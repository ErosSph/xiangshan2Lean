package chicala.lean.ir

import scala.collection.mutable

/** Last-connect priority is resolved first; combinational references are resolved afterwards.
  * Register reads always resolve to the old state, including within other register updates.
  */
object Normalize {
  def apply(m: Module): Normalized = new Normalizer(m).run()

  private final class Normalizer(m: Module) {
    private val byName = mutable.Map.empty[String, Signal] ++ m.signals.map(s => s.name -> s)
    private val expressions = mutable.LinkedHashMap.empty[String, Expr]
    private val resolved = mutable.Map.empty[String, TypedExpr]
    private val active = mutable.Set.empty[String]
    private val extraRequirements = mutable.ListBuffer.empty[ParamExpr]
    private var location = m.source
    private var boundIndices = Map.empty[String, ParamExpr]
    private val inferredTypes = mutable.Map.empty[String, HWType]
    private val inferring = mutable.Set.empty[String]
    private var validationGuard: ParamExpr = PBool(true)
    private var solvingWidths = false
    private def requireDomain(r: ParamExpr): Unit = {
      if (solvingWidths) return
      val condition = ParamSimplify(POp("||", List(POp("!", List(validationGuard)), r)))
      val quantified = boundIndices.toList.foldRight(condition) { case ((i, n), c) =>
        if (ParamSimplify.names(c)(i)) PForall(i, n, c) else c
      }
      quantified match {
        case PBool(true) =>
        case PBool(false) => fail("A constant source width/literal/index condition is invalid")
        case _ => extraRequirements += quantified
      }
    }
    private def underGuard[A](guard: ParamExpr)(body: => A): A = {
      val previous = validationGuard
      validationGuard = ParamSimplify(POp("&&", List(previous, guard)))
      try body finally { validationGuard = previous }
    }
    private def fail(message: String): Nothing = throw TranslationError(location, message)

    private def process(statements: List[Statement], env: mutable.LinkedHashMap[String, Expr]): Unit =
      statements.foreach {
        case IndexedAssign(name, indices, rhs, pos) =>
          location = pos
          val sig = byName.getOrElse(name, fail(s"Unknown connection target $name"))
          if (sig.kind == "input") fail(s"Cannot drive input $name")
          def update(value: Expr, tpe: HWType, path: List[VectorIndex]): Expr = path match {
            case Nil => Resize(rhs, tpe)
            case head :: tail => tpe match {
              case VectorType(_, element) => head match {
                case StaticIndex(i) => VecSet(value, i, update(VecGet(value, i), element, tail))
                case DynamicIndex(i) => VecSetDynamic(value, i, update(VecGetDynamic(value, i), element, tail))
              }
              case _ => fail(s"Too many vector indices in connection to $name")
            }
          }
          env(name) = update(env(name), sig.tpe, indices)
        case DynamicAssign(name, index, rhs, pos) =>
          location = pos
          val sig = byName.getOrElse(name, fail(s"Unknown connection target $name"))
          if (sig.kind == "input") fail(s"Cannot drive input $name")
          sig.tpe match {
            case VectorType(_, elem) => env(name) = VecSetDynamic(env(name), index, Resize(rhs, elem))
            case _ => fail("Dynamic writes require a Vec")
          }
        case a @ Assign(name, index, rhs, pos) =>
          location = pos
          val sig = byName.getOrElse(name, fail(s"Unknown connection target $name"))
          if (sig.kind == "input") fail(s"Cannot drive input $name")
          index match {
            case None => env(name) = Resize(rhs, sig.tpe)
            case Some(i) => sig.tpe match {
              case VectorType(_, element) => env(name) = VecSet(env(name), i, Resize(rhs, element))
              case _ => fail(s"Indexed assignment requires Vec: $name")
            }
          }
        case Branch(cond, yes, no, pos) =>
          location = pos
          val left = mutable.LinkedHashMap.empty[String, Expr] ++ env
          val right = mutable.LinkedHashMap.empty[String, Expr] ++ env
          process(yes, left)
          process(no, right)
          env.keys.toList.foreach { key =>
            env(key) = if (left(key) == right(key)) left(key) else Choose(cond, left(key), right(key))
          }
        case Generate(index, start, end, body, pos) =>
          location = pos
          val previous = env.toMap
          val once = mutable.LinkedHashMap.empty[String, Expr] ++ env
          process(body, once)
          env.keys.toList.filter(key => once(key) != previous(key)).foreach { key =>
            byName(key).tpe match {
              case VectorType(size, _) =>
                List(POp(">=", List(start, PInt(0))), POp("<=", List(end, size))).foreach(requireDomain)
                def element(e: Expr): Expr = e match {
                  case VecSet(_, PName(i), rhs) if i == index => rhs
                  case Choose(c, a, b) => Choose(c, element(a), element(b))
                  case Undefined(n) => Undefined(n + "[" + index + "]")
                  case other if other == previous(key) => VecGet(other, PName(index))
                  case _ => fail("Generate body must connect each Vec element at its loop index")
                }
                val generated = element(once(key))
                val value = if (start == PInt(0) && size == end) generated else
                  Choose(HostBool(POp("&&", List(POp(">=", List(PName(index), start)), POp("<", List(PName(index), end))))),
                    generated, VecGet(previous(key), PName(index)))
                env(key) = VecMap(index, size, value)
              case _ => fail("Generate loops must cover a whole Vec of the same symbolic length")
            }
          }
      }

