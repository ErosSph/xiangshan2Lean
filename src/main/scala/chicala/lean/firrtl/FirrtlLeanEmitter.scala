package chicala.lean.firrtl

import java.util.IdentityHashMap
import scala.collection.mutable
import chicala.lean.ir.{Normalized, TypedExpr}
import chicala.lean.backend.LeanEmitter

/** Preserve the normalized expression DAG in Lean instead of duplicating whole
  * subcircuits at every reference. The serialized semantic IR remains unchanged.
  * Helpers are pure definitions with the same input/old-state arguments.
  */
object FirrtlLeanEmitter {
  def emit(n: Normalized, contract: String,
           provenance: String = "FIRRTL 1.5.6 frontend; Lean 4.19.0; IR v2; expression DAG."): String = {
    val ids = new IdentityHashMap[TypedExpr, String]()
    val seen = new IdentityHashMap[TypedExpr, java.lang.Boolean]()
    val nodes = mutable.ListBuffer.empty[TypedExpr]
    val leaves = Set("input", "reg", "literal", "parameter")
    def collect(e: TypedExpr): Unit = if (!seen.containsKey(e)) {
      seen.put(e, true)
      e.args.foreach(collect)
      if (!leaves(e.kind)) {
        ids.put(e, "c2lFirrtlNode" + nodes.size)
        nodes += e
      }
    }
    (n.next ++ n.outputs ++ n.resets).foreach(x => collect(x._2))
    def reference(e: TypedExpr): TypedExpr =
      if (ids.containsKey(e)) TypedExpr("namedExpr", e.tpe, List(e), name = ids.get(e)) else e
    val helpers = nodes.map { e =>
      val expression = e.copy(args = e.args.map(reference))
      s"def ${ids.get(e)} (p : Params) (inputs : Inputs p) (state : State p) : ${LeanEmitter.hwType(e.tpe)} :=\n  ${LeanEmitter.expression(expression)}\n\n"
    }.mkString
    val shared = n.copy(next = n.next.map { case (s, e) => s -> reference(e) },
      outputs = n.outputs.map { case (s, e) => s -> reference(e) },
      resets = n.resets.map { case (s, e) => s -> reference(e) })
    val base = LeanEmitter.emit(shared, provenance, Some(contract))
    val index = base.indexOf("def step (")
    require(index >= 0, "Lean backend entry point changed")
    base.substring(0, index) + helpers + base.substring(index)
  }
}
