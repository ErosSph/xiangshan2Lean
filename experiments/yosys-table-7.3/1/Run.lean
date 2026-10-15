import Table.Case1
def main (args : List String) : IO Unit := do
  let [path] := args | throw (IO.userError "Supply request")
  let request ← Chisel2Lean.Functional.unwrap (Lean.Json.parse (← IO.FS.readFile path))
  let circuit ← Chisel2Lean.Functional.unwrap Table.Case1.circuit
  Chisel2Lean.Functional.runRequest circuit request
