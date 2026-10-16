-- Generated from locked Yosys FunctionalIR. Fixed circuit; explicit initial state.
import Lean
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
namespace Yosys.XSPrefetch
structure InputsGroup0 where
  i0 : BitVec 1
  i1 : BitVec 1
  i2 : BitVec 2
  i3 : BitVec 2
  i4 : BitVec 1
  i5 : BitVec 1
  i6 : BitVec 16
  i7 : BitVec 1
  i8 : BitVec 4
  i9 : BitVec 44
  i10 : BitVec 27
  i11 : BitVec 1
  i12 : BitVec 1
  i13 : BitVec 39
  i14 : BitVec 16
  i15 : BitVec 1

structure InputsGroup1 where
  i16 : BitVec 1
  i17 : BitVec 1
  i18 : BitVec 2

structure Inputs where
  g0 : InputsGroup0
  g1 : InputsGroup1

structure StateGroup0 where
  s0 : BitVec 1
  s1 : BitVec 2
  s2 : BitVec 2
  s3 : BitVec 1
  s4 : BitVec 1
  s5 : BitVec 1
  s6 : BitVec 1
  s7 : BitVec 1
  s8 : BitVec 1
  s9 : BitVec 1
  s10 : BitVec 1
  s11 : BitVec 27
  s12 : BitVec 27
  s13 : BitVec 27
  s14 : BitVec 27
  s15 : BitVec 27

structure StateGroup1 where
  s16 : BitVec 27
  s17 : BitVec 27
  s18 : BitVec 27
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
  s29 : BitVec 27
  s30 : BitVec 27
  s31 : BitVec 1

structure StateGroup2 where
  s32 : BitVec 1

structure State where
  g0 : StateGroup0
  g1 : StateGroup1
  g2 : StateGroup2

structure Outputs where
  o0 : BitVec 2
  o1 : BitVec 27
  o2 : BitVec 1

structure Evaluation where
  outputs : Outputs
  nextState : State
  outputDefined : Bool
  transitionDefined : Bool

