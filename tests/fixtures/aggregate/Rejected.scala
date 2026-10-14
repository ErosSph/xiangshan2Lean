package aggregateRejected

import chisel3._

class OnlyA extends Bundle { val a = UInt(4.W) }
class OnlyB extends Bundle { val b = UInt(4.W) }
class Column extends Bundle { val a = Vec(2, UInt(4.W)) }

class MismatchBundleFields extends Module {
  val data = IO(Input(Vec(2, new OnlyA)))
  val out = IO(Output(Vec(2, new OnlyB)))
  out := data
}

class MismatchAggregateShape extends Module {
  val data = IO(Input(new Column))
  val out = IO(Output(Vec(2, new OnlyA)))
  out := data
}

class WriteThroughAlias extends Module {
  val data = IO(Input(Vec(2, new OnlyA)))
  val out = IO(Output(Vec(2, new OnlyA)))
  val saved = RegInit(data)
  val view = saved(0)
  view.a := 1.U
  out := saved
}
