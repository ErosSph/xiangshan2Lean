import configuration.ConfiguredPipeline
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open configuration.ConfiguredPipeline
def p : Params := { inc := (2 : Int), cfg_p_configuration_CoreKey_width := (8 : Int), cfg_p_configuration_CoreKey_enabled := false, cfg_p_configuration_CoreKey_nested_offset := (3 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ data := (BitVec.ofInt _ (327 : Int)) }, true),
  ({ data := (BitVec.ofInt _ (194 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (193 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (94 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (457 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (497 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (235 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (376 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (63 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (354 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (483 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (504 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (84 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (348 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (179 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (256 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (452 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (287 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (164 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (87 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (460 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (352 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (36 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (75 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (353 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (32 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (206 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (498 : Int)) }, true),
  ({ data := (BitVec.ofInt _ (338 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (329 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (365 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (46 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (393 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (114 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (82 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (508 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (448 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (105 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (501 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (323 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (34 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (173 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (264 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (479 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (119 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (96 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (325 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (189 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (47 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (324 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (480 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (257 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (487 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (290 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (397 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (364 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (367 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (420 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (155 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (71 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (214 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (293 : Int)) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("out", Lean.toJson (o.«out»).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("stored", Lean.toJson (s.stored).toNat)]
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { data := (BitVec.ofInt _ (327 : Int)) }
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
