package chicala.lean.backend

import chicala.lean.ir._

object LeanEmitter {
  private val keywords = Set("in", "out", "if", "then", "else", "match", "with", "where", "def", "let", "by", "end", "namespace", "open", "class", "structure", "theorem", "axiom", "instance", "inductive", "do", "return", "Type", "Prop", "repeat", "for", "while", "until", "try", "catch", "finally", "break", "continue", "fun", "forall", "exists", "from", "import", "export", "private", "protected", "partial", "opaque", "unsafe", "mutual", "deriving", "section", "variable", "example", "abbrev", "constant", "syntax", "macro", "elab", "attribute", "initialize", "set_option", "at", "have", "show", "calc", "nomatch")
  def field(name: String): String = {
    val plain = name.replace('.', '_')
    if (plain.matches("[a-zA-Z_][a-zA-Z0-9_]*") && !keywords(plain)) plain
    else "«" + plain.replace("»", "_") + "»"
  }
  def namespace(name: String): String = name.split('.').map(field).mkString(".")

  def parameter(p: ParamExpr, locals: Map[String, String] = Map.empty): String = p match {
    case PInt(n) => s"($n : Int)"
    case PBool(v) => v.toString
    case PName(n) => locals.getOrElse(n, "p." + field(n))
    case PIf(c, a, b) => s"(if ${parameter(c, locals)} then ${parameter(a, locals)} else ${parameter(b, locals)})"
    case PForall(i, n, c) =>
      val binding = "__domain_" + i.replaceAll("[^a-zA-Z0-9_]", "_")
      s"((List.range (${nat(n, locals)})).all (fun $binding => ${parameter(c, locals + (i -> s"(Int.ofNat $binding)"))}))"
    case POp(op, values, wrap) =>
      val a = values.map(parameter(_, locals))
      val base = op match {
        case "+" | "-" | "*" => s"(${a.head} $op ${a(1)})"
        case "/" => s"(Int.tdiv ${a.head} ${a(1)})"
        case "%" => s"(Int.tmod ${a.head} ${a(1)})"
        case "max" | "min" => s"($op ${a.head} ${a(1)})"
        case "neg" => s"(-${a.head})"
        case "==" => s"(${a.head} == ${a(1)})"
        case "!=" => s"(${a.head} != ${a(1)})"
        case "<" | "<=" | ">" | ">=" => s"(decide (${a.head} $op ${a(1)}))"
        case "&&" | "||" => s"(${a.head} $op ${a(1)})"
        case "!" => s"(!${a.head})"
        case "log2Ceil" => s"(Chisel2Lean.Runtime.log2Ceil ${a.head})"
        case "unsignedWidth" => s"(Chisel2Lean.Runtime.unsignedWidth ${a.head})"
        case "signedWidth" => s"(Chisel2Lean.Runtime.signedWidth ${a.head})"
        case "lookupComplete" => s"(Chisel2Lean.Runtime.lookupComplete ${a.head} [${a.tail.mkString(", ")}])"
        case "pow2" => s"(Int.ofNat (2 ^ (${a.head}).toNat))"
        case "fitsUnsigned" => s"(Chisel2Lean.Runtime.fitsUnsigned ${a.head} ${a(1)})"
        case "fitsSigned" => s"(Chisel2Lean.Runtime.fitsSigned ${a.head} ${a(1)})"
        case other => throw new IllegalArgumentException(s"Unsupported parameter operation $other")
      }
      if (wrap) s"(Chisel2Lean.Runtime.int32 $base)" else base
  }
  def nat(p: ParamExpr, locals: Map[String, String] = Map.empty): String = s"(${parameter(p, locals)}).toNat"
  def hwType(t: HWType): String = t match {
    case BooleanType => "Bool"
    case BitsType(w, _) => s"BitVec (${nat(w)})"
    case VectorType(n, e) => s"(Fin (${nat(n)}) → ${hwType(e)})"
    case InferType | _: InferBits => throw new IllegalArgumentException("Unresolved width in Lean backend")
  }

  private def number(e: TypedExpr, locals: Map[String, String]): String = e.tpe match {
    case BooleanType => s"(if ${expression(e, locals)} then (1 : Int) else 0)"
    case BitsType(_, true) => s"(${expression(e, locals)}).toInt"
    case _: BitsType => s"(Int.ofNat (${expression(e, locals)}).toNat)"
    case _ => throw new IllegalArgumentException("Numeric expression requires bits")
  }
  private def unsigned(e: TypedExpr, locals: Map[String, String]): String = e.tpe match {
    case BooleanType => s"(if ${expression(e, locals)} then (1 : Nat) else 0)"
    case _: BitsType => s"(${expression(e, locals)}).toNat"
    case _ => throw new IllegalArgumentException("Expected bit-vector")
  }
  private def asBits(e: TypedExpr, w: ParamExpr, locals: Map[String, String]): String =
    s"(BitVec.ofInt (${nat(w, locals)}) ${number(e, locals)})"

