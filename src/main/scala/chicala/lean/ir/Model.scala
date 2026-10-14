package chicala.lean.ir

/** Source-level, parameterized hardware semantics, independent of Scala compiler trees. */
final case class Source(file: String, line: Int, column: Int)
final case class TranslationError(source: Source, detail: String) extends RuntimeException(detail)

sealed trait ParamExpr
final case class PInt(value: BigInt) extends ParamExpr
final case class PBool(value: Boolean) extends ParamExpr
final case class PName(name: String) extends ParamExpr
/** wrap32 distinguishes Scala Int operations from mathematical width arithmetic. */
final case class POp(op: String, args: List[ParamExpr], wrap32: Boolean = false) extends ParamExpr
final case class PIf(cond: ParamExpr, yes: ParamExpr, no: ParamExpr) extends ParamExpr
final case class PForall(index: String, size: ParamExpr, condition: ParamExpr) extends ParamExpr
final case class Parameter(name: String, kind: String)
/** An explicit source annotation and its expression in the module's parameters. */
final case class PreservedParameter(owner: String, name: String, kind: String, role: String,
                                    expression: ParamExpr, source: Source, instance: List[String] = Nil)

object ParamSimplify {
  def apply(p: ParamExpr): ParamExpr = p match {
    case PIf(c, a, b) => apply(c) match {
      case PBool(true) => apply(a)
      case PBool(false) => apply(b)
      case x => if (apply(a) == apply(b)) apply(a) else PIf(x, apply(a), apply(b))
    }
    case POp(op, values, wrap) =>
      val args = values.map(apply)
      val computed: Option[ParamExpr] = (op, args) match {
        case ("&&", List(PBool(true), x)) => Some(x)
        case ("&&", List(x, PBool(true))) => Some(x)
        case ("&&", List(PBool(false), _)) | ("&&", List(_, PBool(false))) => Some(PBool(false))
        case ("||", List(PBool(false), x)) => Some(x)
        case ("||", List(x, PBool(false))) => Some(x)
        case ("||", List(PBool(true), _)) | ("||", List(_, PBool(true))) => Some(PBool(true))
        case ("!", List(PBool(v))) => Some(PBool(!v))
        case ("neg", List(PInt(v))) => Some(PInt(-v))
        case ("unsignedWidth", List(PInt(v))) => Some(PInt(v.bitLength.max(1)))
        case ("signedWidth", List(PInt(v))) => Some(PInt((if (v >= 0) v.bitLength else (-v - 1).bitLength) + 1))
        case ("pow2", List(PInt(v))) if v >= 0 && v <= 4096 => Some(PInt(BigInt(1) << v.toInt))
        case (operation, List(PInt(a), PInt(b))) => operation match {
          case "+" => Some(PInt(a + b)); case "-" => Some(PInt(a - b)); case "*" => Some(PInt(a * b))
          case "/" if b != 0 => Some(PInt(a / b)); case "%" if b != 0 => Some(PInt(a % b))
          case "max" => Some(PInt(a.max(b))); case "min" => Some(PInt(a.min(b)))
          case "<" => Some(PBool(a < b)); case "<=" => Some(PBool(a <= b))
          case ">" => Some(PBool(a > b)); case ">=" => Some(PBool(a >= b))
          case "==" => Some(PBool(a == b)); case "!=" => Some(PBool(a != b))
          case "fitsUnsigned" => Some(PBool(a >= 0 && b >= 0 && BigInt(a.bitLength) <= b))
          case "fitsSigned" => Some(PBool(b >= 1 && BigInt((if (a >= 0) a.bitLength else (-a - 1).bitLength) + 1) <= b))
          case _ => None
        }
        case _ => None
      }
      computed match {
        case Some(PInt(v)) if wrap => PInt((v + (BigInt(1) << 31)).mod(BigInt(1) << 32) - (BigInt(1) << 31))
        case Some(v) => v
        case None => POp(op, args, wrap)
      }
    case other => other
  }
  def names(p: ParamExpr): Set[String] = p match {
    case PForall(i, n, c) => names(n) ++ (names(c) - i)
    case PName(n) => Set(n)
    case POp(_, args, _) => args.flatMap(names).toSet
    case PIf(c, a, b) => names(c) ++ names(a) ++ names(b)
    case _ => Set.empty
  }
}

