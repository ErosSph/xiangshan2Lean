package chicala.lean.frontend

import scala.tools.nsc.Global
import scala.collection.mutable
import chicala.convert.frontend.Scala2Reader
import chicala.lean.ir.{Module => IRModule, Signal => IRSignal, Statement => IRStatement, Expr => IRExpr, Assign => IRAssign, _}

/** Adapter from the reused Chicala source AST, before DependencySort. */
trait LeanAdapter { self: Scala2Reader =>
  val global: Global
  import global._

  def adaptToLean(module: ModuleDef, root: Tree, child: String => IRModule): IRModule = new Adapter(module, root, child).build()

  private class Adapter(module: ModuleDef, root: Tree, child: String => IRModule) {
    private def source(pos: Position): Source = {
      val p = if (pos.isDefined) pos else root.pos
      Source(p.source.file.path, p.line, p.column + 1)
    }
    private var location = source(root.pos)
    private def at(s: MStatement): Unit = {
      val p = statementPosition(s)
      if (p.isDefined) location = source(p)
    }
    private def fail(detail: String): Nothing = throw TranslationError(location, detail)
    private val aliases = mutable.Map.empty[String, ParamExpr]
    private var indexSerial = 0
    private def freshIndex(name: String): String = { indexSerial += 1; name + "__" + indexSerial }
    private val hardwareAliases = mutable.Map.empty[String, IRExpr]
    private val helpers = module.body.collect { case d: SDefDef => d.name.toString -> d }.toMap
    private val nodeDefinitions = module.body.collect { case n: NodeDef => n.name.toString -> n.rhs }.toMap
    private val enumTypes = module.body.collect { case EnumDef(names, tpe) => names.map(_.toString -> tpe) }.flatten.toMap
    private val initializerSemantics: Set[String] = root match {
      case ClassDef(_, _, _, Template(_, _, body)) => body.collect {
        case ValDef(_, n, _, rhs) if (passThrough(rhs)._1 match {
          case Apply(fun, args) =>
            val name = passThrough(fun)._1.toString
            (name == "chisel3.RegInit.apply" && args.size == 1) || (name == "chisel3.util.RegEnable.apply" && args.size == 3)
          case _ => false
        }) => n.toString.trim
      }.toSet
      case _ => Set.empty
    }
    private val parameters = module.vparams.map { p =>
      val kind = p.tpe match { case StInt => "Int"; case StBoolean => "Bool"; case _ => fail("Only Int and Boolean constructor parameters are supported") }
      Parameter(p.name.toString, kind)
    }
    private val parameterNames = parameters.map(_.name).toSet
    private val signals = mutable.ListBuffer.empty[IRSignal]
    private val requirements = mutable.ListBuffer.empty[ParamExpr]
    private var parameterGuard: ParamExpr = PBool(true)
    private def requireParameter(condition: ParamExpr): Unit =
      requirements += ParamSimplify(POp("||", List(POp("!", List(parameterGuard)), condition)))
    private def underParameterGuard[A](guard: ParamExpr)(body: => A): A = {
      val previous = parameterGuard
      parameterGuard = ParamSimplify(POp("&&", List(previous, guard)))
      try body finally { parameterGuard = previous }
    }
    private val memoryWrites = mutable.Map.empty[String, Int]
    private val memoryKinds: Map[String, String] = root match {
      case ClassDef(_, _, _, Template(_, _, body)) => body.collect {
        case ValDef(_, n, tpt, _) if tpt.tpe != null && Set("chisel3.Mem", "chisel3.SyncReadMem")(tpt.tpe.typeSymbol.fullName) => n.toString.trim -> tpt.tpe.typeSymbol.fullName
      }.toMap
      case _ => Map.empty
    }
    private var context: IRExpr = HostBool(PBool(true))
    private def inContext[A](condition: IRExpr)(body: => A): A = {
      val previous = context
      context = Prim("andBool", List(previous, condition))
      try body finally { context = previous }
    }
    private val writePorts = mutable.Map.empty[String, (IRExpr, IRExpr)]
    private val readPorts = mutable.ListBuffer.empty[(String, String, IRExpr, IRExpr, ParamExpr, Source)]

