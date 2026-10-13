import probes.MuxPriorities
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.MuxPriorities
def p : Params := { w := (9 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ a := (BitVec.ofInt _ (468 : Int)), b := (BitVec.ofInt _ (198 : Int)), c := (BitVec.ofInt _ (335 : Int)), sel := (BitVec.ofInt _ (3 : Int)), x := false, y := true }, false),
  ({ a := (BitVec.ofInt _ (54 : Int)), b := (BitVec.ofInt _ (242 : Int)), c := (BitVec.ofInt _ (75 : Int)), sel := (BitVec.ofInt _ (0 : Int)), x := false, y := false }, false),
  ({ a := (BitVec.ofInt _ (255 : Int)), b := (BitVec.ofInt _ (132 : Int)), c := (BitVec.ofInt _ (205 : Int)), sel := (BitVec.ofInt _ (3 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (47 : Int)), b := (BitVec.ofInt _ (142 : Int)), c := (BitVec.ofInt _ (229 : Int)), sel := (BitVec.ofInt _ (1 : Int)), x := true, y := true }, false),
  ({ a := (BitVec.ofInt _ (427 : Int)), b := (BitVec.ofInt _ (347 : Int)), c := (BitVec.ofInt _ (481 : Int)), sel := (BitVec.ofInt _ (3 : Int)), x := true, y := true }, false),
  ({ a := (BitVec.ofInt _ (469 : Int)), b := (BitVec.ofInt _ (405 : Int)), c := (BitVec.ofInt _ (249 : Int)), sel := (BitVec.ofInt _ (2 : Int)), x := false, y := false }, false),
  ({ a := (BitVec.ofInt _ (428 : Int)), b := (BitVec.ofInt _ (241 : Int)), c := (BitVec.ofInt _ (104 : Int)), sel := (BitVec.ofInt _ (0 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (483 : Int)), b := (BitVec.ofInt _ (462 : Int)), c := (BitVec.ofInt _ (144 : Int)), sel := (BitVec.ofInt _ (0 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (430 : Int)), b := (BitVec.ofInt _ (208 : Int)), c := (BitVec.ofInt _ (383 : Int)), sel := (BitVec.ofInt _ (1 : Int)), x := false, y := false }, false),
  ({ a := (BitVec.ofInt _ (490 : Int)), b := (BitVec.ofInt _ (72 : Int)), c := (BitVec.ofInt _ (303 : Int)), sel := (BitVec.ofInt _ (0 : Int)), x := false, y := true }, false),
  ({ a := (BitVec.ofInt _ (158 : Int)), b := (BitVec.ofInt _ (471 : Int)), c := (BitVec.ofInt _ (149 : Int)), sel := (BitVec.ofInt _ (2 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (90 : Int)), b := (BitVec.ofInt _ (8 : Int)), c := (BitVec.ofInt _ (459 : Int)), sel := (BitVec.ofInt _ (1 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (401 : Int)), b := (BitVec.ofInt _ (121 : Int)), c := (BitVec.ofInt _ (458 : Int)), sel := (BitVec.ofInt _ (2 : Int)), x := true, y := true }, false),
  ({ a := (BitVec.ofInt _ (475 : Int)), b := (BitVec.ofInt _ (495 : Int)), c := (BitVec.ofInt _ (392 : Int)), sel := (BitVec.ofInt _ (0 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (226 : Int)), b := (BitVec.ofInt _ (370 : Int)), c := (BitVec.ofInt _ (293 : Int)), sel := (BitVec.ofInt _ (2 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (366 : Int)), b := (BitVec.ofInt _ (274 : Int)), c := (BitVec.ofInt _ (200 : Int)), sel := (BitVec.ofInt _ (1 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (212 : Int)), b := (BitVec.ofInt _ (234 : Int)), c := (BitVec.ofInt _ (20 : Int)), sel := (BitVec.ofInt _ (0 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (287 : Int)), b := (BitVec.ofInt _ (461 : Int)), c := (BitVec.ofInt _ (399 : Int)), sel := (BitVec.ofInt _ (2 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (241 : Int)), b := (BitVec.ofInt _ (361 : Int)), c := (BitVec.ofInt _ (364 : Int)), sel := (BitVec.ofInt _ (1 : Int)), x := true, y := true }, false),
  ({ a := (BitVec.ofInt _ (422 : Int)), b := (BitVec.ofInt _ (15 : Int)), c := (BitVec.ofInt _ (340 : Int)), sel := (BitVec.ofInt _ (1 : Int)), x := false, y := true }, false),
  ({ a := (BitVec.ofInt _ (376 : Int)), b := (BitVec.ofInt _ (25 : Int)), c := (BitVec.ofInt _ (78 : Int)), sel := (BitVec.ofInt _ (3 : Int)), x := false, y := false }, false),
  ({ a := (BitVec.ofInt _ (350 : Int)), b := (BitVec.ofInt _ (157 : Int)), c := (BitVec.ofInt _ (44 : Int)), sel := (BitVec.ofInt _ (3 : Int)), x := false, y := true }, false),
  ({ a := (BitVec.ofInt _ (18 : Int)), b := (BitVec.ofInt _ (468 : Int)), c := (BitVec.ofInt _ (293 : Int)), sel := (BitVec.ofInt _ (1 : Int)), x := false, y := false }, false),
  ({ a := (BitVec.ofInt _ (438 : Int)), b := (BitVec.ofInt _ (108 : Int)), c := (BitVec.ofInt _ (105 : Int)), sel := (BitVec.ofInt _ (3 : Int)), x := true, y := true }, false),
  ({ a := (BitVec.ofInt _ (264 : Int)), b := (BitVec.ofInt _ (172 : Int)), c := (BitVec.ofInt _ (374 : Int)), sel := (BitVec.ofInt _ (1 : Int)), x := false, y := false }, false),
  ({ a := (BitVec.ofInt _ (477 : Int)), b := (BitVec.ofInt _ (277 : Int)), c := (BitVec.ofInt _ (30 : Int)), sel := (BitVec.ofInt _ (2 : Int)), x := false, y := true }, false),
  ({ a := (BitVec.ofInt _ (376 : Int)), b := (BitVec.ofInt _ (33 : Int)), c := (BitVec.ofInt _ (248 : Int)), sel := (BitVec.ofInt _ (0 : Int)), x := true, y := true }, false),
  ({ a := (BitVec.ofInt _ (166 : Int)), b := (BitVec.ofInt _ (491 : Int)), c := (BitVec.ofInt _ (504 : Int)), sel := (BitVec.ofInt _ (2 : Int)), x := false, y := false }, false),
  ({ a := (BitVec.ofInt _ (67 : Int)), b := (BitVec.ofInt _ (32 : Int)), c := (BitVec.ofInt _ (102 : Int)), sel := (BitVec.ofInt _ (0 : Int)), x := false, y := false }, false),
  ({ a := (BitVec.ofInt _ (470 : Int)), b := (BitVec.ofInt _ (108 : Int)), c := (BitVec.ofInt _ (304 : Int)), sel := (BitVec.ofInt _ (3 : Int)), x := true, y := true }, false),
  ({ a := (BitVec.ofInt _ (133 : Int)), b := (BitVec.ofInt _ (348 : Int)), c := (BitVec.ofInt _ (508 : Int)), sel := (BitVec.ofInt _ (2 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (386 : Int)), b := (BitVec.ofInt _ (169 : Int)), c := (BitVec.ofInt _ (499 : Int)), sel := (BitVec.ofInt _ (2 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (297 : Int)), b := (BitVec.ofInt _ (167 : Int)), c := (BitVec.ofInt _ (187 : Int)), sel := (BitVec.ofInt _ (2 : Int)), x := true, y := true }, false),
  ({ a := (BitVec.ofInt _ (334 : Int)), b := (BitVec.ofInt _ (127 : Int)), c := (BitVec.ofInt _ (44 : Int)), sel := (BitVec.ofInt _ (2 : Int)), x := true, y := true }, false),
  ({ a := (BitVec.ofInt _ (356 : Int)), b := (BitVec.ofInt _ (199 : Int)), c := (BitVec.ofInt _ (398 : Int)), sel := (BitVec.ofInt _ (2 : Int)), x := false, y := true }, false),
  ({ a := (BitVec.ofInt _ (312 : Int)), b := (BitVec.ofInt _ (226 : Int)), c := (BitVec.ofInt _ (462 : Int)), sel := (BitVec.ofInt _ (1 : Int)), x := true, y := true }, false),
  ({ a := (BitVec.ofInt _ (490 : Int)), b := (BitVec.ofInt _ (168 : Int)), c := (BitVec.ofInt _ (325 : Int)), sel := (BitVec.ofInt _ (2 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (255 : Int)), b := (BitVec.ofInt _ (391 : Int)), c := (BitVec.ofInt _ (73 : Int)), sel := (BitVec.ofInt _ (3 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (46 : Int)), b := (BitVec.ofInt _ (331 : Int)), c := (BitVec.ofInt _ (15 : Int)), sel := (BitVec.ofInt _ (0 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (318 : Int)), b := (BitVec.ofInt _ (287 : Int)), c := (BitVec.ofInt _ (442 : Int)), sel := (BitVec.ofInt _ (0 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (384 : Int)), b := (BitVec.ofInt _ (373 : Int)), c := (BitVec.ofInt _ (132 : Int)), sel := (BitVec.ofInt _ (3 : Int)), x := false, y := true }, false),
  ({ a := (BitVec.ofInt _ (23 : Int)), b := (BitVec.ofInt _ (153 : Int)), c := (BitVec.ofInt _ (337 : Int)), sel := (BitVec.ofInt _ (0 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (317 : Int)), b := (BitVec.ofInt _ (235 : Int)), c := (BitVec.ofInt _ (341 : Int)), sel := (BitVec.ofInt _ (3 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (369 : Int)), b := (BitVec.ofInt _ (186 : Int)), c := (BitVec.ofInt _ (71 : Int)), sel := (BitVec.ofInt _ (3 : Int)), x := false, y := true }, false),
  ({ a := (BitVec.ofInt _ (390 : Int)), b := (BitVec.ofInt _ (161 : Int)), c := (BitVec.ofInt _ (469 : Int)), sel := (BitVec.ofInt _ (2 : Int)), x := false, y := false }, false),
  ({ a := (BitVec.ofInt _ (230 : Int)), b := (BitVec.ofInt _ (224 : Int)), c := (BitVec.ofInt _ (243 : Int)), sel := (BitVec.ofInt _ (2 : Int)), x := true, y := false }, false),
  ({ a := (BitVec.ofInt _ (94 : Int)), b := (BitVec.ofInt _ (171 : Int)), c := (BitVec.ofInt _ (383 : Int)), sel := (BitVec.ofInt _ (3 : Int)), x := true, y := true }, false),
  ({ a := (BitVec.ofInt _ (446 : Int)), b := (BitVec.ofInt _ (285 : Int)), c := (BitVec.ofInt _ (451 : Int)), sel := (BitVec.ofInt _ (0 : Int)), x := true, y := true }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("lookup", Lean.toJson (o.lookup).toNat), ("muxcase", Lean.toJson (o.muxcase).toNat), ("priority", Lean.toJson (o.priority).toNat), ("widthCheck", Lean.toJson (o.widthCheck).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj []
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { a := (BitVec.ofInt _ (468 : Int)), b := (BitVec.ofInt _ (198 : Int)), c := (BitVec.ofInt _ (335 : Int)), sel := (BitVec.ofInt _ (3 : Int)), x := false, y := true }
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
