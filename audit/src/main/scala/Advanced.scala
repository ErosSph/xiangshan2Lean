package probes
import chisel3._
import chisel3.util._

class ElaborationWidth(n: Int) extends Module {
  require(n > 0)
  val in = IO(Input(UInt(n.W)))
  val out = IO(Output(UInt((n + 4).W)))
  val selected = if (n > 3) in else 3.U(2.W)
  out := selected + 1.U
}

class ElaborationLiteral(n: Int) extends Module {
  require(n > 0)
  val in = IO(Input(UInt(n.W)))
  val out = IO(Output(UInt(n.W)))
  val selected = if (n > 3) 15.U(n.W) else 1.U(n.W)
  out := selected
}

class ExtendedBits(w: Int, shift: Int) extends Module {
  require(w >= 0 && shift >= 0)
  val in = IO(Input(UInt(w.W)))
  val flag = IO(Input(Bool()))
  val amount = IO(Input(UInt(2.W)))
  val inverted = IO(Output(UInt(w.W)))
  val negative = IO(Output(UInt((w + 1).W)))
  val concatenated = IO(Output(UInt((w + 2).W)))
  val isZero = IO(Output(Bool()))
  val shifted = IO(Output(UInt(w.W)))
  val dynamic = IO(Output(UInt(w.W)))
  val padded = IO(Output(UInt((w + 3).W)))
  inverted := ~in
  negative := -in
  concatenated := Cat(flag, -in)
  isZero := !in
  shifted := in >> shift
  dynamic := in >> amount
  padded := in.pad(w + 3)
}

class ReservedPorts extends RawModule {
  val clock = IO(Input(Bool()))
  val reset = IO(Input(Bool()))
  val bit = IO(Output(Bool()))
  val `class` = IO(Output(Bool()))
  bit := clock && reset
  `class` := clock || reset
}

class BoolState extends Module {
  val enable = IO(Input(Bool()))
  val out = IO(Output(Bool()))
  val r = RegInit(false.B)
  when(enable) { r := !r }
  out := r
}

class ResetFromInput(w: Int) extends Module {
  val in = IO(Input(UInt(w.W)))
  val out = IO(Output(UInt(w.W)))
  val r = RegInit(in)
  r := r + 1.U
  out := r
}

class MixedReset(w: Int) extends Module {
  val in = IO(Input(UInt(w.W)))
  val initialized = IO(Output(UInt(w.W)))
  val uninitialized = IO(Output(UInt(w.W)))
  val a = RegInit(0.U(w.W))
  val b = Reg(UInt(w.W))
  a := b
  b := in
  initialized := a
  uninitialized := b
}

class CountedIO(val w: Int) extends Bundle {
  val in = Input(UInt(w.W))
  val out = Output(UInt(w.W))
}

class NamedBundle(w: Int) extends Module {
  val io = IO(new CountedIO(w))
  io.out := io.in + 1.U
}
