import configuration.ConfiguredHierarchy
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open configuration.ConfiguredHierarchy
def p : Params := { inc := (1 : Int), cfg_p_configuration_CoreKey_width := (5 : Int), cfg_p_configuration_CoreKey_nested_offset := (1 : Int), cfg_p_configuration_CoreKey_enabled := false, cfg_other_configuration_CoreKey_width := (2 : Int), cfg_other_configuration_CoreKey_nested_offset := (3 : Int), cfg_other_configuration_CoreKey_enabled := true }
def inputsTrace : List (Inputs p × Bool) := [
  ({ data := (BitVec.ofInt _ (27 : Int)) }, true),
  ({ data := (BitVec.ofInt _ (217 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (10 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (11 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (20 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (28 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (250 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (154 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (58 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (31 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (195 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (54 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (105 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (245 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (62 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (66 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (169 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (27 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (18 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (194 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (210 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (227 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (84 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (25 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (160 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (245 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (225 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (173 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (65 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (133 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (229 : Int)) }, true),
  ({ data := (BitVec.ofInt _ (84 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (9 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (99 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (187 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (170 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (117 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (207 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (50 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (20 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (49 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (77 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (152 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (201 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (181 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (179 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (49 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (31 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (12 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (175 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (134 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (209 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (246 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (187 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (226 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (129 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (183 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (246 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (250 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (105 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (29 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (118 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (76 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (205 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (240 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (108 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (76 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (135 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (218 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (193 : Int)) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("out", Lean.toJson (o.«out»).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("stage.left.saved", Lean.toJson (s.stage_left_saved).toNat), ("stage.right.saved", Lean.toJson (s.stage_right_saved).toNat)]
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { data := (BitVec.ofInt _ (27 : Int)) }
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
