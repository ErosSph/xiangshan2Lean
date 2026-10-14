package chicala.lean.backend

import chicala.lean.ir._

object Json {
  def str(value: String): String = "\"" + value.flatMap {
    case '"' => "\\\""
    case '\\' => "\\\\"
    case '\n' => "\\n"
    case '\r' => "\\r"
    case '\t' => "\\t"
    case c if c < ' ' => f"\\u${c.toInt}%04x"
    case c => c.toString
  } + "\""
  def obj(fields: (String, String)*): String = fields.map { case (k, v) => str(k) + ":" + v }.mkString("{", ",", "}")
  def arr(values: Iterable[String]): String = values.mkString("[", ",", "]")
  def source(s: Source): String = obj("file" -> str(s.file), "line" -> s.line.toString, "column" -> s.column.toString)
  def param(p: ParamExpr): String = p match {
    case PInt(v) => obj("kind" -> str("int"), "value" -> str(v.toString))
    case PBool(v) => obj("kind" -> str("bool"), "value" -> v.toString)
    case PName(n) => obj("kind" -> str("name"), "name" -> str(n))
    case POp(op, args, wrap) => obj("kind" -> str("op"), "op" -> str(op), "args" -> arr(args.map(param)), "wrap32" -> wrap.toString)
    case PIf(c, a, b) => obj("kind" -> str("if"), "args" -> arr(List(c, a, b).map(param)))
    case PForall(i, n, c) => obj("kind" -> str("forall"), "index" -> str(i), "size" -> param(n), "condition" -> param(c))
  }
  def hwType(t: HWType): String = t match {
    case BooleanType => obj("kind" -> str("bool"))
    case BitsType(w, signed) => obj("kind" -> str("bits"), "width" -> param(w), "signed" -> signed.toString)
    case VectorType(n, e) => obj("kind" -> str("vec"), "size" -> param(n), "element" -> hwType(e))
    case InferType | _: InferBits => throw new IllegalArgumentException("Unresolved type cannot be serialized")
  }
  def signal(s: Signal): String = {
    val base = List("name" -> str(s.name), "field" -> str(LeanEmitter.field(s.name)),
      "kind" -> str(s.kind), "type" -> hwType(s.tpe), "source" -> source(s.source))
    obj((base ++ (if (s.sourcePath.isEmpty) Nil else List("source_path" -> arr(s.sourcePath.map(str))))): _*)
  }
  def expression(e: TypedExpr): String = obj("kind" -> str(e.kind), "type" -> hwType(e.tpe),
    "name" -> str(e.name), "params" -> arr(e.params.map(param)), "args" -> arr(e.args.map(expression)))
  def module(n: Normalized, chiselVersion: Option[String] = Some("7.3.0"),
             metadata: List[(String, String)] = Nil, resetMode: Option[String] = None): String = {
    val base = obj(
    "format" -> str("chisel2lean-ir-v2"), "module" -> str(n.module.name),
    "namespace" -> str(LeanEmitter.namespace(n.module.name)), "leanVersion" -> str("4.19.0"),
    "chiselVersion" -> chiselVersion.map(str).getOrElse("null"), "reset" -> str(resetMode.getOrElse(if (n.next.isEmpty) "none-combinational" else "single-clock-synchronous-active-high")),
    "definedness" -> str("executable-predicates"),
    "source" -> source(n.module.source),
    "parameters" -> arr(n.module.parameters.map(p => obj("name" -> str(p.name), "field" -> str(LeanEmitter.field(p.name)), "kind" -> str(p.kind)))),
    "requirements" -> arr(n.requirements.map(param)), "signals" -> arr(n.signals.map(signal)),
    "next" -> arr(n.next.map { case (s, e) => obj("signal" -> str(s.name), "expression" -> expression(e)) }),
    "outputs" -> arr(n.outputs.map { case (s, e) => obj("signal" -> str(s.name), "expression" -> expression(e)) }),
    "resets" -> arr(n.resets.map { case (s, e) => obj("signal" -> str(s.name), "expression" -> expression(e)) }))
    if (metadata.isEmpty) base else base.dropRight(1) + metadata.map { case (k, v) => "," + str(k) + ":" + v }.mkString + "}"
  }
}
