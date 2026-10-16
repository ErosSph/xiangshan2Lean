import Modern.XSPrefetch
set_option linter.unusedVariables false
set_option maxRecDepth 10000
set_option maxHeartbeats 0
open Modern.XSPrefetch
def p : Params := ⟨⟩
def decodeInputs (j : Lean.Json) : Except String (Inputs p) := do
  let v0 ← j.getObjValAs? Int "reset"
  let v1 ← j.getObjValAs? Int "c2l_port_0"
  let v2 ← j.getObjValAs? Int "c2l_port_1"
  let v3 ← j.getObjValAs? Int "c2l_port_2"
  let v4 ← j.getObjValAs? Int "c2l_port_3"
  let v5 ← j.getObjValAs? Int "c2l_port_4"
  let v6 ← j.getObjValAs? Int "c2l_port_5"
  let v7 ← j.getObjValAs? Int "c2l_port_6"
  let v8 ← j.getObjValAs? Int "c2l_port_7"
  let v9 ← j.getObjValAs? Int "c2l_port_8"
  let v10 ← j.getObjValAs? Int "c2l_port_9"
  let v11 ← j.getObjValAs? Int "c2l_port_12"
  let v12 ← j.getObjValAs? Int "c2l_port_14"
  let v13 ← j.getObjValAs? Int "c2l_port_15"
  let v14 ← j.getObjValAs? Int "c2l_port_16"
  let v15 ← j.getObjValAs? Int "c2l_port_17"
  let v16 ← j.getObjValAs? Int "c2l_port_18"
  return { reset := BitVec.ofInt _ v0, c2l_port_0 := BitVec.ofInt _ v1, c2l_port_1 := BitVec.ofInt _ v2, c2l_port_2 := BitVec.ofInt _ v3, c2l_port_3 := BitVec.ofInt _ v4, c2l_port_4 := BitVec.ofInt _ v5, c2l_port_5 := BitVec.ofInt _ v6, c2l_port_6 := BitVec.ofInt _ v7, c2l_port_7 := BitVec.ofInt _ v8, c2l_port_8 := BitVec.ofInt _ v9, c2l_port_9 := BitVec.ofInt _ v10, c2l_port_12 := BitVec.ofInt _ v11, c2l_port_14 := BitVec.ofInt _ v12, c2l_port_15 := BitVec.ofInt _ v13, c2l_port_16 := BitVec.ofInt _ v14, c2l_port_17 := BitVec.ofInt _ v15, c2l_port_18 := BitVec.ofInt _ v16 }

def decodeState (j : Lean.Json) : Except String (State p) := do
  let v0 ← j.getObjValAs? Int "c2lInstance0.c2lSSA39"
  let v1 ← j.getObjValAs? Int "c2lInstance0.c2lSSA40"
  let v2 ← j.getObjValAs? Int "c2lInstance0.c2lSSA41"
  let v3 ← j.getObjValAs? Int "c2lInstance0.c2lSSA42"
  let v4 ← j.getObjValAs? Int "c2lInstance0.c2lSSA48"
  let v5 ← j.getObjValAs? Int "c2lInstance0.c2lSSA49"
  let v6 ← j.getObjValAs? Int "c2lInstance0.c2lSSA50"
  let v7 ← j.getObjValAs? Int "c2lInstance0.c2lSSA51"
  let v8 ← j.getObjValAs? Int "c2lInstance0.c2lSSA53"
  let v9 ← j.getObjValAs? Int "c2lInstance0.c2lSSA66"
  let v10 ← j.getObjValAs? Int "c2lInstance0.c2lSSA114"
  return { c2lInstance0_c2lSSA39 := BitVec.ofInt _ v0, c2lInstance0_c2lSSA40 := BitVec.ofInt _ v1, c2lInstance0_c2lSSA41 := BitVec.ofInt _ v2, c2lInstance0_c2lSSA42 := BitVec.ofInt _ v3, c2lInstance0_c2lSSA48 := BitVec.ofInt _ v4, c2lInstance0_c2lSSA49 := BitVec.ofInt _ v5, c2lInstance0_c2lSSA50 := BitVec.ofInt _ v6, c2lInstance0_c2lSSA51 := BitVec.ofInt _ v7, c2lInstance0_c2lSSA53 := BitVec.ofInt _ v8, c2lInstance0_c2lSSA66 := BitVec.ofInt _ v9, c2lInstance0_c2lSSA114 := BitVec.ofInt _ v10 }

def outputJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("c2l_port_10", Lean.toJson (o.c2l_port_10).toNat), ("c2l_port_11", Lean.toJson (o.c2l_port_11).toNat), ("c2l_port_13", Lean.toJson (o.c2l_port_13).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("c2lInstance0.c2lSSA39", Lean.toJson (s.c2lInstance0_c2lSSA39).toNat), ("c2lInstance0.c2lSSA40", Lean.toJson (s.c2lInstance0_c2lSSA40).toNat), ("c2lInstance0.c2lSSA41", Lean.toJson (s.c2lInstance0_c2lSSA41).toNat), ("c2lInstance0.c2lSSA42", Lean.toJson (s.c2lInstance0_c2lSSA42).toNat), ("c2lInstance0.c2lSSA48", Lean.toJson (s.c2lInstance0_c2lSSA48).toNat), ("c2lInstance0.c2lSSA49", Lean.toJson (s.c2lInstance0_c2lSSA49).toNat), ("c2lInstance0.c2lSSA50", Lean.toJson (s.c2lInstance0_c2lSSA50).toNat), ("c2lInstance0.c2lSSA51", Lean.toJson (s.c2lInstance0_c2lSSA51).toNat), ("c2lInstance0.c2lSSA53", Lean.toJson (s.c2lInstance0_c2lSSA53).toNat), ("c2lInstance0.c2lSSA66", Lean.toJson (s.c2lInstance0_c2lSSA66).toNat), ("c2lInstance0.c2lSSA114", Lean.toJson (s.c2lInstance0_c2lSSA114).toNat)]
def unwrap (r : Except String α) : IO α :=
  match r with
  | .ok x => pure x
  | .error e => throw (IO.userError e)
def main (args : List String) : IO Unit := do
  let path ← match args with
    | [path] => pure path
    | _ => throw (IO.userError "Supply one request JSON path")
  let j ← unwrap (Lean.Json.parse (← IO.FS.readFile path))
  let rows ← unwrap (j.getObjValAs? (Array Lean.Json) "trace")
  let initial ← unwrap (j.getObjVal? "initial")
  let mut state ← unwrap (decodeState initial)
  let mut cycle : Nat := 0
  for row in rows do
    let values ← unwrap (row.getObjVal? "inputs")
    let inputs ← unwrap (decodeInputs values)
    if !outputDefined p inputs state && !(cycle == 0 && false) then
      throw (IO.userError "Undefined output operation")
    if !transitionDefined p inputs state then
      throw (IO.userError "Undefined transition operation")
    let pre := output p inputs state
    let next := step p inputs state
    if !outputDefined p inputs next then
      throw (IO.userError "Undefined output operation after edge")
    IO.println ((Lean.Json.mkObj [("cycle", Lean.toJson cycle),
      ("pre", outputJson pre), ("post", outputJson (output p inputs next)),
      ("state", stateJson next)]).compress)
    state := next
    cycle := cycle + 1
