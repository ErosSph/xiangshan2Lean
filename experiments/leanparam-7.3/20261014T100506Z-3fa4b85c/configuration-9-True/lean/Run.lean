import leanparam.AnnotatedConfiguration
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open leanparam.AnnotatedConfiguration
def p : Params := { cfg_p_leanparam_SettingsKey_width := (9 : Int), cfg_p_leanparam_SettingsKey_enabled := true }
def inputsTrace : List (Inputs p × Bool) := [
  ({ data := (BitVec.ofInt _ (259 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (270 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (206 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (361 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (246 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (375 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (23 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (416 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (78 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (408 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (209 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (319 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (354 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (303 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (265 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (363 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (44 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (412 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (20 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (147 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (467 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (385 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (151 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (298 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (55 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (291 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (230 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (417 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (266 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (382 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (336 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (40 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (31 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (279 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (257 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (156 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (245 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (329 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (277 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (308 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (361 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (21 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (286 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (153 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (276 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (232 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (198 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (98 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (37 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (323 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (158 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (41 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (186 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (9 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (241 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (85 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (139 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (335 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (281 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (287 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (43 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (459 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (414 : Int)) }, false),
  ({ data := (BitVec.ofInt _ (511 : Int)) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("out", Lean.toJson (o.«out»).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj []
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { data := (BitVec.ofInt _ (259 : Int)) }
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
