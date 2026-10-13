// Test-only framework isolation for the original RightShiftModule declaration.
// The module uses only the architecture width supplied by Parameters/XSModule.
package org.chipsalliance.cde.config {
  final case class Parameters(xlen: Int)
}

package xiangshan {
  import chisel3.Module
  import org.chipsalliance.cde.config.Parameters

  abstract class XSModule(implicit val p: Parameters) extends Module {
    val XLEN: Int = p.xlen
  }
}

package xiangshan.validation {
  import chisel3._
  import org.chipsalliance.cde.config.Parameters

  /** Exposes the original class through an Int constructor for the RTL runner. */
  class OriginalRightShiftReference(val XLEN: Int) extends Module {
    implicit val parameters: Parameters = Parameters(XLEN)
    val io = IO(new Bundle {
      val shamt = Input(UInt(6.W))
      val revShamt = Input(UInt(6.W))
      val srlSrc = Input(UInt(XLEN.W))
      val sraSrc = Input(UInt(XLEN.W))
      val srl = Output(UInt(XLEN.W))
      val sra = Output(UInt(XLEN.W))
      val revSrl = Output(UInt(XLEN.W))
    })
    val original = Module(new xiangshan.backend.fu.RightShiftModule)
    original.io.shamt := io.shamt
    original.io.revShamt := io.revShamt
    original.io.srlSrc := io.srlSrc
    original.io.sraSrc := io.sraSrc
    io.srl := original.io.srl
    io.sra := original.io.sra
    io.revSrl := original.io.revSrl
  }
}
