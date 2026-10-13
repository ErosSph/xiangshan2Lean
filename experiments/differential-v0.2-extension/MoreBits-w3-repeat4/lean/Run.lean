import probes.MoreBits
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.MoreBits
def p : Params := { w := (3 : Int), «repeat» := (4 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ a := (BitVec.ofInt _ (7 : Int)), b := (BitVec.ofInt _ (3 : Int)), shift := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (7 : Int)), b := (BitVec.ofInt _ (1 : Int)), shift := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (0 : Int)), b := (BitVec.ofInt _ (3 : Int)), shift := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (0 : Int)), b := (BitVec.ofInt _ (3 : Int)), shift := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (3 : Int)), b := (BitVec.ofInt _ (2 : Int)), shift := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (7 : Int)), b := (BitVec.ofInt _ (7 : Int)), shift := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (0 : Int)), b := (BitVec.ofInt _ (2 : Int)), shift := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (2 : Int)), b := (BitVec.ofInt _ (5 : Int)), shift := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (6 : Int)), b := (BitVec.ofInt _ (5 : Int)), shift := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (7 : Int)), b := (BitVec.ofInt _ (7 : Int)), shift := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (7 : Int)), b := (BitVec.ofInt _ (6 : Int)), shift := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (6 : Int)), b := (BitVec.ofInt _ (3 : Int)), shift := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (0 : Int)), b := (BitVec.ofInt _ (7 : Int)), shift := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (7 : Int)), b := (BitVec.ofInt _ (7 : Int)), shift := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (0 : Int)), b := (BitVec.ofInt _ (6 : Int)), shift := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (6 : Int)), b := (BitVec.ofInt _ (3 : Int)), shift := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (3 : Int)), b := (BitVec.ofInt _ (3 : Int)), shift := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (7 : Int)), b := (BitVec.ofInt _ (1 : Int)), shift := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (0 : Int)), b := (BitVec.ofInt _ (3 : Int)), shift := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (2 : Int)), b := (BitVec.ofInt _ (7 : Int)), shift := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (5 : Int)), b := (BitVec.ofInt _ (6 : Int)), shift := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (3 : Int)), b := (BitVec.ofInt _ (7 : Int)), shift := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (6 : Int)), b := (BitVec.ofInt _ (1 : Int)), shift := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (5 : Int)), b := (BitVec.ofInt _ (4 : Int)), shift := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (7 : Int)), b := (BitVec.ofInt _ (7 : Int)), shift := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (0 : Int)), b := (BitVec.ofInt _ (4 : Int)), shift := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (3 : Int)), b := (BitVec.ofInt _ (5 : Int)), shift := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (4 : Int)), b := (BitVec.ofInt _ (4 : Int)), shift := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (5 : Int)), b := (BitVec.ofInt _ (4 : Int)), shift := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (3 : Int)), b := (BitVec.ofInt _ (5 : Int)), shift := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (3 : Int)), b := (BitVec.ofInt _ (3 : Int)), shift := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (1 : Int)), b := (BitVec.ofInt _ (5 : Int)), shift := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (4 : Int)), b := (BitVec.ofInt _ (7 : Int)), shift := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (5 : Int)), b := (BitVec.ofInt _ (7 : Int)), shift := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (3 : Int)), b := (BitVec.ofInt _ (5 : Int)), shift := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (2 : Int)), b := (BitVec.ofInt _ (5 : Int)), shift := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (3 : Int)), b := (BitVec.ofInt _ (1 : Int)), shift := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (6 : Int)), b := (BitVec.ofInt _ (1 : Int)), shift := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (5 : Int)), b := (BitVec.ofInt _ (2 : Int)), shift := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (0 : Int)), b := (BitVec.ofInt _ (7 : Int)), shift := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (3 : Int)), b := (BitVec.ofInt _ (3 : Int)), shift := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (6 : Int)), b := (BitVec.ofInt _ (1 : Int)), shift := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (6 : Int)), b := (BitVec.ofInt _ (6 : Int)), shift := (BitVec.ofInt _ (2 : Int)) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("quotient", Lean.toJson (o.quotient).toNat), ("remainder", Lean.toJson (o.remainder).toNat), ("shifted", Lean.toJson (o.shifted).toNat), ("top", Lean.toJson (o.top).toNat), ("bottom", Lean.toJson (o.bottom).toNat), ("filled", Lean.toJson (o.filled).toNat), ("bit", Lean.toJson (o.bit))]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj []
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { a := (BitVec.ofInt _ (7 : Int)), b := (BitVec.ofInt _ (3 : Int)), shift := (BitVec.ofInt _ (2 : Int)) }
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
