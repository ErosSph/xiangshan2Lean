import Clocks.All
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
open Clocks.All
def decodeInputs (j : Lean.Json) : Except String Inputs := do
  let v0 ← j.getObjValAs? Int "reset"
  let v1 ← j.getObjValAs? Int "c1"
  let v2 ← j.getObjValAs? Int "c2"
  let v3 ← j.getObjValAs? Int "latch_en"
  let v4 ← j.getObjValAs? Int "gate_en"
  let v5 ← j.getObjValAs? Int "d"
  let v6 ← j.getObjValAs? Int "c2l_undefined_0"
  let v7 ← j.getObjValAs? Int "c2l_undefined_1"
  return { i0 := BitVec.ofInt 1 v0, i1 := BitVec.ofInt 1 v1, i2 := BitVec.ofInt 1 v2, i3 := BitVec.ofInt 1 v3, i4 := BitVec.ofInt 1 v4, i5 := BitVec.ofInt 8 v5, i6 := BitVec.ofInt 8 v6, i7 := BitVec.ofInt 1 v7 }
def decodeState (j : Lean.Json) : Except String State := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:80:sample_control$64"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$66"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$62"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$96"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$94"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$92"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$144"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$134"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:80:sample_control$54"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:80:sample_control$44"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:80:sample_control$34"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:80:sample_control$24"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:80:sample_control$14"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:80:sample_control$4"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:80:sample_control$84"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:80:sample_control$74"
  let v16 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$124"
  let v17 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$114"
  let v18 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:80:sample_control$102"
  let v19 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$56"
  let v20 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$52"
  let v21 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$46"
  let v22 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$42"
  let v23 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$36"
  let v24 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$32"
  let v25 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$26"
  let v26 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$22"
  let v27 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$16"
  let v28 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$12"
  let v29 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$6"
  let v30 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2"
  let v31 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$86"
  let v32 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$82"
  let v33 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$76"
  let v34 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$72"
  let v35 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$104"
  let v36 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$142"
  let v37 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$140"
  let v38 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$132"
  let v39 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$130"
  let v40 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$122"
  let v41 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$120"
  let v42 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$112"
  let v43 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$110"
  return { s0 := BitVec.ofInt 1 v0, s1 := BitVec.ofInt 1 v1, s2 := BitVec.ofInt 1 v2, s3 := BitVec.ofInt 1 v3, s4 := BitVec.ofInt 8 v4, s5 := BitVec.ofInt 8 v5, s6 := BitVec.ofInt 1 v6, s7 := BitVec.ofInt 1 v7, s8 := BitVec.ofInt 1 v8, s9 := BitVec.ofInt 1 v9, s10 := BitVec.ofInt 1 v10, s11 := BitVec.ofInt 1 v11, s12 := BitVec.ofInt 1 v12, s13 := BitVec.ofInt 1 v13, s14 := BitVec.ofInt 1 v14, s15 := BitVec.ofInt 1 v15, s16 := BitVec.ofInt 1 v16, s17 := BitVec.ofInt 1 v17, s18 := BitVec.ofInt 1 v18, s19 := BitVec.ofInt 1 v19, s20 := BitVec.ofInt 1 v20, s21 := BitVec.ofInt 1 v21, s22 := BitVec.ofInt 1 v22, s23 := BitVec.ofInt 1 v23, s24 := BitVec.ofInt 1 v24, s25 := BitVec.ofInt 1 v25, s26 := BitVec.ofInt 1 v26, s27 := BitVec.ofInt 1 v27, s28 := BitVec.ofInt 1 v28, s29 := BitVec.ofInt 1 v29, s30 := BitVec.ofInt 1 v30, s31 := BitVec.ofInt 1 v31, s32 := BitVec.ofInt 1 v32, s33 := BitVec.ofInt 1 v33, s34 := BitVec.ofInt 1 v34, s35 := BitVec.ofInt 8 v35, s36 := BitVec.ofInt 8 v36, s37 := BitVec.ofInt 8 v37, s38 := BitVec.ofInt 8 v38, s39 := BitVec.ofInt 8 v39, s40 := BitVec.ofInt 8 v40, s41 := BitVec.ofInt 8 v41, s42 := BitVec.ofInt 8 v42, s43 := BitVec.ofInt 8 v43 }
def encodeOutputs (o : Outputs) : Lean.Json := Lean.Json.mkObj [("a", Lean.toJson o.o0.toNat), ("p", Lean.toJson o.o1.toNat), ("n", Lean.toJson o.o2.toNat), ("l", Lean.toJson o.o3.toNat), ("g", Lean.toJson o.o4.toNat), ("crossed", Lean.toJson o.o5.toNat)]

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
