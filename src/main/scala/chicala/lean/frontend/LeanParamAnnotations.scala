package chicala.lean.frontend

import scala.tools.nsc.Global
import scala.collection.mutable
import chicala.lean.ir.{Source, TranslationError}

/** Read typed annotation symbols, including Scala's constructor/accessor copies. */
trait LeanParamAnnotations {
  val global: Global
  import global._

  private val annotationName = "chisel2lean.LeanParam"
  private def annotations(t: Tree): List[AnnotationInfo] =
    if (!t.isInstanceOf[DefTree] || t.symbol == null || t.symbol == NoSymbol) Nil
    else t.symbol.annotations.filter(a => a.atp.typeSymbol.fullName == annotationName)

  private def annotatedType(t: Tree): Boolean = {
    def marked(tp: Type): Boolean = tp != null && tp != NoType && (tp match {
      case AnnotatedType(as, underlying) => as.exists(_.atp.typeSymbol.fullName == annotationName) || marked(underlying)
      case _ => tp.typeArgs.exists(marked)
    })
    t.isInstanceOf[TypeTree] && marked(t.tpe)
  }

  def containsLeanParam(tree: Tree): Boolean = {
    var found = false
    new Traverser {
      override def traverse(t: Tree): Unit = {
        if (annotations(t).nonEmpty || annotatedType(t)) found = true
        if (!found) super.traverse(t)
      }
    }.traverse(tree)
    found
  }

  case class LeanParamDeclaration(owner: String, name: String, kind: String, role: String,
                                  source: Source, definition: Tree)
  case class LeanParamBinding(owner: String, name: String, kind: String, role: String,
                              source: Source, alias: String)

  def leanParamDeclarations(c: ClassDef): List[LeanParamDeclaration] = {
    def clean(n: Name): String = n.decodedName.toString.trim
    def source(t: Tree): Source = {
      val p = if (t.pos.isDefined) t.pos else c.pos
      Source(p.source.file.path, p.line, p.column + 1)
    }
    def fail(t: Tree, message: String): Nothing = throw TranslationError(source(t), "@LeanParam " + message)
    def kind(t: Type, at: Tree): String = {
      if (t == null || t == NoType) fail(at, "requires a typed Int or Boolean scalar")
      t.dealias.widen match {
        case x if x =:= definitions.IntTpe => "Int"
        case x if x =:= definitions.BooleanTpe => "Bool"
        case _ => fail(at, "supports Int and Boolean scalars; found " + t)
      }
    }
    val constructors = c.impl.body.collect { case d: DefDef if d.name == termNames.CONSTRUCTOR => d }
    val params = constructors.filter(_.symbol.isPrimaryConstructor).flatMap(_.vparamss.flatten)
    val fields = c.impl.body.collect { case v: ValDef => v }
    val ctorFields = fields.filter(_.mods.isParamAccessor).map(v => clean(v.name) -> v).toMap
    val direct = c.impl.body.toSet
    val result = mutable.LinkedHashMap.empty[(String, String), LeanParamDeclaration]

    def add(t: Tree, name: String, tpe: Type, role: String, definition: Tree): Unit = {
      val key = (role, name)
      if (!result.contains(key)) result(key) = LeanParamDeclaration(c.symbol.fullName,
        name, kind(tpe, t), role, source(t), definition)
    }
    new Traverser {
      override def traverse(t: Tree): Unit = {
        // A nested hardware class is validated when it enters the selected source graph.
        if (t.isInstanceOf[ClassDef] && t != c) return
        if (annotatedType(t)) fail(t, "must annotate a declaration rather than a type use")
        val marks = annotations(t)
        if (marks.nonEmpty) {
          if (marks.size != 1) fail(t, "must appear only once on a declaration")
          t match {
            case v: ValDef if params.contains(v) =>
              val name = clean(v.name)
              if (v.mods.isMutable || ctorFields.get(name).exists(_.mods.isMutable))
                fail(v, "cannot mark a mutable constructor parameter")
              add(v, name, v.tpt.tpe, "constructor", v)
            case v: ValDef if direct(v) && v.mods.isParamAccessor && params.exists(p => clean(p.name) == clean(v.name)) =>
              if (v.mods.isMutable) fail(v, "cannot mark a mutable constructor parameter")
              val param = params.find(p => clean(p.name) == clean(v.name)).get
              add(v, clean(v.name), v.tpt.tpe, "constructor", param)
            case d: DefDef if direct(d) && d.mods.hasAccessorFlag =>
              // Accessor annotations duplicate their source val/constructor annotation.
              val name = clean(d.name)
              fields.find(v => clean(v.name) == name) match {
                case Some(v) if v.mods.isMutable => fail(v, "cannot mark a mutable member")
                case Some(v) if v.mods.isParamAccessor =>
                  val param = params.find(p => clean(p.name) == name).getOrElse(fail(d, "has no primary constructor parameter"))
                  add(d, name, d.tpt.tpe, "constructor", param)
                case Some(v) if v.mods.isLazy => fail(v, "cannot mark a lazy member")
                case Some(v) => add(v, name, v.tpt.tpe, "member", v)
                case None => fail(d, "requires a source val or parameterless def")
              }
            case v: ValDef if direct(v) =>
              if (v.mods.isMutable || v.mods.isLazy) fail(v, "cannot mark a mutable or lazy member")
              if (v.rhs == EmptyTree) fail(v, "requires an initialized val; use a parameterless def for an abstract getter")
              add(v, clean(v.name), v.tpt.tpe, "member", v)
            case d: DefDef if direct(d) && d.name != termNames.CONSTRUCTOR &&
                d.vparamss.flatten.isEmpty && d.tparams.isEmpty =>
              add(d, clean(d.name), d.tpt.tpe, "member", d)
            case _ => fail(t, "must mark a primary constructor parameter, immutable scalar member val, or parameterless scalar def")
          }
        }
        super.traverse(t)
      }
    }.traverse(c)
    result.values.toList
  }
}
