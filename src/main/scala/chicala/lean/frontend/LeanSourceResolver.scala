package chicala.lean.frontend

import scala.tools.nsc.Global
import scala.collection.mutable
import chicala.lean.ir.{Source, TranslationError}
import chicala.lean.backend.Json

/** Source-level inheritance and CDE projection, before the legacy AST reader.
  * No concrete configuration values enter hardware expressions here.
  */
trait LeanSourceResolver {
  val global: Global
  import global._

  private val sourceClasses = mutable.LinkedHashMap.empty[String, ClassDef]
  def registerLeanSources(tree: Tree): Unit = new Traverser {
    override def traverse(t: Tree): Unit = {
      t match {
        case c: ClassDef if c.symbol != NoSymbol => sourceClasses(c.symbol.fullName) = c
        case _ =>
      }
      super.traverse(t)
    }
  }.traverse(tree)

  case class ResolvedLeanSource(tree: ClassDef, metadata: String)
  def resolveLeanSource(root: ClassDef): ResolvedLeanSource = new Resolver(root).run()

  private class Resolver(root: ClassDef) {
    private def origin(t: Tree): Source = {
      val p = if (t.pos.isDefined) t.pos else root.pos
      Source(p.source.file.path, p.line, p.column + 1)
    }
    private def fail(t: Tree, message: String): Nothing = throw TranslationError(origin(t), message)
    private def clean(n: Name): String = n.decodedName.toString.trim
    private def validType(t: Type): Boolean = t != null && t != NoType
    private def cde(t: Type): Boolean = validType(t) && t.dealias.baseClasses.exists(_.fullName == "org.chipsalliance.cde.config.Parameters")
    private def kind(t: Type): Option[String] = if (!validType(t)) None else t.dealias.widen.toString match {
      case "Int" => Some("Int")
      case "Boolean" => Some("Bool")
      case _ => None
    }
    private def hardware(t: Type): Boolean = validType(t) && t.dealias.baseClasses.exists(s =>
      Set("chisel3.Data", "chisel3.RawModule", "chisel3.MemBase")(s.fullName))
    private val baseSymbols = root.symbol.asClass.baseClasses.takeWhile(s =>
      !Set("chisel3.Module", "chisel3.RawModule", "chisel3.Bundle")(s.fullName))
      .filterNot(s => s.fullName.startsWith("scala.") || s.fullName.startsWith("java."))
    private val bases = baseSymbols.map(s => sourceClasses.getOrElse(s.fullName,
      fail(root, s"Source of parent/trait ${s.fullName} is required; include it among translation sources")))
    private val baseNames = baseSymbols.map(_.fullName).toSet
    private def body(c: ClassDef): List[Tree] = c.impl.body
    private def ctor(c: ClassDef): DefDef = {
      val constructors = body(c).collect { case d: DefDef if d.name == termNames.CONSTRUCTOR => d }
      if (constructors.isEmpty && c.mods.isTrait)
        return DefDef(Modifiers(), termNames.CONSTRUCTOR, Nil, Nil, TypeTree(definitions.UnitTpe), EmptyTree).setPos(c.pos)
      if (constructors.size != 1) fail(c, "Inheritance requires one primary constructor; auxiliary constructors are unsupported")
      constructors.head
    }
    private val rootParams = ctor(root).vparamss.flatten
    private val roots = rootParams.zipWithIndex.map { case (p, i) => clean(p.name) -> (p, i) }.toMap
    private val bound = mutable.Map.empty[(String, String), Tree]
    private val members = mutable.Map.empty[(String, String), Tree]
    private val selected = mutable.LinkedHashMap.empty[String, Tree]
    private val helpers = mutable.LinkedHashMap.empty[String, DefDef]
    private val usedGetters = mutable.LinkedHashSet.empty[(String, String)]
    private val requiredKeys = mutable.LinkedHashSet.empty[(String, String)]
    private case class Projection(name: String, kind: String, root: String, key: String, fields: List[String], source: Source)
    private val projections = mutable.LinkedHashMap.empty[(String, String, List[String]), Projection]
    private case class ConfigPath(root: String, key: String, fields: List[String])
    private val executionOrder = bases.reverse.flatMap(body)
    private val initializedAt = executionOrder.zipWithIndex.collect {
      case (v: ValDef, i) if !v.mods.isParamAccessor && v.rhs != EmptyTree =>
        (v.symbol.owner.fullName, clean(v.name)) -> i
    }.toMap
    private var currentInitialization = Int.MaxValue

