package xiangshan.validation

import chisel3._
import org.chipsalliance.cde.config.Parameters
import xiangshan.{SfenceBundle, XSModule}
import xiangshan.backend.fu.{LeftShiftModule, RightShiftModule}

/** Test tops only: all selected child modules and Bundle definitions are the
  * unchanged upstream classes. These harnesses are not upstream CPU modules.
  */
class ShiftHierarchy(implicit p: Parameters) extends XSModule {
  val source = IO(Input(UInt(XLEN.W)))
  val amount = IO(Input(UInt(6.W)))
  val reverse = IO(Input(UInt(6.W)))
  val left = IO(Output(UInt(XLEN.W)))
  val logical = IO(Output(UInt(XLEN.W)))
  val arithmetic = IO(Output(UInt(XLEN.W)))
  val combined = IO(Output(UInt(XLEN.W)))

  val l = Module(new LeftShiftModule)
  val r = Module(new RightShiftModule)
  l.io.sllSrc := source
  l.io.shamt := amount
  l.io.revShamt := reverse
  r.io.srlSrc := source
  r.io.sraSrc := source
  r.io.shamt := amount
  r.io.revShamt := reverse
  left := l.io.sll
  logical := r.io.srl
  arithmetic := r.io.sra
  combined := l.io.sll | r.io.revSrl
}

class SfencePipeline(implicit p: Parameters) extends XSModule {
  val request = IO(Input(new SfenceBundle))
  val result = IO(Output(new SfenceBundle))
  val enable = IO(Input(Bool()))
  val saved = RegInit(request)
  when(enable) { saved := request }
  result := saved
}
