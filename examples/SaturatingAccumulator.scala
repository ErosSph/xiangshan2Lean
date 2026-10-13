package walkthrough

import chisel3._

/** Accumulate with saturation; remember overflow until clear or reset. */
class SaturatingAccumulator(val w: Int) extends Module {
  require(w > 0)

  val en = IO(Input(Bool()))
  val clear = IO(Input(Bool()))
  val data = IO(Input(UInt(w.W)))
  val value = IO(Output(UInt(w.W)))
  val overflow = IO(Output(Bool()))

  val acc = RegInit(0.U(w.W))
  val seenOverflow = RegInit(false.B)
  val sum = acc +& data

  when(clear) {
    acc := 0.U(w.W)
    seenOverflow := false.B
  }.elsewhen(en) {
    when(sum(w)) {
      acc := ~0.U(w.W)
      seenOverflow := true.B
    }.otherwise {
      acc := sum(w - 1, 0)
    }
  }

  value := acc
  overflow := seenOverflow
}
