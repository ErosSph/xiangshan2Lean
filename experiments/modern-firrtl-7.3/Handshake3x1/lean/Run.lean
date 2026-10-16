import Modern.Handshake3x1
set_option linter.unusedVariables false
set_option maxRecDepth 10000
set_option maxHeartbeats 0
open Modern.Handshake3x1
def p : Params := ⟨⟩
def decodeInputs (j : Lean.Json) : Except String (Inputs p) := do
  let v0 ← j.getObjValAs? Int "reset"
  let v1 ← j.getObjValAs? Int "c2l_port_0"
  let v2 ← j.getObjValAs? Int "c2l_port_2"
  let v3 ← j.getObjValAs? Int "c2l_port_4"
  return { reset := BitVec.ofInt _ v0, c2l_port_0 := BitVec.ofInt _ v1, c2l_port_2 := BitVec.ofInt _ v2, c2l_port_4 := BitVec.ofInt _ v3 }

def decodeState (j : Lean.Json) : Except String (State p) := do
  let v0 ← j.getObjValAs? Int "c2lInstance0.c2lInstance12.c2lSSA27"
  let v1 ← j.getObjValAs? Int "c2lInstance0.c2lInstance12.c2lSSA28"
  return { c2lInstance0_c2lInstance12_c2lSSA27 := BitVec.ofInt _ v0, c2lInstance0_c2lInstance12_c2lSSA28 := BitVec.ofInt _ v1 }

def outputJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("c2l_port_1", Lean.toJson (o.c2l_port_1).toNat), ("c2l_port_3", Lean.toJson (o.c2l_port_3).toNat), ("c2l_port_5", Lean.toJson (o.c2l_port_5).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("c2lInstance0.c2lInstance12.c2lSSA27", Lean.toJson (s.c2lInstance0_c2lInstance12_c2lSSA27).toNat), ("c2lInstance0.c2lInstance12.c2lSSA28", Lean.toJson (s.c2lInstance0_c2lInstance12_c2lSSA28).toNat)]
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
