import Initialization.Hardware
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
open Initialization.Hardware
def decodeInputs (j : Lean.Json) : Except String Inputs := do
  let v0 ← j.getObjValAs? Int "reset"
  let v1 ← j.getObjValAs? Int "clock"
  let v2 ← j.getObjValAs? Int "d"
  return { i0 := BitVec.ofInt 1 v0, i1 := BitVec.ofInt 1 v1, i2 := BitVec.ofInt 8 v2 }
def decodeState (j : Lean.Json) : Except String State := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$6"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:80:sample_control$12"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$14"
  return { s0 := BitVec.ofInt 1 v0, s1 := BitVec.ofInt 8 v1, s2 := BitVec.ofInt 8 v2, s3 := BitVec.ofInt 1 v3, s4 := BitVec.ofInt 8 v4 }
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
