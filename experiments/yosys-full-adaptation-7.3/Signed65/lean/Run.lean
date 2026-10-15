import Yosys.Signed65
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
open Yosys.Signed65
def decodeInputs (j : Lean.Json) : Except String Inputs := do
  let v0 ← j.getObjValAs? Int "reset"
  let v1 ← j.getObjValAs? Int "clock"
  let v2 ← j.getObjValAs? Int "c2l_port_0"
  let v3 ← j.getObjValAs? Int "c2l_port_1"
  return { i0 := BitVec.ofInt 1 v0, i1 := BitVec.ofInt 1 v1, i2 := BitVec.ofInt 65 v2, i3 := BitVec.ofInt 65 v3 }
def decodeState (j : Lean.Json) : Except String State := do
  return ⟨⟩
def encodeOutputs (o : Outputs) : Lean.Json := Lean.Json.mkObj [("c2l_port_2", Lean.toJson o.o0.toNat), ("c2l_port_3", Lean.toJson o.o1.toNat), ("c2l_port_4", Lean.toJson o.o2.toNat), ("c2l_port_5", Lean.toJson o.o3.toNat), ("c2l_port_6", Lean.toJson o.o4.toNat), ("c2l_port_7", Lean.toJson o.o5.toNat)]

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
