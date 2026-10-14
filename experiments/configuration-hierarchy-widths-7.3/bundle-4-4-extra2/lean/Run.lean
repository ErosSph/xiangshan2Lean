import configuration.ConfiguredBundlePipeline
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open configuration.ConfiguredBundlePipeline
def p : Params := { extra := (2 : Int), cfg_p_configuration_CoreKey_width := (4 : Int), cfg_other_configuration_CoreKey_width := (4 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ data_header_code := (BitVec.ofInt _ (0 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (0 : Int)), data_tag := (BitVec.ofInt _ (0 : Int)), data_tail := (BitVec.ofInt _ (0 : Int)), en := true }, true),
  ({ data_header_code := (BitVec.ofInt _ (1 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (10 : Int)), data_tag := (BitVec.ofInt _ (19 : Int)), data_tail := (BitVec.ofInt _ (49 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (4 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (11 : Int)), data_tag := (BitVec.ofInt _ (10 : Int)), data_tail := (BitVec.ofInt _ (12 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (5 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (2 : Int)), data_tag := (BitVec.ofInt _ (9 : Int)), data_tail := (BitVec.ofInt _ (36 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (2 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (0 : Int)), data_tag := (BitVec.ofInt _ (15 : Int)), data_tail := (BitVec.ofInt _ (20 : Int)), en := false }, false),
  ({ data_header_code := (BitVec.ofInt _ (12 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (6 : Int)), data_tag := (BitVec.ofInt _ (27 : Int)), data_tail := (BitVec.ofInt _ (47 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (6 : Int)), data_header_valid := true, data_payload := (BitVec.ofInt _ (6 : Int)), data_tag := (BitVec.ofInt _ (1 : Int)), data_tail := (BitVec.ofInt _ (27 : Int)), en := false }, false),
  ({ data_header_code := (BitVec.ofInt _ (7 : Int)), data_header_valid := true, data_payload := (BitVec.ofInt _ (10 : Int)), data_tag := (BitVec.ofInt _ (13 : Int)), data_tail := (BitVec.ofInt _ (44 : Int)), en := false }, false),
  ({ data_header_code := (BitVec.ofInt _ (12 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (12 : Int)), data_tag := (BitVec.ofInt _ (30 : Int)), data_tail := (BitVec.ofInt _ (6 : Int)), en := false }, false),
  ({ data_header_code := (BitVec.ofInt _ (2 : Int)), data_header_valid := true, data_payload := (BitVec.ofInt _ (6 : Int)), data_tag := (BitVec.ofInt _ (3 : Int)), data_tail := (BitVec.ofInt _ (60 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (4 : Int)), data_header_valid := true, data_payload := (BitVec.ofInt _ (8 : Int)), data_tag := (BitVec.ofInt _ (6 : Int)), data_tail := (BitVec.ofInt _ (32 : Int)), en := false }, false),
  ({ data_header_code := (BitVec.ofInt _ (4 : Int)), data_header_valid := true, data_payload := (BitVec.ofInt _ (2 : Int)), data_tag := (BitVec.ofInt _ (2 : Int)), data_tail := (BitVec.ofInt _ (57 : Int)), en := false }, false),
  ({ data_header_code := (BitVec.ofInt _ (12 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (7 : Int)), data_tag := (BitVec.ofInt _ (13 : Int)), data_tail := (BitVec.ofInt _ (61 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (3 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (2 : Int)), data_tag := (BitVec.ofInt _ (22 : Int)), data_tail := (BitVec.ofInt _ (28 : Int)), en := false }, false),
  ({ data_header_code := (BitVec.ofInt _ (3 : Int)), data_header_valid := true, data_payload := (BitVec.ofInt _ (6 : Int)), data_tag := (BitVec.ofInt _ (20 : Int)), data_tail := (BitVec.ofInt _ (47 : Int)), en := false }, false),
  ({ data_header_code := (BitVec.ofInt _ (10 : Int)), data_header_valid := true, data_payload := (BitVec.ofInt _ (3 : Int)), data_tag := (BitVec.ofInt _ (1 : Int)), data_tail := (BitVec.ofInt _ (19 : Int)), en := false }, false),
  ({ data_header_code := (BitVec.ofInt _ (13 : Int)), data_header_valid := true, data_payload := (BitVec.ofInt _ (10 : Int)), data_tag := (BitVec.ofInt _ (3 : Int)), data_tail := (BitVec.ofInt _ (59 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (2 : Int)), data_header_valid := true, data_payload := (BitVec.ofInt _ (4 : Int)), data_tag := (BitVec.ofInt _ (11 : Int)), data_tail := (BitVec.ofInt _ (49 : Int)), en := false }, false),
  ({ data_header_code := (BitVec.ofInt _ (14 : Int)), data_header_valid := true, data_payload := (BitVec.ofInt _ (9 : Int)), data_tag := (BitVec.ofInt _ (10 : Int)), data_tail := (BitVec.ofInt _ (45 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (1 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (10 : Int)), data_tag := (BitVec.ofInt _ (7 : Int)), data_tail := (BitVec.ofInt _ (12 : Int)), en := false }, false),
  ({ data_header_code := (BitVec.ofInt _ (9 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (5 : Int)), data_tag := (BitVec.ofInt _ (22 : Int)), data_tail := (BitVec.ofInt _ (7 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (1 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (6 : Int)), data_tag := (BitVec.ofInt _ (3 : Int)), data_tail := (BitVec.ofInt _ (39 : Int)), en := false }, false),
  ({ data_header_code := (BitVec.ofInt _ (3 : Int)), data_header_valid := true, data_payload := (BitVec.ofInt _ (6 : Int)), data_tag := (BitVec.ofInt _ (0 : Int)), data_tail := (BitVec.ofInt _ (60 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (3 : Int)), data_header_valid := true, data_payload := (BitVec.ofInt _ (14 : Int)), data_tag := (BitVec.ofInt _ (31 : Int)), data_tail := (BitVec.ofInt _ (47 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (8 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (4 : Int)), data_tag := (BitVec.ofInt _ (30 : Int)), data_tail := (BitVec.ofInt _ (54 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (10 : Int)), data_header_valid := true, data_payload := (BitVec.ofInt _ (8 : Int)), data_tag := (BitVec.ofInt _ (9 : Int)), data_tail := (BitVec.ofInt _ (24 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (12 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (5 : Int)), data_tag := (BitVec.ofInt _ (25 : Int)), data_tail := (BitVec.ofInt _ (49 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (4 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (0 : Int)), data_tag := (BitVec.ofInt _ (4 : Int)), data_tail := (BitVec.ofInt _ (14 : Int)), en := true }, true),
  ({ data_header_code := (BitVec.ofInt _ (12 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (2 : Int)), data_tag := (BitVec.ofInt _ (5 : Int)), data_tail := (BitVec.ofInt _ (0 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (5 : Int)), data_header_valid := true, data_payload := (BitVec.ofInt _ (12 : Int)), data_tag := (BitVec.ofInt _ (12 : Int)), data_tail := (BitVec.ofInt _ (46 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (9 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (7 : Int)), data_tag := (BitVec.ofInt _ (15 : Int)), data_tail := (BitVec.ofInt _ (26 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (15 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (14 : Int)), data_tag := (BitVec.ofInt _ (21 : Int)), data_tail := (BitVec.ofInt _ (32 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (4 : Int)), data_header_valid := true, data_payload := (BitVec.ofInt _ (1 : Int)), data_tag := (BitVec.ofInt _ (25 : Int)), data_tail := (BitVec.ofInt _ (36 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (12 : Int)), data_header_valid := true, data_payload := (BitVec.ofInt _ (5 : Int)), data_tag := (BitVec.ofInt _ (19 : Int)), data_tail := (BitVec.ofInt _ (53 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (0 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (12 : Int)), data_tag := (BitVec.ofInt _ (1 : Int)), data_tail := (BitVec.ofInt _ (56 : Int)), en := false }, false),
  ({ data_header_code := (BitVec.ofInt _ (9 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (4 : Int)), data_tag := (BitVec.ofInt _ (14 : Int)), data_tail := (BitVec.ofInt _ (57 : Int)), en := false }, false),
  ({ data_header_code := (BitVec.ofInt _ (6 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (5 : Int)), data_tag := (BitVec.ofInt _ (16 : Int)), data_tail := (BitVec.ofInt _ (41 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (14 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (7 : Int)), data_tag := (BitVec.ofInt _ (3 : Int)), data_tail := (BitVec.ofInt _ (11 : Int)), en := false }, false),
  ({ data_header_code := (BitVec.ofInt _ (12 : Int)), data_header_valid := true, data_payload := (BitVec.ofInt _ (14 : Int)), data_tag := (BitVec.ofInt _ (23 : Int)), data_tail := (BitVec.ofInt _ (1 : Int)), en := false }, false),
  ({ data_header_code := (BitVec.ofInt _ (13 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (7 : Int)), data_tag := (BitVec.ofInt _ (23 : Int)), data_tail := (BitVec.ofInt _ (3 : Int)), en := false }, false),
  ({ data_header_code := (BitVec.ofInt _ (15 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (4 : Int)), data_tag := (BitVec.ofInt _ (11 : Int)), data_tail := (BitVec.ofInt _ (1 : Int)), en := false }, false),
  ({ data_header_code := (BitVec.ofInt _ (0 : Int)), data_header_valid := true, data_payload := (BitVec.ofInt _ (1 : Int)), data_tag := (BitVec.ofInt _ (1 : Int)), data_tail := (BitVec.ofInt _ (4 : Int)), en := false }, false),
  ({ data_header_code := (BitVec.ofInt _ (6 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (15 : Int)), data_tag := (BitVec.ofInt _ (18 : Int)), data_tail := (BitVec.ofInt _ (55 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (0 : Int)), data_header_valid := true, data_payload := (BitVec.ofInt _ (14 : Int)), data_tag := (BitVec.ofInt _ (7 : Int)), data_tail := (BitVec.ofInt _ (3 : Int)), en := false }, false),
  ({ data_header_code := (BitVec.ofInt _ (13 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (5 : Int)), data_tag := (BitVec.ofInt _ (22 : Int)), data_tail := (BitVec.ofInt _ (5 : Int)), en := false }, false),
  ({ data_header_code := (BitVec.ofInt _ (7 : Int)), data_header_valid := true, data_payload := (BitVec.ofInt _ (8 : Int)), data_tag := (BitVec.ofInt _ (2 : Int)), data_tail := (BitVec.ofInt _ (9 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (8 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (12 : Int)), data_tag := (BitVec.ofInt _ (6 : Int)), data_tail := (BitVec.ofInt _ (54 : Int)), en := false }, false),
  ({ data_header_code := (BitVec.ofInt _ (7 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (1 : Int)), data_tag := (BitVec.ofInt _ (11 : Int)), data_tail := (BitVec.ofInt _ (60 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (12 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (12 : Int)), data_tag := (BitVec.ofInt _ (23 : Int)), data_tail := (BitVec.ofInt _ (39 : Int)), en := false }, false),
  ({ data_header_code := (BitVec.ofInt _ (2 : Int)), data_header_valid := true, data_payload := (BitVec.ofInt _ (6 : Int)), data_tag := (BitVec.ofInt _ (21 : Int)), data_tail := (BitVec.ofInt _ (16 : Int)), en := false }, false),
  ({ data_header_code := (BitVec.ofInt _ (4 : Int)), data_header_valid := true, data_payload := (BitVec.ofInt _ (4 : Int)), data_tag := (BitVec.ofInt _ (23 : Int)), data_tail := (BitVec.ofInt _ (29 : Int)), en := false }, false),
  ({ data_header_code := (BitVec.ofInt _ (15 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (11 : Int)), data_tag := (BitVec.ofInt _ (2 : Int)), data_tail := (BitVec.ofInt _ (24 : Int)), en := false }, false),
  ({ data_header_code := (BitVec.ofInt _ (15 : Int)), data_header_valid := true, data_payload := (BitVec.ofInt _ (9 : Int)), data_tag := (BitVec.ofInt _ (11 : Int)), data_tail := (BitVec.ofInt _ (34 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (15 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (15 : Int)), data_tag := (BitVec.ofInt _ (25 : Int)), data_tail := (BitVec.ofInt _ (8 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (12 : Int)), data_header_valid := true, data_payload := (BitVec.ofInt _ (2 : Int)), data_tag := (BitVec.ofInt _ (1 : Int)), data_tail := (BitVec.ofInt _ (44 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (11 : Int)), data_header_valid := true, data_payload := (BitVec.ofInt _ (2 : Int)), data_tag := (BitVec.ofInt _ (13 : Int)), data_tail := (BitVec.ofInt _ (36 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (3 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (9 : Int)), data_tag := (BitVec.ofInt _ (7 : Int)), data_tail := (BitVec.ofInt _ (16 : Int)), en := false }, false),
  ({ data_header_code := (BitVec.ofInt _ (1 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (9 : Int)), data_tag := (BitVec.ofInt _ (25 : Int)), data_tail := (BitVec.ofInt _ (22 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (12 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (10 : Int)), data_tag := (BitVec.ofInt _ (13 : Int)), data_tail := (BitVec.ofInt _ (18 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (7 : Int)), data_header_valid := true, data_payload := (BitVec.ofInt _ (3 : Int)), data_tag := (BitVec.ofInt _ (8 : Int)), data_tail := (BitVec.ofInt _ (37 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (7 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (12 : Int)), data_tag := (BitVec.ofInt _ (24 : Int)), data_tail := (BitVec.ofInt _ (11 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (0 : Int)), data_header_valid := true, data_payload := (BitVec.ofInt _ (10 : Int)), data_tag := (BitVec.ofInt _ (23 : Int)), data_tail := (BitVec.ofInt _ (15 : Int)), en := false }, false),
  ({ data_header_code := (BitVec.ofInt _ (14 : Int)), data_header_valid := true, data_payload := (BitVec.ofInt _ (14 : Int)), data_tag := (BitVec.ofInt _ (30 : Int)), data_tail := (BitVec.ofInt _ (51 : Int)), en := true }, false),
  ({ data_header_code := (BitVec.ofInt _ (11 : Int)), data_header_valid := true, data_payload := (BitVec.ofInt _ (12 : Int)), data_tag := (BitVec.ofInt _ (14 : Int)), data_tail := (BitVec.ofInt _ (50 : Int)), en := false }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("out.header.code", Lean.toJson (o.out_header_code).toNat), ("out.header.valid", Lean.toJson (o.out_header_valid)), ("out.payload", Lean.toJson (o.out_payload).toNat), ("out.tag", Lean.toJson (o.out_tag).toNat), ("out.tail", Lean.toJson (o.out_tail).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("saved.header.code", Lean.toJson (s.saved_header_code).toNat), ("saved.header.valid", Lean.toJson (s.saved_header_valid)), ("saved.payload", Lean.toJson (s.saved_payload).toNat), ("saved.tag", Lean.toJson (s.saved_tag).toNat), ("saved.tail", Lean.toJson (s.saved_tail).toNat)]
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { data_header_code := (BitVec.ofInt _ (0 : Int)), data_header_valid := false, data_payload := (BitVec.ofInt _ (0 : Int)), data_tag := (BitVec.ofInt _ (0 : Int)), data_tail := (BitVec.ofInt _ (0 : Int)), en := true }
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
