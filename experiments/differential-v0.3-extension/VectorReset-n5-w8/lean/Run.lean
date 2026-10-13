import probes.VectorReset
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.VectorReset
def p : Params := { n := (5 : Int), w := (8 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (234 : Int)) | 1 => (BitVec.ofInt _ (99 : Int)) | 2 => (BitVec.ofInt _ (167 : Int)) | 3 => (BitVec.ofInt _ (242 : Int)) | 4 => (BitVec.ofInt _ (49 : Int)) | _ => default), en := true }, true),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (27 : Int)) | 1 => (BitVec.ofInt _ (121 : Int)) | 2 => (BitVec.ofInt _ (37 : Int)) | 3 => (BitVec.ofInt _ (9 : Int)) | 4 => (BitVec.ofInt _ (113 : Int)) | _ => default), en := false }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (127 : Int)) | 1 => (BitVec.ofInt _ (66 : Int)) | 2 => (BitVec.ofInt _ (102 : Int)) | 3 => (BitVec.ofInt _ (231 : Int)) | 4 => (BitVec.ofInt _ (250 : Int)) | _ => default), en := false }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (23 : Int)) | 1 => (BitVec.ofInt _ (71 : Int)) | 2 => (BitVec.ofInt _ (114 : Int)) | 3 => (BitVec.ofInt _ (92 : Int)) | 4 => (BitVec.ofInt _ (166 : Int)) | _ => default), en := true }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (213 : Int)) | 1 => (BitVec.ofInt _ (173 : Int)) | 2 => (BitVec.ofInt _ (240 : Int)) | 3 => (BitVec.ofInt _ (243 : Int)) | 4 => (BitVec.ofInt _ (243 : Int)) | _ => default), en := true }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (234 : Int)) | 1 => (BitVec.ofInt _ (202 : Int)) | 2 => (BitVec.ofInt _ (124 : Int)) | 3 => (BitVec.ofInt _ (156 : Int)) | 4 => (BitVec.ofInt _ (5 : Int)) | _ => default), en := false }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (214 : Int)) | 1 => (BitVec.ofInt _ (120 : Int)) | 2 => (BitVec.ofInt _ (52 : Int)) | 3 => (BitVec.ofInt _ (23 : Int)) | 4 => (BitVec.ofInt _ (229 : Int)) | _ => default), en := false }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (241 : Int)) | 1 => (BitVec.ofInt _ (231 : Int)) | 2 => (BitVec.ofInt _ (72 : Int)) | 3 => (BitVec.ofInt _ (12 : Int)) | 4 => (BitVec.ofInt _ (218 : Int)) | _ => default), en := false }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (215 : Int)) | 1 => (BitVec.ofInt _ (104 : Int)) | 2 => (BitVec.ofInt _ (191 : Int)) | 3 => (BitVec.ofInt _ (100 : Int)) | 4 => (BitVec.ofInt _ (118 : Int)) | _ => default), en := false }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (245 : Int)) | 1 => (BitVec.ofInt _ (36 : Int)) | 2 => (BitVec.ofInt _ (151 : Int)) | 3 => (BitVec.ofInt _ (20 : Int)) | 4 => (BitVec.ofInt _ (111 : Int)) | _ => default), en := true }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (79 : Int)) | 1 => (BitVec.ofInt _ (235 : Int)) | 2 => (BitVec.ofInt _ (74 : Int)) | 3 => (BitVec.ofInt _ (184 : Int)) | 4 => (BitVec.ofInt _ (206 : Int)) | _ => default), en := false }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (45 : Int)) | 1 => (BitVec.ofInt _ (4 : Int)) | 2 => (BitVec.ofInt _ (229 : Int)) | 3 => (BitVec.ofInt _ (98 : Int)) | 4 => (BitVec.ofInt _ (235 : Int)) | _ => default), en := false }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (200 : Int)) | 1 => (BitVec.ofInt _ (60 : Int)) | 2 => (BitVec.ofInt _ (229 : Int)) | 3 => (BitVec.ofInt _ (167 : Int)) | 4 => (BitVec.ofInt _ (144 : Int)) | _ => default), en := true }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (237 : Int)) | 1 => (BitVec.ofInt _ (247 : Int)) | 2 => (BitVec.ofInt _ (196 : Int)) | 3 => (BitVec.ofInt _ (23 : Int)) | 4 => (BitVec.ofInt _ (142 : Int)) | _ => default), en := false }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (113 : Int)) | 1 => (BitVec.ofInt _ (185 : Int)) | 2 => (BitVec.ofInt _ (146 : Int)) | 3 => (BitVec.ofInt _ (140 : Int)) | 4 => (BitVec.ofInt _ (133 : Int)) | _ => default), en := false }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (183 : Int)) | 1 => (BitVec.ofInt _ (137 : Int)) | 2 => (BitVec.ofInt _ (100 : Int)) | 3 => (BitVec.ofInt _ (118 : Int)) | 4 => (BitVec.ofInt _ (167 : Int)) | _ => default), en := false }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (106 : Int)) | 1 => (BitVec.ofInt _ (117 : Int)) | 2 => (BitVec.ofInt _ (10 : Int)) | 3 => (BitVec.ofInt _ (63 : Int)) | 4 => (BitVec.ofInt _ (167 : Int)) | _ => default), en := false }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (143 : Int)) | 1 => (BitVec.ofInt _ (230 : Int)) | 2 => (BitVec.ofInt _ (199 : Int)) | 3 => (BitVec.ofInt _ (190 : Int)) | 4 => (BitVec.ofInt _ (227 : Int)) | _ => default), en := false }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (120 : Int)) | 1 => (BitVec.ofInt _ (180 : Int)) | 2 => (BitVec.ofInt _ (182 : Int)) | 3 => (BitVec.ofInt _ (70 : Int)) | 4 => (BitVec.ofInt _ (164 : Int)) | _ => default), en := true }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (211 : Int)) | 1 => (BitVec.ofInt _ (7 : Int)) | 2 => (BitVec.ofInt _ (170 : Int)) | 3 => (BitVec.ofInt _ (101 : Int)) | 4 => (BitVec.ofInt _ (41 : Int)) | _ => default), en := true }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (188 : Int)) | 1 => (BitVec.ofInt _ (12 : Int)) | 2 => (BitVec.ofInt _ (39 : Int)) | 3 => (BitVec.ofInt _ (212 : Int)) | 4 => (BitVec.ofInt _ (34 : Int)) | _ => default), en := false }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (175 : Int)) | 1 => (BitVec.ofInt _ (78 : Int)) | 2 => (BitVec.ofInt _ (22 : Int)) | 3 => (BitVec.ofInt _ (194 : Int)) | 4 => (BitVec.ofInt _ (28 : Int)) | _ => default), en := true }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (9 : Int)) | 1 => (BitVec.ofInt _ (234 : Int)) | 2 => (BitVec.ofInt _ (146 : Int)) | 3 => (BitVec.ofInt _ (127 : Int)) | 4 => (BitVec.ofInt _ (115 : Int)) | _ => default), en := false }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (219 : Int)) | 1 => (BitVec.ofInt _ (54 : Int)) | 2 => (BitVec.ofInt _ (52 : Int)) | 3 => (BitVec.ofInt _ (210 : Int)) | 4 => (BitVec.ofInt _ (205 : Int)) | _ => default), en := true }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (132 : Int)) | 1 => (BitVec.ofInt _ (86 : Int)) | 2 => (BitVec.ofInt _ (187 : Int)) | 3 => (BitVec.ofInt _ (123 : Int)) | 4 => (BitVec.ofInt _ (93 : Int)) | _ => default), en := false }, true),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (238 : Int)) | 1 => (BitVec.ofInt _ (138 : Int)) | 2 => (BitVec.ofInt _ (15 : Int)) | 3 => (BitVec.ofInt _ (158 : Int)) | 4 => (BitVec.ofInt _ (7 : Int)) | _ => default), en := true }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (188 : Int)) | 1 => (BitVec.ofInt _ (16 : Int)) | 2 => (BitVec.ofInt _ (124 : Int)) | 3 => (BitVec.ofInt _ (32 : Int)) | 4 => (BitVec.ofInt _ (228 : Int)) | _ => default), en := true }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (83 : Int)) | 1 => (BitVec.ofInt _ (245 : Int)) | 2 => (BitVec.ofInt _ (252 : Int)) | 3 => (BitVec.ofInt _ (156 : Int)) | 4 => (BitVec.ofInt _ (38 : Int)) | _ => default), en := false }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (33 : Int)) | 1 => (BitVec.ofInt _ (16 : Int)) | 2 => (BitVec.ofInt _ (51 : Int)) | 3 => (BitVec.ofInt _ (17 : Int)) | 4 => (BitVec.ofInt _ (21 : Int)) | _ => default), en := false }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (235 : Int)) | 1 => (BitVec.ofInt _ (54 : Int)) | 2 => (BitVec.ofInt _ (152 : Int)) | 3 => (BitVec.ofInt _ (239 : Int)) | 4 => (BitVec.ofInt _ (185 : Int)) | _ => default), en := true }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (66 : Int)) | 1 => (BitVec.ofInt _ (174 : Int)) | 2 => (BitVec.ofInt _ (254 : Int)) | 3 => (BitVec.ofInt _ (178 : Int)) | 4 => (BitVec.ofInt _ (224 : Int)) | _ => default), en := false }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (193 : Int)) | 1 => (BitVec.ofInt _ (84 : Int)) | 2 => (BitVec.ofInt _ (249 : Int)) | 3 => (BitVec.ofInt _ (144 : Int)) | 4 => (BitVec.ofInt _ (252 : Int)) | _ => default), en := false }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (148 : Int)) | 1 => (BitVec.ofInt _ (83 : Int)) | 2 => (BitVec.ofInt _ (93 : Int)) | 3 => (BitVec.ofInt _ (128 : Int)) | 4 => (BitVec.ofInt _ (133 : Int)) | _ => default), en := true }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (167 : Int)) | 1 => (BitVec.ofInt _ (63 : Int)) | 2 => (BitVec.ofInt _ (22 : Int)) | 3 => (BitVec.ofInt _ (152 : Int)) | 4 => (BitVec.ofInt _ (217 : Int)) | _ => default), en := true }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (178 : Int)) | 1 => (BitVec.ofInt _ (99 : Int)) | 2 => (BitVec.ofInt _ (199 : Int)) | 3 => (BitVec.ofInt _ (165 : Int)) | 4 => (BitVec.ofInt _ (11 : Int)) | _ => default), en := true }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (156 : Int)) | 1 => (BitVec.ofInt _ (113 : Int)) | 2 => (BitVec.ofInt _ (231 : Int)) | 3 => (BitVec.ofInt _ (82 : Int)) | 4 => (BitVec.ofInt _ (204 : Int)) | _ => default), en := true }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (245 : Int)) | 1 => (BitVec.ofInt _ (84 : Int)) | 2 => (BitVec.ofInt _ (162 : Int)) | 3 => (BitVec.ofInt _ (139 : Int)) | 4 => (BitVec.ofInt _ (218 : Int)) | _ => default), en := false }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (127 : Int)) | 1 => (BitVec.ofInt _ (195 : Int)) | 2 => (BitVec.ofInt _ (36 : Int)) | 3 => (BitVec.ofInt _ (240 : Int)) | 4 => (BitVec.ofInt _ (224 : Int)) | _ => default), en := false }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (23 : Int)) | 1 => (BitVec.ofInt _ (165 : Int)) | 2 => (BitVec.ofInt _ (7 : Int)) | 3 => (BitVec.ofInt _ (19 : Int)) | 4 => (BitVec.ofInt _ (243 : Int)) | _ => default), en := false }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (159 : Int)) | 1 => (BitVec.ofInt _ (143 : Int)) | 2 => (BitVec.ofInt _ (221 : Int)) | 3 => (BitVec.ofInt _ (46 : Int)) | 4 => (BitVec.ofInt _ (164 : Int)) | _ => default), en := false }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (192 : Int)) | 1 => (BitVec.ofInt _ (186 : Int)) | 2 => (BitVec.ofInt _ (66 : Int)) | 3 => (BitVec.ofInt _ (207 : Int)) | 4 => (BitVec.ofInt _ (126 : Int)) | _ => default), en := true }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (11 : Int)) | 1 => (BitVec.ofInt _ (76 : Int)) | 2 => (BitVec.ofInt _ (168 : Int)) | 3 => (BitVec.ofInt _ (46 : Int)) | 4 => (BitVec.ofInt _ (168 : Int)) | _ => default), en := false }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (158 : Int)) | 1 => (BitVec.ofInt _ (117 : Int)) | 2 => (BitVec.ofInt _ (170 : Int)) | 3 => (BitVec.ofInt _ (225 : Int)) | 4 => (BitVec.ofInt _ (203 : Int)) | _ => default), en := false }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (184 : Int)) | 1 => (BitVec.ofInt _ (93 : Int)) | 2 => (BitVec.ofInt _ (35 : Int)) | 3 => (BitVec.ofInt _ (242 : Int)) | 4 => (BitVec.ofInt _ (62 : Int)) | _ => default), en := true }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (195 : Int)) | 1 => (BitVec.ofInt _ (80 : Int)) | 2 => (BitVec.ofInt _ (234 : Int)) | 3 => (BitVec.ofInt _ (145 : Int)) | 4 => (BitVec.ofInt _ (20 : Int)) | _ => default), en := false }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (115 : Int)) | 1 => (BitVec.ofInt _ (112 : Int)) | 2 => (BitVec.ofInt _ (121 : Int)) | 3 => (BitVec.ofInt _ (144 : Int)) | 4 => (BitVec.ofInt _ (190 : Int)) | _ => default), en := false }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (47 : Int)) | 1 => (BitVec.ofInt _ (85 : Int)) | 2 => (BitVec.ofInt _ (191 : Int)) | 3 => (BitVec.ofInt _ (207 : Int)) | 4 => (BitVec.ofInt _ (245 : Int)) | _ => default), en := true }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (223 : Int)) | 1 => (BitVec.ofInt _ (142 : Int)) | 2 => (BitVec.ofInt _ (225 : Int)) | 3 => (BitVec.ofInt _ (45 : Int)) | 4 => (BitVec.ofInt _ (184 : Int)) | _ => default), en := true }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("out", Lean.Json.arr (((List.finRange 5).map (fun j0 => Lean.toJson ((o.«out») j0).toNat)).toArray))]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("regs", Lean.Json.arr (((List.finRange 5).map (fun j0 => Lean.toJson ((s.regs) j0).toNat)).toArray))]
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (234 : Int)) | 1 => (BitVec.ofInt _ (99 : Int)) | 2 => (BitVec.ofInt _ (167 : Int)) | 3 => (BitVec.ofInt _ (242 : Int)) | 4 => (BitVec.ofInt _ (49 : Int)) | _ => default), en := true }
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
