-- Generated from locked Yosys FunctionalIR. Fixed circuit; explicit initial state.
import Lean
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
namespace Native.MaskedMemory
structure Inputs where
  i0 : BitVec 1
  i1 : BitVec 2
  i2 : BitVec 2
  i3 : BitVec 2
  i4 : BitVec 1
  i5 : BitVec 1
  i6 : BitVec 2
  i7 : BitVec 2
  i8 : BitVec 8
  i9 : BitVec 8
  i10 : BitVec 4
  i11 : BitVec 4
  i12 : BitVec 4
  i13 : BitVec 4

structure StateGroup0 where
  s0 : BitVec 1
  s1 : BitVec 1
  s2 : BitVec 1
  s3 : BitVec 1
  s4 : BitVec 8
  s5 : BitVec 8
  s6 : BitVec 8
  s7 : BitVec 8
  s8 : BitVec 8
  s9 : BitVec 2
  s10 : BitVec 8
  s11 : BitVec 2
  s12 : BitVec 8
  s13 : BitVec 2
  s14 : BitVec 8
  s15 : BitVec 2

structure StateGroup1 where
  s16 : (BitVec 2 → BitVec 8)

structure State where
  g0 : StateGroup0
  g1 : StateGroup1

structure Outputs where
  o0 : BitVec 8

structure Evaluation where
  outputs : Outputs
  nextState : State
  outputDefined : Bool
  transitionDefined : Bool