  def expression(e: TypedExpr, locals: Map[String, String] = Map.empty): String = {
    def arg(i: Int): String = expression(e.args(i), locals)
    def num(i: Int): String = number(e.args(i), locals)
    def un(i: Int): String = unsigned(e.args(i), locals)
    def width: ParamExpr = Width.bits(e.tpe).width
    def bits(value: String): String = s"(BitVec.ofInt (${nat(width, locals)}) $value)"
    e.kind match {
      case "input" => "inputs." + field(e.name)
      case "reg" => "state." + field(e.name)
      // Named DAG nodes are introduced only during emission; the original child
      // remains attached so definedness still follows the complete expression.
      case "namedExpr" => s"(${e.name} p inputs state)"
      case "parameter" => parameter(e.params.head, locals)
      case "literal" => if (e.tpe == BooleanType) parameter(e.params.head, locals)
                        else bits(parameter(e.params.head, locals))
      case "mux" => s"(if ${arg(0)} then ${arg(1)} else ${arg(2)})"
      case "checked" => arg(0)
      case "sameVecIndex" => s"(Chisel2Lean.Runtime.vecIndex (${nat(e.params.head, locals)}) (${un(0)}) == Chisel2Lean.Runtime.vecIndex (${nat(e.params.head, locals)}) (${un(1)}))"
      case "resize" => e.tpe match {
        case BooleanType => s"(${un(0)} != 0)"
        case _: BitsType => bits(num(0))
        case _ => arg(0)
      }
      case "add" | "addWide" => bits(s"(${num(0)} + ${num(1)})")
      case "sub" | "subWide" => bits(s"(${num(0)} - ${num(1)})")
      case "mul" => bits(s"(${num(0)} * ${num(1)})")
      case "div" => bits(s"(Int.tdiv ${num(0)} ${num(1)})")
      case "rem" => bits(s"(Int.tmod ${num(0)} ${num(1)})")
      case "neg" => bits(s"(-${num(0)})")
      case "and" | "or" | "xor" if e.tpe == BooleanType =>
        val op = Map("and" -> "&&", "or" -> "||", "xor" -> "!=")(e.kind)
        s"(${arg(0)} $op ${arg(1)})"
      case "and" | "or" | "xor" =>
        s"(BitVec.${e.kind} ${asBits(e.args.head, width, locals)} ${asBits(e.args(1), width, locals)})"
      case "not" if e.tpe == BooleanType => s"(!${arg(0)})"
      case "not" => s"(BitVec.not ${arg(0)})"
      case "notBool" => if (e.args.head.tpe == BooleanType) s"(!${arg(0)})" else s"(${num(0)} == 0)"
      case "andBool" => s"(${arg(0)} && ${arg(1)})"
      case "orBool" => s"(${arg(0)} || ${arg(1)})"
      case "eq" => s"(${num(0)} == ${num(1)})"
      case "ne" => s"(${num(0)} != ${num(1)})"
      case "lt" | "le" | "gt" | "ge" =>
        val op = Map("lt" -> "<", "le" -> "<=", "gt" -> ">", "ge" -> ">=")(e.kind)
        s"(decide (${num(0)} $op ${num(1)}))"
      case "asUInt" | "asSInt" => s"(BitVec.ofNat (${nat(width, locals)}) ${un(0)})"
      case "asBool" => s"(${un(0)} != 0)"
      case "shl" =>
        val amount = if (e.params.nonEmpty) nat(e.params.head, locals) else un(1)
        bits(s"(${num(0)} * (2 : Int) ^ ($amount))")
      case "shr" =>
        val amount = if (e.params.nonEmpty) nat(e.params.head, locals) else un(1)
        if (Width.bits(e.args.head.tpe).signed) bits(s"(${arg(0)}.sshiftRight ($amount)).toInt")
        else s"(BitVec.ofNat (${nat(width, locals)}) (${un(0)} >>> ($amount)))"
      case "slice" => s"(BitVec.ofNat (${nat(width, locals)}) (${un(0)} >>> (${nat(e.params(1), locals)})))"
      case "bit" => s"((${un(0)} >>> (${nat(e.params.head, locals)})) % 2 == 1)"
      case "cat" =>
        val value = e.args.foldLeft("(0 : Nat)") { (acc, value) =>
          s"($acc * 2 ^ (${nat(Width.bits(value.tpe).width, locals)}) + ${unsigned(value, locals)})"
        }
        s"(BitVec.ofNat (${nat(width, locals)}) $value)"
      case "orR" => s"(${un(0)} != 0)"
      case "andR" => s"(${un(0)} == 2 ^ (${nat(Width.bits(e.args.head.tpe).width, locals)}) - 1)"
      case "xorR" => s"(Chisel2Lean.Runtime.xorR ${arg(0)})"
      case "pad" => bits(num(0))
      case "head" => s"(BitVec.ofNat (${nat(width, locals)}) (${un(0)} >>> ((${nat(Width.bits(e.args.head.tpe).width, locals)}) - (${nat(e.params.head, locals)}))))"
      case "tail" => s"(BitVec.ofNat (${nat(width, locals)}) ${un(0)})"
      case "fill" => s"(BitVec.ofNat (${nat(width, locals)}) (Chisel2Lean.Runtime.fill (${un(0)}) (${nat(Width.bits(e.args.head.tpe).width, locals)}) (${nat(e.params.head, locals)})))"
      case "vecGet" => s"(Chisel2Lean.Runtime.vecGet ${arg(0)} (${nat(e.params.head, locals)}))"
      case "vecSet" => s"(fun j => if j.val == ${nat(e.params.head, locals)} then ${arg(1)} else ${arg(0)} j)"
      case "vecMap" =>
        val binding = "__gen_" + e.name.replaceAll("[^a-zA-Z0-9_]", "_")
        val localMap = locals + (e.name -> s"(Int.ofNat $binding.val)")
        s"(fun $binding => ${expression(e.args.head, localMap)})"
      case "vecValues" =>
        val cases = e.args.zipWithIndex.map { case (v, i) => s"| $i => ${expression(v, locals)}" }.mkString(" ")
        s"(fun (j : Fin (${nat(e.tpe.asInstanceOf[VectorType].size, locals)})) => match j.val with $cases | _ => default)"
      case "vecGetDynamic" => s"(Chisel2Lean.Runtime.vecGet ${arg(0)} (Chisel2Lean.Runtime.vecIndex (${nat(e.params.head, locals)}) (${un(1)})))"
      case "vecSetDynamic" => s"(fun j => if j.val == Chisel2Lean.Runtime.vecIndex (${nat(e.params.head, locals)}) (${un(1)}) then ${arg(2)} else ${arg(0)} j)"
      case "vecResize" =>
        val depth = locals.get("@vecResizeDepth").map(_.toInt).getOrElse(0)
        val binding = if (depth == 0) "__elem" else "__elem_" + depth
        val scope = locals ++ Map("@vecResizeDepth" -> (depth + 1).toString,
          "__vecElement" -> s"(${arg(0)} $binding)")
        s"(fun $binding => ${expression(e.args(1), scope)})"
      case "vecElement" => locals("__vecElement")
      case other => throw new IllegalArgumentException(s"Unsupported typed IR operation $other")
    }
  }

