import Yosys.XSPrefetch
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
open Yosys.XSPrefetch
def decodeInputsGroup0 (j : Lean.Json) : Except String InputsGroup0 := do
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
  let v10 ← j.getObjValAs? Int "c2l_port_8"
  let v11 ← j.getObjValAs? Int "c2l_port_9"
  let v12 ← j.getObjValAs? Int "c2l_port_12"
  let v13 ← j.getObjValAs? Int "c2l_port_14"
  let v14 ← j.getObjValAs? Int "c2l_port_15"
  let v15 ← j.getObjValAs? Int "c2l_port_16"
  return { i0 := BitVec.ofInt 1 v0, i1 := BitVec.ofInt 1 v1, i2 := BitVec.ofInt 2 v2, i3 := BitVec.ofInt 2 v3, i4 := BitVec.ofInt 1 v4, i5 := BitVec.ofInt 1 v5, i6 := BitVec.ofInt 16 v6, i7 := BitVec.ofInt 1 v7, i8 := BitVec.ofInt 4 v8, i9 := BitVec.ofInt 44 v9, i10 := BitVec.ofInt 27 v10, i11 := BitVec.ofInt 1 v11, i12 := BitVec.ofInt 1 v12, i13 := BitVec.ofInt 39 v13, i14 := BitVec.ofInt 16 v14, i15 := BitVec.ofInt 1 v15 }

def decodeInputsGroup1 (j : Lean.Json) : Except String InputsGroup1 := do
  let v0 ← j.getObjValAs? Int "c2l_port_17"
  let v1 ← j.getObjValAs? Int "c2l_port_18"
  let v2 ← j.getObjValAs? Int "c2l_undefined_0"
  return { i16 := BitVec.ofInt 1 v0, i17 := BitVec.ofInt 1 v1, i18 := BitVec.ofInt 2 v2 }

def decodeInputs (j : Lean.Json) : Except String Inputs := do

  let g0 ← decodeInputsGroup0 j

  let g1 ← decodeInputsGroup1 j

  return { g0 := g0, g1 := g1 }
def decodeStateGroup0 (j : Lean.Json) : Except String StateGroup0 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$16"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$14"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$12"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$26"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$36"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$46"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$56"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$66"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$76"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$86"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$96"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$24"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$22"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$34"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$32"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$44"
  return { s0 := BitVec.ofInt 1 v0, s1 := BitVec.ofInt 2 v1, s2 := BitVec.ofInt 2 v2, s3 := BitVec.ofInt 1 v3, s4 := BitVec.ofInt 1 v4, s5 := BitVec.ofInt 1 v5, s6 := BitVec.ofInt 1 v6, s7 := BitVec.ofInt 1 v7, s8 := BitVec.ofInt 1 v8, s9 := BitVec.ofInt 1 v9, s10 := BitVec.ofInt 1 v10, s11 := BitVec.ofInt 27 v11, s12 := BitVec.ofInt 27 v12, s13 := BitVec.ofInt 27 v13, s14 := BitVec.ofInt 27 v14, s15 := BitVec.ofInt 27 v15 }

def decodeStateGroup1 (j : Lean.Json) : Except String StateGroup1 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$42"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$54"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$52"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$64"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$62"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$74"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$72"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$84"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$82"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$94"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$92"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$6"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$106"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$104"
  return { s16 := BitVec.ofInt 27 v0, s17 := BitVec.ofInt 27 v1, s18 := BitVec.ofInt 27 v2, s19 := BitVec.ofInt 1 v3, s20 := BitVec.ofInt 1 v4, s21 := BitVec.ofInt 1 v5, s22 := BitVec.ofInt 1 v6, s23 := BitVec.ofInt 1 v7, s24 := BitVec.ofInt 1 v8, s25 := BitVec.ofInt 1 v9, s26 := BitVec.ofInt 1 v10, s27 := BitVec.ofInt 1 v11, s28 := BitVec.ofInt 1 v12, s29 := BitVec.ofInt 27 v13, s30 := BitVec.ofInt 27 v14, s31 := BitVec.ofInt 1 v15 }

def decodeStateGroup2 (j : Lean.Json) : Except String StateGroup2 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$102"
  return { s32 := BitVec.ofInt 1 v0 }

def decodeState (j : Lean.Json) : Except String State := do

  let g0 ← decodeStateGroup0 j

  let g1 ← decodeStateGroup1 j

  let g2 ← decodeStateGroup2 j

  return { g0 := g0, g1 := g1, g2 := g2 }
def encodeOutputs (o : Outputs) : Lean.Json := Lean.Json.mkObj [("c2l_port_10", Lean.toJson o.o0.toNat), ("c2l_port_11", Lean.toJson o.o1.toNat), ("c2l_port_13", Lean.toJson o.o2.toNat)]

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
    let low := evaluate ({ inputs with g0 := { inputs.g0 with i1 := 0 } }) state
    if !low.outputDefined || !low.transitionDefined then throw (IO.userError "Undefined low-clock operation")
    let high := evaluate ({ inputs with g0 := { inputs.g0 with i1 := 1 } }) low.nextState
    if !high.outputDefined || !high.transitionDefined then throw (IO.userError "Undefined high-clock operation")
    let pre := low.outputs
    let post := high.outputs
    state := high.nextState
    IO.println ((Lean.Json.mkObj [("cycle", Lean.toJson cycle),
      ("pre", encodeOutputs pre), ("post", encodeOutputs post)]).compress)
    cycle := cycle + 1