    bases.foreach { c =>
      if (c.tparams.nonEmpty) fail(c, "Generic parent classes/traits are outside the inheritance subset")
      body(c).foreach {
        case v: ValDef if !v.mods.isParamAccessor && v.rhs != EmptyTree =>
          members((c.symbol.fullName, clean(v.name))) = v
          if (!selected.contains(clean(v.name))) selected(clean(v.name)) = v
        case d: DefDef if d.name != termNames.CONSTRUCTOR && !d.mods.hasAccessorFlag && !d.mods.isSynthetic =>
          members((c.symbol.fullName, clean(d.name))) = d
          if (!selected.contains(clean(d.name))) selected(clean(d.name)) = d
        case _ =>
      }
    }

    private def primaryCall(t: Tree): Option[(Symbol, List[Tree])] = {
      def unpack(t: Tree, args: List[Tree]): Option[(Symbol, List[Tree])] = t match {
        case Apply(f, as) => unpack(f, as ++ args)
        case TypeApply(f, _) => unpack(f, args)
        case s @ Select(_: Super, n) if n == termNames.CONSTRUCTOR => Some((s.symbol.owner, args))
        case _ => None
      }
      t match {
        case Block(stats, _) => stats.iterator.flatMap(x => unpack(x, Nil)).take(1).toList.headOption
        case _ => unpack(t, Nil)
      }
    }

    bases.foreach { c =>
      val constructor = ctor(c)
      constructor.vparamss.flatten.foreach { p =>
        if (body(c).exists {
          case v: ValDef => v.mods.isParamAccessor && v.mods.hasFlag(Flag.OVERRIDE) && clean(v.name) == clean(p.name)
          case d: DefDef => d.mods.hasAccessorFlag && d.mods.hasFlag(Flag.OVERRIDE) && clean(d.name) == clean(p.name)
          case _ => false
        }) fail(p, "Overridden constructor vals are outside the initialization subset")
        if (p.mods.isMutable || body(c).exists {
          case v: ValDef => v.mods.isParamAccessor && v.mods.isMutable && clean(v.name) == clean(p.name)
          case _ => false
        }) fail(p, "Mutable constructor parameters are unsupported")
      }
      primaryCall(constructor.rhs).foreach { case (parent, args) =>
        if (baseNames(parent.fullName)) {
          val params = ctor(sourceClasses(parent.fullName)).vparamss.flatten
          if (params.size != args.size) fail(constructor, "Cannot bind parent constructor arguments")
          params.zip(args).foreach { case (p, arg) => bound((parent.fullName, clean(p.name))) = arg }
        }
      }
    }

