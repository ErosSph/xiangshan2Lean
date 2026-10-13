import chisel3._

/** Parameterized enabled counter, matching the user's Chisel-to-Lean example. */
class Counter(n: Int) extends Module {
  require(n > 0)
  val en = IO(Input(Bool()))
  val q = IO(Output(UInt(n.W)))
  val cnt = RegInit(0.U(n.W))
  when(en) { cnt := cnt + 1.U }
  q := cnt
}
