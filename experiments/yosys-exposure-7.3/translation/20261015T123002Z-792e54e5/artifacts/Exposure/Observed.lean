-- Generated from locked Yosys FunctionalIR. Fixed circuit; explicit initial state.
import Lean
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
namespace Exposure.Observed
structure Inputs where
  i0 : BitVec 1
  i1 : BitVec 1
  i2 : BitVec 1
  i3 : BitVec 4
  i4 : BitVec 4

structure StateGroup0 where
  s0 : BitVec 1
  s1 : BitVec 1
  s2 : BitVec 1
  s3 : BitVec 1
  s4 : BitVec 1
  s5 : BitVec 1
  s6 : BitVec 4
  s7 : BitVec 4
  s8 : BitVec 1
  s9 : BitVec 1
  s10 : BitVec 1
  s11 : BitVec 1
  s12 : BitVec 1
  s13 : BitVec 1
  s14 : BitVec 1
  s15 : BitVec 1

structure StateGroup1 where
  s16 : BitVec 4

structure State where
  g0 : StateGroup0
  g1 : StateGroup1

structure Outputs where
  o0 : BitVec 4
  o1 : BitVec 1
  o2 : BitVec 1
  o3 : BitVec 1
  o4 : BitVec 1
  o5 : BitVec 1
  o6 : BitVec 1
  o7 : BitVec 1
  o8 : BitVec 4
  o9 : BitVec 1

structure Evaluation where
  outputs : Outputs
  nextState : State
  outputDefined : Bool
  transitionDefined : Bool
  checksValid : Bool

