import Yosys.Handshake65x3
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
open Yosys.Handshake65x3
def decodeInputs (j : Lean.Json) : Except String Inputs := do
  let v0 ← j.getObjValAs? Int "reset"
  let v1 ← j.getObjValAs? Int "clock"
  let v2 ← j.getObjValAs? Int "c2l_port_0"
  let v3 ← j.getObjValAs? Int "c2l_port_2"
  let v4 ← j.getObjValAs? Int "c2l_port_4"
  let v5 ← j.getObjValAs? Int "c2l_undefined_0"
  let v6 ← j.getObjValAs? Int "c2l_undefined_1"
  let v7 ← j.getObjValAs? Int "c2l_undefined_2"
  return { i0 := BitVec.ofInt 1 v0, i1 := BitVec.ofInt 1 v1, i2 := BitVec.ofInt 65 v2, i3 := BitVec.ofInt 1 v3, i4 := BitVec.ofInt 1 v4, i5 := BitVec.ofInt 1 v5, i6 := BitVec.ofInt 1 v6, i7 := BitVec.ofInt 1 v7 }
def decodeState (j : Lean.Json) : Except String State := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$6"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$36"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$26"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$16"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$34"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$32"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$24"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$22"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$14"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$12"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$46"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$56"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$44"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$42"
  let v16 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$54"
  let v17 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$52"
  return { s0 := BitVec.ofInt 1 v0, s1 := BitVec.ofInt 65 v1, s2 := BitVec.ofInt 65 v2, s3 := BitVec.ofInt 1 v3, s4 := BitVec.ofInt 1 v4, s5 := BitVec.ofInt 1 v5, s6 := BitVec.ofInt 1 v6, s7 := BitVec.ofInt 1 v7, s8 := BitVec.ofInt 65 v8, s9 := BitVec.ofInt 65 v9, s10 := BitVec.ofInt 1 v10, s11 := BitVec.ofInt 1 v11, s12 := BitVec.ofInt 1 v12, s13 := BitVec.ofInt 1 v13, s14 := BitVec.ofInt 65 v14, s15 := BitVec.ofInt 65 v15, s16 := BitVec.ofInt 1 v16, s17 := BitVec.ofInt 1 v17 }
def encodeOutputs (o : Outputs) : Lean.Json := Lean.Json.mkObj [("c2l_port_1", Lean.toJson o.o0.toNat), ("c2l_port_3", Lean.toJson o.o1.toNat), ("c2l_port_5", Lean.toJson o.o2.toNat)]
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
