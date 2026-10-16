import probes.ConditionalPriority
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.ConditionalPriority
def p : Params := { w := (3 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ a := true, b := false, c := true }, true),
  ({ a := true, b := false, c := true }, false),
  ({ a := false, b := false, c := false }, false),
  ({ a := false, b := false, c := false }, false),
  ({ a := false, b := false, c := false }, false),
  ({ a := true, b := true, c := false }, false),
  ({ a := false, b := false, c := false }, false),
  ({ a := false, b := true, c := true }, false),
  ({ a := true, b := true, c := true }, false),
  ({ a := true, b := true, c := true }, false),
  ({ a := true, b := true, c := false }, false),
  ({ a := true, b := false, c := false }, false),
  ({ a := true, b := false, c := false }, false),
  ({ a := false, b := true, c := false }, false),
  ({ a := true, b := true, c := false }, false),
  ({ a := false, b := true, c := false }, false),
  ({ a := true, b := false, c := true }, false),
  ({ a := false, b := false, c := false }, false),
  ({ a := true, b := false, c := true }, false),
  ({ a := false, b := false, c := true }, false),
  ({ a := false, b := true, c := false }, false),
  ({ a := true, b := true, c := false }, false),
  ({ a := false, b := false, c := true }, false),
  ({ a := false, b := true, c := false }, false),
  ({ a := true, b := false, c := true }, true),
  ({ a := true, b := true, c := true }, false),
  ({ a := true, b := true, c := true }, false),
  ({ a := false, b := true, c := false }, false),
  ({ a := false, b := true, c := true }, false),
  ({ a := true, b := true, c := false }, false),
  ({ a := true, b := true, c := false }, false),
  ({ a := false, b := true, c := false }, false),
  ({ a := false, b := false, c := false }, false),
  ({ a := false, b := true, c := false }, false),
  ({ a := true, b := true, c := true }, false),
  ({ a := true, b := true, c := false }, false),
  ({ a := false, b := true, c := true }, false),
  ({ a := false, b := true, c := true }, false),
  ({ a := true, b := false, c := true }, false),
  ({ a := false, b := false, c := true }, false),
  ({ a := true, b := false, c := false }, false),
  ({ a := true, b := false, c := false }, false),
  ({ a := true, b := false, c := false }, false),
  ({ a := true, b := false, c := true }, false),
  ({ a := false, b := true, c := true }, false),
  ({ a := false, b := false, c := false }, false),
  ({ a := true, b := false, c := false }, false),
  ({ a := true, b := true, c := true }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("combinational", Lean.toJson (o.combinational).toNat), ("sequential", Lean.toJson (o.sequential).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("r", Lean.toJson (s.r).toNat)]
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { a := true, b := false, c := true }
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
