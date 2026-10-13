import probes.RegisterIdioms
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.RegisterIdioms
def p : Params := { w := (9 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ «in» := (BitVec.ofInt _ (468 : Int)), en := false }, true),
  ({ «in» := (BitVec.ofInt _ (335 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (99 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (54 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (75 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (226 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (255 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (205 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (501 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (47 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (229 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (333 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (427 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (481 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (486 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (469 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (249 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (10 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (428 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (104 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (458 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (483 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (144 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (436 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (430 : Int)), en := false }, true),
  ({ «in» := (BitVec.ofInt _ (383 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (237 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (490 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (303 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (222 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (158 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (149 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (413 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (90 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (459 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (471 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (401 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (458 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (288 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (475 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (392 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (284 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (226 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (293 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (267 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (366 : Int)), en := true }, false),
  ({ «in» := (BitVec.ofInt _ (200 : Int)), en := false }, false),
  ({ «in» := (BitVec.ofInt _ (335 : Int)), en := false }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("out", Lean.toJson (o.«out»).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("delayed", Lean.toJson (s.delayed).toNat), ("held", Lean.toJson (s.held).toNat), ("explicit", Lean.toJson (s.explicit).toNat)]
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { «in» := (BitVec.ofInt _ (468 : Int)), en := false }
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
