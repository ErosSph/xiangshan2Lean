package rejectedleanparam

import chisel3._
import chisel2lean.LeanParam

class WrongScalar(@LeanParam n: String) extends Module {
  val out = IO(Output(UInt(1.W)))
  out := 0.U
}
class MutableParameter(@LeanParam var n: Int) extends Module {
  val out = IO(Output(UInt(n.W)))
  out := 0.U
}
class MutableMember(n: Int) extends Module {
  @LeanParam var count: Int = n
  val out = IO(Output(UInt(1.W)))
  out := 0.U
}
class LazyMember(n: Int) extends Module {
  @LeanParam lazy val count: Int = n
  val out = IO(Output(UInt(1.W)))
  out := 0.U
}
class HardwareValue(n: Int) extends Module {
  @LeanParam val data = IO(Input(UInt(n.W)))
  val out = IO(Output(UInt(n.W)))
  out := data
}
class MethodArgument(n: Int) extends Module {
  @LeanParam def compute(x: Int): Int = n + x
  val out = IO(Output(UInt(n.W)))
  out := 0.U
}
@LeanParam class ClassTarget(n: Int) extends Module {
  val out = IO(Output(UInt(n.W)))
  out := 0.U
}
class LocalTarget(n: Int) extends Module {
  def compute(x: Int): Int = { @LeanParam val local = n + x; local }
  val out = IO(Output(UInt(n.W)))
  out := 0.U
}
class CollectionMember(n: Int) extends Module {
  @LeanParam val sizes: Seq[Int] = Seq(n)
  val out = IO(Output(UInt(n.W)))
  out := 0.U
}
class ConstantMember extends Module {
  @LeanParam val n: Int = 4
  val out = IO(Output(UInt(n.W)))
  out := 0.U
}
class UnsupportedComputation(n: Int) extends Module {
  @LeanParam def width: Int = math.abs(n)
  val out = IO(Output(UInt(4.W)))
  out := 0.U
}
class ConditionalAllocation(@LeanParam enabled: Boolean) extends Module {
  val out = IO(Output(UInt(4.W)))
  out := 0.U
  if (enabled) {
    val extra = RegInit(0.U(4.W))
    extra := extra + 1.U
    out := extra
  }
}
class RepeatedAllocation(@LeanParam n: Int) extends Module {
  require(n > 0)
  val children = Seq.fill(n)(Module(new leanparam.AnnotatedCounter(4)))
  val out = IO(Output(UInt(4.W)))
  for (i <- 0 until n) { children(i).en := true.B }
  out := children(0).out
}
class OptionalPort(@LeanParam enabled: Boolean) extends Module {
  val extra = if (enabled) Some(IO(Input(UInt(4.W)))) else None
  val out = IO(Output(UInt(4.W)))
  out := 0.U
}
class TypeUse(n: Int @LeanParam) extends Module {
  val out = IO(Output(UInt(n.W)))
  out := 0.U
}
class MarkedBundle(@LeanParam n: Int) extends Bundle {
  val value = UInt(n.W)
}
class BundleTarget(n: Int) extends Module {
  val data = IO(Input(new MarkedBundle(n)))
  val out = IO(Output(UInt(n.W)))
  out := data.value
}
