package leanparam.lookalike {
  final class LeanParam extends scala.annotation.StaticAnnotation
}
package leanparam {
  import chisel3._
  class IgnoredLookalike(n: Int) extends Module {
    require(n > 0)
    @lookalike.LeanParam val literal: Int = 4
    val data = IO(Input(UInt(n.W)))
    val out = IO(Output(UInt(n.W)))
    out := data + literal.U
  }
}
