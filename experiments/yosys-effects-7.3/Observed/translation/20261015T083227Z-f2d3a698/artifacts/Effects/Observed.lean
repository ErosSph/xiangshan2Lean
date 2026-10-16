-- Generated from locked Yosys FunctionalIR. Fixed circuit; explicit initial state.
import Lean
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
namespace Effects.Observed
structure Inputs where
  i0 : BitVec 1
  i1 : BitVec 1
  i2 : BitVec 1
  i3 : BitVec 4
  i4 : BitVec 4
  i5 : BitVec 4

structure State where
  s0 : BitVec 1
  s1 : BitVec 1
  s2 : BitVec 1
  s3 : BitVec 1
  s4 : BitVec 1
  s5 : BitVec 4
  s6 : BitVec 4
  s7 : BitVec 1
  s8 : BitVec 1
  s9 : BitVec 1
  s10 : BitVec 1
  s11 : BitVec 1
  s12 : BitVec 8
  s13 : BitVec 1
  s14 : BitVec 1

structure Outputs where
  o0 : BitVec 4
  o1 : BitVec 1
  o2 : BitVec 1
  o3 : BitVec 1
  o4 : BitVec 8
  o5 : BitVec 1
  o6 : BitVec 1
  o7 : BitVec 1
  o8 : BitVec 1

structure Evaluation where
  outputs : Outputs
  nextState : State
  outputDefined : Bool
  transitionDefined : Bool
  checksValid : Bool

