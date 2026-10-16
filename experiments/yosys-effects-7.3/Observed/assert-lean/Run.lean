import Effects.Observed
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
open Effects.Observed
def decodeInputs (j : Lean.Json) : Except String Inputs := do
  let v0 ← j.getObjValAs? Int "reset"
  let v1 ← j.getObjValAs? Int "clock"
  let v2 ← j.getObjValAs? Int "en"
  let v3 ← j.getObjValAs? Int "d"
  let v4 ← j.getObjValAs? Int "expected"
  let v5 ← j.getObjValAs? Int "c2l_undefined_0"
  return { i0 := BitVec.ofInt 1 v0, i1 := BitVec.ofInt 1 v1, i2 := BitVec.ofInt 1 v2, i3 := BitVec.ofInt 4 v3, i4 := BitVec.ofInt 4 v4, i5 := BitVec.ofInt 4 v5 }
def decodeState (j : Lean.Json) : Except String State := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$16"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$28"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$42"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$60"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$58"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$56"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$8"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$22"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$34"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$48"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$14"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$20"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$40"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$54"
  return { s0 := BitVec.ofInt 1 v0, s1 := BitVec.ofInt 1 v1, s2 := BitVec.ofInt 1 v2, s3 := BitVec.ofInt 1 v3, s4 := BitVec.ofInt 1 v4, s5 := BitVec.ofInt 4 v5, s6 := BitVec.ofInt 4 v6, s7 := BitVec.ofInt 1 v7, s8 := BitVec.ofInt 1 v8, s9 := BitVec.ofInt 1 v9, s10 := BitVec.ofInt 1 v10, s11 := BitVec.ofInt 1 v11, s12 := BitVec.ofInt 8 v12, s13 := BitVec.ofInt 1 v13, s14 := BitVec.ofInt 1 v14 }
def encodeOutputs (o : Outputs) : Lean.Json := Lean.Json.mkObj [("q", Lean.toJson o.o0.toNat)]
def checkEffects (r : Evaluation) : IO Unit := do
  if r.outputs.o5 != 0 && r.outputs.o6 == 0 then
    throw (IO.userError "assert failed at work/design.v:6.5-6.27")
  if r.outputs.o7 != 0 && r.outputs.o8 == 0 then
    throw (IO.userError "assume failed at work/design.v:7.5-7.20")
  pure ()

def encodeEffects (o : Outputs) : Lean.Json := Id.run do
  let mut events : Array Lean.Json := #[]
  if o.o1 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (0 : Nat)), ("kind", Lean.toJson "cover"), ("condition", Lean.toJson o.o2.toNat)])
  if o.o3 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (1 : Nat)), ("kind", Lean.toJson "print"), ("arguments", Lean.toJson o.o4.toNat)])
  if o.o5 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (2 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.o6.toNat)])
  if o.o7 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (3 : Nat)), ("kind", Lean.toJson "assume"), ("condition", Lean.toJson o.o8.toNat)])
  return Lean.Json.arr events
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
    checkEffects low
    let high := evaluate ({ inputs with i1 := 1 }) low.nextState
    if !high.outputDefined || !high.transitionDefined then throw (IO.userError "Undefined high-clock operation")
    checkEffects high
    let pre := low.outputs
    let post := high.outputs
    state := high.nextState
    IO.println ((Lean.Json.mkObj [("cycle", Lean.toJson cycle),
      ("pre", encodeOutputs pre), ("post", encodeOutputs post), ("effects_pre", encodeEffects pre), ("effects_post", encodeEffects post)]).compress)
    cycle := cycle + 1
