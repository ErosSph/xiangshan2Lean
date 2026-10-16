import Exposure.Observed
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
open Exposure.Observed
def decodeInputs (j : Lean.Json) : Except String Inputs := do
  let v0 ← j.getObjValAs? Int "reset"
  let v1 ← j.getObjValAs? Int "clock"
  let v2 ← j.getObjValAs? Int "en"
  let v3 ← j.getObjValAs? Int "d"
  let v4 ← j.getObjValAs? Int "c2l_undefined_0_Y"
  return { i0 := BitVec.ofInt 1 v0, i1 := BitVec.ofInt 1 v1, i2 := BitVec.ofInt 1 v2, i3 := BitVec.ofInt 4 v3, i4 := BitVec.ofInt 4 v4 }
def decodeStateGroup0 (j : Lean.Json) : Except String StateGroup0 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$21"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$33"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$45"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$59"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$73"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$91"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$89"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$87"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$27"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$39"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$51"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$65"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$79"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$25"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$57"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$71"
  return { s0 := BitVec.ofInt 1 v0, s1 := BitVec.ofInt 1 v1, s2 := BitVec.ofInt 1 v2, s3 := BitVec.ofInt 1 v3, s4 := BitVec.ofInt 1 v4, s5 := BitVec.ofInt 1 v5, s6 := BitVec.ofInt 4 v6, s7 := BitVec.ofInt 4 v7, s8 := BitVec.ofInt 1 v8, s9 := BitVec.ofInt 1 v9, s10 := BitVec.ofInt 1 v10, s11 := BitVec.ofInt 1 v11, s12 := BitVec.ofInt 1 v12, s13 := BitVec.ofInt 4 v13, s14 := BitVec.ofInt 1 v14, s15 := BitVec.ofInt 1 v15 }

def decodeStateGroup1 (j : Lean.Json) : Except String StateGroup1 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$85"
  return { s16 := BitVec.ofInt 1 v0 }

def decodeState (j : Lean.Json) : Except String State := do

  let g0 ← decodeStateGroup0 j

  let g1 ← decodeStateGroup1 j

  return { g0 := g0, g1 := g1 }
def encodeOutputs (o : Outputs) : Lean.Json := Lean.Json.mkObj [("q", Lean.toJson o.o0.toNat)]
def checkEffects (r : Evaluation) : IO Unit := do
  if r.outputs.o7 != 0 && r.outputs.o6 == 0 then
    throw (IO.userError "assume failed at design.v:6.3-6.16")
  if r.outputs.o9 != 0 && r.outputs.o8 == 0 then
    throw (IO.userError "assert failed at design.v:5.3-5.17")
  pure ()

def encodeEffects (o : Outputs) : Lean.Json := Id.run do
  let mut events : Array Lean.Json := #[]
  if o.o2 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (0 : Nat)), ("kind", Lean.toJson "print"), ("file_descriptor", Lean.toJson (2147483649 : Nat)), ("stream", Lean.toJson "stdout"), ("arguments", Lean.toJson o.o1.toNat)])
  if o.o3 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (1 : Nat)), ("kind", Lean.toJson "print")])
  if o.o5 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (2 : Nat)), ("kind", Lean.toJson "cover"), ("condition", Lean.toJson o.o4.toNat)])
  if o.o7 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (3 : Nat)), ("kind", Lean.toJson "assume"), ("condition", Lean.toJson o.o6.toNat)])
  if o.o9 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (4 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.o8.toNat)])
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