    private def owner(t: Tree): String = if (t.symbol == null || t.symbol == NoSymbol) "" else t.symbol.owner.fullName
    private def memberRef(t: Tree): Option[String] = t match {
      case Apply(f, Nil) => memberRef(f)
      case s @ Select(th: This, n) if baseNames(owner(s)) && baseNames(th.symbol.fullName) => Some(clean(n))
      case i: Ident if baseNames(owner(i)) => Some(clean(i.name))
      case _ => None
    }
    private def implementation(t: Tree): Option[Tree] = memberRef(t).flatMap { n =>
      val own = members.get((owner(t), n))
      if (own.exists(m => m.symbol.isPrivate || m.symbol.isFinal)) own
      else {
        val symbol = root.symbol.info.member(TermName(n))
        if (selected.get(n).exists(_.isInstanceOf[DefDef]) && symbol != NoSymbol && symbol.isOverloaded)
          fail(t, "Overloaded inherited methods are unsupported")
        selected.get(n)
      }
    }
    private def checkInitialization(t: Tree, seen: Set[Symbol] = Set.empty): Unit = {
      implementation(t) match {
        case Some(v: ValDef) =>
          if (initializedAt.getOrElse((v.symbol.owner.fullName, clean(v.name)), -1) >= currentInitialization)
            fail(t, "Member read before Scala initialization: " + clean(v.name))
        case Some(d: DefDef) if !seen(d.symbol) =>
          new Traverser { override def traverse(x: Tree): Unit = {
            checkInitialization(x, seen + d.symbol)
            super.traverse(x)
          } }.traverse(d.rhs)
        case _ =>
      }
    }

    private def expand(t: Tree, stack: Set[(String, String)] = Set.empty): Tree = {
      val name = memberRef(t)
      val binding = name.flatMap(n => bound.get((owner(t), n)))
      binding match {
        case Some(value) =>
          val tag = (owner(t), name.get)
          if (stack(tag)) fail(t, "Recursive parent constructor binding")
          expand(value, stack + tag)
        case None =>
          implementation(t) match {
            case Some(v: ValDef) if !hardware(v.tpt.tpe) =>
              if (v.mods.isMutable || v.mods.isLazy) fail(v, "Mutable/lazy host fields are unsupported")
              val tag = (v.symbol.owner.fullName, clean(v.name))
              if (stack(tag)) fail(t, "Recursive inherited value")
              usedGetters += tag
              expand(v.rhs, stack + tag)
            case Some(d: DefDef) if d.vparamss.flatten.isEmpty && d.rhs != EmptyTree =>
              val tag = (d.symbol.owner.fullName, clean(d.name))
              if (stack(tag)) fail(t, "Recursive inherited getter")
              usedGetters += tag
              expand(d.rhs, stack + tag)
            case _ => t
          }
      }
    }

    private def configRoot(t: Tree): Option[String] = {
      val x = expand(t)
      x match {
        case i: Ident if roots.contains(clean(i.name)) && cde(i.tpe) => Some(clean(i.name))
        case Select(th: This, n) if baseNames(th.symbol.fullName) && roots.contains(clean(n)) && cde(x.tpe) => Some(clean(n))
        case _ => None
      }
    }
    private def configPath(tree: Tree, stack: Set[(String, String)] = Set.empty): Option[ConfigPath] = {
      val t = expand(tree, stack)
      t match {
        case Typed(x, _) => configPath(x, stack)
        case Apply(TypeApply(s @ Select(p, n), _), List(key)) if clean(n) == "apply" && cde(p.tpe) =>
          val rootName = configRoot(p).getOrElse(fail(p, "CDE queries must use an unchanged constructor Parameters value"))
          if (key.symbol == null || key.symbol == NoSymbol || !key.symbol.isModule)
            fail(key, "CDE Field keys must be static singleton objects")
          Some(ConfigPath(rootName, key.symbol.fullName, Nil))
        case Apply(s @ Select(p, n), List(key)) if clean(n) == "apply" && cde(p.tpe) =>
          configPath(Apply(TypeApply(s, Nil), List(key)).setType(t.tpe).setPos(t.pos), stack)
        case Select(from, n) if t.symbol != null && t.symbol != NoSymbol && t.symbol.isAccessor &&
            t.symbol.owner.isClass && t.symbol.owner.asClass.isCaseClass =>
          configPath(from, stack).map(p => p.copy(fields = p.fields :+ clean(n)))
        case _ => None
      }
    }
    private def project(t: Tree, p: ConfigPath, k: String): Tree = {
      val id = (p.root, p.key, p.fields)
      val entry = projections.getOrElseUpdate(id, {
        val name = ("cfg" :: p.root :: p.key.split('.').toList ::: p.fields).mkString("_")
        if (!name.matches("[a-zA-Z_][a-zA-Z0-9_]*") || roots.contains(name) || selected.contains(name))
          fail(t, "Configuration parameter name collision or unsupported identifier: " + name)
        if (projections.values.exists(_.name == name)) fail(t, "Ambiguous configuration field name: " + name)
        Projection(name, k, p.root, p.key, p.fields, origin(t))
      })
      requiredKeys += ((p.root, p.key))
      Ident(TermName(entry.name)).setType(t.tpe).setPos(t.pos)
    }

