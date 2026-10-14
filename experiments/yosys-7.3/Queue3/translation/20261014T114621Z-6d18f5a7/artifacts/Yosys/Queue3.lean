-- Generated from locked Yosys FunctionalIR. Fixed circuit; explicit initial state.
import Lean
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
namespace Yosys.Queue3
structure Inputs where
  i0 : BitVec 1
  i1 : BitVec 1
  i2 : BitVec 8
  i3 : BitVec 1
  i4 : BitVec 1
  i5 : BitVec 8
  i6 : BitVec 2
  i7 : BitVec 2
  i8 : BitVec 1

structure State where
  s0 : BitVec 1
  s1 : BitVec 1
  s2 : BitVec 1
  s3 : BitVec 1
  s4 : BitVec 2
  s5 : BitVec 2
  s6 : BitVec 2
  s7 : BitVec 2
  s8 : BitVec 8
  s9 : BitVec 1
  s10 : BitVec 1
  s11 : BitVec 8
  s12 : BitVec 2
  s13 : (BitVec 2 → BitVec 8)

structure Outputs where
  o0 : BitVec 2
  o1 : BitVec 1
  o2 : BitVec 8
  o3 : BitVec 1

structure Evaluation where
  outputs : Outputs
  nextState : State
  outputDefined : Bool
  transitionDefined : Bool

