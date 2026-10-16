import configuration.ConfiguredPipeline
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open configuration.ConfiguredPipeline
def p : Params := { inc := (2 : Int), cfg_p_configuration_CoreKey_width := (4 : Int), cfg_p_configuration_CoreKey_enabled := false, cfg_p_configuration_CoreKey_nested_offset := (3 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ data := (BitVec.ofInt _ (31 : Int)) }, true),
  ({ data := (BitVec.ofInt _ (26 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (18 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (13 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (5 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (31 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (22 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (23 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (4 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (26 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (22 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (18 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (14 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (16 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (13 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (18 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (23 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (11 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (12 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (6 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (26 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (7 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (26 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (14 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (16 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (1 : Int)) }, true),
  ({ data := (BitVec.ofInt _ (30 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (20 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (26 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (7 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (4 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (19 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (8 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (8 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (25 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (21 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (21 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (31 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (26 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (6 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (26 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (10 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (27 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (21 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (16 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (23 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (10 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (6 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (19 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (7 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (28 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (27 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (20 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (26 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (12 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (4 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (6 : Int)) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("out", Lean.toJson (o.«out»).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("stored", Lean.toJson (s.stored).toNat)]
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { data := (BitVec.ofInt _ (31 : Int)) }
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
