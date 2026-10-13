package chicala.lean.firrtl

import scala.collection.mutable
import firrtl.{ir => F}
import chicala.lean.{ir => L}

/** Consume official, width-resolved Low FIRRTL, retaining observable circuit semantics.
  * Clocks are checked as a single domain. Reset is an ordinary input: synchronous
  * register reset muxes belong to next-state expressions, not an invented initial state.
  */
object FirrtlAdapter {
  def apply(circuit: F.Circuit, namespace: String, file: String): L.Module =
    new Adapter(circuit, namespace, file).build()

  private final class Adapter(circuit: F.Circuit, namespace: String, file: String) {
    private val definitions = circuit.modules.map(m => m.name -> m).toMap
    private val signals = mutable.ListBuffer.empty[L.Signal]
    private val statements = mutable.ListBuffer.empty[L.Statement]
    private val registers = mutable.ListBuffer.empty[(String, String, F.DefRegister, String)]
    private val clockDrivers = mutable.Map.empty[String, (F.Expression, String)]
    private val clocks = mutable.Set.empty[String]
    private val reserved = mutable.Set.empty[String]
    private var location = L.Source(file, 1, 1)

    private def source(info: F.Info): L.Source = {
      val pattern = "([^\\s\\[\\]@]+)\\s+(\\d+):(\\d+)".r
      pattern.findFirstMatchIn(info.serialize).map(m =>
        L.Source(m.group(1), m.group(2).toInt, m.group(3).toInt)).getOrElse(L.Source(file, 1, 1))
    }
    private def fail(detail: String): Nothing = throw L.TranslationError(location, "FIRRTL: " + detail)
    private def name(prefix: String, local: String): String = if (prefix.isEmpty) local else prefix + "." + local
    private def reference(e: F.Expression, prefix: String): String = e match {
      case F.Reference(n, _, _, _) => name(prefix, n)
      case F.SubField(parent, field, _, _) => reference(parent, prefix) + "." + field
      case other => fail("Expected a scalar reference, got " + other.serialize)
    }
    private def hw(t: F.Type): L.HWType = t match {
      case F.UIntType(F.IntWidth(w)) => L.BitsType(L.PInt(w))
      case F.SIntType(F.IntWidth(w)) if w > 0 => L.BitsType(L.PInt(w), signed = true)
      case F.AsyncResetType => fail("Asynchronous reset is unsupported")
      case other => fail("Unsupported or unresolved type " + other.serialize)
    }
    private def width(t: F.Type): BigInt = t match {
      case F.UIntType(F.IntWidth(w)) => w
      case F.SIntType(F.IntWidth(w)) => w
      case _ => fail("Expected a known integer width")
    }
    private def bool(e: F.Expression, prefix: String): L.Expr = {
      if (e.tpe != F.UIntType(F.IntWidth(1))) fail("Condition must be UInt<1>")
      L.Resize(expression(e, prefix), L.BooleanType)
    }
    private def expression(e: F.Expression, prefix: String): L.Expr = {
      val value: L.Expr = e match {
        case _: F.Reference | _: F.SubField => L.Ref(reference(e, prefix))
        case F.UIntLiteral(v, w) => L.Lit(L.PInt(v), hw(F.UIntType(w)))
        case F.SIntLiteral(v, w) => L.Lit(L.PInt(v), hw(F.SIntType(w)))
        case F.Mux(c, a, b, _) => L.Choose(bool(c, prefix), expression(a, prefix), expression(b, prefix))
        case F.ValidIf(c, v, _) => L.Checked(expression(v, prefix), bool(c, prefix))
        case F.DoPrim(op, args, consts, tpe) =>
          val values = args.toList.map(expression(_, prefix))
          val params = consts.toList.map(L.PInt)
          def prim(n: String, vs: List[L.Expr] = values, ps: List[L.ParamExpr] = params): L.Expr = L.Prim(n, vs, ps)
          op.toString match {
            // FIRRTL add/sub retain the carry bit; Chisel '+' inserts its own tail.
            case "add" => prim("addWide")
            case "sub" => prim("subWide")
            case "mul" | "div" | "rem" | "eq" | "lt" | "gt" => prim(op.toString)
            case "neq" => prim("ne")
            case "leq" => prim("le")
            case "geq" => prim("ge")
            case "dshl" => prim("shl")
            case "dshr" => prim("shr")
            case "shl" | "shr" | "pad" | "head" | "tail" | "cat" | "asUInt" | "asSInt" => prim(op.toString)
            case "bits" => prim("slice")
            case "andr" => prim("andR")
            case "orr" => prim("orR")
            case "xorr" => prim("xorR")
            case "neg" =>
              // Negation must happen AFTER widening, particularly for MIN_SIGNED.
              val widened = L.Resize(values.head, L.BitsType(L.PInt(width(tpe)), args.head.tpe.isInstanceOf[F.SIntType]))
              prim("neg", List(L.Prim("asSInt", List(widened))), Nil)
            case "cvt" => L.Resize(values.head, hw(tpe))
            case "not" => prim("not", List(L.Prim("asUInt", values)), Nil)
            case "and" | "or" | "xor" =>
              // FIRRTL bitwise results are UInt, including operations on SInt.
              val extended = args.toList.zip(values).map { case (arg, v) =>
                L.Prim("asUInt", List(L.Resize(v, L.BitsType(L.PInt(width(tpe)), arg.tpe.isInstanceOf[F.SIntType]))))
              }
              prim(op.toString, extended, Nil)
            case other => fail("Unsupported primitive " + other)
          }
        case other => fail("Unsupported expression " + other.serialize)
      }
      L.Resize(value, hw(e.tpe))
    }
    private def fresh(base: String): String = {
      var result = base
      while (reserved(result)) result += "_"
      reserved += result
      result
    }
    private def body(module: F.Module, prefix: String, top: Boolean, stack: Set[String]): Unit = {
      if (stack(module.name)) fail("Recursive module instantiation " + module.name)
      module.ports.foreach { p =>
        location = source(p.info)
        val n = name(prefix, p.name)
        reserved += n
        if (p.tpe == F.ClockType) {
          if (top) {
            if (p.direction != F.Input) fail("Output clocks are unsupported")
            clocks += n
          }
        } else {
          val kind = if (!top) "wire" else if (p.direction == F.Input) "input" else "output"
          signals += L.Signal(n, kind, hw(p.tpe), None, location)
        }
      }
      def reserve(s: F.Statement): Unit = {
        s match { case d: F.IsDeclaration => reserved += name(prefix, d.name); case _ => }
        s.foreachStmt(reserve)
      }
      reserve(module.body)
      val nextWires = mutable.Map.empty[String, String]
      def declarations(s: F.Statement): Unit = {
        s.foreachInfo(info => location = source(info))
        s match {
          case F.Block(xs) => xs.foreach(declarations)
          case r: F.DefRegister =>
            val n = name(prefix, r.name)
            val next = fresh(n + "$NEXT")
            nextWires(n) = next
            signals += L.Signal(n, "reg", hw(r.tpe), None, location)
            signals += L.Signal(next, "wire", hw(r.tpe), Some(L.Ref(n)), location)
            registers += ((n, next, r, prefix))
          case w: F.DefWire if w.tpe != F.ClockType => signals += L.Signal(name(prefix, w.name), "wire", hw(w.tpe), None, location)
          case n: F.DefNode if n.value.tpe != F.ClockType =>
            signals += L.Signal(name(prefix, n.name), "wire", hw(n.value.tpe), Some(expression(n.value, prefix)), location)
          case i: F.DefInstance => definitions.get(i.module) match {
            case Some(child: F.Module) => body(child, name(prefix, i.name), top = false, stack + module.name)
            case Some(_: F.ExtModule) => fail("BlackBox/ExtModule " + i.module + " requires an explicit semantics model")
            case _ => fail("Unknown module " + i.module)
          }
          case _: F.DefMemory => fail("Memory ports/latencies are not supported by the FIRRTL frontend yet")
          case _: F.Connect | F.EmptyStmt =>
          case w: F.DefWire if w.tpe == F.ClockType =>
          case n: F.DefNode if n.value.tpe == F.ClockType => clockDrivers(name(prefix, n.name)) = (n.value, prefix)
          case other => fail("Unsupported statement " + other.serialize.take(200))
        }
      }
      declarations(module.body)
      def connects(s: F.Statement): Unit = {
        s.foreachInfo(info => location = source(info))
        s match {
          case F.Block(xs) => xs.foreach(connects)
          case F.Connect(_, loc, rhs) if loc.tpe == F.ClockType => clockDrivers(reference(loc, prefix)) = (rhs, prefix)
          case F.Connect(_, loc, rhs) =>
            val n = reference(loc, prefix)
            statements += L.Assign(nextWires.getOrElse(n, n), None, expression(rhs, prefix), location)
          case _ =>
        }
      }
      connects(module.body)
    }
    def build(): L.Module = {
      val main = definitions.get(circuit.main) match {
        case Some(m: F.Module) => m
        case _ => fail("Main module must be a concrete module")
      }
      body(main, "", top = true, Set.empty)
      if (clocks.size > 1) fail("Multiple top-level clock inputs are unsupported")
      def clockRoot(e: F.Expression, prefix: String, seen: Set[String]): String = {
        val n = reference(e, prefix)
        if (clocks(n)) n
        else if (seen(n)) fail("Clock connection cycle " + n)
        else clockDrivers.get(n) match {
          case Some((driver, scope)) => clockRoot(driver, scope, seen + n)
          case None => fail("Unsupported or unconnected clock " + n)
        }
      }
      registers.foreach { case (n, next, r, scope) =>
        location = source(r.info)
        clockRoot(r.clock, scope, Set.empty)
        val value = r.reset match {
          case F.UIntLiteral(v, _) if v == 0 => L.Ref(next)
          case _ => L.Choose(bool(r.reset, scope), expression(r.init, scope), L.Ref(next))
        }
        statements += L.Assign(n, None, value, location)
      }
      L.Module(namespace, Nil, Nil, signals.toList, statements.toList, source(main.info))
    }
  }
}
