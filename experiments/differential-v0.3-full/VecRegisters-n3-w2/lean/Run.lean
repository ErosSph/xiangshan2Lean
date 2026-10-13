import probes.VecRegisters
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.VecRegisters
def p : Params := { n := (3 : Int), w := (2 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (3 : Int)) | 1 => (BitVec.ofInt _ (1 : Int)) | 2 => (BitVec.ofInt _ (2 : Int)) | _ => default) }, true),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (3 : Int)) | 1 => (BitVec.ofInt _ (0 : Int)) | 2 => (BitVec.ofInt _ (3 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (0 : Int)) | 1 => (BitVec.ofInt _ (1 : Int)) | 2 => (BitVec.ofInt _ (0 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (0 : Int)) | 1 => (BitVec.ofInt _ (1 : Int)) | 2 => (BitVec.ofInt _ (0 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (1 : Int)) | 1 => (BitVec.ofInt _ (1 : Int)) | 2 => (BitVec.ofInt _ (1 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (3 : Int)) | 1 => (BitVec.ofInt _ (3 : Int)) | 2 => (BitVec.ofInt _ (1 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (0 : Int)) | 1 => (BitVec.ofInt _ (1 : Int)) | 2 => (BitVec.ofInt _ (1 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (1 : Int)) | 1 => (BitVec.ofInt _ (2 : Int)) | 2 => (BitVec.ofInt _ (3 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (3 : Int)) | 1 => (BitVec.ofInt _ (2 : Int)) | 2 => (BitVec.ofInt _ (3 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (3 : Int)) | 1 => (BitVec.ofInt _ (3 : Int)) | 2 => (BitVec.ofInt _ (3 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (3 : Int)) | 1 => (BitVec.ofInt _ (3 : Int)) | 2 => (BitVec.ofInt _ (1 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (2 : Int)) | 1 => (BitVec.ofInt _ (0 : Int)) | 2 => (BitVec.ofInt _ (1 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (3 : Int)) | 1 => (BitVec.ofInt _ (1 : Int)) | 2 => (BitVec.ofInt _ (0 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (0 : Int)) | 1 => (BitVec.ofInt _ (3 : Int)) | 2 => (BitVec.ofInt _ (0 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (3 : Int)) | 1 => (BitVec.ofInt _ (3 : Int)) | 2 => (BitVec.ofInt _ (1 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (0 : Int)) | 1 => (BitVec.ofInt _ (3 : Int)) | 2 => (BitVec.ofInt _ (0 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (3 : Int)) | 1 => (BitVec.ofInt _ (1 : Int)) | 2 => (BitVec.ofInt _ (2 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (1 : Int)) | 1 => (BitVec.ofInt _ (1 : Int)) | 2 => (BitVec.ofInt _ (0 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (3 : Int)) | 1 => (BitVec.ofInt _ (0 : Int)) | 2 => (BitVec.ofInt _ (2 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (0 : Int)) | 1 => (BitVec.ofInt _ (1 : Int)) | 2 => (BitVec.ofInt _ (2 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (1 : Int)) | 1 => (BitVec.ofInt _ (3 : Int)) | 2 => (BitVec.ofInt _ (1 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (2 : Int)) | 1 => (BitVec.ofInt _ (3 : Int)) | 2 => (BitVec.ofInt _ (1 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (0 : Int)) | 1 => (BitVec.ofInt _ (0 : Int)) | 2 => (BitVec.ofInt _ (3 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (1 : Int)) | 1 => (BitVec.ofInt _ (3 : Int)) | 2 => (BitVec.ofInt _ (0 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (3 : Int)) | 1 => (BitVec.ofInt _ (0 : Int)) | 2 => (BitVec.ofInt _ (3 : Int)) | _ => default) }, true),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (2 : Int)) | 1 => (BitVec.ofInt _ (2 : Int)) | 2 => (BitVec.ofInt _ (2 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (3 : Int)) | 1 => (BitVec.ofInt _ (3 : Int)) | 2 => (BitVec.ofInt _ (3 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (0 : Int)) | 1 => (BitVec.ofInt _ (2 : Int)) | 2 => (BitVec.ofInt _ (1 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (1 : Int)) | 1 => (BitVec.ofInt _ (2 : Int)) | 2 => (BitVec.ofInt _ (2 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (2 : Int)) | 1 => (BitVec.ofInt _ (2 : Int)) | 2 => (BitVec.ofInt _ (1 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (2 : Int)) | 1 => (BitVec.ofInt _ (2 : Int)) | 2 => (BitVec.ofInt _ (1 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (1 : Int)) | 1 => (BitVec.ofInt _ (2 : Int)) | 2 => (BitVec.ofInt _ (1 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (1 : Int)) | 1 => (BitVec.ofInt _ (1 : Int)) | 2 => (BitVec.ofInt _ (0 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (0 : Int)) | 1 => (BitVec.ofInt _ (2 : Int)) | 2 => (BitVec.ofInt _ (0 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (2 : Int)) | 1 => (BitVec.ofInt _ (3 : Int)) | 2 => (BitVec.ofInt _ (3 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (2 : Int)) | 1 => (BitVec.ofInt _ (3 : Int)) | 2 => (BitVec.ofInt _ (1 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (1 : Int)) | 1 => (BitVec.ofInt _ (2 : Int)) | 2 => (BitVec.ofInt _ (2 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (1 : Int)) | 1 => (BitVec.ofInt _ (2 : Int)) | 2 => (BitVec.ofInt _ (2 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (3 : Int)) | 1 => (BitVec.ofInt _ (0 : Int)) | 2 => (BitVec.ofInt _ (2 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (1 : Int)) | 1 => (BitVec.ofInt _ (0 : Int)) | 2 => (BitVec.ofInt _ (3 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (2 : Int)) | 1 => (BitVec.ofInt _ (0 : Int)) | 2 => (BitVec.ofInt _ (0 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (3 : Int)) | 1 => (BitVec.ofInt _ (0 : Int)) | 2 => (BitVec.ofInt _ (1 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (2 : Int)) | 1 => (BitVec.ofInt _ (1 : Int)) | 2 => (BitVec.ofInt _ (0 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (3 : Int)) | 1 => (BitVec.ofInt _ (0 : Int)) | 2 => (BitVec.ofInt _ (2 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (0 : Int)) | 1 => (BitVec.ofInt _ (3 : Int)) | 2 => (BitVec.ofInt _ (2 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (1 : Int)) | 1 => (BitVec.ofInt _ (1 : Int)) | 2 => (BitVec.ofInt _ (1 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (3 : Int)) | 1 => (BitVec.ofInt _ (0 : Int)) | 2 => (BitVec.ofInt _ (0 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (3 : Int)) | 1 => (BitVec.ofInt _ (3 : Int)) | 2 => (BitVec.ofInt _ (2 : Int)) | _ => default) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("io.out", Lean.Json.arr (((List.finRange 3).map (fun j0 => Lean.toJson ((o.io_out) j0).toNat)).toArray))]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("registers", Lean.Json.arr (((List.finRange 3).map (fun j0 => Lean.toJson ((s.registers) j0).toNat)).toArray))]
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (3 : Int)) | 1 => (BitVec.ofInt _ (1 : Int)) | 2 => (BitVec.ofInt _ (2 : Int)) | _ => default) }
  let mut state : State p := { registers := (fun j => match j.val with | 0 => (BitVec.ofInt _ (0 : Int)) | 1 => (BitVec.ofInt _ (0 : Int)) | 2 => (BitVec.ofInt _ (0 : Int)) | _ => default) }
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
