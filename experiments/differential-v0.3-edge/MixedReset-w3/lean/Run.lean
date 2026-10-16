import probes.MixedReset
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.MixedReset
def p : Params := { w := (3 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ «in» := (BitVec.ofInt _ (7 : Int)) }, true),
  ({ «in» := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (5 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (7 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (6 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (7 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (7 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (5 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (6 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (6 : Int)) }, true),
  ({ «in» := (BitVec.ofInt _ (5 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (7 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (7 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (7 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (6 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (7 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (6 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (4 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (6 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (7 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (7 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (7 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (6 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (0 : Int)) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("initialized", Lean.toJson (o.initialized).toNat), ("uninitialized", Lean.toJson (o.uninitialized).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("a", Lean.toJson (s.a).toNat), ("b", Lean.toJson (s.b).toNat)]
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { «in» := (BitVec.ofInt _ (7 : Int)) }
  let mut state : State p := { a := (BitVec.ofInt _ (0 : Int)), b := (BitVec.ofInt _ (0 : Int)) }
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
