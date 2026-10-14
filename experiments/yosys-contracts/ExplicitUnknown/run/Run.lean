import Contract.ExplicitUnknown
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
open Contract.ExplicitUnknown
def decodeInputs (j : Lean.Json) : Except String Inputs := do
  let v0 ← j.getObjValAs? Int "d"
  let v1 ← j.getObjValAs? Int "c2l_undefined_0"
  return { i0 := BitVec.ofInt 1 v0, i1 := BitVec.ofInt 1 v1 }
def decodeState (j : Lean.Json) : Except String State := do
  return ⟨⟩
def encodeOutputs (o : Outputs) : Lean.Json := Lean.Json.mkObj [("q", Lean.toJson o.o0.toNat)]
def unwrap (r : Except String α) : IO α :=
  match r with
  | .ok x => pure x
  | .error e => throw (IO.userError e)
def main (args : List String) : IO Unit := do
  let [path] := args | throw (IO.userError "Supply request path")
  let j ← unwrap (Lean.Json.parse (← IO.FS.readFile path))
  let rows ← unwrap (j.getObjValAs? (Array Lean.Json) "trace")
  let mut state ← unwrap (decodeState (← unwrap (j.getObjVal? "initial")))
  if !initialValid state then throw (IO.userError "Initial state violates known-bit constraints")
  let mut cycle : Nat := 0
  for row in rows do
    let inputs ← unwrap (decodeInputs (← unwrap (row.getObjVal? "inputs")))
    let r := evaluate inputs state
    if !r.outputDefined || !r.transitionDefined then throw (IO.userError "Undefined operation")
    let pre := r.outputs
    let post := r.outputs
    state := r.nextState
    IO.println ((Lean.Json.mkObj [("cycle", Lean.toJson cycle),
      ("pre", encodeOutputs pre), ("post", encodeOutputs post)]).compress)
    cycle := cycle + 1
