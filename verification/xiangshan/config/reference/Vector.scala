package xiangshan.validation

import chisel3._
import org.chipsalliance.cde.config.Parameters
import xiangshan.{SfenceBundle, XSModule}

// A local test top using the unchanged upstream SfenceBundle and real CDE.
class SfenceVectorPipeline(n: Int)(implicit p: Parameters) extends XSModule {
  require(n > 0)
  val request = IO(Input(Vec(n, new SfenceBundle)))
  val patch = IO(Input(new SfenceBundle))
  val enable = IO(Input(Bool()))
  val overrideAddress = IO(Input(Bool()))
  val index = IO(Input(UInt(8.W)))
  val result = IO(Output(Vec(n, new SfenceBundle)))
  val selected = IO(Output(new SfenceBundle))
  val saved = RegInit(request)
  when(enable) { saved(index) := patch }
  when(overrideAddress) { saved(index).bits.addr := saved(index).bits.addr + 1.U }
  result := saved
  selected := saved(index)
}
