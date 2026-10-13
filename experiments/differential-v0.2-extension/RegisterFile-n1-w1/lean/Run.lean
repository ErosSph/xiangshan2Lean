import probes.RegisterFile
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.RegisterFile
def p : Params := { n := (1 : Int), w := (1 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ write := true, waddr := (BitVec.ofInt _ (3 : Int)), raddr := (BitVec.ofInt _ (5 : Int)), data := (BitVec.ofInt _ (1 : Int)) }, true),
  ({ write := false, waddr := (BitVec.ofInt _ (6 : Int)), raddr := (BitVec.ofInt _ (0 : Int)), data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ write := false, waddr := (BitVec.ofInt _ (0 : Int)), raddr := (BitVec.ofInt _ (3 : Int)), data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ write := false, waddr := (BitVec.ofInt _ (2 : Int)), raddr := (BitVec.ofInt _ (3 : Int)), data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ write := true, waddr := (BitVec.ofInt _ (2 : Int)), raddr := (BitVec.ofInt _ (0 : Int)), data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ write := false, waddr := (BitVec.ofInt _ (2 : Int)), raddr := (BitVec.ofInt _ (5 : Int)), data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ write := true, waddr := (BitVec.ofInt _ (5 : Int)), raddr := (BitVec.ofInt _ (7 : Int)), data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ write := true, waddr := (BitVec.ofInt _ (6 : Int)), raddr := (BitVec.ofInt _ (7 : Int)), data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ write := false, waddr := (BitVec.ofInt _ (4 : Int)), raddr := (BitVec.ofInt _ (0 : Int)), data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ write := true, waddr := (BitVec.ofInt _ (3 : Int)), raddr := (BitVec.ofInt _ (1 : Int)), data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ write := true, waddr := (BitVec.ofInt _ (1 : Int)), raddr := (BitVec.ofInt _ (7 : Int)), data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ write := false, waddr := (BitVec.ofInt _ (0 : Int)), raddr := (BitVec.ofInt _ (6 : Int)), data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ write := true, waddr := (BitVec.ofInt _ (3 : Int)), raddr := (BitVec.ofInt _ (5 : Int)), data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ write := false, waddr := (BitVec.ofInt _ (0 : Int)), raddr := (BitVec.ofInt _ (7 : Int)), data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ write := true, waddr := (BitVec.ofInt _ (0 : Int)), raddr := (BitVec.ofInt _ (3 : Int)), data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ write := false, waddr := (BitVec.ofInt _ (7 : Int)), raddr := (BitVec.ofInt _ (2 : Int)), data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ write := true, waddr := (BitVec.ofInt _ (2 : Int)), raddr := (BitVec.ofInt _ (1 : Int)), data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ write := true, waddr := (BitVec.ofInt _ (3 : Int)), raddr := (BitVec.ofInt _ (7 : Int)), data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ write := true, waddr := (BitVec.ofInt _ (1 : Int)), raddr := (BitVec.ofInt _ (7 : Int)), data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ write := true, waddr := (BitVec.ofInt _ (5 : Int)), raddr := (BitVec.ofInt _ (7 : Int)), data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ write := true, waddr := (BitVec.ofInt _ (0 : Int)), raddr := (BitVec.ofInt _ (4 : Int)), data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ write := false, waddr := (BitVec.ofInt _ (5 : Int)), raddr := (BitVec.ofInt _ (4 : Int)), data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ write := true, waddr := (BitVec.ofInt _ (2 : Int)), raddr := (BitVec.ofInt _ (5 : Int)), data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ write := false, waddr := (BitVec.ofInt _ (3 : Int)), raddr := (BitVec.ofInt _ (5 : Int)), data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ write := false, waddr := (BitVec.ofInt _ (3 : Int)), raddr := (BitVec.ofInt _ (0 : Int)), data := (BitVec.ofInt _ (0 : Int)) }, true),
  ({ write := true, waddr := (BitVec.ofInt _ (1 : Int)), raddr := (BitVec.ofInt _ (4 : Int)), data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ write := true, waddr := (BitVec.ofInt _ (5 : Int)), raddr := (BitVec.ofInt _ (7 : Int)), data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ write := false, waddr := (BitVec.ofInt _ (5 : Int)), raddr := (BitVec.ofInt _ (5 : Int)), data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ write := true, waddr := (BitVec.ofInt _ (5 : Int)), raddr := (BitVec.ofInt _ (6 : Int)), data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ write := true, waddr := (BitVec.ofInt _ (3 : Int)), raddr := (BitVec.ofInt _ (1 : Int)), data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ write := true, waddr := (BitVec.ofInt _ (0 : Int)), raddr := (BitVec.ofInt _ (1 : Int)), data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ write := false, waddr := (BitVec.ofInt _ (3 : Int)), raddr := (BitVec.ofInt _ (5 : Int)), data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ write := false, waddr := (BitVec.ofInt _ (6 : Int)), raddr := (BitVec.ofInt _ (0 : Int)), data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ write := false, waddr := (BitVec.ofInt _ (7 : Int)), raddr := (BitVec.ofInt _ (4 : Int)), data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ write := false, waddr := (BitVec.ofInt _ (2 : Int)), raddr := (BitVec.ofInt _ (6 : Int)), data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ write := false, waddr := (BitVec.ofInt _ (6 : Int)), raddr := (BitVec.ofInt _ (6 : Int)), data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ write := true, waddr := (BitVec.ofInt _ (2 : Int)), raddr := (BitVec.ofInt _ (5 : Int)), data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ write := false, waddr := (BitVec.ofInt _ (1 : Int)), raddr := (BitVec.ofInt _ (7 : Int)), data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ write := false, waddr := (BitVec.ofInt _ (4 : Int)), raddr := (BitVec.ofInt _ (0 : Int)), data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ write := true, waddr := (BitVec.ofInt _ (0 : Int)), raddr := (BitVec.ofInt _ (3 : Int)), data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ write := true, waddr := (BitVec.ofInt _ (4 : Int)), raddr := (BitVec.ofInt _ (2 : Int)), data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ write := true, waddr := (BitVec.ofInt _ (4 : Int)), raddr := (BitVec.ofInt _ (1 : Int)), data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ write := false, waddr := (BitVec.ofInt _ (0 : Int)), raddr := (BitVec.ofInt _ (1 : Int)), data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ write := false, waddr := (BitVec.ofInt _ (0 : Int)), raddr := (BitVec.ofInt _ (7 : Int)), data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ write := true, waddr := (BitVec.ofInt _ (7 : Int)), raddr := (BitVec.ofInt _ (5 : Int)), data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ write := false, waddr := (BitVec.ofInt _ (5 : Int)), raddr := (BitVec.ofInt _ (7 : Int)), data := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ write := true, waddr := (BitVec.ofInt _ (1 : Int)), raddr := (BitVec.ofInt _ (6 : Int)), data := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ write := true, waddr := (BitVec.ofInt _ (4 : Int)), raddr := (BitVec.ofInt _ (7 : Int)), data := (BitVec.ofInt _ (0 : Int)) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("out", Lean.toJson (o.«out»).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("registers", Lean.Json.arr (((List.finRange 1).map (fun j0 => Lean.toJson ((s.registers) j0).toNat)).toArray))]
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { write := true, waddr := (BitVec.ofInt _ (3 : Int)), raddr := (BitVec.ofInt _ (5 : Int)), data := (BitVec.ofInt _ (1 : Int)) }
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
