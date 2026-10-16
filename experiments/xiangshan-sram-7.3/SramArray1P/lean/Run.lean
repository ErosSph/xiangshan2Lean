import SRAM.SramArray1P
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
open SRAM.SramArray1P
def decodeInputs (j : Lean.Json) : Except String Inputs := do
  let v0 ← j.getObjValAs? Int "reset"
  let v1 ← j.getObjValAs? Int "clock"
  let v2 ← j.getObjValAs? Int "c2l_port_0"
  let v3 ← j.getObjValAs? Int "c2l_port_1"
  let v4 ← j.getObjValAs? Int "c2l_port_2"
  let v5 ← j.getObjValAs? Int "c2l_port_3"
  let v6 ← j.getObjValAs? Int "c2l_port_4"
  let v7 ← j.getObjValAs? Int "c2l_port_5"
  let v8 ← j.getObjValAs? Int "c2l_port_6"
  let v9 ← j.getObjValAs? Int "c2l_port_7"
  let v10 ← j.getObjValAs? Int "c2l_undefined_0"
  let v11 ← j.getObjValAs? Int "c2l_undefined_1"
  let v12 ← j.getObjValAs? Int "c2l_undefined_2"
  return { i0 := BitVec.ofInt 1 v0, i1 := BitVec.ofInt 1 v1, i2 := BitVec.ofInt 1 v2, i3 := BitVec.ofInt 1 v3, i4 := BitVec.ofInt 1 v4, i5 := BitVec.ofInt 1 v5, i6 := BitVec.ofInt 3 v6, i7 := BitVec.ofInt 3 v7, i8 := BitVec.ofInt 16 v8, i9 := BitVec.ofInt 2 v9, i10 := BitVec.ofInt 8 v10, i11 := BitVec.ofInt 8 v11, i12 := BitVec.ofInt 16 v12 }
def decodeState (j : Lean.Json) : Except String State := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$50"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$40"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$30"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$48"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$46"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:192:execute$14"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:192:execute$2"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$38"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$36"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$28"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$26"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:207:execute$18"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:207:execute$6"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:213:execute$22"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:210:execute$20"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:213:execute$10"
  let v16 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:210:execute$8"
  let v17 ← j.getObjValAs? (Array Int) "SramArrayValidation.ram.array_ext.Memory"
  if v17.size != 8 then throw "Memory initial state has wrong size"
  return { s0 := BitVec.ofInt 1 v0, s1 := BitVec.ofInt 1 v1, s2 := BitVec.ofInt 1 v2, s3 := BitVec.ofInt 1 v3, s4 := BitVec.ofInt 1 v4, s5 := BitVec.ofInt 1 v5, s6 := BitVec.ofInt 1 v6, s7 := BitVec.ofInt 1 v7, s8 := BitVec.ofInt 1 v8, s9 := BitVec.ofInt 3 v9, s10 := BitVec.ofInt 3 v10, s11 := BitVec.ofInt 16 v11, s12 := BitVec.ofInt 16 v12, s13 := BitVec.ofInt 16 v13, s14 := BitVec.ofInt 3 v14, s15 := BitVec.ofInt 16 v15, s16 := BitVec.ofInt 3 v16, s17 := (fun address => BitVec.ofInt 16 (v17[address.toNat]!)) }
def encodeOutputs (o : Outputs) : Lean.Json := Lean.Json.mkObj [("c2l_port_8", Lean.toJson o.o0.toNat)]

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
