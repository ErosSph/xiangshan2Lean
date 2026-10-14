-- Generated from locked Yosys FunctionalIR. Fixed circuit; explicit initial state.
import Lean
set_option maxRecDepth 65536
set_option maxHeartbeats 0
namespace Yosys.Signed65
structure Inputs where
  i0 : BitVec 1
  i1 : BitVec 1
  i2 : BitVec 65
  i3 : BitVec 65

structure State where

structure Outputs where
  o0 : BitVec 67
  o1 : BitVec 1
  o2 : BitVec 130
  o3 : BitVec 65
  o4 : BitVec 65
  o5 : BitVec 66

structure Evaluation where
  outputs : Outputs
  nextState : State
  outputDefined : Bool
  transitionDefined : Bool

def evaluate (inputs : Inputs) (state : State) : Evaluation :=
  let n0 : BitVec 65 := inputs.i2
  let n1 : BitVec 1 := (BitVec.extractLsb' 64 1 n0)
  let n2 : BitVec 66 := (n1 ++ n0)
  let n3 : BitVec 67 := (n1 ++ n2)
  let n4 : BitVec 65 := inputs.i3
  let n5 : Bool := (decide (n4.toInt > n0.toInt))
  let n6 : BitVec 1 := (1#1)
  let n7 : BitVec 1 := (0#1)
  let n8 : BitVec 1 := (if n5 then n6 else n7)
  let n9 : BitVec 66 := (n1 ++ n0)
  let n10 : BitVec 67 := (n1 ++ n9)
  let n11 : BitVec 68 := (n1 ++ n10)
  let n12 : BitVec 69 := (n1 ++ n11)
  let n13 : BitVec 70 := (n1 ++ n12)
  let n14 : BitVec 71 := (n1 ++ n13)
  let n15 : BitVec 72 := (n1 ++ n14)
  let n16 : BitVec 73 := (n1 ++ n15)
  let n17 : BitVec 74 := (n1 ++ n16)
  let n18 : BitVec 75 := (n1 ++ n17)
  let n19 : BitVec 76 := (n1 ++ n18)
  let n20 : BitVec 77 := (n1 ++ n19)
  let n21 : BitVec 78 := (n1 ++ n20)
  let n22 : BitVec 79 := (n1 ++ n21)
  let n23 : BitVec 80 := (n1 ++ n22)
  let n24 : BitVec 81 := (n1 ++ n23)
  let n25 : BitVec 82 := (n1 ++ n24)
  let n26 : BitVec 83 := (n1 ++ n25)
  let n27 : BitVec 84 := (n1 ++ n26)
  let n28 : BitVec 85 := (n1 ++ n27)
  let n29 : BitVec 86 := (n1 ++ n28)
  let n30 : BitVec 87 := (n1 ++ n29)
  let n31 : BitVec 88 := (n1 ++ n30)
  let n32 : BitVec 89 := (n1 ++ n31)
  let n33 : BitVec 90 := (n1 ++ n32)
  let n34 : BitVec 91 := (n1 ++ n33)
  let n35 : BitVec 92 := (n1 ++ n34)
  let n36 : BitVec 93 := (n1 ++ n35)
  let n37 : BitVec 94 := (n1 ++ n36)
  let n38 : BitVec 95 := (n1 ++ n37)
  let n39 : BitVec 96 := (n1 ++ n38)
  let n40 : BitVec 97 := (n1 ++ n39)
  let n41 : BitVec 98 := (n1 ++ n40)
  let n42 : BitVec 99 := (n1 ++ n41)
  let n43 : BitVec 100 := (n1 ++ n42)
  let n44 : BitVec 101 := (n1 ++ n43)
  let n45 : BitVec 102 := (n1 ++ n44)
  let n46 : BitVec 103 := (n1 ++ n45)
  let n47 : BitVec 104 := (n1 ++ n46)
  let n48 : BitVec 105 := (n1 ++ n47)
  let n49 : BitVec 106 := (n1 ++ n48)
  let n50 : BitVec 107 := (n1 ++ n49)
  let n51 : BitVec 108 := (n1 ++ n50)
  let n52 : BitVec 109 := (n1 ++ n51)
  let n53 : BitVec 110 := (n1 ++ n52)
  let n54 : BitVec 111 := (n1 ++ n53)
  let n55 : BitVec 112 := (n1 ++ n54)
  let n56 : BitVec 113 := (n1 ++ n55)
  let n57 : BitVec 114 := (n1 ++ n56)
  let n58 : BitVec 115 := (n1 ++ n57)
  let n59 : BitVec 116 := (n1 ++ n58)
  let n60 : BitVec 117 := (n1 ++ n59)
  let n61 : BitVec 118 := (n1 ++ n60)
  let n62 : BitVec 119 := (n1 ++ n61)
  let n63 : BitVec 120 := (n1 ++ n62)
  let n64 : BitVec 121 := (n1 ++ n63)
  let n65 : BitVec 122 := (n1 ++ n64)
  let n66 : BitVec 123 := (n1 ++ n65)
  let n67 : BitVec 124 := (n1 ++ n66)
  let n68 : BitVec 125 := (n1 ++ n67)
  let n69 : BitVec 126 := (n1 ++ n68)
  let n70 : BitVec 127 := (n1 ++ n69)
  let n71 : BitVec 128 := (n1 ++ n70)
  let n72 : BitVec 129 := (n1 ++ n71)
  let n73 : BitVec 130 := (n1 ++ n72)
  let n74 : BitVec 1 := (BitVec.extractLsb' 64 1 n4)
  let n75 : BitVec 66 := (n74 ++ n4)
  let n76 : BitVec 67 := (n74 ++ n75)
  let n77 : BitVec 68 := (n74 ++ n76)
  let n78 : BitVec 69 := (n74 ++ n77)
  let n79 : BitVec 70 := (n74 ++ n78)
  let n80 : BitVec 71 := (n74 ++ n79)
  let n81 : BitVec 72 := (n74 ++ n80)
  let n82 : BitVec 73 := (n74 ++ n81)
  let n83 : BitVec 74 := (n74 ++ n82)
  let n84 : BitVec 75 := (n74 ++ n83)
  let n85 : BitVec 76 := (n74 ++ n84)
  let n86 : BitVec 77 := (n74 ++ n85)
  let n87 : BitVec 78 := (n74 ++ n86)
  let n88 : BitVec 79 := (n74 ++ n87)
  let n89 : BitVec 80 := (n74 ++ n88)
  let n90 : BitVec 81 := (n74 ++ n89)
  let n91 : BitVec 82 := (n74 ++ n90)
  let n92 : BitVec 83 := (n74 ++ n91)
  let n93 : BitVec 84 := (n74 ++ n92)
  let n94 : BitVec 85 := (n74 ++ n93)
  let n95 : BitVec 86 := (n74 ++ n94)
  let n96 : BitVec 87 := (n74 ++ n95)
  let n97 : BitVec 88 := (n74 ++ n96)
  let n98 : BitVec 89 := (n74 ++ n97)
  let n99 : BitVec 90 := (n74 ++ n98)
  let n100 : BitVec 91 := (n74 ++ n99)
  let n101 : BitVec 92 := (n74 ++ n100)
  let n102 : BitVec 93 := (n74 ++ n101)
  let n103 : BitVec 94 := (n74 ++ n102)
  let n104 : BitVec 95 := (n74 ++ n103)
  let n105 : BitVec 96 := (n74 ++ n104)
  let n106 : BitVec 97 := (n74 ++ n105)
  let n107 : BitVec 98 := (n74 ++ n106)
  let n108 : BitVec 99 := (n74 ++ n107)
  let n109 : BitVec 100 := (n74 ++ n108)
  let n110 : BitVec 101 := (n74 ++ n109)
  let n111 : BitVec 102 := (n74 ++ n110)
  let n112 : BitVec 103 := (n74 ++ n111)
  let n113 : BitVec 104 := (n74 ++ n112)
  let n114 : BitVec 105 := (n74 ++ n113)
  let n115 : BitVec 106 := (n74 ++ n114)
  let n116 : BitVec 107 := (n74 ++ n115)
  let n117 : BitVec 108 := (n74 ++ n116)
  let n118 : BitVec 109 := (n74 ++ n117)
  let n119 : BitVec 110 := (n74 ++ n118)
  let n120 : BitVec 111 := (n74 ++ n119)
  let n121 : BitVec 112 := (n74 ++ n120)
  let n122 : BitVec 113 := (n74 ++ n121)
  let n123 : BitVec 114 := (n74 ++ n122)
  let n124 : BitVec 115 := (n74 ++ n123)
  let n125 : BitVec 116 := (n74 ++ n124)
  let n126 : BitVec 117 := (n74 ++ n125)
  let n127 : BitVec 118 := (n74 ++ n126)
  let n128 : BitVec 119 := (n74 ++ n127)
  let n129 : BitVec 120 := (n74 ++ n128)
  let n130 : BitVec 121 := (n74 ++ n129)
  let n131 : BitVec 122 := (n74 ++ n130)
  let n132 : BitVec 123 := (n74 ++ n131)
  let n133 : BitVec 124 := (n74 ++ n132)
  let n134 : BitVec 125 := (n74 ++ n133)
  let n135 : BitVec 126 := (n74 ++ n134)
  let n136 : BitVec 127 := (n74 ++ n135)
  let n137 : BitVec 128 := (n74 ++ n136)
  let n138 : BitVec 129 := (n74 ++ n137)
  let n139 : BitVec 130 := (n74 ++ n138)
  let n140 : BitVec 130 := (n73 * n139)
  let n141 : BitVec 64 := (BitVec.extractLsb' 1 64 n0)
  let n142 : BitVec 65 := (n1 ++ n141)
  let n143 : BitVec 66 := (n1 ++ n0)
  let n144 : BitVec 66 := (n74 ++ n4)
  let n145 : BitVec 66 := (n143 + n144)
  let n146 : BitVec 65 := (BitVec.extractLsb' 0 65 n145)
  { outputs := { o0 := n3, o1 := n8, o2 := n140, o3 := n142, o4 := n146, o5 := n145 }, nextState := ⟨⟩,
    outputDefined := true, transitionDefined := true }

def step (inputs : Inputs) (state : State) : Outputs × State :=
  let r := evaluate inputs state
  (r.outputs, r.nextState)

def initialValid (state : State) : Bool :=
  true
end Yosys.Signed65
