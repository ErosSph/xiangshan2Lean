package probes
import chisel3._
import chisel3.util._

class VectorReset(val n: Int, val w: Int) extends Module {
  require(n > 0 && w > 0)
  val in = IO(Input(Vec(n, UInt(w.W))))
  val en = IO(Input(Bool()))
  val out = IO(Output(Vec(n, UInt(w.W))))
  val regs = RegInit(VecInit(Seq.fill(n)(0.U(w.W))))
  for (i <- 0 until n) { when(en) { regs(i) := in(i) + 1.U } }
  out := regs
}

class RegisterIdioms(val w: Int) extends Module {
  require(w > 0)
  val in = IO(Input(UInt(w.W)))
  val en = IO(Input(Bool()))
  val out = IO(Output(UInt(w.W)))
  val delayed = RegNext(in, 0.U(w.W))
  val held = RegEnable(delayed, 0.U(w.W), en)
  val explicit = RegInit(UInt(w.W), 0.U)
  explicit := held
  out := explicit
}

class Payload(val w: Int) extends Bundle {
  val data = UInt(w.W)
  val valid = Bool()
}
class BundlePipeline(val w: Int) extends Module {
  require(w > 0)
  val in = IO(Input(new Payload(w)))
  val out = IO(Output(new Payload(w)))
  val r = RegNext(in)
  out := r
}

class SwitchMachine(val w: Int) extends Module {
  require(w >= 2)
  val in = IO(Input(UInt(w.W)))
  val en = IO(Input(Bool()))
  val out = IO(Output(UInt(w.W)))
  val idle :: busy :: done :: Nil = Enum(3)
  val state = RegInit(idle)
  val data = RegInit(0.U(w.W))
  switch(state) {
    is(idle) { when(en) { data := in; state := busy } }
    is(busy) { data := data + 1.U; state := done }
    is(done) { state := idle }
  }
  out := Mux(state === done, data, 0.U)
}

class MoreBits(val w: Int, val repeat: Int) extends RawModule {
  require(w >= 2 && repeat >= 1 && repeat <= 4)
  val a = IO(Input(UInt(w.W)))
  val b = IO(Input(UInt(w.W)))
  val shift = IO(Input(UInt(2.W)))
  val quotient = IO(Output(UInt(w.W)))
  val remainder = IO(Output(UInt(w.W)))
  val shifted = IO(Output(UInt((w + 3).W)))
  val top = IO(Output(UInt(2.W)))
  val bottom = IO(Output(UInt((w - 1).W)))
  val filled = IO(Output(UInt((2 * repeat).W)))
  val bit = IO(Output(Bool()))
  quotient := a / b
  remainder := a % b
  shifted := a << shift
  top := a.head(2)
  bottom := a.tail(1)
  filled := Fill(repeat, a(1, 0))
  bit := a(shift)
}

class SignedDivision(val w: Int) extends RawModule {
  require(w >= 2)
  val a = IO(Input(SInt(w.W)))
  val b = IO(Input(SInt(w.W)))
  val quotient = IO(Output(SInt((w + 1).W)))
  val remainder = IO(Output(SInt(w.W)))
  quotient := a / b
  remainder := a % b
}

class HardwareHelper(val w: Int) extends RawModule {
  require(w > 0)
  val in = IO(Input(UInt(w.W)))
  val out = IO(Output(UInt(w.W)))
  def mix(a: UInt, b: UInt): UInt = { val sum = a + b; sum ^ b }
  out := mix(in, 1.U(w.W))
}

class PartialGenerate(val n: Int, val w: Int) extends RawModule {
  require(n >= 2 && w > 0)
  val in = IO(Input(Vec(n, UInt(w.W))))
  val out = IO(Output(Vec(n, UInt(w.W))))
  out := in
  for (i <- 1 until n) { val inc = 1; val value = in(i - 1) + inc.U; out(i) := value }
}

class LiteralVector extends RawModule {
  val a = IO(Input(UInt(3.W)))
  val out = IO(Output(Vec(3, UInt(4.W))))
  val v = VecInit(Seq(a, 1.U, 7.U(4.W)))
  out := v
}

class InferredRegisters(val w: Int) extends Module {
  require(w >= 2)
  val in = IO(Input(UInt(w.W)))
  val out = IO(Output(UInt((w + 1).W)))
  val unforced = RegInit(0.U)
  val widened = RegNext(in +& 1.U, 0.U)
  val wire = Wire(UInt())
  wire := in
  wire := 0.U
  unforced := in
  out := widened + unforced + wire
}

class InferredVectorReset(val n: Int, val w: Int) extends Module {
  require(n > 0 && w > 0)
  val in = IO(Input(Vec(n, UInt(w.W))))
  val out = IO(Output(Vec(n, UInt(1.W))))
  val r = RegInit(VecInit(Seq.fill(n)(0.U)))
  for (i <- 0 until n) { r(i) := in(i) }
  out := r
}

class AliasedInitializer(val w: Int) extends Module {
  require(w >= 3)
  val in = IO(Input(UInt(w.W)))
  val out = IO(Output(UInt(w.W)))
  val initial = 0.U(2.W)
  val r = RegInit(initial)
  r := in
  out := r
}
