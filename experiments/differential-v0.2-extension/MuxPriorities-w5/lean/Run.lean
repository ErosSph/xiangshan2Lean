import probes.MuxPriorities
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.MuxPriorities
def p : Params := { w := (5 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ a := (BitVec.ofInt _ (29 : Int)), b := (BitVec.ofInt _ (12 : Int)), c := (BitVec.ofInt _ (20 : Int)), sel := (BitVec.ofInt _ (3 : Int)), x := false, y := true }, false),
  ({ a := (BitVec.ofInt _ (3 : Int)), b := (BitVec.ofInt _ (15 : Int)), c := (BitVec.ofInt _ (4 : Int)), sel := (BitVec.ofInt _ (0 : Int)), x := false, y := false }, false),
  ({ a := (BitVec.ofInt _ (15 : Int)), b := (BitVec.ofInt _ (8 : Int)), c := (BitVec.ofInt _ (12 : Int)), sel := (BitVec.ofInt _ (3 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (2 : Int)), b := (BitVec.ofInt _ (8 : Int)), c := (BitVec.ofInt _ (14 : Int)), sel := (BitVec.ofInt _ (1 : Int)), x := true, y := true }, false),
  ({ a := (BitVec.ofInt _ (26 : Int)), b := (BitVec.ofInt _ (21 : Int)), c := (BitVec.ofInt _ (30 : Int)), sel := (BitVec.ofInt _ (3 : Int)), x := true, y := true }, false),
  ({ a := (BitVec.ofInt _ (29 : Int)), b := (BitVec.ofInt _ (25 : Int)), c := (BitVec.ofInt _ (15 : Int)), sel := (BitVec.ofInt _ (2 : Int)), x := false, y := false }, false),
  ({ a := (BitVec.ofInt _ (26 : Int)), b := (BitVec.ofInt _ (15 : Int)), c := (BitVec.ofInt _ (6 : Int)), sel := (BitVec.ofInt _ (0 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (30 : Int)), b := (BitVec.ofInt _ (28 : Int)), c := (BitVec.ofInt _ (9 : Int)), sel := (BitVec.ofInt _ (0 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (26 : Int)), b := (BitVec.ofInt _ (13 : Int)), c := (BitVec.ofInt _ (23 : Int)), sel := (BitVec.ofInt _ (1 : Int)), x := false, y := false }, false),
  ({ a := (BitVec.ofInt _ (30 : Int)), b := (BitVec.ofInt _ (4 : Int)), c := (BitVec.ofInt _ (18 : Int)), sel := (BitVec.ofInt _ (0 : Int)), x := false, y := true }, false),
  ({ a := (BitVec.ofInt _ (9 : Int)), b := (BitVec.ofInt _ (29 : Int)), c := (BitVec.ofInt _ (9 : Int)), sel := (BitVec.ofInt _ (2 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (5 : Int)), b := (BitVec.ofInt _ (0 : Int)), c := (BitVec.ofInt _ (28 : Int)), sel := (BitVec.ofInt _ (1 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (25 : Int)), b := (BitVec.ofInt _ (7 : Int)), c := (BitVec.ofInt _ (28 : Int)), sel := (BitVec.ofInt _ (2 : Int)), x := true, y := true }, false),
  ({ a := (BitVec.ofInt _ (29 : Int)), b := (BitVec.ofInt _ (30 : Int)), c := (BitVec.ofInt _ (24 : Int)), sel := (BitVec.ofInt _ (0 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (14 : Int)), b := (BitVec.ofInt _ (23 : Int)), c := (BitVec.ofInt _ (18 : Int)), sel := (BitVec.ofInt _ (2 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (22 : Int)), b := (BitVec.ofInt _ (17 : Int)), c := (BitVec.ofInt _ (12 : Int)), sel := (BitVec.ofInt _ (1 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (13 : Int)), b := (BitVec.ofInt _ (14 : Int)), c := (BitVec.ofInt _ (1 : Int)), sel := (BitVec.ofInt _ (0 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (17 : Int)), b := (BitVec.ofInt _ (28 : Int)), c := (BitVec.ofInt _ (24 : Int)), sel := (BitVec.ofInt _ (2 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (15 : Int)), b := (BitVec.ofInt _ (22 : Int)), c := (BitVec.ofInt _ (22 : Int)), sel := (BitVec.ofInt _ (1 : Int)), x := true, y := true }, false),
  ({ a := (BitVec.ofInt _ (26 : Int)), b := (BitVec.ofInt _ (0 : Int)), c := (BitVec.ofInt _ (21 : Int)), sel := (BitVec.ofInt _ (1 : Int)), x := false, y := true }, false),
  ({ a := (BitVec.ofInt _ (23 : Int)), b := (BitVec.ofInt _ (1 : Int)), c := (BitVec.ofInt _ (4 : Int)), sel := (BitVec.ofInt _ (3 : Int)), x := false, y := false }, false),
  ({ a := (BitVec.ofInt _ (21 : Int)), b := (BitVec.ofInt _ (9 : Int)), c := (BitVec.ofInt _ (2 : Int)), sel := (BitVec.ofInt _ (3 : Int)), x := false, y := true }, false),
  ({ a := (BitVec.ofInt _ (1 : Int)), b := (BitVec.ofInt _ (29 : Int)), c := (BitVec.ofInt _ (18 : Int)), sel := (BitVec.ofInt _ (1 : Int)), x := false, y := false }, false),
  ({ a := (BitVec.ofInt _ (27 : Int)), b := (BitVec.ofInt _ (6 : Int)), c := (BitVec.ofInt _ (6 : Int)), sel := (BitVec.ofInt _ (3 : Int)), x := true, y := true }, false),
  ({ a := (BitVec.ofInt _ (16 : Int)), b := (BitVec.ofInt _ (10 : Int)), c := (BitVec.ofInt _ (23 : Int)), sel := (BitVec.ofInt _ (1 : Int)), x := false, y := false }, false),
  ({ a := (BitVec.ofInt _ (29 : Int)), b := (BitVec.ofInt _ (17 : Int)), c := (BitVec.ofInt _ (1 : Int)), sel := (BitVec.ofInt _ (2 : Int)), x := false, y := true }, false),
  ({ a := (BitVec.ofInt _ (23 : Int)), b := (BitVec.ofInt _ (2 : Int)), c := (BitVec.ofInt _ (15 : Int)), sel := (BitVec.ofInt _ (0 : Int)), x := true, y := true }, false),
  ({ a := (BitVec.ofInt _ (10 : Int)), b := (BitVec.ofInt _ (30 : Int)), c := (BitVec.ofInt _ (31 : Int)), sel := (BitVec.ofInt _ (2 : Int)), x := false, y := false }, false),
  ({ a := (BitVec.ofInt _ (4 : Int)), b := (BitVec.ofInt _ (2 : Int)), c := (BitVec.ofInt _ (6 : Int)), sel := (BitVec.ofInt _ (0 : Int)), x := false, y := false }, false),
  ({ a := (BitVec.ofInt _ (29 : Int)), b := (BitVec.ofInt _ (6 : Int)), c := (BitVec.ofInt _ (19 : Int)), sel := (BitVec.ofInt _ (3 : Int)), x := true, y := true }, false),
  ({ a := (BitVec.ofInt _ (8 : Int)), b := (BitVec.ofInt _ (21 : Int)), c := (BitVec.ofInt _ (31 : Int)), sel := (BitVec.ofInt _ (2 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (24 : Int)), b := (BitVec.ofInt _ (10 : Int)), c := (BitVec.ofInt _ (31 : Int)), sel := (BitVec.ofInt _ (2 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (18 : Int)), b := (BitVec.ofInt _ (10 : Int)), c := (BitVec.ofInt _ (11 : Int)), sel := (BitVec.ofInt _ (2 : Int)), x := true, y := true }, false),
  ({ a := (BitVec.ofInt _ (20 : Int)), b := (BitVec.ofInt _ (7 : Int)), c := (BitVec.ofInt _ (2 : Int)), sel := (BitVec.ofInt _ (2 : Int)), x := true, y := true }, false),
  ({ a := (BitVec.ofInt _ (22 : Int)), b := (BitVec.ofInt _ (12 : Int)), c := (BitVec.ofInt _ (24 : Int)), sel := (BitVec.ofInt _ (2 : Int)), x := false, y := true }, false),
  ({ a := (BitVec.ofInt _ (19 : Int)), b := (BitVec.ofInt _ (14 : Int)), c := (BitVec.ofInt _ (28 : Int)), sel := (BitVec.ofInt _ (1 : Int)), x := true, y := true }, false),
  ({ a := (BitVec.ofInt _ (30 : Int)), b := (BitVec.ofInt _ (10 : Int)), c := (BitVec.ofInt _ (20 : Int)), sel := (BitVec.ofInt _ (2 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (15 : Int)), b := (BitVec.ofInt _ (24 : Int)), c := (BitVec.ofInt _ (4 : Int)), sel := (BitVec.ofInt _ (3 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (2 : Int)), b := (BitVec.ofInt _ (20 : Int)), c := (BitVec.ofInt _ (0 : Int)), sel := (BitVec.ofInt _ (0 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (19 : Int)), b := (BitVec.ofInt _ (17 : Int)), c := (BitVec.ofInt _ (27 : Int)), sel := (BitVec.ofInt _ (0 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (24 : Int)), b := (BitVec.ofInt _ (23 : Int)), c := (BitVec.ofInt _ (8 : Int)), sel := (BitVec.ofInt _ (3 : Int)), x := false, y := true }, false),
  ({ a := (BitVec.ofInt _ (1 : Int)), b := (BitVec.ofInt _ (9 : Int)), c := (BitVec.ofInt _ (21 : Int)), sel := (BitVec.ofInt _ (0 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (19 : Int)), b := (BitVec.ofInt _ (14 : Int)), c := (BitVec.ofInt _ (21 : Int)), sel := (BitVec.ofInt _ (3 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (23 : Int)), b := (BitVec.ofInt _ (11 : Int)), c := (BitVec.ofInt _ (4 : Int)), sel := (BitVec.ofInt _ (3 : Int)), x := false, y := true }, false),
  ({ a := (BitVec.ofInt _ (24 : Int)), b := (BitVec.ofInt _ (10 : Int)), c := (BitVec.ofInt _ (29 : Int)), sel := (BitVec.ofInt _ (2 : Int)), x := false, y := false }, false),
  ({ a := (BitVec.ofInt _ (14 : Int)), b := (BitVec.ofInt _ (14 : Int)), c := (BitVec.ofInt _ (15 : Int)), sel := (BitVec.ofInt _ (2 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (5 : Int)), b := (BitVec.ofInt _ (10 : Int)), c := (BitVec.ofInt _ (23 : Int)), sel := (BitVec.ofInt _ (3 : Int)), x := true, y := true }, false),
  ({ a := (BitVec.ofInt _ (27 : Int)), b := (BitVec.ofInt _ (17 : Int)), c := (BitVec.ofInt _ (28 : Int)), sel := (BitVec.ofInt _ (0 : Int)), x := true, y := true }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("lookup", Lean.toJson (o.lookup).toNat), ("muxcase", Lean.toJson (o.muxcase).toNat), ("priority", Lean.toJson (o.priority).toNat), ("widthCheck", Lean.toJson (o.widthCheck).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj []
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { a := (BitVec.ofInt _ (29 : Int)), b := (BitVec.ofInt _ (12 : Int)), c := (BitVec.ofInt _ (20 : Int)), sel := (BitVec.ofInt _ (3 : Int)), x := false, y := true }
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
