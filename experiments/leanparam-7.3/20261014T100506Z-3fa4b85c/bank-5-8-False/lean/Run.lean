import leanparam.AnnotatedBank
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open leanparam.AnnotatedBank
def p : Params := { n := (5 : Int), w := (8 : Int), extra := false }
def inputsTrace : List (Inputs p × Bool) := [
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (136 : Int)) | 1 => (BitVec.ofInt _ (420 : Int)) | 2 => (BitVec.ofInt _ (303 : Int)) | 3 => (BitVec.ofInt _ (454 : Int)) | 4 => (BitVec.ofInt _ (178 : Int)) | _ => default) }, true),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (100 : Int)) | 1 => (BitVec.ofInt _ (236 : Int)) | 2 => (BitVec.ofInt _ (275 : Int)) | 3 => (BitVec.ofInt _ (54 : Int)) | 4 => (BitVec.ofInt _ (170 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (62 : Int)) | 1 => (BitVec.ofInt _ (3 : Int)) | 2 => (BitVec.ofInt _ (483 : Int)) | 3 => (BitVec.ofInt _ (366 : Int)) | 4 => (BitVec.ofInt _ (419 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (368 : Int)) | 1 => (BitVec.ofInt _ (403 : Int)) | 2 => (BitVec.ofInt _ (477 : Int)) | 3 => (BitVec.ofInt _ (123 : Int)) | 4 => (BitVec.ofInt _ (441 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (430 : Int)) | 1 => (BitVec.ofInt _ (355 : Int)) | 2 => (BitVec.ofInt _ (61 : Int)) | 3 => (BitVec.ofInt _ (237 : Int)) | 4 => (BitVec.ofInt _ (28 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (486 : Int)) | 1 => (BitVec.ofInt _ (228 : Int)) | 2 => (BitVec.ofInt _ (321 : Int)) | 3 => (BitVec.ofInt _ (151 : Int)) | 4 => (BitVec.ofInt _ (140 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (258 : Int)) | 1 => (BitVec.ofInt _ (152 : Int)) | 2 => (BitVec.ofInt _ (95 : Int)) | 3 => (BitVec.ofInt _ (412 : Int)) | 4 => (BitVec.ofInt _ (457 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (485 : Int)) | 1 => (BitVec.ofInt _ (79 : Int)) | 2 => (BitVec.ofInt _ (291 : Int)) | 3 => (BitVec.ofInt _ (140 : Int)) | 4 => (BitVec.ofInt _ (124 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (162 : Int)) | 1 => (BitVec.ofInt _ (312 : Int)) | 2 => (BitVec.ofInt _ (350 : Int)) | 3 => (BitVec.ofInt _ (113 : Int)) | 4 => (BitVec.ofInt _ (476 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (353 : Int)) | 1 => (BitVec.ofInt _ (55 : Int)) | 2 => (BitVec.ofInt _ (67 : Int)) | 3 => (BitVec.ofInt _ (331 : Int)) | 4 => (BitVec.ofInt _ (93 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (357 : Int)) | 1 => (BitVec.ofInt _ (64 : Int)) | 2 => (BitVec.ofInt _ (67 : Int)) | 3 => (BitVec.ofInt _ (395 : Int)) | 4 => (BitVec.ofInt _ (66 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (130 : Int)) | 1 => (BitVec.ofInt _ (417 : Int)) | 2 => (BitVec.ofInt _ (118 : Int)) | 3 => (BitVec.ofInt _ (189 : Int)) | 4 => (BitVec.ofInt _ (317 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (254 : Int)) | 1 => (BitVec.ofInt _ (324 : Int)) | 2 => (BitVec.ofInt _ (331 : Int)) | 3 => (BitVec.ofInt _ (450 : Int)) | 4 => (BitVec.ofInt _ (64 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (128 : Int)) | 1 => (BitVec.ofInt _ (451 : Int)) | 2 => (BitVec.ofInt _ (336 : Int)) | 3 => (BitVec.ofInt _ (212 : Int)) | 4 => (BitVec.ofInt _ (484 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (26 : Int)) | 1 => (BitVec.ofInt _ (461 : Int)) | 2 => (BitVec.ofInt _ (500 : Int)) | 3 => (BitVec.ofInt _ (65 : Int)) | 4 => (BitVec.ofInt _ (403 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (442 : Int)) | 1 => (BitVec.ofInt _ (41 : Int)) | 2 => (BitVec.ofInt _ (317 : Int)) | 3 => (BitVec.ofInt _ (428 : Int)) | 4 => (BitVec.ofInt _ (86 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (489 : Int)) | 1 => (BitVec.ofInt _ (413 : Int)) | 2 => (BitVec.ofInt _ (413 : Int)) | 3 => (BitVec.ofInt _ (320 : Int)) | 4 => (BitVec.ofInt _ (200 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (26 : Int)) | 1 => (BitVec.ofInt _ (249 : Int)) | 2 => (BitVec.ofInt _ (209 : Int)) | 3 => (BitVec.ofInt _ (378 : Int)) | 4 => (BitVec.ofInt _ (358 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (1 : Int)) | 1 => (BitVec.ofInt _ (23 : Int)) | 2 => (BitVec.ofInt _ (418 : Int)) | 3 => (BitVec.ofInt _ (63 : Int)) | 4 => (BitVec.ofInt _ (218 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (245 : Int)) | 1 => (BitVec.ofInt _ (41 : Int)) | 2 => (BitVec.ofInt _ (233 : Int)) | 3 => (BitVec.ofInt _ (188 : Int)) | 4 => (BitVec.ofInt _ (444 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (309 : Int)) | 1 => (BitVec.ofInt _ (204 : Int)) | 2 => (BitVec.ofInt _ (494 : Int)) | 3 => (BitVec.ofInt _ (83 : Int)) | 4 => (BitVec.ofInt _ (200 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (106 : Int)) | 1 => (BitVec.ofInt _ (15 : Int)) | 2 => (BitVec.ofInt _ (263 : Int)) | 3 => (BitVec.ofInt _ (187 : Int)) | 4 => (BitVec.ofInt _ (453 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (67 : Int)) | 1 => (BitVec.ofInt _ (25 : Int)) | 2 => (BitVec.ofInt _ (141 : Int)) | 3 => (BitVec.ofInt _ (342 : Int)) | 4 => (BitVec.ofInt _ (381 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (212 : Int)) | 1 => (BitVec.ofInt _ (106 : Int)) | 2 => (BitVec.ofInt _ (433 : Int)) | 3 => (BitVec.ofInt _ (198 : Int)) | 4 => (BitVec.ofInt _ (405 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (111 : Int)) | 1 => (BitVec.ofInt _ (166 : Int)) | 2 => (BitVec.ofInt _ (50 : Int)) | 3 => (BitVec.ofInt _ (3 : Int)) | 4 => (BitVec.ofInt _ (140 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (180 : Int)) | 1 => (BitVec.ofInt _ (177 : Int)) | 2 => (BitVec.ofInt _ (269 : Int)) | 3 => (BitVec.ofInt _ (414 : Int)) | 4 => (BitVec.ofInt _ (375 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (383 : Int)) | 1 => (BitVec.ofInt _ (453 : Int)) | 2 => (BitVec.ofInt _ (339 : Int)) | 3 => (BitVec.ofInt _ (252 : Int)) | 4 => (BitVec.ofInt _ (317 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (481 : Int)) | 1 => (BitVec.ofInt _ (257 : Int)) | 2 => (BitVec.ofInt _ (398 : Int)) | 3 => (BitVec.ofInt _ (132 : Int)) | 4 => (BitVec.ofInt _ (426 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (149 : Int)) | 1 => (BitVec.ofInt _ (23 : Int)) | 2 => (BitVec.ofInt _ (396 : Int)) | 3 => (BitVec.ofInt _ (354 : Int)) | 4 => (BitVec.ofInt _ (505 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (267 : Int)) | 1 => (BitVec.ofInt _ (470 : Int)) | 2 => (BitVec.ofInt _ (103 : Int)) | 3 => (BitVec.ofInt _ (374 : Int)) | 4 => (BitVec.ofInt _ (507 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (435 : Int)) | 1 => (BitVec.ofInt _ (121 : Int)) | 2 => (BitVec.ofInt _ (306 : Int)) | 3 => (BitVec.ofInt _ (502 : Int)) | 4 => (BitVec.ofInt _ (99 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (38 : Int)) | 1 => (BitVec.ofInt _ (164 : Int)) | 2 => (BitVec.ofInt _ (398 : Int)) | 3 => (BitVec.ofInt _ (111 : Int)) | 4 => (BitVec.ofInt _ (1 : Int)) | _ => default) }, true),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (36 : Int)) | 1 => (BitVec.ofInt _ (75 : Int)) | 2 => (BitVec.ofInt _ (29 : Int)) | 3 => (BitVec.ofInt _ (178 : Int)) | 4 => (BitVec.ofInt _ (293 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (366 : Int)) | 1 => (BitVec.ofInt _ (478 : Int)) | 2 => (BitVec.ofInt _ (127 : Int)) | 3 => (BitVec.ofInt _ (236 : Int)) | 4 => (BitVec.ofInt _ (102 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (420 : Int)) | 1 => (BitVec.ofInt _ (260 : Int)) | 2 => (BitVec.ofInt _ (192 : Int)) | 3 => (BitVec.ofInt _ (356 : Int)) | 4 => (BitVec.ofInt _ (327 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (366 : Int)) | 1 => (BitVec.ofInt _ (400 : Int)) | 2 => (BitVec.ofInt _ (408 : Int)) | 3 => (BitVec.ofInt _ (7 : Int)) | 4 => (BitVec.ofInt _ (279 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (374 : Int)) | 1 => (BitVec.ofInt _ (94 : Int)) | 2 => (BitVec.ofInt _ (413 : Int)) | 3 => (BitVec.ofInt _ (405 : Int)) | 4 => (BitVec.ofInt _ (41 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (103 : Int)) | 1 => (BitVec.ofInt _ (403 : Int)) | 2 => (BitVec.ofInt _ (51 : Int)) | 3 => (BitVec.ofInt _ (436 : Int)) | 4 => (BitVec.ofInt _ (502 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (205 : Int)) | 1 => (BitVec.ofInt _ (53 : Int)) | 2 => (BitVec.ofInt _ (394 : Int)) | 3 => (BitVec.ofInt _ (26 : Int)) | 4 => (BitVec.ofInt _ (440 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (369 : Int)) | 1 => (BitVec.ofInt _ (64 : Int)) | 2 => (BitVec.ofInt _ (425 : Int)) | 3 => (BitVec.ofInt _ (428 : Int)) | 4 => (BitVec.ofInt _ (163 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (282 : Int)) | 1 => (BitVec.ofInt _ (490 : Int)) | 2 => (BitVec.ofInt _ (156 : Int)) | 3 => (BitVec.ofInt _ (318 : Int)) | 4 => (BitVec.ofInt _ (142 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (284 : Int)) | 1 => (BitVec.ofInt _ (66 : Int)) | 2 => (BitVec.ofInt _ (178 : Int)) | 3 => (BitVec.ofInt _ (387 : Int)) | 4 => (BitVec.ofInt _ (432 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (270 : Int)) | 1 => (BitVec.ofInt _ (272 : Int)) | 2 => (BitVec.ofInt _ (187 : Int)) | 3 => (BitVec.ofInt _ (216 : Int)) | 4 => (BitVec.ofInt _ (349 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (148 : Int)) | 1 => (BitVec.ofInt _ (251 : Int)) | 2 => (BitVec.ofInt _ (410 : Int)) | 3 => (BitVec.ofInt _ (20 : Int)) | 4 => (BitVec.ofInt _ (67 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (181 : Int)) | 1 => (BitVec.ofInt _ (391 : Int)) | 2 => (BitVec.ofInt _ (385 : Int)) | 3 => (BitVec.ofInt _ (160 : Int)) | 4 => (BitVec.ofInt _ (298 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (491 : Int)) | 1 => (BitVec.ofInt _ (358 : Int)) | 2 => (BitVec.ofInt _ (319 : Int)) | 3 => (BitVec.ofInt _ (398 : Int)) | 4 => (BitVec.ofInt _ (348 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (136 : Int)) | 1 => (BitVec.ofInt _ (76 : Int)) | 2 => (BitVec.ofInt _ (369 : Int)) | 3 => (BitVec.ofInt _ (164 : Int)) | 4 => (BitVec.ofInt _ (49 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (318 : Int)) | 1 => (BitVec.ofInt _ (332 : Int)) | 2 => (BitVec.ofInt _ (361 : Int)) | 3 => (BitVec.ofInt _ (82 : Int)) | 4 => (BitVec.ofInt _ (440 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (471 : Int)) | 1 => (BitVec.ofInt _ (153 : Int)) | 2 => (BitVec.ofInt _ (57 : Int)) | 3 => (BitVec.ofInt _ (191 : Int)) | 4 => (BitVec.ofInt _ (55 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (29 : Int)) | 1 => (BitVec.ofInt _ (446 : Int)) | 2 => (BitVec.ofInt _ (138 : Int)) | 3 => (BitVec.ofInt _ (121 : Int)) | 4 => (BitVec.ofInt _ (396 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (489 : Int)) | 1 => (BitVec.ofInt _ (124 : Int)) | 2 => (BitVec.ofInt _ (31 : Int)) | 3 => (BitVec.ofInt _ (275 : Int)) | 4 => (BitVec.ofInt _ (317 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (173 : Int)) | 1 => (BitVec.ofInt _ (309 : Int)) | 2 => (BitVec.ofInt _ (274 : Int)) | 3 => (BitVec.ofInt _ (191 : Int)) | 4 => (BitVec.ofInt _ (217 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (362 : Int)) | 1 => (BitVec.ofInt _ (254 : Int)) | 2 => (BitVec.ofInt _ (491 : Int)) | 3 => (BitVec.ofInt _ (377 : Int)) | 4 => (BitVec.ofInt _ (474 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (246 : Int)) | 1 => (BitVec.ofInt _ (3 : Int)) | 2 => (BitVec.ofInt _ (456 : Int)) | 3 => (BitVec.ofInt _ (433 : Int)) | 4 => (BitVec.ofInt _ (33 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (427 : Int)) | 1 => (BitVec.ofInt _ (135 : Int)) | 2 => (BitVec.ofInt _ (362 : Int)) | 3 => (BitVec.ofInt _ (504 : Int)) | 4 => (BitVec.ofInt _ (448 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (305 : Int)) | 1 => (BitVec.ofInt _ (171 : Int)) | 2 => (BitVec.ofInt _ (54 : Int)) | 3 => (BitVec.ofInt _ (429 : Int)) | 4 => (BitVec.ofInt _ (323 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (456 : Int)) | 1 => (BitVec.ofInt _ (299 : Int)) | 2 => (BitVec.ofInt _ (211 : Int)) | 3 => (BitVec.ofInt _ (245 : Int)) | 4 => (BitVec.ofInt _ (403 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (246 : Int)) | 1 => (BitVec.ofInt _ (210 : Int)) | 2 => (BitVec.ofInt _ (256 : Int)) | 3 => (BitVec.ofInt _ (290 : Int)) | 4 => (BitVec.ofInt _ (467 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (171 : Int)) | 1 => (BitVec.ofInt _ (13 : Int)) | 2 => (BitVec.ofInt _ (384 : Int)) | 3 => (BitVec.ofInt _ (430 : Int)) | 4 => (BitVec.ofInt _ (252 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (292 : Int)) | 1 => (BitVec.ofInt _ (61 : Int)) | 2 => (BitVec.ofInt _ (55 : Int)) | 3 => (BitVec.ofInt _ (165 : Int)) | 4 => (BitVec.ofInt _ (280 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (389 : Int)) | 1 => (BitVec.ofInt _ (270 : Int)) | 2 => (BitVec.ofInt _ (40 : Int)) | 3 => (BitVec.ofInt _ (210 : Int)) | 4 => (BitVec.ofInt _ (429 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (483 : Int)) | 1 => (BitVec.ofInt _ (441 : Int)) | 2 => (BitVec.ofInt _ (262 : Int)) | 3 => (BitVec.ofInt _ (237 : Int)) | 4 => (BitVec.ofInt _ (378 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (132 : Int)) | 1 => (BitVec.ofInt _ (355 : Int)) | 2 => (BitVec.ofInt _ (465 : Int)) | 3 => (BitVec.ofInt _ (107 : Int)) | 4 => (BitVec.ofInt _ (338 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (245 : Int)) | 1 => (BitVec.ofInt _ (63 : Int)) | 2 => (BitVec.ofInt _ (234 : Int)) | 3 => (BitVec.ofInt _ (125 : Int)) | 4 => (BitVec.ofInt _ (102 : Int)) | _ => default) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("out", Lean.Json.arr (((List.finRange 5).map (fun j0 => Lean.toJson ((o.«out») j0).toNat)).toArray))]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("stored", Lean.Json.arr (((List.finRange 5).map (fun j0 => Lean.toJson ((s.stored) j0).toNat)).toArray))]
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (136 : Int)) | 1 => (BitVec.ofInt _ (420 : Int)) | 2 => (BitVec.ofInt _ (303 : Int)) | 3 => (BitVec.ofInt _ (454 : Int)) | 4 => (BitVec.ofInt _ (178 : Int)) | _ => default) }
  let mut state : State p := resetState p first
  let mut cycle : Nat := 0
  for entry in inputsTrace do
    let (inputs, reset) := entry
    if !outputDefined p inputs state && !(cycle == 0 && false) then throw (IO.userError "Undefined output operation in input trace")
    let pre := output p inputs state
    if !transitionDefined p inputs state reset then throw (IO.userError "Undefined transition operation in input trace")
    let next := step p inputs state reset
    if !outputDefined p inputs next then throw (IO.userError "Undefined output operation after clock edge")
    let post := output p inputs next
    IO.println (Lean.Json.mkObj [("cycle", Lean.toJson cycle), ("pre", outputsJson pre),
      ("post", outputsJson post), ("state", stateJson next)]).compress
    state := next
    cycle := cycle + 1
