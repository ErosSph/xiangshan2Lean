import Chisel2Lean.Functional

/-! Pure incremental execution of the same checked FunctionalIR. A cache must
    originate from the previous call for the same circuit. This is a separate
    execution backend; the baseline evaluator remains the reference/audit path.
    Both value and definedness changes propagate, including dormant ite arms. -/
namespace Chisel2Lean.Functional

deriving instance DecidableEq for Value
deriving instance DecidableEq for Evaluation

structure DependencyIndex where
  fanout : Array (Array Nat)
  inputs : Array (Array Nat)
  states : Array (Array Nat)
  shifts : Array Nat

def dependencyIndex (circuit : Circuit) : Except String DependencyIndex := do
  let mut fanout := Array.replicate circuit.nodes.size (#[] : Array Nat)
  let mut inputs := Array.replicate circuit.inputs.size (#[] : Array Nat)
  let mut states := Array.replicate circuit.states.size (#[] : Array Nat)
  let mut shifts := #[]
  for i in [:circuit.nodes.size] do
    let node ← arrayAt circuit.nodes i
    if node.operation == 1 then
      inputs := inputs.set! node.extra ((← arrayAt inputs node.extra).push i)
    if node.operation == 2 then
      states := states.set! node.extra ((← arrayAt states node.extra).push i)
    if node.operation == 12 then shifts := shifts.push i
    for dependency in node.args do
      require (dependency < i) "Incremental execution needs an acyclic ordered circuit"
      fanout := fanout.set! dependency ((← arrayAt fanout dependency).push i)
  return { fanout, inputs, states, shifts }

def scheduleNode (pending : Array UInt64) (index : Nat) : Except String (Array UInt64) := do
  let block := index / 64
  let bit := (1 : UInt64) <<< UInt64.ofNat (index % 64)
  return pending.set! block ((← arrayAt pending block) ||| bit)

structure IncrementalCache (circuit : Circuit) where
  inputs : Array Value
  state : Array Value
  values : Array Value
  domains : Array Bool
  dependencies : DependencyIndex

def changedFrame (previous current : Array Value) : Except String (Array Bool) := do
  require (previous.size == current.size) "Incremental frame size changed"
  current.mapIdxM fun i value => do
    return decide (value ≠ (← arrayAt previous i))

def evaluateIncremental (circuit : Circuit) (inputs state : Array Value)
    (cache : Option (IncrementalCache circuit)) :
    Except String (Evaluation × IncrementalCache circuit) := do
  validateFrame circuit.inputs inputs
  validateFrame circuit.states state
  let dependencies ← match cache with
    | none => dependencyIndex circuit
    | some old => pure old.dependencies
  let mut values := cache.map (·.values) |>.getD #[]
  let mut domains := cache.map (·.domains) |>.getD #[]
  let mut maxLeftShift := 0
  let mut maxLeftShiftLine := 0
  match cache with
  | none =>
    for node in circuit.nodes do
      let (value, defined) ← evaluateNode inputs state values domains node
      values := values.push value
      domains := domains.push defined
  | some old =>
    let inputChanges ← changedFrame old.inputs inputs
    let stateChanges ← changedFrame old.state state
    let mut pending := Array.replicate ((circuit.nodes.size + 63) / 64) (0 : UInt64)
    for i in [:inputChanges.size] do
      if ← arrayAt inputChanges i then
        for root in (← arrayAt dependencies.inputs i) do pending ← scheduleNode pending root
    for i in [:stateChanges.size] do
      if ← arrayAt stateChanges i then
        for root in (← arrayAt dependencies.states i) do pending ← scheduleNode pending root
    -- All edges point to larger node indices. A word can therefore be skipped
    -- permanently when zero; later work can only set bits to its right.
    for block in [:pending.size] do
      if (← arrayAt pending block) != 0 then
        for bit in [:64] do
          let mask := (1 : UInt64) <<< UInt64.ofNat bit
          if ((← arrayAt pending block) &&& mask) != 0 then
            let i := block * 64 + bit
            let node ← arrayAt circuit.nodes i
            let (value, defined) ← evaluateNode inputs state values domains node
            let changed := decide (value ≠ (← arrayAt values i)) || defined != (← arrayAt domains i)
            if changed then
              values := values.set! i value
              domains := domains.set! i defined
              for destination in (← arrayAt dependencies.fanout i) do
                pending ← scheduleNode pending destination
  for i in dependencies.shifts do
    let node ← arrayAt circuit.nodes i
    match ← arrayAt values (← arrayAt node.args 1) with
    | .bits _ amount =>
      if amount.toNat > maxLeftShift then
        maxLeftShift := amount.toNat
        maxLeftShiftLine := node.line
    | _ => throw "Shift count must be a bitvector"
  let mut outputs := #[]
  let mut nextState := #[]
  let mut outputDefined := true
  let mut transitionDefined := true
  let mut checksValid := true
  for output in circuit.outputs do
    outputs := outputs.push (← arrayAt values output.node)
    let active ← match output.guard with
      | none => pure true
      | some enable => (← arrayAt values enable).nonzero
    outputDefined := outputDefined && (!active || (← arrayAt domains output.node))
  for field in circuit.states do
    let some index := field.next | throw "Missing state transition"
    nextState := nextState.push (← arrayAt values index)
    transitionDefined := transitionDefined && (← arrayAt domains index)
  for effect in circuit.effects do
    if effect.kind < 2 && (← (← arrayAt outputs effect.enable).nonzero) then
      let some index := effect.condition | throw "Missing property condition"
      checksValid := checksValid && (← (← arrayAt outputs index).nonzero)
  let result := { outputs, nextState, outputDefined, transitionDefined, checksValid,
                  maxLeftShift, maxLeftShiftLine : Evaluation }
  return (result, { inputs, state, values, domains, dependencies })

end Chisel2Lean.Functional
