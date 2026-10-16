import configuration.ConfiguredHierarchy
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open configuration.ConfiguredHierarchy
def p : Params := { inc := (1 : Int), cfg_p_configuration_CoreKey_width := (5 : Int), cfg_p_configuration_CoreKey_nested_offset := (1 : Int), cfg_p_configuration_CoreKey_enabled := true, cfg_other_configuration_CoreKey_width := (2 : Int), cfg_other_configuration_CoreKey_nested_offset := (3 : Int), cfg_other_configuration_CoreKey_enabled := false }
def inputsTrace : List (Inputs p × Bool) := [
  ({ data := (BitVec.ofInt _ (201 : Int)) }, true),
  ({ data := (BitVec.ofInt _ (114 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (113 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (61 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (224 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (102 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (56 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (140 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (213 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (205 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (141 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (107 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (87 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (159 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (143 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (165 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (225 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (81 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (57 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (19 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (231 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (8 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (22 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (160 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (255 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (39 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (173 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (42 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (84 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (225 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (31 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (111 : Int)) }, true),
  ({ data := (BitVec.ofInt _ (190 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (140 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (184 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (137 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (201 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (83 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (229 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (84 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (224 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (243 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (224 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (102 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (62 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (147 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (8 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (121 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (184 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (226 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (21 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (79 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (61 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (177 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (85 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (14 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (7 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (89 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (184 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (17 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (91 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (87 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (175 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (131 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (21 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (29 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (80 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (139 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (240 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (254 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (100 : Int)) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("out", Lean.toJson (o.«out»).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("stage.left.saved", Lean.toJson (s.stage_left_saved).toNat), ("stage.right.saved", Lean.toJson (s.stage_right_saved).toNat)]
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { data := (BitVec.ofInt _ (201 : Int)) }
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
