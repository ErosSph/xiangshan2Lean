package wireprobe
import chisel3._
class WireProbe(w: Int) extends Module {
 require(w>0)
 val in=IO(Input(UInt(w.W)))
 val out=IO(Output(UInt(w.W)))
 val v=WireInit(0.U(w.W))
 v := in
 out := v
}
