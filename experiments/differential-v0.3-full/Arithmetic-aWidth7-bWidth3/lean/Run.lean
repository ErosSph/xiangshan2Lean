import probes.Arithmetic
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.Arithmetic
def p : Params := { aWidth := (7 : Int), bWidth := (3 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ io_a := (BitVec.ofInt _ (117 : Int)), io_b := (BitVec.ofInt _ (3 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (121 : Int)), io_b := (BitVec.ofInt _ (1 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (13 : Int)), io_b := (BitVec.ofInt _ (3 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (4 : Int)), io_b := (BitVec.ofInt _ (3 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (63 : Int)), io_b := (BitVec.ofInt _ (2 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (115 : Int)), io_b := (BitVec.ofInt _ (7 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (11 : Int)), io_b := (BitVec.ofInt _ (2 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (46 : Int)), io_b := (BitVec.ofInt _ (5 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (106 : Int)), io_b := (BitVec.ofInt _ (5 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (121 : Int)), io_b := (BitVec.ofInt _ (7 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (117 : Int)), io_b := (BitVec.ofInt _ (6 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (78 : Int)), io_b := (BitVec.ofInt _ (0 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (107 : Int)), io_b := (BitVec.ofInt _ (3 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (11 : Int)), io_b := (BitVec.ofInt _ (7 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (120 : Int)), io_b := (BitVec.ofInt _ (7 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (6 : Int)), io_b := (BitVec.ofInt _ (6 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (107 : Int)), io_b := (BitVec.ofInt _ (3 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (50 : Int)), io_b := (BitVec.ofInt _ (3 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (122 : Int)), io_b := (BitVec.ofInt _ (1 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (10 : Int)), io_b := (BitVec.ofInt _ (3 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (39 : Int)), io_b := (BitVec.ofInt _ (7 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (92 : Int)), io_b := (BitVec.ofInt _ (6 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (22 : Int)), io_b := (BitVec.ofInt _ (0 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (49 : Int)), io_b := (BitVec.ofInt _ (7 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (100 : Int)), io_b := (BitVec.ofInt _ (1 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (83 : Int)), io_b := (BitVec.ofInt _ (4 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (118 : Int)), io_b := (BitVec.ofInt _ (7 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (11 : Int)), io_b := (BitVec.ofInt _ (4 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (56 : Int)), io_b := (BitVec.ofInt _ (5 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (70 : Int)), io_b := (BitVec.ofInt _ (4 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (91 : Int)), io_b := (BitVec.ofInt _ (4 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (59 : Int)), io_b := (BitVec.ofInt _ (5 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (53 : Int)), io_b := (BitVec.ofInt _ (3 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (31 : Int)), io_b := (BitVec.ofInt _ (5 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (71 : Int)), io_b := (BitVec.ofInt _ (7 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (95 : Int)), io_b := (BitVec.ofInt _ (7 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (60 : Int)), io_b := (BitVec.ofInt _ (5 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (35 : Int)), io_b := (BitVec.ofInt _ (5 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (105 : Int)), io_b := (BitVec.ofInt _ (0 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (50 : Int)), io_b := (BitVec.ofInt _ (1 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (94 : Int)), io_b := (BitVec.ofInt _ (0 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (106 : Int)), io_b := (BitVec.ofInt _ (1 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (87 : Int)), io_b := (BitVec.ofInt _ (2 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (97 : Int)), io_b := (BitVec.ofInt _ (0 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (4 : Int)), io_b := (BitVec.ofInt _ (7 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (63 : Int)), io_b := (BitVec.ofInt _ (3 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (109 : Int)), io_b := (BitVec.ofInt _ (1 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (105 : Int)), io_b := (BitVec.ofInt _ (6 : Int)), io_choose := true }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("io.carry", Lean.toJson (o.io_carry).toNat), ("io.concat", Lean.toJson (o.io_concat).toNat), ("io.equal", Lean.toJson (o.io_equal)), ("io.less", Lean.toJson (o.io_less)), ("io.product", Lean.toJson (o.io_product).toNat), ("io.selected", Lean.toJson (o.io_selected).toNat), ("io.sub", Lean.toJson (o.io_sub).toNat), ("io.sum", Lean.toJson (o.io_sum).toNat), ("io.xor", Lean.toJson (o.io_xor).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj []
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { io_a := (BitVec.ofInt _ (117 : Int)), io_b := (BitVec.ofInt _ (3 : Int)), io_choose := true }
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