    private object Lower extends Transformer {
      private var active = Set.empty[(String, String)]
      override def transform(original: Tree): Tree = {
        original match {
          case d: DefDef if d.name == termNames.CONSTRUCTOR => return d
          case s: Super => fail(s, "Explicit super dispatch is outside the inheritance subset")
          case _ =>
        }
        checkInitialization(original)
        val t = expand(original, active)
        val tag = if (t eq original) None else memberRef(original).map { n =>
          implementation(original).map(m => (m.symbol.owner.fullName, n)).getOrElse((owner(original), n))
        }
        val previous = active
        active ++= tag
        try lower(original, t) finally { active = previous }
      }
      private def lower(original: Tree, t: Tree): Tree = {
        configPath(t) match {
          case Some(p) => kind(t.tpe) match {
            case Some(k) => return project(t, p, k)
            case None => fail(original, "CDE values used by hardware must end in an Int/Boolean case-class field")
          }
          case _ =>
        }
        implementation(t) match {
          case Some(d: DefDef) if d.vparamss.flatten.nonEmpty =>
            val n = clean(d.name)
            if (helpers.get(n).exists(_.symbol != d.symbol)) fail(t, "Inherited helper name collision: " + n)
            helpers(n) = d
          case _ =>
        }
        t match {
          case th: This if baseNames(th.symbol.fullName) =>
            treeCopy.This(th, root.name).setSymbol(root.symbol).setType(root.symbol.tpe)
          case i: Ident if roots.contains(clean(i.name)) && cde(i.tpe) =>
            fail(i, "Parameters objects cannot be passed to arbitrary code; use static CDE field projections")
          case _ => super.transform(t)
        }
      }
    }

