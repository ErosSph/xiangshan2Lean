package rejected
import chisel3._

class CombinationalCycle(w: Int) extends Module {
  val in = IO(Input(UInt(w.W)))
  val out = IO(Output(UInt(w.W)))
  val a = Wire(UInt(w.W))
  val b = Wire(UInt(w.W))
  a := b
  b := a
  out := a
}

class UnconnectedOutput(w: Int) extends Module {
  val in = IO(Input(UInt(w.W)))
  val out = IO(Output(UInt(w.W)))
  when(in === 0.U) { out := 0.U }
}

class DynamicLeftShift(w: Int) extends Module {
  val in = IO(Input(UInt(w.W)))
  val shift = IO(Input(UInt(2.W)))
  val out = IO(Output(UInt(w.W)))
  out := in << shift
}

class Division(w: Int) extends Module {
  val a = IO(Input(UInt(w.W)))
  val b = IO(Input(UInt(w.W)))
  val out = IO(Output(UInt(w.W)))
  out := a / b
}

class Memory(w: Int) extends Module {
  val in = IO(Input(UInt(w.W)))
  val out = IO(Output(UInt(w.W)))
  val mem = Mem(4, UInt(w.W))
  out := mem(0.U)
}

class ChangedReset(w: Int) extends Module {
  val in = IO(Input(UInt(w.W)))
  val resetIn = IO(Input(AsyncReset()))
  val out = IO(Output(UInt(w.W)))
  val r = withReset(resetIn) { RegInit(0.U(w.W)) }
  r := in
  out := r
}

class Child(w: Int) extends Module {
  val in = IO(Input(UInt(w.W)))
  val out = IO(Output(UInt(w.W)))
  out := in
}

class Hierarchy(w: Int) extends Module {
  val in = IO(Input(UInt(w.W)))
  val out = IO(Output(UInt(w.W)))
  val child = Module(new Child(w))
  child.in := in
  out := child.out
}

class ConditionalDeclaration(w: Int) extends Module {
  val in = IO(Input(UInt(w.W)))
  val out = IO(Output(UInt(w.W)))
  if (w > 3) {
    val r = RegInit(0.U(w.W))
    r := in
    out := r
  } else { out := in }
}

class HostSideEffect(w: Int) extends Module {
  val in = IO(Input(UInt(w.W)))
  val out = IO(Output(UInt(w.W)))
  println(w)
  out := in
}

class StringParameter(label: String) extends Module {
  val in = IO(Input(Bool()))
  val out = IO(Output(Bool()))
  out := in
}

class SynchronousMemory(w: Int) extends Module {
  val in = IO(Input(UInt(w.W)))
  val out = IO(Output(UInt(w.W)))
  val mem = SyncReadMem(4, UInt(w.W))
  out := mem.read(0.U, true.B)
}
class MultipleMemoryWrites(w: Int) extends Module {
  val in = IO(Input(UInt(w.W)))
  val out = IO(Output(UInt(w.W)))
  val mem = Mem(4, UInt(w.W))
  mem.write(0.U, in)
  mem.write(1.U, in)
  out := mem.read(0.U)
}
class UnconnectedChild(w: Int) extends Module {
  val out = IO(Output(UInt(w.W)))
  val child = Module(new Child(w))
  out := child.out
}
class RawState(w: Int) extends RawModule {
  val in = IO(Input(UInt(w.W)))
  val out = IO(Output(UInt(w.W)))
  val r = RegInit(0.U(w.W))
  r := in
  out := r
}
class NonuniformVector(w: Int) extends RawModule {
  val out = IO(Output(Vec(w, UInt(w.W))))
  val v = VecInit(Seq.tabulate(w)(i => i.U))
  out := v
}
