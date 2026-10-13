import xiangshan.backend.fu.RightShiftModule
set_option linter.unusedVariables false
set_option maxHeartbeats 0
open xiangshan.backend.fu.RightShiftModule

def p : Params := { XLEN := (32 : Int) }
def decodeInputs (j : Lean.Json) : Except String (Inputs p) := do
  let value0 ← j.getObjValAs? Nat "io.revShamt"
  let value1 ← j.getObjValAs? Nat "io.shamt"
  let value2 ← j.getObjValAs? Nat "io.sraSrc"
  let value3 ← j.getObjValAs? Nat "io.srlSrc"
  pure { io_revShamt := BitVec.ofNat _ value0, io_shamt := BitVec.ofNat _ value1, io_sraSrc := BitVec.ofNat _ value2, io_srlSrc := BitVec.ofNat _ value3 }
def checked {α : Type} (value : Except String α) : IO α :=
  match value with
  | .ok x => pure x
  | .error message => throw (IO.userError message)
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("io.revSrl", Lean.toJson (o.io_revSrl).toNat), ("io.sra", Lean.toJson (o.io_sra).toNat), ("io.srl", Lean.toJson (o.io_srl).toNat)]
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let text ← IO.FS.readFile "trace.json"
  let json ← checked (Lean.Json.parse text)
  let entries ← checked json.getArr?
  let mut state : State p := ⟨⟩
  let mut cycle : Nat := 0
  for entry in entries do
    let data ← checked (entry.getObjVal? "inputs")
    let inputs ← checked (decodeInputs data)
    let reset ← checked (entry.getObjValAs? Bool "reset")
    if !outputDefined p inputs state || !transitionDefined p inputs state reset then
      throw (IO.userError "Undefined model operation")
    let pre := output p inputs state
    let next := step p inputs state reset
    if !outputDefined p inputs next then throw (IO.userError "Undefined next output")
    let post := output p inputs next
    IO.println (Lean.Json.mkObj [("cycle", Lean.toJson cycle),
      ("pre", outputsJson pre), ("post", outputsJson post),
      ("state", Lean.Json.mkObj [])]).compress
    state := next
    cycle := cycle + 1
