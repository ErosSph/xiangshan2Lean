import Contract.MaskedMemory
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
open Contract.MaskedMemory
def decodeInputs (j : Lean.Json) : Except String Inputs := do
  let v0 ← j.getObjValAs? Int "clock"
  let v1 ← j.getObjValAs? Int "addr0"
  let v2 ← j.getObjValAs? Int "addr1"
  let v3 ← j.getObjValAs? Int "readAddr"
  let v4 ← j.getObjValAs? Int "en0"
  let v5 ← j.getObjValAs? Int "en1"
  let v6 ← j.getObjValAs? Int "mask0"
  let v7 ← j.getObjValAs? Int "mask1"
  let v8 ← j.getObjValAs? Int "data0"
  let v9 ← j.getObjValAs? Int "data1"
  let v10 ← j.getObjValAs? Int "c2l_undefined_0"
  let v11 ← j.getObjValAs? Int "c2l_undefined_1"
  let v12 ← j.getObjValAs? Int "c2l_undefined_2"
  let v13 ← j.getObjValAs? Int "c2l_undefined_3"
  return { i0 := BitVec.ofInt 1 v0, i1 := BitVec.ofInt 2 v1, i2 := BitVec.ofInt 2 v2, i3 := BitVec.ofInt 2 v3, i4 := BitVec.ofInt 1 v4, i5 := BitVec.ofInt 1 v5, i6 := BitVec.ofInt 2 v6, i7 := BitVec.ofInt 2 v7, i8 := BitVec.ofInt 8 v8, i9 := BitVec.ofInt 8 v9, i10 := BitVec.ofInt 4 v10, i11 := BitVec.ofInt 4 v11, i12 := BitVec.ofInt 4 v12, i13 := BitVec.ofInt 4 v13 }
def decodeState (j : Lean.Json) : Except String State := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:192:execute$38"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:192:execute$26"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:192:execute$14"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:192:execute$2"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:207:execute$42"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:207:execute$30"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:207:execute$18"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:207:execute$6"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:213:execute$46"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:210:execute$44"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:213:execute$34"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:210:execute$32"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:213:execute$22"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:210:execute$20"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:213:execute$10"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:210:execute$8"
  let v16 ← j.getObjValAs? (Array Int) "mem"
  if v16.size != 4 then throw "Memory initial state has wrong size"
  return { s0 := BitVec.ofInt 1 v0, s1 := BitVec.ofInt 1 v1, s2 := BitVec.ofInt 1 v2, s3 := BitVec.ofInt 1 v3, s4 := BitVec.ofInt 8 v4, s5 := BitVec.ofInt 8 v5, s6 := BitVec.ofInt 8 v6, s7 := BitVec.ofInt 8 v7, s8 := BitVec.ofInt 8 v8, s9 := BitVec.ofInt 2 v9, s10 := BitVec.ofInt 8 v10, s11 := BitVec.ofInt 2 v11, s12 := BitVec.ofInt 8 v12, s13 := BitVec.ofInt 2 v13, s14 := BitVec.ofInt 8 v14, s15 := BitVec.ofInt 2 v15, s16 := (fun address => BitVec.ofInt 8 (v16[address.toNat]!)) }
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
    let low := evaluate ({ inputs with i0 := 0 }) state
    if !low.outputDefined || !low.transitionDefined then throw (IO.userError "Undefined low-clock operation")
    let high := evaluate ({ inputs with i0 := 1 }) low.nextState
    if !high.outputDefined || !high.transitionDefined then throw (IO.userError "Undefined high-clock operation")
    let pre := low.outputs
    let post := high.outputs
    state := high.nextState
    IO.println ((Lean.Json.mkObj [("cycle", Lean.toJson cycle),
      ("pre", encodeOutputs pre), ("post", encodeOutputs post)]).compress)
    cycle := cycle + 1
