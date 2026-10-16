import configuration.ConfiguredHierarchy
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open configuration.ConfiguredHierarchy
def p : Params := { inc := (1 : Int), cfg_p_configuration_CoreKey_width := (5 : Int), cfg_p_configuration_CoreKey_nested_offset := (3 : Int), cfg_p_configuration_CoreKey_enabled := true, cfg_other_configuration_CoreKey_width := (2 : Int), cfg_other_configuration_CoreKey_nested_offset := (1 : Int), cfg_other_configuration_CoreKey_enabled := true }
def inputsTrace : List (Inputs p × Bool) := [
  ({ data := (BitVec.ofInt _ (188 : Int)) }, true),
  ({ data := (BitVec.ofInt _ (103 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (9 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (255 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (90 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (75 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (105 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (55 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (180 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (50 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (45 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (189 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (37 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (88 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (35 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (203 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (143 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (22 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (52 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (77 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (35 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (122 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (158 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (33 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (91 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (60 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (103 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (36 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (222 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (147 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (213 : Int)) }, true),
  ({ data := (BitVec.ofInt _ (197 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (67 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (64 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (185 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (34 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (42 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (203 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (5 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (40 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (230 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (161 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (153 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (4 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (168 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (158 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (120 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (60 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (20 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (123 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (12 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (212 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (28 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (135 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (19 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (148 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (38 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (88 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (26 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (74 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (246 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (237 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (235 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (58 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (136 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (161 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (48 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (24 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (84 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (250 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (50 : Int)) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("out", Lean.toJson (o.«out»).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("stage.left.saved", Lean.toJson (s.stage_left_saved).toNat), ("stage.right.saved", Lean.toJson (s.stage_right_saved).toNat)]
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { data := (BitVec.ofInt _ (188 : Int)) }
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
