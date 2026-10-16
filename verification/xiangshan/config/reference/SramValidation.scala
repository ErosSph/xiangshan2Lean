package xiangshan.validation

import chisel3._
import utility.sram.{SramArray1P, SramArray2P}

/** Port adapter around the unchanged original SRAM implementations. */
class SramArrayValidation(singlePort: Boolean) extends RawModule {
  val rclk = IO(Input(Clock()))
  val wclk = IO(Input(Clock()))
  val ren = IO(Input(Bool()))
  val wen = IO(Input(Bool()))
  val raddr = IO(Input(UInt(3.W)))
  val waddr = IO(Input(UInt(3.W)))
  val data = IO(Input(UInt(16.W)))
  val mask = IO(Input(UInt(2.W)))
  val q = IO(Output(UInt(16.W)))
  if (singlePort) {
    val ram = Module(new SramArray1P(8, 16, 2, false, false))
    val rw = ram.RW0.get
    rw.clk := rclk
    rw.en := ren || wen
    rw.addr := Mux(wen, waddr, raddr)
    rw.wmode := wen
    rw.wmask := mask
    rw.wdata := data
    q := rw.rdata
  } else {
    val ram = Module(new SramArray2P(8, 16, 2, false, false))
    val r = ram.R0.get
    r.clk := rclk
    r.en := ren
    r.addr := raddr
    val w = ram.W0.get
    w.clk := wclk
    w.en := wen
    w.addr := waddr
    w.mask := mask
    w.data := data
    q := r.data
  }
}
