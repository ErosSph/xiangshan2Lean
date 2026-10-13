import probes.BundlePipeline
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.BundlePipeline
def p : Params := { w := (8 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ in_data := (BitVec.ofInt _ (234 : Int)), in_valid := false }, true),
  ({ in_data := (BitVec.ofInt _ (167 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (49 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (27 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (37 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (113 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (127 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (102 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (250 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (23 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (114 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (166 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (213 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (240 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (243 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (234 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (124 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (5 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (214 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (52 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (229 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (241 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (72 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (218 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (215 : Int)), in_valid := false }, true),
  ({ in_data := (BitVec.ofInt _ (191 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (118 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (245 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (151 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (111 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (79 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (74 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (206 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (45 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (229 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (235 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (200 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (229 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (144 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (237 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (196 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (142 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (113 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (146 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (133 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (183 : Int)), in_valid := true }, false),
  ({ in_data := (BitVec.ofInt _ (100 : Int)), in_valid := false }, false),
  ({ in_data := (BitVec.ofInt _ (167 : Int)), in_valid := false }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("out.data", Lean.toJson (o.out_data).toNat), ("out.valid", Lean.toJson (o.out_valid))]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("r.data", Lean.toJson (s.r_data).toNat), ("r.valid", Lean.toJson (s.r_valid))]
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { in_data := (BitVec.ofInt _ (234 : Int)), in_valid := false }
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
