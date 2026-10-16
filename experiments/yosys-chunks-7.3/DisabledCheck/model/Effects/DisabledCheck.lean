-- Generated from locked Yosys FunctionalIR. Fixed circuit; explicit initial state.
import Lean
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
namespace Effects.DisabledCheck
structure Inputs where
  i0 : BitVec 4
  i1 : BitVec 4
  i2 : BitVec 1

structure State where

structure Outputs where
  o0 : BitVec 1
  o1 : BitVec 1
  o2 : BitVec 1

structure Evaluation where
  outputs : Outputs
  nextState : State
  outputDefined : Bool
  transitionDefined : Bool
  checksValid : Bool

abbrev C2LChunk0 := (BitVec 1 × (BitVec 4 × BitVec 28))

@[noinline] def c2lChunk0 (inputs : Inputs) (state : State) : C2LChunk0 :=
  let n0 : BitVec 1 := inputs.i2
  let n1 : BitVec 1 := (1#1)
  let n2 : Bool := (n0 == n1)
  let n3 : BitVec 1 := (1#1)
  let n4 : BitVec 1 := (0#1)
  let n5 : BitVec 1 := (if n2 then n3 else n4)
  let n6 : BitVec 4 := inputs.i0
  let n7 : BitVec 28 := (0#28)
  (n5, (n6, n7))

abbrev C2LChunk1 := (Bool × (Bool × BitVec 1))

@[noinline] def c2lChunk1 (inputs : Inputs) (state : State) (c0 : C2LChunk0) : C2LChunk1 :=
  let n8 : BitVec 32 := (c0.snd.snd ++ c0.snd.fst)
  let n9 : BitVec 4 := inputs.i1
  let n10 : BitVec 28 := (0#28)
  let n11 : BitVec 32 := (n10 ++ n9)
  let n12 : BitVec 32 := (BitVec.udiv n8 n11)
  let d12 : Bool := (n11 != 0)
  let n13 : BitVec 32 := (0#32)
  let n14 : Bool := (decide (n12.toNat > n13.toNat))
  let d14 : Bool := d12
  let n15 : BitVec 1 := (1#1)
  (n14, (d14, n15))

abbrev C2LChunk2 := (BitVec 1 × (Bool × BitVec 1))

@[noinline] def c2lChunk2 (inputs : Inputs) (state : State) (c1 : C2LChunk1) : C2LChunk2 :=
  let n16 : BitVec 1 := (0#1)
  let n17 : BitVec 1 := (if c1.fst then c1.snd.snd else n16)
  let d17 : Bool := c1.snd.fst
  let n18 : BitVec 1 := (1#1)
  (n17, (d17, n18))

def evaluate (inputs : Inputs) (state : State) : Evaluation :=
  let c0 := c2lChunk0 inputs state
  let c1 := c2lChunk1 inputs state c0
  let c2 := c2lChunk2 inputs state c1
  { outputs := { o0 := c2.snd.snd, o1 := c0.fst, o2 := c2.fst }, nextState := ⟨⟩,
    outputDefined := (c0.fst == 0 || c2.snd.fst), transitionDefined := true, checksValid := (c0.fst == 0 || c2.fst != 0) }

def step (inputs : Inputs) (state : State) : Outputs × State :=
  let r := evaluate inputs state
  (r.outputs, r.nextState)

def initialValid (state : State) : Bool :=
  true
end Effects.DisabledCheck
