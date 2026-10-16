import Chisel2Lean.Functional
namespace Table.Case15
open Chisel2Lean.Functional
abbrev Inputs := Array Value
abbrev State := Array Value
def circuit : Except String CheckedCircuit := decodeHex (include_str "Case15.circuit.hex")
def evaluate (inputs : Inputs) (state : State) : Except String Evaluation := do
  Chisel2Lean.Functional.evaluate (← circuit).data inputs state
def step (inputs : Inputs) (state : State) : Except String (Array Value × State) := do
  let result ← evaluate inputs state
  return (result.outputs, result.nextState)
def initialValid (state : State) : Except String Bool := do
  Chisel2Lean.Functional.initialValid (← circuit).data.states state
#eval do
  let checked ← match circuit with
    | .ok value => pure value
    | .error message => throw (IO.userError message)
  IO.println ("C2L_TABLE_CHECK " ++ (Lean.Json.mkObj [
    ("nodes", Lean.toJson checked.data.nodes.size),
    ("inputs", Lean.toJson checked.data.inputs.size),
    ("states", Lean.toJson checked.data.states.size),
    ("outputs", Lean.toJson checked.data.outputs.size)]).compress)
end Table.Case15
