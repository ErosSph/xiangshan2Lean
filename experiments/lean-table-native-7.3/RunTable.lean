import Chisel2Lean.Functional
def main (args : List String) : IO Unit := do
  let [circuitPath, requestPath] := args | throw (IO.userError "Supply circuit and request paths")
  let circuit ← Chisel2Lean.Functional.unwrap (Chisel2Lean.Functional.decode (← IO.FS.readBinFile circuitPath))
  let request ← Chisel2Lean.Functional.unwrap (Lean.Json.parse (← IO.FS.readFile requestPath))
  Chisel2Lean.Functional.runRequest circuit request