    private def path(tree: Tree): String = tree match {
      case This(_) => ""
      case Ident(n) => n.decodedName.toString.trim
      case Select(from, n) => List(path(from), n.decodedName.toString.trim).filter(_.nonEmpty).mkString(".")
      case _ => fail(s"Unsupported hardware reference ${show(tree)}")
    }
    private def funName(t: STerm): String = t match {
      case SLib(n, _) => n
      case SIdent(n, _) => n.toString
      case SSelect(from: STerm, n, _) => funName(from) + "." + n.decodedName.toString
      case _ => ""
    }
    private def memoryCall(t: MTerm): Option[(String, String, List[MTerm])] = t match {
      case SApply(SSelect(SIdent(n, _), method, _), args, _) if memoryKinds.contains(n.toString) =>
        Some((n.toString, method.decodedName.toString, args))
      case _ => None
    }

    private def parameter(t: MTerm, locals: Map[String, ParamExpr] = Map.empty,
                          stack: Set[String] = Set.empty): ParamExpr = t match {
      case SLiteral(v: Boolean, _) => PBool(v)
      case SLiteral(v: Int, _) => PInt(BigInt(v))
      case SLiteral(v: BigInt, _) => PInt(v)
      case SIdent(n, _) =>
        val name = n.toString
        locals.getOrElse(name, if (parameterNames(name)) PName(name)
          else aliases.getOrElse(name, fail(s"Unknown parameter expression $name")))
      case SIf(c, a, b, _) =>
        val condition = parameter(c, locals, stack)
        PIf(condition, underParameterGuard(condition)(parameter(a, locals, stack)),
          underParameterGuard(POp("!", List(condition)))(parameter(b, locals, stack)))
      case SSelect(from: MTerm, n, _) if Set("unary_-", "unary_!")(n.decodedName.toString) =>
        val op = if (n.decodedName.toString == "unary_-") "neg" else "!"
        POp(op, List(parameter(from, locals, stack)), wrap32 = op == "neg" && from.tpe == StInt)
      case SApply(SSelect(from, method, _), args, tpe) if
          Set("+", "-", "*", "/", "%", "<", "<=", ">", ">=", "==", "!=", "&&", "||")(method.decodedName.toString) =>
        val op = method.decodedName.toString
        if (Set("/", "%")(op)) requireParameter(POp("!=", List(parameter(args.head, locals, stack), PInt(0))))
        POp(op, parameter(from, locals, stack) :: args.map(parameter(_, locals, stack)),
          wrap32 = tpe == StInt && Set("+", "-", "*", "/", "%")(op))
      case SApply(fun, args, _) if Set("scala.Predef.intWrapper", "math.this.BigInt.int2bigInt", "scala.`package`.BigInt.apply")(funName(fun)) =>
        parameter(args.head, locals, stack)
      case SApply(fun, List(arg), _) if funName(fun) == "chisel3.util.log2Ceil.apply" =>
        requireParameter(POp(">=", List(parameter(arg, locals, stack), PInt(0))))
        POp("log2Ceil", List(parameter(arg, locals, stack)))
      case SApply(fun, args, _) if helpers.contains(funName(fun)) =>
        val name = funName(fun)
        if (stack(name)) fail(s"Recursive parameter helper $name is unsupported")
        val d = helpers(name)
        val names = d.vparamss.flatten.map(_.name.toString)
        if (names.size != args.size) fail("Helper argument count mismatch")
        val bindings = names.zip(args.map(parameter(_, locals, stack))).toMap
        paramBody(d.defp, locals ++ bindings, stack + name)
      case _ => fail(s"Unsupported parameter computation: $t")
    }

    private def paramBody(body: MStatement, locals: Map[String, ParamExpr], stack: Set[String]): ParamExpr = body match {
      case SBlock(parts, _) if parts.nonEmpty =>
        var scope = locals
        parts.dropRight(1).foreach {
          case SValDef(n, _, rhs, false) => scope += n.toString -> parameter(rhs, scope, stack)
          case _ => fail("Parameter helper blocks may contain immutable scalar values only")
        }
        paramBody(parts.last, scope, stack)
      case term: MTerm => parameter(term, locals, stack)
      case _ => fail("Unsupported parameter helper body")
    }