def evaluate (inputs : Inputs) (state : State) : Evaluation :=
  let n0 : BitVec 1 := inputs.i1
  let n1 : BitVec 4 := state.g0.s7
  let n2 : BitVec 4 := state.g0.s6
  let n3 : BitVec 1 := state.g0.s5
  let n4 : BitVec 2 := (n3 ++ n0)
  let n5 : BitVec 2 := (1#2)
  let n6 : Bool := (n4 == n5)
  let n7 : BitVec 1 := (1#1)
  let n8 : BitVec 1 := (0#1)
  let n9 : BitVec 1 := (if n6 then n7 else n8)
  let n10 : BitVec 1 := (1#1)
  let n11 : Bool := (n9 == n10)
  let n12 : BitVec 4 := (if n11 then n2 else n1)
  let n13 : BitVec 4 := inputs.i3
  let n14 : BitVec 1 := inputs.i2
  let n15 : BitVec 1 := (1#1)
  let n16 : Bool := (n14 == n15)
  let n17 : BitVec 4 := (if n16 then n13 else n12)
  let n18 : BitVec 4 := inputs.i4
  let n19 : BitVec 1 := inputs.i0
  let n20 : BitVec 1 := (1#1)
  let n21 : Bool := (n19 == n20)
  let n22 : BitVec 4 := (if n21 then n18 else n17)
  let n23 : BitVec 1 := (1#1)
  let n24 : Bool := (n19 == n23)
  let n25 : BitVec 4 := (0#4)
  let n26 : BitVec 4 := (if n24 then n25 else n22)
  let n27 : BitVec 1 := (~~~n19)
  let n28 : BitVec 1 := (n27 &&& n14)
  let n29 : BitVec 1 := (1#1)
  let n30 : Bool := (n28 == n29)
  let n31 : BitVec 1 := (1#1)
  let n32 : BitVec 1 := (0#1)
  let n33 : BitVec 1 := (if n30 then n31 else n32)
  let n34 : BitVec 1 := (1#1)
  let n35 : Bool := (n28 == n34)
  let n36 : BitVec 1 := (1#1)
  let n37 : BitVec 1 := (0#1)
  let n38 : BitVec 1 := (if n35 then n36 else n37)
  let n39 : BitVec 1 := (1#1)
  let n40 : Bool := (n28 == n39)
  let n41 : BitVec 1 := (1#1)
  let n42 : BitVec 1 := (0#1)
  let n43 : BitVec 1 := (if n40 then n41 else n42)
  let n44 : BitVec 1 := (1#1)
  let n45 : Bool := (n28 == n44)
  let n46 : BitVec 1 := (1#1)
  let n47 : BitVec 1 := (0#1)
  let n48 : BitVec 1 := (if n45 then n46 else n47)
  let n49 : BitVec 1 := (1#1)
  let n50 : Bool := (n28 == n49)
  let n51 : BitVec 1 := (1#1)
  let n52 : BitVec 1 := (0#1)
  let n53 : BitVec 1 := (if n50 then n51 else n52)
  let n54 : BitVec 28 := (0#28)
  let n55 : BitVec 32 := (n54 ++ n13)
  let n56 : BitVec 32 := (7#32)
  let n57 : Bool := (n55 == n56)
  let n58 : BitVec 1 := (1#1)
  let n59 : BitVec 1 := (0#1)
  let n60 : BitVec 1 := (if n57 then n58 else n59)
  let n61 : BitVec 32 := (15#32)
  let n62 : Bool := (decide (n61.toNat > n55.toNat))
  let n63 : BitVec 1 := (1#1)
  let n64 : BitVec 1 := (0#1)
  let n65 : BitVec 1 := (if n62 then n63 else n64)
  let n66 : BitVec 32 := (15#32)
  let n67 : Bool := (n55 != n66)
  let n68 : BitVec 1 := (1#1)
  let n69 : BitVec 1 := (0#1)
  let n70 : BitVec 1 := (if n67 then n68 else n69)
  let n71 : BitVec 1 := state.g0.s8
  let n72 : BitVec 1 := state.g0.s0
  let n73 : BitVec 2 := (n72 ++ n0)
  let n74 : BitVec 2 := (1#2)
  let n75 : Bool := (n73 == n74)
  let n76 : BitVec 1 := (1#1)
  let n77 : BitVec 1 := (0#1)
  let n78 : BitVec 1 := (if n75 then n76 else n77)
  let n79 : BitVec 1 := (n71 &&& n78)
  let n80 : BitVec 1 := state.g0.s9
  let n81 : BitVec 1 := state.g0.s1
  let n82 : BitVec 2 := (n81 ++ n0)
  let n83 : BitVec 2 := (1#2)
  let n84 : Bool := (n82 == n83)
  let n85 : BitVec 1 := (1#1)
  let n86 : BitVec 1 := (0#1)
  let n87 : BitVec 1 := (if n84 then n85 else n86)
  let n88 : BitVec 1 := (n80 &&& n87)
  let n89 : BitVec 1 := state.g0.s13
  let n90 : BitVec 1 := state.g0.s10
  let n91 : BitVec 1 := state.g0.s2
  let n92 : BitVec 2 := (n91 ++ n0)
  let n93 : BitVec 2 := (1#2)
  let n94 : Bool := (n92 == n93)
  let n95 : BitVec 1 := (1#1)
  let n96 : BitVec 1 := (0#1)
  let n97 : BitVec 1 := (if n94 then n95 else n96)
  let n98 : BitVec 1 := (n90 &&& n97)
  let n99 : BitVec 1 := state.g0.s14
  let n100 : BitVec 1 := state.g0.s11
  let n101 : BitVec 1 := state.g0.s3
  let n102 : BitVec 2 := (n101 ++ n0)
  let n103 : BitVec 2 := (1#2)
  let n104 : Bool := (n102 == n103)
  let n105 : BitVec 1 := (1#1)
  let n106 : BitVec 1 := (0#1)
  let n107 : BitVec 1 := (if n104 then n105 else n106)
  let n108 : BitVec 1 := (n100 &&& n107)
  let n109 : BitVec 1 := state.g0.s15
  let n110 : BitVec 4 := state.g1.s16
  let n111 : BitVec 1 := state.g0.s12
  let n112 : BitVec 1 := state.g0.s4
  let n113 : BitVec 2 := (n112 ++ n0)
  let n114 : BitVec 2 := (1#2)
  let n115 : Bool := (n113 == n114)
  let n116 : BitVec 1 := (1#1)
  let n117 : BitVec 1 := (0#1)
  let n118 : BitVec 1 := (if n115 then n116 else n117)
  let n119 : BitVec 1 := (n111 &&& n118)
  { outputs := { o0 := n12, o1 := n79, o2 := n88, o3 := n89, o4 := n98, o5 := n99, o6 := n108, o7 := n109, o8 := n110, o9 := n119 }, nextState := { g0 := { s0 := n0, s1 := n0, s2 := n0, s3 := n0, s4 := n0, s5 := n0, s6 := n26, s7 := n12, s8 := n33, s9 := n38, s10 := n43, s11 := n48, s12 := n53, s13 := n60, s14 := n65, s15 := n70 }, g1 := { s16 := n12 } },
    outputDefined := true, transitionDefined := true, checksValid := (n108 == 0 || n109 != 0) && (n98 == 0 || n99 != 0) }

def step (inputs : Inputs) (state : State) : Outputs × State :=
  let r := evaluate inputs state
  (r.outputs, r.nextState)

def initialValid (state : State) : Bool :=
  ((state.g0.s0 &&& (1#1)) == (1#1)) &&
  ((state.g0.s1 &&& (1#1)) == (1#1)) &&
  ((state.g0.s2 &&& (1#1)) == (1#1)) &&
  ((state.g0.s3 &&& (1#1)) == (1#1)) &&
  ((state.g0.s4 &&& (1#1)) == (1#1)) &&
  ((state.g0.s5 &&& (1#1)) == (1#1)) &&
  ((state.g0.s6 &&& (15#4)) == (0#4)) &&
  ((state.g0.s7 &&& (15#4)) == (0#4)) &&
  ((state.g0.s8 &&& (1#1)) == (0#1)) &&
  ((state.g0.s9 &&& (1#1)) == (0#1)) &&
  ((state.g0.s10 &&& (1#1)) == (0#1)) &&
  ((state.g0.s11 &&& (1#1)) == (0#1)) &&
  ((state.g0.s12 &&& (1#1)) == (0#1)) &&
  ((state.g0.s13 &&& (1#1)) == (1#1)) &&
  ((state.g0.s14 &&& (1#1)) == (1#1)) &&
  ((state.g0.s15 &&& (1#1)) == (1#1)) &&
  ((state.g1.s16 &&& (15#4)) == (0#4))
end Exposure.Observed
