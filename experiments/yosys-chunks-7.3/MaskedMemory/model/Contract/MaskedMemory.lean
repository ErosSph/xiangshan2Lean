-- Generated from locked Yosys FunctionalIR. Fixed circuit; explicit initial state.
import Lean
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
namespace Contract.MaskedMemory
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

structure State where
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
  s16 : (BitVec 2 → BitVec 8)

structure Outputs where
  o0 : BitVec 8

structure Evaluation where
  outputs : Outputs
  nextState : State
  outputDefined : Bool
  transitionDefined : Bool

abbrev C2LChunk0 := ((BitVec 1 × BitVec 1) × (BitVec 2 × (Bool × BitVec 1)))

@[noinline] def c2lChunk0 (inputs : Inputs) (state : State) : C2LChunk0 :=
  let n0 : BitVec 1 := inputs.i0
  let n1 : BitVec 1 := inputs.i5
  let n2 : BitVec 2 := inputs.i7
  let n3 : BitVec 1 := (BitVec.extractLsb' 1 1 n2)
  let n4 : BitVec 1 := (n1 &&& n3)
  let n5 : BitVec 1 := (1#1)
  let n6 : Bool := (n4 == n5)
  let n7 : BitVec 1 := (1#1)
  ((n0, n1), (n2, (n6, n7)))

abbrev C2LChunk1 := (BitVec 8 × BitVec 1)

@[noinline] def c2lChunk1 (inputs : Inputs) (state : State) (c0 : C2LChunk0) : C2LChunk1 :=
  let n8 : BitVec 1 := (0#1)
  let n9 : BitVec 1 := (if c0.snd.snd.fst then c0.snd.snd.snd else n8)
  let n10 : BitVec 1 := (1#1)
  let n11 : Bool := (n9 == n10)
  let n12 : BitVec 8 := (240#8)
  let n13 : BitVec 8 := (0#8)
  let n14 : BitVec 8 := (if n11 then n12 else n13)
  let n15 : BitVec 1 := inputs.i4
  (n14, n15)

abbrev C2LChunk2 := (BitVec 2 × BitVec 1)

@[noinline] def c2lChunk2 (inputs : Inputs) (state : State) (c1 : C2LChunk1) : C2LChunk2 :=
  let n16 : BitVec 2 := inputs.i6
  let n17 : BitVec 1 := (BitVec.extractLsb' 1 1 n16)
  let n18 : BitVec 1 := (c1.snd &&& n17)
  let n19 : BitVec 1 := (1#1)
  let n20 : Bool := (n18 == n19)
  let n21 : BitVec 1 := (1#1)
  let n22 : BitVec 1 := (0#1)
  let n23 : BitVec 1 := (if n20 then n21 else n22)
  (n16, n23)

abbrev C2LChunk3 := (BitVec 8 × (BitVec 1 × BitVec 1))

@[noinline] def c2lChunk3 (inputs : Inputs) (state : State) (c0 : C2LChunk0) (c2 : C2LChunk2) : C2LChunk3 :=
  let n24 : BitVec 1 := (1#1)
  let n25 : Bool := (c2.snd == n24)
  let n26 : BitVec 8 := (240#8)
  let n27 : BitVec 8 := (0#8)
  let n28 : BitVec 8 := (if n25 then n26 else n27)
  let n29 : BitVec 1 := (BitVec.extractLsb' 0 1 c0.snd.fst)
  let n30 : BitVec 1 := (c0.fst.snd &&& n29)
  let n31 : BitVec 1 := (1#1)
  (n28, (n30, n31))

abbrev C2LChunk4 := (Bool × (BitVec 8 × BitVec 8))

@[noinline] def c2lChunk4 (inputs : Inputs) (state : State) (c3 : C2LChunk3) : C2LChunk4 :=
  let n32 : Bool := (c3.snd.fst == c3.snd.snd)
  let n33 : BitVec 1 := (1#1)
  let n34 : BitVec 1 := (0#1)
  let n35 : BitVec 1 := (if n32 then n33 else n34)
  let n36 : BitVec 1 := (1#1)
  let n37 : Bool := (n35 == n36)
  let n38 : BitVec 8 := (15#8)
  let n39 : BitVec 8 := (0#8)
  (n37, (n38, n39))

abbrev C2LChunk5 := (BitVec 8 × BitVec 1)

@[noinline] def c2lChunk5 (inputs : Inputs) (state : State) (c1 : C2LChunk1) (c2 : C2LChunk2) (c4 : C2LChunk4) : C2LChunk5 :=
  let n40 : BitVec 8 := (if c4.fst then c4.snd.fst else c4.snd.snd)
  let n41 : BitVec 1 := (BitVec.extractLsb' 0 1 c2.fst)
  let n42 : BitVec 1 := (c1.snd &&& n41)
  let n43 : BitVec 1 := (1#1)
  let n44 : Bool := (n42 == n43)
  let n45 : BitVec 1 := (1#1)
  let n46 : BitVec 1 := (0#1)
  let n47 : BitVec 1 := (if n44 then n45 else n46)
  (n40, n47)

abbrev C2LChunk6 := ((BitVec 8 × BitVec 4) × (BitVec 8 × BitVec 4))

@[noinline] def c2lChunk6 (inputs : Inputs) (state : State) (c5 : C2LChunk5) : C2LChunk6 :=
  let n48 : BitVec 1 := (1#1)
  let n49 : Bool := (c5.snd == n48)
  let n50 : BitVec 8 := (15#8)
  let n51 : BitVec 8 := (0#8)
  let n52 : BitVec 8 := (if n49 then n50 else n51)
  let n53 : BitVec 4 := inputs.i10
  let n54 : BitVec 8 := inputs.i9
  let n55 : BitVec 4 := (BitVec.extractLsb' 4 4 n54)
  ((n52, n53), (n54, n55))

abbrev C2LChunk7 := ((BitVec 8 × (BitVec 2 × BitVec 8)) × (BitVec 8 × (BitVec 2 × BitVec 4)))

@[noinline] def c2lChunk7 (inputs : Inputs) (state : State) (c6 : C2LChunk6) : C2LChunk7 :=
  let n56 : BitVec 8 := (c6.snd.snd ++ c6.fst.snd)
  let n57 : BitVec 2 := inputs.i2
  let n58 : BitVec 4 := inputs.i11
  let n59 : BitVec 8 := inputs.i8
  let n60 : BitVec 4 := (BitVec.extractLsb' 4 4 n59)
  let n61 : BitVec 8 := (n60 ++ n58)
  let n62 : BitVec 2 := inputs.i1
  let n63 : BitVec 4 := (BitVec.extractLsb' 0 4 c6.snd.fst)
  ((n56, (n57, n59)), (n61, (n62, n63)))

abbrev C2LChunk8 := ((BitVec 8 × BitVec 8) × ((BitVec 2 → BitVec 8) × (BitVec 2 × BitVec 8)))

@[noinline] def c2lChunk8 (inputs : Inputs) (state : State) (c7 : C2LChunk7) : C2LChunk8 :=
  let n64 : BitVec 4 := inputs.i12
  let n65 : BitVec 8 := (n64 ++ c7.snd.snd.snd)
  let n66 : BitVec 4 := (BitVec.extractLsb' 0 4 c7.fst.snd.snd)
  let n67 : BitVec 4 := inputs.i13
  let n68 : BitVec 8 := (n67 ++ n66)
  let n69 : (BitVec 2 → BitVec 8) := state.s16
  let n70 : BitVec 2 := state.s15
  let n71 : BitVec 8 := (n69 n70)
  ((n65, n68), (n69, (n70, n71)))

abbrev C2LChunk9 := (BitVec 8 × BitVec 1)

@[noinline] def c2lChunk9 (inputs : Inputs) (state : State) (c0 : C2LChunk0) : C2LChunk9 :=
  let n72 : BitVec 8 := state.s7
  let n73 : BitVec 1 := state.s3
  let n74 : BitVec 2 := (c0.fst.fst ++ n73)
  let n75 : BitVec 2 := (2#2)
  let n76 : Bool := (n74 == n75)
  let n77 : BitVec 1 := (1#1)
  let n78 : BitVec 1 := (0#1)
  let n79 : BitVec 1 := (if n76 then n77 else n78)
  (n72, n79)

abbrev C2LChunk10 := (BitVec 8 × BitVec 8)

@[noinline] def c2lChunk10 (inputs : Inputs) (state : State) (c8 : C2LChunk8) (c9 : C2LChunk9) : C2LChunk10 :=
  let n80 : BitVec 1 := (1#1)
  let n81 : Bool := (c9.snd == n80)
  let n82 : BitVec 8 := (0#8)
  let n83 : BitVec 8 := (if n81 then c9.fst else n82)
  let n84 : BitVec 8 := (~~~n83)
  let n85 : BitVec 8 := (c8.snd.snd.snd &&& n84)
  let n86 : BitVec 8 := state.s14
  let n87 : BitVec 8 := (n86 &&& n83)
  (n85, n87)

abbrev C2LChunk11 := (((BitVec 2 → BitVec 8) × (BitVec 2 × BitVec 8)) × (BitVec 8 × (BitVec 2 × BitVec 2)))

@[noinline] def c2lChunk11 (inputs : Inputs) (state : State) (c0 : C2LChunk0) (c8 : C2LChunk8) (c10 : C2LChunk10) : C2LChunk11 :=
  let n88 : BitVec 8 := (c10.fst ||| c10.snd)
  let n89 : (BitVec 2 → BitVec 8) := (fun address => if address == c8.snd.snd.fst then n88 else c8.snd.fst address)
  let n90 : BitVec 2 := state.s13
  let n91 : BitVec 8 := (n89 n90)
  let n92 : BitVec 8 := state.s6
  let n93 : BitVec 1 := state.s2
  let n94 : BitVec 2 := (c0.fst.fst ++ n93)
  let n95 : BitVec 2 := (2#2)
  ((n89, (n90, n91)), (n92, (n94, n95)))

abbrev C2LChunk12 := BitVec 8

@[noinline] def c2lChunk12 (inputs : Inputs) (state : State) (c11 : C2LChunk11) : C2LChunk12 :=
  let n96 : Bool := (c11.snd.snd.fst == c11.snd.snd.snd)
  let n97 : BitVec 1 := (1#1)
  let n98 : BitVec 1 := (0#1)
  let n99 : BitVec 1 := (if n96 then n97 else n98)
  let n100 : BitVec 1 := (1#1)
  let n101 : Bool := (n99 == n100)
  let n102 : BitVec 8 := (0#8)
  let n103 : BitVec 8 := (if n101 then c11.snd.fst else n102)
  n103

abbrev C2LChunk13 := ((BitVec 2 → BitVec 8) × (BitVec 2 × BitVec 8))

@[noinline] def c2lChunk13 (inputs : Inputs) (state : State) (c11 : C2LChunk11) (c12 : C2LChunk12) : C2LChunk13 :=
  let n104 : BitVec 8 := (~~~c12)
  let n105 : BitVec 8 := (c11.fst.snd.snd &&& n104)
  let n106 : BitVec 8 := state.s12
  let n107 : BitVec 8 := (n106 &&& c12)
  let n108 : BitVec 8 := (n105 ||| n107)
  let n109 : (BitVec 2 → BitVec 8) := (fun address => if address == c11.fst.snd.fst then n108 else c11.fst.fst address)
  let n110 : BitVec 2 := state.s11
  let n111 : BitVec 8 := (n109 n110)
  (n109, (n110, n111))

abbrev C2LChunk14 := (BitVec 8 × BitVec 1)

@[noinline] def c2lChunk14 (inputs : Inputs) (state : State) (c0 : C2LChunk0) : C2LChunk14 :=
  let n112 : BitVec 8 := state.s5
  let n113 : BitVec 1 := state.s1
  let n114 : BitVec 2 := (c0.fst.fst ++ n113)
  let n115 : BitVec 2 := (2#2)
  let n116 : Bool := (n114 == n115)
  let n117 : BitVec 1 := (1#1)
  let n118 : BitVec 1 := (0#1)
  let n119 : BitVec 1 := (if n116 then n117 else n118)
  (n112, n119)

abbrev C2LChunk15 := (BitVec 8 × BitVec 8)

@[noinline] def c2lChunk15 (inputs : Inputs) (state : State) (c13 : C2LChunk13) (c14 : C2LChunk14) : C2LChunk15 :=
  let n120 : BitVec 1 := (1#1)
  let n121 : Bool := (c14.snd == n120)
  let n122 : BitVec 8 := (0#8)
  let n123 : BitVec 8 := (if n121 then c14.fst else n122)
  let n124 : BitVec 8 := (~~~n123)
  let n125 : BitVec 8 := (c13.snd.snd &&& n124)
  let n126 : BitVec 8 := state.s10
  let n127 : BitVec 8 := (n126 &&& n123)
  (n125, n127)

abbrev C2LChunk16 := (((BitVec 2 → BitVec 8) × (BitVec 2 × BitVec 8)) × (BitVec 8 × (BitVec 2 × BitVec 2)))

@[noinline] def c2lChunk16 (inputs : Inputs) (state : State) (c0 : C2LChunk0) (c13 : C2LChunk13) (c15 : C2LChunk15) : C2LChunk16 :=
  let n128 : BitVec 8 := (c15.fst ||| c15.snd)
  let n129 : (BitVec 2 → BitVec 8) := (fun address => if address == c13.snd.fst then n128 else c13.fst address)
  let n130 : BitVec 2 := state.s9
  let n131 : BitVec 8 := (n129 n130)
  let n132 : BitVec 8 := state.s4
  let n133 : BitVec 1 := state.s0
  let n134 : BitVec 2 := (c0.fst.fst ++ n133)
  let n135 : BitVec 2 := (2#2)
  ((n129, (n130, n131)), (n132, (n134, n135)))

abbrev C2LChunk17 := BitVec 8

@[noinline] def c2lChunk17 (inputs : Inputs) (state : State) (c16 : C2LChunk16) : C2LChunk17 :=
  let n136 : Bool := (c16.snd.snd.fst == c16.snd.snd.snd)
  let n137 : BitVec 1 := (1#1)
  let n138 : BitVec 1 := (0#1)
  let n139 : BitVec 1 := (if n136 then n137 else n138)
  let n140 : BitVec 1 := (1#1)
  let n141 : Bool := (n139 == n140)
  let n142 : BitVec 8 := (0#8)
  let n143 : BitVec 8 := (if n141 then c16.snd.fst else n142)
  n143

abbrev C2LChunk18 := ((BitVec 2 → BitVec 8) × BitVec 8)

@[noinline] def c2lChunk18 (inputs : Inputs) (state : State) (c16 : C2LChunk16) (c17 : C2LChunk17) : C2LChunk18 :=
  let n144 : BitVec 8 := (~~~c17)
  let n145 : BitVec 8 := (c16.fst.snd.snd &&& n144)
  let n146 : BitVec 8 := state.s8
  let n147 : BitVec 8 := (n146 &&& c17)
  let n148 : BitVec 8 := (n145 ||| n147)
  let n149 : (BitVec 2 → BitVec 8) := (fun address => if address == c16.fst.snd.fst then n148 else c16.fst.fst address)
  let n150 : BitVec 2 := inputs.i3
  let n151 : BitVec 8 := (n149 n150)
  (n149, n151)

def evaluate (inputs : Inputs) (state : State) : Evaluation :=
  let c0 := c2lChunk0 inputs state
  let c1 := c2lChunk1 inputs state c0
  let c2 := c2lChunk2 inputs state c1
  let c3 := c2lChunk3 inputs state c0 c2
  let c4 := c2lChunk4 inputs state c3
  let c5 := c2lChunk5 inputs state c1 c2 c4
  let c6 := c2lChunk6 inputs state c5
  let c7 := c2lChunk7 inputs state c6
  let c8 := c2lChunk8 inputs state c7
  let c9 := c2lChunk9 inputs state c0
  let c10 := c2lChunk10 inputs state c8 c9
  let c11 := c2lChunk11 inputs state c0 c8 c10
  let c12 := c2lChunk12 inputs state c11
  let c13 := c2lChunk13 inputs state c11 c12
  let c14 := c2lChunk14 inputs state c0
  let c15 := c2lChunk15 inputs state c13 c14
  let c16 := c2lChunk16 inputs state c0 c13 c15
  let c17 := c2lChunk17 inputs state c16
  let c18 := c2lChunk18 inputs state c16 c17
  { outputs := { o0 := c18.snd }, nextState := { s0 := c0.fst.fst, s1 := c0.fst.fst, s2 := c0.fst.fst, s3 := c0.fst.fst, s4 := c1.fst, s5 := c3.fst, s6 := c5.fst, s7 := c6.fst.fst, s8 := c7.fst.fst, s9 := c7.fst.snd.fst, s10 := c7.snd.fst, s11 := c7.snd.snd.fst, s12 := c8.fst.fst, s13 := c7.fst.snd.fst, s14 := c8.fst.snd, s15 := c7.snd.snd.fst, s16 := c18.fst },
    outputDefined := true, transitionDefined := true }

def step (inputs : Inputs) (state : State) : Outputs × State :=
  let r := evaluate inputs state
  (r.outputs, r.nextState)

def initialValid (state : State) : Bool :=
  ((state.s0 &&& (1#1)) == (1#1)) &&
  ((state.s1 &&& (1#1)) == (1#1)) &&
  ((state.s2 &&& (1#1)) == (1#1)) &&
  ((state.s3 &&& (1#1)) == (1#1))
end Contract.MaskedMemory
