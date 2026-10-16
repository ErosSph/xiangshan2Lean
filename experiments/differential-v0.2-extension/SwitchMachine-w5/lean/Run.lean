import probes.SwitchMachine
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.SwitchMachine
def p : Params := { w := (5 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ «in» := (BitVec.ofInt _ (29 : Int)), en := false }, true),
  ({ «in» := (BitVec.ofInt _ (20 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (6 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (3 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (4 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (14 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (15 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (12 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (31 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (2 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (14 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (20 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (26 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (30 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (30 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (29 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (15 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (0 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (26 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (6 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (28 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (30 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (9 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (27 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (26 : Int)), en := false }, true),
  ({ «in» := (BitVec.ofInt _ (23 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (14 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (30 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (18 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (13 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (9 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (9 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (25 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (5 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (28 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (29 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (25 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (28 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (18 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (29 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (24 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (17 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (14 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (18 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (16 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (22 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (12 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (20 : Int)), en := false }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("out", Lean.toJson (o.«out»).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("state", Lean.toJson (s.state).toNat), ("data", Lean.toJson (s.data).toNat)]
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { «in» := (BitVec.ofInt _ (29 : Int)), en := false }
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
