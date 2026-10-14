-- Generated from locked Yosys FunctionalIR. Fixed circuit; explicit initial state.
import Lean
set_option maxRecDepth 65536
set_option maxHeartbeats 0
namespace Yosys.Handshake65x3
structure Inputs where
  i0 : BitVec 1
  i1 : BitVec 1
  i2 : BitVec 65
  i3 : BitVec 1
  i4 : BitVec 1

structure State where
  s0 : BitVec 1
  s1 : BitVec 65
  s2 : BitVec 65
  s3 : BitVec 1
  s4 : BitVec 1
  s5 : BitVec 1
  s6 : BitVec 1
  s7 : BitVec 1
  s8 : BitVec 65
  s9 : BitVec 65
  s10 : BitVec 1
  s11 : BitVec 1
  s12 : BitVec 1
  s13 : BitVec 1
  s14 : BitVec 65
  s15 : BitVec 65
  s16 : BitVec 1
  s17 : BitVec 1

structure Outputs where
  o0 : BitVec 1
  o1 : BitVec 65
  o2 : BitVec 1

structure Evaluation where
  outputs : Outputs
  nextState : State
  outputDefined : Bool
  transitionDefined : Bool

def evaluate (inputs : Inputs) (state : State) : Evaluation :=
  let n0 : BitVec 1 := inputs.i0
  let n1 : BitVec 65 := state.s2
  let n2 : BitVec 65 := state.s1
  let n3 : BitVec 1 := state.s0
  let n4 : BitVec 2 := (n3 ++ n0)
  let n5 : BitVec 2 := (1#2)
  let n6 : Bool := (n4 == n5)
  let n7 : BitVec 1 := (1#1)
  let n8 : BitVec 1 := (0#1)
  let n9 : BitVec 1 := (if n6 then n7 else n8)
  let n10 : BitVec 1 := (1#1)
  let n11 : Bool := (n9 == n10)
  let n12 : BitVec 65 := (if n11 then n2 else n1)
  let n13 : BitVec 65 := inputs.i2
  let n14 : BitVec 1 := state.s11
  let n15 : BitVec 1 := state.s10
  let n16 : BitVec 1 := state.s5
  let n17 : BitVec 2 := (n16 ++ n0)
  let n18 : BitVec 2 := (1#2)
  let n19 : Bool := (n17 == n18)
  let n20 : BitVec 1 := (1#1)
  let n21 : BitVec 1 := (0#1)
  let n22 : BitVec 1 := (if n19 then n20 else n21)
  let n23 : BitVec 1 := (1#1)
  let n24 : Bool := (n22 == n23)
  let n25 : BitVec 1 := (if n24 then n15 else n14)
  let n26 : BitVec 1 := (~~~n25)
  let n27 : BitVec 1 := state.s7
  let n28 : BitVec 1 := state.s6
  let n29 : BitVec 1 := state.s3
  let n30 : BitVec 2 := (n29 ++ n0)
  let n31 : BitVec 2 := (1#2)
  let n32 : Bool := (n30 == n31)
  let n33 : BitVec 1 := (1#1)
  let n34 : BitVec 1 := (0#1)
  let n35 : BitVec 1 := (if n32 then n33 else n34)
  let n36 : BitVec 1 := (1#1)
  let n37 : Bool := (n35 == n36)
  let n38 : BitVec 1 := (if n37 then n28 else n27)
  let n39 : BitVec 1 := (~~~n38)
  let n40 : BitVec 1 := state.s17
  let n41 : BitVec 1 := state.s16
  let n42 : BitVec 1 := state.s13
  let n43 : BitVec 2 := (n42 ++ n0)
  let n44 : BitVec 2 := (1#2)
  let n45 : Bool := (n43 == n44)
  let n46 : BitVec 1 := (1#1)
  let n47 : BitVec 1 := (0#1)
  let n48 : BitVec 1 := (if n45 then n46 else n47)
  let n49 : BitVec 1 := (1#1)
  let n50 : Bool := (n48 == n49)
  let n51 : BitVec 1 := (if n50 then n41 else n40)
  let n52 : BitVec 1 := (~~~n51)
  let n53 : BitVec 1 := inputs.i4
  let n54 : BitVec 1 := (n52 ||| n53)
  let n55 : BitVec 1 := (n39 ||| n54)
  let n56 : BitVec 1 := (n26 ||| n55)
  let n57 : BitVec 1 := inputs.i3
  let n58 : BitVec 1 := (n56 &&& n57)
  let n59 : BitVec 1 := (1#1)
  let n60 : Bool := (n58 == n59)
  let n61 : BitVec 65 := (if n60 then n13 else n12)
  let n62 : BitVec 1 := (1#1)
  let n63 : Bool := (n55 == n62)
  let n64 : BitVec 1 := (if n63 then n25 else n38)
  let n65 : BitVec 1 := inputs.i1
  let n66 : BitVec 1 := (1#1)
  let n67 : Bool := (n65 == n66)
  let n68 : BitVec 1 := (0#1)
  let n69 : BitVec 1 := (if n67 then n68 else n64)
  let n70 : BitVec 65 := state.s9
  let n71 : BitVec 65 := state.s8
  let n72 : BitVec 1 := state.s4
  let n73 : BitVec 2 := (n72 ++ n0)
  let n74 : BitVec 2 := (1#2)
  let n75 : Bool := (n73 == n74)
  let n76 : BitVec 1 := (1#1)
  let n77 : BitVec 1 := (0#1)
  let n78 : BitVec 1 := (if n75 then n76 else n77)
  let n79 : BitVec 1 := (1#1)
  let n80 : Bool := (n78 == n79)
  let n81 : BitVec 65 := (if n80 then n71 else n70)
  let n82 : BitVec 1 := (n55 &&& n25)
  let n83 : BitVec 1 := (1#1)
  let n84 : Bool := (n82 == n83)
  let n85 : BitVec 65 := (if n84 then n12 else n81)
  let n86 : BitVec 1 := (1#1)
  let n87 : Bool := (n56 == n86)
  let n88 : BitVec 1 := (if n87 then n57 else n25)
  let n89 : BitVec 1 := (1#1)
  let n90 : Bool := (n65 == n89)
  let n91 : BitVec 1 := (0#1)
  let n92 : BitVec 1 := (if n90 then n91 else n88)
  let n93 : BitVec 65 := state.s15
  let n94 : BitVec 65 := state.s14
  let n95 : BitVec 1 := state.s12
  let n96 : BitVec 2 := (n95 ++ n0)
  let n97 : BitVec 2 := (1#2)
  let n98 : Bool := (n96 == n97)
  let n99 : BitVec 1 := (1#1)
  let n100 : BitVec 1 := (0#1)
  let n101 : BitVec 1 := (if n98 then n99 else n100)
  let n102 : BitVec 1 := (1#1)
  let n103 : Bool := (n101 == n102)
  let n104 : BitVec 65 := (if n103 then n94 else n93)
  let n105 : BitVec 1 := (n54 &&& n38)
  let n106 : BitVec 1 := (1#1)
  let n107 : Bool := (n105 == n106)
  let n108 : BitVec 65 := (if n107 then n81 else n104)
  let n109 : BitVec 1 := (1#1)
  let n110 : Bool := (n54 == n109)
  let n111 : BitVec 1 := (if n110 then n38 else n51)
  let n112 : BitVec 1 := (1#1)
  let n113 : Bool := (n65 == n112)
  let n114 : BitVec 1 := (0#1)
  let n115 : BitVec 1 := (if n113 then n114 else n111)
  { outputs := { o0 := n56, o1 := n104, o2 := n51 }, nextState := { s0 := n0, s1 := n61, s2 := n12, s3 := n0, s4 := n0, s5 := n0, s6 := n69, s7 := n38, s8 := n85, s9 := n81, s10 := n92, s11 := n25, s12 := n0, s13 := n0, s14 := n108, s15 := n104, s16 := n115, s17 := n51 },
    outputDefined := true, transitionDefined := true }

def step (inputs : Inputs) (state : State) : Outputs × State :=
  let r := evaluate inputs state
  (r.outputs, r.nextState)

def initialValid (state : State) : Bool :=
  ((state.s0 &&& (1#1)) == (1#1)) &&
  ((state.s1 &&& (36893488147419103231#65)) == (0#65)) &&
  ((state.s3 &&& (1#1)) == (1#1)) &&
  ((state.s4 &&& (1#1)) == (1#1)) &&
  ((state.s5 &&& (1#1)) == (1#1)) &&
  ((state.s6 &&& (1#1)) == (0#1)) &&
  ((state.s8 &&& (36893488147419103231#65)) == (0#65)) &&
  ((state.s10 &&& (1#1)) == (0#1)) &&
  ((state.s12 &&& (1#1)) == (1#1)) &&
  ((state.s13 &&& (1#1)) == (1#1)) &&
  ((state.s14 &&& (36893488147419103231#65)) == (0#65)) &&
  ((state.s16 &&& (1#1)) == (0#1))
end Yosys.Handshake65x3
