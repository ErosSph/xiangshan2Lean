import probes.DualRegister
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.DualRegister
def p : Params := { n := (9 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ io_in := (BitVec.ofInt _ (468 : Int)) }, true),
  ({ io_in := (BitVec.ofInt _ (198 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (335 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (484 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (99 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (424 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (54 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (242 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (75 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (19 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (226 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (106 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (255 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (132 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (205 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (462 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (501 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (156 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (47 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (142 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (229 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (184 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (333 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (406 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (427 : Int)) }, true),
  ({ io_in := (BitVec.ofInt _ (347 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (481 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (486 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (486 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (441 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (469 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (405 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (249 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (313 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (10 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (151 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (428 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (241 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (104 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (47 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (458 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (71 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (483 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (462 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (144 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (25 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (436 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (26 : Int)) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("io.a", Lean.toJson (o.io_a).toNat), ("io.b", Lean.toJson (o.io_b).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("first", Lean.toJson (s.first).toNat), ("second", Lean.toJson (s.second).toNat)]
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { io_in := (BitVec.ofInt _ (468 : Int)) }
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
