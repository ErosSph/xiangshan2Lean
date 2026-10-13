import probes.VecRegisters
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.VecRegisters
def p : Params := { n := (1 : Int), w := (8 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (234 : Int)) | _ => default) }, true),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (99 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (167 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (242 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (49 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (212 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (27 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (121 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (37 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (9 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (113 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (53 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (127 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (66 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (102 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (231 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (250 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (78 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (23 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (71 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (114 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (92 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (166 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (203 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (213 : Int)) | _ => default) }, true),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (173 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (240 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (243 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (243 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (220 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (234 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (202 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (124 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (156 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (5 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (75 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (214 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (120 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (52 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (23 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (229 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (35 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (241 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (231 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (72 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (12 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (218 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (13 : Int)) | _ => default) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("io.out", Lean.Json.arr (((List.finRange 1).map (fun j0 => Lean.toJson ((o.io_out) j0).toNat)).toArray))]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("registers", Lean.Json.arr (((List.finRange 1).map (fun j0 => Lean.toJson ((s.registers) j0).toNat)).toArray))]
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (234 : Int)) | _ => default) }
  let mut state : State p := { registers := (fun j => match j.val with | 0 => (BitVec.ofInt _ (0 : Int)) | _ => default) }
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