    private def signalType(name: String): HWType = {
      val signal = byName.getOrElse(name, fail(s"Unknown signal $name"))
      if (signal.tpe != InferType && !signal.tpe.isInstanceOf[InferBits]) signal.tpe
      else inferredTypes.getOrElseUpdate(name, {
        if (inferring(name)) fail(s"Cannot infer cyclic register/node type $name")
        inferring += name
        val result = if (signal.kind == "reg") typed(signal.init.getOrElse(expressions(name))).tpe else resolve(name).tpe
        inferring -= name
        result
      })
    }

    private def resolve(name: String): TypedExpr = resolved.getOrElseUpdate(name, {
      val signal = byName.getOrElse(name, fail(s"Unknown signal $name"))
      location = signal.source
      if (signal.kind == "input" || signal.kind == "reg") {
        TypedExpr(signal.kind, signalType(name), name = name)
      } else {
        if (active(name)) fail(s"Combinational dependency cycle involving $name")
        active += name
        val value = coerce(typed(expressions(name)), inferredTypes.getOrElse(name, signal.tpe))
        active -= name
        value
      }
    })

    private def coerce(value: TypedExpr, target: HWType): TypedExpr = {
      if (target == InferType || target.isInstanceOf[InferBits] || value.tpe == target) value
      else (value.tpe, target) match {
        case (_: BitsType | BooleanType, _: BitsType | BooleanType) =>
          if (!solvingWidths && target == BooleanType && Width.bits(value.tpe).width != PInt(1))
            fail("Conversion to Bool requires a proven one-bit source")
          TypedExpr("resize", target, List(value))
        case (VectorType(a, x), VectorType(b, y)) if a == b =>
          val sample = coerce(TypedExpr("vecElement", x), y)
          TypedExpr("vecResize", target, List(value, sample))
        case _ => fail(s"Unsupported connection type conversion ${value.tpe} -> $target")
      }
    }

    private def join(a: HWType, b: HWType): HWType = (a, b) match {
      case (BooleanType, BooleanType) => BooleanType
      case (x: BitsType, y: BitsType) if x.signed == y.signed =>
        BitsType(Width.max(x.width, y.width), x.signed)
      case (VectorType(n, x), VectorType(m, y)) if n == m => VectorType(n, join(x, y))
      case _ if a == b => a
      case _ => fail(s"Incompatible Mux branches: $a and $b")
    }

