package probes
import chisel3._
import chisel3.util._

// Parent deliberately precedes dependencies; constructor expressions stay symbolic.
class HierarchicalPipeline(val w: Int) extends Module {
  require(w > 0)
  val in = IO(Input(UInt(w.W)))
  val en = IO(Input(Bool()))
  val out = IO(Output(UInt((w + 1).W)))
  val a = Module(new PipelineLane(w + 1, 1))
  val b = Module(new PipelineLane(w + 1, 2))
  a.in := in
  a.en := en
  b.in := a.out
  b.en := en
  out := b.out
}

class PipelineLane(val width: Int, val increment: Int) extends Module {
  require(width > 0 && increment >= 0)
  val in = IO(Input(UInt(width.W)))
  val en = IO(Input(Bool()))
  val out = IO(Output(UInt(width.W)))
  val r = RegInit(0.U(width.W))
  when(en) { r := in + increment.U(width.W) }
  out := r
}

class NestedHierarchy(val w: Int) extends Module {
  require(w > 0)
  val io = IO(new Bundle { val in = Input(UInt(w.W)); val en = Input(Bool()); val out = Output(UInt((w + 1).W)) })
  val child = Module(new HierarchicalPipeline(w))
  child.in := io.in
  child.en := io.en
  io.out := child.out
}

class HierarchicalComb(val w: Int, val invert: Boolean) extends RawModule {
  require(w > 0)
  val a = IO(Input(UInt(w.W)))
  val out = IO(Output(UInt(w.W)))
  val child = Module(new CombLane(w, invert))
  child.io.in := a
  out := child.io.out + 1.U
}

class CombLane(val w: Int, val invert: Boolean) extends RawModule {
  require(w > 0)
  val io = IO(new Bundle { val in = Input(UInt(w.W)); val out = Output(UInt(w.W)) })
  io.out := (if (invert) ~io.in else io.in)
}
