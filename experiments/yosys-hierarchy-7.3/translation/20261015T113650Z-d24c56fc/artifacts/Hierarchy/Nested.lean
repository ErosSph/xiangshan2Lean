-- Generated from locked Yosys FunctionalIR. Fixed circuit; explicit initial state.
import Lean
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
namespace Hierarchy.Nested
structure Inputs where
  i0 : BitVec 1
  i1 : BitVec 1
  i2 : BitVec 1
  i3 : BitVec 8
  i4 : BitVec 8
  i5 : BitVec 8

structure State where
  s0 : BitVec 1
  s1 : BitVec 1
  s2 : BitVec 8
  s3 : BitVec 8
  s4 : BitVec 8
  s5 : BitVec 8

structure Outputs where
  o0 : BitVec 8
  o1 : BitVec 8

structure Evaluation where
  outputs : Outputs
  nextState : State
  outputDefined : Bool
  transitionDefined : Bool

def evaluate (inputs : Inputs) (state : State) : Evaluation :=
  let n0 : BitVec 1 := inputs.i1
  let n1 : BitVec 8 := state.s3
  let n2 : BitVec 8 := state.s2
  let n3 : BitVec 1 := state.s0
  let n4 : BitVec 2 := (n3 ++ n0)
  let n5 : BitVec 2 := (1#2)
  let n6 : Bool := (n4 == n5)
  let n7 : BitVec 1 := (1#1)
  let n8 : BitVec 1 := (0#1)
  let n9 : BitVec 1 := (if n6 then n7 else n8)
  let n10 : BitVec 1 := (1#1)
  let n11 : Bool := (n9 == n10)
  let n12 : BitVec 8 := (if n11 then n2 else n1)
  let n13 : BitVec 8 := state.s5
  let n14 : BitVec 8 := state.s4
  let n15 : BitVec 1 := state.s1
  let n16 : BitVec 2 := (n15 ++ n0)
  let n17 : BitVec 2 := (1#2)
  let n18 : Bool := (n16 == n17)
  let n19 : BitVec 1 := (1#1)
  let n20 : BitVec 1 := (0#1)
  let n21 : BitVec 1 := (if n18 then n19 else n20)
  let n22 : BitVec 1 := (1#1)
  let n23 : Bool := (n21 == n22)
  let n24 : BitVec 8 := (if n23 then n14 else n13)
  let n25 : BitVec 8 := inputs.i3
  let n26 : BitVec 8 := (n24 + n25)
  let n27 : BitVec 24 := (0#24)
  let n28 : BitVec 32 := (n27 ++ n26)
  let n29 : BitVec 32 := (1#32)
  let n30 : BitVec 32 := (n28 + n29)
  let n31 : BitVec 8 := (BitVec.extractLsb' 0 8 n30)
  let n32 : BitVec 1 := inputs.i2
  let n33 : BitVec 1 := (1#1)
  let n34 : Bool := (n32 == n33)
  let n35 : BitVec 8 := (if n34 then n31 else n12)
  let n36 : BitVec 8 := inputs.i4
  let n37 : BitVec 1 := inputs.i0
  let n38 : BitVec 1 := (1#1)
  let n39 : Bool := (n37 == n38)
  let n40 : BitVec 8 := (if n39 then n36 else n35)
  let n41 : BitVec 1 := (1#1)
  let n42 : Bool := (n37 == n41)
  let n43 : BitVec 8 := (0#8)
  let n44 : BitVec 8 := (if n42 then n43 else n40)
  let n45 : BitVec 8 := (n12 ^^^ n25)
  let n46 : BitVec 24 := (0#24)
  let n47 : BitVec 32 := (n46 ++ n45)
  let n48 : BitVec 32 := (1#32)
  let n49 : BitVec 32 := (n47 + n48)
  let n50 : BitVec 8 := (BitVec.extractLsb' 0 8 n49)
  let n51 : BitVec 1 := (1#1)
  let n52 : Bool := (n32 == n51)
  let n53 : BitVec 8 := (if n52 then n50 else n24)
  let n54 : BitVec 8 := inputs.i5
  let n55 : BitVec 1 := (1#1)
  let n56 : Bool := (n37 == n55)
  let n57 : BitVec 8 := (if n56 then n54 else n53)
  let n58 : BitVec 1 := (1#1)
  let n59 : Bool := (n37 == n58)
  let n60 : BitVec 8 := (0#8)
  let n61 : BitVec 8 := (if n59 then n60 else n57)
  { outputs := { o0 := n12, o1 := n24 }, nextState := { s0 := n0, s1 := n0, s2 := n44, s3 := n12, s4 := n61, s5 := n24 },
    outputDefined := true, transitionDefined := true }

def step (inputs : Inputs) (state : State) : Outputs × State :=
  let r := evaluate inputs state
  (r.outputs, r.nextState)

def initialValid (state : State) : Bool :=
  ((state.s0 &&& (1#1)) == (1#1)) &&
  ((state.s1 &&& (1#1)) == (1#1)) &&
  ((state.s2 &&& (255#8)) == (0#8)) &&
  ((state.s3 &&& (255#8)) == (0#8)) &&
  ((state.s4 &&& (255#8)) == (0#8)) &&
  ((state.s5 &&& (255#8)) == (0#8))
end Hierarchy.Nested
