-- Generated from locked Yosys FunctionalIR. Fixed circuit; explicit initial state.
import Lean
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
namespace Shift.Source
structure Inputs where
  i0 : BitVec 256
  i1 : BitVec 256

structure State where

structure Outputs where
  o0 : BitVec 1
  o1 : BitVec 1
  o2 : BitVec 1
  o3 : BitVec 8
  o4 : BitVec 8
  o5 : BitVec 8
  o6 : BitVec 65
  o7 : BitVec 65
  o8 : BitVec 65
  o9 : BitVec 127
  o10 : BitVec 127
  o11 : BitVec 127
  o12 : BitVec 256
  o13 : BitVec 256
  o14 : BitVec 256

structure Evaluation where
  outputs : Outputs
  nextState : State
  outputDefined : Bool
  transitionDefined : Bool

def evaluate (inputs : Inputs) (state : State) : Evaluation :=
  let n0 : BitVec 256 := inputs.i0
  let n1 : BitVec 1 := (BitVec.extractLsb' 0 1 n0)
  let n2 : BitVec 256 := inputs.i1
  let n3 : BitVec 256 := (0#256)
  let n4 : Bool := (n2 != n3)
  let n5 : BitVec 1 := (1#1)
  let n6 : BitVec 1 := (0#1)
  let n7 : BitVec 1 := (if n4 then n5 else n6)
  let n8 : BitVec 1 := (~~~n7)
  let n9 : BitVec 1 := (n1 &&& n8)
  let n10 : BitVec 256 := (0#256)
  let n11 : Bool := (n2 != n10)
  let n12 : BitVec 1 := (1#1)
  let n13 : BitVec 1 := (0#1)
  let n14 : BitVec 1 := (if n11 then n12 else n13)
  let n15 : BitVec 1 := (~~~n14)
  let n16 : BitVec 1 := (n1 &&& n15)
  let n17 : BitVec 8 := (BitVec.extractLsb' 0 8 n0)
  let n18 : BitVec 3 := (BitVec.extractLsb' 0 3 n2)
  let n19 : BitVec 8 := (BitVec.setWidth 8 n18)
  let n20 : BitVec 8 := (n17 <<< (Nat.min 8 n19.toNat))
  let n21 : BitVec 256 := (8#256)
  let n22 : Bool := (decide (n2.toNat >= n21.toNat))
  let n23 : BitVec 1 := (1#1)
  let n24 : BitVec 1 := (0#1)
  let n25 : BitVec 1 := (if n22 then n23 else n24)
  let n26 : BitVec 1 := (1#1)
  let n27 : Bool := (n25 == n26)
  let n28 : BitVec 8 := (0#8)
  let n29 : BitVec 8 := (if n27 then n28 else n20)
  let n30 : BitVec 3 := (BitVec.extractLsb' 0 3 n2)
  let n31 : BitVec 8 := (BitVec.setWidth 8 n30)
  let n32 : BitVec 8 := (n17 >>> (Nat.min 8 n31.toNat))
  let n33 : BitVec 256 := (8#256)
  let n34 : Bool := (decide (n2.toNat >= n33.toNat))
  let n35 : BitVec 1 := (1#1)
  let n36 : BitVec 1 := (0#1)
  let n37 : BitVec 1 := (if n34 then n35 else n36)
  let n38 : BitVec 1 := (1#1)
  let n39 : Bool := (n37 == n38)
  let n40 : BitVec 8 := (0#8)
  let n41 : BitVec 8 := (if n39 then n40 else n32)
  let n42 : BitVec 3 := (BitVec.extractLsb' 0 3 n2)
  let n43 : BitVec 8 := (BitVec.setWidth 8 n42)
  let n44 : BitVec 8 := (n17.sshiftRight (Nat.min 8 n43.toNat))
  let n45 : BitVec 1 := (BitVec.extractLsb' 7 1 n17)
  let n46 : BitVec 8 := (BitVec.signExtend 8 n45)
  let n47 : BitVec 256 := (8#256)
  let n48 : Bool := (decide (n2.toNat >= n47.toNat))
  let n49 : BitVec 1 := (1#1)
  let n50 : BitVec 1 := (0#1)
  let n51 : BitVec 1 := (if n48 then n49 else n50)
  let n52 : BitVec 1 := (1#1)
  let n53 : Bool := (n51 == n52)
  let n54 : BitVec 8 := (if n53 then n46 else n44)
  let n55 : BitVec 65 := (BitVec.extractLsb' 0 65 n0)
  let n56 : BitVec 7 := (BitVec.extractLsb' 0 7 n2)
  let n57 : BitVec 65 := (BitVec.setWidth 65 n56)
  let n58 : BitVec 65 := (n55 <<< (Nat.min 65 n57.toNat))
  let n59 : BitVec 256 := (65#256)
  let n60 : Bool := (decide (n2.toNat >= n59.toNat))
  let n61 : BitVec 1 := (1#1)
  let n62 : BitVec 1 := (0#1)
  let n63 : BitVec 1 := (if n60 then n61 else n62)
  let n64 : BitVec 1 := (1#1)
  let n65 : Bool := (n63 == n64)
  let n66 : BitVec 65 := (0#65)
  let n67 : BitVec 65 := (if n65 then n66 else n58)
  let n68 : BitVec 7 := (BitVec.extractLsb' 0 7 n2)
  let n69 : BitVec 65 := (BitVec.setWidth 65 n68)
  let n70 : BitVec 65 := (n55 >>> (Nat.min 65 n69.toNat))
  let n71 : BitVec 256 := (65#256)
  let n72 : Bool := (decide (n2.toNat >= n71.toNat))
  let n73 : BitVec 1 := (1#1)
  let n74 : BitVec 1 := (0#1)
  let n75 : BitVec 1 := (if n72 then n73 else n74)
  let n76 : BitVec 1 := (1#1)
  let n77 : Bool := (n75 == n76)
  let n78 : BitVec 65 := (0#65)
  let n79 : BitVec 65 := (if n77 then n78 else n70)
  let n80 : BitVec 7 := (BitVec.extractLsb' 0 7 n2)
  let n81 : BitVec 65 := (BitVec.setWidth 65 n80)
  let n82 : BitVec 65 := (n55.sshiftRight (Nat.min 65 n81.toNat))
  let n83 : BitVec 1 := (BitVec.extractLsb' 64 1 n55)
  let n84 : BitVec 65 := (BitVec.signExtend 65 n83)
  let n85 : BitVec 256 := (65#256)
  let n86 : Bool := (decide (n2.toNat >= n85.toNat))
  let n87 : BitVec 1 := (1#1)
  let n88 : BitVec 1 := (0#1)
  let n89 : BitVec 1 := (if n86 then n87 else n88)
  let n90 : BitVec 1 := (1#1)
  let n91 : Bool := (n89 == n90)
  let n92 : BitVec 65 := (if n91 then n84 else n82)
  let n93 : BitVec 127 := (BitVec.extractLsb' 0 127 n0)
  let n94 : BitVec 7 := (BitVec.extractLsb' 0 7 n2)
  let n95 : BitVec 127 := (BitVec.setWidth 127 n94)
  let n96 : BitVec 127 := (n93 <<< (Nat.min 127 n95.toNat))
  let n97 : BitVec 256 := (127#256)
  let n98 : Bool := (decide (n2.toNat >= n97.toNat))
  let n99 : BitVec 1 := (1#1)
  let n100 : BitVec 1 := (0#1)
  let n101 : BitVec 1 := (if n98 then n99 else n100)
  let n102 : BitVec 1 := (1#1)
  let n103 : Bool := (n101 == n102)
  let n104 : BitVec 127 := (0#127)
  let n105 : BitVec 127 := (if n103 then n104 else n96)
  let n106 : BitVec 7 := (BitVec.extractLsb' 0 7 n2)
  let n107 : BitVec 127 := (BitVec.setWidth 127 n106)
  let n108 : BitVec 127 := (n93 >>> (Nat.min 127 n107.toNat))
  let n109 : BitVec 256 := (127#256)
  let n110 : Bool := (decide (n2.toNat >= n109.toNat))
  let n111 : BitVec 1 := (1#1)
  let n112 : BitVec 1 := (0#1)
  let n113 : BitVec 1 := (if n110 then n111 else n112)
  let n114 : BitVec 1 := (1#1)
  let n115 : Bool := (n113 == n114)
  let n116 : BitVec 127 := (0#127)
  let n117 : BitVec 127 := (if n115 then n116 else n108)
  let n118 : BitVec 7 := (BitVec.extractLsb' 0 7 n2)
  let n119 : BitVec 127 := (BitVec.setWidth 127 n118)
  let n120 : BitVec 127 := (n93.sshiftRight (Nat.min 127 n119.toNat))
  let n121 : BitVec 1 := (BitVec.extractLsb' 126 1 n93)
  let n122 : BitVec 127 := (BitVec.signExtend 127 n121)
  let n123 : BitVec 256 := (127#256)
  let n124 : Bool := (decide (n2.toNat >= n123.toNat))
  let n125 : BitVec 1 := (1#1)
  let n126 : BitVec 1 := (0#1)
  let n127 : BitVec 1 := (if n124 then n125 else n126)
  let n128 : BitVec 1 := (1#1)
  let n129 : Bool := (n127 == n128)
  let n130 : BitVec 127 := (if n129 then n122 else n120)
  let n131 : BitVec 8 := (BitVec.extractLsb' 0 8 n2)
  let n132 : BitVec 256 := (BitVec.setWidth 256 n131)
  let n133 : BitVec 256 := (n0 <<< (Nat.min 256 n132.toNat))
  let n134 : BitVec 256 := (256#256)
  let n135 : Bool := (decide (n2.toNat >= n134.toNat))
  let n136 : BitVec 1 := (1#1)
  let n137 : BitVec 1 := (0#1)
  let n138 : BitVec 1 := (if n135 then n136 else n137)
  let n139 : BitVec 1 := (1#1)
  let n140 : Bool := (n138 == n139)
  let n141 : BitVec 256 := (0#256)
  let n142 : BitVec 256 := (if n140 then n141 else n133)
  let n143 : BitVec 8 := (BitVec.extractLsb' 0 8 n2)
  let n144 : BitVec 256 := (BitVec.setWidth 256 n143)
  let n145 : BitVec 256 := (n0 >>> (Nat.min 256 n144.toNat))
  let n146 : BitVec 256 := (256#256)
  let n147 : Bool := (decide (n2.toNat >= n146.toNat))
  let n148 : BitVec 1 := (1#1)
  let n149 : BitVec 1 := (0#1)
  let n150 : BitVec 1 := (if n147 then n148 else n149)
  let n151 : BitVec 1 := (1#1)
  let n152 : Bool := (n150 == n151)
  let n153 : BitVec 256 := (0#256)
  let n154 : BitVec 256 := (if n152 then n153 else n145)
  let n155 : BitVec 8 := (BitVec.extractLsb' 0 8 n2)
  let n156 : BitVec 256 := (BitVec.setWidth 256 n155)
  let n157 : BitVec 256 := (n0.sshiftRight (Nat.min 256 n156.toNat))
  let n158 : BitVec 1 := (BitVec.extractLsb' 255 1 n0)
  let n159 : BitVec 256 := (BitVec.signExtend 256 n158)
  let n160 : BitVec 256 := (256#256)
  let n161 : Bool := (decide (n2.toNat >= n160.toNat))
  let n162 : BitVec 1 := (1#1)
  let n163 : BitVec 1 := (0#1)
  let n164 : BitVec 1 := (if n161 then n162 else n163)
  let n165 : BitVec 1 := (1#1)
  let n166 : Bool := (n164 == n165)
  let n167 : BitVec 256 := (if n166 then n159 else n157)
  { outputs := { o0 := n9, o1 := n16, o2 := n1, o3 := n29, o4 := n41, o5 := n54, o6 := n67, o7 := n79, o8 := n92, o9 := n105, o10 := n117, o11 := n130, o12 := n142, o13 := n154, o14 := n167 }, nextState := ⟨⟩,
    outputDefined := true, transitionDefined := true }

def step (inputs : Inputs) (state : State) : Outputs × State :=
  let r := evaluate inputs state
  (r.outputs, r.nextState)

def initialValid (state : State) : Bool :=
  true
end Shift.Source