def evaluate (inputs : Inputs) (state : State) : Evaluation :=
  let n0 : BitVec 1 := inputs.i1
  let n1 : BitVec 2 := state.s5
  let n2 : BitVec 2 := state.s4
  let n3 : BitVec 1 := state.s0
  let n4 : BitVec 2 := (n3 ++ n0)
  let n5 : BitVec 2 := (1#2)
  let n6 : Bool := (n4 == n5)
  let n7 : BitVec 1 := (1#1)
  let n8 : BitVec 1 := (0#1)
  let n9 : BitVec 1 := (if n6 then n7 else n8)
  let n10 : BitVec 1 := (1#1)
  let n11 : Bool := (n9 == n10)
  let n12 : BitVec 2 := (if n11 then n2 else n1)
  let n13 : BitVec 2 := (1#2)
  let n14 : BitVec 2 := (n12 + n13)
  let n15 : BitVec 2 := (2#2)
  let n16 : Bool := (n12 == n15)
  let n17 : BitVec 1 := (1#1)
  let n18 : BitVec 1 := (0#1)
  let n19 : BitVec 1 := (if n16 then n17 else n18)
  let n20 : BitVec 1 := (1#1)
  let n21 : Bool := (n19 == n20)
  let n22 : BitVec 2 := (0#2)
  let n23 : BitVec 2 := (if n21 then n22 else n14)
  let n24 : BitVec 2 := state.s7
  let n25 : BitVec 2 := state.s6
  let n26 : BitVec 1 := state.s1
  let n27 : BitVec 2 := (n26 ++ n0)
  let n28 : BitVec 2 := (1#2)
  let n29 : Bool := (n27 == n28)
  let n30 : BitVec 1 := (1#1)
  let n31 : BitVec 1 := (0#1)
  let n32 : BitVec 1 := (if n29 then n30 else n31)
  let n33 : BitVec 1 := (1#1)
  let n34 : Bool := (n32 == n33)
  let n35 : BitVec 2 := (if n34 then n25 else n24)
  let n36 : Bool := (n12 == n35)
  let n37 : BitVec 1 := (1#1)
  let n38 : BitVec 1 := (0#1)
  let n39 : BitVec 1 := (if n36 then n37 else n38)
  let n40 : BitVec 1 := state.s10
  let n41 : BitVec 1 := state.s9
  let n42 : BitVec 1 := state.s2
  let n43 : BitVec 2 := (n42 ++ n0)
  let n44 : BitVec 2 := (1#2)
  let n45 : Bool := (n43 == n44)
  let n46 : BitVec 1 := (1#1)
  let n47 : BitVec 1 := (0#1)
  let n48 : BitVec 1 := (if n45 then n46 else n47)
  let n49 : BitVec 1 := (1#1)
  let n50 : Bool := (n48 == n49)
  let n51 : BitVec 1 := (if n50 then n41 else n40)
  let n52 : BitVec 1 := (n39 &&& n51)
  let n53 : BitVec 1 := (~~~n52)
  let n54 : BitVec 1 := inputs.i3
  let n55 : BitVec 1 := (n53 &&& n54)
  let n56 : BitVec 1 := (1#1)
  let n57 : Bool := (n55 == n56)
  let n58 : BitVec 2 := (if n57 then n23 else n12)
  let n59 : BitVec 2 := inputs.i7
  let n60 : BitVec 1 := inputs.i0
  let n61 : BitVec 1 := (1#1)
  let n62 : Bool := (n60 == n61)
  let n63 : BitVec 2 := (if n62 then n59 else n58)
  let n64 : BitVec 1 := (1#1)
  let n65 : Bool := (n60 == n64)
  let n66 : BitVec 2 := (0#2)
  let n67 : BitVec 2 := (if n65 then n66 else n63)
  let n68 : BitVec 2 := (1#2)
  let n69 : BitVec 2 := (n35 + n68)
  let n70 : BitVec 2 := (2#2)
  let n71 : Bool := (n35 == n70)
  let n72 : BitVec 1 := (1#1)
  let n73 : BitVec 1 := (0#1)
  let n74 : BitVec 1 := (if n71 then n72 else n73)
  let n75 : BitVec 1 := (1#1)
  let n76 : Bool := (n74 == n75)
  let n77 : BitVec 2 := (0#2)
  let n78 : BitVec 2 := (if n76 then n77 else n69)
  let n79 : BitVec 1 := inputs.i4
  let n80 : BitVec 1 := (~~~n51)
  let n81 : BitVec 1 := (n39 &&& n80)
  let n82 : BitVec 1 := (~~~n81)
  let n83 : BitVec 1 := (n79 &&& n82)
  let n84 : BitVec 1 := (1#1)
  let n85 : Bool := (n83 == n84)
  let n86 : BitVec 2 := (if n85 then n78 else n35)
  let n87 : BitVec 2 := inputs.i6
  let n88 : BitVec 1 := (1#1)
  let n89 : Bool := (n60 == n88)
  let n90 : BitVec 2 := (if n89 then n87 else n86)
  let n91 : BitVec 1 := (1#1)
  let n92 : Bool := (n60 == n91)
  let n93 : BitVec 2 := (0#2)
  let n94 : BitVec 2 := (if n92 then n93 else n90)
  let n95 : BitVec 1 := (1#1)
  let n96 : Bool := (n55 == n95)
  let n97 : BitVec 1 := (1#1)
  let n98 : BitVec 1 := (0#1)
  let n99 : BitVec 1 := (if n96 then n97 else n98)
  let n100 : BitVec 1 := (1#1)
  let n101 : Bool := (n99 == n100)
  let n102 : BitVec 8 := (255#8)
  let n103 : BitVec 8 := (0#8)
  let n104 : BitVec 8 := (if n101 then n102 else n103)
  let n105 : Bool := (n55 != n83)
  let n106 : BitVec 1 := (1#1)
  let n107 : BitVec 1 := (0#1)
  let n108 : BitVec 1 := (if n105 then n106 else n107)
  let n109 : BitVec 1 := (1#1)
  let n110 : Bool := (n108 == n109)
  let n111 : BitVec 1 := (if n110 then n55 else n51)
  let n112 : BitVec 1 := inputs.i8
  let n113 : BitVec 1 := (1#1)
  let n114 : Bool := (n60 == n113)
  let n115 : BitVec 1 := (if n114 then n112 else n111)
  let n116 : BitVec 1 := (1#1)
  let n117 : Bool := (n60 == n116)
  let n118 : BitVec 1 := (0#1)
  let n119 : BitVec 1 := (if n117 then n118 else n115)
  let n120 : BitVec 8 := inputs.i2
  let n121 : (BitVec 2 → BitVec 8) := state.s13
  let n122 : BitVec 2 := state.s12
  let n123 : BitVec 8 := (n121 n122)
  let n124 : BitVec 8 := state.s8
  let n125 : BitVec 1 := state.s3
  let n126 : BitVec 2 := (n0 ++ n125)
  let n127 : BitVec 2 := (2#2)
  let n128 : Bool := (n126 == n127)
  let n129 : BitVec 1 := (1#1)
  let n130 : BitVec 1 := (0#1)
  let n131 : BitVec 1 := (if n128 then n129 else n130)
  let n132 : BitVec 1 := (1#1)
  let n133 : Bool := (n131 == n132)
  let n134 : BitVec 8 := (0#8)
  let n135 : BitVec 8 := (if n133 then n124 else n134)
  let n136 : BitVec 8 := (~~~n135)
  let n137 : BitVec 8 := (n123 &&& n136)
  let n138 : BitVec 8 := state.s11
  let n139 : BitVec 8 := (n138 &&& n135)
  let n140 : BitVec 8 := (n137 ||| n139)
  let n141 : (BitVec 2 → BitVec 8) := (fun address => if address == n122 then n140 else n121 address)
  let n142 : BitVec 2 := (n12 - n35)
  let n143 : BitVec 2 := (1#2)
  let n144 : BitVec 2 := (n142 - n143)
  let n145 : Bool := (decide (n35.toNat > n12.toNat))
  let n146 : BitVec 1 := (1#1)
  let n147 : BitVec 1 := (0#1)
  let n148 : BitVec 1 := (if n145 then n146 else n147)
  let n149 : BitVec 1 := (1#1)
  let n150 : Bool := (n148 == n149)
  let n151 : BitVec 2 := (if n150 then n144 else n142)
  let n152 : BitVec 2 := (n51 ++ n51)
  let n153 : BitVec 1 := (1#1)
  let n154 : Bool := (n39 == n153)
  let n155 : BitVec 2 := (if n154 then n152 else n151)
  let n156 : BitVec 1 := (~~~n52)
  let n157 : BitVec 8 := inputs.i5
  let n158 : BitVec 8 := (n141 n35)
  let n159 : BitVec 1 := (1#1)
  let n160 : BitVec 1 := (1#1)
  let n161 : Bool := (n159 == n160)
  let n162 : BitVec 8 := (if n161 then n158 else n157)
  let n163 : BitVec 1 := (~~~n81)
  { outputs := { o0 := n155, o1 := n156, o2 := n162, o3 := n163 }, nextState := { s0 := n0, s1 := n0, s2 := n0, s3 := n0, s4 := n67, s5 := n12, s6 := n94, s7 := n35, s8 := n104, s9 := n119, s10 := n51, s11 := n120, s12 := n12, s13 := n141 },
    outputDefined := true, transitionDefined := true }

def step (inputs : Inputs) (state : State) : Outputs × State :=
  let r := evaluate inputs state
  (r.outputs, r.nextState)

def initialValid (state : State) : Bool :=
  ((state.s0 &&& (1#1)) == (1#1)) &&
  ((state.s1 &&& (1#1)) == (1#1)) &&
  ((state.s2 &&& (1#1)) == (1#1)) &&
  ((state.s3 &&& (1#1)) == (1#1)) &&
  ((state.s4 &&& (3#2)) == (0#2)) &&
  ((state.s6 &&& (3#2)) == (0#2)) &&
  ((state.s9 &&& (1#1)) == (0#1))
end Yosys.Queue3
