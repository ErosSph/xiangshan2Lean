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

abbrev C2LChunk0 := ((BitVec 1 × BitVec 4) × (BitVec 4 × (Bool × BitVec 1)))

@[noinline] def c2lChunk0 (inputs : Inputs) (state : State) : C2LChunk0 :=
  let n0 : BitVec 1 := inputs.i1
  let n1 : BitVec 4 := state.s6
  let n2 : BitVec 4 := state.s5
  let n3 : BitVec 1 := state.s4
  let n4 : BitVec 2 := (n3 ++ n0)
  let n5 : BitVec 2 := (1#2)
  let n6 : Bool := (n4 == n5)
  let n7 : BitVec 1 := (1#1)
  ((n0, n1), (n2, (n6, n7)))

abbrev C2LChunk1 := ((BitVec 4 × BitVec 4) × (BitVec 1 × BitVec 1))

@[noinline] def c2lChunk1 (inputs : Inputs) (state : State) (c0 : C2LChunk0) : C2LChunk1 :=
  let n8 : BitVec 1 := (0#1)
  let n9 : BitVec 1 := (if c0.snd.snd.fst then c0.snd.snd.snd else n8)
  let n10 : BitVec 1 := (1#1)
  let n11 : Bool := (n9 == n10)
  let n12 : BitVec 4 := (if n11 then c0.snd.fst else c0.fst.snd)
  let n13 : BitVec 4 := inputs.i3
  let n14 : BitVec 1 := inputs.i2
  let n15 : BitVec 1 := (1#1)
  ((n12, n13), (n14, n15))

abbrev C2LChunk2 := (BitVec 1 × (BitVec 4 × BitVec 1))

@[noinline] def c2lChunk2 (inputs : Inputs) (state : State) (c1 : C2LChunk1) : C2LChunk2 :=
  let n16 : Bool := (c1.snd.fst == c1.snd.snd)
  let n17 : BitVec 4 := (if n16 then c1.fst.snd else c1.fst.fst)
  let n18 : BitVec 4 := inputs.i5
  let n19 : BitVec 1 := inputs.i0
  let n20 : BitVec 1 := (1#1)
  let n21 : Bool := (n19 == n20)
  let n22 : BitVec 4 := (if n21 then n18 else n17)
  let n23 : BitVec 1 := (1#1)
  (n19, (n22, n23))

abbrev C2LChunk3 := ((BitVec 4 × BitVec 1) × (Bool × (BitVec 1 × BitVec 1)))

@[noinline] def c2lChunk3 (inputs : Inputs) (state : State) (c2 : C2LChunk2) : C2LChunk3 :=
  let n24 : Bool := (c2.fst == c2.snd.snd)
  let n25 : BitVec 4 := (0#4)
  let n26 : BitVec 4 := (if n24 then n25 else c2.snd.fst)
  let n27 : BitVec 1 := (~~~c2.fst)
  let n28 : BitVec 1 := (1#1)
  let n29 : Bool := (n27 == n28)
  let n30 : BitVec 1 := (1#1)
  let n31 : BitVec 1 := (0#1)
  ((n26, n27), (n29, (n30, n31)))

abbrev C2LChunk4 := (BitVec 1 × (BitVec 1 × Bool))

@[noinline] def c2lChunk4 (inputs : Inputs) (state : State) (c3 : C2LChunk3) : C2LChunk4 :=
  let n32 : BitVec 1 := (if c3.snd.fst then c3.snd.snd.fst else c3.snd.snd.snd)
  let n33 : BitVec 1 := (1#1)
  let n34 : Bool := (c3.fst.snd == n33)
  let n35 : BitVec 1 := (1#1)
  let n36 : BitVec 1 := (0#1)
  let n37 : BitVec 1 := (if n34 then n35 else n36)
  let n38 : BitVec 1 := (1#1)
  let n39 : Bool := (c3.fst.snd == n38)
  (n32, (n37, n39))

abbrev C2LChunk5 := (BitVec 1 × BitVec 1)

@[noinline] def c2lChunk5 (inputs : Inputs) (state : State) (c3 : C2LChunk3) (c4 : C2LChunk4) : C2LChunk5 :=
  let n40 : BitVec 1 := (1#1)
  let n41 : BitVec 1 := (0#1)
  let n42 : BitVec 1 := (if c4.snd.snd then n40 else n41)
  let n43 : BitVec 1 := (1#1)
  let n44 : Bool := (c3.fst.snd == n43)
  let n45 : BitVec 1 := (1#1)
  let n46 : BitVec 1 := (0#1)
  let n47 : BitVec 1 := (if n44 then n45 else n46)
  (n42, n47)

abbrev C2LChunk6 := (BitVec 1 × BitVec 8)

@[noinline] def c2lChunk6 (inputs : Inputs) (state : State) (c1 : C2LChunk1) : C2LChunk6 :=
  let n48 : BitVec 28 := (0#28)
  let n49 : BitVec 32 := (n48 ++ c1.fst.fst)
  let n50 : BitVec 32 := (3#32)
  let n51 : Bool := (n49 == n50)
  let n52 : BitVec 1 := (1#1)
  let n53 : BitVec 1 := (0#1)
  let n54 : BitVec 1 := (if n51 then n52 else n53)
  let n55 : BitVec 8 := (c1.fst.snd ++ c1.fst.fst)
  (n54, n55)

abbrev C2LChunk7 := (BitVec 1 × (BitVec 32 × BitVec 32))

@[noinline] def c2lChunk7 (inputs : Inputs) (state : State) (c1 : C2LChunk1) : C2LChunk7 :=
  let n56 : BitVec 4 := inputs.i4
  let n57 : Bool := (c1.fst.fst == n56)
  let n58 : BitVec 1 := (1#1)
  let n59 : BitVec 1 := (0#1)
  let n60 : BitVec 1 := (if n57 then n58 else n59)
  let n61 : BitVec 28 := (0#28)
  let n62 : BitVec 32 := (n61 ++ c1.fst.snd)
  let n63 : BitVec 32 := (12#32)
  (n60, (n62, n63))

abbrev C2LChunk8 := ((BitVec 1 × BitVec 1) × (BitVec 2 × BitVec 2))

@[noinline] def c2lChunk8 (inputs : Inputs) (state : State) (c0 : C2LChunk0) (c7 : C2LChunk7) : C2LChunk8 :=
  let n64 : Bool := (decide (c7.snd.snd.toNat > c7.snd.fst.toNat))
  let n65 : BitVec 1 := (1#1)
  let n66 : BitVec 1 := (0#1)
  let n67 : BitVec 1 := (if n64 then n65 else n66)
  let n68 : BitVec 1 := state.s7
  let n69 : BitVec 1 := state.s0
  let n70 : BitVec 2 := (n69 ++ c0.fst.fst)
  let n71 : BitVec 2 := (1#2)
  ((n67, n68), (n70, n71))

abbrev C2LChunk9 := ((BitVec 1 × BitVec 1) × (BitVec 1 × BitVec 1))

@[noinline] def c2lChunk9 (inputs : Inputs) (state : State) (c8 : C2LChunk8) : C2LChunk9 :=
  let n72 : Bool := (c8.snd.fst == c8.snd.snd)
  let n73 : BitVec 1 := (1#1)
  let n74 : BitVec 1 := (0#1)
  let n75 : BitVec 1 := (if n72 then n73 else n74)
  let n76 : BitVec 1 := (c8.fst.snd &&& n75)
  let n77 : BitVec 1 := state.s11
  let n78 : BitVec 1 := state.s8
  let n79 : BitVec 1 := state.s1
  ((n76, n77), (n78, n79))

abbrev C2LChunk10 := (BitVec 1 × BitVec 8)

@[noinline] def c2lChunk10 (inputs : Inputs) (state : State) (c0 : C2LChunk0) (c9 : C2LChunk9) : C2LChunk10 :=
  let n80 : BitVec 2 := (c9.snd.snd ++ c0.fst.fst)
  let n81 : BitVec 2 := (1#2)
  let n82 : Bool := (n80 == n81)
  let n83 : BitVec 1 := (1#1)
  let n84 : BitVec 1 := (0#1)
  let n85 : BitVec 1 := (if n82 then n83 else n84)
  let n86 : BitVec 1 := (c9.snd.fst &&& n85)
  let n87 : BitVec 8 := state.s12
  (n86, n87)

abbrev C2LChunk11 := (BitVec 1 × BitVec 1)

@[noinline] def c2lChunk11 (inputs : Inputs) (state : State) (c0 : C2LChunk0) : C2LChunk11 :=
  let n88 : BitVec 1 := state.s9
  let n89 : BitVec 1 := state.s2
  let n90 : BitVec 2 := (n89 ++ c0.fst.fst)
  let n91 : BitVec 2 := (1#2)
  let n92 : Bool := (n90 == n91)
  let n93 : BitVec 1 := (1#1)
  let n94 : BitVec 1 := (0#1)
  let n95 : BitVec 1 := (if n92 then n93 else n94)
  (n88, n95)

abbrev C2LChunk12 := ((BitVec 1 × BitVec 1) × (BitVec 1 × (Bool × BitVec 1)))

@[noinline] def c2lChunk12 (inputs : Inputs) (state : State) (c0 : C2LChunk0) (c11 : C2LChunk11) : C2LChunk12 :=
  let n96 : BitVec 1 := (c11.fst &&& c11.snd)
  let n97 : BitVec 1 := state.s13
  let n98 : BitVec 1 := state.s10
  let n99 : BitVec 1 := state.s3
  let n100 : BitVec 2 := (n99 ++ c0.fst.fst)
  let n101 : BitVec 2 := (1#2)
  let n102 : Bool := (n100 == n101)
  let n103 : BitVec 1 := (1#1)
  ((n96, n97), (n98, (n102, n103)))

abbrev C2LChunk13 := (BitVec 1 × BitVec 1)

@[noinline] def c2lChunk13 (inputs : Inputs) (state : State) (c12 : C2LChunk12) : C2LChunk13 :=
  let n104 : BitVec 1 := (0#1)
  let n105 : BitVec 1 := (if c12.snd.snd.fst then c12.snd.snd.snd else n104)
  let n106 : BitVec 1 := (c12.snd.fst &&& n105)
  let n107 : BitVec 1 := state.s14
  (n106, n107)

def evaluate (inputs : Inputs) (state : State) : Evaluation :=
  let c0 := c2lChunk0 inputs state
  let c1 := c2lChunk1 inputs state c0
  let c2 := c2lChunk2 inputs state c1
  let c3 := c2lChunk3 inputs state c2
  let c4 := c2lChunk4 inputs state c3
  let c5 := c2lChunk5 inputs state c3 c4
  let c6 := c2lChunk6 inputs state c1
  let c7 := c2lChunk7 inputs state c1
  let c8 := c2lChunk8 inputs state c0 c7
  let c9 := c2lChunk9 inputs state c8
  let c10 := c2lChunk10 inputs state c0 c9
  let c11 := c2lChunk11 inputs state c0
  let c12 := c2lChunk12 inputs state c0 c11
  let c13 := c2lChunk13 inputs state c12
  { outputs := { o0 := c1.fst.fst, o1 := c9.fst.fst, o2 := c9.fst.snd, o3 := c10.fst, o4 := c10.snd, o5 := c12.fst.fst, o6 := c12.fst.snd, o7 := c13.fst, o8 := c13.snd }, nextState := { s0 := c0.fst.fst, s1 := c0.fst.fst, s2 := c0.fst.fst, s3 := c0.fst.fst, s4 := c0.fst.fst, s5 := c3.fst.fst, s6 := c1.fst.fst, s7 := c4.fst, s8 := c4.snd.fst, s9 := c5.fst, s10 := c5.snd, s11 := c6.fst, s12 := c6.snd, s13 := c7.fst, s14 := c8.fst.fst },
    outputDefined := true, transitionDefined := true, checksValid := (c12.fst.fst == 0 || c12.fst.snd != 0) && (c13.fst == 0 || c13.snd != 0) }

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
