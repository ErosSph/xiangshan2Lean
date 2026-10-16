-- Generated from locked Yosys FunctionalIR. Fixed circuit; explicit initial state.
import Lean
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
namespace Native.Clocks
structure Inputs where
  i0 : BitVec 1
  i1 : BitVec 1
  i2 : BitVec 1
  i3 : BitVec 1
  i4 : BitVec 1
  i5 : BitVec 8
  i6 : BitVec 8
  i7 : BitVec 1

structure StateGroup0 where
  s0 : BitVec 1
  s1 : BitVec 1
  s2 : BitVec 1
  s3 : BitVec 1
  s4 : BitVec 8
  s5 : BitVec 8
  s6 : BitVec 1
  s7 : BitVec 1
  s8 : BitVec 1
  s9 : BitVec 1
  s10 : BitVec 1
  s11 : BitVec 1
  s12 : BitVec 1
  s13 : BitVec 1
  s14 : BitVec 1
  s15 : BitVec 1

structure StateGroup1 where
  s16 : BitVec 1
  s17 : BitVec 1
  s18 : BitVec 1
  s19 : BitVec 1
  s20 : BitVec 1
  s21 : BitVec 1
  s22 : BitVec 1
  s23 : BitVec 1
  s24 : BitVec 1
  s25 : BitVec 1
  s26 : BitVec 1
  s27 : BitVec 1
  s28 : BitVec 1
  s29 : BitVec 1
  s30 : BitVec 1
  s31 : BitVec 1

structure StateGroup2 where
  s32 : BitVec 1
  s33 : BitVec 1
  s34 : BitVec 1
  s35 : BitVec 8
  s36 : BitVec 8
  s37 : BitVec 8
  s38 : BitVec 8
  s39 : BitVec 8
  s40 : BitVec 8
  s41 : BitVec 8
  s42 : BitVec 8
  s43 : BitVec 8

structure State where
  g0 : StateGroup0
  g1 : StateGroup1
  g2 : StateGroup2

structure Outputs where
  o0 : BitVec 8
  o1 : BitVec 8
  o2 : BitVec 8
  o3 : BitVec 8
  o4 : BitVec 8
  o5 : BitVec 8

structure Evaluation where
  outputs : Outputs
  nextState : State
  outputDefined : Bool
  transitionDefined : Bool

