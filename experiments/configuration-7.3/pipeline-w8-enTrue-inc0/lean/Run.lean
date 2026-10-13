import configuration.ConfiguredPipeline
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open configuration.ConfiguredPipeline
def p : Params := { inc := (0 : Int), cfg_p_configuration_CoreKey_width := (8 : Int), cfg_p_configuration_CoreKey_enabled := true, cfg_p_configuration_CoreKey_nested_offset := (3 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ data := (BitVec.ofInt _ (493 : Int)) }, true),
  ({ data := (BitVec.ofInt _ (499 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (503 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (110 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (350 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (39 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (227 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (374 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (401 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (406 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (495 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (21 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (438 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (474 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (427 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (427 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (245 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (329 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (426 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (224 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (440 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (163 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (150 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (371 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (437 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (313 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (106 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (79 : Int)) }, true),
  ({ data := (BitVec.ofInt _ (369 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (328 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (149 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (483 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (370 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (281 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (22 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (296 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (500 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (432 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (467 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (120 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (503 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (178 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (354 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (4 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (454 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (62 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (273 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (139 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (237 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (203 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (476 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (162 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (63 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (366 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (371 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (15 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (327 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (108 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (190 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (54 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (355 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (373 : Int)) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("out", Lean.toJson (o.«out»).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("stored", Lean.toJson (s.stored).toNat)]
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { data := (BitVec.ofInt _ (493 : Int)) }
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
