import probes.VecIndex
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.VecIndex
def p : Params := { n := (3 : Int), w := (4 : Int), k := (0 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (14 : Int)) | 1 => (BitVec.ofInt _ (6 : Int)) | 2 => (BitVec.ofInt _ (10 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (15 : Int)) | 1 => (BitVec.ofInt _ (3 : Int)) | 2 => (BitVec.ofInt _ (13 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (1 : Int)) | 1 => (BitVec.ofInt _ (7 : Int)) | 2 => (BitVec.ofInt _ (2 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (0 : Int)) | 1 => (BitVec.ofInt _ (7 : Int)) | 2 => (BitVec.ofInt _ (3 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (7 : Int)) | 1 => (BitVec.ofInt _ (4 : Int)) | 2 => (BitVec.ofInt _ (6 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (14 : Int)) | 1 => (BitVec.ofInt _ (15 : Int)) | 2 => (BitVec.ofInt _ (4 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (1 : Int)) | 1 => (BitVec.ofInt _ (4 : Int)) | 2 => (BitVec.ofInt _ (7 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (5 : Int)) | 1 => (BitVec.ofInt _ (10 : Int)) | 2 => (BitVec.ofInt _ (12 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (13 : Int)) | 1 => (BitVec.ofInt _ (10 : Int)) | 2 => (BitVec.ofInt _ (15 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (15 : Int)) | 1 => (BitVec.ofInt _ (15 : Int)) | 2 => (BitVec.ofInt _ (13 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (14 : Int)) | 1 => (BitVec.ofInt _ (12 : Int)) | 2 => (BitVec.ofInt _ (7 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (9 : Int)) | 1 => (BitVec.ofInt _ (0 : Int)) | 2 => (BitVec.ofInt _ (4 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (13 : Int)) | 1 => (BitVec.ofInt _ (7 : Int)) | 2 => (BitVec.ofInt _ (3 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (1 : Int)) | 1 => (BitVec.ofInt _ (14 : Int)) | 2 => (BitVec.ofInt _ (2 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (15 : Int)) | 1 => (BitVec.ofInt _ (14 : Int)) | 2 => (BitVec.ofInt _ (4 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (0 : Int)) | 1 => (BitVec.ofInt _ (13 : Int)) | 2 => (BitVec.ofInt _ (0 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (13 : Int)) | 1 => (BitVec.ofInt _ (6 : Int)) | 2 => (BitVec.ofInt _ (11 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (6 : Int)) | 1 => (BitVec.ofInt _ (7 : Int)) | 2 => (BitVec.ofInt _ (1 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (15 : Int)) | 1 => (BitVec.ofInt _ (2 : Int)) | 2 => (BitVec.ofInt _ (9 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (1 : Int)) | 1 => (BitVec.ofInt _ (6 : Int)) | 2 => (BitVec.ofInt _ (9 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (4 : Int)) | 1 => (BitVec.ofInt _ (14 : Int)) | 2 => (BitVec.ofInt _ (4 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (11 : Int)) | 1 => (BitVec.ofInt _ (12 : Int)) | 2 => (BitVec.ofInt _ (4 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (2 : Int)) | 1 => (BitVec.ofInt _ (0 : Int)) | 2 => (BitVec.ofInt _ (14 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (6 : Int)) | 1 => (BitVec.ofInt _ (14 : Int)) | 2 => (BitVec.ofInt _ (2 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (12 : Int)) | 1 => (BitVec.ofInt _ (3 : Int)) | 2 => (BitVec.ofInt _ (14 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (10 : Int)) | 1 => (BitVec.ofInt _ (9 : Int)) | 2 => (BitVec.ofInt _ (11 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (14 : Int)) | 1 => (BitVec.ofInt _ (15 : Int)) | 2 => (BitVec.ofInt _ (12 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (1 : Int)) | 1 => (BitVec.ofInt _ (8 : Int)) | 2 => (BitVec.ofInt _ (6 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (7 : Int)) | 1 => (BitVec.ofInt _ (11 : Int)) | 2 => (BitVec.ofInt _ (9 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (8 : Int)) | 1 => (BitVec.ofInt _ (8 : Int)) | 2 => (BitVec.ofInt _ (5 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (11 : Int)) | 1 => (BitVec.ofInt _ (8 : Int)) | 2 => (BitVec.ofInt _ (6 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (7 : Int)) | 1 => (BitVec.ofInt _ (10 : Int)) | 2 => (BitVec.ofInt _ (6 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (6 : Int)) | 1 => (BitVec.ofInt _ (7 : Int)) | 2 => (BitVec.ofInt _ (0 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (3 : Int)) | 1 => (BitVec.ofInt _ (10 : Int)) | 2 => (BitVec.ofInt _ (2 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (8 : Int)) | 1 => (BitVec.ofInt _ (14 : Int)) | 2 => (BitVec.ofInt _ (12 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (11 : Int)) | 1 => (BitVec.ofInt _ (14 : Int)) | 2 => (BitVec.ofInt _ (5 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (7 : Int)) | 1 => (BitVec.ofInt _ (11 : Int)) | 2 => (BitVec.ofInt _ (11 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (4 : Int)) | 1 => (BitVec.ofInt _ (10 : Int)) | 2 => (BitVec.ofInt _ (10 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (13 : Int)) | 1 => (BitVec.ofInt _ (0 : Int)) | 2 => (BitVec.ofInt _ (10 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (6 : Int)) | 1 => (BitVec.ofInt _ (2 : Int)) | 2 => (BitVec.ofInt _ (12 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (11 : Int)) | 1 => (BitVec.ofInt _ (0 : Int)) | 2 => (BitVec.ofInt _ (2 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (13 : Int)) | 1 => (BitVec.ofInt _ (2 : Int)) | 2 => (BitVec.ofInt _ (6 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (10 : Int)) | 1 => (BitVec.ofInt _ (4 : Int)) | 2 => (BitVec.ofInt _ (1 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (12 : Int)) | 1 => (BitVec.ofInt _ (1 : Int)) | 2 => (BitVec.ofInt _ (10 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (0 : Int)) | 1 => (BitVec.ofInt _ (14 : Int)) | 2 => (BitVec.ofInt _ (9 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (7 : Int)) | 1 => (BitVec.ofInt _ (7 : Int)) | 2 => (BitVec.ofInt _ (5 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (13 : Int)) | 1 => (BitVec.ofInt _ (3 : Int)) | 2 => (BitVec.ofInt _ (3 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (13 : Int)) | 1 => (BitVec.ofInt _ (12 : Int)) | 2 => (BitVec.ofInt _ (10 : Int)) | _ => default) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("out", Lean.toJson (o.«out»).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj []
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (14 : Int)) | 1 => (BitVec.ofInt _ (6 : Int)) | 2 => (BitVec.ofInt _ (10 : Int)) | _ => default) }
  let mut state : State p := resetState p first
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
