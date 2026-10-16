import Chisel2Lean.Compiled

/-! Continue the checked circuit's transition relation from its own preceding
    next state. State deltas are produced by evaluation, never supplied by RTL.
    Functional.evaluate remains the independent full-evaluation audit path. -/
namespace Chisel2Lean.Functional

-- These affect compilation only. The imported mathematical definitions and
-- the full-evaluator audit path are unchanged. Inlining removes transient
-- Except/tuple allocations in the event-propagation loop.

structure SelectEdge where
  destination : Nat
  left : Nat
  right : Nat

def guardedIndex (circuit : Circuit) (dependencies : DependencyIndex) :
    Except String (Array (Array Nat) × Array (Array SelectEdge)) := do
  let mut fanout := #[]
  let mut selectors := #[]
  for source in [:circuit.nodes.size] do
    let destinations ← compiledAt dependencies.fanout source
    let mut ordinary := #[]
    let mut selected := #[]
    for destination in destinations do
      let node ← compiledAt circuit.nodes destination
      if node.operation == 3 then
        let condition ← compiledAt node.args 0
        let left ← compiledAt node.args 1
        let right ← compiledAt node.args 2
        if condition == source && left != source && right != source then
          selected := selected.push { destination, left, right : SelectEdge }
        else ordinary := ordinary.push destination
      else ordinary := ordinary.push destination
    fanout := fanout.push (if selected.isEmpty then destinations else ordinary)
    selectors := selectors.push selected
  return (fanout, selectors)

-- A selector change is irrelevant only when both data AND definedness agree.
theorem select_same_data_domain (condition : Bool) (value : Value) (dc dv : Bool) :
    (if condition then (value, dc && dv) else (value, dc && dv)) = (value, dc && dv) := by
  cases condition <;> rfl

structure ProgressCache (circuit : Circuit) where
  base : IncrementalCache circuit
  result : Evaluation
  nextFields : Array (Array Nat)
  stateDelta : Array Nat
  transitionBad : Nat
  fanout : Array (Array Nat)
  selectors : Array (Array SelectEdge)

