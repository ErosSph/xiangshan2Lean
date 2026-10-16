-- Generated from locked Yosys FunctionalIR. Fixed circuit; explicit initial state.
import Lean
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
namespace SRAM.SramArray2P
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
  s4 : BitVec 3
  s5 : BitVec 3
  s6 : BitVec 16
  s7 : BitVec 16
  s8 : BitVec 1
  s9 : BitVec 1
  s10 : BitVec 16
  s11 : BitVec 3
  s12 : BitVec 16
  s13 : BitVec 3
  s14 : (BitVec 3 → BitVec 16)

structure Outputs where
  o0 : BitVec 16

structure Evaluation where
  outputs : Outputs
  nextState : State
  outputDefined : Bool
  transitionDefined : Bool

def evaluate (inputs : Inputs) (state : State) : Evaluation :=
  let n0 : BitVec 1 := inputs.i2
  let n1 : BitVec 1 := inputs.i3
  let n2 : BitVec 3 := inputs.i6
  let n3 : BitVec 3 := state.s5
  let n4 : BitVec 3 := state.s4
  let n5 : BitVec 1 := state.s0
  let n6 : BitVec 2 := (n5 ++ n0)
  let n7 : BitVec 2 := (1#2)
  let n8 : Bool := (n6 == n7)
  let n9 : BitVec 1 := (1#1)
  let n10 : BitVec 1 := (0#1)
  let n11 : BitVec 1 := (if n8 then n9 else n10)
  let n12 : BitVec 1 := (1#1)
  let n13 : Bool := (n11 == n12)
  let n14 : BitVec 3 := (if n13 then n4 else n3)
  let n15 : BitVec 1 := inputs.i5
  let n16 : BitVec 2 := inputs.i9
  let n17 : BitVec 1 := (BitVec.extractLsb' 1 1 n16)
  let n18 : BitVec 1 := (n15 &&& n17)
  let n19 : BitVec 1 := (1#1)
  let n20 : Bool := (n18 == n19)
  let n21 : BitVec 1 := (1#1)
  let n22 : BitVec 1 := (0#1)
  let n23 : BitVec 1 := (if n20 then n21 else n22)
  let n24 : BitVec 1 := (1#1)
  let n25 : Bool := (n23 == n24)
  let n26 : BitVec 16 := (65280#16)
  let n27 : BitVec 16 := (0#16)
  let n28 : BitVec 16 := (if n25 then n26 else n27)
  let n29 : BitVec 1 := (BitVec.extractLsb' 0 1 n16)
  let n30 : BitVec 1 := (n15 &&& n29)
  let n31 : BitVec 1 := (1#1)
  let n32 : Bool := (n30 == n31)
  let n33 : BitVec 1 := (1#1)
  let n34 : BitVec 1 := (0#1)
  let n35 : BitVec 1 := (if n32 then n33 else n34)
  let n36 : BitVec 1 := (1#1)
  let n37 : Bool := (n35 == n36)
  let n38 : BitVec 16 := (255#16)
  let n39 : BitVec 16 := (0#16)
  let n40 : BitVec 16 := (if n37 then n38 else n39)
  let n41 : BitVec 1 := inputs.i4
  let n42 : BitVec 1 := state.s9
  let n43 : BitVec 1 := state.s8
  let n44 : BitVec 1 := state.s3
  let n45 : BitVec 2 := (n44 ++ n0)
  let n46 : BitVec 2 := (1#2)
  let n47 : Bool := (n45 == n46)
  let n48 : BitVec 1 := (1#1)
  let n49 : BitVec 1 := (0#1)
  let n50 : BitVec 1 := (if n47 then n48 else n49)
  let n51 : BitVec 1 := (1#1)
  let n52 : Bool := (n50 == n51)
  let n53 : BitVec 1 := (if n52 then n43 else n42)
  let n54 : BitVec 8 := inputs.i10
  let n55 : BitVec 16 := inputs.i8
  let n56 : BitVec 8 := (BitVec.extractLsb' 8 8 n55)
  let n57 : BitVec 16 := (n56 ++ n54)
  let n58 : BitVec 3 := inputs.i7
  let n59 : BitVec 8 := (BitVec.extractLsb' 0 8 n55)
  let n60 : BitVec 8 := inputs.i11
  let n61 : BitVec 16 := (n60 ++ n59)
  let n62 : (BitVec 3 → BitVec 16) := state.s14
  let n63 : BitVec 3 := state.s13
  let n64 : BitVec 16 := (n62 n63)
  let n65 : BitVec 16 := state.s7
  let n66 : BitVec 1 := state.s2
  let n67 : BitVec 2 := (n1 ++ n66)
  let n68 : BitVec 2 := (2#2)
  let n69 : Bool := (n67 == n68)
  let n70 : BitVec 1 := (1#1)
  let n71 : BitVec 1 := (0#1)
  let n72 : BitVec 1 := (if n69 then n70 else n71)
  let n73 : BitVec 1 := (1#1)
  let n74 : Bool := (n72 == n73)
  let n75 : BitVec 16 := (0#16)
  let n76 : BitVec 16 := (if n74 then n65 else n75)
  let n77 : BitVec 16 := (~~~n76)
  let n78 : BitVec 16 := (n64 &&& n77)
  let n79 : BitVec 16 := state.s12
  let n80 : BitVec 16 := (n79 &&& n76)
  let n81 : BitVec 16 := (n78 ||| n80)
  let n82 : (BitVec 3 → BitVec 16) := (fun address => if address == n63 then n81 else n62 address)
  let n83 : BitVec 3 := state.s11
  let n84 : BitVec 16 := (n82 n83)
  let n85 : BitVec 16 := state.s6
  let n86 : BitVec 1 := state.s1
  let n87 : BitVec 2 := (n1 ++ n86)
  let n88 : BitVec 2 := (2#2)
  let n89 : Bool := (n87 == n88)
  let n90 : BitVec 1 := (1#1)
  let n91 : BitVec 1 := (0#1)
  let n92 : BitVec 1 := (if n89 then n90 else n91)
  let n93 : BitVec 1 := (1#1)
  let n94 : Bool := (n92 == n93)
  let n95 : BitVec 16 := (0#16)
  let n96 : BitVec 16 := (if n94 then n85 else n95)
  let n97 : BitVec 16 := (~~~n96)
  let n98 : BitVec 16 := (n84 &&& n97)
  let n99 : BitVec 16 := state.s10
  let n100 : BitVec 16 := (n99 &&& n96)
  let n101 : BitVec 16 := (n98 ||| n100)
  let n102 : (BitVec 3 → BitVec 16) := (fun address => if address == n83 then n101 else n82 address)
  let n103 : BitVec 16 := inputs.i12
  let n104 : BitVec 16 := (n102 n14)
  let n105 : BitVec 1 := (1#1)
  let n106 : Bool := (n53 == n105)
  let n107 : BitVec 16 := (if n106 then n104 else n103)
  { outputs := { o0 := n107 }, nextState := { s0 := n0, s1 := n1, s2 := n1, s3 := n0, s4 := n2, s5 := n14, s6 := n28, s7 := n40, s8 := n41, s9 := n53, s10 := n57, s11 := n58, s12 := n61, s13 := n58, s14 := n102 },
    outputDefined := true, transitionDefined := true }

def step (inputs : Inputs) (state : State) : Outputs × State :=
  let r := evaluate inputs state
  (r.outputs, r.nextState)

def initialValid (state : State) : Bool :=
  ((state.s0 &&& (1#1)) == (1#1)) &&
  ((state.s1 &&& (1#1)) == (1#1)) &&
  ((state.s2 &&& (1#1)) == (1#1)) &&
  ((state.s3 &&& (1#1)) == (1#1)) &&
  ((state.s4 &&& (7#3)) == (0#3)) &&
  ((state.s8 &&& (1#1)) == (0#1))
end SRAM.SramArray2P
