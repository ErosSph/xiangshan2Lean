package rejectedconfiguration

import chisel3._
import org.chipsalliance.cde.config.Parameters
import configuration._

class LocalChildConfiguration(implicit val p: Parameters) extends Module {
  val data = IO(Input(UInt(4.W)))
  val out = IO(Output(UInt(4.W)))
  val leaf = Module(new ConfiguredLeaf(0)(new TestConfig(4, true, 0)))
  leaf.data := data
  out := leaf.out
}

class MissingBundleSource(implicit val p: Parameters) extends Module {
  val data = IO(Input(new ConfiguredHeader))
  val out = IO(Output(new ConfiguredHeader))
  out := data
}