    private def known(size: CSize): ParamExpr = size match {
      case KnownSize(term) => parameter(term)
      case _ => fail("Explicit symbolic widths and Vec lengths are required for declared ports/registers/wires")
    }
    private def hwType(t: SignalType, inferred: Boolean = false): HWType = t match {
      case _: Bool => BooleanType
      case UInt(w, _, _) => if (inferred && !w.isInstanceOf[KnownSize]) InferBits(false) else BitsType(known(w))
      case SInt(w, _, _) => if (inferred && !w.isInstanceOf[KnownSize]) InferBits(true) else BitsType(known(w), signed = true)
      case Vec(n, _, elem) =>
        val element = hwType(elem, inferred)
        if (element == InferType || element.isInstanceOf[InferBits]) InferType else VectorType(known(n), element)
      case _: Bundle => fail("Bundle must be flattened before hardware typing")
    }

    private def flatten(name: String, t: SignalType, kind: String, init: Option[MTerm], inferred: Boolean = false): Unit = t match {
      case Bundle(_, fields) =>
        fields.toList.sortBy(_._1.toString).foreach { case (n, v) => flatten(name + "." + n, v, kind, init.map(project(_, n, v)), inferred) }
      case other =>
        val actualKind = if (kind == "io") {
          if (other.isInput) "input" else if (other.isOutput) "output" else fail(s"IO direction missing on $name")
        } else kind
        signals += IRSignal(name, actualKind, hwType(other, inferred), init.map(expression(_)), location)
    }

    private def project(value: MTerm, name: TermName, tpe: SignalType): MTerm = value match {
      case SignalRef(tree, _) => SignalRef(Select(tree, name), tpe)
      case CApply(Mux, _, List(c, a, b)) => CApply(Mux, tpe, List(c, project(a, name, tpe), project(b, name, tpe)))
      case _ => fail("Aggregate values require a Bundle reference or Bundle Mux")
    }

    // Source aliases can still refer to forced-width hardware literals.
    private def forcedInitializer(t: MTerm, seen: Set[String] = Set.empty): Option[HWType] = t match {
      case Lit(_, tpe @ UInt(_: KnownSize, _, _)) => Some(hwType(tpe))
      case Lit(_, tpe @ SInt(_: KnownSize, _, _)) => Some(hwType(tpe))
      case Lit(_, _: Bool) => Some(BooleanType)
      case SignalRef(tree, _) =>
        val name = path(tree)
        if (seen(name)) fail("Recursive literal initializer alias")
        enumTypes.get(name).map(hwType(_)).orElse(nodeDefinitions.get(name).flatMap(forcedInitializer(_, seen + name)))
      case SIf(c, a, b, _) =>
        (forcedInitializer(a, seen), forcedInitializer(b, seen)) match {
          case (Some(BitsType(x, sx)), Some(BitsType(y, sy))) if sx == sy => Some(BitsType(PIf(parameter(c), x, y), sx))
          case (Some(BooleanType), Some(BooleanType)) => Some(BooleanType)
          case (None, None) => None
          case _ => fail("RegInit cannot mix forced and inferred widths across a Scala if initializer")
        }
      case _ => None
    }

    private def sequence(value: MTerm): List[MTerm] = value match {
      case SApply(fun, values, _) if funName(fun).endsWith("Seq.apply") => values
      case _ => fail("Expected a literal Seq")
    }
    private def pair(value: MTerm): (MTerm, MTerm) = value match {
      case STuple(List(k, v), _) => k -> v
      case SApply(SSelect(SApply(fun, List(k), _), arrow, _), List(v), _) if funName(fun) == "scala.Predef.ArrowAssoc" && arrow.decodedName.toString == "->" => k -> v
      case _ => fail("Mux mappings require literal key/value pairs")
    }

    private def literalType(t: GroundType, value: ParamExpr): HWType = t match {
      case _: Bool => BooleanType
      case UInt(KnownSize(w), _, _) => BitsType(parameter(w))
      case SInt(KnownSize(w), _, _) => BitsType(parameter(w), signed = true)
      case _: UInt => value match {
        case PInt(v) if v >= 0 => BitsType(PInt(v.bitLength.max(1)))
        case _ => BitsType(POp("unsignedWidth", List(value)))
      }
      case _: SInt => value match {
        case PInt(v) => BitsType(PInt((if (v >= 0) v.bitLength else (-v - 1).bitLength) + 1), signed = true)
        case _ => BitsType(POp("signedWidth", List(value)), signed = true)
      }
    }

