import Chisel2Lean.Functional
open Chisel2Lean.Functional
def main (args : List String) : IO Unit := do
  let [circuitPath, requestPath] := args | throw (IO.userError "Supply circuit and request paths")
  let checked ← unwrap (decode (← IO.FS.readBinFile circuitPath))
  let circuit := checked.data
  let input ← IO.FS.Handle.mk requestPath .read
  let header ← unwrap (Lean.Json.parse (← input.getLine))
  let mut state ← unwrap (decodeFrame circuit.states (← unwrap (header.getObjVal? "initial")))
  if !(← unwrap (initialValid circuit.states state)) then throw (IO.userError "Initial state violates known bits")
  let eval (inputs state : Array Value) : IO Evaluation := do
    let result ← unwrap (evaluate circuit inputs state)
    if result.maxLeftShift > 1000000 then
      IO.eprintln s!"C2L_LARGE_SHIFT amount={result.maxLeftShift} smt_line={result.maxLeftShiftLine}"
    if !result.outputDefined || !result.transitionDefined then throw (IO.userError "Undefined operation")
    if !result.checksValid then throw (IO.userError "Assertion or assumption failed")
    return result
  let mut cycle : Nat := 0
  repeat
    let line ← input.getLine
    if line.isEmpty then break
    let row ← unwrap (Lean.Json.parse line)
    let inputs ← unwrap (decodeFrame circuit.inputs (← unwrap (row.getObjVal? "inputs")))
    let (pre, post, nextState) ← match circuit.clock with
      | none => do
        let result ← eval inputs state
        pure (result.outputs, result.outputs, result.nextState)
      | some index => do
        if h : index < inputs.size then
          let low ← eval (inputs.set index (.bits 1 0)) state
          let high ← eval (inputs.set index (.bits 1 1)) low.nextState
          pure (low.outputs, high.outputs, high.nextState)
        else throw (IO.userError "Clock index outside input frame")
    let mut fields := [("cycle", Lean.toJson cycle), ("pre", ← unwrap (encodeOutputs circuit pre)),
                       ("post", ← unwrap (encodeOutputs circuit post))]
    if !circuit.effects.isEmpty then
      fields := fields ++ [("effects_pre", ← unwrap (encodeEffects circuit pre)),
                           ("effects_post", ← unwrap (encodeEffects circuit post))]
    IO.println (Lean.Json.mkObj fields).compress
    state := nextState
    cycle := cycle + 1
