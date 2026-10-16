import Hierarchy.Nested
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
open Hierarchy.Nested
def decodeInputs (j : Lean.Json) : Except String Inputs := do
  let v0 ← j.getObjValAs? Int "reset"
  let v1 ← j.getObjValAs? Int "clock"
  let v2 ← j.getObjValAs? Int "en"
  let v3 ← j.getObjValAs? Int "d"
  let v4 ← j.getObjValAs? Int "c2l_undefined_0"
  let v5 ← j.getObjValAs? Int "c2l_undefined_1"
  return { i0 := BitVec.ofInt 1 v0, i1 := BitVec.ofInt 1 v1, i2 := BitVec.ofInt 1 v2, i3 := BitVec.ofInt 8 v3, i4 := BitVec.ofInt 8 v4, i5 := BitVec.ofInt 8 v5 }
def decodeState (j : Lean.Json) : Except String State := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$6"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$16"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$14"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$12"
  return { s0 := BitVec.ofInt 1 v0, s1 := BitVec.ofInt 1 v1, s2 := BitVec.ofInt 8 v2, s3 := BitVec.ofInt 8 v3, s4 := BitVec.ofInt 8 v4, s5 := BitVec.ofInt 8 v5 }
def encodeOutputs (o : Outputs) : Lean.Json := Lean.Json.mkObj [("a", Lean.toJson o.o0.toNat), ("b", Lean.toJson o.o1.toNat)]

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
    let low := evaluate ({ inputs with i1 := 0 }) state
    if !low.outputDefined || !low.transitionDefined then throw (IO.userError "Undefined low-clock operation")
    let high := evaluate ({ inputs with i1 := 1 }) low.nextState
    if !high.outputDefined || !high.transitionDefined then throw (IO.userError "Undefined high-clock operation")
    let pre := low.outputs
    let post := high.outputs
    state := high.nextState
    IO.println ((Lean.Json.mkObj [("cycle", Lean.toJson cycle),
      ("pre", encodeOutputs pre), ("post", encodeOutputs post)]).compress)
    cycle := cycle + 1
