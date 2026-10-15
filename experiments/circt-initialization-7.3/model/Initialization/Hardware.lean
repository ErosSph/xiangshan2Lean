-- Generated from locked Yosys FunctionalIR. Fixed circuit; explicit initial state.
import Lean
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
namespace Initialization.Hardware
structure Inputs where
  i0 : BitVec 1
  i1 : BitVec 1
  i2 : BitVec 8

structure State where
  s0 : BitVec 1
  s1 : BitVec 8
  s2 : BitVec 8
  s3 : BitVec 1
  s4 : BitVec 8

structure Outputs where
  o0 : BitVec 8

structure Evaluation where
  outputs : Outputs
  nextState : State
  outputDefined : Bool
  transitionDefined : Bool

def evaluate (inputs : Inputs) (state : State) : Evaluation :=
  let n0 : BitVec 1 := inputs.i1
  let n1 : BitVec 8 := inputs.i2
  let n2 : BitVec 8 := state.s2
  let n3 : BitVec 8 := state.s1
  let n4 : BitVec 1 := state.s0
  let n5 : BitVec 2 := (n4 ++ n0)
  let n6 : BitVec 2 := (1#2)
  let n7 : Bool := (n5 == n6)
  let n8 : BitVec 1 := (1#1)
  let n9 : BitVec 1 := (0#1)
  let n10 : BitVec 1 := (if n7 then n8 else n9)
  let n11 : BitVec 1 := (1#1)
  let n12 : Bool := (n10 == n11)
  let n13 : BitVec 8 := (if n12 then n3 else n2)
  let n14 : BitVec 8 := state.s4
  let n15 : BitVec 1 := state.s3
  let n16 : BitVec 1 := (1#1)
  let n17 : Bool := (n15 == n16)
  let n18 : BitVec 8 := (if n17 then n14 else n13)
  let n19 : BitVec 1 := inputs.i0
  let n20 : BitVec 1 := (1#1)
  let n21 : Bool := (n19 == n20)
  let n22 : BitVec 8 := (167#8)
  let n23 : BitVec 8 := (if n21 then n22 else n18)
  let n24 : BitVec 8 := (167#8)
  { outputs := { o0 := n23 }, nextState := { s0 := n0, s1 := n1, s2 := n23, s3 := n19, s4 := n24 },
    outputDefined := true, transitionDefined := true }

def step (inputs : Inputs) (state : State) : Outputs × State :=
  let r := evaluate inputs state
  (r.outputs, r.nextState)

def initialValid (state : State) : Bool :=
  ((state.s0 &&& (1#1)) == (1#1)) &&
  ((state.s1 &&& (255#8)) == (0#8)) &&
  ((state.s3 &&& (1#1)) == (0#1)) &&
  ((state.s4 &&& (255#8)) == (0#8))
end Initialization.Hardware