    private def typed(e: Expr): TypedExpr = e match {
      case Checked(value, condition) =>
        val v = typed(value); val c = typed(condition)
        if (c.tpe != BooleanType) fail("Definedness condition must be Bool")
        TypedExpr("checked", v.tpe, List(v, c))
      case Ref(n) => resolve(n)
      case Lit(v, t) =>
        typeRequirements(t).foreach(requireDomain)
        t match {
          case BitsType(w, false) => requireDomain(POp("fitsUnsigned", List(v, w)))
          case BitsType(w, true) => requireDomain(POp("fitsSigned", List(v, w)))
          case _ =>
        }
        TypedExpr("literal", t, params = List(v))
      case HostBool(v) => TypedExpr("parameter", BooleanType, params = List(v))
      case Undefined(n) => fail(s"Unconnected combinational signal $n")
      case Resize(v, t) => coerce(typed(v), t)
      case Choose(c, a, b) =>
        val cond = typed(c)
        if (cond.tpe != BooleanType) fail("when/if/Mux condition must be Bool")
        val sourceCondition = c match { case HostBool(p) => Some(p); case _ => None }
        val left = sourceCondition.map(p => underGuard(p)(typed(a))).getOrElse(typed(a))
        val right = sourceCondition.map(p => underGuard(POp("!", List(p)))(typed(b))).getOrElse(typed(b))
        val t = (sourceCondition, left.tpe, right.tpe) match {
          case (Some(p), BitsType(x, sx), BitsType(y, sy)) if sx == sy && x != y => BitsType(ParamSimplify(PIf(p, x, y)), sx)
          case _ => join(left.tpe, right.tpe)
        }
        TypedExpr("mux", t, List(cond, coerce(left, t), coerce(right, t)))
      case VecGet(v, index) => typed(v).tpe match {
        case VectorType(size, elem) =>
          requireDomain(POp("&&", List(POp(">=", List(index, PInt(0))), POp("<", List(index, size)))))
          TypedExpr("vecGet", elem, List(typed(v)), params = List(index))
        case _ => fail("Vec selection requires a vector")
      }
      case VecSet(v, index, rhs) =>
        val arr = typed(v)
        arr.tpe match {
          case VectorType(size, elem) =>
            requireDomain(POp("&&", List(POp(">=", List(index, PInt(0))), POp("<", List(index, size)))))
            TypedExpr("vecSet", arr.tpe, List(arr, coerce(typed(rhs), elem)), params = List(index))
          case _ => fail("Vec update requires a vector")
        }
      case VecMap(index, size, v) =>
        val previous = boundIndices
        boundIndices += index -> size
        val value = try typed(v) finally { boundIndices = previous }
        def typeNames(t: HWType): Set[String] = t match {
          case BitsType(w, _) => ParamSimplify.names(w)
          case VectorType(n, e) => ParamSimplify.names(n) ++ typeNames(e)
          case _ => Set.empty
        }
        if (typeNames(value.tpe)(index)) fail("Vec elements must have a uniform width independent of the generate index")
        TypedExpr("vecMap", VectorType(size, value.tpe), List(value), name = index)
      case VecValues(values) =>
        if (values.isEmpty) fail("VecInit requires a nonempty sequence")
        val items = values.map(typed)
        val elem = items.map(_.tpe).reduce(join)
        TypedExpr("vecValues", VectorType(PInt(items.size), elem), items.map(coerce(_, elem)))
      case VecGetDynamic(value, index) =>
        val arr = typed(value); val i = typed(index)
        arr.tpe match {
          case VectorType(size, elem) if !Width.bits(i.tpe).signed =>
            requireDomain(POp(">", List(size, PInt(0))))
            TypedExpr("vecGetDynamic", elem, List(arr, i), params = List(size))
          case _ => fail("Dynamic Vec reads require a UInt index and a nonempty Vec")
        }
      case VecSetDynamic(value, index, rhs) =>
        val arr = typed(value); val i = typed(index)
        arr.tpe match {
          case VectorType(size, elem) if !Width.bits(i.tpe).signed =>
            requireDomain(POp(">", List(size, PInt(0))))
            TypedExpr("vecSetDynamic", arr.tpe, List(arr, i, coerce(typed(rhs), elem)), params = List(size))
          case _ => fail("Dynamic Vec writes require a UInt index and a nonempty Vec")
        }
      case Prim(op, arguments, params) =>
        val args = arguments.map(typed)
        if (op == "muxLookup") {
          val keyWidth = Width.bits(args.head.tpe).width
          val keys = args.drop(2).grouped(2).map(_.head).filter(_.kind == "literal").map(_.params.head).toList
          val complete = POp("lookupComplete", keyWidth :: keys)
          val values = args.drop(3).grouped(2).map(_.head).toList
          val mappedType = if (values.isEmpty) args(1).tpe else values.map(_.tpe).reduce(join)
          val joined = join(mappedType, args(1).tpe)
          val tpe = (mappedType, joined) match {
            case (BitsType(w, s), BitsType(j, _)) => BitsType(ParamSimplify(PIf(complete, w, j)), s)
            case _ => joined
          }
          val fallback = Choose(HostBool(complete), if (values.nonEmpty) arguments(3) else arguments(1), arguments(1))
          val body = arguments.drop(2).grouped(2).foldLeft[Expr](fallback) { (tail, kv) =>
            if (kv.size != 2) fail("MuxLookup has an incomplete key/value pair")
            Choose(Prim("eq", List(arguments.head, kv.head)), kv(1), tail)
          }
          return coerce(typed(body), tpe)
        }
        def unary = Width.bits(args.head.tpe)
        def binary: (BitsType, BitsType) = {
          if (args.size != 2) fail(s"$op requires two operands")
          val a = Width.bits(args.head.tpe)
          val b = Width.bits(args(1).tpe)
          if (a.signed != b.signed) fail("Mixed UInt/SInt arithmetic must use an explicit cast")
          (a, b)
        }
        val tpe: HWType = op match {
          case "add" | "sub" | "and" | "or" | "xor" | "addWide" | "subWide" | "mul" =>
            val (a, b) = binary
            if (Set("add", "sub", "addWide", "subWide")(op))
              requireDomain(POp("<=", List(Width.add(Width.max(a.width, b.width), PInt(1)), PInt(2147483647))))
            val w = if (op == "mul") Width.add(a.width, b.width)
                    else if (op.endsWith("Wide")) Width.add(Width.max(a.width, b.width), PInt(1))
                    else Width.max(a.width, b.width)
            if ((op == "and" || op == "or" || op == "xor") && args.forall(_.tpe == BooleanType)) BooleanType
            else BitsType(w, a.signed)
          case "eq" | "ne" | "lt" | "le" | "gt" | "ge" => binary; BooleanType
          case "sameVecIndex" => BooleanType
          case "div" | "rem" =>
            val (a, b) = binary
            BitsType(if (op == "rem") POp("min", List(a.width, b.width))
              else if (a.signed) Width.add(a.width, PInt(1)) else a.width, a.signed)
          case "notBool" =>
            if (args.size != 1 || (!args.head.tpe.isInstanceOf[BitsType] && args.head.tpe != BooleanType)) fail("Logical negation requires a scalar")
            BooleanType
          case "andBool" | "orBool" =>
            if (!args.forall(_.tpe == BooleanType)) fail("Logical operation requires Bool operands")
            BooleanType
          case "not" => if (args.head.tpe == BooleanType) BooleanType else unary
          case "neg" =>
            requireDomain(POp("<=", List(Width.add(Width.max(unary.width, PInt(1)), PInt(1)), PInt(2147483647))))
            BitsType(Width.max(unary.width, PInt(1)), unary.signed)
          case "shl" =>
            val amount = if (params.nonEmpty) {
              requireDomain(POp(">=", List(params.head, PInt(0))))
              params.head
            } else {
              val shift = Width.bits(args(1).tpe)
              if (shift.signed) fail("Dynamic shift amount must be UInt")
              requireDomain(POp("<", List(shift.width, PInt(31))))
              POp("-", List(POp("pow2", List(shift.width)), PInt(1)))
            }
            BitsType(Width.add(unary.width, amount), unary.signed)
          case "shr" =>
            if (params.nonEmpty) {
              requireDomain(POp(">=", List(params.head, PInt(0))))
              BitsType(POp("max", List(PInt(if (unary.signed) 1 else 0), POp("-", List(unary.width, params.head)))), unary.signed)
            } else unary
          case "asUInt" => BitsType(unary.width)
          case "asSInt" => BitsType(unary.width, signed = true)
          case "asBool" =>
            requireDomain(POp("==", List(unary.width, PInt(1))))
            BooleanType
          case "slice" =>
            val hi = params.head
            val lo = params(1)
            List(POp(">=", List(lo, PInt(0))), POp(">=", List(hi, lo)), POp("<", List(hi, unary.width))).foreach(requireDomain)
            BitsType(Width.add(POp("-", List(hi, lo)), PInt(1)))
          case "bit" =>
            List(POp(">=", List(params.head, PInt(0))), POp("<", List(params.head, unary.width))).foreach(requireDomain)
            BooleanType
          case "cat" => BitsType(args.map(x => Width.bits(x.tpe).width).foldLeft[ParamExpr](PInt(0))(Width.add))
          case "orR" | "andR" | "xorR" => BooleanType
          case "pad" =>
            requireDomain(POp(">=", List(params.head, PInt(0))))
            BitsType(Width.max(unary.width, params.head), unary.signed)
          case "head" | "tail" =>
            List(POp(">=", List(params.head, PInt(0))), POp("<=", List(params.head, unary.width))).foreach(requireDomain)
            BitsType(if (op == "head") params.head else POp("-", List(unary.width, params.head)))
          case "fill" =>
            requireDomain(POp(">=", List(params.head, PInt(0))))
            BitsType(POp("*", List(unary.width, params.head)))
          case other => fail(s"Unsupported IR operation $other")
        }
        tpe match {
          case BitsType(w, _) =>
            requireDomain(POp(">=", List(w, PInt(0))))
            requireDomain(POp("<=", List(w, PInt(2147483647))))
          case _ =>
        }
        TypedExpr(op, tpe, args, params = params)
    }

