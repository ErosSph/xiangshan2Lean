package chicala.lean.firrtl

import java.nio.charset.StandardCharsets
import java.nio.file.{Files, Paths}
import scala.collection.mutable
import firrtl.{ir => F, PrimOps}
import chicala.lean.ir.{Normalize, Source, TranslationError}
import chicala.lean.backend.Json
import org.json4s._
import org.json4s.native.JsonMethods.parse

/** Import official CIRCT's fully lowered, typed, scalar SSA operations.
  * SSA identities (not optional name hints) identify values. The existing
  * FIRRTL adapter supplies the common IR, operation semantics and clock checks.
  * No classic parsing/width inference/lowering is applied to modern source text.
  */
object CirctMain {
  private final case class Value(value: JValue) {
    def apply(key: String): Value = obj.getOrElse(key, throw new IllegalArgumentException("Missing bridge field " + key))
    def str: String = value match { case JString(s) => s; case _ => throw new IllegalArgumentException("Expected JSON string") }
    def num: BigInt = value match { case JInt(n) => n; case _ => throw new IllegalArgumentException("Expected JSON integer") }
    def bool: Boolean = value match { case JBool(b) => b; case _ => throw new IllegalArgumentException("Expected JSON Boolean") }
    def arr: List[Value] = value match { case JArray(xs) => xs.map(Value); case _ => throw new IllegalArgumentException("Expected JSON array") }
    def obj: Map[String, Value] = value match {
      case JObject(xs) => xs.map { case (k, v) => k -> Value(v) }.toMap
      case _ => throw new IllegalArgumentException("Expected JSON object")
    }
  }
  private def source(v: Value): Source = {
    val s = v("source")
    Source(s("file").str, s("line").num.toInt, s("column").num.toInt)
  }
  private def fail(v: Value, text: String): Nothing =
    throw TranslationError(source(v), "CIRCT: " + text)
  private def info(v: Value): F.Info = {
    val s = source(v)
    F.FileInfo(F.StringLit(s.file + " " + s.line + ":" + s.column))
  }
  private def hw(text: String, op: Value): F.Type = text match {
    case "!firrtl.clock" => F.ClockType
    case "!firrtl.asyncreset" => fail(op, "Asynchronous reset is unsupported")
    case x if x.matches("!firrtl.uint<\\d+>") => F.UIntType(F.IntWidth(BigInt(x.drop(13).dropRight(1))))
    case x if x.matches("!firrtl.sint<\\d+>") => F.SIntType(F.IntWidth(BigInt(x.drop(13).dropRight(1))))
    case other => fail(op, "Unsupported or unresolved scalar type " + other)
  }
  private def attrs(op: Value) = op("attributes").obj
  private def regions(op: Value) = op("regions").arr
  private def strings(v: Value): List[String] = v.arr.toList.map(_.str)
  private def internal(id: String): String = "c2lSSA" + id.drop(1).replace("#", "_")

