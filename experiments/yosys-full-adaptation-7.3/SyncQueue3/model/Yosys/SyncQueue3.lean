-- Generated from locked Yosys FunctionalIR. Fixed circuit; explicit initial state.
import Lean
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
namespace Yosys.SyncQueue3
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
  s4 : BitVec 1
  s5 : BitVec 1
  s6 : BitVec 2
  s7 : BitVec 2
  s8 : BitVec 2
  s9 : BitVec 2
  s10 : BitVec 2
  s11 : BitVec 2
  s12 : BitVec 8
  s13 : BitVec 1
  s14 : BitVec 1
  s15 : BitVec 1
  s16 : BitVec 1
  s17 : BitVec 8
  s18 : BitVec 2
  s19 : (BitVec 2 → BitVec 8)

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
  let n1 : BitVec 2 := state.s7
  let n2 : BitVec 2 := state.s6
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
  let n24 : BitVec 1 := inputs.i4
  let n25 : BitVec 2 := state.s9
  let n26 : BitVec 2 := state.s8
  let n27 : BitVec 1 := state.s1
  let n28 : BitVec 2 := (n27 ++ n0)
  let n29 : BitVec 2 := (1#2)
  let n30 : Bool := (n28 == n29)
  let n31 : BitVec 1 := (1#1)
  let n32 : BitVec 1 := (0#1)
  let n33 : BitVec 1 := (if n30 then n31 else n32)
  let n34 : BitVec 1 := (1#1)
  let n35 : Bool := (n33 == n34)
  let n36 : BitVec 2 := (if n35 then n26 else n25)
  let n37 : Bool := (n36 == n12)
  let n38 : BitVec 1 := (1#1)
  let n39 : BitVec 1 := (0#1)
  let n40 : BitVec 1 := (if n37 then n38 else n39)
  let n41 : BitVec 1 := state.s14
  let n42 : BitVec 1 := state.s13
  let n43 : BitVec 1 := state.s3
  let n44 : BitVec 2 := (n43 ++ n0)
  let n45 : BitVec 2 := (1#2)
  let n46 : Bool := (n44 == n45)
  let n47 : BitVec 1 := (1#1)
  let n48 : BitVec 1 := (0#1)
  let n49 : BitVec 1 := (if n46 then n47 else n48)
  let n50 : BitVec 1 := (1#1)
  let n51 : Bool := (n49 == n50)
  let n52 : BitVec 1 := (if n51 then n42 else n41)
  let n53 : BitVec 1 := (~~~n52)
  let n54 : BitVec 1 := (n40 &&& n53)
  let n55 : BitVec 1 := (~~~n54)
  let n56 : BitVec 1 := (n24 &&& n55)
  let n57 : BitVec 1 := (1#1)
  let n58 : Bool := (n56 == n57)
  let n59 : BitVec 2 := (if n58 then n23 else n12)
  let n60 : BitVec 2 := inputs.i6
  let n61 : BitVec 1 := inputs.i0
  let n62 : BitVec 1 := (1#1)
  let n63 : Bool := (n61 == n62)
  let n64 : BitVec 2 := (if n63 then n60 else n59)
  let n65 : BitVec 1 := (1#1)
  let n66 : Bool := (n61 == n65)
  let n67 : BitVec 2 := (0#2)
  let n68 : BitVec 2 := (if n66 then n67 else n64)
  let n69 : BitVec 2 := (1#2)
  let n70 : BitVec 2 := (n36 + n69)
  let n71 : BitVec 2 := (2#2)
  let n72 : Bool := (n36 == n71)
  let n73 : BitVec 1 := (1#1)
  let n74 : BitVec 1 := (0#1)
  let n75 : BitVec 1 := (if n72 then n73 else n74)
  let n76 : BitVec 1 := (1#1)
  let n77 : Bool := (n75 == n76)
  let n78 : BitVec 2 := (0#2)
  let n79 : BitVec 2 := (if n77 then n78 else n70)
  let n80 : BitVec 1 := (n40 &&& n52)
  let n81 : BitVec 1 := (~~~n80)
  let n82 : BitVec 1 := inputs.i3
  let n83 : BitVec 1 := (n81 &&& n82)
  let n84 : BitVec 1 := (1#1)
  let n85 : Bool := (n83 == n84)
  let n86 : BitVec 2 := (if n85 then n79 else n36)
  let n87 : BitVec 2 := inputs.i7
  let n88 : BitVec 1 := (1#1)
  let n89 : Bool := (n61 == n88)
  let n90 : BitVec 2 := (if n89 then n87 else n86)
  let n91 : BitVec 1 := (1#1)
  let n92 : Bool := (n61 == n91)
  let n93 : BitVec 2 := (0#2)
  let n94 : BitVec 2 := (if n92 then n93 else n90)
  let n95 : BitVec 2 := (1#2)
  let n96 : BitVec 2 := (n12 + n95)
  let n97 : BitVec 2 := (2#2)
  let n98 : Bool := (n12 == n97)
  let n99 : BitVec 1 := (1#1)
  let n100 : BitVec 1 := (0#1)
  let n101 : BitVec 1 := (if n98 then n99 else n100)
  let n102 : BitVec 1 := (1#1)
  let n103 : Bool := (n101 == n102)
  let n104 : BitVec 2 := (0#2)
  let n105 : BitVec 2 := (if n103 then n104 else n96)
  let n106 : BitVec 1 := (1#1)
  let n107 : Bool := (n56 == n106)
  let n108 : BitVec 2 := (if n107 then n105 else n12)
  let n109 : BitVec 2 := state.s11
  let n110 : BitVec 2 := state.s10
  let n111 : BitVec 1 := state.s2
  let n112 : BitVec 2 := (n111 ++ n0)
  let n113 : BitVec 2 := (1#2)
  let n114 : Bool := (n112 == n113)
  let n115 : BitVec 1 := (1#1)
  let n116 : BitVec 1 := (0#1)
  let n117 : BitVec 1 := (if n114 then n115 else n116)
  let n118 : BitVec 1 := (1#1)
  let n119 : Bool := (n117 == n118)
  let n120 : BitVec 2 := (if n119 then n110 else n109)
  let n121 : BitVec 1 := (1#1)
  let n122 : Bool := (n83 == n121)
  let n123 : BitVec 1 := (1#1)
  let n124 : BitVec 1 := (0#1)
  let n125 : BitVec 1 := (if n122 then n123 else n124)
  let n126 : BitVec 1 := (1#1)
  let n127 : Bool := (n125 == n126)
  let n128 : BitVec 8 := (255#8)
  let n129 : BitVec 8 := (0#8)
  let n130 : BitVec 8 := (if n127 then n128 else n129)
  let n131 : Bool := (n83 != n56)
  let n132 : BitVec 1 := (1#1)
  let n133 : BitVec 1 := (0#1)
  let n134 : BitVec 1 := (if n131 then n132 else n133)
  let n135 : BitVec 1 := (1#1)
  let n136 : Bool := (n134 == n135)
  let n137 : BitVec 1 := (if n136 then n83 else n52)
  let n138 : BitVec 1 := inputs.i8
  let n139 : BitVec 1 := (1#1)
  let n140 : Bool := (n61 == n139)
  let n141 : BitVec 1 := (if n140 then n138 else n137)
  let n142 : BitVec 1 := (1#1)
  let n143 : Bool := (n61 == n142)
  let n144 : BitVec 1 := (0#1)
  let n145 : BitVec 1 := (if n143 then n144 else n141)
  let n146 : BitVec 1 := state.s16
  let n147 : BitVec 1 := state.s15
  let n148 : BitVec 1 := state.s5
  let n149 : BitVec 2 := (n148 ++ n0)
  let n150 : BitVec 2 := (1#2)
  let n151 : Bool := (n149 == n150)
  let n152 : BitVec 1 := (1#1)
  let n153 : BitVec 1 := (0#1)
  let n154 : BitVec 1 := (if n151 then n152 else n153)
  let n155 : BitVec 1 := (1#1)
  let n156 : Bool := (n154 == n155)
  let n157 : BitVec 1 := (if n156 then n147 else n146)
  let n158 : BitVec 8 := inputs.i2
  let n159 : (BitVec 2 → BitVec 8) := state.s19
  let n160 : BitVec 2 := state.s18
  let n161 : BitVec 8 := (n159 n160)
  let n162 : BitVec 8 := state.s12
  let n163 : BitVec 1 := state.s4
  let n164 : BitVec 2 := (n0 ++ n163)
  let n165 : BitVec 2 := (2#2)
  let n166 : Bool := (n164 == n165)
  let n167 : BitVec 1 := (1#1)
  let n168 : BitVec 1 := (0#1)
  let n169 : BitVec 1 := (if n166 then n167 else n168)
  let n170 : BitVec 1 := (1#1)
  let n171 : Bool := (n169 == n170)
  let n172 : BitVec 8 := (0#8)
  let n173 : BitVec 8 := (if n171 then n162 else n172)
  let n174 : BitVec 8 := (~~~n173)
  let n175 : BitVec 8 := (n161 &&& n174)
  let n176 : BitVec 8 := state.s17
  let n177 : BitVec 8 := (n176 &&& n173)
  let n178 : BitVec 8 := (n175 ||| n177)
  let n179 : (BitVec 2 → BitVec 8) := (fun address => if address == n160 then n178 else n159 address)
  let n180 : BitVec 2 := (n36 - n12)
  let n181 : BitVec 2 := (1#2)
  let n182 : BitVec 2 := (n180 - n181)
  let n183 : Bool := (decide (n12.toNat > n36.toNat))
  let n184 : BitVec 1 := (1#1)
  let n185 : BitVec 1 := (0#1)
  let n186 : BitVec 1 := (if n183 then n184 else n185)
  let n187 : BitVec 1 := (1#1)
  let n188 : Bool := (n186 == n187)
  let n189 : BitVec 2 := (if n188 then n182 else n180)
  let n190 : BitVec 2 := (n52 ++ n52)
  let n191 : BitVec 1 := (1#1)
  let n192 : Bool := (n40 == n191)
  let n193 : BitVec 2 := (if n192 then n190 else n189)
  let n194 : BitVec 1 := (~~~n80)
  let n195 : BitVec 8 := inputs.i5
  let n196 : BitVec 8 := (n179 n120)
  let n197 : BitVec 1 := (1#1)
  let n198 : Bool := (n157 == n197)
  let n199 : BitVec 8 := (if n198 then n196 else n195)
  let n200 : BitVec 1 := (~~~n54)
  let n201 : BitVec 1 := (1#1)
  { outputs := { o0 := n193, o1 := n194, o2 := n199, o3 := n200 }, nextState := { s0 := n0, s1 := n0, s2 := n0, s3 := n0, s4 := n0, s5 := n0, s6 := n68, s7 := n12, s8 := n94, s9 := n36, s10 := n108, s11 := n120, s12 := n130, s13 := n145, s14 := n52, s15 := n201, s16 := n157, s17 := n158, s18 := n36, s19 := n179 },
    outputDefined := true, transitionDefined := true }

def step (inputs : Inputs) (state : State) : Outputs × State :=
  let r := evaluate inputs state
  (r.outputs, r.nextState)

def initialValid (state : State) : Bool :=
  ((state.s0 &&& (1#1)) == (1#1)) &&
  ((state.s1 &&& (1#1)) == (1#1)) &&
  ((state.s2 &&& (1#1)) == (1#1)) &&
  ((state.s3 &&& (1#1)) == (1#1)) &&
  ((state.s4 &&& (1#1)) == (1#1)) &&
  ((state.s5 &&& (1#1)) == (1#1)) &&
  ((state.s6 &&& (3#2)) == (0#2)) &&
  ((state.s8 &&& (3#2)) == (0#2)) &&
  ((state.s10 &&& (3#2)) == (0#2)) &&
  ((state.s13 &&& (1#1)) == (0#1)) &&
  ((state.s15 &&& (1#1)) == (0#1))
end Yosys.SyncQueue3
