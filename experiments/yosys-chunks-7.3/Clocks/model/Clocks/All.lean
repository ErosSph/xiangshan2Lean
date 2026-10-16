-- Generated from locked Yosys FunctionalIR. Fixed circuit; explicit initial state.
import Lean
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
namespace Clocks.All
structure Inputs where
  i0 : BitVec 1
  i1 : BitVec 1
  i2 : BitVec 1
  i3 : BitVec 1
  i4 : BitVec 1
  i5 : BitVec 8
  i6 : BitVec 8
  i7 : BitVec 1

structure State where
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

abbrev C2LChunk0 := ((BitVec 1 × BitVec 1) × (BitVec 1 × BitVec 1))

@[noinline] def c2lChunk0 (inputs : Inputs) (state : State) : C2LChunk0 :=
  let n0 : BitVec 1 := inputs.i1
  let n1 : BitVec 1 := (~~~n0)
  let n2 : BitVec 1 := (1#1)
  let n3 : Bool := (n1 == n2)
  let n4 : BitVec 1 := (1#1)
  let n5 : BitVec 1 := (0#1)
  let n6 : BitVec 1 := (if n3 then n4 else n5)
  let n7 : BitVec 1 := inputs.i7
  ((n0, n1), (n6, n7))

abbrev C2LChunk1 := ((BitVec 1 × BitVec 1) × (BitVec 1 × (BitVec 1 × BitVec 1)))

@[noinline] def c2lChunk1 (inputs : Inputs) (state : State) (c0 : C2LChunk0) : C2LChunk1 :=
  let n8 : BitVec 1 := inputs.i4
  let n9 : BitVec 1 := (1#1)
  let n10 : Bool := (c0.fst.snd == n9)
  let n11 : BitVec 1 := (if n10 then n8 else c0.snd.snd)
  let n12 : BitVec 1 := state.s2
  let n13 : BitVec 1 := state.s1
  let n14 : BitVec 1 := state.s0
  let n15 : BitVec 1 := (1#1)
  ((n11, n12), (n13, (n14, n15)))

abbrev C2LChunk2 := ((BitVec 1 × BitVec 8) × (BitVec 8 × BitVec 8))

@[noinline] def c2lChunk2 (inputs : Inputs) (state : State) (c0 : C2LChunk0) (c1 : C2LChunk1) : C2LChunk2 :=
  let n16 : Bool := (c1.snd.snd.fst == c1.snd.snd.snd)
  let n17 : BitVec 1 := (if n16 then c1.snd.fst else c1.fst.snd)
  let n18 : BitVec 1 := (1#1)
  let n19 : Bool := (c0.snd.fst == n18)
  let n20 : BitVec 1 := (if n19 then c1.fst.fst else n17)
  let n21 : BitVec 8 := inputs.i5
  let n22 : BitVec 8 := state.s5
  let n23 : BitVec 8 := state.s4
  ((n20, n21), (n22, n23))

abbrev C2LChunk3 := (BitVec 1 × BitVec 1)

@[noinline] def c2lChunk3 (inputs : Inputs) (state : State) (c0 : C2LChunk0) : C2LChunk3 :=
  let n24 : BitVec 1 := state.s3
  let n25 : BitVec 2 := (n24 ++ c0.fst.fst)
  let n26 : BitVec 2 := (1#2)
  let n27 : Bool := (n25 == n26)
  let n28 : BitVec 1 := (1#1)
  let n29 : BitVec 1 := (0#1)
  let n30 : BitVec 1 := (if n27 then n28 else n29)
  let n31 : BitVec 1 := (1#1)
  (n30, n31)

abbrev C2LChunk4 := (BitVec 8 × BitVec 1)

@[noinline] def c2lChunk4 (inputs : Inputs) (state : State) (c2 : C2LChunk2) (c3 : C2LChunk3) : C2LChunk4 :=
  let n32 : Bool := (c3.fst == c3.snd)
  let n33 : BitVec 8 := (if n32 then c2.snd.snd else c2.snd.fst)
  let n34 : BitVec 8 := state.s35
  let n35 : BitVec 1 := state.s18
  let n36 : BitVec 1 := (1#1)
  let n37 : Bool := (n35 == n36)
  let n38 : BitVec 8 := (if n37 then n34 else n33)
  let n39 : BitVec 1 := inputs.i0
  (n38, n39)

abbrev C2LChunk5 := ((BitVec 8 × BitVec 1) × (BitVec 1 × Bool))

@[noinline] def c2lChunk5 (inputs : Inputs) (state : State) (c4 : C2LChunk4) : C2LChunk5 :=
  let n40 : BitVec 1 := (1#1)
  let n41 : Bool := (c4.snd == n40)
  let n42 : BitVec 8 := (0#8)
  let n43 : BitVec 8 := (if n41 then n42 else c4.fst)
  let n44 : BitVec 1 := inputs.i2
  let n45 : BitVec 1 := inputs.i3
  let n46 : BitVec 1 := (1#1)
  let n47 : Bool := (n45 == n46)
  ((n43, n44), (n45, n47))

abbrev C2LChunk6 := ((BitVec 8 × (BitVec 1 × BitVec 1)) × (BitVec 1 × (BitVec 1 × BitVec 1)))

@[noinline] def c2lChunk6 (inputs : Inputs) (state : State) (c5 : C2LChunk5) : C2LChunk6 :=
  let n48 : BitVec 8 := (255#8)
  let n49 : BitVec 8 := (0#8)
  let n50 : BitVec 8 := (if c5.snd.snd then n48 else n49)
  let n51 : BitVec 1 := (BitVec.extractLsb' 7 1 n50)
  let n52 : BitVec 1 := (BitVec.extractLsb' 6 1 n50)
  let n53 : BitVec 1 := (BitVec.extractLsb' 5 1 n50)
  let n54 : BitVec 1 := (BitVec.extractLsb' 4 1 n50)
  let n55 : BitVec 1 := (BitVec.extractLsb' 3 1 n50)
  ((n50, (n51, n52)), (n53, (n54, n55)))

abbrev C2LChunk7 := ((BitVec 1 × BitVec 1) × (BitVec 1 × (BitVec 1 × BitVec 8)))

@[noinline] def c2lChunk7 (inputs : Inputs) (state : State) (c0 : C2LChunk0) (c2 : C2LChunk2) (c5 : C2LChunk5) (c6 : C2LChunk6) : C2LChunk7 :=
  let n56 : BitVec 1 := (BitVec.extractLsb' 2 1 c6.fst.fst)
  let n57 : BitVec 1 := (BitVec.extractLsb' 1 1 c6.fst.fst)
  let n58 : BitVec 1 := (BitVec.extractLsb' 0 1 c6.fst.fst)
  let n59 : BitVec 1 := (c0.fst.fst &&& c2.fst.fst)
  let n60 : BitVec 8 := inputs.i6
  let n61 : BitVec 1 := (1#1)
  let n62 : Bool := (c5.snd.fst == n61)
  let n63 : BitVec 8 := (if n62 then c2.fst.snd else n60)
  ((n56, n57), (n58, (n59, n63)))

abbrev C2LChunk8 := (BitVec 1 × (BitVec 1 × BitVec 1))

@[noinline] def c2lChunk8 (inputs : Inputs) (state : State) (c7 : C2LChunk7) : C2LChunk8 :=
  let n64 : BitVec 1 := (BitVec.extractLsb' 7 1 c7.snd.snd.snd)
  let n65 : BitVec 1 := state.s34
  let n66 : BitVec 1 := state.s33
  let n67 : BitVec 1 := state.s15
  let n68 : BitVec 1 := (1#1)
  let n69 : Bool := (n67 == n68)
  let n70 : BitVec 1 := (if n69 then n66 else n65)
  let n71 : BitVec 1 := (BitVec.extractLsb' 0 1 c7.snd.snd.snd)
  (n64, (n70, n71))

abbrev C2LChunk9 := ((BitVec 1 × BitVec 1) × (BitVec 1 × Bool))

@[noinline] def c2lChunk9 (inputs : Inputs) (state : State) (c7 : C2LChunk7) (c8 : C2LChunk8) : C2LChunk9 :=
  let n72 : BitVec 1 := (1#1)
  let n73 : Bool := (c7.snd.fst == n72)
  let n74 : BitVec 1 := (if n73 then c8.snd.snd else c8.snd.fst)
  let n75 : BitVec 1 := state.s32
  let n76 : BitVec 1 := state.s31
  let n77 : BitVec 1 := state.s14
  let n78 : BitVec 1 := (1#1)
  let n79 : Bool := (n77 == n78)
  ((n74, n75), (n76, n79))

abbrev C2LChunk10 := ((BitVec 1 × BitVec 2) × (BitVec 1 × BitVec 1))

@[noinline] def c2lChunk10 (inputs : Inputs) (state : State) (c7 : C2LChunk7) (c9 : C2LChunk9) : C2LChunk10 :=
  let n80 : BitVec 1 := (if c9.snd.snd then c9.snd.fst else c9.fst.snd)
  let n81 : BitVec 1 := (BitVec.extractLsb' 1 1 c7.snd.snd.snd)
  let n82 : BitVec 1 := (1#1)
  let n83 : Bool := (c7.fst.snd == n82)
  let n84 : BitVec 1 := (if n83 then n81 else n80)
  let n85 : BitVec 2 := (n84 ++ c9.fst.fst)
  let n86 : BitVec 1 := state.s30
  let n87 : BitVec 1 := state.s29
  ((n81, n85), (n86, n87))

abbrev C2LChunk11 := (BitVec 1 × BitVec 1)

@[noinline] def c2lChunk11 (inputs : Inputs) (state : State) (c7 : C2LChunk7) (c10 : C2LChunk10) : C2LChunk11 :=
  let n88 : BitVec 1 := state.s13
  let n89 : BitVec 1 := (1#1)
  let n90 : Bool := (n88 == n89)
  let n91 : BitVec 1 := (if n90 then c10.snd.snd else c10.snd.fst)
  let n92 : BitVec 1 := (BitVec.extractLsb' 2 1 c7.snd.snd.snd)
  let n93 : BitVec 1 := (1#1)
  let n94 : Bool := (c7.fst.fst == n93)
  let n95 : BitVec 1 := (if n94 then n92 else n91)
  (n92, n95)

abbrev C2LChunk12 := (BitVec 3 × (BitVec 1 × BitVec 1))

@[noinline] def c2lChunk12 (inputs : Inputs) (state : State) (c7 : C2LChunk7) (c10 : C2LChunk10) (c11 : C2LChunk11) : C2LChunk12 :=
  let n96 : BitVec 3 := (c11.snd ++ c10.fst.snd)
  let n97 : BitVec 1 := state.s28
  let n98 : BitVec 1 := state.s27
  let n99 : BitVec 1 := state.s12
  let n100 : BitVec 1 := (1#1)
  let n101 : Bool := (n99 == n100)
  let n102 : BitVec 1 := (if n101 then n98 else n97)
  let n103 : BitVec 1 := (BitVec.extractLsb' 3 1 c7.snd.snd.snd)
  (n96, (n102, n103))

abbrev C2LChunk13 := ((BitVec 4 × BitVec 1) × (BitVec 1 × (BitVec 1 × BitVec 1)))

@[noinline] def c2lChunk13 (inputs : Inputs) (state : State) (c6 : C2LChunk6) (c12 : C2LChunk12) : C2LChunk13 :=
  let n104 : BitVec 1 := (1#1)
  let n105 : Bool := (c6.snd.snd.snd == n104)
  let n106 : BitVec 1 := (if n105 then c12.snd.snd else c12.snd.fst)
  let n107 : BitVec 4 := (n106 ++ c12.fst)
  let n108 : BitVec 1 := state.s26
  let n109 : BitVec 1 := state.s25
  let n110 : BitVec 1 := state.s11
  let n111 : BitVec 1 := (1#1)
  ((n107, n108), (n109, (n110, n111)))

abbrev C2LChunk14 := (BitVec 1 × (BitVec 5 × BitVec 1))

@[noinline] def c2lChunk14 (inputs : Inputs) (state : State) (c6 : C2LChunk6) (c7 : C2LChunk7) (c13 : C2LChunk13) : C2LChunk14 :=
  let n112 : Bool := (c13.snd.snd.fst == c13.snd.snd.snd)
  let n113 : BitVec 1 := (if n112 then c13.snd.fst else c13.fst.snd)
  let n114 : BitVec 1 := (BitVec.extractLsb' 4 1 c7.snd.snd.snd)
  let n115 : BitVec 1 := (1#1)
  let n116 : Bool := (c6.snd.snd.fst == n115)
  let n117 : BitVec 1 := (if n116 then n114 else n113)
  let n118 : BitVec 5 := (n117 ++ c13.fst.fst)
  let n119 : BitVec 1 := state.s24
  (n114, (n118, n119))

abbrev C2LChunk15 := (BitVec 1 × (BitVec 1 × Bool))

@[noinline] def c2lChunk15 (inputs : Inputs) (state : State) (c6 : C2LChunk6) (c7 : C2LChunk7) (c14 : C2LChunk14) : C2LChunk15 :=
  let n120 : BitVec 1 := state.s23
  let n121 : BitVec 1 := state.s10
  let n122 : BitVec 1 := (1#1)
  let n123 : Bool := (n121 == n122)
  let n124 : BitVec 1 := (if n123 then n120 else c14.snd.snd)
  let n125 : BitVec 1 := (BitVec.extractLsb' 5 1 c7.snd.snd.snd)
  let n126 : BitVec 1 := (1#1)
  let n127 : Bool := (c6.snd.fst == n126)
  (n124, (n125, n127))

abbrev C2LChunk16 := (BitVec 6 × BitVec 1)

@[noinline] def c2lChunk16 (inputs : Inputs) (state : State) (c14 : C2LChunk14) (c15 : C2LChunk15) : C2LChunk16 :=
  let n128 : BitVec 1 := (if c15.snd.snd then c15.snd.fst else c15.fst)
  let n129 : BitVec 6 := (n128 ++ c14.snd.fst)
  let n130 : BitVec 1 := state.s22
  let n131 : BitVec 1 := state.s21
  let n132 : BitVec 1 := state.s9
  let n133 : BitVec 1 := (1#1)
  let n134 : Bool := (n132 == n133)
  let n135 : BitVec 1 := (if n134 then n131 else n130)
  (n129, n135)

abbrev C2LChunk17 := ((BitVec 1 × BitVec 7) × (BitVec 1 × (BitVec 1 × BitVec 1)))

@[noinline] def c2lChunk17 (inputs : Inputs) (state : State) (c6 : C2LChunk6) (c7 : C2LChunk7) (c16 : C2LChunk16) : C2LChunk17 :=
  let n136 : BitVec 1 := (BitVec.extractLsb' 6 1 c7.snd.snd.snd)
  let n137 : BitVec 1 := (1#1)
  let n138 : Bool := (c6.fst.snd.snd == n137)
  let n139 : BitVec 1 := (if n138 then n136 else c16.snd)
  let n140 : BitVec 7 := (n139 ++ c16.fst)
  let n141 : BitVec 1 := state.s20
  let n142 : BitVec 1 := state.s19
  let n143 : BitVec 1 := state.s8
  ((n136, n140), (n141, (n142, n143)))

abbrev C2LChunk18 := (BitVec 8 × BitVec 1)

@[noinline] def c2lChunk18 (inputs : Inputs) (state : State) (c6 : C2LChunk6) (c8 : C2LChunk8) (c17 : C2LChunk17) : C2LChunk18 :=
  let n144 : BitVec 1 := (1#1)
  let n145 : Bool := (c17.snd.snd.snd == n144)
  let n146 : BitVec 1 := (if n145 then c17.snd.snd.fst else c17.snd.fst)
  let n147 : BitVec 1 := (1#1)
  let n148 : Bool := (c6.fst.snd.fst == n147)
  let n149 : BitVec 1 := (if n148 then c8.fst else n146)
  let n150 : BitVec 8 := (n149 ++ c17.fst.snd)
  let n151 : BitVec 1 := (BitVec.extractLsb' 7 1 n150)
  (n150, n151)

abbrev C2LChunk19 := (((BitVec 1 × BitVec 1) × (BitVec 1 × BitVec 1)) × ((BitVec 1 × BitVec 1) × (BitVec 1 × BitVec 8)))

@[noinline] def c2lChunk19 (inputs : Inputs) (state : State) (c18 : C2LChunk18) : C2LChunk19 :=
  let n152 : BitVec 1 := (BitVec.extractLsb' 6 1 c18.fst)
  let n153 : BitVec 1 := (BitVec.extractLsb' 5 1 c18.fst)
  let n154 : BitVec 1 := (BitVec.extractLsb' 4 1 c18.fst)
  let n155 : BitVec 1 := (BitVec.extractLsb' 3 1 c18.fst)
  let n156 : BitVec 1 := (BitVec.extractLsb' 2 1 c18.fst)
  let n157 : BitVec 1 := (BitVec.extractLsb' 1 1 c18.fst)
  let n158 : BitVec 1 := (BitVec.extractLsb' 0 1 c18.fst)
  let n159 : BitVec 8 := state.s37
  (((n152, n153), (n154, n155)), ((n156, n157), (n158, n159)))

abbrev C2LChunk20 := (BitVec 8 × BitVec 1)

@[noinline] def c2lChunk20 (inputs : Inputs) (state : State) (c0 : C2LChunk0) : C2LChunk20 :=
  let n160 : BitVec 8 := state.s36
  let n161 : BitVec 1 := state.s6
  let n162 : BitVec 2 := (n161 ++ c0.fst.fst)
  let n163 : BitVec 2 := (1#2)
  let n164 : Bool := (n162 == n163)
  let n165 : BitVec 1 := (1#1)
  let n166 : BitVec 1 := (0#1)
  let n167 : BitVec 1 := (if n164 then n165 else n166)
  (n160, n167)

abbrev C2LChunk21 := ((BitVec 8 × BitVec 8) × (BitVec 8 × (BitVec 2 × BitVec 2)))

@[noinline] def c2lChunk21 (inputs : Inputs) (state : State) (c5 : C2LChunk5) (c19 : C2LChunk19) (c20 : C2LChunk20) : C2LChunk21 :=
  let n168 : BitVec 1 := (1#1)
  let n169 : Bool := (c20.snd == n168)
  let n170 : BitVec 8 := (if n169 then c20.fst else c19.snd.snd.snd)
  let n171 : BitVec 8 := state.s39
  let n172 : BitVec 8 := state.s38
  let n173 : BitVec 1 := state.s7
  let n174 : BitVec 2 := (n173 ++ c5.fst.snd)
  let n175 : BitVec 2 := (2#2)
  ((n170, n171), (n172, (n174, n175)))

abbrev C2LChunk22 := (BitVec 8 × BitVec 8)

@[noinline] def c2lChunk22 (inputs : Inputs) (state : State) (c21 : C2LChunk21) : C2LChunk22 :=
  let n176 : Bool := (c21.snd.snd.fst == c21.snd.snd.snd)
  let n177 : BitVec 1 := (1#1)
  let n178 : BitVec 1 := (0#1)
  let n179 : BitVec 1 := (if n176 then n177 else n178)
  let n180 : BitVec 1 := (1#1)
  let n181 : Bool := (n179 == n180)
  let n182 : BitVec 8 := (if n181 then c21.snd.fst else c21.fst.snd)
  let n183 : BitVec 8 := state.s41
  (n182, n183)

abbrev C2LChunk23 := (BitVec 8 × BitVec 1)

@[noinline] def c2lChunk23 (inputs : Inputs) (state : State) (c7 : C2LChunk7) : C2LChunk23 :=
  let n184 : BitVec 8 := state.s40
  let n185 : BitVec 1 := state.s16
  let n186 : BitVec 2 := (n185 ++ c7.snd.snd.fst)
  let n187 : BitVec 2 := (1#2)
  let n188 : Bool := (n186 == n187)
  let n189 : BitVec 1 := (1#1)
  let n190 : BitVec 1 := (0#1)
  let n191 : BitVec 1 := (if n188 then n189 else n190)
  (n184, n191)

abbrev C2LChunk24 := ((BitVec 8 × BitVec 8) × (BitVec 8 × (BitVec 2 × BitVec 2)))

@[noinline] def c2lChunk24 (inputs : Inputs) (state : State) (c0 : C2LChunk0) (c22 : C2LChunk22) (c23 : C2LChunk23) : C2LChunk24 :=
  let n192 : BitVec 1 := (1#1)
  let n193 : Bool := (c23.snd == n192)
  let n194 : BitVec 8 := (if n193 then c23.fst else c22.snd)
  let n195 : BitVec 8 := state.s43
  let n196 : BitVec 8 := state.s42
  let n197 : BitVec 1 := state.s17
  let n198 : BitVec 2 := (n197 ++ c0.fst.fst)
  let n199 : BitVec 2 := (1#2)
  ((n194, n195), (n196, (n198, n199)))

abbrev C2LChunk25 := (BitVec 8 × BitVec 8)

@[noinline] def c2lChunk25 (inputs : Inputs) (state : State) (c24 : C2LChunk24) : C2LChunk25 :=
  let n200 : Bool := (c24.snd.snd.fst == c24.snd.snd.snd)
  let n201 : BitVec 1 := (1#1)
  let n202 : BitVec 1 := (0#1)
  let n203 : BitVec 1 := (if n200 then n201 else n202)
  let n204 : BitVec 1 := (1#1)
  let n205 : Bool := (n203 == n204)
  let n206 : BitVec 8 := (if n205 then c24.snd.fst else c24.fst.snd)
  let n207 : BitVec 8 := (0#8)
  (n206, n207)

def evaluate (inputs : Inputs) (state : State) : Evaluation :=
  let c0 := c2lChunk0 inputs state
  let c1 := c2lChunk1 inputs state c0
  let c2 := c2lChunk2 inputs state c0 c1
  let c3 := c2lChunk3 inputs state c0
  let c4 := c2lChunk4 inputs state c2 c3
  let c5 := c2lChunk5 inputs state c4
  let c6 := c2lChunk6 inputs state c5
  let c7 := c2lChunk7 inputs state c0 c2 c5 c6
  let c8 := c2lChunk8 inputs state c7
  let c9 := c2lChunk9 inputs state c7 c8
  let c10 := c2lChunk10 inputs state c7 c9
  let c11 := c2lChunk11 inputs state c7 c10
  let c12 := c2lChunk12 inputs state c7 c10 c11
  let c13 := c2lChunk13 inputs state c6 c12
  let c14 := c2lChunk14 inputs state c6 c7 c13
  let c15 := c2lChunk15 inputs state c6 c7 c14
  let c16 := c2lChunk16 inputs state c14 c15
  let c17 := c2lChunk17 inputs state c6 c7 c16
  let c18 := c2lChunk18 inputs state c6 c8 c17
  let c19 := c2lChunk19 inputs state c18
  let c20 := c2lChunk20 inputs state c0
  let c21 := c2lChunk21 inputs state c5 c19 c20
  let c22 := c2lChunk22 inputs state c21
  let c23 := c2lChunk23 inputs state c7
  let c24 := c2lChunk24 inputs state c0 c22 c23
  let c25 := c2lChunk25 inputs state c24
  { outputs := { o0 := c5.fst.fst, o1 := c21.fst.fst, o2 := c22.fst, o3 := c18.fst, o4 := c24.fst.fst, o5 := c25.fst }, nextState := { s0 := c0.snd.fst, s1 := c1.fst.fst, s2 := c2.fst.fst, s3 := c0.fst.fst, s4 := c2.fst.snd, s5 := c5.fst.fst, s6 := c0.fst.fst, s7 := c5.fst.snd, s8 := c6.fst.snd.fst, s9 := c6.fst.snd.snd, s10 := c6.snd.fst, s11 := c6.snd.snd.fst, s12 := c6.snd.snd.snd, s13 := c7.fst.fst, s14 := c7.fst.snd, s15 := c7.snd.fst, s16 := c7.snd.snd.fst, s17 := c0.fst.fst, s18 := c4.snd, s19 := c8.fst, s20 := c18.snd, s21 := c17.fst.fst, s22 := c19.fst.fst.fst, s23 := c15.snd.fst, s24 := c19.fst.fst.snd, s25 := c14.fst, s26 := c19.fst.snd.fst, s27 := c12.snd.snd, s28 := c19.fst.snd.snd, s29 := c11.fst, s30 := c19.snd.fst.fst, s31 := c10.fst.fst, s32 := c19.snd.fst.snd, s33 := c8.snd.snd, s34 := c19.snd.snd.fst, s35 := c25.snd, s36 := c2.fst.snd, s37 := c21.fst.fst, s38 := c2.fst.snd, s39 := c22.fst, s40 := c2.fst.snd, s41 := c24.fst.fst, s42 := c22.fst, s43 := c25.fst },
    outputDefined := true, transitionDefined := true }

def step (inputs : Inputs) (state : State) : Outputs × State :=
  let r := evaluate inputs state
  (r.outputs, r.nextState)

def initialValid (state : State) : Bool :=
  ((state.s0 &&& (1#1)) == (0#1)) &&
  ((state.s1 &&& (1#1)) == (0#1)) &&
  ((state.s2 &&& (1#1)) == (0#1)) &&
  ((state.s3 &&& (1#1)) == (1#1)) &&
  ((state.s4 &&& (255#8)) == (0#8)) &&
  ((state.s5 &&& (255#8)) == (0#8)) &&
  ((state.s6 &&& (1#1)) == (1#1)) &&
  ((state.s7 &&& (1#1)) == (0#1)) &&
  ((state.s8 &&& (1#1)) == (0#1)) &&
  ((state.s9 &&& (1#1)) == (0#1)) &&
  ((state.s10 &&& (1#1)) == (0#1)) &&
  ((state.s11 &&& (1#1)) == (0#1)) &&
  ((state.s12 &&& (1#1)) == (0#1)) &&
  ((state.s13 &&& (1#1)) == (0#1)) &&
  ((state.s14 &&& (1#1)) == (0#1)) &&
  ((state.s15 &&& (1#1)) == (0#1)) &&
  ((state.s16 &&& (1#1)) == (1#1)) &&
  ((state.s17 &&& (1#1)) == (1#1)) &&
  ((state.s18 &&& (1#1)) == (0#1)) &&
  ((state.s19 &&& (1#1)) == (0#1)) &&
  ((state.s20 &&& (1#1)) == (0#1)) &&
  ((state.s21 &&& (1#1)) == (0#1)) &&
  ((state.s22 &&& (1#1)) == (0#1)) &&
  ((state.s23 &&& (1#1)) == (0#1)) &&
  ((state.s24 &&& (1#1)) == (0#1)) &&
  ((state.s25 &&& (1#1)) == (0#1)) &&
  ((state.s26 &&& (1#1)) == (0#1)) &&
  ((state.s27 &&& (1#1)) == (0#1)) &&
  ((state.s28 &&& (1#1)) == (0#1)) &&
  ((state.s29 &&& (1#1)) == (0#1)) &&
  ((state.s30 &&& (1#1)) == (0#1)) &&
  ((state.s31 &&& (1#1)) == (0#1)) &&
  ((state.s32 &&& (1#1)) == (0#1)) &&
  ((state.s33 &&& (1#1)) == (0#1)) &&
  ((state.s34 &&& (1#1)) == (0#1)) &&
  ((state.s35 &&& (255#8)) == (0#8)) &&
  ((state.s36 &&& (255#8)) == (0#8)) &&
  ((state.s37 &&& (255#8)) == (0#8)) &&
  ((state.s38 &&& (255#8)) == (0#8)) &&
  ((state.s39 &&& (255#8)) == (0#8)) &&
  ((state.s40 &&& (255#8)) == (0#8)) &&
  ((state.s41 &&& (255#8)) == (0#8)) &&
  ((state.s42 &&& (255#8)) == (0#8)) &&
  ((state.s43 &&& (255#8)) == (0#8))
end Clocks.All
