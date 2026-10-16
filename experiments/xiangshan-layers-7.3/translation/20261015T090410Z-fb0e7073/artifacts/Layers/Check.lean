-- Generated from locked Yosys FunctionalIR. Fixed circuit; explicit initial state.
import Lean
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
namespace Layers.Check
structure Inputs where
  i0 : BitVec 1
  i1 : BitVec 1
  i2 : BitVec 1

structure State where
  s0 : BitVec 1
  s1 : BitVec 1
  s2 : BitVec 1

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
  let n0 : BitVec 1 := inputs.i0
  let n1 : BitVec 1 := inputs.i1
  let n2 : BitVec 1 := (1#1)
  let n3 : Bool := (n1 == n2)
  let n4 : BitVec 1 := (1#1)
  let n5 : BitVec 1 := (0#1)
  let n6 : BitVec 1 := (if n3 then n4 else n5)
  let n7 : BitVec 1 := inputs.i2
  let n8 : BitVec 1 := state.s1
  let n9 : BitVec 1 := state.s0
  let n10 : BitVec 2 := (n9 ++ n0)
  let n11 : BitVec 2 := (1#2)
  let n12 : Bool := (n10 == n11)
  let n13 : BitVec 1 := (1#1)
  let n14 : BitVec 1 := (0#1)
  let n15 : BitVec 1 := (if n12 then n13 else n14)
  let n16 : BitVec 1 := (n8 &&& n15)
  let n17 : BitVec 1 := state.s2
  { outputs := { o0 := n7, o1 := n16, o2 := n17 }, nextState := { s0 := n0, s1 := n6, s2 := n7 },
    outputDefined := true, transitionDefined := true, checksValid := (n16 == 0 || n17 != 0) }

def step (inputs : Inputs) (state : State) : Outputs × State :=
  let r := evaluate inputs state
  (r.outputs, r.nextState)

def initialValid (state : State) : Bool :=
  ((state.s0 &&& (1#1)) == (1#1)) &&
  ((state.s1 &&& (1#1)) == (0#1)) &&
  ((state.s2 &&& (1#1)) == (1#1))
end Layers.Check
