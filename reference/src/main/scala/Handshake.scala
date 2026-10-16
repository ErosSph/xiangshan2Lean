package modernfixtures

import chisel3._
import chisel3.util._

/** Exercises ordinary Scala construction/generics and standard handshake types.
  * It is a validation fixture, not an upstream XiangShan module.
  */
class ElasticStage[T <: Data](gen: T) extends Module {
  val io = IO(new Bundle {
    val in = Flipped(Decoupled(gen))
    val out = Decoupled(gen)
  })
  val valid = RegInit(false.B)
  val data = Reg(gen)
  io.in.ready := !valid || io.out.ready
  when(io.in.ready) {
    valid := io.in.valid
    when(io.in.valid) { data := io.in.bits }
  }
  io.out.valid := valid
  io.out.bits := data
}

class HandshakeTop(width: Int, stages: Int) extends Module {
  require(width > 0 && stages > 0)
  val io = IO(new Bundle {
    val in = Flipped(Decoupled(UInt(width.W)))
    val out = Decoupled(UInt(width.W))
  })
  // Collection operations and a generic module run through official elaboration.
  val chain = List.tabulate(stages)(i => Option(i)).flatten.map(_ => Module(new ElasticStage(UInt(width.W))))
  chain.head.io.in <> io.in
  chain.sliding(2).filter(_.size == 2).foreach(pair => pair(1).io.in <> pair(0).io.out)
  io.out <> chain.last.io.out
}
