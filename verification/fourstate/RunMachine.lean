import Chisel2Lean.Functional
open Chisel2Lean.Functional

def natValue (value : Value) : Except String Nat :=
  match value with
  | .bits _ word => pure word.toNat
  | .boolean b => pure (if b then 1 else 0)
  | _ => throw "Scalar protocol/output expected"

def wordValue (value : Value) (index : Nat) : Except String Nat :=
  match value with
  | .bits _ word => pure word.toNat
  | .memory _ _ words => return (← arrayAt words index).toNat
  | _ => throw "Scalar or memory bank expected"

def emitPair (kind : String) (sample phase object index width tag value : Nat) : IO Unit :=
  IO.println s!"C2LN {sample} {phase} {kind} {object} {index} {width} {tag} {value}"

def emitObject (object : Array Nat) (state : Array Value) (sample phase : Nat)
    (activation : Bool) (ordinal : Nat) : IO Unit := do
  if object.size != 7 then throw (IO.userError "Object map arity")
  let tag ← unwrap (arrayAt state object[5]!)
  let value ← unwrap (arrayAt state object[6]!)
  let size := if object[3]! == 0 then 1 else object[3]!
  for index in [:size] do
    let logical := if object[3]! == 0 then 0 else object[4]! + index
    let t ← unwrap (wordValue tag index)
    let v ← unwrap (wordValue value index)
    if activation then
      IO.println s!"A2LN {sample} {object[1]!} {ordinal} S {object[0]!} {logical} {object[2]!} {t} {v}"
    else emitPair "S" sample phase object[0]! logical object[2]! t v

def outputNat (outputs : Array Value) (index : Nat) : IO Nat := do
  unwrap (natValue (← unwrap (arrayAt outputs index)))