    def run(): ResolvedLeanSource = {
      rootParams.foreach { p => if (kind(p.tpt.tpe).isEmpty && !cde(p.tpt.tpe))
        fail(p, "Constructor parameters must be Int, Boolean, or real CDE Parameters") }
      // Overridden vals have Scala initialization hazards; never model them as
      // virtual defs or discard an earlier hardware allocation.
      bases.flatMap(body).collect { case v: ValDef if !v.mods.isParamAccessor && v.rhs != EmptyTree => v }.groupBy(v => clean(v.name)).foreach {
        case (_, values) if values.size > 1 => fail(values.head, "Overridden or shadowed concrete vals are unsupported; use def for pure parameter getters")
        case _ =>
      }
      val statements = bases.reverse.flatMap { c => body(c).flatMap {
        case _: DefDef => Nil
        case _: TypeDef | _: Import => Nil
        case v: ValDef if v.mods.isParamAccessor => Nil
        case v: ValDef if v.rhs == EmptyTree => Nil
        case v: ValDef if !hardware(v.tpt.tpe) && kind(v.tpt.tpe).isEmpty =>
          currentInitialization = executionOrder.indexOf(v)
          checkInitialization(v.rhs)
          if (c != root && cdeRootIn(v.rhs))
            fail(v, "Eager inherited configuration vals may read uninitialized Parameters; use def")
          configPath(v.rhs) match {
            case Some(p) => requiredKeys += ((p.root, p.key)); Nil
            case None => fail(v, "Non-scalar inherited host values must be immutable CDE record aliases")
          }
        case v: ValDef if !hardware(v.tpt.tpe) && c != root && cdeRootIn(v.rhs) =>
          fail(v, "Eager inherited configuration vals may read uninitialized Parameters; use def")
        case t if t == EmptyTree => Nil
        case t =>
          currentInitialization = executionOrder.indexOf(t)
          List(Lower.transform(t))
      } }
      currentInitialization = Int.MaxValue
      val functions = mutable.ListBuffer.empty[Tree]
      val done = mutable.Set.empty[String]
      while (helpers.keys.exists(n => !done(n))) {
        val name = helpers.keys.find(n => !done(n)).get
        done += name
        val d = helpers(name)
        functions += treeCopy.DefDef(d, d.mods, d.name, d.tparams, d.vparamss, d.tpt, Lower.transform(d.rhs))
      }
      val configParams = projections.values.toList.map { p =>
        ValDef(Modifiers(Flag.PARAM), TermName(p.name), TypeTree(if (p.kind == "Int") definitions.IntTpe else definitions.BooleanTpe), EmptyTree).setPos(root.pos)
      }
      val plainParams = rootParams.filterNot(p => cde(p.tpt.tpe))
      val constructor = ctor(root)
      val loweredCtor = treeCopy.DefDef(constructor, constructor.mods, constructor.name, constructor.tparams,
        List(plainParams ++ configParams), constructor.tpt, constructor.rhs)
      val fields = (plainParams ++ configParams).map(p => treeCopy.ValDef(p, Modifiers(Flag.PARAMACCESSOR), p.name, p.tpt, EmptyTree))
      val result = treeCopy.ClassDef(root, root.mods, root.name, root.tparams,
        treeCopy.Template(root.impl, root.impl.parents, root.impl.self, fields ++ List(loweredCtor) ++ functions.toList ++ statements))
      val metadata = Json.obj(
        "system" -> Json.str(if (rootParams.exists(p => cde(p.tpt.tpe))) "CDE" else "Scala-inheritance"),
        "inheritance" -> Json.arr(baseSymbols.map(s => Json.str(s.fullName))),
        "constructor" -> Json.arr(rootParams.zipWithIndex.map { case (p, index) => Json.obj(
          "name" -> Json.str(clean(p.name)), "index" -> index.toString,
          "type" -> Json.str(p.tpt.tpe.toString), "kind" -> Json.str(if (cde(p.tpt.tpe)) "configuration" else kind(p.tpt.tpe).get)) }),
        "fields" -> Json.arr(projections.values.map(p => Json.obj(
          "name" -> Json.str(p.name), "kind" -> Json.str(p.kind), "root" -> Json.str(p.root),
          "key" -> Json.str(p.key), "selectors" -> Json.arr(p.fields.map(Json.str)), "source" -> Json.source(p.source)))),
        "required_keys" -> Json.arr(requiredKeys.map { case (r, k) => Json.obj("root" -> Json.str(r), "key" -> Json.str(k)) }),
        "getters" -> Json.arr(usedGetters.map { case (o, n) => Json.str(o + "." + n) }),
        "sources" -> Json.arr(bases.map(c => Json.source(origin(c)))))
      ResolvedLeanSource(result, metadata)
    }

    private def cdeRootIn(t: Tree): Boolean = {
      var found = false
      val seen = mutable.Set.empty[Symbol]
      new Traverser { override def traverse(t: Tree): Unit = {
        if (configRoot(t).nonEmpty || configPath(t).nonEmpty) found = true
        implementation(t).foreach {
          case d: DefDef if !seen(d.symbol) => seen += d.symbol; traverse(d.rhs)
          case v: ValDef if !hardware(v.tpt.tpe) && !seen(v.symbol) => seen += v.symbol; traverse(v.rhs)
          case _ =>
        }
        super.traverse(t)
      } }.traverse(t)
      found
    }
  }
}
