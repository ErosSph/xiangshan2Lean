import Native.Clocks
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
open Native.Clocks
def decodeInputs (j : Lean.Json) : Except String Inputs := do
  let v0 ← j.getObjValAs? Int "reset"
  let v1 ← j.getObjValAs? Int "c1"
  let v2 ← j.getObjValAs? Int "c2"
  let v3 ← j.getObjValAs? Int "latch_en"
  let v4 ← j.getObjValAs? Int "gate_en"
  let v5 ← j.getObjValAs? Int "d"
  let v6 ← j.getObjValAs? Int "c2l_undefined_0_Y"
  let v7 ← j.getObjValAs? Int "c2l_undefined_1_Y"
  return { i0 := BitVec.ofInt 1 v0, i1 := BitVec.ofInt 1 v1, i2 := BitVec.ofInt 1 v2, i3 := BitVec.ofInt 1 v3, i4 := BitVec.ofInt 1 v4, i5 := BitVec.ofInt 8 v5, i6 := BitVec.ofInt 1 v6, i7 := BitVec.ofInt 8 v7 }
def decodeStateGroup0 (j : Lean.Json) : Except String StateGroup0 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:80:sample_control$26"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$28"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$24"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$118"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$116"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$114"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:80:sample_control$96"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$156"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$136"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:80:sample_control$36"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:80:sample_control$46"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:80:sample_control$56"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:80:sample_control$66"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:80:sample_control$76"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:80:sample_control$86"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$98"
  return { s0 := BitVec.ofInt 1 v0, s1 := BitVec.ofInt 1 v1, s2 := BitVec.ofInt 1 v2, s3 := BitVec.ofInt 1 v3, s4 := BitVec.ofInt 8 v4, s5 := BitVec.ofInt 8 v5, s6 := BitVec.ofInt 1 v6, s7 := BitVec.ofInt 1 v7, s8 := BitVec.ofInt 1 v8, s9 := BitVec.ofInt 1 v9, s10 := BitVec.ofInt 1 v10, s11 := BitVec.ofInt 1 v11, s12 := BitVec.ofInt 1 v12, s13 := BitVec.ofInt 1 v13, s14 := BitVec.ofInt 1 v14, s15 := BitVec.ofInt 1 v15 }

def decodeStateGroup1 (j : Lean.Json) : Except String StateGroup1 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$94"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:80:sample_control$106"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$18"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$146"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:80:sample_control$124"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$38"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$34"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$48"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$44"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$58"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$54"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$68"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$64"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$78"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$74"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$88"
  return { s16 := BitVec.ofInt 1 v0, s17 := BitVec.ofInt 1 v1, s18 := BitVec.ofInt 1 v2, s19 := BitVec.ofInt 1 v3, s20 := BitVec.ofInt 1 v4, s21 := BitVec.ofInt 1 v5, s22 := BitVec.ofInt 1 v6, s23 := BitVec.ofInt 1 v7, s24 := BitVec.ofInt 1 v8, s25 := BitVec.ofInt 1 v9, s26 := BitVec.ofInt 1 v10, s27 := BitVec.ofInt 1 v11, s28 := BitVec.ofInt 1 v12, s29 := BitVec.ofInt 1 v13, s30 := BitVec.ofInt 1 v14, s31 := BitVec.ofInt 1 v15 }

def decodeStateGroup2 (j : Lean.Json) : Except String StateGroup2 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$84"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$108"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$104"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$126"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$154"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$152"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$134"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$132"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$16"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$14"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$144"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$142"
  return { s32 := BitVec.ofInt 1 v0, s33 := BitVec.ofInt 1 v1, s34 := BitVec.ofInt 1 v2, s35 := BitVec.ofInt 8 v3, s36 := BitVec.ofInt 8 v4, s37 := BitVec.ofInt 8 v5, s38 := BitVec.ofInt 8 v6, s39 := BitVec.ofInt 8 v7, s40 := BitVec.ofInt 8 v8, s41 := BitVec.ofInt 8 v9, s42 := BitVec.ofInt 8 v10, s43 := BitVec.ofInt 8 v11 }

def decodeState (j : Lean.Json) : Except String State := do

  let g0 ← decodeStateGroup0 j

  let g1 ← decodeStateGroup1 j

  let g2 ← decodeStateGroup2 j

  return { g0 := g0, g1 := g1, g2 := g2 }
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
