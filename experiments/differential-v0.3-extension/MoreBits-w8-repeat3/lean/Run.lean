import probes.MoreBits
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.MoreBits
def p : Params := { w := (8 : Int), «repeat» := (3 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ a := (BitVec.ofInt _ (234 : Int)), b := (BitVec.ofInt _ (99 : Int)), shift := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (242 : Int)), b := (BitVec.ofInt _ (49 : Int)), shift := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (27 : Int)), b := (BitVec.ofInt _ (121 : Int)), shift := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (9 : Int)), b := (BitVec.ofInt _ (113 : Int)), shift := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (127 : Int)), b := (BitVec.ofInt _ (66 : Int)), shift := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (231 : Int)), b := (BitVec.ofInt _ (250 : Int)), shift := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (23 : Int)), b := (BitVec.ofInt _ (71 : Int)), shift := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (92 : Int)), b := (BitVec.ofInt _ (166 : Int)), shift := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (213 : Int)), b := (BitVec.ofInt _ (173 : Int)), shift := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (243 : Int)), b := (BitVec.ofInt _ (243 : Int)), shift := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (234 : Int)), b := (BitVec.ofInt _ (202 : Int)), shift := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (156 : Int)), b := (BitVec.ofInt _ (5 : Int)), shift := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (214 : Int)), b := (BitVec.ofInt _ (120 : Int)), shift := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (23 : Int)), b := (BitVec.ofInt _ (229 : Int)), shift := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (241 : Int)), b := (BitVec.ofInt _ (231 : Int)), shift := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (12 : Int)), b := (BitVec.ofInt _ (218 : Int)), shift := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (215 : Int)), b := (BitVec.ofInt _ (104 : Int)), shift := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (100 : Int)), b := (BitVec.ofInt _ (118 : Int)), shift := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (245 : Int)), b := (BitVec.ofInt _ (36 : Int)), shift := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (20 : Int)), b := (BitVec.ofInt _ (111 : Int)), shift := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (79 : Int)), b := (BitVec.ofInt _ (235 : Int)), shift := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (184 : Int)), b := (BitVec.ofInt _ (206 : Int)), shift := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (45 : Int)), b := (BitVec.ofInt _ (4 : Int)), shift := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (98 : Int)), b := (BitVec.ofInt _ (235 : Int)), shift := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (200 : Int)), b := (BitVec.ofInt _ (60 : Int)), shift := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (167 : Int)), b := (BitVec.ofInt _ (144 : Int)), shift := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (237 : Int)), b := (BitVec.ofInt _ (247 : Int)), shift := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (23 : Int)), b := (BitVec.ofInt _ (142 : Int)), shift := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (113 : Int)), b := (BitVec.ofInt _ (185 : Int)), shift := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (140 : Int)), b := (BitVec.ofInt _ (133 : Int)), shift := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (183 : Int)), b := (BitVec.ofInt _ (137 : Int)), shift := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (118 : Int)), b := (BitVec.ofInt _ (167 : Int)), shift := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (106 : Int)), b := (BitVec.ofInt _ (117 : Int)), shift := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (63 : Int)), b := (BitVec.ofInt _ (167 : Int)), shift := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (143 : Int)), b := (BitVec.ofInt _ (230 : Int)), shift := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (190 : Int)), b := (BitVec.ofInt _ (227 : Int)), shift := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (120 : Int)), b := (BitVec.ofInt _ (180 : Int)), shift := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (70 : Int)), b := (BitVec.ofInt _ (164 : Int)), shift := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (211 : Int)), b := (BitVec.ofInt _ (7 : Int)), shift := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (101 : Int)), b := (BitVec.ofInt _ (41 : Int)), shift := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (188 : Int)), b := (BitVec.ofInt _ (12 : Int)), shift := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (212 : Int)), b := (BitVec.ofInt _ (34 : Int)), shift := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (175 : Int)), b := (BitVec.ofInt _ (78 : Int)), shift := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (194 : Int)), b := (BitVec.ofInt _ (28 : Int)), shift := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (9 : Int)), b := (BitVec.ofInt _ (234 : Int)), shift := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (127 : Int)), b := (BitVec.ofInt _ (115 : Int)), shift := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (219 : Int)), b := (BitVec.ofInt _ (54 : Int)), shift := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ a := (BitVec.ofInt _ (210 : Int)), b := (BitVec.ofInt _ (205 : Int)), shift := (BitVec.ofInt _ (2 : Int)) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("quotient", Lean.toJson (o.quotient).toNat), ("remainder", Lean.toJson (o.remainder).toNat), ("shifted", Lean.toJson (o.shifted).toNat), ("top", Lean.toJson (o.top).toNat), ("bottom", Lean.toJson (o.bottom).toNat), ("filled", Lean.toJson (o.filled).toNat), ("bit", Lean.toJson (o.bit))]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj []
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { a := (BitVec.ofInt _ (234 : Int)), b := (BitVec.ofInt _ (99 : Int)), shift := (BitVec.ofInt _ (2 : Int)) }
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
