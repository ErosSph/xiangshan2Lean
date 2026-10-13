import probes.VecLoop
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.VecLoop
def p : Params := { n := (4 : Int), w := (7 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (117 : Int)) | 1 => (BitVec.ofInt _ (49 : Int)) | 2 => (BitVec.ofInt _ (83 : Int)) | 3 => (BitVec.ofInt _ (121 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (24 : Int)) | 1 => (BitVec.ofInt _ (106 : Int)) | 2 => (BitVec.ofInt _ (13 : Int)) | 3 => (BitVec.ofInt _ (60 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (18 : Int)) | 1 => (BitVec.ofInt _ (4 : Int)) | 2 => (BitVec.ofInt _ (56 : Int)) | 3 => (BitVec.ofInt _ (26 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (63 : Int)) | 1 => (BitVec.ofInt _ (33 : Int)) | 2 => (BitVec.ofInt _ (51 : Int)) | 3 => (BitVec.ofInt _ (115 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (125 : Int)) | 1 => (BitVec.ofInt _ (39 : Int)) | 2 => (BitVec.ofInt _ (11 : Int)) | 3 => (BitVec.ofInt _ (35 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (57 : Int)) | 1 => (BitVec.ofInt _ (46 : Int)) | 2 => (BitVec.ofInt _ (83 : Int)) | 3 => (BitVec.ofInt _ (101 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (106 : Int)) | 1 => (BitVec.ofInt _ (86 : Int)) | 2 => (BitVec.ofInt _ (120 : Int)) | 3 => (BitVec.ofInt _ (121 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (121 : Int)) | 1 => (BitVec.ofInt _ (110 : Int)) | 2 => (BitVec.ofInt _ (117 : Int)) | 3 => (BitVec.ofInt _ (101 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (62 : Int)) | 1 => (BitVec.ofInt _ (78 : Int)) | 2 => (BitVec.ofInt _ (2 : Int)) | 3 => (BitVec.ofInt _ (37 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (107 : Int)) | 1 => (BitVec.ofInt _ (60 : Int)) | 2 => (BitVec.ofInt _ (26 : Int)) | 3 => (BitVec.ofInt _ (11 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (114 : Int)) | 1 => (BitVec.ofInt _ (17 : Int)) | 2 => (BitVec.ofInt _ (120 : Int)) | 3 => (BitVec.ofInt _ (115 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (36 : Int)) | 1 => (BitVec.ofInt _ (6 : Int)) | 2 => (BitVec.ofInt _ (109 : Int)) | 3 => (BitVec.ofInt _ (6 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (107 : Int)) | 1 => (BitVec.ofInt _ (52 : Int)) | 2 => (BitVec.ofInt _ (95 : Int)) | 3 => (BitVec.ofInt _ (50 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (59 : Int)) | 1 => (BitVec.ofInt _ (9 : Int)) | 2 => (BitVec.ofInt _ (122 : Int)) | 3 => (BitVec.ofInt _ (18 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (75 : Int)) | 1 => (BitVec.ofInt _ (10 : Int)) | 2 => (BitVec.ofInt _ (55 : Int)) | 3 => (BitVec.ofInt _ (75 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (39 : Int)) | 1 => (BitVec.ofInt _ (117 : Int)) | 2 => (BitVec.ofInt _ (37 : Int)) | 3 => (BitVec.ofInt _ (92 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (103 : Int)) | 1 => (BitVec.ofInt _ (37 : Int)) | 2 => (BitVec.ofInt _ (22 : Int)) | 3 => (BitVec.ofInt _ (2 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (114 : Int)) | 1 => (BitVec.ofInt _ (49 : Int)) | 2 => (BitVec.ofInt _ (117 : Int)) | 3 => (BitVec.ofInt _ (17 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (100 : Int)) | 1 => (BitVec.ofInt _ (30 : Int)) | 2 => (BitVec.ofInt _ (114 : Int)) | 3 => (BitVec.ofInt _ (83 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (72 : Int)) | 1 => (BitVec.ofInt _ (88 : Int)) | 2 => (BitVec.ofInt _ (118 : Int)) | 3 => (BitVec.ofInt _ (123 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (98 : Int)) | 1 => (BitVec.ofInt _ (11 : Int)) | 2 => (BitVec.ofInt _ (71 : Int)) | 3 => (BitVec.ofInt _ (55 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (56 : Int)) | 1 => (BitVec.ofInt _ (92 : Int)) | 2 => (BitVec.ofInt _ (73 : Int)) | 3 => (BitVec.ofInt _ (70 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (66 : Int)) | 1 => (BitVec.ofInt _ (43 : Int)) | 2 => (BitVec.ofInt _ (91 : Int)) | 3 => (BitVec.ofInt _ (68 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (50 : Int)) | 1 => (BitVec.ofInt _ (59 : Int)) | 2 => (BitVec.ofInt _ (83 : Int)) | 3 => (BitVec.ofInt _ (50 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (53 : Int)) | 1 => (BitVec.ofInt _ (58 : Int)) | 2 => (BitVec.ofInt _ (5 : Int)) | 3 => (BitVec.ofInt _ (31 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (83 : Int)) | 1 => (BitVec.ofInt _ (21 : Int)) | 2 => (BitVec.ofInt _ (71 : Int)) | 3 => (BitVec.ofInt _ (115 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (99 : Int)) | 1 => (BitVec.ofInt _ (95 : Int)) | 2 => (BitVec.ofInt _ (113 : Int)) | 3 => (BitVec.ofInt _ (43 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (60 : Int)) | 1 => (BitVec.ofInt _ (90 : Int)) | 2 => (BitVec.ofInt _ (91 : Int)) | 3 => (BitVec.ofInt _ (35 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (82 : Int)) | 1 => (BitVec.ofInt _ (84 : Int)) | 2 => (BitVec.ofInt _ (105 : Int)) | 3 => (BitVec.ofInt _ (3 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (85 : Int)) | 1 => (BitVec.ofInt _ (50 : Int)) | 2 => (BitVec.ofInt _ (20 : Int)) | 3 => (BitVec.ofInt _ (97 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (94 : Int)) | 1 => (BitVec.ofInt _ (6 : Int)) | 2 => (BitVec.ofInt _ (19 : Int)) | 3 => (BitVec.ofInt _ (106 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (17 : Int)) | 1 => (BitVec.ofInt _ (52 : Int)) | 2 => (BitVec.ofInt _ (87 : Int)) | 3 => (BitVec.ofInt _ (39 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (11 : Int)) | 1 => (BitVec.ofInt _ (97 : Int)) | 2 => (BitVec.ofInt _ (14 : Int)) | 3 => (BitVec.ofInt _ (87 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (4 : Int)) | 1 => (BitVec.ofInt _ (117 : Int)) | 2 => (BitVec.ofInt _ (73 : Int)) | 3 => (BitVec.ofInt _ (63 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (57 : Int)) | 1 => (BitVec.ofInt _ (47 : Int)) | 2 => (BitVec.ofInt _ (109 : Int)) | 3 => (BitVec.ofInt _ (27 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (26 : Int)) | 1 => (BitVec.ofInt _ (105 : Int)) | 2 => (BitVec.ofInt _ (102 : Int)) | 3 => (BitVec.ofInt _ (84 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (66 : Int)) | 1 => (BitVec.ofInt _ (43 : Int)) | 2 => (BitVec.ofInt _ (93 : Int)) | 3 => (BitVec.ofInt _ (61 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (46 : Int)) | 1 => (BitVec.ofInt _ (26 : Int)) | 2 => (BitVec.ofInt _ (119 : Int)) | 3 => (BitVec.ofInt _ (69 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (7 : Int)) | 1 => (BitVec.ofInt _ (79 : Int)) | 2 => (BitVec.ofInt _ (3 : Int)) | 3 => (BitVec.ofInt _ (106 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (94 : Int)) | 1 => (BitVec.ofInt _ (8 : Int)) | 2 => (BitVec.ofInt _ (62 : Int)) | 3 => (BitVec.ofInt _ (16 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (114 : Int)) | 1 => (BitVec.ofInt _ (77 : Int)) | 2 => (BitVec.ofInt _ (41 : Int)) | 3 => (BitVec.ofInt _ (122 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (126 : Int)) | 1 => (BitVec.ofInt _ (78 : Int)) | 2 => (BitVec.ofInt _ (19 : Int)) | 3 => (BitVec.ofInt _ (16 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (16 : Int)) | 1 => (BitVec.ofInt _ (8 : Int)) | 2 => (BitVec.ofInt _ (25 : Int)) | 3 => (BitVec.ofInt _ (8 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (10 : Int)) | 1 => (BitVec.ofInt _ (6 : Int)) | 2 => (BitVec.ofInt _ (117 : Int)) | 3 => (BitVec.ofInt _ (27 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (76 : Int)) | 1 => (BitVec.ofInt _ (119 : Int)) | 2 => (BitVec.ofInt _ (92 : Int)) | 3 => (BitVec.ofInt _ (81 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (33 : Int)) | 1 => (BitVec.ofInt _ (87 : Int)) | 2 => (BitVec.ofInt _ (127 : Int)) | 3 => (BitVec.ofInt _ (89 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (112 : Int)) | 1 => (BitVec.ofInt _ (19 : Int)) | 2 => (BitVec.ofInt _ (96 : Int)) | 3 => (BitVec.ofInt _ (42 : Int)) | _ => default) }, false),
  ({ io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (124 : Int)) | 1 => (BitVec.ofInt _ (72 : Int)) | 2 => (BitVec.ofInt _ (126 : Int)) | 3 => (BitVec.ofInt _ (63 : Int)) | _ => default) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("io.out", Lean.Json.arr (((List.finRange 4).map (fun j0 => Lean.toJson ((o.io_out) j0).toNat)).toArray))]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj []
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { io_in := (fun j => match j.val with | 0 => (BitVec.ofInt _ (117 : Int)) | 1 => (BitVec.ofInt _ (49 : Int)) | 2 => (BitVec.ofInt _ (83 : Int)) | 3 => (BitVec.ofInt _ (121 : Int)) | _ => default) }
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