def evaluate (inputs : Inputs) (state : State) : Evaluation :=
  let n0 : BitVec 1 := inputs.i0
  let n1 : BitVec 1 := inputs.i5
  let n2 : BitVec 2 := inputs.i7
  let n3 : BitVec 1 := (BitVec.extractLsb' 1 1 n2)
  let n4 : BitVec 1 := (n1 &&& n3)
  let n5 : BitVec 1 := (1#1)
  let n6 : Bool := (n4 == n5)
  let n7 : BitVec 1 := (1#1)
  let n8 : BitVec 1 := (0#1)
  let n9 : BitVec 1 := (if n6 then n7 else n8)
  let n10 : BitVec 1 := (1#1)
  let n11 : Bool := (n9 == n10)
  let n12 : BitVec 8 := (240#8)
  let n13 : BitVec 8 := (0#8)
  let n14 : BitVec 8 := (if n11 then n12 else n13)
  let n15 : BitVec 1 := inputs.i4
  let n16 : BitVec 2 := inputs.i6
  let n17 : BitVec 1 := (BitVec.extractLsb' 1 1 n16)
  let n18 : BitVec 1 := (n15 &&& n17)
  let n19 : BitVec 1 := (1#1)
  let n20 : Bool := (n18 == n19)
  let n21 : BitVec 1 := (1#1)
  let n22 : BitVec 1 := (0#1)
  let n23 : BitVec 1 := (if n20 then n21 else n22)
  let n24 : BitVec 1 := (1#1)
  let n25 : Bool := (n23 == n24)
  let n26 : BitVec 8 := (240#8)
  let n27 : BitVec 8 := (0#8)
  let n28 : BitVec 8 := (if n25 then n26 else n27)
  let n29 : BitVec 1 := (BitVec.extractLsb' 0 1 n2)
  let n30 : BitVec 1 := (n1 &&& n29)
  let n31 : BitVec 1 := (1#1)
  let n32 : Bool := (n30 == n31)
  let n33 : BitVec 1 := (1#1)
  let n34 : BitVec 1 := (0#1)
  let n35 : BitVec 1 := (if n32 then n33 else n34)
  let n36 : BitVec 1 := (1#1)
  let n37 : Bool := (n35 == n36)
  let n38 : BitVec 8 := (15#8)
  let n39 : BitVec 8 := (0#8)
  let n40 : BitVec 8 := (if n37 then n38 else n39)
  let n41 : BitVec 1 := (BitVec.extractLsb' 0 1 n16)
  let n42 : BitVec 1 := (n15 &&& n41)
  let n43 : BitVec 1 := (1#1)
  let n44 : Bool := (n42 == n43)
  let n45 : BitVec 1 := (1#1)
  let n46 : BitVec 1 := (0#1)
  let n47 : BitVec 1 := (if n44 then n45 else n46)
  let n48 : BitVec 1 := (1#1)
  let n49 : Bool := (n47 == n48)
  let n50 : BitVec 8 := (15#8)
  let n51 : BitVec 8 := (0#8)
  let n52 : BitVec 8 := (if n49 then n50 else n51)
  let n53 : BitVec 4 := inputs.i10
  let n54 : BitVec 8 := inputs.i9
  let n55 : BitVec 4 := (BitVec.extractLsb' 4 4 n54)
  let n56 : BitVec 8 := (n55 ++ n53)
  let n57 : BitVec 2 := inputs.i2
  let n58 : BitVec 4 := inputs.i11
  let n59 : BitVec 8 := inputs.i8
  let n60 : BitVec 4 := (BitVec.extractLsb' 4 4 n59)
  let n61 : BitVec 8 := (n60 ++ n58)
  let n62 : BitVec 2 := inputs.i1
  let n63 : BitVec 4 := (BitVec.extractLsb' 0 4 n54)
  let n64 : BitVec 4 := inputs.i12
  let n65 : BitVec 8 := (n64 ++ n63)
  let n66 : BitVec 4 := (BitVec.extractLsb' 0 4 n59)
  let n67 : BitVec 4 := inputs.i13
  let n68 : BitVec 8 := (n67 ++ n66)
  let n69 : (BitVec 2 → BitVec 8) := state.g1.s16
  let n70 : BitVec 2 := state.g0.s15
  let n71 : BitVec 8 := (n69 n70)
  let n72 : BitVec 8 := state.g0.s7
  let n73 : BitVec 1 := state.g0.s3
  let n74 : BitVec 2 := (n0 ++ n73)
  let n75 : BitVec 2 := (2#2)
  let n76 : Bool := (n74 == n75)
  let n77 : BitVec 1 := (1#1)
  let n78 : BitVec 1 := (0#1)
  let n79 : BitVec 1 := (if n76 then n77 else n78)
  let n80 : BitVec 1 := (1#1)
  let n81 : Bool := (n79 == n80)
  let n82 : BitVec 8 := (0#8)
  let n83 : BitVec 8 := (if n81 then n72 else n82)
  let n84 : BitVec 8 := (~~~n83)
  let n85 : BitVec 8 := (n71 &&& n84)
  let n86 : BitVec 8 := state.g0.s14
  let n87 : BitVec 8 := (n86 &&& n83)
  let n88 : BitVec 8 := (n85 ||| n87)
  let n89 : (BitVec 2 → BitVec 8) := (fun address => if address == n70 then n88 else n69 address)
  let n90 : BitVec 2 := state.g0.s13
  let n91 : BitVec 8 := (n89 n90)
  let n92 : BitVec 8 := state.g0.s6
  let n93 : BitVec 1 := state.g0.s2
  let n94 : BitVec 2 := (n0 ++ n93)
  let n95 : BitVec 2 := (2#2)
  let n96 : Bool := (n94 == n95)
  let n97 : BitVec 1 := (1#1)
  let n98 : BitVec 1 := (0#1)
  let n99 : BitVec 1 := (if n96 then n97 else n98)
  let n100 : BitVec 1 := (1#1)
  let n101 : Bool := (n99 == n100)
  let n102 : BitVec 8 := (0#8)
  let n103 : BitVec 8 := (if n101 then n92 else n102)
  let n104 : BitVec 8 := (~~~n103)
  let n105 : BitVec 8 := (n91 &&& n104)
  let n106 : BitVec 8 := state.g0.s12
  let n107 : BitVec 8 := (n106 &&& n103)
  let n108 : BitVec 8 := (n105 ||| n107)
  let n109 : (BitVec 2 → BitVec 8) := (fun address => if address == n90 then n108 else n89 address)
  let n110 : BitVec 2 := state.g0.s11
  let n111 : BitVec 8 := (n109 n110)
  let n112 : BitVec 8 := state.g0.s5
  let n113 : BitVec 1 := state.g0.s1
  let n114 : BitVec 2 := (n0 ++ n113)
  let n115 : BitVec 2 := (2#2)
  let n116 : Bool := (n114 == n115)
  let n117 : BitVec 1 := (1#1)
  let n118 : BitVec 1 := (0#1)
  let n119 : BitVec 1 := (if n116 then n117 else n118)
  let n120 : BitVec 1 := (1#1)
  let n121 : Bool := (n119 == n120)
  let n122 : BitVec 8 := (0#8)
  let n123 : BitVec 8 := (if n121 then n112 else n122)
  let n124 : BitVec 8 := (~~~n123)
  let n125 : BitVec 8 := (n111 &&& n124)
  let n126 : BitVec 8 := state.g0.s10
  let n127 : BitVec 8 := (n126 &&& n123)
  let n128 : BitVec 8 := (n125 ||| n127)
  let n129 : (BitVec 2 → BitVec 8) := (fun address => if address == n110 then n128 else n109 address)
  let n130 : BitVec 2 := state.g0.s9
  let n131 : BitVec 8 := (n129 n130)
  let n132 : BitVec 8 := state.g0.s4
  let n133 : BitVec 1 := state.g0.s0
  let n134 : BitVec 2 := (n0 ++ n133)
  let n135 : BitVec 2 := (2#2)
  let n136 : Bool := (n134 == n135)
  let n137 : BitVec 1 := (1#1)
  let n138 : BitVec 1 := (0#1)
  let n139 : BitVec 1 := (if n136 then n137 else n138)
  let n140 : BitVec 1 := (1#1)
  let n141 : Bool := (n139 == n140)
  let n142 : BitVec 8 := (0#8)
  let n143 : BitVec 8 := (if n141 then n132 else n142)
  let n144 : BitVec 8 := (~~~n143)
  let n145 : BitVec 8 := (n131 &&& n144)
  let n146 : BitVec 8 := state.g0.s8
  let n147 : BitVec 8 := (n146 &&& n143)
  let n148 : BitVec 8 := (n145 ||| n147)
  let n149 : (BitVec 2 → BitVec 8) := (fun address => if address == n130 then n148 else n129 address)
  let n150 : BitVec 2 := inputs.i3
  let n151 : BitVec 8 := (n149 n150)
  { outputs := { o0 := n151 }, nextState := { g0 := { s0 := n0, s1 := n0, s2 := n0, s3 := n0, s4 := n14, s5 := n28, s6 := n40, s7 := n52, s8 := n56, s9 := n57, s10 := n61, s11 := n62, s12 := n65, s13 := n57, s14 := n68, s15 := n62 }, g1 := { s16 := n149 } },
    outputDefined := true, transitionDefined := true }

def step (inputs : Inputs) (state : State) : Outputs × State :=
  let r := evaluate inputs state
  (r.outputs, r.nextState)

def initialValid (state : State) : Bool :=
  ((state.g0.s0 &&& (1#1)) == (1#1)) &&
  ((state.g0.s1 &&& (1#1)) == (1#1)) &&
  ((state.g0.s2 &&& (1#1)) == (1#1)) &&
  ((state.g0.s3 &&& (1#1)) == (1#1))
end Native.MaskedMemory
