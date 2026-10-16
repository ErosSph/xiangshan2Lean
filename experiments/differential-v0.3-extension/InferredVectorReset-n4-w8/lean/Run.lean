import probes.InferredVectorReset
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.InferredVectorReset
def p : Params := { n := (4 : Int), w := (8 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (234 : Int)) | 1 => (BitVec.ofInt _ (99 : Int)) | 2 => (BitVec.ofInt _ (167 : Int)) | 3 => (BitVec.ofInt _ (242 : Int)) | _ => default) }, true),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (49 : Int)) | 1 => (BitVec.ofInt _ (212 : Int)) | 2 => (BitVec.ofInt _ (27 : Int)) | 3 => (BitVec.ofInt _ (121 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (37 : Int)) | 1 => (BitVec.ofInt _ (9 : Int)) | 2 => (BitVec.ofInt _ (113 : Int)) | 3 => (BitVec.ofInt _ (53 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (127 : Int)) | 1 => (BitVec.ofInt _ (66 : Int)) | 2 => (BitVec.ofInt _ (102 : Int)) | 3 => (BitVec.ofInt _ (231 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (250 : Int)) | 1 => (BitVec.ofInt _ (78 : Int)) | 2 => (BitVec.ofInt _ (23 : Int)) | 3 => (BitVec.ofInt _ (71 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (114 : Int)) | 1 => (BitVec.ofInt _ (92 : Int)) | 2 => (BitVec.ofInt _ (166 : Int)) | 3 => (BitVec.ofInt _ (203 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (213 : Int)) | 1 => (BitVec.ofInt _ (173 : Int)) | 2 => (BitVec.ofInt _ (240 : Int)) | 3 => (BitVec.ofInt _ (243 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (243 : Int)) | 1 => (BitVec.ofInt _ (220 : Int)) | 2 => (BitVec.ofInt _ (234 : Int)) | 3 => (BitVec.ofInt _ (202 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (124 : Int)) | 1 => (BitVec.ofInt _ (156 : Int)) | 2 => (BitVec.ofInt _ (5 : Int)) | 3 => (BitVec.ofInt _ (75 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (214 : Int)) | 1 => (BitVec.ofInt _ (120 : Int)) | 2 => (BitVec.ofInt _ (52 : Int)) | 3 => (BitVec.ofInt _ (23 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (229 : Int)) | 1 => (BitVec.ofInt _ (35 : Int)) | 2 => (BitVec.ofInt _ (241 : Int)) | 3 => (BitVec.ofInt _ (231 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (72 : Int)) | 1 => (BitVec.ofInt _ (12 : Int)) | 2 => (BitVec.ofInt _ (218 : Int)) | 3 => (BitVec.ofInt _ (13 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (215 : Int)) | 1 => (BitVec.ofInt _ (104 : Int)) | 2 => (BitVec.ofInt _ (191 : Int)) | 3 => (BitVec.ofInt _ (100 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (118 : Int)) | 1 => (BitVec.ofInt _ (19 : Int)) | 2 => (BitVec.ofInt _ (245 : Int)) | 3 => (BitVec.ofInt _ (36 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (151 : Int)) | 1 => (BitVec.ofInt _ (20 : Int)) | 2 => (BitVec.ofInt _ (111 : Int)) | 3 => (BitVec.ofInt _ (150 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (79 : Int)) | 1 => (BitVec.ofInt _ (235 : Int)) | 2 => (BitVec.ofInt _ (74 : Int)) | 3 => (BitVec.ofInt _ (184 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (206 : Int)) | 1 => (BitVec.ofInt _ (74 : Int)) | 2 => (BitVec.ofInt _ (45 : Int)) | 3 => (BitVec.ofInt _ (4 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (229 : Int)) | 1 => (BitVec.ofInt _ (98 : Int)) | 2 => (BitVec.ofInt _ (235 : Int)) | 3 => (BitVec.ofInt _ (34 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (200 : Int)) | 1 => (BitVec.ofInt _ (60 : Int)) | 2 => (BitVec.ofInt _ (229 : Int)) | 3 => (BitVec.ofInt _ (167 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (144 : Int)) | 1 => (BitVec.ofInt _ (176 : Int)) | 2 => (BitVec.ofInt _ (237 : Int)) | 3 => (BitVec.ofInt _ (247 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (196 : Int)) | 1 => (BitVec.ofInt _ (23 : Int)) | 2 => (BitVec.ofInt _ (142 : Int)) | 3 => (BitVec.ofInt _ (111 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (113 : Int)) | 1 => (BitVec.ofInt _ (185 : Int)) | 2 => (BitVec.ofInt _ (146 : Int)) | 3 => (BitVec.ofInt _ (140 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (133 : Int)) | 1 => (BitVec.ofInt _ (87 : Int)) | 2 => (BitVec.ofInt _ (183 : Int)) | 3 => (BitVec.ofInt _ (137 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (100 : Int)) | 1 => (BitVec.ofInt _ (118 : Int)) | 2 => (BitVec.ofInt _ (167 : Int)) | 3 => (BitVec.ofInt _ (100 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (106 : Int)) | 1 => (BitVec.ofInt _ (117 : Int)) | 2 => (BitVec.ofInt _ (10 : Int)) | 3 => (BitVec.ofInt _ (63 : Int)) | _ => default) }, true),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (167 : Int)) | 1 => (BitVec.ofInt _ (42 : Int)) | 2 => (BitVec.ofInt _ (143 : Int)) | 3 => (BitVec.ofInt _ (230 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (199 : Int)) | 1 => (BitVec.ofInt _ (190 : Int)) | 2 => (BitVec.ofInt _ (227 : Int)) | 3 => (BitVec.ofInt _ (86 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (120 : Int)) | 1 => (BitVec.ofInt _ (180 : Int)) | 2 => (BitVec.ofInt _ (182 : Int)) | 3 => (BitVec.ofInt _ (70 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (164 : Int)) | 1 => (BitVec.ofInt _ (169 : Int)) | 2 => (BitVec.ofInt _ (211 : Int)) | 3 => (BitVec.ofInt _ (7 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (170 : Int)) | 1 => (BitVec.ofInt _ (101 : Int)) | 2 => (BitVec.ofInt _ (41 : Int)) | 3 => (BitVec.ofInt _ (195 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (188 : Int)) | 1 => (BitVec.ofInt _ (12 : Int)) | 2 => (BitVec.ofInt _ (39 : Int)) | 3 => (BitVec.ofInt _ (212 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (34 : Int)) | 1 => (BitVec.ofInt _ (105 : Int)) | 2 => (BitVec.ofInt _ (175 : Int)) | 3 => (BitVec.ofInt _ (78 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (22 : Int)) | 1 => (BitVec.ofInt _ (194 : Int)) | 2 => (BitVec.ofInt _ (28 : Int)) | 3 => (BitVec.ofInt _ (174 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (9 : Int)) | 1 => (BitVec.ofInt _ (234 : Int)) | 2 => (BitVec.ofInt _ (146 : Int)) | 3 => (BitVec.ofInt _ (127 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (115 : Int)) | 1 => (BitVec.ofInt _ (94 : Int)) | 2 => (BitVec.ofInt _ (219 : Int)) | 3 => (BitVec.ofInt _ (54 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (52 : Int)) | 1 => (BitVec.ofInt _ (210 : Int)) | 2 => (BitVec.ofInt _ (205 : Int)) | 3 => (BitVec.ofInt _ (169 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (132 : Int)) | 1 => (BitVec.ofInt _ (86 : Int)) | 2 => (BitVec.ofInt _ (187 : Int)) | 3 => (BitVec.ofInt _ (123 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (93 : Int)) | 1 => (BitVec.ofInt _ (53 : Int)) | 2 => (BitVec.ofInt _ (238 : Int)) | 3 => (BitVec.ofInt _ (138 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (15 : Int)) | 1 => (BitVec.ofInt _ (158 : Int)) | 2 => (BitVec.ofInt _ (7 : Int)) | 3 => (BitVec.ofInt _ (212 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (188 : Int)) | 1 => (BitVec.ofInt _ (16 : Int)) | 2 => (BitVec.ofInt _ (124 : Int)) | 3 => (BitVec.ofInt _ (32 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (228 : Int)) | 1 => (BitVec.ofInt _ (155 : Int)) | 2 => (BitVec.ofInt _ (83 : Int)) | 3 => (BitVec.ofInt _ (245 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (252 : Int)) | 1 => (BitVec.ofInt _ (156 : Int)) | 2 => (BitVec.ofInt _ (38 : Int)) | 3 => (BitVec.ofInt _ (32 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (33 : Int)) | 1 => (BitVec.ofInt _ (16 : Int)) | 2 => (BitVec.ofInt _ (51 : Int)) | 3 => (BitVec.ofInt _ (17 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (21 : Int)) | 1 => (BitVec.ofInt _ (13 : Int)) | 2 => (BitVec.ofInt _ (235 : Int)) | 3 => (BitVec.ofInt _ (54 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (152 : Int)) | 1 => (BitVec.ofInt _ (239 : Int)) | 2 => (BitVec.ofInt _ (185 : Int)) | 3 => (BitVec.ofInt _ (163 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (66 : Int)) | 1 => (BitVec.ofInt _ (174 : Int)) | 2 => (BitVec.ofInt _ (254 : Int)) | 3 => (BitVec.ofInt _ (178 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (224 : Int)) | 1 => (BitVec.ofInt _ (38 : Int)) | 2 => (BitVec.ofInt _ (193 : Int)) | 3 => (BitVec.ofInt _ (84 : Int)) | _ => default) }, false),
  ({ «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (249 : Int)) | 1 => (BitVec.ofInt _ (144 : Int)) | 2 => (BitVec.ofInt _ (252 : Int)) | 3 => (BitVec.ofInt _ (127 : Int)) | _ => default) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("out", Lean.Json.arr (((List.finRange 4).map (fun j0 => Lean.toJson ((o.«out») j0).toNat)).toArray))]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("r", Lean.Json.arr (((List.finRange 4).map (fun j0 => Lean.toJson ((s.r) j0).toNat)).toArray))]
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { «in» := (fun j => match j.val with | 0 => (BitVec.ofInt _ (234 : Int)) | 1 => (BitVec.ofInt _ (99 : Int)) | 2 => (BitVec.ofInt _ (167 : Int)) | 3 => (BitVec.ofInt _ (242 : Int)) | _ => default) }
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
