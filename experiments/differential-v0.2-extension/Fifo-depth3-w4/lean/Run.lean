import probes.Fifo
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.Fifo
def p : Params := { depth := (3 : Int), w := (4 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ enq := false, deq := false, data := (BitVec.ofInt _ (0 : Int)) }, true),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (4 : Int)) }, false),
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
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (10 : Int)) }, true),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (13 : Int)) }, false),
  ({ enq := false, deq := false, data := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ enq := false, deq := false, data := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ enq := false, deq := false, data := (BitVec.ofInt _ (6 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (4 : Int)) }, false),
  ({ enq := false, deq := false, data := (BitVec.ofInt _ (7 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (12 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (15 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (13 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (7 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (4 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (4 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (11 : Int)) }, false),
  ({ enq := false, deq := false, data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (9 : Int)) }, false),
  ({ enq := false, deq := false, data := (BitVec.ofInt _ (9 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (4 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (4 : Int)) }, false),
  ({ enq := false, deq := false, data := (BitVec.ofInt _ (14 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (14 : Int)) }, true),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (11 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (12 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (6 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (9 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (5 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (6 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (6 : Int)) }, false),
  ({ enq := false, deq := false, data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (12 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (5 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (11 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (10 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (10 : Int)) }, false),
  ({ enq := false, deq := false, data := (BitVec.ofInt _ (12 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (6 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (10 : Int)) }, false),
  ({ enq := false, deq := true, data := (BitVec.ofInt _ (9 : Int)) }, false),
  ({ enq := false, deq := false, data := (BitVec.ofInt _ (5 : Int)) }, false),
  ({ enq := true, deq := false, data := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ enq := true, deq := true, data := (BitVec.ofInt _ (10 : Int)) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("out", Lean.toJson (o.«out»).toNat), ("full", Lean.toJson (o.full)), ("empty", Lean.toJson (o.empty))]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("storage", Lean.Json.arr (((List.finRange 3).map (fun j0 => Lean.toJson ((s.storage) j0).toNat)).toArray)), ("read", Lean.toJson (s.read).toNat), ("write", Lean.toJson (s.write).toNat), ("count", Lean.toJson (s.count).toNat)]
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
