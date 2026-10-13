package probes
import chisel3._
import chisel3.util._

class MuxPriorities(val w: Int) extends RawModule {
  require(w >= 2)
  val a = IO(Input(UInt(w.W)))
  val b = IO(Input(UInt(w.W)))
  val c = IO(Input(UInt(w.W)))
  val sel = IO(Input(UInt(2.W)))
  val x = IO(Input(Bool()))
  val y = IO(Input(Bool()))
  val lookup = IO(Output(UInt(w.W)))
  val muxcase = IO(Output(UInt(w.W)))
  val priority = IO(Output(UInt(w.W)))
  val widthCheck = IO(Output(UInt((w + 1).W)))
  lookup := MuxLookup(sel, 0.U)(Seq(0.U -> a, 0.U -> b, 1.U -> c))
  muxcase := MuxCase(c, Seq(x -> a, y -> b))
  priority := PriorityMux(Seq(x -> a, y -> b, true.B -> c))
  val exhaustive = MuxLookup(sel, 255.U(8.W))(Seq(0.U -> a, 1.U -> b, 2.U -> c, 3.U -> a))
  widthCheck := exhaustive +& 1.U
}