    private def expression(t: MTerm, locals: Map[String, ParamExpr] = Map.empty,
                           stack: Set[String] = Set.empty): IRExpr = t match {
      case term if memoryCall(term).exists(x => Set("apply", "read", "do_apply", "do_read")(x._2)) =>
        val (name, _, args) = memoryCall(term).get
        val address = expression(args.head, locals, stack)
        if (memoryKinds(name) == "chisel3.Mem") {
          if (args.size != 1) fail("Asynchronous Mem reads must have one address and no explicit clock")
          VecGetDynamic(Ref(name), address)
        } else {
          if (args.size != 2) fail("SyncReadMem.read requires address and Bool enable; explicit clocks and read-under-write modes are unsupported")
          val VectorType(size, elem) = signals.find(_.name == name).get.tpe
          val port = "__memory_" + name + "_read_" + readPorts.size
          val enable = Prim("andBool", List(context, expression(args(1), locals, stack)))
          signals += IRSignal(port, "reg", elem, None, location)
          signals += IRSignal(port + "_valid", "reg", BooleanType, None, location)
          readPorts += ((name, port, address, enable, size, location))
          Checked(Ref(port), Ref(port + "_valid"))
        }
      case SignalRef(tree, _) => hardwareAliases.getOrElse(path(tree), Ref(path(tree)))
      case Lit(v, tpe) =>
        val value = parameter(v, locals)
        chicala.lean.ir.Lit(value, literalType(tpe, value))
      case CApply(op, _, operands) =>
        val name = op.toString
        val basic = Map("Add" -> "add", "Minus" -> "sub", "Multiply" -> "mul", "AddWide" -> "addWide", "MinusWide" -> "subWide",
          "And" -> "and", "Or" -> "or", "Xor" -> "xor", "Equal" -> "eq", "NotEqual" -> "ne", "GreaterEq" -> "ge",
          "Less" -> "lt", "LessEq" -> "le", "Greater" -> "gt", "LogiNot" -> "notBool", "LogiAnd" -> "andBool", "LogiOr" -> "orBool",
          "Not" -> "not", "Negative" -> "neg", "AsUInt" -> "asUInt", "AsSInt" -> "asSInt", "AsBool" -> "asBool",
          "Cat" -> "cat", "OrReduce" -> "orR", "AndReduce" -> "andR", "XorReduce" -> "xorR",
          "Divide" -> "div", "Remainder" -> "rem")
        name match {
          case "Mux" => Choose(expression(operands.head, locals, stack), expression(operands(1), locals, stack), expression(operands(2), locals, stack))
          case "VecSelect" =>
            if (operands(1).tpe.isInstanceOf[SignalType]) VecGetDynamic(expression(operands.head, locals, stack), expression(operands(1), locals, stack))
            else VecGet(expression(operands.head, locals, stack), parameter(operands(1), locals))
          case "Slice" =>
            if (operands.size == 2 && operands(1).tpe.isInstanceOf[SignalType])
              Prim("bit", List(Prim("shr", operands.map(expression(_, locals, stack)))), List(PInt(0)))
            else {
              val indices = operands.tail.map(parameter(_, locals))
              Prim(if (indices.size == 1) "bit" else "slice", List(expression(operands.head, locals, stack)), indices)
            }
          case "LShift" | "RShift" =>
            if (operands(1).tpe.isInstanceOf[SType])
              Prim(if (name == "LShift") "shl" else "shr", List(expression(operands.head, locals, stack)), List(parameter(operands(1), locals)))
            else Prim(if (name == "LShift") "shl" else "shr", operands.map(expression(_, locals, stack)))
          case "Pad" | "Head" | "Tail" => Prim(name.toLowerCase, List(expression(operands.head, locals, stack)), List(parameter(operands(1), locals)))
          case "Fill" => Prim("fill", List(expression(operands(1), locals, stack)), List(parameter(operands.head, locals)))
          case "MakeVec" => operands match {
            case List(SApply(SApply(fun, List(n), _), List(value), _)) if funName(fun).endsWith("Seq.fill") =>
              val size = parameter(n, locals)
              requireParameter(POp(">", List(size, PInt(0))))
              VecMap(freshIndex("__fill"), size, expression(value, locals, stack))
            case List(SApply(SApply(fun, List(n), _), List(SFunction(List(i), body: MTerm)), _)) if funName(fun).endsWith("Seq.tabulate") =>
              val index = freshIndex(i.name.toString)
              val size = parameter(n, locals)
              requireParameter(POp(">", List(size, PInt(0))))
              VecMap(index, size, expression(body, locals + (i.name.toString -> PName(index)), stack))
            case List(value) if value.tpe.isInstanceOf[StSeq] => VecValues(sequence(value).map(expression(_, locals, stack)))
            case values => VecValues(values.map(expression(_, locals, stack)))
          }
          case "MuxLookup" =>
            val entries = sequence(operands(2)).map(pair)
            Prim("muxLookup", List(expression(operands.head, locals, stack), expression(operands(1), locals, stack)) ++
              entries.flatMap { case (k, v) => List(expression(k, locals, stack), expression(v, locals, stack)) })
          case "MuxCase" | "PriorityMux" =>
            val entries = sequence(operands.last).map(pair)
            if (name == "PriorityMux" && (operands.size != 1 || entries.isEmpty)) fail("PriorityMux requires a nonempty Seq of Bool/value pairs")
            val initial = if (name == "MuxCase") expression(operands.head, locals, stack) else expression(entries.last._2, locals, stack)
            val choices = if (name == "MuxCase") entries else entries.dropRight(1)
            choices.foldRight(initial) { case ((c, v), tail) => Choose(expression(c, locals, stack), expression(v, locals, stack), tail) }
          case other => Prim(basic.getOrElse(other, fail(s"Unsupported Chisel operation $other")), operands.map(expression(_, locals, stack)))
        }
      case SIf(c, a, b, _) =>
        val condition = parameter(c, locals)
        Choose(HostBool(condition), underParameterGuard(condition)(expression(a, locals, stack)),
          underParameterGuard(POp("!", List(condition)))(expression(b, locals, stack)))
      case SApply(fun, args, _) if helpers.contains(funName(fun)) =>
        val name = funName(fun)
        if (stack(name)) fail("Recursive hardware helpers are unsupported")
        val d = helpers(name)
        val bindings = d.vparamss.flatten.map(_.name.toString).zip(args).toMap
        val ps = bindings.collect { case (k, v) if v.tpe.isInstanceOf[SType] => k -> parameter(v, locals) }
        val hs = bindings.collect { case (k, v) if v.tpe.isInstanceOf[SignalType] => k -> expression(v, locals, stack) }
        val saved = hardwareAliases.toMap
        hardwareAliases ++= hs
        def inline(body: MStatement): IRExpr = body match {
          case SBlock(parts, _) if parts.nonEmpty =>
            parts.dropRight(1).foreach {
              case n: NodeDef if !n.isVar => hardwareAliases(n.name.toString) = expression(n.rhs, locals ++ ps, stack + name)
              case _ => fail("Hardware helper blocks may contain immutable hardware values only")
            }
            inline(parts.last)
          case term: MTerm => expression(term, locals ++ ps, stack + name)
          case _ => fail("Hardware helpers must return a pure expression")
        }
        try inline(d.defp) finally { hardwareAliases.clear(); hardwareAliases ++= saved }
      case _ if t.tpe == StBoolean => HostBool(parameter(t, locals))
      case _ => fail(s"Unsupported hardware expression: $t")
    }