  private def record(values: List[(String, String)]): String =
    if (values.isEmpty) "⟨⟩" else values.map { case (n, v) => s"${field(n)} := $v" }.mkString("{ ", ",\n    ", " }")
  private def structure(name: String, fields: List[(String, String)], dependent: Boolean = true): String =
    s"structure $name${if (dependent) " (p : Params)" else ""} where\n" +
      fields.map { case (n, t) => s"  ${field(n)} : $t\n" }.mkString + "\n"
  private def readsState(e: TypedExpr): Boolean = e.kind == "reg" || e.args.exists(readsState)

  /** FIRRTL leaves division by zero undefined. Expose, and execute, the contract. */
  private def defined(e: TypedExpr, locals: Map[String, String] = Map.empty): String = {
    def all(xs: List[String]) = xs.filter(_ != "true").distinct match {
      case Nil => "true"
      case values => values.mkString("(", " && ", ")")
    }
    e.kind match {
      case "mux" =>
        val a = defined(e.args(1), locals); val b = defined(e.args(2), locals)
        all(List(defined(e.args.head, locals), if (a == b) a else s"(if ${expression(e.args.head, locals)} then $a else $b)"))
      case "vecMap" =>
        val binding = "__defined_" + e.name.replaceAll("[^a-zA-Z0-9_]", "_")
        val domain = defined(e.args.head, locals + (e.name -> s"(Int.ofNat $binding.val)"))
        if (domain == "true") "true" else s"((List.finRange (${nat(e.tpe.asInstanceOf[VectorType].size, locals)})).all (fun $binding => $domain))"
      case "vecElement" => "true"
      case "vecResize" => defined(e.args.head, locals)
      case "div" | "rem" => all(e.args.map(defined(_, locals)) :+ s"(${unsigned(e.args(1), locals)} != 0)")
      case "checked" => all(e.args.map(defined(_, locals)) :+ expression(e.args(1), locals))
      case "vecGetDynamic" | "vecSetDynamic" => all(e.args.map(defined(_, locals)) :+
        s"(decide (Chisel2Lean.Runtime.vecIndex (${nat(e.params.head, locals)}) (${unsigned(e.args(1), locals)}) < (${nat(e.params.head, locals)})))")
      case _ => all(e.args.map(defined(_, locals)))
    }
  }

