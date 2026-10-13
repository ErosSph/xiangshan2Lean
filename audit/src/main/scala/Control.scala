package probes
import chisel3._

class ConditionalPriority(w: Int) extends Module {
  require(w > 0)
  val a = IO(Input(Bool()))
  val b = IO(Input(Bool()))
  val c = IO(Input(Bool()))
  val combinational = IO(Output(UInt(w.W)))
  val sequential = IO(Output(UInt(w.W)))
  val r = RegInit(0.U(w.W))
  val value = Wire(UInt(w.W))
  when(a) { value := 1.U }
    .elsewhen(b) { value := 2.U }
    .otherwise { value := 3.U }
  when(a) {
    when(b) { r := 1.U }.otherwise { r := 2.U }
  }.elsewhen(c) { r := 3.U }
    .otherwise { r := r + 1.U }
  combinational := value
  sequential := r
}
