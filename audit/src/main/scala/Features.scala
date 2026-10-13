package probes

import chisel3._
import chisel3.util._

class RenamedAccumulator(width: Int, increment: Int) extends Module {
  require(width > 0)
  require(increment >= 0)
  val active = IO(Input(Bool()))
  val result = IO(Output(UInt(width.W)))
  val storage = RegInit(0.U(width.W))
  when(active) { storage := storage + increment.U(width.W) }
  result := storage
}

class Arithmetic(aWidth: Int, bWidth: Int) extends Module {
  require(aWidth > 0 && bWidth > 0)
  val io = IO(new Bundle {
    val a = Input(UInt(aWidth.W))
    val b = Input(UInt(bWidth.W))
    val choose = Input(Bool())
    val sum = Output(UInt((aWidth + bWidth).W))
    val carry = Output(UInt((aWidth + bWidth + 1).W))
    val sub = Output(UInt((aWidth + bWidth).W))
    val product = Output(UInt((aWidth + bWidth).W))
    val selected = Output(UInt((aWidth + bWidth).W))
    val less = Output(Bool())
    val equal = Output(Bool())
    val concat = Output(UInt((aWidth + bWidth).W))
    val xor = Output(UInt((aWidth + bWidth).W))
  })
  io.sum := io.a + io.b
  io.carry := io.a +& io.b
  io.sub := io.a - io.b
  io.product := io.a * io.b
  io.selected := Mux(io.choose, io.a, io.b)
  io.less := io.a < io.b
  io.equal := io.a === io.b
  io.concat := Cat(io.a, io.b)
  io.xor := io.a ^ io.b
}

class SignedArithmetic(w: Int) extends Module {
  require(w > 0)
  val io = IO(new Bundle {
    val a = Input(SInt(w.W))
    val b = Input(SInt(w.W))
    val sum = Output(SInt(w.W))
    val wide = Output(SInt((w + 1).W))
    val product = Output(SInt((2 * w).W))
    val extended = Output(SInt((w + 2).W))
    val shr = Output(SInt(w.W))
    val less = Output(Bool())
  })
  io.sum := io.a + io.b
  io.wide := io.a +& io.b
  io.product := io.a * io.b
  io.extended := io.a
  io.shr := io.a >> 1
  io.less := io.a < io.b
}

class CombinationalDependencies(w: Int) extends Module {
  val io = IO(new Bundle {
    val in = Input(UInt(w.W))
    val en = Input(Bool())
    val out = Output(UInt(w.W))
  })
  val a = Wire(UInt(w.W))
  val b = Wire(UInt(w.W))
  a := 0.U
  b := a
  io.out := b
  when(io.en) { a := io.in }
}

class BoolGate(invert: Boolean) extends RawModule {
  val in = IO(Input(Bool()))
  val out = IO(Output(Bool()))
  out := (if (invert) !in else in)
}

class HelperWidth(n: Int) extends Module {
  require(n > 0)
  def wider(x: Int): Int = x + 1
  val w = wider(n)
  val in = IO(Input(UInt(w.W)))
  val out = IO(Output(UInt((2 * n).W)))
  out := in
}

class EnabledRegister(w: Int) extends Module {
  val in = IO(Input(UInt(w.W)))
  val en = IO(Input(Bool()))
  val out = IO(Output(UInt(w.W)))
  val r = RegEnable(in, en)
  out := r
}

class VecRegisters(n: Int, w: Int) extends Module {
  val io = IO(new Bundle {
    val in = Input(Vec(n, UInt(w.W)))
    val out = Output(Vec(n, UInt(w.W)))
  })
  val registers = Reg(Vec(n, UInt(w.W)))
  for (i <- 0 until n) {
    registers(i) := io.in(i)
    io.out(i) := registers(i)
  }
}

class BitOperations(w: Int) extends Module {
  require(w > 0)
  val in = IO(Input(UInt(w.W)))
  val out = IO(Output(UInt(w.W)))
  val left = IO(Output(UInt((w + 2).W)))
  val right = IO(Output(UInt(w.W)))
  val bit = IO(Output(Bool()))
  val any = IO(Output(Bool()))
  val all = IO(Output(Bool()))
  val parity = IO(Output(Bool()))
  out := in(w - 1, 0)
  left := in << 2
  right := in >> 1
  bit := in(0)
  any := in.orR
  all := in.andR
  parity := in.xorR
}

class VecIndex(n: Int, w: Int, k: Int) extends Module {
  val in = IO(Input(Vec(n, UInt(w.W))))
  val out = IO(Output(UInt(w.W)))
  out := in(k)
}
