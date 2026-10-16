import probes.CombinationalDependencies
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.CombinationalDependencies
def p : Params := { w := (9 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ io_en := true, io_in := (BitVec.ofInt _ (198 : Int)) }, false),
  ({ io_en := true, io_in := (BitVec.ofInt _ (484 : Int)) }, false),
  ({ io_en := false, io_in := (BitVec.ofInt _ (424 : Int)) }, false),
  ({ io_en := false, io_in := (BitVec.ofInt _ (242 : Int)) }, false),
  ({ io_en := false, io_in := (BitVec.ofInt _ (19 : Int)) }, false),
  ({ io_en := false, io_in := (BitVec.ofInt _ (106 : Int)) }, false),
  ({ io_en := false, io_in := (BitVec.ofInt _ (132 : Int)) }, false),
  ({ io_en := false, io_in := (BitVec.ofInt _ (462 : Int)) }, false),
  ({ io_en := true, io_in := (BitVec.ofInt _ (156 : Int)) }, false),
  ({ io_en := false, io_in := (BitVec.ofInt _ (142 : Int)) }, false),
  ({ io_en := false, io_in := (BitVec.ofInt _ (184 : Int)) }, false),
  ({ io_en := true, io_in := (BitVec.ofInt _ (406 : Int)) }, false),
  ({ io_en := true, io_in := (BitVec.ofInt _ (347 : Int)) }, false),
  ({ io_en := true, io_in := (BitVec.ofInt _ (486 : Int)) }, false),
  ({ io_en := true, io_in := (BitVec.ofInt _ (441 : Int)) }, false),
  ({ io_en := true, io_in := (BitVec.ofInt _ (405 : Int)) }, false),
  ({ io_en := false, io_in := (BitVec.ofInt _ (313 : Int)) }, false),
  ({ io_en := false, io_in := (BitVec.ofInt _ (151 : Int)) }, false),
  ({ io_en := true, io_in := (BitVec.ofInt _ (241 : Int)) }, false),
  ({ io_en := false, io_in := (BitVec.ofInt _ (47 : Int)) }, false),
  ({ io_en := true, io_in := (BitVec.ofInt _ (71 : Int)) }, false),
  ({ io_en := true, io_in := (BitVec.ofInt _ (462 : Int)) }, false),
  ({ io_en := false, io_in := (BitVec.ofInt _ (25 : Int)) }, false),
  ({ io_en := true, io_in := (BitVec.ofInt _ (26 : Int)) }, false),
  ({ io_en := true, io_in := (BitVec.ofInt _ (208 : Int)) }, false),
  ({ io_en := true, io_in := (BitVec.ofInt _ (201 : Int)) }, false),
  ({ io_en := false, io_in := (BitVec.ofInt _ (39 : Int)) }, false),
  ({ io_en := true, io_in := (BitVec.ofInt _ (72 : Int)) }, false),
  ({ io_en := true, io_in := (BitVec.ofInt _ (40 : Int)) }, false),
  ({ io_en := false, io_in := (BitVec.ofInt _ (301 : Int)) }, false),
  ({ io_en := false, io_in := (BitVec.ofInt _ (471 : Int)) }, false),
  ({ io_en := false, io_in := (BitVec.ofInt _ (369 : Int)) }, false),
  ({ io_en := true, io_in := (BitVec.ofInt _ (148 : Int)) }, false),
  ({ io_en := false, io_in := (BitVec.ofInt _ (8 : Int)) }, false),
  ({ io_en := true, io_in := (BitVec.ofInt _ (196 : Int)) }, false),
  ({ io_en := true, io_in := (BitVec.ofInt _ (69 : Int)) }, false),
  ({ io_en := true, io_in := (BitVec.ofInt _ (121 : Int)) }, false),
  ({ io_en := true, io_in := (BitVec.ofInt _ (335 : Int)) }, false),
  ({ io_en := true, io_in := (BitVec.ofInt _ (353 : Int)) }, false),
  ({ io_en := true, io_in := (BitVec.ofInt _ (495 : Int)) }, false),
  ({ io_en := true, io_in := (BitVec.ofInt _ (47 : Int)) }, false),
  ({ io_en := true, io_in := (BitVec.ofInt _ (223 : Int)) }, false),
  ({ io_en := false, io_in := (BitVec.ofInt _ (370 : Int)) }, false),
  ({ io_en := true, io_in := (BitVec.ofInt _ (280 : Int)) }, false),
  ({ io_en := true, io_in := (BitVec.ofInt _ (175 : Int)) }, false),
  ({ io_en := true, io_in := (BitVec.ofInt _ (274 : Int)) }, false),
  ({ io_en := false, io_in := (BitVec.ofInt _ (236 : Int)) }, false),
  ({ io_en := true, io_in := (BitVec.ofInt _ (201 : Int)) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("io.out", Lean.toJson (o.io_out).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj []
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { io_en := true, io_in := (BitVec.ofInt _ (198 : Int)) }
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
