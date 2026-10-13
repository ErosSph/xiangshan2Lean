package configuration

import chisel3._
import org.chipsalliance.cde.config.{Config, Field, Parameters}

case class Nested(offset: Int)
case class Core(width: Int, enabled: Boolean, nested: Nested, unused: Seq[Int])
case object CoreKey extends Field[Core]

class TestConfig(width: Int, enabled: Boolean, offset: Int) extends Config((site, here, up) => {
  case CoreKey => Core(width, enabled, Nested(offset), Seq(11, 22, 33))
})

trait ConfigParams {
  implicit val p: Parameters
  def core = p(CoreKey)
  def width = core.width
  def enabled = core.enabled
  def offset = core.nested.offset
  def laneWidth = width
}

trait Widen extends ConfigParams {
  def widen(value: Int): Int = value + 1
  override def laneWidth = widen(width)
}

abstract class PipelineBase(delta: Int)(implicit val p: Parameters) extends Module with ConfigParams {
  require(laneWidth > 0 && delta >= 0 && delta < 4)
  val data = IO(Input(UInt(laneWidth.W)))
  val out = IO(Output(UInt(laneWidth.W)))
  val stored = RegInit(0.U(laneWidth.W))
  if (enabled) { stored := data + delta.U }
  out := stored
}

trait AddOffset extends ConfigParams { this: PipelineBase =>
  out := stored + offset.U
}

class ConfiguredPipeline(inc: Int)(implicit p: Parameters)
    extends PipelineBase(inc + 1)(p) with Widen with AddOffset

// Separate constructor Parameters roots must never accidentally merge fields.
class TwoConfigurations(implicit val p: Parameters, val other: Parameters) extends Module {
  val a = IO(Input(UInt(p(CoreKey).width.W)))
  val y = IO(Output(UInt(other(CoreKey).width.W)))
  y := a
}

// Parent constructor substitution also works independently of CDE.
abstract class WidthBase(val width: Int) extends Module {
  require(width > 0)
  val a = IO(Input(UInt(width.W)))
  val y = IO(Output(UInt(width.W)))
  y := a
}
trait InvertOutput { this: WidthBase => y := ~a }
class InheritedPrimitive(n: Int) extends WidthBase(n + 1) with InvertOutput

case object ScalarKey extends Field[Int](5)
case object FlagKey extends Field[Boolean]
class ScalarConfig(flag: Boolean) extends Config((site, here, up) => { case FlagKey => flag })
trait ScalarParams {
  implicit val p: Parameters
  def width(): Int = p(ScalarKey)
  def flag(): Boolean = p(FlagKey)
}
class ScalarDefaults(implicit val p: Parameters) extends Module with ScalarParams {
  val a = IO(Input(UInt(width().W)))
  val y = IO(Output(UInt(width().W)))
  y := (if (flag()) ~a else a)
}