sealed trait HWType
case object BooleanType extends HWType
final case class BitsType(width: ParamExpr, signed: Boolean = false) extends HWType
final case class VectorType(size: ParamExpr, element: HWType) extends HWType
case object InferType extends HWType
final case class InferBits(signed: Boolean) extends HWType

sealed trait Expr
final case class Ref(name: String) extends Expr
final case class Lit(value: ParamExpr, tpe: HWType) extends Expr
final case class HostBool(value: ParamExpr) extends Expr
final case class Prim(op: String, args: List[Expr], params: List[ParamExpr] = Nil) extends Expr
final case class Choose(cond: Expr, yes: Expr, no: Expr) extends Expr
final case class Resize(value: Expr, tpe: HWType) extends Expr
final case class VecGet(value: Expr, index: ParamExpr) extends Expr
final case class VecSet(value: Expr, index: ParamExpr, rhs: Expr) extends Expr
final case class VecMap(index: String, size: ParamExpr, value: Expr) extends Expr
final case class VecValues(values: List[Expr]) extends Expr
final case class VecGetDynamic(value: Expr, index: Expr) extends Expr
final case class VecSetDynamic(value: Expr, index: Expr, rhs: Expr) extends Expr
final case class Checked(value: Expr, condition: Expr) extends Expr
final case class Undefined(name: String) extends Expr

final case class Signal(name: String, kind: String, tpe: HWType, init: Option[Expr], source: Source,
                        sourcePath: List[String] = Nil)
sealed trait Statement { def source: Source }
final case class Assign(name: String, index: Option[ParamExpr], rhs: Expr, source: Source) extends Statement
final case class DynamicAssign(name: String, index: Expr, rhs: Expr, source: Source) extends Statement
sealed trait VectorIndex
final case class StaticIndex(value: ParamExpr) extends VectorIndex
final case class DynamicIndex(value: Expr) extends VectorIndex
/** Retain the lvalue path so partial writes compose with earlier connections. */
final case class IndexedAssign(name: String, indices: List[VectorIndex], rhs: Expr, source: Source) extends Statement
final case class Branch(cond: Expr, yes: List[Statement], no: List[Statement], source: Source) extends Statement
final case class Generate(index: String, start: ParamExpr, end: ParamExpr,
                          body: List[Statement], source: Source) extends Statement
final case class Module(name: String, parameters: List[Parameter], requirements: List[ParamExpr],
                        signals: List[Signal], statements: List[Statement], source: Source,
                        preservedParameters: List[PreservedParameter] = Nil)

/** Every expression in the emission IR has its resolved hardware type. */
final case class TypedExpr(kind: String, tpe: HWType, args: List[TypedExpr] = Nil,
                           name: String = "", params: List[ParamExpr] = Nil)
final case class Normalized(module: Module, signals: List[Signal],
                            next: List[(Signal, TypedExpr)], outputs: List[(Signal, TypedExpr)],
                            resets: List[(Signal, TypedExpr)], requirements: List[ParamExpr])

object Width {
  def add(a: ParamExpr, b: ParamExpr): ParamExpr = (a, b) match {
    case (PInt(x), PInt(y)) => PInt(x + y)
    case (PInt(x), y) if x == 0 => y
    case (x, PInt(y)) if y == 0 => x
    case _ => POp("+", List(a, b))
  }
  def max(a: ParamExpr, b: ParamExpr): ParamExpr = {
    def terms(x: ParamExpr): List[ParamExpr] = x match {
      case POp("max", xs, false) => xs.flatMap(terms)
      case other => List(other)
    }
    val xs = (terms(a) ++ terms(b)).distinct
    val constants = xs.collect { case PInt(n) => n }
    val variables = xs.filterNot(_.isInstanceOf[PInt])
    val values = variables ++ (if (constants.isEmpty) Nil else List(PInt(constants.max)))
    values.reduceLeft { (x, y) => if (x == y) x else POp("max", List(x, y)) }
  }
  def bits(t: HWType): BitsType = t match {
    case b: BitsType => b
    case BooleanType => BitsType(PInt(1))
    case _ => throw new IllegalArgumentException("Expected a bit-vector type")
  }
}