  private def module(m: Value, definitions: Map[String, Value]): F.Module = {
    if (m("name").str != "firrtl.module") fail(m, "Top/child must be a concrete module")
    val a = attrs(m)
    if (regions(m).size != 1) fail(m, "Expected one module region")
    val block = regions(m).head
    val names = strings(a("portNames"))
    val types = strings(a("portTypes")).map(hw(_, m))
    val directions = a("portDirections").arr.toList.map(_.bool)
    val arguments = block("arguments").arr.toList
    if (List(types.size, directions.size, arguments.size).exists(_ != names.size) || names.distinct.size != names.size)
      fail(m, "Invalid module port signature")
    val refs = mutable.Map.empty[String, F.Expression]
    val body = mutable.ListBuffer.empty[F.Statement]
    val occupied = mutable.Set.empty[String] ++ names
    def fresh(base: String): String = {
      var name = base
      while (occupied(name)) name += "_"
      occupied += name
      name
    }
    def define(id: String, value: F.Expression, op: Value): Unit = {
      if (refs.contains(id)) fail(op, "Duplicate SSA definition " + id)
      refs(id) = value
    }
    val ports = names.indices.map { i =>
      if (hw(arguments(i)("type").str, m) != types(i)) fail(m, "Block argument/port type mismatch")
      define(arguments(i)("name").str, F.Reference(names(i), types(i)), m)
      F.Port(info(m), names(i), if (directions(i)) F.Output else F.Input, types(i))
    }
    block("operations").arr.foreach { op =>
      if (regions(op).nonEmpty) fail(op, "Unlowered region operation " + op("name").str)
      val name = op("name").str
      val ids = strings(op("results"))
      val ts = strings(op("result_types")).map(hw(_, op))
      val args = strings(op("operands")).map(id => refs.getOrElse(id, fail(op, "Undefined SSA operand " + id)))
      val inputTypes = strings(op("input_types")).map(hw(_, op))
      if (args.size != inputTypes.size || args.zip(inputTypes).exists { case (e, t) => e.tpe != t })
        fail(op, "SSA operand type mismatch")
      if (ids.size != ts.size) fail(op, "SSA result type mismatch")
      def scalar: (String, F.Type) = {
        if (ids.size != 1) fail(op, "Expected one result for " + name)
        (fresh(internal(ids.head)), ts.head)
      }
      def arity(n: Int): Unit = if (args.size != n) fail(op, "Wrong operand count for " + name)
      def integer(key: String): BigInt = BigInt(attrs(op)(key)("integer").str)
      def node(value: F.Expression): Unit = {
        val (n, t) = scalar
        if (value.tpe != t) fail(op, "Result type mismatch for " + name)
        body += F.DefNode(info(op), n, value)
        define(ids.head, F.Reference(n, t), op)
      }
      name match {
        case "firrtl.instance" =>
          val target = attrs(op)("moduleName")("symbol").str
          val child = definitions.getOrElse(target, fail(op, "Unknown module " + target))
          if (child("name").str != "firrtl.module") fail(op, "BlackBox/ExtModule requires explicit semantics: " + target)
          val ca = attrs(child)
          val childNames = strings(ca("portNames"))
          val childTypes = strings(ca("portTypes")).map(hw(_, op))
          if (ts != childTypes || strings(attrs(op)("portNames")) != childNames || args.nonEmpty)
            fail(op, "Instance/module signature mismatch")
          val ds = ca("portDirections").arr.toList.map(_.bool)
          if (attrs(op)("portDirections").arr.toList.map(_.bool) != ds)
            fail(op, "Instance port direction mismatch")
          val fields = childNames.indices.map(i => F.Field(childNames(i), if (ds(i)) F.Default else F.Flip, ts(i)))
          val tpe = F.BundleType(fields)
          val instance = fresh("c2lInstance" + body.size)
          body += F.DefInstance(info(op), instance, target, tpe)
          ids.indices.foreach(i => define(ids(i), F.SubField(F.Reference(instance, tpe), childNames(i), ts(i)), op))
        case "firrtl.connect" | "firrtl.matchingconnect" =>
          arity(2)
          if (ids.nonEmpty) fail(op, "Connect may not produce a result")
          body += F.Connect(info(op), args.head, args(1))
        case "firrtl.wire" =>
          arity(0)
          val (n, t) = scalar
          body += F.DefWire(info(op), n, t)
          define(ids.head, F.Reference(n, t), op)
        case "firrtl.node" => arity(1); node(args.head)
        case "firrtl.reg" | "firrtl.regreset" =>
          arity(if (name == "firrtl.reg") 1 else 3)
          val (n, t) = scalar
          if (args.head.tpe != F.ClockType) fail(op, "Register clock must have Clock type")
          val ref = F.Reference(n, t)
          val reset = if (args.size == 1) F.UIntLiteral(0, F.IntWidth(1)) else args(1)
          val init = if (args.size == 1) ref else args(2)
          if (init.tpe != t) fail(op, "Register reset value type mismatch")
          body += F.DefRegister(info(op), n, t, args.head, reset, init)
          define(ids.head, ref, op)
        case "firrtl.constant" =>
          arity(0)
          if (ts.size != 1) fail(op, "Constant must have one result")
          val raw = integer("value")
          val (width, signed) = ts.head match {
            case F.UIntType(F.IntWidth(w)) => (w, false)
            case F.SIntType(F.IntWidth(w)) => (w, true)
            case _ => fail(op, "Constant must have integer type")
          }
          if (!width.isValidInt || width > 1000000) fail(op, "Constant width exceeds supported resource bounds")
          if (signed && width == 0) fail(op, "Signed zero-width constants are unsupported")
          val modulus = BigInt(1) << width.toInt
          val bits = raw.mod(modulus)
          node(if (signed) F.SIntLiteral(if (bits.testBit(width.toInt - 1)) bits - modulus else bits, F.IntWidth(width))
               else F.UIntLiteral(bits, F.IntWidth(width)))
        case "firrtl.invalidvalue" =>
          arity(0)
          val zero = ts.head match {
            case F.UIntType(w) => F.UIntLiteral(0, w)
            case F.SIntType(w) => F.SIntLiteral(0, w)
            case _ => fail(op, "Unsupported invalid value type")
          }
          node(F.ValidIf(F.UIntLiteral(0, F.IntWidth(1)), zero, ts.head))
        case "firrtl.mux" => arity(3); node(F.Mux(args.head, args(1), args(2), ts.head))
        case "firrtl.multibit_mux" =>
          if (args.size < 2 || ts.size != 1) fail(op, "Multibit mux requires an index and data")
          val width = args.head.tpe match {
            case F.UIntType(F.IntWidth(w)) if w.isValidInt => w.toInt
            case _ => fail(op, "Multibit mux index must be a known UInt")
          }
          // CIRCT lists data in descending index order: index 0 selects LAST.
          val values = args.tail.reverse
          if (width > 30 || BigInt(values.size) > (BigInt(1) << width))
            fail(op, "Multibit mux index/data count exceeds supported bounds")
          val bit = F.UIntType(F.IntWidth(1))
          val selected = values.zipWithIndex.dropRight(1).foldRight(values.last) {
            case ((value, index), otherwise) =>
              val equal = F.DoPrim(PrimOps.Eq, List(args.head, F.UIntLiteral(index, F.IntWidth(width))), Nil, bit)
              F.Mux(equal, value, otherwise, ts.head)
          }
          // Preserve out-of-range definedness instead of inventing a default.
          val result = if (BigInt(values.size) == (BigInt(1) << width)) selected else {
            val bound = F.UIntLiteral(values.size, F.IntWidth(BigInt(values.size).bitLength))
            val valid = F.DoPrim(PrimOps.Lt, List(args.head, bound), Nil, bit)
            F.ValidIf(valid, selected, ts.head)
          }
          node(result)
        case operation if operation.startsWith("firrtl.") =>
          val primitive = operation.stripPrefix("firrtl.")
          val allowed = Set("add", "sub", "mul", "div", "rem", "lt", "leq", "gt", "geq", "eq", "neq",
            "and", "or", "xor", "not", "neg", "andr", "orr", "xorr", "asUInt", "asSInt", "cvt",
            "cat", "bits", "head", "tail", "pad", "shl", "shr", "dshl", "dshr", "dshlw")
          if (!allowed(primitive)) fail(op, "Unsupported operation " + operation)
          val constants = primitive match {
            case "bits" => Seq(integer("hi"), integer("lo"))
            case "head" | "tail" | "pad" | "shl" | "shr" => Seq(integer("amount"))
            case _ => Nil
          }
          val classic = if (primitive == "dshlw") "dshl" else primitive
          node(F.DoPrim(PrimOps.fromString(classic), args, constants, ts.head))
        case other => fail(op, "Unsupported operation " + other)
      }
    }
    F.Module(info(m), a("sym_name").str, ports, F.Block(body.toList))
  }

