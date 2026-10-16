import leanparam.AnnotatedCounter
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open leanparam.AnnotatedCounter
def p : Params := { n := (1 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ en := false }, true),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := false }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := false }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := false }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := false }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, true),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := false }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := false }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := false }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := false }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := true }, false),
  ({ en := false }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("out", Lean.toJson (o.«out»).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("count", Lean.toJson (s.count).toNat)]
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { en := false }
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
