import FIRRTL.VectorReset
set_option linter.unusedVariables false
set_option maxRecDepth 10000
set_option maxHeartbeats 0
open FIRRTL.VectorReset
def p : Params := ⟨⟩
def decodeInputs (j : Lean.Json) : Except String (Inputs p) := do
  let v0 ← j.getObjValAs? Int "reset"
  let v1 ← j.getObjValAs? Int "in_0"
  let v2 ← j.getObjValAs? Int "in_1"
  let v3 ← j.getObjValAs? Int "in_2"
  let v4 ← j.getObjValAs? Int "en"
  return { reset := BitVec.ofInt _ v0, in_0 := BitVec.ofInt _ v1, in_1 := BitVec.ofInt _ v2, in_2 := BitVec.ofInt _ v3, en := BitVec.ofInt _ v4 }

def decodeState (j : Lean.Json) : Except String (State p) := do
  let v0 ← j.getObjValAs? Int "regs_0"
  let v1 ← j.getObjValAs? Int "regs_1"
  let v2 ← j.getObjValAs? Int "regs_2"
  return { regs_0 := BitVec.ofInt _ v0, regs_1 := BitVec.ofInt _ v1, regs_2 := BitVec.ofInt _ v2 }

def outputJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("out_0", Lean.toJson (o.out_0).toNat), ("out_1", Lean.toJson (o.out_1).toNat), ("out_2", Lean.toJson (o.out_2).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("regs_0", Lean.toJson (s.regs_0).toNat), ("regs_1", Lean.toJson (s.regs_1).toNat), ("regs_2", Lean.toJson (s.regs_2).toNat)]
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
