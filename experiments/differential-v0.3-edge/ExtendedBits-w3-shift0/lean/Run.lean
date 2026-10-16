import probes.ExtendedBits
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.ExtendedBits
def p : Params := { w := (3 : Int), shift := (0 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ «in» := (BitVec.ofInt _ (0 : Int)), flag := false, amount := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (0 : Int)), flag := false, amount := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (0 : Int)), flag := false, amount := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (0 : Int)), flag := false, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (0 : Int)), flag := true, amount := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (0 : Int)), flag := true, amount := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (0 : Int)), flag := true, amount := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (0 : Int)), flag := true, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (1 : Int)), flag := false, amount := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (1 : Int)), flag := false, amount := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (1 : Int)), flag := false, amount := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (1 : Int)), flag := false, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (1 : Int)), flag := true, amount := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (1 : Int)), flag := true, amount := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (1 : Int)), flag := true, amount := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (1 : Int)), flag := true, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (2 : Int)), flag := false, amount := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (2 : Int)), flag := false, amount := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (2 : Int)), flag := false, amount := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (2 : Int)), flag := false, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (2 : Int)), flag := true, amount := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (2 : Int)), flag := true, amount := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (2 : Int)), flag := true, amount := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (2 : Int)), flag := true, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (3 : Int)), flag := false, amount := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (3 : Int)), flag := false, amount := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (3 : Int)), flag := false, amount := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (3 : Int)), flag := false, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (3 : Int)), flag := true, amount := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (3 : Int)), flag := true, amount := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (3 : Int)), flag := true, amount := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (3 : Int)), flag := true, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (4 : Int)), flag := false, amount := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (4 : Int)), flag := false, amount := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (4 : Int)), flag := false, amount := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (4 : Int)), flag := false, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (4 : Int)), flag := true, amount := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (4 : Int)), flag := true, amount := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (4 : Int)), flag := true, amount := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (4 : Int)), flag := true, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (5 : Int)), flag := false, amount := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (5 : Int)), flag := false, amount := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (5 : Int)), flag := false, amount := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (5 : Int)), flag := false, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (5 : Int)), flag := true, amount := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (5 : Int)), flag := true, amount := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (5 : Int)), flag := true, amount := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (5 : Int)), flag := true, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (6 : Int)), flag := false, amount := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (6 : Int)), flag := false, amount := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (6 : Int)), flag := false, amount := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (6 : Int)), flag := false, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (6 : Int)), flag := true, amount := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (6 : Int)), flag := true, amount := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (6 : Int)), flag := true, amount := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (6 : Int)), flag := true, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (7 : Int)), flag := false, amount := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (7 : Int)), flag := false, amount := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (7 : Int)), flag := false, amount := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (7 : Int)), flag := false, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (7 : Int)), flag := true, amount := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (7 : Int)), flag := true, amount := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (7 : Int)), flag := true, amount := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (7 : Int)), flag := true, amount := (BitVec.ofInt _ (3 : Int)) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("inverted", Lean.toJson (o.inverted).toNat), ("negative", Lean.toJson (o.negative).toNat), ("concatenated", Lean.toJson (o.concatenated).toNat), ("isZero", Lean.toJson (o.isZero)), ("shifted", Lean.toJson (o.shifted).toNat), ("dynamic", Lean.toJson (o.dynamic).toNat), ("padded", Lean.toJson (o.padded).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj []
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { «in» := (BitVec.ofInt _ (0 : Int)), flag := false, amount := (BitVec.ofInt _ (0 : Int)) }
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
