import probes.ParamExpression
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.ParamExpression
def p : Params := { n := (9 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ io_in := (BitVec.ofInt _ (936 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (396 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (671 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (969 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (198 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (849 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (109 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (485 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (150 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (38 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (453 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (213 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (511 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (264 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (411 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (925 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (1002 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (313 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (95 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (285 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (459 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (369 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (666 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (812 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (854 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (695 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (962 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (972 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (973 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (883 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (938 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (810 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (499 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (626 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (21 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (303 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (857 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (482 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (209 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (94 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (917 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (143 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (966 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (924 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (289 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (51 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (873 : Int)) }, false),
  ({ io_in := (BitVec.ofInt _ (52 : Int)) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("io.out", Lean.toJson (o.io_out).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj []
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { io_in := (BitVec.ofInt _ (936 : Int)) }
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
