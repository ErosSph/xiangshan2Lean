-- Generated from locked Yosys FunctionalIR. Fixed circuit; explicit initial state.
import Lean
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
namespace Contract.PartialInitial
structure Inputs where
  i0 : BitVec 1
  i1 : BitVec 1

structure State where
  s0 : BitVec 1
  s1 : BitVec 4
  s2 : BitVec 4

structure Outputs where
  o0 : BitVec 4

structure Evaluation where
  outputs : Outputs
  nextState : State
  outputDefined : Bool
  transitionDefined : Bool

def evaluate (inputs : Inputs) (state : State) : Evaluation :=
  let n0 : BitVec 1 := inputs.i0
  let n1 : BitVec 4 := state.s2
  let n2 : BitVec 4 := state.s1
  let n3 : BitVec 1 := state.s0
  let n4 : BitVec 2 := (n3 ++ n0)
  let n5 : BitVec 2 := (1#2)
  let n6 : Bool := (n4 == n5)
  let n7 : BitVec 1 := (1#1)
  let n8 : BitVec 1 := (0#1)
  let n9 : BitVec 1 := (if n6 then n7 else n8)
  let n10 : BitVec 1 := (1#1)
  let n11 : Bool := (n9 == n10)
  let n12 : BitVec 4 := (if n11 then n2 else n1)
  let n13 : BitVec 28 := (0#28)
  let n14 : BitVec 32 := (n13 ++ n12)
  let n15 : BitVec 32 := (1#32)
  let n16 : BitVec 32 := (n14 + n15)
  let n17 : BitVec 4 := (BitVec.extractLsb' 0 4 n16)
  let n18 : BitVec 1 := inputs.i1
  let n19 : BitVec 1 := (1#1)
  let n20 : Bool := (n18 == n19)
  let n21 : BitVec 4 := (if n20 then n17 else n12)
  { outputs := { o0 := n12 }, nextState := { s0 := n0, s1 := n21, s2 := n12 },
    outputDefined := true, transitionDefined := true }

def step (inputs : Inputs) (state : State) : Outputs × State :=
  let r := evaluate inputs state
  (r.outputs, r.nextState)

def initialValid (state : State) : Bool :=
  ((state.s0 &&& (1#1)) == (1#1)) &&
  ((state.s1 &&& (15#4)) == (0#4)) &&
  ((state.s2 &&& (10#4)) == (8#4))
end Contract.PartialInitial
