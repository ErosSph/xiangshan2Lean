package probes
import chisel3._
import chisel3.util._

class RegisterFile(val n: Int, val w: Int) extends Module {
  require(n > 0 && w > 0)
  val write = IO(Input(Bool()))
  val waddr = IO(Input(UInt(3.W)))
  val raddr = IO(Input(UInt(3.W)))
  val data = IO(Input(UInt(w.W)))
  val out = IO(Output(UInt(w.W)))
  val registers = RegInit(VecInit(Seq.fill(n)(0.U(w.W))))
  when(write) { registers(waddr) := data }
  out := registers(raddr)
}

class Fifo(val depth: Int, val w: Int) extends Module {
  require(depth >= 2 && w > 0)
  val enq = IO(Input(Bool()))
  val deq = IO(Input(Bool()))
  val data = IO(Input(UInt(w.W)))
  val out = IO(Output(UInt(w.W)))
  val full = IO(Output(Bool()))
  val empty = IO(Output(Bool()))
  val storage = RegInit(VecInit(Seq.fill(depth)(0.U(w.W))))
  val read = RegInit(0.U(log2Ceil(depth).W))
  val write = RegInit(0.U(log2Ceil(depth).W))
  val count = RegInit(0.U(log2Ceil(depth + 1).W))
  val push = enq && count < depth.U
  val pop = deq && count =/= 0.U
  when(push) {
    storage(write) := data
    write := Mux(write === (depth - 1).U, 0.U, write + 1.U)
  }
  when(pop) { read := Mux(read === (depth - 1).U, 0.U, read + 1.U) }
  when(push && !pop) { count := count + 1.U }
  when(pop && !push) { count := count - 1.U }
  out := storage(read)
  full := count === depth.U
  empty := count === 0.U
}

class ParameterLookup(val w: Int) extends RawModule {
  require(w >= 2)
  val sel = IO(Input(UInt(2.W)))
  val a = IO(Input(UInt(w.W)))
  val b = IO(Input(UInt(w.W)))
  val out = IO(Output(UInt(w.W)))
  out := MuxLookup(sel, 0.U, Seq(0.U -> a, 1.U -> b, 2.U -> (a + b)))
}

class TabulatedVector(val n: Int, val w: Int) extends RawModule {
  require(n > 0 && w > 0)
  val in = IO(Input(Vec(n, UInt(w.W))))
  val out = IO(Output(Vec(n, UInt(w.W))))
  val computed = VecInit(Seq.tabulate(n)(i => in(i) + 1.U))
  out := computed
}
