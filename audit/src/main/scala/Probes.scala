package probes

import chisel3._

class Counter(n: Int) extends Module {
  require(n > 0)
  val io = IO(new Bundle {
    val en = Input(Bool())
    val q = Output(UInt(n.W))
  })
  val cnt = RegInit(0.U(n.W))
  when(io.en) { cnt := cnt + 1.U }
  io.q := cnt
}

class DualRegister(n: Int) extends Module {
  val io = IO(new Bundle {
    val in = Input(UInt(n.W))
    val a = Output(UInt(n.W))
    val b = Output(UInt(n.W))
  })
  val first = RegInit(0.U(n.W))
  val second = RegInit(0.U(n.W))
  first := io.in
  second := first
  io.a := first
  io.b := second
}

class Priority(n: Int) extends Module {
  val io = IO(new Bundle {
    val en = Input(Bool())
    val clear = Input(Bool())
    val q = Output(UInt(n.W))
  })
  val cnt = RegInit(0.U(n.W))
  when(io.en) { cnt := cnt + 1.U }
  when(io.clear) { cnt := 0.U }
  io.q := cnt
}

class ParamChoice(n: Int) extends Module {
  val io = IO(new Bundle {
    val in = Input(UInt(n.W))
    val out = Output(UInt(n.W))
  })
  if (n > 3) { io.out := io.in + 1.U }
  else { io.out := io.in + 2.U }
}

class VecLoop(n: Int, w: Int) extends Module {
  val io = IO(new Bundle {
    val in = Input(Vec(n, UInt(w.W)))
    val out = Output(Vec(n, UInt(w.W)))
  })
  for (i <- 0 until n) { io.out(i) := io.in(i) + 1.U }
}

class ParamExpression(n: Int) extends Module {
  val io = IO(new Bundle {
    val in = Input(UInt((n + 1).W))
    val out = Output(UInt((2 * n).W))
  })
  io.out := io.in
}

class DirectCounter(n: Int) extends Module {
  require(n > 0)
  val en = IO(Input(Bool()))
  val q = IO(Output(UInt(n.W)))
  val cnt = RegInit(0.U(n.W))
  when(en) { cnt := cnt + 1.U }
  q := cnt
}