def evaluate (inputs : Inputs) (state : State) : Evaluation :=
  let n0 : BitVec 1 := inputs.g0.i1
  let n1 : BitVec 2 := state.g0.s2
  let n2 : BitVec 2 := state.g0.s1
  let n3 : BitVec 1 := state.g0.s0
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
  let n15 : BitVec 2 := (3#2)
  let n16 : Bool := (n12 == n15)
  let n17 : BitVec 1 := (1#1)
  let n18 : BitVec 1 := (0#1)
  let n19 : BitVec 1 := (if n16 then n17 else n18)
  let n20 : BitVec 1 := (1#1)
  let n21 : Bool := (n19 == n20)
  let n22 : BitVec 2 := (0#2)
  let n23 : BitVec 2 := (if n21 then n22 else n14)
  let n24 : BitVec 1 := inputs.g0.i12
  let n25 : BitVec 1 := state.g2.s32
  let n26 : BitVec 1 := state.g1.s31
  let n27 : BitVec 1 := state.g1.s28
  let n28 : BitVec 2 := (n27 ++ n0)
  let n29 : BitVec 2 := (1#2)
  let n30 : Bool := (n28 == n29)
  let n31 : BitVec 1 := (1#1)
  let n32 : BitVec 1 := (0#1)
  let n33 : BitVec 1 := (if n30 then n31 else n32)
  let n34 : BitVec 1 := (1#1)
  let n35 : Bool := (n33 == n34)
  let n36 : BitVec 1 := (if n35 then n26 else n25)
  let n37 : BitVec 1 := (n24 &&& n36)
  let n38 : BitVec 1 := (1#1)
  let n39 : Bool := (n37 == n38)
  let n40 : BitVec 2 := (if n39 then n23 else n12)
  let n41 : BitVec 2 := inputs.g1.i18
  let n42 : BitVec 1 := inputs.g0.i0
  let n43 : BitVec 1 := (1#1)
  let n44 : Bool := (n42 == n43)
  let n45 : BitVec 2 := (if n44 then n41 else n40)
  let n46 : BitVec 1 := (1#1)
  let n47 : Bool := (n42 == n46)
  let n48 : BitVec 2 := (0#2)
  let n49 : BitVec 2 := (if n47 then n48 else n45)
  let n50 : BitVec 27 := state.g0.s12
  let n51 : BitVec 27 := state.g0.s11
  let n52 : BitVec 1 := state.g0.s3
  let n53 : BitVec 2 := (n52 ++ n0)
  let n54 : BitVec 2 := (1#2)
  let n55 : Bool := (n53 == n54)
  let n56 : BitVec 1 := (1#1)
  let n57 : BitVec 1 := (0#1)
  let n58 : BitVec 1 := (if n55 then n56 else n57)
  let n59 : BitVec 1 := (1#1)
  let n60 : Bool := (n58 == n59)
  let n61 : BitVec 27 := (if n60 then n51 else n50)
  let n62 : BitVec 27 := state.g1.s30
  let n63 : BitVec 27 := state.g1.s29
  let n64 : BitVec 1 := state.g1.s27
  let n65 : BitVec 2 := (n64 ++ n0)
  let n66 : BitVec 2 := (1#2)
  let n67 : Bool := (n65 == n66)
  let n68 : BitVec 1 := (1#1)
  let n69 : BitVec 1 := (0#1)
  let n70 : BitVec 1 := (if n67 then n68 else n69)
  let n71 : BitVec 1 := (1#1)
  let n72 : Bool := (n70 == n71)
  let n73 : BitVec 27 := (if n72 then n63 else n62)
  let n74 : BitVec 2 := (0#2)
  let n75 : Bool := (n12 == n74)
  let n76 : BitVec 1 := (1#1)
  let n77 : BitVec 1 := (0#1)
  let n78 : BitVec 1 := (if n75 then n76 else n77)
  let n79 : BitVec 1 := (n37 &&& n78)
  let n80 : BitVec 1 := (1#1)
  let n81 : Bool := (n79 == n80)
  let n82 : BitVec 27 := (if n81 then n73 else n61)
  let n83 : BitVec 27 := state.g0.s14
  let n84 : BitVec 27 := state.g0.s13
  let n85 : BitVec 1 := state.g0.s4
  let n86 : BitVec 2 := (n85 ++ n0)
  let n87 : BitVec 2 := (1#2)
  let n88 : Bool := (n86 == n87)
  let n89 : BitVec 1 := (1#1)
  let n90 : BitVec 1 := (0#1)
  let n91 : BitVec 1 := (if n88 then n89 else n90)
  let n92 : BitVec 1 := (1#1)
  let n93 : Bool := (n91 == n92)
  let n94 : BitVec 27 := (if n93 then n84 else n83)
  let n95 : BitVec 2 := (1#2)
  let n96 : Bool := (n12 == n95)
  let n97 : BitVec 1 := (1#1)
  let n98 : BitVec 1 := (0#1)
  let n99 : BitVec 1 := (if n96 then n97 else n98)
  let n100 : BitVec 1 := (n37 &&& n99)
  let n101 : BitVec 1 := (1#1)
  let n102 : Bool := (n100 == n101)
  let n103 : BitVec 27 := (if n102 then n73 else n94)
  let n104 : BitVec 27 := state.g1.s16
  let n105 : BitVec 27 := state.g0.s15
  let n106 : BitVec 1 := state.g0.s5
  let n107 : BitVec 2 := (n106 ++ n0)
  let n108 : BitVec 2 := (1#2)
  let n109 : Bool := (n107 == n108)
  let n110 : BitVec 1 := (1#1)
  let n111 : BitVec 1 := (0#1)
  let n112 : BitVec 1 := (if n109 then n110 else n111)
  let n113 : BitVec 1 := (1#1)
  let n114 : Bool := (n112 == n113)
  let n115 : BitVec 27 := (if n114 then n105 else n104)
  let n116 : BitVec 2 := (2#2)
  let n117 : Bool := (n12 == n116)
  let n118 : BitVec 1 := (1#1)
  let n119 : BitVec 1 := (0#1)
  let n120 : BitVec 1 := (if n117 then n118 else n119)
  let n121 : BitVec 1 := (n37 &&& n120)
  let n122 : BitVec 1 := (1#1)
  let n123 : Bool := (n121 == n122)
  let n124 : BitVec 27 := (if n123 then n73 else n115)
  let n125 : BitVec 27 := state.g1.s18
  let n126 : BitVec 27 := state.g1.s17
  let n127 : BitVec 1 := state.g0.s6
  let n128 : BitVec 2 := (n127 ++ n0)
  let n129 : BitVec 2 := (1#2)
  let n130 : Bool := (n128 == n129)
  let n131 : BitVec 1 := (1#1)
  let n132 : BitVec 1 := (0#1)
  let n133 : BitVec 1 := (if n130 then n131 else n132)
  let n134 : BitVec 1 := (1#1)
  let n135 : Bool := (n133 == n134)
  let n136 : BitVec 27 := (if n135 then n126 else n125)
  let n137 : BitVec 2 := (3#2)
  let n138 : Bool := (n12 == n137)
  let n139 : BitVec 1 := (1#1)
  let n140 : BitVec 1 := (0#1)
  let n141 : BitVec 1 := (if n138 then n139 else n140)
  let n142 : BitVec 1 := (n37 &&& n141)
  let n143 : BitVec 1 := (1#1)
  let n144 : Bool := (n142 == n143)
  let n145 : BitVec 27 := (if n144 then n73 else n136)
  let n146 : BitVec 1 := inputs.g1.i17
  let n147 : BitVec 1 := inputs.g0.i7
  let n148 : BitVec 1 := (n146 ||| n147)
  let n149 : BitVec 1 := (~~~n148)
  let n150 : BitVec 1 := state.g1.s20
  let n151 : BitVec 1 := state.g1.s19
  let n152 : BitVec 1 := state.g0.s7
  let n153 : BitVec 2 := (n152 ++ n0)
  let n154 : BitVec 2 := (1#2)
  let n155 : Bool := (n153 == n154)
  let n156 : BitVec 1 := (1#1)
  let n157 : BitVec 1 := (0#1)
  let n158 : BitVec 1 := (if n155 then n156 else n157)
  let n159 : BitVec 1 := (1#1)
  let n160 : Bool := (n158 == n159)
  let n161 : BitVec 1 := (if n160 then n151 else n150)
  let n162 : BitVec 1 := (n79 ||| n161)
  let n163 : BitVec 1 := (n149 &&& n162)
  let n164 : BitVec 1 := (1#1)
  let n165 : Bool := (n42 == n164)
  let n166 : BitVec 1 := (0#1)
  let n167 : BitVec 1 := (if n165 then n166 else n163)
  let n168 : BitVec 1 := (~~~n148)
  let n169 : BitVec 1 := state.g1.s22
  let n170 : BitVec 1 := state.g1.s21
  let n171 : BitVec 1 := state.g0.s8
  let n172 : BitVec 2 := (n171 ++ n0)
  let n173 : BitVec 2 := (1#2)
  let n174 : Bool := (n172 == n173)
  let n175 : BitVec 1 := (1#1)
  let n176 : BitVec 1 := (0#1)
  let n177 : BitVec 1 := (if n174 then n175 else n176)
  let n178 : BitVec 1 := (1#1)
  let n179 : Bool := (n177 == n178)
  let n180 : BitVec 1 := (if n179 then n170 else n169)
  let n181 : BitVec 1 := (n100 ||| n180)
  let n182 : BitVec 1 := (n168 &&& n181)
  let n183 : BitVec 1 := (1#1)
  let n184 : Bool := (n42 == n183)
  let n185 : BitVec 1 := (0#1)
  let n186 : BitVec 1 := (if n184 then n185 else n182)
  let n187 : BitVec 1 := (~~~n148)
  let n188 : BitVec 1 := state.g1.s24
  let n189 : BitVec 1 := state.g1.s23
  let n190 : BitVec 1 := state.g0.s9
  let n191 : BitVec 2 := (n190 ++ n0)
  let n192 : BitVec 2 := (1#2)
  let n193 : Bool := (n191 == n192)
  let n194 : BitVec 1 := (1#1)
  let n195 : BitVec 1 := (0#1)
  let n196 : BitVec 1 := (if n193 then n194 else n195)
  let n197 : BitVec 1 := (1#1)
  let n198 : Bool := (n196 == n197)
  let n199 : BitVec 1 := (if n198 then n189 else n188)
  let n200 : BitVec 1 := (n121 ||| n199)
  let n201 : BitVec 1 := (n187 &&& n200)
  let n202 : BitVec 1 := (1#1)
  let n203 : Bool := (n42 == n202)
  let n204 : BitVec 1 := (0#1)
  let n205 : BitVec 1 := (if n203 then n204 else n201)
  let n206 : BitVec 1 := (~~~n148)
  let n207 : BitVec 1 := state.g1.s26
  let n208 : BitVec 1 := state.g1.s25
  let n209 : BitVec 1 := state.g0.s10
  let n210 : BitVec 2 := (n209 ++ n0)
  let n211 : BitVec 2 := (1#2)
  let n212 : Bool := (n210 == n211)
  let n213 : BitVec 1 := (1#1)
  let n214 : BitVec 1 := (0#1)
  let n215 : BitVec 1 := (if n212 then n213 else n214)
  let n216 : BitVec 1 := (1#1)
  let n217 : Bool := (n215 == n216)
  let n218 : BitVec 1 := (if n217 then n208 else n207)
  let n219 : BitVec 1 := (n142 ||| n218)
  let n220 : BitVec 1 := (n206 &&& n219)
  let n221 : BitVec 1 := (1#1)
  let n222 : Bool := (n42 == n221)
  let n223 : BitVec 1 := (0#1)
  let n224 : BitVec 1 := (if n222 then n223 else n220)
  let n225 : BitVec 27 := inputs.g0.i10
  let n226 : BitVec 24 := (BitVec.extractLsb' 3 24 n225)
  let n227 : BitVec 24 := (1#24)
  let n228 : BitVec 24 := (n226 + n227)
  let n229 : BitVec 3 := (0#3)
  let n230 : BitVec 27 := (n228 ++ n229)
  let n231 : BitVec 1 := inputs.g0.i11
  let n232 : BitVec 1 := (1#1)
  let n233 : Bool := (n231 == n232)
  let n234 : BitVec 27 := (if n233 then n230 else n73)
  let n235 : BitVec 1 := (~~~n148)
  let n236 : BitVec 1 := (~~~n148)
  let n237 : BitVec 1 := (n231 &&& n236)
  let n238 : BitVec 24 := (BitVec.extractLsb' 3 24 n136)
  let n239 : Bool := (n238 == n228)
  let n240 : BitVec 1 := (1#1)
  let n241 : BitVec 1 := (0#1)
  let n242 : BitVec 1 := (if n239 then n240 else n241)
  let n243 : BitVec 1 := (n242 &&& n218)
  let n244 : BitVec 24 := (BitVec.extractLsb' 3 24 n115)
  let n245 : Bool := (n244 == n228)
  let n246 : BitVec 1 := (1#1)
  let n247 : BitVec 1 := (0#1)
  let n248 : BitVec 1 := (if n245 then n246 else n247)
  let n249 : BitVec 1 := (n248 &&& n199)
  let n250 : BitVec 2 := (n249 ++ n243)
  let n251 : BitVec 24 := (BitVec.extractLsb' 3 24 n94)
  let n252 : Bool := (n251 == n228)
  let n253 : BitVec 1 := (1#1)
  let n254 : BitVec 1 := (0#1)
  let n255 : BitVec 1 := (if n252 then n253 else n254)
  let n256 : BitVec 1 := (n255 &&& n180)
  let n257 : BitVec 3 := (n256 ++ n250)
  let n258 : BitVec 24 := (BitVec.extractLsb' 3 24 n61)
  let n259 : Bool := (n258 == n228)
  let n260 : BitVec 1 := (1#1)
  let n261 : BitVec 1 := (0#1)
  let n262 : BitVec 1 := (if n259 then n260 else n261)
  let n263 : BitVec 1 := (n262 &&& n161)
  let n264 : BitVec 4 := (n263 ++ n257)
  let n265 : BitVec 4 := (0#4)
  let n266 : Bool := (n264 == n265)
  let n267 : BitVec 1 := (1#1)
  let n268 : BitVec 1 := (0#1)
  let n269 : BitVec 1 := (if n266 then n267 else n268)
  let n270 : BitVec 1 := (n237 &&& n269)
  let n271 : BitVec 1 := (~~~n37)
  let n272 : BitVec 1 := (n271 &&& n36)
  let n273 : BitVec 1 := (n270 ||| n272)
  let n274 : BitVec 1 := (n235 &&& n273)
  let n275 : BitVec 1 := (1#1)
  let n276 : Bool := (n42 == n275)
  let n277 : BitVec 1 := (0#1)
  let n278 : BitVec 1 := (if n276 then n277 else n274)
  let n279 : BitVec 2 := (2#2)
  { outputs := { o0 := n279, o1 := n73, o2 := n36 }, nextState := { g0 := { s0 := n0, s1 := n49, s2 := n12, s3 := n0, s4 := n0, s5 := n0, s6 := n0, s7 := n0, s8 := n0, s9 := n0, s10 := n0, s11 := n82, s12 := n61, s13 := n103, s14 := n94, s15 := n124 }, g1 := { s16 := n115, s17 := n145, s18 := n136, s19 := n167, s20 := n161, s21 := n186, s22 := n180, s23 := n205, s24 := n199, s25 := n224, s26 := n218, s27 := n0, s28 := n0, s29 := n234, s30 := n73, s31 := n278 }, g2 := { s32 := n36 } },
    outputDefined := true, transitionDefined := true }

def step (inputs : Inputs) (state : State) : Outputs × State :=
  let r := evaluate inputs state
  (r.outputs, r.nextState)

def initialValid (state : State) : Bool :=
  ((state.g0.s0 &&& (1#1)) == (1#1)) &&
  ((state.g0.s1 &&& (3#2)) == (0#2)) &&
  ((state.g0.s3 &&& (1#1)) == (1#1)) &&
  ((state.g0.s4 &&& (1#1)) == (1#1)) &&
  ((state.g0.s5 &&& (1#1)) == (1#1)) &&
  ((state.g0.s6 &&& (1#1)) == (1#1)) &&
  ((state.g0.s7 &&& (1#1)) == (1#1)) &&
  ((state.g0.s8 &&& (1#1)) == (1#1)) &&
  ((state.g0.s9 &&& (1#1)) == (1#1)) &&
  ((state.g0.s10 &&& (1#1)) == (1#1)) &&
  ((state.g0.s11 &&& (134217727#27)) == (0#27)) &&
  ((state.g0.s13 &&& (134217727#27)) == (0#27)) &&
  ((state.g0.s15 &&& (134217727#27)) == (0#27)) &&
  ((state.g1.s17 &&& (134217727#27)) == (0#27)) &&
  ((state.g1.s19 &&& (1#1)) == (0#1)) &&
  ((state.g1.s21 &&& (1#1)) == (0#1)) &&
  ((state.g1.s23 &&& (1#1)) == (0#1)) &&
  ((state.g1.s25 &&& (1#1)) == (0#1)) &&
  ((state.g1.s27 &&& (1#1)) == (1#1)) &&
  ((state.g1.s28 &&& (1#1)) == (1#1)) &&
  ((state.g1.s29 &&& (134217727#27)) == (0#27)) &&
  ((state.g1.s31 &&& (1#1)) == (0#1))
end Yosys.XSPrefetch
