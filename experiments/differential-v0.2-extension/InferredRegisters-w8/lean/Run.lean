import probes.InferredRegisters
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.InferredRegisters
def p : Params := { w := (8 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ «in» := (BitVec.ofInt _ (234 : Int)) }, true),
  ({ «in» := (BitVec.ofInt _ (99 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (167 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (242 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (49 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (212 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (27 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (121 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (37 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (9 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (113 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (53 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (127 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (66 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (102 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (231 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (250 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (78 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (23 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (71 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (114 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (92 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (166 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (203 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (213 : Int)) }, true),
  ({ «in» := (BitVec.ofInt _ (173 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (240 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (243 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (243 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (220 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (234 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (202 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (124 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (156 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (5 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (75 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (214 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (120 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (52 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (23 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (229 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (35 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (241 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (231 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (72 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (12 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (218 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (13 : Int)) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("out", Lean.toJson (o.«out»).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("unforced", Lean.toJson (s.unforced).toNat), ("widened", Lean.toJson (s.widened).toNat)]
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { «in» := (BitVec.ofInt _ (234 : Int)) }
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
