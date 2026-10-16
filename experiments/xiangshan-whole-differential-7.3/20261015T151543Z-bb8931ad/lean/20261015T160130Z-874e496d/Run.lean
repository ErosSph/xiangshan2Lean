import XiangShan.Whole
def main (args : List String) : IO Unit := do
  let [path] := args | throw (IO.userError "Supply request path")
  let request ← Chisel2Lean.Functional.unwrap (Lean.Json.parse (← IO.FS.readFile path))
  let circuit ← Chisel2Lean.Functional.unwrap XiangShan.Whole.circuit
  Chisel2Lean.Functional.runRequest circuit request