def evaluate (inputs : Inputs) (state : State) : Evaluation :=
  let n0 : BitVec 1 := inputs.i1
  let n1 : BitVec 4 := state.s6
  let n2 : BitVec 4 := state.s5
  let n3 : BitVec 1 := state.s4
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
  let n18 : BitVec 4 := inputs.i5
  let n19 : BitVec 1 := inputs.i0
  let n20 : BitVec 1 := (1#1)
  let n21 : Bool := (n19 == n20)
  let n22 : BitVec 4 := (if n21 then n18 else n17)
  let n23 : BitVec 1 := (1#1)
  let n24 : Bool := (n19 == n23)
  let n25 : BitVec 4 := (0#4)
  let n26 : BitVec 4 := (if n24 then n25 else n22)
  let n27 : BitVec 1 := (~~~n19)
  let n28 : BitVec 1 := (1#1)
  let n29 : Bool := (n27 == n28)
  let n30 : BitVec 1 := (1#1)
  let n31 : BitVec 1 := (0#1)
  let n32 : BitVec 1 := (if n29 then n30 else n31)
  let n33 : BitVec 1 := (1#1)
  let n34 : Bool := (n27 == n33)
  let n35 : BitVec 1 := (1#1)
  let n36 : BitVec 1 := (0#1)
  let n37 : BitVec 1 := (if n34 then n35 else n36)
  let n38 : BitVec 1 := (1#1)
  let n39 : Bool := (n27 == n38)
  let n40 : BitVec 1 := (1#1)
  let n41 : BitVec 1 := (0#1)
  let n42 : BitVec 1 := (if n39 then n40 else n41)
  let n43 : BitVec 1 := (1#1)
  let n44 : Bool := (n27 == n43)
  let n45 : BitVec 1 := (1#1)
  let n46 : BitVec 1 := (0#1)
  let n47 : BitVec 1 := (if n44 then n45 else n46)
  let n48 : BitVec 28 := (0#28)
  let n49 : BitVec 32 := (n48 ++ n12)
  let n50 : BitVec 32 := (3#32)
  let n51 : Bool := (n49 == n50)
  let n52 : BitVec 1 := (1#1)
  let n53 : BitVec 1 := (0#1)
  let n54 : BitVec 1 := (if n51 then n52 else n53)
  let n55 : BitVec 8 := (n13 ++ n12)
  let n56 : BitVec 4 := inputs.i4
  let n57 : Bool := (n12 == n56)
  let n58 : BitVec 1 := (1#1)
  let n59 : BitVec 1 := (0#1)
  let n60 : BitVec 1 := (if n57 then n58 else n59)
  let n61 : BitVec 28 := (0#28)
  let n62 : BitVec 32 := (n61 ++ n13)
  let n63 : BitVec 32 := (12#32)
  let n64 : Bool := (decide (n63.toNat > n62.toNat))
  let n65 : BitVec 1 := (1#1)
  let n66 : BitVec 1 := (0#1)
  let n67 : BitVec 1 := (if n64 then n65 else n66)
  let n68 : BitVec 1 := state.s7
  let n69 : BitVec 1 := state.s0
  let n70 : BitVec 2 := (n69 ++ n0)
  let n71 : BitVec 2 := (1#2)
  let n72 : Bool := (n70 == n71)
  let n73 : BitVec 1 := (1#1)
  let n74 : BitVec 1 := (0#1)
  let n75 : BitVec 1 := (if n72 then n73 else n74)
  let n76 : BitVec 1 := (n68 &&& n75)
  let n77 : BitVec 1 := state.s11
  let n78 : BitVec 1 := state.s8
  let n79 : BitVec 1 := state.s1
  let n80 : BitVec 2 := (n79 ++ n0)
  let n81 : BitVec 2 := (1#2)
  let n82 : Bool := (n80 == n81)
  let n83 : BitVec 1 := (1#1)
  let n84 : BitVec 1 := (0#1)
  let n85 : BitVec 1 := (if n82 then n83 else n84)
  let n86 : BitVec 1 := (n78 &&& n85)
  let n87 : BitVec 8 := state.s12
  let n88 : BitVec 1 := state.s9
  let n89 : BitVec 1 := state.s2
  let n90 : BitVec 2 := (n89 ++ n0)
  let n91 : BitVec 2 := (1#2)
  let n92 : Bool := (n90 == n91)
  let n93 : BitVec 1 := (1#1)
  let n94 : BitVec 1 := (0#1)
  let n95 : BitVec 1 := (if n92 then n93 else n94)
  let n96 : BitVec 1 := (n88 &&& n95)
  let n97 : BitVec 1 := state.s13
  let n98 : BitVec 1 := state.s10
  let n99 : BitVec 1 := state.s3
  let n100 : BitVec 2 := (n99 ++ n0)
  let n101 : BitVec 2 := (1#2)
  let n102 : Bool := (n100 == n101)
  let n103 : BitVec 1 := (1#1)
  let n104 : BitVec 1 := (0#1)
  let n105 : BitVec 1 := (if n102 then n103 else n104)
  let n106 : BitVec 1 := (n98 &&& n105)
  let n107 : BitVec 1 := state.s14
  { outputs := { o0 := n12, o1 := n76, o2 := n77, o3 := n86, o4 := n87, o5 := n96, o6 := n97, o7 := n106, o8 := n107 }, nextState := { s0 := n0, s1 := n0, s2 := n0, s3 := n0, s4 := n0, s5 := n26, s6 := n12, s7 := n32, s8 := n37, s9 := n42, s10 := n47, s11 := n54, s12 := n55, s13 := n60, s14 := n67 },
    outputDefined := true, transitionDefined := true, checksValid := (n96 == 0 || n97 != 0) && (n106 == 0 || n107 != 0) }

def step (inputs : Inputs) (state : State) : Outputs × State :=
  let r := evaluate inputs state
  (r.outputs, r.nextState)

def initialValid (state : State) : Bool :=
  ((state.s0 &&& (1#1)) == (1#1)) &&
  ((state.s1 &&& (1#1)) == (1#1)) &&
  ((state.s2 &&& (1#1)) == (1#1)) &&
  ((state.s3 &&& (1#1)) == (1#1)) &&
  ((state.s4 &&& (1#1)) == (1#1)) &&
  ((state.s5 &&& (15#4)) == (0#4)) &&
  ((state.s6 &&& (15#4)) == (0#4)) &&
  ((state.s7 &&& (1#1)) == (0#1)) &&
  ((state.s8 &&& (1#1)) == (0#1)) &&
  ((state.s9 &&& (1#1)) == (0#1)) &&
  ((state.s10 &&& (1#1)) == (0#1)) &&
  ((state.s11 &&& (1#1)) == (1#1)) &&
  ((state.s12 &&& (255#8)) == (0#8)) &&
  ((state.s13 &&& (1#1)) == (1#1)) &&
  ((state.s14 &&& (1#1)) == (1#1))
end Effects.Observed
