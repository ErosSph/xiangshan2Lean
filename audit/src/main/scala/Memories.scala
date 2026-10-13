package probes
import chisel3._

class AsyncMemory(val n: Int, val w: Int) extends Module {
  require(n >= 2 && w > 0)
  val write = IO(Input(Bool()))
  val waddr = IO(Input(UInt(3.W)))
  val raddr = IO(Input(UInt(3.W)))
  val data = IO(Input(UInt(w.W)))
  val out = IO(Output(UInt(w.W)))
  val memory = Mem(n, UInt(w.W))
  when(write) { memory.write(waddr, data) }
  out := memory.read(raddr)
}

class SyncMemory(val n: Int, val w: Int) extends Module {
  require(n >= 2 && w > 0)
  val write = IO(Input(Bool()))
  val readEnable = IO(Input(Bool()))
  val waddr = IO(Input(UInt(3.W)))
  val raddr = IO(Input(UInt(3.W)))
  val data = IO(Input(UInt(w.W)))
  val out = IO(Output(UInt(w.W)))
  val memory = SyncReadMem(n, UInt(w.W))
  when(write) { memory.write(waddr, data) }
  out := memory.read(raddr, readEnable)
}
