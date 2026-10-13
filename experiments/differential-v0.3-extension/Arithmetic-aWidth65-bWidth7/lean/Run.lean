import probes.Arithmetic
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.Arithmetic
def p : Params := { aWidth := (65 : Int), bWidth := (7 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ io_a := (BitVec.ofInt _ (8432683584078134192 : Int)), io_b := (BitVec.ofInt _ (83 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (1358736949838177847 : Int)), io_b := (BitVec.ofInt _ (56 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (22153149478883899424 : Int)), io_b := (BitVec.ofInt _ (125 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (4137205505084429078 : Int)), io_b := (BitVec.ofInt _ (83 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (28793930542741334841 : Int)), io_b := (BitVec.ofInt _ (121 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (33071341065308219070 : Int)), io_b := (BitVec.ofInt _ (2 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (13906620541140924814 : Int)), io_b := (BitVec.ofInt _ (114 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (18913778978660956332 : Int)), io_b := (BitVec.ofInt _ (6 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (6907270774008649489 : Int)), io_b := (BitVec.ofInt _ (59 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (36846831401000407905 : Int)), io_b := (BitVec.ofInt _ (18 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (722031061230588770 : Int)), io_b := (BitVec.ofInt _ (75 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (33806790077006384778 : Int)), io_b := (BitVec.ofInt _ (37 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (15688005050050355824 : Int)), io_b := (BitVec.ofInt _ (117 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (14294987825311976206 : Int)), io_b := (BitVec.ofInt _ (114 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (24822719148445966461 : Int)), io_b := (BitVec.ofInt _ (123 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (18224081393624001569 : Int)), io_b := (BitVec.ofInt _ (92 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (29487527372709771375 : Int)), io_b := (BitVec.ofInt _ (66 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (3613314171473495955 : Int)), io_b := (BitVec.ofInt _ (83 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (14523945897447868416 : Int)), io_b := (BitVec.ofInt _ (31 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (10290930439098325909 : Int)), io_b := (BitVec.ofInt _ (71 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (3124162679057425579 : Int)), io_b := (BitVec.ofInt _ (90 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (15075371280645765461 : Int)), io_b := (BitVec.ofInt _ (82 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (19944254163994538688 : Int)), io_b := (BitVec.ofInt _ (94 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (19866612291026214687 : Int)), io_b := (BitVec.ofInt _ (17 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (36630339309493611295 : Int)), io_b := (BitVec.ofInt _ (39 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (12529920914174947689 : Int)), io_b := (BitVec.ofInt _ (87 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (26878747700883232505 : Int)), io_b := (BitVec.ofInt _ (63 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (34511694390421723333 : Int)), io_b := (BitVec.ofInt _ (102 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (4771273550354989773 : Int)), io_b := (BitVec.ofInt _ (93 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (18713320226812083852 : Int)), io_b := (BitVec.ofInt _ (94 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (14209092829556047091 : Int)), io_b := (BitVec.ofInt _ (114 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (35579449996314079058 : Int)), io_b := (BitVec.ofInt _ (19 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (18096619143048019956 : Int)), io_b := (BitVec.ofInt _ (6 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (13578921927771438823 : Int)), io_b := (BitVec.ofInt _ (76 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (36366770992267324080 : Int)), io_b := (BitVec.ofInt _ (81 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (35547795416673231451 : Int)), io_b := (BitVec.ofInt _ (89 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (13878595077862812739 : Int)), io_b := (BitVec.ofInt _ (96 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (3011583197497619248 : Int)), io_b := (BitVec.ofInt _ (64 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (29218812537477133056 : Int)), io_b := (BitVec.ofInt _ (89 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (25625320941725960267 : Int)), io_b := (BitVec.ofInt _ (5 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (22530783875306364348 : Int)), io_b := (BitVec.ofInt _ (41 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (30670181477564604572 : Int)), io_b := (BitVec.ofInt _ (42 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (31755689590043357935 : Int)), io_b := (BitVec.ofInt _ (109 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (23056091162542755482 : Int)), io_b := (BitVec.ofInt _ (18 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (5976147770799131020 : Int)), io_b := (BitVec.ofInt _ (9 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (9372982186470679233 : Int)), io_b := (BitVec.ofInt _ (82 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (34774803642799785065 : Int)), io_b := (BitVec.ofInt _ (12 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (32650527431873258793 : Int)), io_b := (BitVec.ofInt _ (101 : Int)), io_choose := false }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("io.carry", Lean.toJson (o.io_carry).toNat), ("io.concat", Lean.toJson (o.io_concat).toNat), ("io.equal", Lean.toJson (o.io_equal)), ("io.less", Lean.toJson (o.io_less)), ("io.product", Lean.toJson (o.io_product).toNat), ("io.selected", Lean.toJson (o.io_selected).toNat), ("io.sub", Lean.toJson (o.io_sub).toNat), ("io.sum", Lean.toJson (o.io_sum).toNat), ("io.xor", Lean.toJson (o.io_xor).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj []
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { io_a := (BitVec.ofInt _ (8432683584078134192 : Int)), io_b := (BitVec.ofInt _ (83 : Int)), io_choose := true }
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
