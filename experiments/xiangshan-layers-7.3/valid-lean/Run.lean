import Layers.Check
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
open Layers.Check
def decodeInputs (j : Lean.Json) : Except String Inputs := do
  let v0 ← j.getObjValAs? Int "clock"
  let v1 ← j.getObjValAs? Int "en"
  let v2 ← j.getObjValAs? Int "ok"
  return { i0 := BitVec.ofInt 1 v0, i1 := BitVec.ofInt 1 v1, i2 := BitVec.ofInt 1 v2 }
def decodeState (j : Lean.Json) : Except String State := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$8"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$14"
  return { s0 := BitVec.ofInt 1 v0, s1 := BitVec.ofInt 1 v1, s2 := BitVec.ofInt 1 v2 }
def encodeOutputs (o : Outputs) : Lean.Json := Lean.Json.mkObj [("q", Lean.toJson o.o0.toNat)]
def checkEffects (r : Evaluation) : IO Unit := do
  if r.outputs.o1 != 0 && r.outputs.o2 == 0 then
    throw (IO.userError "assert failed at work/project/Layer.sv:11.7-11.77")
  pure ()

def encodeEffects (o : Outputs) : Lean.Json := Id.run do
  let mut events : Array Lean.Json := #[]
  if o.o1 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (0 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.o2.toNat)])
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
