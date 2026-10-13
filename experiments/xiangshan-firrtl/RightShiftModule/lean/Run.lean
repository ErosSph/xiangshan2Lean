import FIRRTL.RightShiftModule
set_option linter.unusedVariables false
set_option maxRecDepth 10000
set_option maxHeartbeats 0
open FIRRTL.RightShiftModule
def p : Params := ⟨⟩
def decodeInputs (j : Lean.Json) : Except String (Inputs p) := do
  let v0 ← j.getObjValAs? Int "reset"
  let v1 ← j.getObjValAs? Int "io_shamt"
  let v2 ← j.getObjValAs? Int "io_revShamt"
  let v3 ← j.getObjValAs? Int "io_srlSrc"
  let v4 ← j.getObjValAs? Int "io_sraSrc"
  return { reset := BitVec.ofInt _ v0, io_shamt := BitVec.ofInt _ v1, io_revShamt := BitVec.ofInt _ v2, io_srlSrc := BitVec.ofInt _ v3, io_sraSrc := BitVec.ofInt _ v4 }

def decodeState (j : Lean.Json) : Except String (State p) := do

  return ⟨⟩

def outputJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("io_srl", Lean.toJson (o.io_srl).toNat), ("io_sra", Lean.toJson (o.io_sra).toNat), ("io_revSrl", Lean.toJson (o.io_revSrl).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj []
def unwrap (r : Except String α) : IO α :=
  match r with
  | .ok x => pure x
  | .error e => throw (IO.userError e)
def main (args : List String) : IO Unit := do
  let path ← match args with
    | [path] => pure path
    | _ => throw (IO.userError "Supply one request JSON path")
  let j ← unwrap (Lean.Json.parse (← IO.FS.readFile path))
  let rows ← unwrap (j.getObjValAs? (Array Lean.Json) "trace")
  let initial ← unwrap (j.getObjVal? "initial")
  let mut state ← unwrap (decodeState initial)
  let mut cycle : Nat := 0
  for row in rows do
    let values ← unwrap (row.getObjVal? "inputs")
    let inputs ← unwrap (decodeInputs values)
    if !outputDefined p inputs state && !(cycle == 0 && false) then
      throw (IO.userError "Undefined output operation")
    if !transitionDefined p inputs state then
      throw (IO.userError "Undefined transition operation")
    let pre := output p inputs state
    let next := step p inputs state
    if !outputDefined p inputs next then
      throw (IO.userError "Undefined output operation after edge")
    IO.println ((Lean.Json.mkObj [("cycle", Lean.toJson cycle),
      ("pre", outputJson pre), ("post", outputJson (output p inputs next)),
      ("state", stateJson next)]).compress)
    state := next
    cycle := cycle + 1
