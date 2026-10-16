package modernfixtures

import chisel3._
import chisel3.util._

/** Official standard Queue, including its Mem/SyncReadMem implementation. */
class QueueTop(width: Int, entries: Int, synchronous: Boolean) extends Module {
  require(width > 0 && entries > 0)
  val io = IO(new Bundle {
    val in = Flipped(Decoupled(UInt(width.W)))
    val out = Decoupled(UInt(width.W))
    val count = Output(UInt(log2Ceil(entries + 1).W))
  })
  val queue = Module(new Queue(UInt(width.W), entries, useSyncReadMem = synchronous))
  queue.io.enq <> io.in
  io.out <> queue.io.deq
  io.count := queue.io.count
}