  def main(args: Array[String]): Unit = try {
    require(args.length == 4, "Usage: CirctMain <circt.json> <out> <namespace> <source.fir>")
    val payload = Value(parse(Files.readString(Paths.get(args(0)))))
    require(payload("format").str == "chisel2lean-circt-ssa-v1", "Unsupported CIRCT bridge format")
    val c = payload("circuit")
    val namespace = args(2)
    require(namespace.split('.').forall(_.matches("[a-zA-Z_][a-zA-Z0-9_]*")), "Invalid Lean namespace")
    val declarations = regions(c).head("operations").arr.toList
    val definitions = declarations.filter(o => Set("firrtl.module", "firrtl.extmodule", "firrtl.intmodule")(o("name").str))
      .map(o => attrs(o)("sym_name").str -> o).toMap
    val visited = mutable.Set.empty[String]
    val reachable = mutable.ListBuffer.empty[F.Module]
    def visit(name: String): Unit = if (!visited(name)) {
      visited += name
      val m = definitions.getOrElse(name, fail(c, "Unknown module " + name))
      val imported = module(m, definitions)
      reachable += imported
      regions(m).head("operations").arr.filter(_("name").str == "firrtl.instance")
        .foreach(op => visit(attrs(op)("moduleName")("symbol").str))
    }
    val top = payload("top").str
    visit(top)
    val circuit = F.Circuit(info(c), reachable.toList, top)
    val normalized = Normalize(FirrtlAdapter(circuit, namespace, args(3)))
    val out = Paths.get(args(1))
    val segments = namespace.split('.')
    val directory = segments.dropRight(1).foldLeft(out)((p, n) => p.resolve(n))
    Files.createDirectories(directory)
    val contract = "valid p; fixed configuration; one synchronous clock; reset ports are explicit inputs; supply initial State; step reset argument is unused."
    val lean = FirrtlLeanEmitter.emit(normalized, contract, "CIRCT 1.135.0 frontend; Lean 4.19.0; IR v2; typed SSA import.")
    Files.writeString(directory.resolve(segments.last + ".lean"), lean, StandardCharsets.UTF_8)
    val metadata = List("frontend" -> Json.str("firrtl"), "firrtlImplementation" -> Json.str("CIRCT"),
      "circtVersion" -> Json.str("1.135.0"), "expressionRepresentation" -> Json.str("pure-named-DAG"),
      "circuitTop" -> Json.str(top), "resetInterface" -> Json.str("explicit-input"),
      "initialState" -> Json.str("caller-supplied-for-registers"))
    val mode = if (normalized.next.isEmpty) "none-combinational" else "single-clock-explicit-input-reset"
    Files.writeString(directory.resolve(segments.last + ".ir.json"), Json.module(normalized, None, metadata, Some(mode)), StandardCharsets.UTF_8)
    println(s"CIRCT $top -> $namespace: ${normalized.signals.size} signals, ${normalized.next.size} state fields")
  } catch {
    case e: TranslationError => System.err.println(s"${e.source.file}:${e.source.line}:${e.source.column}: ${e.detail}"); sys.exit(2)
    case e: Exception => System.err.println("CIRCT frontend failed: " + e.getMessage); sys.exit(2)
  }
}
