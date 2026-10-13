import probes.SignedDivision
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.SignedDivision
def p : Params := { w := (8 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ a := (BitVec.ofInt _ (234 : Int)), b := (BitVec.ofInt _ (99 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (167 : Int)), b := (BitVec.ofInt _ (242 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (49 : Int)), b := (BitVec.ofInt _ (212 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (27 : Int)), b := (BitVec.ofInt _ (121 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (37 : Int)), b := (BitVec.ofInt _ (9 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (113 : Int)), b := (BitVec.ofInt _ (53 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (127 : Int)), b := (BitVec.ofInt _ (66 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (102 : Int)), b := (BitVec.ofInt _ (231 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (250 : Int)), b := (BitVec.ofInt _ (78 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (23 : Int)), b := (BitVec.ofInt _ (71 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (114 : Int)), b := (BitVec.ofInt _ (92 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (166 : Int)), b := (BitVec.ofInt _ (203 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (213 : Int)), b := (BitVec.ofInt _ (173 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (240 : Int)), b := (BitVec.ofInt _ (243 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (243 : Int)), b := (BitVec.ofInt _ (220 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (234 : Int)), b := (BitVec.ofInt _ (202 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (124 : Int)), b := (BitVec.ofInt _ (156 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (5 : Int)), b := (BitVec.ofInt _ (75 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (214 : Int)), b := (BitVec.ofInt _ (120 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (52 : Int)), b := (BitVec.ofInt _ (23 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (229 : Int)), b := (BitVec.ofInt _ (35 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (241 : Int)), b := (BitVec.ofInt _ (231 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (72 : Int)), b := (BitVec.ofInt _ (12 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (218 : Int)), b := (BitVec.ofInt _ (13 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (215 : Int)), b := (BitVec.ofInt _ (104 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (191 : Int)), b := (BitVec.ofInt _ (100 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (118 : Int)), b := (BitVec.ofInt _ (19 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (245 : Int)), b := (BitVec.ofInt _ (36 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (151 : Int)), b := (BitVec.ofInt _ (20 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (111 : Int)), b := (BitVec.ofInt _ (150 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (79 : Int)), b := (BitVec.ofInt _ (235 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (74 : Int)), b := (BitVec.ofInt _ (184 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (206 : Int)), b := (BitVec.ofInt _ (74 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (45 : Int)), b := (BitVec.ofInt _ (4 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (229 : Int)), b := (BitVec.ofInt _ (98 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (235 : Int)), b := (BitVec.ofInt _ (34 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (200 : Int)), b := (BitVec.ofInt _ (60 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (229 : Int)), b := (BitVec.ofInt _ (167 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (144 : Int)), b := (BitVec.ofInt _ (176 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (237 : Int)), b := (BitVec.ofInt _ (247 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (196 : Int)), b := (BitVec.ofInt _ (23 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (142 : Int)), b := (BitVec.ofInt _ (111 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (113 : Int)), b := (BitVec.ofInt _ (185 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (146 : Int)), b := (BitVec.ofInt _ (140 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (133 : Int)), b := (BitVec.ofInt _ (87 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (183 : Int)), b := (BitVec.ofInt _ (137 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (100 : Int)), b := (BitVec.ofInt _ (118 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (167 : Int)), b := (BitVec.ofInt _ (100 : Int)) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("quotient", Lean.toJson (o.quotient).toNat), ("remainder", Lean.toJson (o.remainder).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj []
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { a := (BitVec.ofInt _ (234 : Int)), b := (BitVec.ofInt _ (99 : Int)) }
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
