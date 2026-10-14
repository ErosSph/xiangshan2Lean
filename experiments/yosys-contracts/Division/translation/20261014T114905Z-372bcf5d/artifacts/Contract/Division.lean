-- Generated from locked Yosys FunctionalIR. Fixed circuit; explicit initial state.
import Lean
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
namespace Contract.Division
structure Inputs where
  i0 : BitVec 4
  i1 : BitVec 4
  i2 : BitVec 1

structure State where

structure Outputs where
  o0 : BitVec 4

structure Evaluation where
  outputs : Outputs
  nextState : State
  outputDefined : Bool
  transitionDefined : Bool

def evaluate (inputs : Inputs) (state : State) : Evaluation :=
  let n0 : BitVec 4 := inputs.i0
  let n1 : BitVec 4 := inputs.i1
  let n2 : BitVec 4 := (BitVec.udiv n0 n1)
  let d2 : Bool := (n1 != 0)
  let n3 : BitVec 1 := inputs.i2
  let n4 : BitVec 1 := (1#1)
  let n5 : Bool := (n3 == n4)
  let n6 : BitVec 4 := (if n5 then n2 else n0)
  let d6 : Bool := (if n5 then d2 else true)
  { outputs := { o0 := n6 }, nextState := ⟨⟩,
    outputDefined := d6, transitionDefined := true }

def step (inputs : Inputs) (state : State) : Outputs × State :=
  let r := evaluate inputs state
  (r.outputs, r.nextState)

def initialValid (state : State) : Bool :=
  true
end Contract.Division
