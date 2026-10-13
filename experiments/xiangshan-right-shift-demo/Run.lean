import xiangshan.backend.fu.RightShiftModule
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open xiangshan.backend.fu.RightShiftModule
def p : Params := { XLEN := (64 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ io_revShamt := (BitVec.ofInt _ (63 : Int)), io_shamt := (BitVec.ofInt _ (1 : Int)), io_sraSrc := (BitVec.ofInt _ (9223372036854775808 : Int)), io_srlSrc := (BitVec.ofInt _ (9223372036854775808 : Int)) }, false),
  ({ io_revShamt := (BitVec.ofInt _ (0 : Int)), io_shamt := (BitVec.ofInt _ (63 : Int)), io_sraSrc := (BitVec.ofInt _ (18446744073709551615 : Int)), io_srlSrc := (BitVec.ofInt _ (18446744073709551615 : Int)) }, false),
  ({ io_revShamt := (BitVec.ofInt _ (1 : Int)), io_shamt := (BitVec.ofInt _ (0 : Int)), io_sraSrc := (BitVec.ofInt _ (9223372036854775808 : Int)), io_srlSrc := (BitVec.ofInt _ (9223372036854775808 : Int)) }, false),
  ({ io_revShamt := (BitVec.ofInt _ (3 : Int)), io_shamt := (BitVec.ofInt _ (4 : Int)), io_sraSrc := (BitVec.ofInt _ (240 : Int)), io_srlSrc := (BitVec.ofInt _ (240 : Int)) }, true),
  ({ io_revShamt := (BitVec.ofInt _ (63 : Int)), io_shamt := (BitVec.ofInt _ (63 : Int)), io_sraSrc := (BitVec.ofInt _ (0 : Int)), io_srlSrc := (BitVec.ofInt _ (0 : Int)) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("io.revSrl", Lean.toJson (o.io_revSrl).toNat), ("io.sra", Lean.toJson (o.io_sra).toNat), ("io.srl", Lean.toJson (o.io_srl).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj []
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { io_revShamt := (BitVec.ofInt _ (63 : Int)), io_shamt := (BitVec.ofInt _ (1 : Int)), io_sraSrc := (BitVec.ofInt _ (9223372036854775808 : Int)), io_srlSrc := (BitVec.ofInt _ (9223372036854775808 : Int)) }
  let mut state : State p := resetState p first
  let mut cycle : Nat := 0
  for entry in inputsTrace do
    let (inputs, reset) := entry
    if !outputDefined p inputs state && !(cycle == 0 && false) then throw (IO.userError "Undefined output operation in input trace")
    let pre := output p inputs state
    if !transitionDefined p inputs state reset then throw (IO.userError "Undefined transition operation in input trace")
    let next := step p inputs state reset
    if !outputDefined p inputs next then throw (IO.userError "Undefined output operation after clock edge")
    let post := output p inputs next
    IO.println (Lean.Json.mkObj [("cycle", Lean.toJson cycle), ("pre", outputsJson pre),
      ("post", outputsJson post), ("state", stateJson next)]).compress
    state := next
    cycle := cycle + 1
