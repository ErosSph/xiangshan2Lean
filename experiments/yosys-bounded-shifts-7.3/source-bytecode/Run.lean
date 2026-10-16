import Shift.Source
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
open Shift.Source
def decodeInputs (j : Lean.Json) : Except String Inputs := do
  let v0 ← j.getObjValAs? Int "value"
  let v1 ← j.getObjValAs? Int "amount"
  return { i0 := BitVec.ofInt 256 v0, i1 := BitVec.ofInt 256 v1 }
def decodeState (j : Lean.Json) : Except String State := do
  return ⟨⟩
def encodeOutputs (o : Outputs) : Lean.Json := Lean.Json.mkObj [("w1_left", Lean.toJson o.o0.toNat), ("w1_right", Lean.toJson o.o1.toNat), ("w1_signed", Lean.toJson o.o2.toNat), ("w8_left", Lean.toJson o.o3.toNat), ("w8_right", Lean.toJson o.o4.toNat), ("w8_signed", Lean.toJson o.o5.toNat), ("w65_left", Lean.toJson o.o6.toNat), ("w65_right", Lean.toJson o.o7.toNat), ("w65_signed", Lean.toJson o.o8.toNat), ("w127_left", Lean.toJson o.o9.toNat), ("w127_right", Lean.toJson o.o10.toNat), ("w127_signed", Lean.toJson o.o11.toNat), ("w256_left", Lean.toJson o.o12.toNat), ("w256_right", Lean.toJson o.o13.toNat), ("w256_signed", Lean.toJson o.o14.toNat)]

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
