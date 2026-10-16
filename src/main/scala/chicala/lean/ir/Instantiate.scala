package chicala.lean.ir

/** Instantiate a symbolic child without elaborating away the parent's parameters. */
object Instantiate {
  def apply(child: Module, prefix: String, bindings: Map[String, ParamExpr]): Module = {
    def p(x: ParamExpr, locals: Map[String, String] = Map.empty): ParamExpr = x match {
      case PName(n) => locals.get(n).map(PName).getOrElse(bindings.getOrElse(n, x))
      case POp(op, args, wrap) => ParamSimplify(POp(op, args.map(p(_, locals)), wrap))
      case PIf(c, a, b) => ParamSimplify(PIf(p(c, locals), p(a, locals), p(b, locals)))
      case PForall(i, n, c) =>
        val fresh = prefix.replace('.', '_') + "__" + i
        PForall(fresh, p(n, locals), p(c, locals + (i -> fresh)))
      case other => other
    }
    def t(x: HWType): HWType = x match {
      case BitsType(w, s) => BitsType(p(w), s)
      case VectorType(n, elem) => VectorType(p(n), t(elem))
      case other => other
    }
    def e(x: Expr, locals: Map[String, String] = Map.empty): Expr = x match {
      case Ref(n) => Ref(prefix + "." + n)
      case Lit(v, tp) => Lit(p(v, locals), t(tp))
      case HostBool(v) => HostBool(p(v, locals))
      case Prim(op, args, ps) => Prim(op, args.map(e(_, locals)), ps.map(p(_, locals)))
      case Choose(c, a, b) => Choose(e(c, locals), e(a, locals), e(b, locals))
      case Resize(v, tp) => Resize(e(v, locals), t(tp))
      case VecGet(v, i) => VecGet(e(v, locals), p(i, locals))
      case VecSet(v, i, rhs) => VecSet(e(v, locals), p(i, locals), e(rhs, locals))
      case VecMap(i, n, v) =>
        val fresh = prefix.replace('.', '_') + "__" + i
        VecMap(fresh, p(n, locals), e(v, locals + (i -> fresh)))
      case VecValues(xs) => VecValues(xs.map(e(_, locals)))
      case VecGetDynamic(v, i) => VecGetDynamic(e(v, locals), e(i, locals))
      case VecSetDynamic(v, i, rhs) => VecSetDynamic(e(v, locals), e(i, locals), e(rhs, locals))
      case Checked(v, c) => Checked(e(v, locals), e(c, locals))
      case Undefined(n) => Undefined(prefix + "." + n)
    }
    def statements(xs: List[Statement], locals: Map[String, String] = Map.empty): List[Statement] = xs.map {
      case Assign(n, i, rhs, src) => Assign(prefix + "." + n, i.map(p(_, locals)), e(rhs, locals), src)
      case DynamicAssign(n, i, rhs, src) => DynamicAssign(prefix + "." + n, e(i, locals), e(rhs, locals), src)
      case IndexedAssign(n, indices, rhs, src) => IndexedAssign(prefix + "." + n, indices.map {
        case StaticIndex(i) => StaticIndex(p(i, locals))
        case DynamicIndex(i) => DynamicIndex(e(i, locals))
      }, e(rhs, locals), src)
      case Branch(c, a, b, src) => Branch(e(c, locals), statements(a, locals), statements(b, locals), src)
      case Generate(i, a, b, body, src) =>
        val fresh = prefix.replace('.', '_') + "__" + i
        Generate(fresh, p(a, locals), p(b, locals), statements(body, locals + (i -> fresh)), src)
    }
    child.copy(parameters = Nil, requirements = child.requirements.map(p(_)),
      preservedParameters = child.preservedParameters.map(m => m.copy(expression = p(m.expression), instance = prefix :: m.instance)),
      signals = child.signals.map(s => s.copy(name = prefix + "." + s.name,
        kind = if (s.kind == "input" || s.kind == "output") "wire" else s.kind,
        tpe = t(s.tpe), init = s.init.map(e(_)),
        sourcePath = if (s.sourcePath.isEmpty) Nil else prefix.split('.').toList ++ s.sourcePath)), statements = statements(child.statements))
  }
}
