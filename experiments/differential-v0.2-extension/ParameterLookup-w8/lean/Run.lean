import probes.ParameterLookup
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.ParameterLookup
def p : Params := { w := (8 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ sel := (BitVec.ofInt _ (3 : Int)), a := (BitVec.ofInt _ (99 : Int)), b := (BitVec.ofInt _ (167 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (3 : Int)), a := (BitVec.ofInt _ (49 : Int)), b := (BitVec.ofInt _ (212 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (0 : Int)), a := (BitVec.ofInt _ (121 : Int)), b := (BitVec.ofInt _ (37 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (0 : Int)), a := (BitVec.ofInt _ (113 : Int)), b := (BitVec.ofInt _ (53 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (1 : Int)), a := (BitVec.ofInt _ (66 : Int)), b := (BitVec.ofInt _ (102 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (3 : Int)), a := (BitVec.ofInt _ (250 : Int)), b := (BitVec.ofInt _ (78 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (0 : Int)), a := (BitVec.ofInt _ (71 : Int)), b := (BitVec.ofInt _ (114 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (1 : Int)), a := (BitVec.ofInt _ (166 : Int)), b := (BitVec.ofInt _ (203 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (3 : Int)), a := (BitVec.ofInt _ (173 : Int)), b := (BitVec.ofInt _ (240 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (3 : Int)), a := (BitVec.ofInt _ (243 : Int)), b := (BitVec.ofInt _ (220 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (3 : Int)), a := (BitVec.ofInt _ (202 : Int)), b := (BitVec.ofInt _ (124 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (2 : Int)), a := (BitVec.ofInt _ (5 : Int)), b := (BitVec.ofInt _ (75 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (3 : Int)), a := (BitVec.ofInt _ (120 : Int)), b := (BitVec.ofInt _ (52 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (0 : Int)), a := (BitVec.ofInt _ (229 : Int)), b := (BitVec.ofInt _ (35 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (3 : Int)), a := (BitVec.ofInt _ (231 : Int)), b := (BitVec.ofInt _ (72 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (0 : Int)), a := (BitVec.ofInt _ (218 : Int)), b := (BitVec.ofInt _ (13 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (3 : Int)), a := (BitVec.ofInt _ (104 : Int)), b := (BitVec.ofInt _ (191 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (1 : Int)), a := (BitVec.ofInt _ (118 : Int)), b := (BitVec.ofInt _ (19 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (3 : Int)), a := (BitVec.ofInt _ (36 : Int)), b := (BitVec.ofInt _ (151 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (0 : Int)), a := (BitVec.ofInt _ (111 : Int)), b := (BitVec.ofInt _ (150 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (1 : Int)), a := (BitVec.ofInt _ (235 : Int)), b := (BitVec.ofInt _ (74 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (2 : Int)), a := (BitVec.ofInt _ (206 : Int)), b := (BitVec.ofInt _ (74 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (0 : Int)), a := (BitVec.ofInt _ (4 : Int)), b := (BitVec.ofInt _ (229 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (1 : Int)), a := (BitVec.ofInt _ (235 : Int)), b := (BitVec.ofInt _ (34 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (3 : Int)), a := (BitVec.ofInt _ (60 : Int)), b := (BitVec.ofInt _ (229 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (2 : Int)), a := (BitVec.ofInt _ (144 : Int)), b := (BitVec.ofInt _ (176 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (3 : Int)), a := (BitVec.ofInt _ (247 : Int)), b := (BitVec.ofInt _ (196 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (0 : Int)), a := (BitVec.ofInt _ (142 : Int)), b := (BitVec.ofInt _ (111 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (1 : Int)), a := (BitVec.ofInt _ (185 : Int)), b := (BitVec.ofInt _ (146 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (2 : Int)), a := (BitVec.ofInt _ (133 : Int)), b := (BitVec.ofInt _ (87 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (2 : Int)), a := (BitVec.ofInt _ (137 : Int)), b := (BitVec.ofInt _ (100 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (1 : Int)), a := (BitVec.ofInt _ (167 : Int)), b := (BitVec.ofInt _ (100 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (1 : Int)), a := (BitVec.ofInt _ (117 : Int)), b := (BitVec.ofInt _ (10 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (0 : Int)), a := (BitVec.ofInt _ (167 : Int)), b := (BitVec.ofInt _ (42 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (2 : Int)), a := (BitVec.ofInt _ (230 : Int)), b := (BitVec.ofInt _ (199 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (2 : Int)), a := (BitVec.ofInt _ (227 : Int)), b := (BitVec.ofInt _ (86 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (1 : Int)), a := (BitVec.ofInt _ (180 : Int)), b := (BitVec.ofInt _ (182 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (1 : Int)), a := (BitVec.ofInt _ (164 : Int)), b := (BitVec.ofInt _ (169 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (3 : Int)), a := (BitVec.ofInt _ (7 : Int)), b := (BitVec.ofInt _ (170 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (1 : Int)), a := (BitVec.ofInt _ (41 : Int)), b := (BitVec.ofInt _ (195 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (2 : Int)), a := (BitVec.ofInt _ (12 : Int)), b := (BitVec.ofInt _ (39 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (3 : Int)), a := (BitVec.ofInt _ (34 : Int)), b := (BitVec.ofInt _ (105 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (2 : Int)), a := (BitVec.ofInt _ (78 : Int)), b := (BitVec.ofInt _ (22 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (3 : Int)), a := (BitVec.ofInt _ (28 : Int)), b := (BitVec.ofInt _ (174 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (0 : Int)), a := (BitVec.ofInt _ (234 : Int)), b := (BitVec.ofInt _ (146 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (1 : Int)), a := (BitVec.ofInt _ (115 : Int)), b := (BitVec.ofInt _ (94 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (3 : Int)), a := (BitVec.ofInt _ (54 : Int)), b := (BitVec.ofInt _ (52 : Int)) }, false),
  ({ sel := (BitVec.ofInt _ (3 : Int)), a := (BitVec.ofInt _ (205 : Int)), b := (BitVec.ofInt _ (169 : Int)) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("out", Lean.toJson (o.«out»).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj []
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { sel := (BitVec.ofInt _ (3 : Int)), a := (BitVec.ofInt _ (99 : Int)), b := (BitVec.ofInt _ (167 : Int)) }
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
