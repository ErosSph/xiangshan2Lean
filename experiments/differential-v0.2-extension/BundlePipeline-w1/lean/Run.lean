import probes.BundlePipeline
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.BundlePipeline
def p : Params := { w := (1 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ in_data := (BitVec.ofInt _ (1 : Int)), in_valid := false }, true),
  ({ in_data := (BitVec.ofInt _ (1 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (0 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (0 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (0 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (0 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (0 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (0 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (1 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (0 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (0 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (1 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (1 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (1 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (1 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (1 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (0 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (0 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (1 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (0 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (1 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (1 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (0 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (1 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (1 : Int)), in_valid := false }, true),
  ({ in_data := (BitVec.ofInt _ (1 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (0 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (1 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (1 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (0 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (0 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (0 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (1 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (0 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (1 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (1 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (1 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (1 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (1 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (1 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (1 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (1 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (0 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (1 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (1 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (1 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (0 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (1 : Int)), in_valid := false }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("out.data", Lean.toJson (o.out_data).toNat), ("out.valid", Lean.toJson (o.out_valid))]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("r.data", Lean.toJson (s.r_data).toNat), ("r.valid", Lean.toJson (s.r_valid))]
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { in_data := (BitVec.ofInt _ (1 : Int)), in_valid := false }
  let mut state : State p := { r_data := (BitVec.ofInt _ (0 : Int)), r_valid := false }
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
