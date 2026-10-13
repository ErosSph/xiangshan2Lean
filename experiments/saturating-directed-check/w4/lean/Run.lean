import walkthrough.SaturatingAccumulator
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open walkthrough.SaturatingAccumulator
def p : Params := { w := (4 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ en := false, clear := false, data := (BitVec.ofInt _ (0 : Int)) }, true),
  ({ en := false, clear := false, data := (BitVec.ofInt _ (9 : Int)) }, false),
  ({ en := true, clear := false, data := (BitVec.ofInt _ (5 : Int)) }, false),
  ({ en := true, clear := false, data := (BitVec.ofInt _ (7 : Int)) }, false),
  ({ en := false, clear := false, data := (BitVec.ofInt _ (9 : Int)) }, false),
  ({ en := true, clear := false, data := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ en := true, clear := false, data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ en := true, clear := false, data := (BitVec.ofInt _ (9 : Int)) }, false),
  ({ en := false, clear := false, data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ en := true, clear := true, data := (BitVec.ofInt _ (9 : Int)) }, false),
  ({ en := true, clear := false, data := (BitVec.ofInt _ (4 : Int)) }, false),
  ({ en := true, clear := false, data := (BitVec.ofInt _ (15 : Int)) }, true),
  ({ en := true, clear := false, data := (BitVec.ofInt _ (15 : Int)) }, false),
  ({ en := true, clear := false, data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ en := true, clear := false, data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ en := false, clear := true, data := (BitVec.ofInt _ (12 : Int)) }, false),
  ({ en := false, clear := false, data := (BitVec.ofInt _ (14 : Int)) }, false),
  ({ en := true, clear := false, data := (BitVec.ofInt _ (2 : Int)) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("value", Lean.toJson (o.value).toNat), ("overflow", Lean.toJson (o.overflow))]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("acc", Lean.toJson (s.acc).toNat), ("seenOverflow", Lean.toJson (s.seenOverflow))]
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { en := false, clear := false, data := (BitVec.ofInt _ (0 : Int)) }
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
