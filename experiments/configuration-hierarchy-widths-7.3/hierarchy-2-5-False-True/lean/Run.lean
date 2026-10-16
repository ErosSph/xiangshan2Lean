import configuration.ConfiguredHierarchy
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open configuration.ConfiguredHierarchy
def p : Params := { inc := (1 : Int), cfg_p_configuration_CoreKey_width := (2 : Int), cfg_p_configuration_CoreKey_nested_offset := (1 : Int), cfg_p_configuration_CoreKey_enabled := false, cfg_other_configuration_CoreKey_width := (5 : Int), cfg_other_configuration_CoreKey_nested_offset := (3 : Int), cfg_other_configuration_CoreKey_enabled := true }
def inputsTrace : List (Inputs p × Bool) := [
  ({ data := (BitVec.ofInt _ (46 : Int)) }, true),
  ({ data := (BitVec.ofInt _ (147 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (188 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (115 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (97 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (122 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (175 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (10 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (213 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (101 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (163 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (111 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (186 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (213 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (139 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (161 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (159 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (81 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (25 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (69 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (90 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (130 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (248 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (233 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (203 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (142 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (216 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (21 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (73 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (241 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (249 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (95 : Int)) }, true),
  ({ data := (BitVec.ofInt _ (105 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (187 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (217 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (188 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (213 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (175 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (221 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (176 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (133 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (107 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (36 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (252 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (106 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (225 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (229 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (222 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (204 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (132 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (19 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (16 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (206 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (16 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (187 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (70 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (240 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (174 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (28 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (109 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (218 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (132 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (149 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (241 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (65 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (221 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (153 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (38 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (73 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (246 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (70 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (13 : Int)) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("out", Lean.toJson (o.«out»).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("stage.left.saved", Lean.toJson (s.stage_left_saved).toNat), ("stage.right.saved", Lean.toJson (s.stage_right_saved).toNat)]
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { data := (BitVec.ofInt _ (46 : Int)) }
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
