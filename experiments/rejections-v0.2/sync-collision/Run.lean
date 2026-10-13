import probes.SyncMemory
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.SyncMemory
def p : Params := { n := (3 : Int), w := (4 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ write := true, readEnable := true, waddr := (BitVec.ofInt _ (1 : Int)), raddr := (BitVec.ofInt _ (1 : Int)), data := (BitVec.ofInt _ (7 : Int)) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("out", Lean.toJson (o.«out»).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("memory", Lean.Json.arr (((List.finRange 3).map (fun j0 => Lean.toJson ((s.memory) j0).toNat)).toArray)), ("__memory_memory_read_0", Lean.toJson (s.__memory_memory_read_0).toNat), ("__memory_memory_read_0_valid", Lean.toJson (s.__memory_memory_read_0_valid))]
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { write := true, readEnable := true, waddr := (BitVec.ofInt _ (1 : Int)), raddr := (BitVec.ofInt _ (1 : Int)), data := (BitVec.ofInt _ (7 : Int)) }
  let mut state : State p := { memory := (fun j => match j.val with | 0 => (BitVec.ofInt _ (0 : Int)) | 1 => (BitVec.ofInt _ (0 : Int)) | 2 => (BitVec.ofInt _ (0 : Int)) | _ => default), __memory_memory_read_0 := (BitVec.ofInt _ (0 : Int)), __memory_memory_read_0_valid := false }
  let mut cycle : Nat := 0
  for entry in inputsTrace do
    let (inputs, reset) := entry
    if !outputDefined p inputs state && !(cycle == 0 && true) then throw (IO.userError "Undefined output operation in input trace")
    let pre := output p inputs state
    if !transitionDefined p inputs state reset then throw (IO.userError "Undefined transition operation in input trace")
    let next := step p inputs state reset
    if !outputDefined p inputs next then throw (IO.userError "Undefined output operation after clock edge")
    let post := output p inputs next
    IO.println (Lean.Json.mkObj [("cycle", Lean.toJson cycle), ("pre", outputsJson pre),
      ("post", outputsJson post), ("state", stateJson next)]).compress
    state := next
    cycle := cycle + 1