def beginProgressive (circuit : Circuit) (inputs state : Array Value) :
    Except String (Evaluation × ProgressCache circuit) := do
  let (result, base) ← evaluateIncremental circuit inputs state none
  let (fanout, selectors) ← guardedIndex circuit base.dependencies
  validateFrame circuit.states result.nextState
  let mut nextFields := Array.replicate circuit.nodes.size (#[] : Array Nat)
  let mut stateDelta := #[]
  let mut transitionBad := 0
  for i in [:circuit.states.size] do
    let field ← compiledAt circuit.states i
    let some node := field.next | throw "Missing state transition"
    nextFields := nextFields.set! node ((← compiledAt nextFields node).push i)
    if (← compiledAt result.nextState i) ≠ (← compiledAt state i) then
      stateDelta := stateDelta.push i
    if !(← compiledAt base.domains node) then transitionBad := transitionBad + 1
  return (result, { base, result, nextFields, stateDelta, transitionBad, fanout, selectors })

private def propagateProgressive (circuit : Circuit) (inputs : Array Value) (inputChanges : Array Nat)
    (old : ProgressCache circuit) : Except String (Evaluation × ProgressCache circuit) := do
  if inputChanges.isEmpty && old.stateDelta.isEmpty then return (old.result, old)
  -- Consume the previous cache before updating arrays. Retaining its parent
  -- record would force a copy of every cached node at each sampling point.
  let ⟨oldBase, oldResult, nextFields, priorDelta, priorBad, fanout, selectors⟩ := old
  let ⟨_, _, priorValues, priorDomains, dependencies⟩ := oldBase
  let ⟨_, state, _, _, _, _, _⟩ := oldResult
  let mut pending := Array.replicate ((circuit.nodes.size + 63) / 64) (0 : UInt64)
  for i in inputChanges do
    for root in (← compiledAt dependencies.inputs i) do pending ← compiledSchedule pending root
  for i in priorDelta do
    for root in (← compiledAt dependencies.states i) do pending ← compiledSchedule pending root
  let mut values := priorValues
  let mut domains := priorDomains
  let mut nextState := state
  let mut stateDelta := #[]
  let mut transitionBad := priorBad
  for block in [:pending.size] do
    if (← compiledAt pending block) != 0 then
      -- Process only set bits. x & -x isolates the least pending bit, so
      -- topological order is retained even when evaluation adds higher bits.
      for _ in [:64] do
        let word ← compiledAt pending block
        if word == 0 then break
        let bit := (UInt64.log2 (word &&& (0 - word))).toNat
        let mask := (1 : UInt64) <<< UInt64.ofNat bit
        pending := pending.set! block (word &&& (~~~mask))
        let i := block * 64 + bit
        let node ← compiledAt circuit.nodes i
        let (value, defined) ← evaluateNodeCompiled inputs state values domains node
        let priorDefined ← compiledAt domains i
        let valueChanged := decide (value ≠ (← compiledAt values i))
        if valueChanged || defined != priorDefined then
          values := values.set! i value
          domains := domains.set! i defined
          for fieldIndex in (← compiledAt nextFields i) do
            if valueChanged then
              let field ← compiledAt circuit.states fieldIndex
              compiledRequire (value.conforms field.sort) ("Value sort mismatch at " ++ field.name)
              nextState := nextState.set! fieldIndex value
              if value ≠ (← compiledAt state fieldIndex) then
                stateDelta := stateDelta.push fieldIndex
            if defined != priorDefined then
              transitionBad := if defined then transitionBad - 1 else transitionBad + 1
          for destination in (← compiledAt fanout i) do
            pending ← compiledSchedule pending destination
          for edge in (← compiledAt selectors i) do
            if defined != priorDefined ||
               decide ((← compiledAt values edge.left) ≠ (← compiledAt values edge.right)) ||
               (← compiledAt domains edge.left) != (← compiledAt domains edge.right) then
              pending ← compiledSchedule pending edge.destination
      compiledRequire ((← compiledAt pending block) == 0) "Unprocessed incremental work remains"
  let mut outputs := #[]
  let mut outputDefined := true
  let mut checksValid := true
  let mut maxLeftShift := 0
  let mut maxLeftShiftLine := 0
  for i in dependencies.shifts do
    let node ← compiledAt circuit.nodes i
    match ← compiledAt values (← compiledAt node.args 1) with
    | .bits _ amount =>
      if amount.toNat > maxLeftShift then
        maxLeftShift := amount.toNat
        maxLeftShiftLine := node.line
    | _ => throw "Shift count must be a bitvector"
  for output in circuit.outputs do
    outputs := outputs.push (← compiledAt values output.node)
    let active ← match output.guard with
      | none => pure true
      | some enable => (← compiledAt values enable).nonzeroCompiled
    outputDefined := outputDefined && (!active || (← compiledAt domains output.node))
  for effect in circuit.effects do
    if effect.kind < 2 && (← (← compiledAt outputs effect.enable).nonzeroCompiled) then
      let some index := effect.condition | throw "Missing property condition"
      checksValid := checksValid && (← (← compiledAt outputs index).nonzeroCompiled)
  let result := { outputs, nextState, outputDefined, transitionDefined := transitionBad == 0,
                  checksValid, maxLeftShift, maxLeftShiftLine : Evaluation }
  let base := { inputs, state, values, domains, dependencies : IncrementalCache circuit }
  return (result, { base, result, nextFields, stateDelta, transitionBad, fanout, selectors })

def advanceProgressive (circuit : Circuit) (inputs : Array Value)
    (old : ProgressCache circuit) : Except String (Evaluation × ProgressCache circuit) := do
  validateFrame circuit.inputs inputs
  let flags ← changedFrame old.base.inputs inputs
  let mut changed := #[]
  for i in [:flags.size] do
    if ← compiledAt flags i then changed := changed.push i
  propagateProgressive circuit inputs changed old

-- Changes are applied to our own previous input frame. Unspecified inputs
-- remain constant by construction; no external change mask is trusted.
def advanceProgressiveUpdates (circuit : Circuit) (updates : Array (Nat × Value))
    (old : ProgressCache circuit) : Except String (Evaluation × ProgressCache circuit) := do
  let mut inputs := old.base.inputs
  let mut changed := #[]
  for (index, value) in updates do
    let field ← compiledAt circuit.inputs index
    compiledRequire (value.conforms field.sort) ("Value sort mismatch at " ++ field.name)
    if value ≠ (← compiledAt inputs index) then
      inputs := inputs.set! index value
      changed := changed.push index
  propagateProgressive circuit inputs changed old

end Chisel2Lean.Functional
