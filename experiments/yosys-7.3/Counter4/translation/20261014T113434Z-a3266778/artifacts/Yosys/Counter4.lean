-- Generated from locked Yosys FunctionalIR. Fixed circuit; explicit initial state.
import Lean
set_option maxRecDepth 65536
set_option maxHeartbeats 0
namespace Yosys.Counter4
structure Inputs where
  i0 : BitVec 1
  i1 : BitVec 1
  i2 : BitVec 1

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
  let n13 : BitVec 4 := (1#4)
  let n14 : BitVec 4 := (n12 + n13)
  let n15 : BitVec 1 := inputs.i2
  let n16 : BitVec 1 := (1#1)
  let n17 : Bool := (n15 == n16)
  let n18 : BitVec 4 := (if n17 then n14 else n12)
  let n19 : BitVec 1 := inputs.i1
  let n20 : BitVec 1 := (1#1)
  let n21 : Bool := (n19 == n20)
  let n22 : BitVec 4 := (0#4)
  let n23 : BitVec 4 := (if n21 then n22 else n18)
  { outputs := { o0 := n12 }, nextState := { s0 := n0, s1 := n23, s2 := n12 },
    outputDefined := true, transitionDefined := true }

def step (inputs : Inputs) (state : State) : Outputs × State :=
  let r := evaluate inputs state
  (r.outputs, r.nextState)

def initialValid (state : State) : Bool :=
  ((state.s0 &&& (1#1)) == (1#1)) &&
  ((state.s1 &&& (15#4)) == (0#4))
end Yosys.Counter4
