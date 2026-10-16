-- Generated from locked Yosys FunctionalIR. Fixed circuit; explicit initial state.
import Lean
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
namespace SRAM.SramArray1P
structure Inputs where
  i0 : BitVec 1
  i1 : BitVec 1
  i2 : BitVec 1
  i3 : BitVec 1
  i4 : BitVec 1
  i5 : BitVec 1
  i6 : BitVec 3
  i7 : BitVec 3
  i8 : BitVec 16
  i9 : BitVec 2
  i10 : BitVec 8
  i11 : BitVec 8
  i12 : BitVec 16

structure State where
  s0 : BitVec 1
  s1 : BitVec 1
  s2 : BitVec 1
  s3 : BitVec 1
  s4 : BitVec 1
  s5 : BitVec 1
  s6 : BitVec 1
  s7 : BitVec 1
  s8 : BitVec 1
  s9 : BitVec 3
  s10 : BitVec 3
  s11 : BitVec 16
  s12 : BitVec 16
  s13 : BitVec 16
  s14 : BitVec 3
  s15 : BitVec 16
  s16 : BitVec 3
  s17 : (BitVec 3 → BitVec 16)

structure Outputs where
  o0 : BitVec 16

structure Evaluation where
  outputs : Outputs
  nextState : State
  outputDefined : Bool
  transitionDefined : Bool

