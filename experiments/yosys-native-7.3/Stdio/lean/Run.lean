import Native.Stdio
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
open Native.Stdio
def decodeInputs (j : Lean.Json) : Except String Inputs := do
  let v0 ← j.getObjValAs? Int "clock"
  let v1 ← j.getObjValAs? Int "en"
  let v2 ← j.getObjValAs? Int "d"
  return { i0 := BitVec.ofInt 1 v0, i1 := BitVec.ofInt 1 v1, i2 := BitVec.ofInt 4 v2 }
def decodeState (j : Lean.Json) : Except String State := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$18"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$30"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$12"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$10"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$8"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$24"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$36"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$22"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$34"
  return { s0 := BitVec.ofInt 1 v0, s1 := BitVec.ofInt 1 v1, s2 := BitVec.ofInt 1 v2, s3 := BitVec.ofInt 4 v3, s4 := BitVec.ofInt 4 v4, s5 := BitVec.ofInt 1 v5, s6 := BitVec.ofInt 1 v6, s7 := BitVec.ofInt 4 v7, s8 := BitVec.ofInt 4 v8 }
def encodeOutputs (o : Outputs) : Lean.Json := Lean.Json.mkObj [("q", Lean.toJson o.o0.toNat)]
def checkEffects (r : Evaluation) : IO Unit := do
  pure ()

def encodeEffects (o : Outputs) : Lean.Json := Id.run do
  let mut events : Array Lean.Json := #[]
  if o.o2 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (0 : Nat)), ("kind", Lean.toJson "print"), ("file_descriptor", Lean.toJson (2147483649 : Nat)), ("stream", Lean.toJson "stdout"), ("arguments", Lean.toJson o.o1.toNat)])
  if o.o4 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (1 : Nat)), ("kind", Lean.toJson "print"), ("file_descriptor", Lean.toJson (2147483650 : Nat)), ("stream", Lean.toJson "stderr"), ("arguments", Lean.toJson o.o3.toNat)])
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
    let low := evaluate ({ inputs with i0 := 0 }) state
    if !low.outputDefined || !low.transitionDefined then throw (IO.userError "Undefined low-clock operation")
    checkEffects low
    let high := evaluate ({ inputs with i0 := 1 }) low.nextState
    if !high.outputDefined || !high.transitionDefined then throw (IO.userError "Undefined high-clock operation")
    checkEffects high
    let pre := low.outputs
    let post := high.outputs
    state := high.nextState
    IO.println ((Lean.Json.mkObj [("cycle", Lean.toJson cycle),
      ("pre", encodeOutputs pre), ("post", encodeOutputs post), ("effects_pre", encodeEffects pre), ("effects_post", encodeEffects post)]).compress)
    cycle := cycle + 1
