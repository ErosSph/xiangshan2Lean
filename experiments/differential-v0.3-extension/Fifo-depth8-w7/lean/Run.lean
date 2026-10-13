import probes.Fifo
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.Fifo
def p : Params := { depth := (8 : Int), w := (7 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ enq := false, deq := false, data := (BitVec.ofInt _ (0 : Int)) }, true),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (4 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (5 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (6 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (7 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (8 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (9 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (83 : Int)) }, true),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (106 : Int)) }, false),
  ({ enq := false, deq := false, data := (BitVec.ofInt _ (18 : Int)) }, false),
  ({ enq := false, deq := false, data := (BitVec.ofInt _ (26 : Int)) }, false),
  ({ enq := false, deq := false, data := (BitVec.ofInt _ (51 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (39 : Int)) }, false),
  ({ enq := false, deq := false, data := (BitVec.ofInt _ (57 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (101 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (120 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (110 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (62 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (37 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (26 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (17 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (36 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (6 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (95 : Int)) }, false),
  ({ enq := false, deq := false, data := (BitVec.ofInt _ (9 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (75 : Int)) }, false),
  ({ enq := false, deq := false, data := (BitVec.ofInt _ (75 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (37 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (37 : Int)) }, false),
  ({ enq := false, deq := false, data := (BitVec.ofInt _ (114 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (17 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (114 : Int)) }, true),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (88 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (98 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (55 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (73 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (43 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (50 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (50 : Int)) }, false),
  ({ enq := false, deq := false, data := (BitVec.ofInt _ (5 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (21 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (99 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (43 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (91 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (84 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (85 : Int)) }, false),
  ({ enq := false, deq := false, data := (BitVec.ofInt _ (97 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (19 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (52 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (11 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (87 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (73 : Int)) }, false),
  ({ enq := false, deq := false, data := (BitVec.ofInt _ (47 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (26 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (84 : Int)) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("out", Lean.toJson (o.«out»).toNat), ("full", Lean.toJson (o.full)), ("empty", Lean.toJson (o.empty))]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("storage", Lean.Json.arr (((List.finRange 8).map (fun j0 => Lean.toJson ((s.storage) j0).toNat)).toArray)), ("read", Lean.toJson (s.read).toNat), ("write", Lean.toJson (s.write).toNat), ("count", Lean.toJson (s.count).toNat)]
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { enq := false, deq := false, data := (BitVec.ofInt _ (0 : Int)) }
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
