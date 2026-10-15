-- Generated from locked Yosys FunctionalIR. Fixed circuit; explicit initial state.
import Lean
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
namespace Stdio.Observed
structure Inputs where
  i0 : BitVec 1
  i1 : BitVec 1
  i2 : BitVec 4

structure State where
  s0 : BitVec 1
  s1 : BitVec 1
  s2 : BitVec 1
  s3 : BitVec 4
  s4 : BitVec 4
  s5 : BitVec 1
  s6 : BitVec 1
  s7 : BitVec 4
  s8 : BitVec 4

structure Outputs where
  o0 : BitVec 4
  o1 : BitVec 1
  o2 : BitVec 4
  o3 : BitVec 1
  o4 : BitVec 4

structure Evaluation where
  outputs : Outputs
  nextState : State
  outputDefined : Bool
  transitionDefined : Bool
  checksValid : Bool

def evaluate (inputs : Inputs) (state : State) : Evaluation :=
  let n0 : BitVec 1 := inputs.i0
  let n1 : BitVec 4 := state.s4
  let n2 : BitVec 4 := state.s3
  let n3 : BitVec 1 := state.s2
  let n4 : BitVec 2 := (n3 ++ n0)
  let n5 : BitVec 2 := (1#2)
  let n6 : Bool := (n4 == n5)
  let n7 : BitVec 1 := (1#1)
  let n8 : BitVec 1 := (0#1)
  let n9 : BitVec 1 := (if n6 then n7 else n8)
  let n10 : BitVec 1 := (1#1)
  let n11 : Bool := (n9 == n10)
  let n12 : BitVec 4 := (if n11 then n2 else n1)
  let n13 : BitVec 4 := inputs.i2
  let n14 : BitVec 1 := inputs.i1
  let n15 : BitVec 1 := (1#1)
  let n16 : Bool := (n14 == n15)
  let n17 : BitVec 4 := (if n16 then n13 else n12)
  let n18 : BitVec 1 := (1#1)
  let n19 : Bool := (n14 == n18)
  let n20 : BitVec 1 := (1#1)
  let n21 : BitVec 1 := (0#1)
  let n22 : BitVec 1 := (if n19 then n20 else n21)
  let n23 : BitVec 1 := (1#1)
  let n24 : Bool := (n14 == n23)
  let n25 : BitVec 1 := (1#1)
  let n26 : BitVec 1 := (0#1)
  let n27 : BitVec 1 := (if n24 then n25 else n26)
  let n28 : BitVec 1 := state.s5
  let n29 : BitVec 1 := state.s0
  let n30 : BitVec 2 := (n29 ++ n0)
  let n31 : BitVec 2 := (1#2)
  let n32 : Bool := (n30 == n31)
  let n33 : BitVec 1 := (1#1)
  let n34 : BitVec 1 := (0#1)
  let n35 : BitVec 1 := (if n32 then n33 else n34)
  let n36 : BitVec 1 := (n28 &&& n35)
  let n37 : BitVec 4 := state.s7
  let n38 : BitVec 1 := state.s6
  let n39 : BitVec 1 := state.s1
  let n40 : BitVec 2 := (n39 ++ n0)
  let n41 : BitVec 2 := (1#2)
  let n42 : Bool := (n40 == n41)
  let n43 : BitVec 1 := (1#1)
  let n44 : BitVec 1 := (0#1)
  let n45 : BitVec 1 := (if n42 then n43 else n44)
  let n46 : BitVec 1 := (n38 &&& n45)
  let n47 : BitVec 4 := state.s8
  { outputs := { o0 := n12, o1 := n36, o2 := n37, o3 := n46, o4 := n47 }, nextState := { s0 := n0, s1 := n0, s2 := n0, s3 := n17, s4 := n12, s5 := n22, s6 := n27, s7 := n12, s8 := n12 },
    outputDefined := true, transitionDefined := true, checksValid := true }

def step (inputs : Inputs) (state : State) : Outputs × State :=
  let r := evaluate inputs state
  (r.outputs, r.nextState)

def initialValid (state : State) : Bool :=
  ((state.s0 &&& (1#1)) == (1#1)) &&
  ((state.s1 &&& (1#1)) == (1#1)) &&
  ((state.s2 &&& (1#1)) == (1#1)) &&
  ((state.s3 &&& (15#4)) == (0#4)) &&
  ((state.s4 &&& (15#4)) == (0#4)) &&
  ((state.s5 &&& (1#1)) == (0#1)) &&
  ((state.s6 &&& (1#1)) == (0#1)) &&
  ((state.s7 &&& (15#4)) == (0#4)) &&
  ((state.s8 &&& (15#4)) == (0#4))
end Stdio.Observed