    private def typeRequirements(t: HWType): List[ParamExpr] = t match {
      case BitsType(w, signed) => List(POp(">=", List(w, PInt(if (signed) 1 else 0))), POp("<=", List(w, PInt(2147483647))))
      case VectorType(n, elem) => POp(">=", List(n, PInt(0))) :: typeRequirements(elem)
      case _ => Nil
    }

    def run(): Normalized = {
      if (byName.size != m.signals.size) fail("Duplicate flattened signal names")
      m.signals.foreach { s =>
        expressions(s.name) = if (s.kind == "reg" || s.kind == "input") Ref(s.name)
                             else s.init.map(x => Resize(x, s.tpe)).getOrElse(Undefined(s.name))
      }
      m.signals.filter(s => s.tpe == InferType && s.init.nonEmpty).foreach { s =>
        location = s.source
        val tpe = typed(s.init.get).tpe
        byName(s.name) = s.copy(tpe = tpe)
      }
      resolved.clear()
      process(m.statements, expressions)
      // FIRRTL width constraints include overridden connects and reset literals.
      // Solve monotone scalar width equations from their smallest legal widths.
      val unknown = m.signals.filter(_.tpe.isInstanceOf[InferBits])
      unknown.foreach { s => val signed = s.tpe.asInstanceOf[InferBits].signed
        inferredTypes(s.name) = BitsType(PInt(if (signed) 1 else 0), signed)
      }
      val constraints = mutable.Map.empty[String, List[Expr]]
      def collect(xs: List[Statement], guard: ParamExpr = PBool(true)): Unit = xs.foreach {
        case Assign(name, None, rhs, _) if byName(name).tpe.isInstanceOf[InferBits] =>
          val signed = byName(name).tpe.asInstanceOf[InferBits].signed
          val bottom = Lit(PInt(0), BitsType(PInt(if (signed) 1 else 0), signed))
          val candidate = if (guard == PBool(true)) rhs else Choose(HostBool(guard), rhs, bottom)
          constraints(name) = candidate :: constraints.getOrElse(name, Nil)
        case Branch(HostBool(p), a, b, _) =>
          collect(a, POp("&&", List(guard, p))); collect(b, POp("&&", List(guard, POp("!", List(p)))))
        case Branch(_, a, b, _) => collect(a, guard); collect(b, guard)
        case Generate(_, _, _, body, _) => collect(body, guard)
        case _ =>
      }
      collect(m.statements)
      unknown.foreach(s => constraints(s.name) = s.init.toList ++ constraints.getOrElse(s.name, Nil))
      val checkpoint = extraRequirements.size
      var stable = unknown.isEmpty
      var iteration = 0
      solvingWidths = true
      while (!stable && iteration < unknown.size + 4) {
        resolved.clear()
        val before = inferredTypes.toMap
        val candidates = unknown.map { s =>
          location = s.source
          val types = constraints(s.name).map(typed(_).tpe)
          s.name -> types.foldLeft(before(s.name))(join)
        }
        candidates.foreach { case (n, t) => inferredTypes(n) = t }
        stable = unknown.forall(s => before(s.name) == inferredTypes(s.name))
        iteration += 1
      }
      solvingWidths = false
      if (!stable) fail("Width inference does not converge; use an explicit width for expanding feedback")
      extraRequirements.dropRightInPlace(extraRequirements.size - checkpoint)
      resolved.clear()
      def audit(xs: List[Statement]): Unit = xs.foreach {
        case Assign(name, index, rhs, src) =>
          location = src
          typed(rhs)
          index.foreach { i => byName(name).tpe match {
            case VectorType(n, _) => requireDomain(POp("&&", List(POp(">=", List(i, PInt(0))), POp("<", List(i, n)))))
            case _ =>
          } }
        case DynamicAssign(_, i, rhs, src) => location = src; typed(i); typed(rhs)
        case IndexedAssign(name, indices, rhs, src) =>
          location = src
          typed(rhs)
          indices.foldLeft(byName(name).tpe) { (tpe, index) => tpe match {
            case VectorType(n, element) =>
              index match {
                case StaticIndex(i) => requireDomain(POp("&&", List(POp(">=", List(i, PInt(0))), POp("<", List(i, n)))))
                case DynamicIndex(i) => typed(i)
              }
              element
            case _ => fail(s"Too many vector indices in connection to $name")
          } }
        case Branch(HostBool(p), a, b, _) => underGuard(p)(audit(a)); underGuard(POp("!", List(p)))(audit(b))
        case Branch(c, a, b, src) => location = src; typed(c); audit(a); audit(b)
        case Generate(i, start, end, body, _) =>
          val previous = boundIndices
          boundIndices += i -> end
          try underGuard(POp(">=", List(PName(i), start)))(audit(body)) finally { boundIndices = previous }
      }
      audit(m.statements)
      // Verify every declared combinational signal, even one unused at the interface.
      m.signals.filterNot(s => s.kind == "reg" || s.kind == "input").foreach(s => resolve(s.name))
      val signals = m.signals.map(s => s.copy(tpe = signalType(s.name)))
      val next = signals.filter(_.kind == "reg").map { s =>
        location = s.source
        s -> coerce(typed(expressions(s.name)), s.tpe)
      }
      val outputs = signals.filter(_.kind == "output").map(s => s -> resolve(s.name))
      val resets = signals.filter(_.kind == "reg").flatMap(s => s.init.map(v => s -> coerce(typed(v), s.tpe)))
      val domain = m.parameters.filter(_.kind == "Int").flatMap(p => List(
        POp(">=", List(PName(p.name), PInt(BigInt(-2147483648L)))),
        POp("<=", List(PName(p.name), PInt(BigInt(2147483647L))))))
      val requirements = (domain ++ m.requirements ++ signals.flatMap(s => typeRequirements(s.tpe)) ++ extraRequirements).map(ParamSimplify(_)).distinct.filterNot(_ == PBool(true))
      if (requirements.contains(PBool(false))) fail("The source has an unsatisfiable constant legality condition")
      Normalized(m, signals, next, outputs, resets, requirements)
    }
  }
}