    private def target(t: MTerm, locals: Map[String, ParamExpr]): (String, Option[ParamExpr]) = t match {
      case SignalRef(tree, _) => path(tree) -> None
      case CApply(VecSelect, _, List(SignalRef(tree, _), index)) => path(tree) -> Some(parameter(index, locals))
      case _ => fail("Connections require a whole signal or a Vec element")
    }

    private def statements(s: MStatement, locals: Map[String, ParamExpr] = Map.empty,
                           nested: Boolean = false): List[IRStatement] = {
      at(s)
      s match {
        case SBlock(body, _) =>
          val saved = hardwareAliases.toMap
          val savedHost = aliases.toMap
          try body.flatMap(statements(_, locals, nested)) finally {
            hardwareAliases.clear(); hardwareAliases ++= saved
            aliases.clear(); aliases ++= savedHost
          }
        case Connect(left, rhs) if memoryCall(left).nonEmpty =>
          val (name, _, args) = memoryCall(left).get
          if (args.size != 1) fail("Memory write requires one address")
          memoryWrites(name) = memoryWrites.getOrElse(name, 0) + 1
          if (memoryWrites(name) > 1) fail("Multiple Mem write ports require an explicit collision model")
          writePorts(name) = expression(args.head, locals) -> context
          List(DynamicAssign(name, expression(args.head, locals), expression(rhs, locals), location))
        case term: MTerm if memoryCall(term).exists(x => Set("write", "do_write")(x._2)) =>
          val (name, _, args) = memoryCall(term).get
          if (args.size != 2) fail("Mem.write requires address and data; masked or explicit-clock writes are unsupported")
          memoryWrites(name) = memoryWrites.getOrElse(name, 0) + 1
          if (memoryWrites(name) > 1) fail("Multiple Mem write ports require an explicit collision model")
          writePorts(name) = expression(args.head, locals) -> context
          List(DynamicAssign(name, expression(args.head, locals), expression(args(1), locals), location))
        case Connect(CApply(VecSelect, _, List(SignalRef(tree, _), index)), rhs) if index.tpe.isInstanceOf[SignalType] =>
          List(DynamicAssign(path(tree), expression(index, locals), expression(rhs, locals), location))
        case Connect(left, rhs) =>
          if (left.tpe.isInstanceOf[Bundle]) {
            val expanded = Connect(left, rhs).expands
            if (expanded.size == 1 && expanded.head.left == left) fail("Bundle assignment requires a compatible Bundle reference")
            expanded.flatMap(statements(_, locals, nested))
          } else {
            val (name, index) = target(left, locals)
            List(IRAssign(name, index, expression(rhs, locals), location))
          }
        case When(c, yes, no, _) =>
          val condition = expression(c, locals)
          val yesBody = inContext(condition)(statements(yes, locals, nested = true))
          val noBody = inContext(Prim("notBool", List(condition)))(statements(no, locals, nested = true))
          List(Branch(condition, yesBody, noBody, location))
        case SIf(c, yes, no, _) =>
          val param = parameter(c, locals)
          val condition = HostBool(param)
          val yesBody = underParameterGuard(param)(inContext(condition)(statements(yes, locals, nested = true)))
          val noBody = underParameterGuard(POp("!", List(param)))(inContext(Prim("notBool", List(condition)))(statements(no, locals, nested = true)))
          List(Branch(condition, yesBody, noBody, location))
        case SApply(fun, args, _) if funName(fun) == "scala.Predef.require" =>
          requireParameter(parameter(args.head, locals))
          Nil
        case SApply(SSelect(range, name, _), List(SFunction(vparams, body)), _) if name.toString == "foreach" =>
          range match {
            case SApply(SSelect(start, until, _), List(end), _) if until.toString == "until" && vparams.size == 1 =>
              val original = vparams.head.name.toString
              val i = freshIndex(original)
              val from = parameter(start, locals)
              val to = parameter(end, locals)
              List(Generate(i, from, to, statements(body, locals + (original -> PName(i)), nested = true), location))
            case _ => fail("Generate loops must have form: for (i <- 0 until size)")
          }
        case io: IoDef =>
          if (nested) fail("Conditional IO declarations are outside the initial support subset")
          flatten(io.name.toString, io.tpe, "io", None)
          Nil
        case r: RegDef =>
          if (nested) fail("Conditional register declarations are outside the initial support subset")
          flatten(r.name.toString, r.tpe, "reg", r.someInit, inferred = true)
          if (initializerSemantics(r.name.toString) && signals.last.tpe.isInstanceOf[InferBits]) {
            r.someInit.flatMap(forcedInitializer(_)).foreach { tpe =>
              val index = signals.size - 1
              signals(index) = signals(index).copy(tpe = tpe)
            }
          }
          r.someNext.toList.flatMap(v => statements(Connect(SignalRef(Select(This(module.name), r.name), r.tpe), v), locals, nested))
        case w: WireDef =>
          if (nested || w.isVar) fail("Conditional or mutable wire declarations are unsupported")
          flatten(w.name.toString, w.tpe, "wire", w.someInit, inferred = true)
          Nil
        case n: NodeDef =>
          if (n.isVar) fail("Mutable hardware values are unsupported")
          if (nested) hardwareAliases(n.name.toString) = expression(n.rhs, locals)
          else flatten(n.name.toString, n.tpe, "node", Some(n.rhs), inferred = true)
          Nil
        case SValDef(name, _, rhs, false) if rhs != EmptyMTerm =>
          // Validate unused host computations too, so side effects cannot disappear.
          aliases(name.toString) = parameter(rhs, locals)
          Nil
        case _: SDefDef => Nil
        case EnumDef(names, tpe) =>
          names.zipWithIndex.foreach { case (n, i) => hardwareAliases(n.toString) = expression(Lit(SLiteral(i, StInt), tpe), locals) }
          Nil
        case Switch(cond, branches) =>
          val seen = mutable.ListBuffer.empty[ParamExpr]
          branches.flatMap { case (values, body) =>
            val cases = if (values.tpe.isInstanceOf[StSeq]) sequence(values) else List(values)
            val tests = cases.map { v =>
              val value = expression(v, locals)
              val key = value match { case chicala.lean.ir.Lit(k, _) => k; case _ => fail("switch cases must be hardware literals or Enum constants") }
              seen.foreach(k => requirements += POp("!=", List(k, key)))
              seen += key
              Prim("eq", List(expression(cond, locals), value))
            }
            val test = tests.reduce[IRExpr]((a, b) => Prim("orBool", List(a, b)))
            List(Branch(test, statements(body, locals, nested = true), Nil, location))
          }
        case SLiteral(v, _) if v == () => Nil
        case EmptyMTerm => Nil
        case s: SubModuleDef =>
          if (nested) fail("Modules instantiated conditionally or inside a generate loop need a dependent instance layout")
          val definition = child(s.tpe.fullName.stripPrefix("."))
          if (definition.parameters.size != s.args.size) fail("Submodule constructor argument count mismatch")
          val bindings = definition.parameters.map(_.name).zip(s.args.map(parameter(_, locals))).toMap
          val instance = Instantiate(definition, s.name.toString, bindings)
          signals ++= instance.signals
          requirements ++= instance.requirements
          instance.statements
        case _ => fail(s"Unsupported hardware statement: $s")
      }
    }