def evaluate (inputs : Inputs) (state : State) : Evaluation :=
  let n0 : BitVec 1 := inputs.i2
  let n1 : BitVec 1 := inputs.i5
  let n2 : BitVec 2 := inputs.i9
  let n3 : BitVec 2 := (0#2)
  let n4 : Bool := (n2 != n3)
  let n5 : BitVec 1 := (1#1)
  let n6 : BitVec 1 := (0#1)
  let n7 : BitVec 1 := (if n4 then n5 else n6)
  let n8 : BitVec 1 := (n1 &&& n7)
  let n9 : BitVec 1 := state.s4
  let n10 : BitVec 1 := state.s3
  let n11 : BitVec 1 := state.s0
  let n12 : BitVec 2 := (n11 ++ n0)
  let n13 : BitVec 2 := (1#2)
  let n14 : Bool := (n12 == n13)
  let n15 : BitVec 1 := (1#1)
  let n16 : BitVec 1 := (0#1)
  let n17 : BitVec 1 := (if n14 then n15 else n16)
  let n18 : BitVec 1 := (1#1)
  let n19 : Bool := (n17 == n18)
  let n20 : BitVec 1 := (if n19 then n10 else n9)
  let n21 : BitVec 1 := inputs.i4
  let n22 : BitVec 1 := (n21 ||| n1)
  let n23 : BitVec 1 := state.s8
  let n24 : BitVec 1 := state.s7
  let n25 : BitVec 1 := state.s1
  let n26 : BitVec 2 := (n25 ++ n0)
  let n27 : BitVec 2 := (1#2)
  let n28 : Bool := (n26 == n27)
  let n29 : BitVec 1 := (1#1)
  let n30 : BitVec 1 := (0#1)
  let n31 : BitVec 1 := (if n28 then n29 else n30)
  let n32 : BitVec 1 := (1#1)
  let n33 : Bool := (n31 == n32)
  let n34 : BitVec 1 := (if n33 then n24 else n23)
  let n35 : BitVec 3 := inputs.i6
  let n36 : BitVec 3 := inputs.i7
  let n37 : BitVec 1 := (1#1)
  let n38 : Bool := (n1 == n37)
  let n39 : BitVec 3 := (if n38 then n36 else n35)
  let n40 : BitVec 3 := state.s10
  let n41 : BitVec 3 := state.s9
  let n42 : BitVec 1 := state.s2
  let n43 : BitVec 2 := (n42 ++ n0)
  let n44 : BitVec 2 := (1#2)
  let n45 : Bool := (n43 == n44)
  let n46 : BitVec 1 := (1#1)
  let n47 : BitVec 1 := (0#1)
  let n48 : BitVec 1 := (if n45 then n46 else n47)
  let n49 : BitVec 1 := (1#1)
  let n50 : Bool := (n48 == n49)
  let n51 : BitVec 3 := (if n50 then n41 else n40)
  let n52 : BitVec 1 := (BitVec.extractLsb' 0 1 n2)
  let n53 : BitVec 1 := (n1 &&& n52)
  let n54 : BitVec 1 := (BitVec.extractLsb' 1 1 n2)
  let n55 : BitVec 1 := (n1 &&& n54)
  let n56 : BitVec 2 := (n55 ++ n53)
  let n57 : BitVec 1 := (BitVec.extractLsb' 1 1 n56)
  let n58 : BitVec 1 := (n22 &&& n57)
  let n59 : BitVec 1 := (n58 &&& n8)
  let n60 : BitVec 1 := (1#1)
  let n61 : Bool := (n59 == n60)
  let n62 : BitVec 1 := (1#1)
  let n63 : BitVec 1 := (0#1)
  let n64 : BitVec 1 := (if n61 then n62 else n63)
  let n65 : BitVec 1 := (1#1)
  let n66 : Bool := (n64 == n65)
  let n67 : BitVec 16 := (65280#16)
  let n68 : BitVec 16 := (0#16)
  let n69 : BitVec 16 := (if n66 then n67 else n68)
  let n70 : BitVec 1 := (n22 &&& n53)
  let n71 : BitVec 1 := (n70 &&& n8)
  let n72 : BitVec 1 := (1#1)
  let n73 : Bool := (n71 == n72)
  let n74 : BitVec 1 := (1#1)
  let n75 : BitVec 1 := (0#1)
  let n76 : BitVec 1 := (if n73 then n74 else n75)
  let n77 : BitVec 1 := (1#1)
  let n78 : Bool := (n76 == n77)
  let n79 : BitVec 16 := (255#16)
  let n80 : BitVec 16 := (0#16)
  let n81 : BitVec 16 := (if n78 then n79 else n80)
  let n82 : BitVec 8 := inputs.i10
  let n83 : BitVec 16 := inputs.i8
  let n84 : BitVec 8 := (BitVec.extractLsb' 8 8 n83)
  let n85 : BitVec 16 := (n84 ++ n82)
  let n86 : BitVec 8 := (BitVec.extractLsb' 0 8 n83)
  let n87 : BitVec 8 := inputs.i11
  let n88 : BitVec 16 := (n87 ++ n86)
  let n89 : (BitVec 3 → BitVec 16) := state.s17
  let n90 : BitVec 3 := state.s16
  let n91 : BitVec 16 := (n89 n90)
  let n92 : BitVec 16 := state.s12
  let n93 : BitVec 1 := state.s6
  let n94 : BitVec 2 := (n0 ++ n93)
  let n95 : BitVec 2 := (2#2)
  let n96 : Bool := (n94 == n95)
  let n97 : BitVec 1 := (1#1)
  let n98 : BitVec 1 := (0#1)
  let n99 : BitVec 1 := (if n96 then n97 else n98)
  let n100 : BitVec 1 := (1#1)
  let n101 : Bool := (n99 == n100)
  let n102 : BitVec 16 := (0#16)
  let n103 : BitVec 16 := (if n101 then n92 else n102)
  let n104 : BitVec 16 := (~~~n103)
  let n105 : BitVec 16 := (n91 &&& n104)
  let n106 : BitVec 16 := state.s15
  let n107 : BitVec 16 := (n106 &&& n103)
  let n108 : BitVec 16 := (n105 ||| n107)
  let n109 : (BitVec 3 → BitVec 16) := (fun address => if address == n90 then n108 else n89 address)
  let n110 : BitVec 3 := state.s14
  let n111 : BitVec 16 := (n109 n110)
  let n112 : BitVec 16 := state.s11
  let n113 : BitVec 1 := state.s5
  let n114 : BitVec 2 := (n0 ++ n113)
  let n115 : BitVec 2 := (2#2)
  let n116 : Bool := (n114 == n115)
  let n117 : BitVec 1 := (1#1)
  let n118 : BitVec 1 := (0#1)
  let n119 : BitVec 1 := (if n116 then n117 else n118)
  let n120 : BitVec 1 := (1#1)
  let n121 : Bool := (n119 == n120)
  let n122 : BitVec 16 := (0#16)
  let n123 : BitVec 16 := (if n121 then n112 else n122)
  let n124 : BitVec 16 := (~~~n123)
  let n125 : BitVec 16 := (n111 &&& n124)
  let n126 : BitVec 16 := state.s13
  let n127 : BitVec 16 := (n126 &&& n123)
  let n128 : BitVec 16 := (n125 ||| n127)
  let n129 : (BitVec 3 → BitVec 16) := (fun address => if address == n110 then n128 else n109 address)
  let n130 : BitVec 16 := inputs.i12
  let n131 : BitVec 16 := (n129 n51)
  let n132 : BitVec 1 := (~~~n20)
  let n133 : BitVec 1 := (n34 &&& n132)
  let n134 : BitVec 1 := (1#1)
  let n135 : Bool := (n133 == n134)
  let n136 : BitVec 16 := (if n135 then n131 else n130)
  { outputs := { o0 := n136 }, nextState := { s0 := n0, s1 := n0, s2 := n0, s3 := n8, s4 := n20, s5 := n0, s6 := n0, s7 := n22, s8 := n34, s9 := n39, s10 := n51, s11 := n69, s12 := n81, s13 := n85, s14 := n39, s15 := n88, s16 := n39, s17 := n129 },
    outputDefined := true, transitionDefined := true }

def step (inputs : Inputs) (state : State) : Outputs × State :=
  let r := evaluate inputs state
  (r.outputs, r.nextState)

def initialValid (state : State) : Bool :=
  ((state.s0 &&& (1#1)) == (1#1)) &&
  ((state.s1 &&& (1#1)) == (1#1)) &&
  ((state.s2 &&& (1#1)) == (1#1)) &&
  ((state.s3 &&& (1#1)) == (0#1)) &&
  ((state.s5 &&& (1#1)) == (1#1)) &&
  ((state.s6 &&& (1#1)) == (1#1)) &&
  ((state.s7 &&& (1#1)) == (0#1)) &&
  ((state.s9 &&& (7#3)) == (0#3))
end SRAM.SramArray1P
