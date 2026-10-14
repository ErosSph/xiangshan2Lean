package configuration

import chisel3._
import org.chipsalliance.cde.config.Parameters

class ConfiguredLeaf(delta: Int)(implicit val p: Parameters) extends Module with ConfigParams {
  require(width > 0 && width <= 16 && delta >= 0 && delta < 8 && offset >= 0)
  val data = IO(Input(UInt(width.W)))
  val out = IO(Output(UInt(width.W)))
  val saved = RegInit(0.U(width.W))
  if (enabled) { saved := data + delta.U }
  out := saved + offset.U
}

// No direct field queries here: fields must propagate from both children.
abstract class ConfiguredStageBase(extra: Int)(implicit val first: Parameters, val second: Parameters) extends Module {
  val data = IO(Input(UInt(8.W)))
  val out = IO(Output(UInt(8.W)))
  val left = Module(new ConfiguredLeaf(extra)(second))
  val right = Module(new ConfiguredLeaf(extra + 1)(first))
  left.data := data
  right.data := left.out
  out := right.out
}

class ConfiguredStage(extra: Int)(implicit first: Parameters, second: Parameters)
    extends ConfiguredStageBase(extra)(first, second)

class ConfiguredHierarchy(inc: Int)(implicit val p: Parameters, val other: Parameters) extends Module {
  val data = IO(Input(UInt(8.W)))
  val out = IO(Output(UInt(8.W)))
  val stage = Module(new ConfiguredStage(inc + 1)(other, p))
  stage.data := data
  out := stage.out
}

// Inherited fields, a self-typed trait, nested named Bundles and different roots.
trait BundleConfigParams {
  implicit val p: Parameters
  def laneWidth = p(CoreKey).width
}
abstract class ConfiguredPayload(implicit val p: Parameters) extends Bundle with BundleConfigParams {
  val payload = UInt(laneWidth.W)
}
trait HasPacketTag extends BundleConfigParams { this: Bundle =>
  val tag = UInt((laneWidth + 1).W)
}
class ConfiguredHeader(implicit val p: Parameters) extends Bundle with BundleConfigParams {
  val valid = Bool()
  val code = UInt(laneWidth.W)
}
class ConfiguredPacket(extra: Int)(implicit p: Parameters)
    extends ConfiguredPayload with HasPacketTag {
  val header = new ConfiguredHeader
  val tail = UInt((if (extra == 0) laneWidth else laneWidth + extra).W)
}

class ConfiguredBundlePipeline(extra: Int)(implicit val p: Parameters, val other: Parameters) extends Module {
  require(extra >= 0 && extra < 4)
  val data = IO(Input(new ConfiguredPacket(extra)(p)))
  val out = IO(Output(new ConfiguredPacket(extra)(other)))
  val en = IO(Input(Bool()))
  val saved = RegInit(data)
  when(en) { saved := data }
  out := saved
}
