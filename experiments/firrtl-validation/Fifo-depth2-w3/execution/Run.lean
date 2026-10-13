import FIRRTL.Fifo
set_option linter.unusedVariables false
set_option maxRecDepth 10000
set_option maxHeartbeats 0
open FIRRTL.Fifo
def p : Params := ⟨⟩
def decodeInputs (j : Lean.Json) : Except String (Inputs p) := do
  let v0 ← j.getObjValAs? Int "reset"
  let v1 ← j.getObjValAs? Int "enq"
  let v2 ← j.getObjValAs? Int "deq"
  let v3 ← j.getObjValAs? Int "data"
  return { reset := BitVec.ofInt _ v0, enq := BitVec.ofInt _ v1, deq := BitVec.ofInt _ v2, data := BitVec.ofInt _ v3 }

def decodeState (j : Lean.Json) : Except String (State p) := do
  let v0 ← j.getObjValAs? Int "storage_0"
  let v1 ← j.getObjValAs? Int "storage_1"
  let v2 ← j.getObjValAs? Int "read"
  let v3 ← j.getObjValAs? Int "write"
  let v4 ← j.getObjValAs? Int "count"
  return { storage_0 := BitVec.ofInt _ v0, storage_1 := BitVec.ofInt _ v1, read := BitVec.ofInt _ v2, write := BitVec.ofInt _ v3, count := BitVec.ofInt _ v4 }

def outputJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("out", Lean.toJson (o.«out»).toNat), ("full", Lean.toJson (o.full).toNat), ("empty", Lean.toJson (o.empty).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("storage_0", Lean.toJson (s.storage_0).toNat), ("storage_1", Lean.toJson (s.storage_1).toNat), ("read", Lean.toJson (s.read).toNat), ("write", Lean.toJson (s.write).toNat), ("count", Lean.toJson (s.count).toNat)]
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