def evaluate (inputs : Inputs) (state : State) : Evaluation :=
  let n0 : BitVec 1 := inputs.i1
  let n1 : BitVec 1 := (~~~n0)
  let n2 : BitVec 1 := (1#1)
  let n3 : Bool := (n1 == n2)
  let n4 : BitVec 1 := (1#1)
  let n5 : BitVec 1 := (0#1)
  let n6 : BitVec 1 := (if n3 then n4 else n5)
  let n7 : BitVec 1 := inputs.i7
  let n8 : BitVec 1 := inputs.i4
  let n9 : BitVec 1 := (1#1)
  let n10 : Bool := (n1 == n9)
  let n11 : BitVec 1 := (if n10 then n8 else n7)
  let n12 : BitVec 1 := state.g0.s2
  let n13 : BitVec 1 := state.g0.s1
  let n14 : BitVec 1 := state.g0.s0
  let n15 : BitVec 1 := (1#1)
  let n16 : Bool := (n14 == n15)
  let n17 : BitVec 1 := (if n16 then n13 else n12)
  let n18 : BitVec 1 := (1#1)
  let n19 : Bool := (n6 == n18)
  let n20 : BitVec 1 := (if n19 then n11 else n17)
  let n21 : BitVec 8 := inputs.i5
  let n22 : BitVec 8 := state.g0.s5
  let n23 : BitVec 8 := state.g0.s4
  let n24 : BitVec 1 := state.g0.s3
  let n25 : BitVec 2 := (n24 ++ n0)
  let n26 : BitVec 2 := (1#2)
  let n27 : Bool := (n25 == n26)
  let n28 : BitVec 1 := (1#1)
  let n29 : BitVec 1 := (0#1)
  let n30 : BitVec 1 := (if n27 then n28 else n29)
  let n31 : BitVec 1 := (1#1)
  let n32 : Bool := (n30 == n31)
  let n33 : BitVec 8 := (if n32 then n23 else n22)
  let n34 : BitVec 8 := state.g2.s35
  let n35 : BitVec 1 := state.g1.s18
  let n36 : BitVec 1 := (1#1)
  let n37 : Bool := (n35 == n36)
  let n38 : BitVec 8 := (if n37 then n34 else n33)
  let n39 : BitVec 1 := inputs.i0
  let n40 : BitVec 1 := (1#1)
  let n41 : Bool := (n39 == n40)
  let n42 : BitVec 8 := (0#8)
  let n43 : BitVec 8 := (if n41 then n42 else n38)
  let n44 : BitVec 1 := inputs.i2
  let n45 : BitVec 1 := inputs.i3
  let n46 : BitVec 1 := (1#1)
  let n47 : Bool := (n45 == n46)
  let n48 : BitVec 8 := (255#8)
  let n49 : BitVec 8 := (0#8)
  let n50 : BitVec 8 := (if n47 then n48 else n49)
  let n51 : BitVec 1 := (BitVec.extractLsb' 7 1 n50)
  let n52 : BitVec 1 := (BitVec.extractLsb' 6 1 n50)
  let n53 : BitVec 1 := (BitVec.extractLsb' 5 1 n50)
  let n54 : BitVec 1 := (BitVec.extractLsb' 4 1 n50)
  let n55 : BitVec 1 := (BitVec.extractLsb' 3 1 n50)
  let n56 : BitVec 1 := (BitVec.extractLsb' 2 1 n50)
  let n57 : BitVec 1 := (BitVec.extractLsb' 1 1 n50)
  let n58 : BitVec 1 := (BitVec.extractLsb' 0 1 n50)
  let n59 : BitVec 1 := (n0 &&& n20)
  let n60 : BitVec 8 := inputs.i6
  let n61 : BitVec 1 := (1#1)
  let n62 : Bool := (n45 == n61)
  let n63 : BitVec 8 := (if n62 then n21 else n60)
  let n64 : BitVec 1 := (BitVec.extractLsb' 7 1 n63)
  let n65 : BitVec 1 := state.g2.s34
  let n66 : BitVec 1 := state.g2.s33
  let n67 : BitVec 1 := state.g0.s15
  let n68 : BitVec 1 := (1#1)
  let n69 : Bool := (n67 == n68)
  let n70 : BitVec 1 := (if n69 then n66 else n65)
  let n71 : BitVec 1 := (BitVec.extractLsb' 0 1 n63)
  let n72 : BitVec 1 := (1#1)
  let n73 : Bool := (n58 == n72)
  let n74 : BitVec 1 := (if n73 then n71 else n70)
  let n75 : BitVec 1 := state.g2.s32
  let n76 : BitVec 1 := state.g1.s31
  let n77 : BitVec 1 := state.g0.s14
  let n78 : BitVec 1 := (1#1)
  let n79 : Bool := (n77 == n78)
  let n80 : BitVec 1 := (if n79 then n76 else n75)
  let n81 : BitVec 1 := (BitVec.extractLsb' 1 1 n63)
  let n82 : BitVec 1 := (1#1)
  let n83 : Bool := (n57 == n82)
  let n84 : BitVec 1 := (if n83 then n81 else n80)
  let n85 : BitVec 2 := (n84 ++ n74)
  let n86 : BitVec 1 := state.g1.s30
  let n87 : BitVec 1 := state.g1.s29
  let n88 : BitVec 1 := state.g0.s13
  let n89 : BitVec 1 := (1#1)
  let n90 : Bool := (n88 == n89)
  let n91 : BitVec 1 := (if n90 then n87 else n86)
  let n92 : BitVec 1 := (BitVec.extractLsb' 2 1 n63)
  let n93 : BitVec 1 := (1#1)
  let n94 : Bool := (n56 == n93)
  let n95 : BitVec 1 := (if n94 then n92 else n91)
  let n96 : BitVec 3 := (n95 ++ n85)
  let n97 : BitVec 1 := state.g1.s28
  let n98 : BitVec 1 := state.g1.s27
  let n99 : BitVec 1 := state.g0.s12
  let n100 : BitVec 1 := (1#1)
  let n101 : Bool := (n99 == n100)
  let n102 : BitVec 1 := (if n101 then n98 else n97)
  let n103 : BitVec 1 := (BitVec.extractLsb' 3 1 n63)
  let n104 : BitVec 1 := (1#1)
  let n105 : Bool := (n55 == n104)
  let n106 : BitVec 1 := (if n105 then n103 else n102)
  let n107 : BitVec 4 := (n106 ++ n96)
  let n108 : BitVec 1 := state.g1.s26
  let n109 : BitVec 1 := state.g1.s25
  let n110 : BitVec 1 := state.g0.s11
  let n111 : BitVec 1 := (1#1)
  let n112 : Bool := (n110 == n111)
  let n113 : BitVec 1 := (if n112 then n109 else n108)
  let n114 : BitVec 1 := (BitVec.extractLsb' 4 1 n63)
  let n115 : BitVec 1 := (1#1)
  let n116 : Bool := (n54 == n115)
  let n117 : BitVec 1 := (if n116 then n114 else n113)
  let n118 : BitVec 5 := (n117 ++ n107)
  let n119 : BitVec 1 := state.g1.s24
  let n120 : BitVec 1 := state.g1.s23
  let n121 : BitVec 1 := state.g0.s10
  let n122 : BitVec 1 := (1#1)
  let n123 : Bool := (n121 == n122)
  let n124 : BitVec 1 := (if n123 then n120 else n119)
  let n125 : BitVec 1 := (BitVec.extractLsb' 5 1 n63)
  let n126 : BitVec 1 := (1#1)
  let n127 : Bool := (n53 == n126)
  let n128 : BitVec 1 := (if n127 then n125 else n124)
  let n129 : BitVec 6 := (n128 ++ n118)
  let n130 : BitVec 1 := state.g1.s22
  let n131 : BitVec 1 := state.g1.s21
  let n132 : BitVec 1 := state.g0.s9
  let n133 : BitVec 1 := (1#1)
  let n134 : Bool := (n132 == n133)
  let n135 : BitVec 1 := (if n134 then n131 else n130)
  let n136 : BitVec 1 := (BitVec.extractLsb' 6 1 n63)
  let n137 : BitVec 1 := (1#1)
  let n138 : Bool := (n52 == n137)
  let n139 : BitVec 1 := (if n138 then n136 else n135)
  let n140 : BitVec 7 := (n139 ++ n129)
  let n141 : BitVec 1 := state.g1.s20
  let n142 : BitVec 1 := state.g1.s19
  let n143 : BitVec 1 := state.g0.s8
  let n144 : BitVec 1 := (1#1)
  let n145 : Bool := (n143 == n144)
  let n146 : BitVec 1 := (if n145 then n142 else n141)
  let n147 : BitVec 1 := (1#1)
  let n148 : Bool := (n51 == n147)
  let n149 : BitVec 1 := (if n148 then n64 else n146)
  let n150 : BitVec 8 := (n149 ++ n140)
  let n151 : BitVec 1 := (BitVec.extractLsb' 7 1 n150)
  let n152 : BitVec 1 := (BitVec.extractLsb' 6 1 n150)
  let n153 : BitVec 1 := (BitVec.extractLsb' 5 1 n150)
  let n154 : BitVec 1 := (BitVec.extractLsb' 4 1 n150)
  let n155 : BitVec 1 := (BitVec.extractLsb' 3 1 n150)
  let n156 : BitVec 1 := (BitVec.extractLsb' 2 1 n150)
  let n157 : BitVec 1 := (BitVec.extractLsb' 1 1 n150)
  let n158 : BitVec 1 := (BitVec.extractLsb' 0 1 n150)
  let n159 : BitVec 8 := state.g2.s37
  let n160 : BitVec 8 := state.g2.s36
  let n161 : BitVec 1 := state.g0.s6
  let n162 : BitVec 2 := (n161 ++ n0)
  let n163 : BitVec 2 := (1#2)
  let n164 : Bool := (n162 == n163)
  let n165 : BitVec 1 := (1#1)
  let n166 : BitVec 1 := (0#1)
  let n167 : BitVec 1 := (if n164 then n165 else n166)
  let n168 : BitVec 1 := (1#1)
  let n169 : Bool := (n167 == n168)
  let n170 : BitVec 8 := (if n169 then n160 else n159)
  let n171 : BitVec 8 := state.g2.s39
  let n172 : BitVec 8 := state.g2.s38
  let n173 : BitVec 1 := state.g0.s7
  let n174 : BitVec 2 := (n173 ++ n44)
  let n175 : BitVec 2 := (2#2)
  let n176 : Bool := (n174 == n175)
  let n177 : BitVec 1 := (1#1)
  let n178 : BitVec 1 := (0#1)
  let n179 : BitVec 1 := (if n176 then n177 else n178)
  let n180 : BitVec 1 := (1#1)
  let n181 : Bool := (n179 == n180)
  let n182 : BitVec 8 := (if n181 then n172 else n171)
  let n183 : BitVec 8 := state.g2.s41
  let n184 : BitVec 8 := state.g2.s40
  let n185 : BitVec 1 := state.g1.s16
  let n186 : BitVec 2 := (n185 ++ n59)
  let n187 : BitVec 2 := (1#2)
  let n188 : Bool := (n186 == n187)
  let n189 : BitVec 1 := (1#1)
  let n190 : BitVec 1 := (0#1)
  let n191 : BitVec 1 := (if n188 then n189 else n190)
  let n192 : BitVec 1 := (1#1)
  let n193 : Bool := (n191 == n192)
  let n194 : BitVec 8 := (if n193 then n184 else n183)
  let n195 : BitVec 8 := state.g2.s43
  let n196 : BitVec 8 := state.g2.s42
  let n197 : BitVec 1 := state.g1.s17
  let n198 : BitVec 2 := (n197 ++ n0)
  let n199 : BitVec 2 := (1#2)
  let n200 : Bool := (n198 == n199)
  let n201 : BitVec 1 := (1#1)
  let n202 : BitVec 1 := (0#1)
  let n203 : BitVec 1 := (if n200 then n201 else n202)
  let n204 : BitVec 1 := (1#1)
  let n205 : Bool := (n203 == n204)
  let n206 : BitVec 8 := (if n205 then n196 else n195)
  let n207 : BitVec 8 := (0#8)
  { outputs := { o0 := n43, o1 := n170, o2 := n182, o3 := n150, o4 := n194, o5 := n206 }, nextState := { g0 := { s0 := n6, s1 := n11, s2 := n20, s3 := n0, s4 := n21, s5 := n43, s6 := n0, s7 := n44, s8 := n51, s9 := n52, s10 := n53, s11 := n54, s12 := n55, s13 := n56, s14 := n57, s15 := n58 }, g1 := { s16 := n59, s17 := n0, s18 := n39, s19 := n64, s20 := n151, s21 := n136, s22 := n152, s23 := n125, s24 := n153, s25 := n114, s26 := n154, s27 := n103, s28 := n155, s29 := n92, s30 := n156, s31 := n81 }, g2 := { s32 := n157, s33 := n71, s34 := n158, s35 := n207, s36 := n21, s37 := n170, s38 := n21, s39 := n182, s40 := n21, s41 := n194, s42 := n182, s43 := n206 } },
    outputDefined := true, transitionDefined := true }

def step (inputs : Inputs) (state : State) : Outputs × State :=
  let r := evaluate inputs state
  (r.outputs, r.nextState)

def initialValid (state : State) : Bool :=
  ((state.g0.s0 &&& (1#1)) == (0#1)) &&
  ((state.g0.s1 &&& (1#1)) == (0#1)) &&
  ((state.g0.s2 &&& (1#1)) == (0#1)) &&
  ((state.g0.s3 &&& (1#1)) == (1#1)) &&
  ((state.g0.s4 &&& (255#8)) == (0#8)) &&
  ((state.g0.s5 &&& (255#8)) == (0#8)) &&
  ((state.g0.s6 &&& (1#1)) == (1#1)) &&
  ((state.g0.s7 &&& (1#1)) == (0#1)) &&
  ((state.g0.s8 &&& (1#1)) == (0#1)) &&
  ((state.g0.s9 &&& (1#1)) == (0#1)) &&
  ((state.g0.s10 &&& (1#1)) == (0#1)) &&
  ((state.g0.s11 &&& (1#1)) == (0#1)) &&
  ((state.g0.s12 &&& (1#1)) == (0#1)) &&
  ((state.g0.s13 &&& (1#1)) == (0#1)) &&
  ((state.g0.s14 &&& (1#1)) == (0#1)) &&
  ((state.g0.s15 &&& (1#1)) == (0#1)) &&
  ((state.g1.s16 &&& (1#1)) == (1#1)) &&
  ((state.g1.s17 &&& (1#1)) == (1#1)) &&
  ((state.g1.s18 &&& (1#1)) == (0#1)) &&
  ((state.g1.s19 &&& (1#1)) == (0#1)) &&
  ((state.g1.s20 &&& (1#1)) == (0#1)) &&
  ((state.g1.s21 &&& (1#1)) == (0#1)) &&
  ((state.g1.s22 &&& (1#1)) == (0#1)) &&
  ((state.g1.s23 &&& (1#1)) == (0#1)) &&
  ((state.g1.s24 &&& (1#1)) == (0#1)) &&
  ((state.g1.s25 &&& (1#1)) == (0#1)) &&
  ((state.g1.s26 &&& (1#1)) == (0#1)) &&
  ((state.g1.s27 &&& (1#1)) == (0#1)) &&
  ((state.g1.s28 &&& (1#1)) == (0#1)) &&
  ((state.g1.s29 &&& (1#1)) == (0#1)) &&
  ((state.g1.s30 &&& (1#1)) == (0#1)) &&
  ((state.g1.s31 &&& (1#1)) == (0#1)) &&
  ((state.g2.s32 &&& (1#1)) == (0#1)) &&
  ((state.g2.s33 &&& (1#1)) == (0#1)) &&
  ((state.g2.s34 &&& (1#1)) == (0#1)) &&
  ((state.g2.s35 &&& (255#8)) == (0#8)) &&
  ((state.g2.s36 &&& (255#8)) == (0#8)) &&
  ((state.g2.s37 &&& (255#8)) == (0#8)) &&
  ((state.g2.s38 &&& (255#8)) == (0#8)) &&
  ((state.g2.s39 &&& (255#8)) == (0#8)) &&
  ((state.g2.s40 &&& (255#8)) == (0#8)) &&
  ((state.g2.s41 &&& (255#8)) == (0#8)) &&
  ((state.g2.s42 &&& (255#8)) == (0#8)) &&
  ((state.g2.s43 &&& (255#8)) == (0#8))
end Native.Clocks
