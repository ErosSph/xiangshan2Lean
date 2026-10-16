-- Generated from locked Yosys FunctionalIR. Fixed circuit; explicit initial state.
import Lean
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
namespace Effects.DisabledCheck
structure Inputs where
  i0 : BitVec 4
  i1 : BitVec 4
  i2 : BitVec 1

structure State where

structure Outputs where
  o0 : BitVec 1
  o1 : BitVec 1
  o2 : BitVec 1

structure Evaluation where
  outputs : Outputs
  nextState : State
  outputDefined : Bool
  transitionDefined : Bool
  checksValid : Bool

def evaluate (inputs : Inputs) (state : State) : Evaluation :=
  let n0 : BitVec 1 := inputs.i2
  let n1 : BitVec 1 := (1#1)
  let n2 : Bool := (n0 == n1)
  let n3 : BitVec 1 := (1#1)
  let n4 : BitVec 1 := (0#1)
  let n5 : BitVec 1 := (if n2 then n3 else n4)
  let n6 : BitVec 4 := inputs.i0
  let n7 : BitVec 28 := (0#28)
  let n8 : BitVec 32 := (n7 ++ n6)
  let n9 : BitVec 4 := inputs.i1
  let n10 : BitVec 28 := (0#28)
  let n11 : BitVec 32 := (n10 ++ n9)
  let n12 : BitVec 32 := (BitVec.udiv n8 n11)
  let d12 : Bool := (n11 != 0)
  let n13 : BitVec 32 := (0#32)
  let n14 : Bool := (decide (n12.toNat > n13.toNat))
  let d14 : Bool := d12
  let n15 : BitVec 1 := (1#1)
  let n16 : BitVec 1 := (0#1)
  let n17 : BitVec 1 := (if n14 then n15 else n16)
  let d17 : Bool := d14
  let n18 : BitVec 1 := (1#1)
  { outputs := { o0 := n18, o1 := n5, o2 := n17 }, nextState := ⟨⟩,
    outputDefined := (n5 == 0 || d17), transitionDefined := true, checksValid := (n5 == 0 || n17 != 0) }

def step (inputs : Inputs) (state : State) : Outputs × State :=
  let r := evaluate inputs state
  (r.outputs, r.nextState)

def initialValid (state : State) : Bool :=
  true
end Effects.DisabledCheck