    def build(): IRModule = {
      root match {
        case ClassDef(_, _, _, Template(_, _, body)) =>
          if (body.count { case DefDef(_, n, _, _, _, _) => n == termNames.CONSTRUCTOR; case _ => false } != 1)
            fail("Auxiliary constructors are outside the supported generator subset")
          if (body.exists { case ValDef(mods, _, _, _) => mods.isParamAccessor && mods.isMutable; case _ => false })
            fail("Mutable constructor parameters are unsupported")
        case _ =>
      }
      val body = module.body.flatMap(statements(_))
      memoryKinds.keys.foreach { name =>
        val VectorType(size, _) = signals.find(_.name == name).get.tpe
        requireParameter(POp(">", List(size, PInt(0))))
      }
      val memorySteps = readPorts.toList.flatMap { case (memory, port, address, enable, size, src) =>
        val collision = writePorts.get(memory).map { case (writeAddress, writeEnable) =>
          Prim("andBool", List(writeEnable, Prim("sameVecIndex", List(address, writeAddress), List(size))))
        }.getOrElse(HostBool(PBool(false)))
        List(IRAssign(port, None, Choose(enable, VecGetDynamic(Ref(memory), address), Ref(port)), src),
          IRAssign(port + "_valid", None, Prim("andBool", List(enable, Prim("notBool", List(collision)))), src))
      }
      if (signals.exists(_.kind == "reg") && !root.symbol.asClass.baseClasses.exists(_.fullName == "chisel3.Module"))
        fail("Clocked state requires the implicit clock of Module; explicit RawModule clocks are unsupported")
      IRModule(module.fullName.stripPrefix("."), parameters, requirements.toList, signals.toList, body ++ memorySteps, source(root.pos))
    }
  }
}