  def emit(n: Normalized,
           toolchain: String = "Chisel 7.3.0; Scala 2.13.15; Lean 4.19.0; IR v2.",
           contract: Option[String] = None): String = {
    val names = n.signals.map(s => field(s.name))
    if (names.distinct.size != names.size) throw TranslationError(n.module.source, "Lean field name collision")
    val pNames = n.module.parameters.map(p => field(p.name))
    if (pNames.distinct.size != pNames.size) throw TranslationError(n.module.source, "Lean parameter name collision")
    val ns = namespace(n.module.name)
    val regs = n.signals.filter(_.kind == "reg")
    val inputs = n.signals.filter(_.kind == "input")
    val outputs = n.signals.filter(_.kind == "output")
    val header = s"-- Automatically generated by Chisel2Lean 0.2.0; do not edit.\n" +
      s"-- Source: ${n.module.source.file}:${n.module.source.line}\n" +
      s"-- $toolchain\n" +
      "-- Contract: " + contract.getOrElse(if (regs.isEmpty) "valid p; combinational semantics." else "valid p; one synchronous active-high reset/clock domain.") + "\n" +
      "import Chisel2Lean.Runtime\n" + "set_option linter.unusedVariables false\n\n" + s"namespace $ns\n\n"
    val paramStruct = structure("Params", n.module.parameters.map(p => p.name -> (if (p.kind == "Int") "Int" else "Bool")), dependent = false)
    val valid = "def valid (p : Params) : Bool :=\n  " + (if (n.requirements.isEmpty) "true" else n.requirements.map(parameter(_)).mkString(" &&\n  ")) + "\n\n"
    val structs = List("Inputs" -> inputs, "State" -> regs, "Outputs" -> outputs).map { case (name, sigs) =>
      structure(name, sigs.map(s => s.name -> hwType(s.tpe)))
    }.mkString
    val resetMap = n.resets.toMap
    val next = n.next.map { case (s, value) =>
      s.name -> resetMap.get(s).map(r => s"(if reset then ${expression(r)} else ${expression(value)})").getOrElse(expression(value))
    }
    val step = s"def step (p : Params) (inputs : Inputs p) (state : State p) (reset : Bool := false) : State p :=\n  ${record(next)}\n\n"
    val output = s"def output (p : Params) (inputs : Inputs p) (state : State p) : Outputs p :=\n  ${record(n.outputs.map { case (s, e) => s.name -> expression(e) })}\n\n"
    def conjunction(values: List[String]): String = values.filter(_ != "true").distinct match {
      case Nil => "true"; case xs => xs.mkString(" &&\n  ")
    }
    val contracts = s"/-- Preconditions for operations with undefined FIRRTL cases. -/\n" +
      s"def outputDefined (p : Params) (inputs : Inputs p) (state : State p) : Bool :=\n  ${conjunction(n.outputs.map(x => defined(x._2)))}\n\n" +
      s"def transitionDefined (p : Params) (inputs : Inputs p) (state : State p) (reset : Bool := false) : Bool :=\n  ${conjunction(n.next.map { case (s, e) => resetMap.get(s).map(r => s"(if reset then ${defined(r)} else ${defined(e)})").getOrElse(defined(e)) })}\n\n"
    val reset = if (n.resets.size == regs.size && !n.resets.exists(x => readsState(x._2)))
      s"/-- State after an effective reset edge under the supplied inputs. -/\n" +
      s"def resetState (p : Params) (inputs : Inputs p) : State p :=\n  ${record(n.resets.map { case (s, e) => s.name -> expression(e) })}\n\n"
      else "-- Reset does not determine every register; supply State explicitly.\n\n"
    header + paramStruct + valid + structs + step + output + contracts + reset + s"end $ns\n"
  }
}
