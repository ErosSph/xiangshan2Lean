import FIRRTL.RegisterFile
set_option linter.unusedVariables false
set_option maxRecDepth 10000
set_option maxHeartbeats 0
open FIRRTL.RegisterFile
def p : Params := ⟨⟩
def decodeInputs (j : Lean.Json) : Except String (Inputs p) := do
  let v0 ← j.getObjValAs? Int "reset"
  let v1 ← j.getObjValAs? Int "write"
  let v2 ← j.getObjValAs? Int "waddr"
  let v3 ← j.getObjValAs? Int "raddr"
  let v4 ← j.getObjValAs? Int "data"
  return { reset := BitVec.ofInt _ v0, write := BitVec.ofInt _ v1, waddr := BitVec.ofInt _ v2, raddr := BitVec.ofInt _ v3, data := BitVec.ofInt _ v4 }

def decodeState (j : Lean.Json) : Except String (State p) := do
  let v0 ← j.getObjValAs? Int "registers_0"
  let v1 ← j.getObjValAs? Int "registers_1"
  let v2 ← j.getObjValAs? Int "registers_2"
  let v3 ← j.getObjValAs? Int "registers_3"
  let v4 ← j.getObjValAs? Int "registers_4"
  let v5 ← j.getObjValAs? Int "registers_5"
  let v6 ← j.getObjValAs? Int "registers_6"
  let v7 ← j.getObjValAs? Int "registers_7"
  return { registers_0 := BitVec.ofInt _ v0, registers_1 := BitVec.ofInt _ v1, registers_2 := BitVec.ofInt _ v2, registers_3 := BitVec.ofInt _ v3, registers_4 := BitVec.ofInt _ v4, registers_5 := BitVec.ofInt _ v5, registers_6 := BitVec.ofInt _ v6, registers_7 := BitVec.ofInt _ v7 }

def outputJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("out", Lean.toJson (o.«out»).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("registers_0", Lean.toJson (s.registers_0).toNat), ("registers_1", Lean.toJson (s.registers_1).toNat), ("registers_2", Lean.toJson (s.registers_2).toNat), ("registers_3", Lean.toJson (s.registers_3).toNat), ("registers_4", Lean.toJson (s.registers_4).toNat), ("registers_5", Lean.toJson (s.registers_5).toNat), ("registers_6", Lean.toJson (s.registers_6).toNat), ("registers_7", Lean.toJson (s.registers_7).toNat)]
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