def main (args : List String) : IO Unit := do
  let [binaryPath, planPath, requestPath] := args | throw (IO.userError "circuit, plan, explicit request required")
  let checked ← unwrap (decode (← IO.FS.readBinFile binaryPath))
  let circuit := checked.data
  let plan ← unwrap (Lean.Json.parse (← IO.FS.readFile planPath))
  let request ← unwrap (Lean.Json.parse (← IO.FS.readFile requestPath))
  let objects ← unwrap (plan.getObjValAs? (Array (Array Nat)) "objects")
  let originalOutputs ← unwrap (plan.getObjValAs? (Array (Array Nat)) "outputs")
  let aliases ← unwrap (plan.getObjValAs? (Array (Array Nat)) "aliases")
  let edges ← unwrap (plan.getObjValAs? (Array Nat) "edges")
  let diagnostics ← unwrap (plan.getObjValAs? (Array Lean.Json) "diagnostics")
  let processes ← unwrap (plan.getObjValAs? Nat "processes")
  let monitorCount ← unwrap (plan.getObjValAs? Nat "monitors")
  let waves ← unwrap (plan.getObjValAs? Nat "waves")
  let clock ← unwrap (plan.getObjValAs? Nat "clock")
  let protocol ← unwrap (plan.getObjVal? "protocol")
  let field (name : String) : IO Nat := unwrap (protocol.getObjValAs? Nat name)
  let readyIndex ← field "step_ready"
  let preIndex ← field "pre_valid"
  let postIndex ← field "post_valid"
  let faultIndex ← field "fault"
  let firedIndex ← field "fired"
  let monitorIndex ← field "observed_monitors"
  let waveIndex ← field "wave_valid"
  let validIndex := circuit.inputs.findIdx? (fun f => f.name == "step_valid")
  let some validIndex := validIndex | throw (IO.userError "step_valid input missing")
  let mut state ← unwrap (decodeFrame circuit.states (← unwrap (request.getObjVal? "initial")))
  if !(← unwrap (initialValid circuit.states state)) then throw (IO.userError "Invalid complete initial state")
  let rows ← unwrap (request.getObjValAs? (Array Lean.Json) "trace")
  let mut edgeMask := Array.replicate processes false
  for pid in edges do
    if pid >= processes then throw (IO.userError "Invalid process map")
    edgeMask := edgeMask.set! pid true
  let mut counts := Array.replicate processes 0
  let tick (inputs state : Array Value) : IO (Array Value × Array Value) := do
    let low ← unwrap (evaluate circuit (inputs.set! clock (.bits 1 0)) state)
    let high ← unwrap (evaluate circuit (inputs.set! clock (.bits 1 1)) low.nextState)
    if !low.outputDefined || !low.transitionDefined || !low.checksValid ||
       !high.outputDefined || !high.transitionDefined || !high.checksValid then
      throw (IO.userError "Undefined domain or native backend check failure")
    pure (high.outputs,high.nextState)
  let snapshot (outputs state : Array Value) (sample phase : Nat) (counts : Array Nat) : IO Unit := do
    for group in aliases do
      let first ← unwrap (natValue (← unwrap (arrayAt state group[0]!)))
      for index in group do
        if (← unwrap (natValue (← unwrap (arrayAt state index)))) != first then
          throw (IO.userError "Exact sampled-Q aliases diverged")
    for p in originalOutputs do
      if p.size != 4 then throw (IO.userError "Output map arity")
      emitPair "O" sample phase p[0]! 0 p[1]! (← outputNat outputs p[2]!) (← outputNat outputs p[3]!)
    for object in objects do emitObject object state sample phase false 0
    let monitors ← outputNat outputs monitorIndex
    for index in [:monitorCount] do
      emitPair "M" sample phase index 0 1
        (if monitors.testBit (2*index+1) then 1 else 0) (if monitors.testBit (2*index) then 1 else 0)
    for pid in edges do emitPair "E" sample phase pid 0 0 0 counts[pid]!
    if phase == 0 then
      for index in [:diagnostics.size] do
        let flags ← unwrap (diagnostics[index]!.getObjValAs? (Array Nat) "flags")
        IO.println s!"AFLAG {sample} {index} {← outputNat outputs flags[0]!}{← outputNat outputs flags[1]!}{← outputNat outputs flags[2]!}{← outputNat outputs flags[3]!}"
  for sample in [:rows.size] do
    IO.println s!"F47_STEP {sample}"
    let base ← unwrap (decodeFrame circuit.inputs (← unwrap (rows[sample]!.getObjVal? "inputs")))
    let mut inputs := base.set! validIndex (.bits 1 1)
    let mut done := false
    let mut reachedPre := false
    for _ in [:8*waves+8] do
      let (outputs,next) ← tick inputs state
      state := next
      inputs := inputs.set! validIndex (.bits 1 0)
      if (← outputNat outputs faultIndex) != 0 then throw (IO.userError s!"Controller fault at sample {sample}")
      if (← outputNat outputs waveIndex) == 1 then
        let fired ← outputNat outputs firedIndex
        for pid in [:processes] do
          if fired.testBit pid then
            if !edgeMask[pid]! then throw (IO.userError "Latch has an edge event")
            counts := counts.set! pid (counts[pid]! + 1)
        for object in objects do
          if fired.testBit object[1]! then emitObject object state sample 0 true counts[object[1]!]!
        for site in [:diagnostics.size] do
          let diagnostic := diagnostics[site]!
          let pid ← unwrap (diagnostic.getObjValAs? Nat "process")
          let flags ← unwrap (diagnostic.getObjValAs? (Array Nat) "flags")
          if fired.testBit pid && (← outputNat outputs flags[0]!) == 0 &&
             (← outputNat outputs flags[1]!) == 1 && (← outputNat outputs flags[2]!) == 0 &&
             (← outputNat outputs flags[3]!) == 0 then
            IO.println s!"F57_DIAG {sample} {site} {pid} {counts[pid]!}"
            let arguments ← unwrap (diagnostic.getObjValAs? (Array (Array Nat)) "arguments")
            for argument in [:arguments.size] do
              let a := arguments[argument]!
              IO.println s!"F57_ARGNUM {sample} {site} {counts[pid]!} {argument} {a[0]!} {← outputNat outputs a[1]!} {← outputNat outputs a[2]!}"
      if (← outputNat outputs preIndex) == 1 then
        if reachedPre then throw (IO.userError "Repeated pre observation")
        snapshot outputs state sample 0 counts
        reachedPre := true
      if (← outputNat outputs postIndex) == 1 then
        if !reachedPre then throw (IO.userError "Missing pre observation")
        snapshot outputs state sample 1 counts
        let (afterCleanup,next) ← tick inputs state
        state := next
        if (← outputNat afterCleanup readyIndex) != 1 then throw (IO.userError "Controller did not return ready")
        done := true
        break
    if !done then throw (IO.userError "Accepted event plan did not converge")
  IO.println s!"F57_END {rows.size}"
