package example

import chisel3._
import chisel2lean.LeanParam

class Counter(@LeanParam val n: Int) extends Module {
  require(n > 0)
  val en = IO(Input(Bool()))
  val out = IO(Output(UInt(n.W)))
  val count = RegInit(0.U(n.W))
  when(en) { count := count + 1.U }
  out := count
}
