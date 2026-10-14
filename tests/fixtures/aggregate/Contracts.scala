package aggregateContracts

import chisel3._

class WidthPacket(w: Int) extends Bundle { val data = UInt(w.W) }
class OtherPacket(w: Int) extends Bundle { val data = UInt(w.W) }
class EmptyPacket extends Bundle

class MuxWidthContract(wi: Int, wo: Int) extends Module {
  require(wi > 0 && wo > 0)
  val a = IO(Input(Vec(2, new WidthPacket(wi))))
  val b = IO(Input(Vec(2, new WidthPacket(wo))))
  val select = IO(Input(Bool()))
  val out = IO(Output(Vec(2, new WidthPacket(wi))))
  out := Mux(select, a, b)
}

class VecInitWidthContract(wi: Int, wo: Int) extends Module {
  require(wi > 0 && wo > 0)
  val a = IO(Input(new WidthPacket(wi)))
  val b = IO(Input(new WidthPacket(wo)))
  val out = IO(Output(Vec(2, new WidthPacket(wi))))
  out := VecInit(Seq(a, b))
}

class MuxLengthContract(ni: Int, no: Int) extends Module {
  require(ni > 0 && no > 0)
  val a = IO(Input(Vec(ni, UInt(4.W))))
  val b = IO(Input(Vec(no, UInt(4.W))))
  val select = IO(Input(Bool()))
  val out = IO(Output(Vec(ni, UInt(4.W))))
  out := Mux(select, a, b)
}

class VecInitLengthContract(ni: Int, no: Int) extends Module {
  require(ni > 0 && no > 0)
  val a = IO(Input(Vec(ni, UInt(4.W))))
  val b = IO(Input(Vec(no, UInt(4.W))))
  val out = IO(Output(Vec(2, Vec(ni, UInt(4.W)))))
  out := VecInit(Seq(a, b))
}

class MuxClassMismatch extends Module {
  val a = IO(Input(Vec(2, new WidthPacket(4))))
  val b = IO(Input(Vec(2, new OtherPacket(4))))
  val select = IO(Input(Bool()))
  val out = IO(Output(Vec(2, new WidthPacket(4))))
  out := Mux(select, a, b)
}

class VecInitClassMismatch extends Module {
  val a = IO(Input(new WidthPacket(4)))
  val b = IO(Input(new OtherPacket(4)))
  val out = IO(Output(Vec(2, new WidthPacket(4))))
  out := VecInit(Seq(a, b))
}

class MuxKindMismatch extends Module {
  val a = IO(Input(Vec(2, UInt(4.W))))
  val b = IO(Input(Vec(2, SInt(4.W))))
  val select = IO(Input(Bool()))
  val out = IO(Output(Vec(2, UInt(4.W))))
  out := Mux(select, a, b)
}

class EmptyBundleContract extends Module {
  val data = IO(Input(Vec(2, new EmptyPacket)))
}
