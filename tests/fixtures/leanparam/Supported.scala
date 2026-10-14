package leanparam

import chisel3._
import chisel2lean.{LeanParam => KeepParam}
import org.chipsalliance.cde.config.{Config, Field, Parameters}

// One generated Lean family must work for different lengths, widths and flags.
class AnnotatedBank(@KeepParam val n: Int, @KeepParam val w: Int, @KeepParam val extra: Boolean) extends Module {
  require(n > 0 && w > 0 && w < 64)
  @KeepParam val width: Int = w + 1
  @KeepParam def lanes: Int = n
  val data = IO(Input(Vec(lanes, UInt(width.W))))
  val out = IO(Output(Vec(lanes, UInt(width.W))))
  val stored = RegInit(VecInit(Seq.fill(lanes)(0.U(width.W))))
  stored := data
  if (extra) {
    for (i <- 0 until lanes) { stored(i) := data(i) + 1.U }
  }
  out := stored
}

class AnnotatedCounter(@chisel2lean.LeanParam n: Int = 4) extends Module {
  require(n > 0)
  val en = IO(Input(Bool()))
  val out = IO(Output(UInt(n.W)))
  val count = RegInit(0.U(n.W))
  when(en) { count := count + 1.U }
  out := count
}

abstract class MarkedBase(@KeepParam val width: Int) extends Module {
  require(width > 0)
  val data = IO(Input(UInt(width.W)))
  val out = IO(Output(UInt(width.W)))
  out := ~data
}
class RenamedParameter(@KeepParam n: Int) extends MarkedBase(n + 1)

class AnnotatedHierarchy(@KeepParam n: Int) extends Module {
  require(n > 0)
  val en = IO(Input(Bool()))
  val out = IO(Output(UInt((n + 1).W)))
  val child = Module(new AnnotatedCounter(n + 1))
  child.en := en
  out := child.out
}

case class Settings(width: Int, enabled: Boolean)
case object SettingsKey extends Field[Settings]
class TestConfig(width: Int, enabled: Boolean) extends Config((site, here, up) => {
  case SettingsKey => Settings(width, enabled)
})
trait MarkedSettings {
  implicit val p: Parameters
  @KeepParam def width: Int = p(SettingsKey).width
  @KeepParam def enabled: Boolean = p(SettingsKey).enabled
}
class AnnotatedConfiguration(implicit val p: Parameters) extends Module with MarkedSettings {
  require(width > 0)
  val data = IO(Input(UInt(width.W)))
  val out = IO(Output(UInt(width.W)))
  out := (if (enabled) ~data else data)
}

// The annotation name must resolve to the library symbol, not just its spelling.
class Unannotated(n: Int) extends Module {
  require(n > 0)
  val data = IO(Input(UInt(n.W)))
  val out = IO(Output(UInt(n.W)))
  out := data
}
