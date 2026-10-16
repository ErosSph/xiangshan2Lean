import Chunks.Large
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
open Chunks.Large
def decodeInputsGroup0Group0 (j : Lean.Json) : Except String InputsGroup0Group0 := do
  let v0 ← j.getObjValAs? Int "reset"
  let v1 ← j.getObjValAs? Int "clock"
  let v2 ← j.getObjValAs? Int "en"
  let v3 ← j.getObjValAs? Int "d"
  let v4 ← j.getObjValAs? Int "c2l_undefined_0"
  let v5 ← j.getObjValAs? Int "c2l_undefined_1"
  let v6 ← j.getObjValAs? Int "c2l_undefined_2"
  let v7 ← j.getObjValAs? Int "c2l_undefined_3"
  let v8 ← j.getObjValAs? Int "c2l_undefined_4"
  let v9 ← j.getObjValAs? Int "c2l_undefined_5"
  let v10 ← j.getObjValAs? Int "c2l_undefined_6"
  let v11 ← j.getObjValAs? Int "c2l_undefined_7"
  let v12 ← j.getObjValAs? Int "c2l_undefined_8"
  let v13 ← j.getObjValAs? Int "c2l_undefined_9"
  let v14 ← j.getObjValAs? Int "c2l_undefined_10"
  let v15 ← j.getObjValAs? Int "c2l_undefined_11"
  return { i0 := BitVec.ofInt 1 v0, i1 := BitVec.ofInt 1 v1, i2 := BitVec.ofInt 1 v2, i3 := BitVec.ofInt 16 v3, i4 := BitVec.ofInt 16 v4, i5 := BitVec.ofInt 16 v5, i6 := BitVec.ofInt 16 v6, i7 := BitVec.ofInt 16 v7, i8 := BitVec.ofInt 16 v8, i9 := BitVec.ofInt 16 v9, i10 := BitVec.ofInt 16 v10, i11 := BitVec.ofInt 16 v11, i12 := BitVec.ofInt 16 v12, i13 := BitVec.ofInt 16 v13, i14 := BitVec.ofInt 16 v14, i15 := BitVec.ofInt 16 v15 }

def decodeInputsGroup0Group1 (j : Lean.Json) : Except String InputsGroup0Group1 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_12"
  let v1 ← j.getObjValAs? Int "c2l_undefined_13"
  let v2 ← j.getObjValAs? Int "c2l_undefined_14"
  let v3 ← j.getObjValAs? Int "c2l_undefined_15"
  let v4 ← j.getObjValAs? Int "c2l_undefined_16"
  let v5 ← j.getObjValAs? Int "c2l_undefined_17"
  let v6 ← j.getObjValAs? Int "c2l_undefined_18"
  let v7 ← j.getObjValAs? Int "c2l_undefined_19"
  let v8 ← j.getObjValAs? Int "c2l_undefined_20"
  let v9 ← j.getObjValAs? Int "c2l_undefined_21"
  let v10 ← j.getObjValAs? Int "c2l_undefined_22"
  let v11 ← j.getObjValAs? Int "c2l_undefined_23"
  let v12 ← j.getObjValAs? Int "c2l_undefined_24"
  let v13 ← j.getObjValAs? Int "c2l_undefined_25"
  let v14 ← j.getObjValAs? Int "c2l_undefined_26"
  let v15 ← j.getObjValAs? Int "c2l_undefined_27"
  return { i16 := BitVec.ofInt 16 v0, i17 := BitVec.ofInt 16 v1, i18 := BitVec.ofInt 16 v2, i19 := BitVec.ofInt 16 v3, i20 := BitVec.ofInt 16 v4, i21 := BitVec.ofInt 16 v5, i22 := BitVec.ofInt 16 v6, i23 := BitVec.ofInt 16 v7, i24 := BitVec.ofInt 16 v8, i25 := BitVec.ofInt 16 v9, i26 := BitVec.ofInt 16 v10, i27 := BitVec.ofInt 16 v11, i28 := BitVec.ofInt 16 v12, i29 := BitVec.ofInt 16 v13, i30 := BitVec.ofInt 16 v14, i31 := BitVec.ofInt 16 v15 }

def decodeInputsGroup0Group2 (j : Lean.Json) : Except String InputsGroup0Group2 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_28"
  let v1 ← j.getObjValAs? Int "c2l_undefined_29"
  let v2 ← j.getObjValAs? Int "c2l_undefined_30"
  let v3 ← j.getObjValAs? Int "c2l_undefined_31"
  let v4 ← j.getObjValAs? Int "c2l_undefined_32"
  let v5 ← j.getObjValAs? Int "c2l_undefined_33"
  let v6 ← j.getObjValAs? Int "c2l_undefined_34"
  let v7 ← j.getObjValAs? Int "c2l_undefined_35"
  let v8 ← j.getObjValAs? Int "c2l_undefined_36"
  let v9 ← j.getObjValAs? Int "c2l_undefined_37"
  let v10 ← j.getObjValAs? Int "c2l_undefined_38"
  let v11 ← j.getObjValAs? Int "c2l_undefined_39"
  let v12 ← j.getObjValAs? Int "c2l_undefined_40"
  let v13 ← j.getObjValAs? Int "c2l_undefined_41"
  let v14 ← j.getObjValAs? Int "c2l_undefined_42"
  let v15 ← j.getObjValAs? Int "c2l_undefined_43"
  return { i32 := BitVec.ofInt 16 v0, i33 := BitVec.ofInt 16 v1, i34 := BitVec.ofInt 16 v2, i35 := BitVec.ofInt 16 v3, i36 := BitVec.ofInt 16 v4, i37 := BitVec.ofInt 16 v5, i38 := BitVec.ofInt 16 v6, i39 := BitVec.ofInt 16 v7, i40 := BitVec.ofInt 16 v8, i41 := BitVec.ofInt 16 v9, i42 := BitVec.ofInt 16 v10, i43 := BitVec.ofInt 16 v11, i44 := BitVec.ofInt 16 v12, i45 := BitVec.ofInt 16 v13, i46 := BitVec.ofInt 16 v14, i47 := BitVec.ofInt 16 v15 }

def decodeInputsGroup0Group3 (j : Lean.Json) : Except String InputsGroup0Group3 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_44"
  let v1 ← j.getObjValAs? Int "c2l_undefined_45"
  let v2 ← j.getObjValAs? Int "c2l_undefined_46"
  let v3 ← j.getObjValAs? Int "c2l_undefined_47"
  let v4 ← j.getObjValAs? Int "c2l_undefined_48"
  let v5 ← j.getObjValAs? Int "c2l_undefined_49"
  let v6 ← j.getObjValAs? Int "c2l_undefined_50"
  let v7 ← j.getObjValAs? Int "c2l_undefined_51"
  let v8 ← j.getObjValAs? Int "c2l_undefined_52"
  let v9 ← j.getObjValAs? Int "c2l_undefined_53"
  let v10 ← j.getObjValAs? Int "c2l_undefined_54"
  let v11 ← j.getObjValAs? Int "c2l_undefined_55"
  let v12 ← j.getObjValAs? Int "c2l_undefined_56"
  let v13 ← j.getObjValAs? Int "c2l_undefined_57"
  let v14 ← j.getObjValAs? Int "c2l_undefined_58"
  let v15 ← j.getObjValAs? Int "c2l_undefined_59"
  return { i48 := BitVec.ofInt 16 v0, i49 := BitVec.ofInt 16 v1, i50 := BitVec.ofInt 16 v2, i51 := BitVec.ofInt 16 v3, i52 := BitVec.ofInt 16 v4, i53 := BitVec.ofInt 16 v5, i54 := BitVec.ofInt 16 v6, i55 := BitVec.ofInt 16 v7, i56 := BitVec.ofInt 16 v8, i57 := BitVec.ofInt 16 v9, i58 := BitVec.ofInt 16 v10, i59 := BitVec.ofInt 16 v11, i60 := BitVec.ofInt 16 v12, i61 := BitVec.ofInt 16 v13, i62 := BitVec.ofInt 16 v14, i63 := BitVec.ofInt 16 v15 }

def decodeInputsGroup0Group4 (j : Lean.Json) : Except String InputsGroup0Group4 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_60"
  let v1 ← j.getObjValAs? Int "c2l_undefined_61"
  let v2 ← j.getObjValAs? Int "c2l_undefined_62"
  let v3 ← j.getObjValAs? Int "c2l_undefined_63"
  let v4 ← j.getObjValAs? Int "c2l_undefined_64"
  let v5 ← j.getObjValAs? Int "c2l_undefined_65"
  let v6 ← j.getObjValAs? Int "c2l_undefined_66"
  let v7 ← j.getObjValAs? Int "c2l_undefined_67"
  let v8 ← j.getObjValAs? Int "c2l_undefined_68"
  let v9 ← j.getObjValAs? Int "c2l_undefined_69"
  let v10 ← j.getObjValAs? Int "c2l_undefined_70"
  let v11 ← j.getObjValAs? Int "c2l_undefined_71"
  let v12 ← j.getObjValAs? Int "c2l_undefined_72"
  let v13 ← j.getObjValAs? Int "c2l_undefined_73"
  let v14 ← j.getObjValAs? Int "c2l_undefined_74"
  let v15 ← j.getObjValAs? Int "c2l_undefined_75"
  return { i64 := BitVec.ofInt 16 v0, i65 := BitVec.ofInt 16 v1, i66 := BitVec.ofInt 16 v2, i67 := BitVec.ofInt 16 v3, i68 := BitVec.ofInt 16 v4, i69 := BitVec.ofInt 16 v5, i70 := BitVec.ofInt 16 v6, i71 := BitVec.ofInt 16 v7, i72 := BitVec.ofInt 16 v8, i73 := BitVec.ofInt 16 v9, i74 := BitVec.ofInt 16 v10, i75 := BitVec.ofInt 16 v11, i76 := BitVec.ofInt 16 v12, i77 := BitVec.ofInt 16 v13, i78 := BitVec.ofInt 16 v14, i79 := BitVec.ofInt 16 v15 }

def decodeInputsGroup0Group5 (j : Lean.Json) : Except String InputsGroup0Group5 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_76"
  let v1 ← j.getObjValAs? Int "c2l_undefined_77"
  let v2 ← j.getObjValAs? Int "c2l_undefined_78"
  let v3 ← j.getObjValAs? Int "c2l_undefined_79"
  let v4 ← j.getObjValAs? Int "c2l_undefined_80"
  let v5 ← j.getObjValAs? Int "c2l_undefined_81"
  let v6 ← j.getObjValAs? Int "c2l_undefined_82"
  let v7 ← j.getObjValAs? Int "c2l_undefined_83"
  let v8 ← j.getObjValAs? Int "c2l_undefined_84"
  let v9 ← j.getObjValAs? Int "c2l_undefined_85"
  let v10 ← j.getObjValAs? Int "c2l_undefined_86"
  let v11 ← j.getObjValAs? Int "c2l_undefined_87"
  let v12 ← j.getObjValAs? Int "c2l_undefined_88"
  let v13 ← j.getObjValAs? Int "c2l_undefined_89"
  let v14 ← j.getObjValAs? Int "c2l_undefined_90"
  let v15 ← j.getObjValAs? Int "c2l_undefined_91"
  return { i80 := BitVec.ofInt 16 v0, i81 := BitVec.ofInt 16 v1, i82 := BitVec.ofInt 16 v2, i83 := BitVec.ofInt 16 v3, i84 := BitVec.ofInt 16 v4, i85 := BitVec.ofInt 16 v5, i86 := BitVec.ofInt 16 v6, i87 := BitVec.ofInt 16 v7, i88 := BitVec.ofInt 16 v8, i89 := BitVec.ofInt 16 v9, i90 := BitVec.ofInt 16 v10, i91 := BitVec.ofInt 16 v11, i92 := BitVec.ofInt 16 v12, i93 := BitVec.ofInt 16 v13, i94 := BitVec.ofInt 16 v14, i95 := BitVec.ofInt 16 v15 }

def decodeInputsGroup0Group6 (j : Lean.Json) : Except String InputsGroup0Group6 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_92"
  let v1 ← j.getObjValAs? Int "c2l_undefined_93"
  let v2 ← j.getObjValAs? Int "c2l_undefined_94"
  let v3 ← j.getObjValAs? Int "c2l_undefined_95"
  let v4 ← j.getObjValAs? Int "c2l_undefined_96"
  let v5 ← j.getObjValAs? Int "c2l_undefined_97"
  let v6 ← j.getObjValAs? Int "c2l_undefined_98"
  let v7 ← j.getObjValAs? Int "c2l_undefined_99"
  let v8 ← j.getObjValAs? Int "c2l_undefined_100"
  let v9 ← j.getObjValAs? Int "c2l_undefined_101"
  let v10 ← j.getObjValAs? Int "c2l_undefined_102"
  let v11 ← j.getObjValAs? Int "c2l_undefined_103"
  let v12 ← j.getObjValAs? Int "c2l_undefined_104"
  let v13 ← j.getObjValAs? Int "c2l_undefined_105"
  let v14 ← j.getObjValAs? Int "c2l_undefined_106"
  let v15 ← j.getObjValAs? Int "c2l_undefined_107"
  return { i96 := BitVec.ofInt 16 v0, i97 := BitVec.ofInt 16 v1, i98 := BitVec.ofInt 16 v2, i99 := BitVec.ofInt 16 v3, i100 := BitVec.ofInt 16 v4, i101 := BitVec.ofInt 16 v5, i102 := BitVec.ofInt 16 v6, i103 := BitVec.ofInt 16 v7, i104 := BitVec.ofInt 16 v8, i105 := BitVec.ofInt 16 v9, i106 := BitVec.ofInt 16 v10, i107 := BitVec.ofInt 16 v11, i108 := BitVec.ofInt 16 v12, i109 := BitVec.ofInt 16 v13, i110 := BitVec.ofInt 16 v14, i111 := BitVec.ofInt 16 v15 }

def decodeInputsGroup0Group7 (j : Lean.Json) : Except String InputsGroup0Group7 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_108"
  let v1 ← j.getObjValAs? Int "c2l_undefined_109"
  let v2 ← j.getObjValAs? Int "c2l_undefined_110"
  let v3 ← j.getObjValAs? Int "c2l_undefined_111"
  let v4 ← j.getObjValAs? Int "c2l_undefined_112"
  let v5 ← j.getObjValAs? Int "c2l_undefined_113"
  let v6 ← j.getObjValAs? Int "c2l_undefined_114"
  let v7 ← j.getObjValAs? Int "c2l_undefined_115"
  let v8 ← j.getObjValAs? Int "c2l_undefined_116"
  let v9 ← j.getObjValAs? Int "c2l_undefined_117"
  let v10 ← j.getObjValAs? Int "c2l_undefined_118"
  let v11 ← j.getObjValAs? Int "c2l_undefined_119"
  let v12 ← j.getObjValAs? Int "c2l_undefined_120"
  let v13 ← j.getObjValAs? Int "c2l_undefined_121"
  let v14 ← j.getObjValAs? Int "c2l_undefined_122"
  let v15 ← j.getObjValAs? Int "c2l_undefined_123"
  return { i112 := BitVec.ofInt 16 v0, i113 := BitVec.ofInt 16 v1, i114 := BitVec.ofInt 16 v2, i115 := BitVec.ofInt 16 v3, i116 := BitVec.ofInt 16 v4, i117 := BitVec.ofInt 16 v5, i118 := BitVec.ofInt 16 v6, i119 := BitVec.ofInt 16 v7, i120 := BitVec.ofInt 16 v8, i121 := BitVec.ofInt 16 v9, i122 := BitVec.ofInt 16 v10, i123 := BitVec.ofInt 16 v11, i124 := BitVec.ofInt 16 v12, i125 := BitVec.ofInt 16 v13, i126 := BitVec.ofInt 16 v14, i127 := BitVec.ofInt 16 v15 }

def decodeInputsGroup0Group8 (j : Lean.Json) : Except String InputsGroup0Group8 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_124"
  let v1 ← j.getObjValAs? Int "c2l_undefined_125"
  let v2 ← j.getObjValAs? Int "c2l_undefined_126"
  let v3 ← j.getObjValAs? Int "c2l_undefined_127"
  let v4 ← j.getObjValAs? Int "c2l_undefined_128"
  let v5 ← j.getObjValAs? Int "c2l_undefined_129"
  let v6 ← j.getObjValAs? Int "c2l_undefined_130"
  let v7 ← j.getObjValAs? Int "c2l_undefined_131"
  let v8 ← j.getObjValAs? Int "c2l_undefined_132"
  let v9 ← j.getObjValAs? Int "c2l_undefined_133"
  let v10 ← j.getObjValAs? Int "c2l_undefined_134"
  let v11 ← j.getObjValAs? Int "c2l_undefined_135"
  let v12 ← j.getObjValAs? Int "c2l_undefined_136"
  let v13 ← j.getObjValAs? Int "c2l_undefined_137"
  let v14 ← j.getObjValAs? Int "c2l_undefined_138"
  let v15 ← j.getObjValAs? Int "c2l_undefined_139"
  return { i128 := BitVec.ofInt 16 v0, i129 := BitVec.ofInt 16 v1, i130 := BitVec.ofInt 16 v2, i131 := BitVec.ofInt 16 v3, i132 := BitVec.ofInt 16 v4, i133 := BitVec.ofInt 16 v5, i134 := BitVec.ofInt 16 v6, i135 := BitVec.ofInt 16 v7, i136 := BitVec.ofInt 16 v8, i137 := BitVec.ofInt 16 v9, i138 := BitVec.ofInt 16 v10, i139 := BitVec.ofInt 16 v11, i140 := BitVec.ofInt 16 v12, i141 := BitVec.ofInt 16 v13, i142 := BitVec.ofInt 16 v14, i143 := BitVec.ofInt 16 v15 }

def decodeInputsGroup0Group9 (j : Lean.Json) : Except String InputsGroup0Group9 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_140"
  let v1 ← j.getObjValAs? Int "c2l_undefined_141"
  let v2 ← j.getObjValAs? Int "c2l_undefined_142"
  let v3 ← j.getObjValAs? Int "c2l_undefined_143"
  let v4 ← j.getObjValAs? Int "c2l_undefined_144"
  let v5 ← j.getObjValAs? Int "c2l_undefined_145"
  let v6 ← j.getObjValAs? Int "c2l_undefined_146"
  let v7 ← j.getObjValAs? Int "c2l_undefined_147"
  let v8 ← j.getObjValAs? Int "c2l_undefined_148"
  let v9 ← j.getObjValAs? Int "c2l_undefined_149"
  let v10 ← j.getObjValAs? Int "c2l_undefined_150"
  let v11 ← j.getObjValAs? Int "c2l_undefined_151"
  let v12 ← j.getObjValAs? Int "c2l_undefined_152"
  let v13 ← j.getObjValAs? Int "c2l_undefined_153"
  let v14 ← j.getObjValAs? Int "c2l_undefined_154"
  let v15 ← j.getObjValAs? Int "c2l_undefined_155"
  return { i144 := BitVec.ofInt 16 v0, i145 := BitVec.ofInt 16 v1, i146 := BitVec.ofInt 16 v2, i147 := BitVec.ofInt 16 v3, i148 := BitVec.ofInt 16 v4, i149 := BitVec.ofInt 16 v5, i150 := BitVec.ofInt 16 v6, i151 := BitVec.ofInt 16 v7, i152 := BitVec.ofInt 16 v8, i153 := BitVec.ofInt 16 v9, i154 := BitVec.ofInt 16 v10, i155 := BitVec.ofInt 16 v11, i156 := BitVec.ofInt 16 v12, i157 := BitVec.ofInt 16 v13, i158 := BitVec.ofInt 16 v14, i159 := BitVec.ofInt 16 v15 }

def decodeInputsGroup0Group10 (j : Lean.Json) : Except String InputsGroup0Group10 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_156"
  let v1 ← j.getObjValAs? Int "c2l_undefined_157"
  let v2 ← j.getObjValAs? Int "c2l_undefined_158"
  let v3 ← j.getObjValAs? Int "c2l_undefined_159"
  let v4 ← j.getObjValAs? Int "c2l_undefined_160"
  let v5 ← j.getObjValAs? Int "c2l_undefined_161"
  let v6 ← j.getObjValAs? Int "c2l_undefined_162"
  let v7 ← j.getObjValAs? Int "c2l_undefined_163"
  let v8 ← j.getObjValAs? Int "c2l_undefined_164"
  let v9 ← j.getObjValAs? Int "c2l_undefined_165"
  let v10 ← j.getObjValAs? Int "c2l_undefined_166"
  let v11 ← j.getObjValAs? Int "c2l_undefined_167"
  let v12 ← j.getObjValAs? Int "c2l_undefined_168"
  let v13 ← j.getObjValAs? Int "c2l_undefined_169"
  let v14 ← j.getObjValAs? Int "c2l_undefined_170"
  let v15 ← j.getObjValAs? Int "c2l_undefined_171"
  return { i160 := BitVec.ofInt 16 v0, i161 := BitVec.ofInt 16 v1, i162 := BitVec.ofInt 16 v2, i163 := BitVec.ofInt 16 v3, i164 := BitVec.ofInt 16 v4, i165 := BitVec.ofInt 16 v5, i166 := BitVec.ofInt 16 v6, i167 := BitVec.ofInt 16 v7, i168 := BitVec.ofInt 16 v8, i169 := BitVec.ofInt 16 v9, i170 := BitVec.ofInt 16 v10, i171 := BitVec.ofInt 16 v11, i172 := BitVec.ofInt 16 v12, i173 := BitVec.ofInt 16 v13, i174 := BitVec.ofInt 16 v14, i175 := BitVec.ofInt 16 v15 }

def decodeInputsGroup0Group11 (j : Lean.Json) : Except String InputsGroup0Group11 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_172"
  let v1 ← j.getObjValAs? Int "c2l_undefined_173"
  let v2 ← j.getObjValAs? Int "c2l_undefined_174"
  let v3 ← j.getObjValAs? Int "c2l_undefined_175"
  let v4 ← j.getObjValAs? Int "c2l_undefined_176"
  let v5 ← j.getObjValAs? Int "c2l_undefined_177"
  let v6 ← j.getObjValAs? Int "c2l_undefined_178"
  let v7 ← j.getObjValAs? Int "c2l_undefined_179"
  let v8 ← j.getObjValAs? Int "c2l_undefined_180"
  let v9 ← j.getObjValAs? Int "c2l_undefined_181"
  let v10 ← j.getObjValAs? Int "c2l_undefined_182"
  let v11 ← j.getObjValAs? Int "c2l_undefined_183"
  let v12 ← j.getObjValAs? Int "c2l_undefined_184"
  let v13 ← j.getObjValAs? Int "c2l_undefined_185"
  let v14 ← j.getObjValAs? Int "c2l_undefined_186"
  let v15 ← j.getObjValAs? Int "c2l_undefined_187"
  return { i176 := BitVec.ofInt 16 v0, i177 := BitVec.ofInt 16 v1, i178 := BitVec.ofInt 16 v2, i179 := BitVec.ofInt 16 v3, i180 := BitVec.ofInt 16 v4, i181 := BitVec.ofInt 16 v5, i182 := BitVec.ofInt 16 v6, i183 := BitVec.ofInt 16 v7, i184 := BitVec.ofInt 16 v8, i185 := BitVec.ofInt 16 v9, i186 := BitVec.ofInt 16 v10, i187 := BitVec.ofInt 16 v11, i188 := BitVec.ofInt 16 v12, i189 := BitVec.ofInt 16 v13, i190 := BitVec.ofInt 16 v14, i191 := BitVec.ofInt 16 v15 }

def decodeInputsGroup0Group12 (j : Lean.Json) : Except String InputsGroup0Group12 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_188"
  let v1 ← j.getObjValAs? Int "c2l_undefined_189"
  let v2 ← j.getObjValAs? Int "c2l_undefined_190"
  let v3 ← j.getObjValAs? Int "c2l_undefined_191"
  let v4 ← j.getObjValAs? Int "c2l_undefined_192"
  let v5 ← j.getObjValAs? Int "c2l_undefined_193"
  let v6 ← j.getObjValAs? Int "c2l_undefined_194"
  let v7 ← j.getObjValAs? Int "c2l_undefined_195"
  let v8 ← j.getObjValAs? Int "c2l_undefined_196"
  let v9 ← j.getObjValAs? Int "c2l_undefined_197"
  let v10 ← j.getObjValAs? Int "c2l_undefined_198"
  let v11 ← j.getObjValAs? Int "c2l_undefined_199"
  let v12 ← j.getObjValAs? Int "c2l_undefined_200"
  let v13 ← j.getObjValAs? Int "c2l_undefined_201"
  let v14 ← j.getObjValAs? Int "c2l_undefined_202"
  let v15 ← j.getObjValAs? Int "c2l_undefined_203"
  return { i192 := BitVec.ofInt 16 v0, i193 := BitVec.ofInt 16 v1, i194 := BitVec.ofInt 16 v2, i195 := BitVec.ofInt 16 v3, i196 := BitVec.ofInt 16 v4, i197 := BitVec.ofInt 16 v5, i198 := BitVec.ofInt 16 v6, i199 := BitVec.ofInt 16 v7, i200 := BitVec.ofInt 16 v8, i201 := BitVec.ofInt 16 v9, i202 := BitVec.ofInt 16 v10, i203 := BitVec.ofInt 16 v11, i204 := BitVec.ofInt 16 v12, i205 := BitVec.ofInt 16 v13, i206 := BitVec.ofInt 16 v14, i207 := BitVec.ofInt 16 v15 }

def decodeInputsGroup0Group13 (j : Lean.Json) : Except String InputsGroup0Group13 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_204"
  let v1 ← j.getObjValAs? Int "c2l_undefined_205"
  let v2 ← j.getObjValAs? Int "c2l_undefined_206"
  let v3 ← j.getObjValAs? Int "c2l_undefined_207"
  let v4 ← j.getObjValAs? Int "c2l_undefined_208"
  let v5 ← j.getObjValAs? Int "c2l_undefined_209"
  let v6 ← j.getObjValAs? Int "c2l_undefined_210"
  let v7 ← j.getObjValAs? Int "c2l_undefined_211"
  let v8 ← j.getObjValAs? Int "c2l_undefined_212"
  let v9 ← j.getObjValAs? Int "c2l_undefined_213"
  let v10 ← j.getObjValAs? Int "c2l_undefined_214"
  let v11 ← j.getObjValAs? Int "c2l_undefined_215"
  let v12 ← j.getObjValAs? Int "c2l_undefined_216"
  let v13 ← j.getObjValAs? Int "c2l_undefined_217"
  let v14 ← j.getObjValAs? Int "c2l_undefined_218"
  let v15 ← j.getObjValAs? Int "c2l_undefined_219"
  return { i208 := BitVec.ofInt 16 v0, i209 := BitVec.ofInt 16 v1, i210 := BitVec.ofInt 16 v2, i211 := BitVec.ofInt 16 v3, i212 := BitVec.ofInt 16 v4, i213 := BitVec.ofInt 16 v5, i214 := BitVec.ofInt 16 v6, i215 := BitVec.ofInt 16 v7, i216 := BitVec.ofInt 16 v8, i217 := BitVec.ofInt 16 v9, i218 := BitVec.ofInt 16 v10, i219 := BitVec.ofInt 16 v11, i220 := BitVec.ofInt 16 v12, i221 := BitVec.ofInt 16 v13, i222 := BitVec.ofInt 16 v14, i223 := BitVec.ofInt 16 v15 }

def decodeInputsGroup0Group14 (j : Lean.Json) : Except String InputsGroup0Group14 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_220"
  let v1 ← j.getObjValAs? Int "c2l_undefined_221"
  let v2 ← j.getObjValAs? Int "c2l_undefined_222"
  let v3 ← j.getObjValAs? Int "c2l_undefined_223"
  let v4 ← j.getObjValAs? Int "c2l_undefined_224"
  let v5 ← j.getObjValAs? Int "c2l_undefined_225"
  let v6 ← j.getObjValAs? Int "c2l_undefined_226"
  let v7 ← j.getObjValAs? Int "c2l_undefined_227"
  let v8 ← j.getObjValAs? Int "c2l_undefined_228"
  let v9 ← j.getObjValAs? Int "c2l_undefined_229"
  let v10 ← j.getObjValAs? Int "c2l_undefined_230"
  let v11 ← j.getObjValAs? Int "c2l_undefined_231"
  let v12 ← j.getObjValAs? Int "c2l_undefined_232"
  let v13 ← j.getObjValAs? Int "c2l_undefined_233"
  let v14 ← j.getObjValAs? Int "c2l_undefined_234"
  let v15 ← j.getObjValAs? Int "c2l_undefined_235"
  return { i224 := BitVec.ofInt 16 v0, i225 := BitVec.ofInt 16 v1, i226 := BitVec.ofInt 16 v2, i227 := BitVec.ofInt 16 v3, i228 := BitVec.ofInt 16 v4, i229 := BitVec.ofInt 16 v5, i230 := BitVec.ofInt 16 v6, i231 := BitVec.ofInt 16 v7, i232 := BitVec.ofInt 16 v8, i233 := BitVec.ofInt 16 v9, i234 := BitVec.ofInt 16 v10, i235 := BitVec.ofInt 16 v11, i236 := BitVec.ofInt 16 v12, i237 := BitVec.ofInt 16 v13, i238 := BitVec.ofInt 16 v14, i239 := BitVec.ofInt 16 v15 }

def decodeInputsGroup0Group15 (j : Lean.Json) : Except String InputsGroup0Group15 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_236"
  let v1 ← j.getObjValAs? Int "c2l_undefined_237"
  let v2 ← j.getObjValAs? Int "c2l_undefined_238"
  let v3 ← j.getObjValAs? Int "c2l_undefined_239"
  let v4 ← j.getObjValAs? Int "c2l_undefined_240"
  let v5 ← j.getObjValAs? Int "c2l_undefined_241"
  let v6 ← j.getObjValAs? Int "c2l_undefined_242"
  let v7 ← j.getObjValAs? Int "c2l_undefined_243"
  let v8 ← j.getObjValAs? Int "c2l_undefined_244"
  let v9 ← j.getObjValAs? Int "c2l_undefined_245"
  let v10 ← j.getObjValAs? Int "c2l_undefined_246"
  let v11 ← j.getObjValAs? Int "c2l_undefined_247"
  let v12 ← j.getObjValAs? Int "c2l_undefined_248"
  let v13 ← j.getObjValAs? Int "c2l_undefined_249"
  let v14 ← j.getObjValAs? Int "c2l_undefined_250"
  let v15 ← j.getObjValAs? Int "c2l_undefined_251"
  return { i240 := BitVec.ofInt 16 v0, i241 := BitVec.ofInt 16 v1, i242 := BitVec.ofInt 16 v2, i243 := BitVec.ofInt 16 v3, i244 := BitVec.ofInt 16 v4, i245 := BitVec.ofInt 16 v5, i246 := BitVec.ofInt 16 v6, i247 := BitVec.ofInt 16 v7, i248 := BitVec.ofInt 16 v8, i249 := BitVec.ofInt 16 v9, i250 := BitVec.ofInt 16 v10, i251 := BitVec.ofInt 16 v11, i252 := BitVec.ofInt 16 v12, i253 := BitVec.ofInt 16 v13, i254 := BitVec.ofInt 16 v14, i255 := BitVec.ofInt 16 v15 }

def decodeInputsGroup0 (j : Lean.Json) : Except String InputsGroup0 := do

  let g0 ← decodeInputsGroup0Group0 j

  let g1 ← decodeInputsGroup0Group1 j

  let g2 ← decodeInputsGroup0Group2 j

  let g3 ← decodeInputsGroup0Group3 j

  let g4 ← decodeInputsGroup0Group4 j

  let g5 ← decodeInputsGroup0Group5 j

  let g6 ← decodeInputsGroup0Group6 j

  let g7 ← decodeInputsGroup0Group7 j

  let g8 ← decodeInputsGroup0Group8 j

  let g9 ← decodeInputsGroup0Group9 j

  let g10 ← decodeInputsGroup0Group10 j

  let g11 ← decodeInputsGroup0Group11 j

  let g12 ← decodeInputsGroup0Group12 j

  let g13 ← decodeInputsGroup0Group13 j

  let g14 ← decodeInputsGroup0Group14 j

  let g15 ← decodeInputsGroup0Group15 j

  return { g0 := g0, g1 := g1, g2 := g2, g3 := g3, g4 := g4, g5 := g5, g6 := g6, g7 := g7, g8 := g8, g9 := g9, g10 := g10, g11 := g11, g12 := g12, g13 := g13, g14 := g14, g15 := g15 }

def decodeInputsGroup1Group0 (j : Lean.Json) : Except String InputsGroup1Group0 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_252"
  let v1 ← j.getObjValAs? Int "c2l_undefined_253"
  let v2 ← j.getObjValAs? Int "c2l_undefined_254"
  let v3 ← j.getObjValAs? Int "c2l_undefined_255"
  let v4 ← j.getObjValAs? Int "c2l_undefined_256"
  let v5 ← j.getObjValAs? Int "c2l_undefined_257"
  let v6 ← j.getObjValAs? Int "c2l_undefined_258"
  let v7 ← j.getObjValAs? Int "c2l_undefined_259"
  let v8 ← j.getObjValAs? Int "c2l_undefined_260"
  let v9 ← j.getObjValAs? Int "c2l_undefined_261"
  let v10 ← j.getObjValAs? Int "c2l_undefined_262"
  let v11 ← j.getObjValAs? Int "c2l_undefined_263"
  let v12 ← j.getObjValAs? Int "c2l_undefined_264"
  let v13 ← j.getObjValAs? Int "c2l_undefined_265"
  let v14 ← j.getObjValAs? Int "c2l_undefined_266"
  let v15 ← j.getObjValAs? Int "c2l_undefined_267"
  return { i256 := BitVec.ofInt 16 v0, i257 := BitVec.ofInt 16 v1, i258 := BitVec.ofInt 16 v2, i259 := BitVec.ofInt 16 v3, i260 := BitVec.ofInt 16 v4, i261 := BitVec.ofInt 16 v5, i262 := BitVec.ofInt 16 v6, i263 := BitVec.ofInt 16 v7, i264 := BitVec.ofInt 16 v8, i265 := BitVec.ofInt 16 v9, i266 := BitVec.ofInt 16 v10, i267 := BitVec.ofInt 16 v11, i268 := BitVec.ofInt 16 v12, i269 := BitVec.ofInt 16 v13, i270 := BitVec.ofInt 16 v14, i271 := BitVec.ofInt 16 v15 }

def decodeInputsGroup1Group1 (j : Lean.Json) : Except String InputsGroup1Group1 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_268"
  let v1 ← j.getObjValAs? Int "c2l_undefined_269"
  let v2 ← j.getObjValAs? Int "c2l_undefined_270"
  let v3 ← j.getObjValAs? Int "c2l_undefined_271"
  let v4 ← j.getObjValAs? Int "c2l_undefined_272"
  let v5 ← j.getObjValAs? Int "c2l_undefined_273"
  let v6 ← j.getObjValAs? Int "c2l_undefined_274"
  let v7 ← j.getObjValAs? Int "c2l_undefined_275"
  let v8 ← j.getObjValAs? Int "c2l_undefined_276"
  let v9 ← j.getObjValAs? Int "c2l_undefined_277"
  let v10 ← j.getObjValAs? Int "c2l_undefined_278"
  let v11 ← j.getObjValAs? Int "c2l_undefined_279"
  let v12 ← j.getObjValAs? Int "c2l_undefined_280"
  let v13 ← j.getObjValAs? Int "c2l_undefined_281"
  let v14 ← j.getObjValAs? Int "c2l_undefined_282"
  let v15 ← j.getObjValAs? Int "c2l_undefined_283"
  return { i272 := BitVec.ofInt 16 v0, i273 := BitVec.ofInt 16 v1, i274 := BitVec.ofInt 16 v2, i275 := BitVec.ofInt 16 v3, i276 := BitVec.ofInt 16 v4, i277 := BitVec.ofInt 16 v5, i278 := BitVec.ofInt 16 v6, i279 := BitVec.ofInt 16 v7, i280 := BitVec.ofInt 16 v8, i281 := BitVec.ofInt 16 v9, i282 := BitVec.ofInt 16 v10, i283 := BitVec.ofInt 16 v11, i284 := BitVec.ofInt 16 v12, i285 := BitVec.ofInt 16 v13, i286 := BitVec.ofInt 16 v14, i287 := BitVec.ofInt 16 v15 }

def decodeInputsGroup1Group2 (j : Lean.Json) : Except String InputsGroup1Group2 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_284"
  let v1 ← j.getObjValAs? Int "c2l_undefined_285"
  let v2 ← j.getObjValAs? Int "c2l_undefined_286"
  let v3 ← j.getObjValAs? Int "c2l_undefined_287"
  let v4 ← j.getObjValAs? Int "c2l_undefined_288"
  let v5 ← j.getObjValAs? Int "c2l_undefined_289"
  let v6 ← j.getObjValAs? Int "c2l_undefined_290"
  let v7 ← j.getObjValAs? Int "c2l_undefined_291"
  let v8 ← j.getObjValAs? Int "c2l_undefined_292"
  let v9 ← j.getObjValAs? Int "c2l_undefined_293"
  let v10 ← j.getObjValAs? Int "c2l_undefined_294"
  let v11 ← j.getObjValAs? Int "c2l_undefined_295"
  let v12 ← j.getObjValAs? Int "c2l_undefined_296"
  let v13 ← j.getObjValAs? Int "c2l_undefined_297"
  let v14 ← j.getObjValAs? Int "c2l_undefined_298"
  let v15 ← j.getObjValAs? Int "c2l_undefined_299"
  return { i288 := BitVec.ofInt 16 v0, i289 := BitVec.ofInt 16 v1, i290 := BitVec.ofInt 16 v2, i291 := BitVec.ofInt 16 v3, i292 := BitVec.ofInt 16 v4, i293 := BitVec.ofInt 16 v5, i294 := BitVec.ofInt 16 v6, i295 := BitVec.ofInt 16 v7, i296 := BitVec.ofInt 16 v8, i297 := BitVec.ofInt 16 v9, i298 := BitVec.ofInt 16 v10, i299 := BitVec.ofInt 16 v11, i300 := BitVec.ofInt 16 v12, i301 := BitVec.ofInt 16 v13, i302 := BitVec.ofInt 16 v14, i303 := BitVec.ofInt 16 v15 }

def decodeInputsGroup1Group3 (j : Lean.Json) : Except String InputsGroup1Group3 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_300"
  let v1 ← j.getObjValAs? Int "c2l_undefined_301"
  let v2 ← j.getObjValAs? Int "c2l_undefined_302"
  let v3 ← j.getObjValAs? Int "c2l_undefined_303"
  let v4 ← j.getObjValAs? Int "c2l_undefined_304"
  let v5 ← j.getObjValAs? Int "c2l_undefined_305"
  let v6 ← j.getObjValAs? Int "c2l_undefined_306"
  let v7 ← j.getObjValAs? Int "c2l_undefined_307"
  let v8 ← j.getObjValAs? Int "c2l_undefined_308"
  let v9 ← j.getObjValAs? Int "c2l_undefined_309"
  let v10 ← j.getObjValAs? Int "c2l_undefined_310"
  let v11 ← j.getObjValAs? Int "c2l_undefined_311"
  let v12 ← j.getObjValAs? Int "c2l_undefined_312"
  let v13 ← j.getObjValAs? Int "c2l_undefined_313"
  let v14 ← j.getObjValAs? Int "c2l_undefined_314"
  let v15 ← j.getObjValAs? Int "c2l_undefined_315"
  return { i304 := BitVec.ofInt 16 v0, i305 := BitVec.ofInt 16 v1, i306 := BitVec.ofInt 16 v2, i307 := BitVec.ofInt 16 v3, i308 := BitVec.ofInt 16 v4, i309 := BitVec.ofInt 16 v5, i310 := BitVec.ofInt 16 v6, i311 := BitVec.ofInt 16 v7, i312 := BitVec.ofInt 16 v8, i313 := BitVec.ofInt 16 v9, i314 := BitVec.ofInt 16 v10, i315 := BitVec.ofInt 16 v11, i316 := BitVec.ofInt 16 v12, i317 := BitVec.ofInt 16 v13, i318 := BitVec.ofInt 16 v14, i319 := BitVec.ofInt 16 v15 }

def decodeInputsGroup1Group4 (j : Lean.Json) : Except String InputsGroup1Group4 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_316"
  let v1 ← j.getObjValAs? Int "c2l_undefined_317"
  let v2 ← j.getObjValAs? Int "c2l_undefined_318"
  let v3 ← j.getObjValAs? Int "c2l_undefined_319"
  let v4 ← j.getObjValAs? Int "c2l_undefined_320"
  let v5 ← j.getObjValAs? Int "c2l_undefined_321"
  let v6 ← j.getObjValAs? Int "c2l_undefined_322"
  let v7 ← j.getObjValAs? Int "c2l_undefined_323"
  let v8 ← j.getObjValAs? Int "c2l_undefined_324"
  let v9 ← j.getObjValAs? Int "c2l_undefined_325"
  let v10 ← j.getObjValAs? Int "c2l_undefined_326"
  let v11 ← j.getObjValAs? Int "c2l_undefined_327"
  let v12 ← j.getObjValAs? Int "c2l_undefined_328"
  let v13 ← j.getObjValAs? Int "c2l_undefined_329"
  let v14 ← j.getObjValAs? Int "c2l_undefined_330"
  let v15 ← j.getObjValAs? Int "c2l_undefined_331"
  return { i320 := BitVec.ofInt 16 v0, i321 := BitVec.ofInt 16 v1, i322 := BitVec.ofInt 16 v2, i323 := BitVec.ofInt 16 v3, i324 := BitVec.ofInt 16 v4, i325 := BitVec.ofInt 16 v5, i326 := BitVec.ofInt 16 v6, i327 := BitVec.ofInt 16 v7, i328 := BitVec.ofInt 16 v8, i329 := BitVec.ofInt 16 v9, i330 := BitVec.ofInt 16 v10, i331 := BitVec.ofInt 16 v11, i332 := BitVec.ofInt 16 v12, i333 := BitVec.ofInt 16 v13, i334 := BitVec.ofInt 16 v14, i335 := BitVec.ofInt 16 v15 }

def decodeInputsGroup1Group5 (j : Lean.Json) : Except String InputsGroup1Group5 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_332"
  let v1 ← j.getObjValAs? Int "c2l_undefined_333"
  let v2 ← j.getObjValAs? Int "c2l_undefined_334"
  let v3 ← j.getObjValAs? Int "c2l_undefined_335"
  let v4 ← j.getObjValAs? Int "c2l_undefined_336"
  let v5 ← j.getObjValAs? Int "c2l_undefined_337"
  let v6 ← j.getObjValAs? Int "c2l_undefined_338"
  let v7 ← j.getObjValAs? Int "c2l_undefined_339"
  let v8 ← j.getObjValAs? Int "c2l_undefined_340"
  let v9 ← j.getObjValAs? Int "c2l_undefined_341"
  let v10 ← j.getObjValAs? Int "c2l_undefined_342"
  let v11 ← j.getObjValAs? Int "c2l_undefined_343"
  let v12 ← j.getObjValAs? Int "c2l_undefined_344"
  let v13 ← j.getObjValAs? Int "c2l_undefined_345"
  let v14 ← j.getObjValAs? Int "c2l_undefined_346"
  let v15 ← j.getObjValAs? Int "c2l_undefined_347"
  return { i336 := BitVec.ofInt 16 v0, i337 := BitVec.ofInt 16 v1, i338 := BitVec.ofInt 16 v2, i339 := BitVec.ofInt 16 v3, i340 := BitVec.ofInt 16 v4, i341 := BitVec.ofInt 16 v5, i342 := BitVec.ofInt 16 v6, i343 := BitVec.ofInt 16 v7, i344 := BitVec.ofInt 16 v8, i345 := BitVec.ofInt 16 v9, i346 := BitVec.ofInt 16 v10, i347 := BitVec.ofInt 16 v11, i348 := BitVec.ofInt 16 v12, i349 := BitVec.ofInt 16 v13, i350 := BitVec.ofInt 16 v14, i351 := BitVec.ofInt 16 v15 }

def decodeInputsGroup1Group6 (j : Lean.Json) : Except String InputsGroup1Group6 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_348"
  let v1 ← j.getObjValAs? Int "c2l_undefined_349"
  let v2 ← j.getObjValAs? Int "c2l_undefined_350"
  let v3 ← j.getObjValAs? Int "c2l_undefined_351"
  let v4 ← j.getObjValAs? Int "c2l_undefined_352"
  let v5 ← j.getObjValAs? Int "c2l_undefined_353"
  let v6 ← j.getObjValAs? Int "c2l_undefined_354"
  let v7 ← j.getObjValAs? Int "c2l_undefined_355"
  let v8 ← j.getObjValAs? Int "c2l_undefined_356"
  let v9 ← j.getObjValAs? Int "c2l_undefined_357"
  let v10 ← j.getObjValAs? Int "c2l_undefined_358"
  let v11 ← j.getObjValAs? Int "c2l_undefined_359"
  let v12 ← j.getObjValAs? Int "c2l_undefined_360"
  let v13 ← j.getObjValAs? Int "c2l_undefined_361"
  let v14 ← j.getObjValAs? Int "c2l_undefined_362"
  let v15 ← j.getObjValAs? Int "c2l_undefined_363"
  return { i352 := BitVec.ofInt 16 v0, i353 := BitVec.ofInt 16 v1, i354 := BitVec.ofInt 16 v2, i355 := BitVec.ofInt 16 v3, i356 := BitVec.ofInt 16 v4, i357 := BitVec.ofInt 16 v5, i358 := BitVec.ofInt 16 v6, i359 := BitVec.ofInt 16 v7, i360 := BitVec.ofInt 16 v8, i361 := BitVec.ofInt 16 v9, i362 := BitVec.ofInt 16 v10, i363 := BitVec.ofInt 16 v11, i364 := BitVec.ofInt 16 v12, i365 := BitVec.ofInt 16 v13, i366 := BitVec.ofInt 16 v14, i367 := BitVec.ofInt 16 v15 }

def decodeInputsGroup1Group7 (j : Lean.Json) : Except String InputsGroup1Group7 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_364"
  let v1 ← j.getObjValAs? Int "c2l_undefined_365"
  let v2 ← j.getObjValAs? Int "c2l_undefined_366"
  let v3 ← j.getObjValAs? Int "c2l_undefined_367"
  let v4 ← j.getObjValAs? Int "c2l_undefined_368"
  let v5 ← j.getObjValAs? Int "c2l_undefined_369"
  let v6 ← j.getObjValAs? Int "c2l_undefined_370"
  let v7 ← j.getObjValAs? Int "c2l_undefined_371"
  let v8 ← j.getObjValAs? Int "c2l_undefined_372"
  let v9 ← j.getObjValAs? Int "c2l_undefined_373"
  let v10 ← j.getObjValAs? Int "c2l_undefined_374"
  let v11 ← j.getObjValAs? Int "c2l_undefined_375"
  let v12 ← j.getObjValAs? Int "c2l_undefined_376"
  let v13 ← j.getObjValAs? Int "c2l_undefined_377"
  let v14 ← j.getObjValAs? Int "c2l_undefined_378"
  let v15 ← j.getObjValAs? Int "c2l_undefined_379"
  return { i368 := BitVec.ofInt 16 v0, i369 := BitVec.ofInt 16 v1, i370 := BitVec.ofInt 16 v2, i371 := BitVec.ofInt 16 v3, i372 := BitVec.ofInt 16 v4, i373 := BitVec.ofInt 16 v5, i374 := BitVec.ofInt 16 v6, i375 := BitVec.ofInt 16 v7, i376 := BitVec.ofInt 16 v8, i377 := BitVec.ofInt 16 v9, i378 := BitVec.ofInt 16 v10, i379 := BitVec.ofInt 16 v11, i380 := BitVec.ofInt 16 v12, i381 := BitVec.ofInt 16 v13, i382 := BitVec.ofInt 16 v14, i383 := BitVec.ofInt 16 v15 }

def decodeInputsGroup1Group8 (j : Lean.Json) : Except String InputsGroup1Group8 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_380"
  let v1 ← j.getObjValAs? Int "c2l_undefined_381"
  let v2 ← j.getObjValAs? Int "c2l_undefined_382"
  let v3 ← j.getObjValAs? Int "c2l_undefined_383"
  let v4 ← j.getObjValAs? Int "c2l_undefined_384"
  let v5 ← j.getObjValAs? Int "c2l_undefined_385"
  let v6 ← j.getObjValAs? Int "c2l_undefined_386"
  let v7 ← j.getObjValAs? Int "c2l_undefined_387"
  let v8 ← j.getObjValAs? Int "c2l_undefined_388"
  let v9 ← j.getObjValAs? Int "c2l_undefined_389"
  let v10 ← j.getObjValAs? Int "c2l_undefined_390"
  let v11 ← j.getObjValAs? Int "c2l_undefined_391"
  let v12 ← j.getObjValAs? Int "c2l_undefined_392"
  let v13 ← j.getObjValAs? Int "c2l_undefined_393"
  let v14 ← j.getObjValAs? Int "c2l_undefined_394"
  let v15 ← j.getObjValAs? Int "c2l_undefined_395"
  return { i384 := BitVec.ofInt 16 v0, i385 := BitVec.ofInt 16 v1, i386 := BitVec.ofInt 16 v2, i387 := BitVec.ofInt 16 v3, i388 := BitVec.ofInt 16 v4, i389 := BitVec.ofInt 16 v5, i390 := BitVec.ofInt 16 v6, i391 := BitVec.ofInt 16 v7, i392 := BitVec.ofInt 16 v8, i393 := BitVec.ofInt 16 v9, i394 := BitVec.ofInt 16 v10, i395 := BitVec.ofInt 16 v11, i396 := BitVec.ofInt 16 v12, i397 := BitVec.ofInt 16 v13, i398 := BitVec.ofInt 16 v14, i399 := BitVec.ofInt 16 v15 }

def decodeInputsGroup1Group9 (j : Lean.Json) : Except String InputsGroup1Group9 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_396"
  let v1 ← j.getObjValAs? Int "c2l_undefined_397"
  let v2 ← j.getObjValAs? Int "c2l_undefined_398"
  let v3 ← j.getObjValAs? Int "c2l_undefined_399"
  let v4 ← j.getObjValAs? Int "c2l_undefined_400"
  let v5 ← j.getObjValAs? Int "c2l_undefined_401"
  let v6 ← j.getObjValAs? Int "c2l_undefined_402"
  let v7 ← j.getObjValAs? Int "c2l_undefined_403"
  let v8 ← j.getObjValAs? Int "c2l_undefined_404"
  let v9 ← j.getObjValAs? Int "c2l_undefined_405"
  let v10 ← j.getObjValAs? Int "c2l_undefined_406"
  let v11 ← j.getObjValAs? Int "c2l_undefined_407"
  let v12 ← j.getObjValAs? Int "c2l_undefined_408"
  let v13 ← j.getObjValAs? Int "c2l_undefined_409"
  let v14 ← j.getObjValAs? Int "c2l_undefined_410"
  let v15 ← j.getObjValAs? Int "c2l_undefined_411"
  return { i400 := BitVec.ofInt 16 v0, i401 := BitVec.ofInt 16 v1, i402 := BitVec.ofInt 16 v2, i403 := BitVec.ofInt 16 v3, i404 := BitVec.ofInt 16 v4, i405 := BitVec.ofInt 16 v5, i406 := BitVec.ofInt 16 v6, i407 := BitVec.ofInt 16 v7, i408 := BitVec.ofInt 16 v8, i409 := BitVec.ofInt 16 v9, i410 := BitVec.ofInt 16 v10, i411 := BitVec.ofInt 16 v11, i412 := BitVec.ofInt 16 v12, i413 := BitVec.ofInt 16 v13, i414 := BitVec.ofInt 16 v14, i415 := BitVec.ofInt 16 v15 }

def decodeInputsGroup1Group10 (j : Lean.Json) : Except String InputsGroup1Group10 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_412"
  let v1 ← j.getObjValAs? Int "c2l_undefined_413"
  let v2 ← j.getObjValAs? Int "c2l_undefined_414"
  let v3 ← j.getObjValAs? Int "c2l_undefined_415"
  let v4 ← j.getObjValAs? Int "c2l_undefined_416"
  let v5 ← j.getObjValAs? Int "c2l_undefined_417"
  let v6 ← j.getObjValAs? Int "c2l_undefined_418"
  let v7 ← j.getObjValAs? Int "c2l_undefined_419"
  let v8 ← j.getObjValAs? Int "c2l_undefined_420"
  let v9 ← j.getObjValAs? Int "c2l_undefined_421"
  let v10 ← j.getObjValAs? Int "c2l_undefined_422"
  let v11 ← j.getObjValAs? Int "c2l_undefined_423"
  let v12 ← j.getObjValAs? Int "c2l_undefined_424"
  let v13 ← j.getObjValAs? Int "c2l_undefined_425"
  let v14 ← j.getObjValAs? Int "c2l_undefined_426"
  let v15 ← j.getObjValAs? Int "c2l_undefined_427"
  return { i416 := BitVec.ofInt 16 v0, i417 := BitVec.ofInt 16 v1, i418 := BitVec.ofInt 16 v2, i419 := BitVec.ofInt 16 v3, i420 := BitVec.ofInt 16 v4, i421 := BitVec.ofInt 16 v5, i422 := BitVec.ofInt 16 v6, i423 := BitVec.ofInt 16 v7, i424 := BitVec.ofInt 16 v8, i425 := BitVec.ofInt 16 v9, i426 := BitVec.ofInt 16 v10, i427 := BitVec.ofInt 16 v11, i428 := BitVec.ofInt 16 v12, i429 := BitVec.ofInt 16 v13, i430 := BitVec.ofInt 16 v14, i431 := BitVec.ofInt 16 v15 }

def decodeInputsGroup1Group11 (j : Lean.Json) : Except String InputsGroup1Group11 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_428"
  let v1 ← j.getObjValAs? Int "c2l_undefined_429"
  let v2 ← j.getObjValAs? Int "c2l_undefined_430"
  let v3 ← j.getObjValAs? Int "c2l_undefined_431"
  let v4 ← j.getObjValAs? Int "c2l_undefined_432"
  let v5 ← j.getObjValAs? Int "c2l_undefined_433"
  let v6 ← j.getObjValAs? Int "c2l_undefined_434"
  let v7 ← j.getObjValAs? Int "c2l_undefined_435"
  let v8 ← j.getObjValAs? Int "c2l_undefined_436"
  let v9 ← j.getObjValAs? Int "c2l_undefined_437"
  let v10 ← j.getObjValAs? Int "c2l_undefined_438"
  let v11 ← j.getObjValAs? Int "c2l_undefined_439"
  let v12 ← j.getObjValAs? Int "c2l_undefined_440"
  let v13 ← j.getObjValAs? Int "c2l_undefined_441"
  let v14 ← j.getObjValAs? Int "c2l_undefined_442"
  let v15 ← j.getObjValAs? Int "c2l_undefined_443"
  return { i432 := BitVec.ofInt 16 v0, i433 := BitVec.ofInt 16 v1, i434 := BitVec.ofInt 16 v2, i435 := BitVec.ofInt 16 v3, i436 := BitVec.ofInt 16 v4, i437 := BitVec.ofInt 16 v5, i438 := BitVec.ofInt 16 v6, i439 := BitVec.ofInt 16 v7, i440 := BitVec.ofInt 16 v8, i441 := BitVec.ofInt 16 v9, i442 := BitVec.ofInt 16 v10, i443 := BitVec.ofInt 16 v11, i444 := BitVec.ofInt 16 v12, i445 := BitVec.ofInt 16 v13, i446 := BitVec.ofInt 16 v14, i447 := BitVec.ofInt 16 v15 }

def decodeInputsGroup1Group12 (j : Lean.Json) : Except String InputsGroup1Group12 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_444"
  let v1 ← j.getObjValAs? Int "c2l_undefined_445"
  let v2 ← j.getObjValAs? Int "c2l_undefined_446"
  let v3 ← j.getObjValAs? Int "c2l_undefined_447"
  let v4 ← j.getObjValAs? Int "c2l_undefined_448"
  let v5 ← j.getObjValAs? Int "c2l_undefined_449"
  let v6 ← j.getObjValAs? Int "c2l_undefined_450"
  let v7 ← j.getObjValAs? Int "c2l_undefined_451"
  let v8 ← j.getObjValAs? Int "c2l_undefined_452"
  let v9 ← j.getObjValAs? Int "c2l_undefined_453"
  let v10 ← j.getObjValAs? Int "c2l_undefined_454"
  let v11 ← j.getObjValAs? Int "c2l_undefined_455"
  let v12 ← j.getObjValAs? Int "c2l_undefined_456"
  let v13 ← j.getObjValAs? Int "c2l_undefined_457"
  let v14 ← j.getObjValAs? Int "c2l_undefined_458"
  let v15 ← j.getObjValAs? Int "c2l_undefined_459"
  return { i448 := BitVec.ofInt 16 v0, i449 := BitVec.ofInt 16 v1, i450 := BitVec.ofInt 16 v2, i451 := BitVec.ofInt 16 v3, i452 := BitVec.ofInt 16 v4, i453 := BitVec.ofInt 16 v5, i454 := BitVec.ofInt 16 v6, i455 := BitVec.ofInt 16 v7, i456 := BitVec.ofInt 16 v8, i457 := BitVec.ofInt 16 v9, i458 := BitVec.ofInt 16 v10, i459 := BitVec.ofInt 16 v11, i460 := BitVec.ofInt 16 v12, i461 := BitVec.ofInt 16 v13, i462 := BitVec.ofInt 16 v14, i463 := BitVec.ofInt 16 v15 }

def decodeInputsGroup1Group13 (j : Lean.Json) : Except String InputsGroup1Group13 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_460"
  let v1 ← j.getObjValAs? Int "c2l_undefined_461"
  let v2 ← j.getObjValAs? Int "c2l_undefined_462"
  let v3 ← j.getObjValAs? Int "c2l_undefined_463"
  let v4 ← j.getObjValAs? Int "c2l_undefined_464"
  let v5 ← j.getObjValAs? Int "c2l_undefined_465"
  let v6 ← j.getObjValAs? Int "c2l_undefined_466"
  let v7 ← j.getObjValAs? Int "c2l_undefined_467"
  let v8 ← j.getObjValAs? Int "c2l_undefined_468"
  let v9 ← j.getObjValAs? Int "c2l_undefined_469"
  let v10 ← j.getObjValAs? Int "c2l_undefined_470"
  let v11 ← j.getObjValAs? Int "c2l_undefined_471"
  let v12 ← j.getObjValAs? Int "c2l_undefined_472"
  let v13 ← j.getObjValAs? Int "c2l_undefined_473"
  let v14 ← j.getObjValAs? Int "c2l_undefined_474"
  let v15 ← j.getObjValAs? Int "c2l_undefined_475"
  return { i464 := BitVec.ofInt 16 v0, i465 := BitVec.ofInt 16 v1, i466 := BitVec.ofInt 16 v2, i467 := BitVec.ofInt 16 v3, i468 := BitVec.ofInt 16 v4, i469 := BitVec.ofInt 16 v5, i470 := BitVec.ofInt 16 v6, i471 := BitVec.ofInt 16 v7, i472 := BitVec.ofInt 16 v8, i473 := BitVec.ofInt 16 v9, i474 := BitVec.ofInt 16 v10, i475 := BitVec.ofInt 16 v11, i476 := BitVec.ofInt 16 v12, i477 := BitVec.ofInt 16 v13, i478 := BitVec.ofInt 16 v14, i479 := BitVec.ofInt 16 v15 }

def decodeInputsGroup1Group14 (j : Lean.Json) : Except String InputsGroup1Group14 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_476"
  let v1 ← j.getObjValAs? Int "c2l_undefined_477"
  let v2 ← j.getObjValAs? Int "c2l_undefined_478"
  let v3 ← j.getObjValAs? Int "c2l_undefined_479"
  let v4 ← j.getObjValAs? Int "c2l_undefined_480"
  let v5 ← j.getObjValAs? Int "c2l_undefined_481"
  let v6 ← j.getObjValAs? Int "c2l_undefined_482"
  let v7 ← j.getObjValAs? Int "c2l_undefined_483"
  let v8 ← j.getObjValAs? Int "c2l_undefined_484"
  let v9 ← j.getObjValAs? Int "c2l_undefined_485"
  let v10 ← j.getObjValAs? Int "c2l_undefined_486"
  let v11 ← j.getObjValAs? Int "c2l_undefined_487"
  let v12 ← j.getObjValAs? Int "c2l_undefined_488"
  let v13 ← j.getObjValAs? Int "c2l_undefined_489"
  let v14 ← j.getObjValAs? Int "c2l_undefined_490"
  let v15 ← j.getObjValAs? Int "c2l_undefined_491"
  return { i480 := BitVec.ofInt 16 v0, i481 := BitVec.ofInt 16 v1, i482 := BitVec.ofInt 16 v2, i483 := BitVec.ofInt 16 v3, i484 := BitVec.ofInt 16 v4, i485 := BitVec.ofInt 16 v5, i486 := BitVec.ofInt 16 v6, i487 := BitVec.ofInt 16 v7, i488 := BitVec.ofInt 16 v8, i489 := BitVec.ofInt 16 v9, i490 := BitVec.ofInt 16 v10, i491 := BitVec.ofInt 16 v11, i492 := BitVec.ofInt 16 v12, i493 := BitVec.ofInt 16 v13, i494 := BitVec.ofInt 16 v14, i495 := BitVec.ofInt 16 v15 }

def decodeInputsGroup1Group15 (j : Lean.Json) : Except String InputsGroup1Group15 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_492"
  let v1 ← j.getObjValAs? Int "c2l_undefined_493"
  let v2 ← j.getObjValAs? Int "c2l_undefined_494"
  let v3 ← j.getObjValAs? Int "c2l_undefined_495"
  let v4 ← j.getObjValAs? Int "c2l_undefined_496"
  let v5 ← j.getObjValAs? Int "c2l_undefined_497"
  let v6 ← j.getObjValAs? Int "c2l_undefined_498"
  let v7 ← j.getObjValAs? Int "c2l_undefined_499"
  let v8 ← j.getObjValAs? Int "c2l_undefined_500"
  let v9 ← j.getObjValAs? Int "c2l_undefined_501"
  let v10 ← j.getObjValAs? Int "c2l_undefined_502"
  let v11 ← j.getObjValAs? Int "c2l_undefined_503"
  let v12 ← j.getObjValAs? Int "c2l_undefined_504"
  let v13 ← j.getObjValAs? Int "c2l_undefined_505"
  let v14 ← j.getObjValAs? Int "c2l_undefined_506"
  let v15 ← j.getObjValAs? Int "c2l_undefined_507"
  return { i496 := BitVec.ofInt 16 v0, i497 := BitVec.ofInt 16 v1, i498 := BitVec.ofInt 16 v2, i499 := BitVec.ofInt 16 v3, i500 := BitVec.ofInt 16 v4, i501 := BitVec.ofInt 16 v5, i502 := BitVec.ofInt 16 v6, i503 := BitVec.ofInt 16 v7, i504 := BitVec.ofInt 16 v8, i505 := BitVec.ofInt 16 v9, i506 := BitVec.ofInt 16 v10, i507 := BitVec.ofInt 16 v11, i508 := BitVec.ofInt 16 v12, i509 := BitVec.ofInt 16 v13, i510 := BitVec.ofInt 16 v14, i511 := BitVec.ofInt 16 v15 }

def decodeInputsGroup1 (j : Lean.Json) : Except String InputsGroup1 := do

  let g0 ← decodeInputsGroup1Group0 j

  let g1 ← decodeInputsGroup1Group1 j

  let g2 ← decodeInputsGroup1Group2 j

  let g3 ← decodeInputsGroup1Group3 j

  let g4 ← decodeInputsGroup1Group4 j

  let g5 ← decodeInputsGroup1Group5 j

  let g6 ← decodeInputsGroup1Group6 j

  let g7 ← decodeInputsGroup1Group7 j

  let g8 ← decodeInputsGroup1Group8 j

  let g9 ← decodeInputsGroup1Group9 j

  let g10 ← decodeInputsGroup1Group10 j

  let g11 ← decodeInputsGroup1Group11 j

  let g12 ← decodeInputsGroup1Group12 j

  let g13 ← decodeInputsGroup1Group13 j

  let g14 ← decodeInputsGroup1Group14 j

  let g15 ← decodeInputsGroup1Group15 j

  return { g0 := g0, g1 := g1, g2 := g2, g3 := g3, g4 := g4, g5 := g5, g6 := g6, g7 := g7, g8 := g8, g9 := g9, g10 := g10, g11 := g11, g12 := g12, g13 := g13, g14 := g14, g15 := g15 }

def decodeInputsGroup2 (j : Lean.Json) : Except String InputsGroup2 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_508"
  let v1 ← j.getObjValAs? Int "c2l_undefined_509"
  let v2 ← j.getObjValAs? Int "c2l_undefined_510"
  let v3 ← j.getObjValAs? Int "c2l_undefined_511"
  return { i512 := BitVec.ofInt 16 v0, i513 := BitVec.ofInt 16 v1, i514 := BitVec.ofInt 16 v2, i515 := BitVec.ofInt 16 v3 }

def decodeInputs (j : Lean.Json) : Except String Inputs := do

  let g0 ← decodeInputsGroup0 j

  let g1 ← decodeInputsGroup1 j

  let g2 ← decodeInputsGroup2 j

  return { g0 := g0, g1 := g1, g2 := g2 }
def decodeStateGroup0Group0 (j : Lean.Json) : Except String StateGroup0Group0 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4576"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4566"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4546"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4536"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4526"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4516"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4506"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4496"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4486"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4476"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4466"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4456"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4426"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4416"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4406"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4396"
  return { s0 := BitVec.ofInt 1 v0, s1 := BitVec.ofInt 1 v1, s2 := BitVec.ofInt 1 v2, s3 := BitVec.ofInt 1 v3, s4 := BitVec.ofInt 1 v4, s5 := BitVec.ofInt 1 v5, s6 := BitVec.ofInt 1 v6, s7 := BitVec.ofInt 1 v7, s8 := BitVec.ofInt 1 v8, s9 := BitVec.ofInt 1 v9, s10 := BitVec.ofInt 1 v10, s11 := BitVec.ofInt 1 v11, s12 := BitVec.ofInt 1 v12, s13 := BitVec.ofInt 1 v13, s14 := BitVec.ofInt 1 v14, s15 := BitVec.ofInt 1 v15 }

def decodeStateGroup0Group1 (j : Lean.Json) : Except String StateGroup0Group1 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4386"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4376"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4366"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4356"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4346"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4336"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4316"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4306"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4296"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4286"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4276"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4266"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4256"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4246"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4236"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4226"
  return { s16 := BitVec.ofInt 1 v0, s17 := BitVec.ofInt 1 v1, s18 := BitVec.ofInt 1 v2, s19 := BitVec.ofInt 1 v3, s20 := BitVec.ofInt 1 v4, s21 := BitVec.ofInt 1 v5, s22 := BitVec.ofInt 1 v6, s23 := BitVec.ofInt 1 v7, s24 := BitVec.ofInt 1 v8, s25 := BitVec.ofInt 1 v9, s26 := BitVec.ofInt 1 v10, s27 := BitVec.ofInt 1 v11, s28 := BitVec.ofInt 1 v12, s29 := BitVec.ofInt 1 v13, s30 := BitVec.ofInt 1 v14, s31 := BitVec.ofInt 1 v15 }

def decodeStateGroup0Group2 (j : Lean.Json) : Except String StateGroup0Group2 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4206"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4196"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4186"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4176"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4166"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4156"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4146"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4136"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4126"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4116"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4096"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4086"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4076"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4066"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4056"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4046"
  return { s32 := BitVec.ofInt 1 v0, s33 := BitVec.ofInt 1 v1, s34 := BitVec.ofInt 1 v2, s35 := BitVec.ofInt 1 v3, s36 := BitVec.ofInt 1 v4, s37 := BitVec.ofInt 1 v5, s38 := BitVec.ofInt 1 v6, s39 := BitVec.ofInt 1 v7, s40 := BitVec.ofInt 1 v8, s41 := BitVec.ofInt 1 v9, s42 := BitVec.ofInt 1 v10, s43 := BitVec.ofInt 1 v11, s44 := BitVec.ofInt 1 v12, s45 := BitVec.ofInt 1 v13, s46 := BitVec.ofInt 1 v14, s47 := BitVec.ofInt 1 v15 }

def decodeStateGroup0Group3 (j : Lean.Json) : Except String StateGroup0Group3 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4036"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4026"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4016"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4006"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3986"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3976"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3966"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3956"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3946"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3936"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3926"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3916"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3906"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3896"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3876"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3866"
  return { s48 := BitVec.ofInt 1 v0, s49 := BitVec.ofInt 1 v1, s50 := BitVec.ofInt 1 v2, s51 := BitVec.ofInt 1 v3, s52 := BitVec.ofInt 1 v4, s53 := BitVec.ofInt 1 v5, s54 := BitVec.ofInt 1 v6, s55 := BitVec.ofInt 1 v7, s56 := BitVec.ofInt 1 v8, s57 := BitVec.ofInt 1 v9, s58 := BitVec.ofInt 1 v10, s59 := BitVec.ofInt 1 v11, s60 := BitVec.ofInt 1 v12, s61 := BitVec.ofInt 1 v13, s62 := BitVec.ofInt 1 v14, s63 := BitVec.ofInt 1 v15 }

def decodeStateGroup0Group4 (j : Lean.Json) : Except String StateGroup0Group4 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3856"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3846"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3836"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3826"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3816"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3806"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3796"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3786"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3766"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3756"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3746"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3736"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3726"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3716"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3706"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3696"
  return { s64 := BitVec.ofInt 1 v0, s65 := BitVec.ofInt 1 v1, s66 := BitVec.ofInt 1 v2, s67 := BitVec.ofInt 1 v3, s68 := BitVec.ofInt 1 v4, s69 := BitVec.ofInt 1 v5, s70 := BitVec.ofInt 1 v6, s71 := BitVec.ofInt 1 v7, s72 := BitVec.ofInt 1 v8, s73 := BitVec.ofInt 1 v9, s74 := BitVec.ofInt 1 v10, s75 := BitVec.ofInt 1 v11, s76 := BitVec.ofInt 1 v12, s77 := BitVec.ofInt 1 v13, s78 := BitVec.ofInt 1 v14, s79 := BitVec.ofInt 1 v15 }

def decodeStateGroup0Group5 (j : Lean.Json) : Except String StateGroup0Group5 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3686"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3676"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3656"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3646"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3636"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3626"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3616"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3606"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3596"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3586"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3576"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3566"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3546"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3536"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3526"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3516"
  return { s80 := BitVec.ofInt 1 v0, s81 := BitVec.ofInt 1 v1, s82 := BitVec.ofInt 1 v2, s83 := BitVec.ofInt 1 v3, s84 := BitVec.ofInt 1 v4, s85 := BitVec.ofInt 1 v5, s86 := BitVec.ofInt 1 v6, s87 := BitVec.ofInt 1 v7, s88 := BitVec.ofInt 1 v8, s89 := BitVec.ofInt 1 v9, s90 := BitVec.ofInt 1 v10, s91 := BitVec.ofInt 1 v11, s92 := BitVec.ofInt 1 v12, s93 := BitVec.ofInt 1 v13, s94 := BitVec.ofInt 1 v14, s95 := BitVec.ofInt 1 v15 }

def decodeStateGroup0Group6 (j : Lean.Json) : Except String StateGroup0Group6 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3506"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3496"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3486"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3476"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3466"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3456"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3436"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3426"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3416"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3406"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3396"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3386"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3376"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3366"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3356"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3346"
  return { s96 := BitVec.ofInt 1 v0, s97 := BitVec.ofInt 1 v1, s98 := BitVec.ofInt 1 v2, s99 := BitVec.ofInt 1 v3, s100 := BitVec.ofInt 1 v4, s101 := BitVec.ofInt 1 v5, s102 := BitVec.ofInt 1 v6, s103 := BitVec.ofInt 1 v7, s104 := BitVec.ofInt 1 v8, s105 := BitVec.ofInt 1 v9, s106 := BitVec.ofInt 1 v10, s107 := BitVec.ofInt 1 v11, s108 := BitVec.ofInt 1 v12, s109 := BitVec.ofInt 1 v13, s110 := BitVec.ofInt 1 v14, s111 := BitVec.ofInt 1 v15 }

def decodeStateGroup0Group7 (j : Lean.Json) : Except String StateGroup0Group7 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3316"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3306"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3296"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3286"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3276"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3266"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3256"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3246"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3236"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3226"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3206"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3196"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3186"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3176"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3166"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3156"
  return { s112 := BitVec.ofInt 1 v0, s113 := BitVec.ofInt 1 v1, s114 := BitVec.ofInt 1 v2, s115 := BitVec.ofInt 1 v3, s116 := BitVec.ofInt 1 v4, s117 := BitVec.ofInt 1 v5, s118 := BitVec.ofInt 1 v6, s119 := BitVec.ofInt 1 v7, s120 := BitVec.ofInt 1 v8, s121 := BitVec.ofInt 1 v9, s122 := BitVec.ofInt 1 v10, s123 := BitVec.ofInt 1 v11, s124 := BitVec.ofInt 1 v12, s125 := BitVec.ofInt 1 v13, s126 := BitVec.ofInt 1 v14, s127 := BitVec.ofInt 1 v15 }

def decodeStateGroup0Group8 (j : Lean.Json) : Except String StateGroup0Group8 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3146"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3136"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3126"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3116"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3096"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3086"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3076"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3066"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3056"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3046"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3036"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3026"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3016"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3006"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2986"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2976"
  return { s128 := BitVec.ofInt 1 v0, s129 := BitVec.ofInt 1 v1, s130 := BitVec.ofInt 1 v2, s131 := BitVec.ofInt 1 v3, s132 := BitVec.ofInt 1 v4, s133 := BitVec.ofInt 1 v5, s134 := BitVec.ofInt 1 v6, s135 := BitVec.ofInt 1 v7, s136 := BitVec.ofInt 1 v8, s137 := BitVec.ofInt 1 v9, s138 := BitVec.ofInt 1 v10, s139 := BitVec.ofInt 1 v11, s140 := BitVec.ofInt 1 v12, s141 := BitVec.ofInt 1 v13, s142 := BitVec.ofInt 1 v14, s143 := BitVec.ofInt 1 v15 }

def decodeStateGroup0Group9 (j : Lean.Json) : Except String StateGroup0Group9 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2966"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2956"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2946"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2936"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2926"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2916"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2906"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2896"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2876"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2866"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2856"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2846"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2836"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2826"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2816"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2806"
  return { s144 := BitVec.ofInt 1 v0, s145 := BitVec.ofInt 1 v1, s146 := BitVec.ofInt 1 v2, s147 := BitVec.ofInt 1 v3, s148 := BitVec.ofInt 1 v4, s149 := BitVec.ofInt 1 v5, s150 := BitVec.ofInt 1 v6, s151 := BitVec.ofInt 1 v7, s152 := BitVec.ofInt 1 v8, s153 := BitVec.ofInt 1 v9, s154 := BitVec.ofInt 1 v10, s155 := BitVec.ofInt 1 v11, s156 := BitVec.ofInt 1 v12, s157 := BitVec.ofInt 1 v13, s158 := BitVec.ofInt 1 v14, s159 := BitVec.ofInt 1 v15 }

def decodeStateGroup0Group10 (j : Lean.Json) : Except String StateGroup0Group10 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2796"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2786"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2766"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2756"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2746"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2736"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2726"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2716"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2706"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2696"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2686"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2676"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2656"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2646"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2636"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2626"
  return { s160 := BitVec.ofInt 1 v0, s161 := BitVec.ofInt 1 v1, s162 := BitVec.ofInt 1 v2, s163 := BitVec.ofInt 1 v3, s164 := BitVec.ofInt 1 v4, s165 := BitVec.ofInt 1 v5, s166 := BitVec.ofInt 1 v6, s167 := BitVec.ofInt 1 v7, s168 := BitVec.ofInt 1 v8, s169 := BitVec.ofInt 1 v9, s170 := BitVec.ofInt 1 v10, s171 := BitVec.ofInt 1 v11, s172 := BitVec.ofInt 1 v12, s173 := BitVec.ofInt 1 v13, s174 := BitVec.ofInt 1 v14, s175 := BitVec.ofInt 1 v15 }

def decodeStateGroup0Group11 (j : Lean.Json) : Except String StateGroup0Group11 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2616"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2606"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2596"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2586"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2576"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2566"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2546"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2536"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2526"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2516"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2506"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2496"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2486"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2476"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2466"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2456"
  return { s176 := BitVec.ofInt 1 v0, s177 := BitVec.ofInt 1 v1, s178 := BitVec.ofInt 1 v2, s179 := BitVec.ofInt 1 v3, s180 := BitVec.ofInt 1 v4, s181 := BitVec.ofInt 1 v5, s182 := BitVec.ofInt 1 v6, s183 := BitVec.ofInt 1 v7, s184 := BitVec.ofInt 1 v8, s185 := BitVec.ofInt 1 v9, s186 := BitVec.ofInt 1 v10, s187 := BitVec.ofInt 1 v11, s188 := BitVec.ofInt 1 v12, s189 := BitVec.ofInt 1 v13, s190 := BitVec.ofInt 1 v14, s191 := BitVec.ofInt 1 v15 }

def decodeStateGroup0Group12 (j : Lean.Json) : Except String StateGroup0Group12 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2436"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2426"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2416"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2406"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2396"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2386"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2376"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2366"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2356"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2346"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2326"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2316"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2306"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2296"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2286"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2276"
  return { s192 := BitVec.ofInt 1 v0, s193 := BitVec.ofInt 1 v1, s194 := BitVec.ofInt 1 v2, s195 := BitVec.ofInt 1 v3, s196 := BitVec.ofInt 1 v4, s197 := BitVec.ofInt 1 v5, s198 := BitVec.ofInt 1 v6, s199 := BitVec.ofInt 1 v7, s200 := BitVec.ofInt 1 v8, s201 := BitVec.ofInt 1 v9, s202 := BitVec.ofInt 1 v10, s203 := BitVec.ofInt 1 v11, s204 := BitVec.ofInt 1 v12, s205 := BitVec.ofInt 1 v13, s206 := BitVec.ofInt 1 v14, s207 := BitVec.ofInt 1 v15 }

def decodeStateGroup0Group13 (j : Lean.Json) : Except String StateGroup0Group13 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2266"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2256"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2246"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2236"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2206"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2196"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2186"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2176"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2166"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2156"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2146"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2136"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2126"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2116"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2096"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2086"
  return { s208 := BitVec.ofInt 1 v0, s209 := BitVec.ofInt 1 v1, s210 := BitVec.ofInt 1 v2, s211 := BitVec.ofInt 1 v3, s212 := BitVec.ofInt 1 v4, s213 := BitVec.ofInt 1 v5, s214 := BitVec.ofInt 1 v6, s215 := BitVec.ofInt 1 v7, s216 := BitVec.ofInt 1 v8, s217 := BitVec.ofInt 1 v9, s218 := BitVec.ofInt 1 v10, s219 := BitVec.ofInt 1 v11, s220 := BitVec.ofInt 1 v12, s221 := BitVec.ofInt 1 v13, s222 := BitVec.ofInt 1 v14, s223 := BitVec.ofInt 1 v15 }

def decodeStateGroup0Group14 (j : Lean.Json) : Except String StateGroup0Group14 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2076"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2066"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2056"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2046"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2036"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2026"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2016"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2006"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1986"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1976"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1966"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1956"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1946"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1936"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1926"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1916"
  return { s224 := BitVec.ofInt 1 v0, s225 := BitVec.ofInt 1 v1, s226 := BitVec.ofInt 1 v2, s227 := BitVec.ofInt 1 v3, s228 := BitVec.ofInt 1 v4, s229 := BitVec.ofInt 1 v5, s230 := BitVec.ofInt 1 v6, s231 := BitVec.ofInt 1 v7, s232 := BitVec.ofInt 1 v8, s233 := BitVec.ofInt 1 v9, s234 := BitVec.ofInt 1 v10, s235 := BitVec.ofInt 1 v11, s236 := BitVec.ofInt 1 v12, s237 := BitVec.ofInt 1 v13, s238 := BitVec.ofInt 1 v14, s239 := BitVec.ofInt 1 v15 }

def decodeStateGroup0Group15 (j : Lean.Json) : Except String StateGroup0Group15 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1906"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1896"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1876"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1866"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1856"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1846"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1836"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1826"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1816"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1806"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1796"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1786"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1766"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1756"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1746"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1736"
  return { s240 := BitVec.ofInt 1 v0, s241 := BitVec.ofInt 1 v1, s242 := BitVec.ofInt 1 v2, s243 := BitVec.ofInt 1 v3, s244 := BitVec.ofInt 1 v4, s245 := BitVec.ofInt 1 v5, s246 := BitVec.ofInt 1 v6, s247 := BitVec.ofInt 1 v7, s248 := BitVec.ofInt 1 v8, s249 := BitVec.ofInt 1 v9, s250 := BitVec.ofInt 1 v10, s251 := BitVec.ofInt 1 v11, s252 := BitVec.ofInt 1 v12, s253 := BitVec.ofInt 1 v13, s254 := BitVec.ofInt 1 v14, s255 := BitVec.ofInt 1 v15 }

def decodeStateGroup0 (j : Lean.Json) : Except String StateGroup0 := do

  let g0 ← decodeStateGroup0Group0 j

  let g1 ← decodeStateGroup0Group1 j

  let g2 ← decodeStateGroup0Group2 j

  let g3 ← decodeStateGroup0Group3 j

  let g4 ← decodeStateGroup0Group4 j

  let g5 ← decodeStateGroup0Group5 j

  let g6 ← decodeStateGroup0Group6 j

  let g7 ← decodeStateGroup0Group7 j

  let g8 ← decodeStateGroup0Group8 j

  let g9 ← decodeStateGroup0Group9 j

  let g10 ← decodeStateGroup0Group10 j

  let g11 ← decodeStateGroup0Group11 j

  let g12 ← decodeStateGroup0Group12 j

  let g13 ← decodeStateGroup0Group13 j

  let g14 ← decodeStateGroup0Group14 j

  let g15 ← decodeStateGroup0Group15 j

  return { g0 := g0, g1 := g1, g2 := g2, g3 := g3, g4 := g4, g5 := g5, g6 := g6, g7 := g7, g8 := g8, g9 := g9, g10 := g10, g11 := g11, g12 := g12, g13 := g13, g14 := g14, g15 := g15 }

def decodeStateGroup1Group0 (j : Lean.Json) : Except String StateGroup1Group0 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1726"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1716"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1706"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1696"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1686"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1676"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1656"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1646"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1636"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1626"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1616"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1606"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1596"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1586"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1576"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1566"
  return { s256 := BitVec.ofInt 1 v0, s257 := BitVec.ofInt 1 v1, s258 := BitVec.ofInt 1 v2, s259 := BitVec.ofInt 1 v3, s260 := BitVec.ofInt 1 v4, s261 := BitVec.ofInt 1 v5, s262 := BitVec.ofInt 1 v6, s263 := BitVec.ofInt 1 v7, s264 := BitVec.ofInt 1 v8, s265 := BitVec.ofInt 1 v9, s266 := BitVec.ofInt 1 v10, s267 := BitVec.ofInt 1 v11, s268 := BitVec.ofInt 1 v12, s269 := BitVec.ofInt 1 v13, s270 := BitVec.ofInt 1 v14, s271 := BitVec.ofInt 1 v15 }

def decodeStateGroup1Group1 (j : Lean.Json) : Except String StateGroup1Group1 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1546"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1536"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1526"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1516"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1506"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1496"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1486"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1476"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1466"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1456"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1436"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1426"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1416"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1406"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1396"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1386"
  return { s272 := BitVec.ofInt 1 v0, s273 := BitVec.ofInt 1 v1, s274 := BitVec.ofInt 1 v2, s275 := BitVec.ofInt 1 v3, s276 := BitVec.ofInt 1 v4, s277 := BitVec.ofInt 1 v5, s278 := BitVec.ofInt 1 v6, s279 := BitVec.ofInt 1 v7, s280 := BitVec.ofInt 1 v8, s281 := BitVec.ofInt 1 v9, s282 := BitVec.ofInt 1 v10, s283 := BitVec.ofInt 1 v11, s284 := BitVec.ofInt 1 v12, s285 := BitVec.ofInt 1 v13, s286 := BitVec.ofInt 1 v14, s287 := BitVec.ofInt 1 v15 }

def decodeStateGroup1Group2 (j : Lean.Json) : Except String StateGroup1Group2 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1376"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1366"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1356"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1346"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1326"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1316"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1306"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1296"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1286"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1276"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1266"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1256"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1246"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1236"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1216"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1206"
  return { s288 := BitVec.ofInt 1 v0, s289 := BitVec.ofInt 1 v1, s290 := BitVec.ofInt 1 v2, s291 := BitVec.ofInt 1 v3, s292 := BitVec.ofInt 1 v4, s293 := BitVec.ofInt 1 v5, s294 := BitVec.ofInt 1 v6, s295 := BitVec.ofInt 1 v7, s296 := BitVec.ofInt 1 v8, s297 := BitVec.ofInt 1 v9, s298 := BitVec.ofInt 1 v10, s299 := BitVec.ofInt 1 v11, s300 := BitVec.ofInt 1 v12, s301 := BitVec.ofInt 1 v13, s302 := BitVec.ofInt 1 v14, s303 := BitVec.ofInt 1 v15 }

def decodeStateGroup1Group3 (j : Lean.Json) : Except String StateGroup1Group3 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1196"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1186"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1176"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1166"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1156"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1146"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1136"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1126"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1096"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1086"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1076"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1066"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1056"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1046"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1036"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1026"
  return { s304 := BitVec.ofInt 1 v0, s305 := BitVec.ofInt 1 v1, s306 := BitVec.ofInt 1 v2, s307 := BitVec.ofInt 1 v3, s308 := BitVec.ofInt 1 v4, s309 := BitVec.ofInt 1 v5, s310 := BitVec.ofInt 1 v6, s311 := BitVec.ofInt 1 v7, s312 := BitVec.ofInt 1 v8, s313 := BitVec.ofInt 1 v9, s314 := BitVec.ofInt 1 v10, s315 := BitVec.ofInt 1 v11, s316 := BitVec.ofInt 1 v12, s317 := BitVec.ofInt 1 v13, s318 := BitVec.ofInt 1 v14, s319 := BitVec.ofInt 1 v15 }

def decodeStateGroup1Group4 (j : Lean.Json) : Except String StateGroup1Group4 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1016"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1006"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$986"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$976"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$966"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$956"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$946"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$936"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$926"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$916"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$906"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$896"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$876"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$866"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$856"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$846"
  return { s320 := BitVec.ofInt 1 v0, s321 := BitVec.ofInt 1 v1, s322 := BitVec.ofInt 1 v2, s323 := BitVec.ofInt 1 v3, s324 := BitVec.ofInt 1 v4, s325 := BitVec.ofInt 1 v5, s326 := BitVec.ofInt 1 v6, s327 := BitVec.ofInt 1 v7, s328 := BitVec.ofInt 1 v8, s329 := BitVec.ofInt 1 v9, s330 := BitVec.ofInt 1 v10, s331 := BitVec.ofInt 1 v11, s332 := BitVec.ofInt 1 v12, s333 := BitVec.ofInt 1 v13, s334 := BitVec.ofInt 1 v14, s335 := BitVec.ofInt 1 v15 }

def decodeStateGroup1Group5 (j : Lean.Json) : Except String StateGroup1Group5 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$836"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$826"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$816"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$806"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$796"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$786"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$766"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$756"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$746"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$736"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$726"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$716"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$706"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$696"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$686"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$676"
  return { s336 := BitVec.ofInt 1 v0, s337 := BitVec.ofInt 1 v1, s338 := BitVec.ofInt 1 v2, s339 := BitVec.ofInt 1 v3, s340 := BitVec.ofInt 1 v4, s341 := BitVec.ofInt 1 v5, s342 := BitVec.ofInt 1 v6, s343 := BitVec.ofInt 1 v7, s344 := BitVec.ofInt 1 v8, s345 := BitVec.ofInt 1 v9, s346 := BitVec.ofInt 1 v10, s347 := BitVec.ofInt 1 v11, s348 := BitVec.ofInt 1 v12, s349 := BitVec.ofInt 1 v13, s350 := BitVec.ofInt 1 v14, s351 := BitVec.ofInt 1 v15 }

def decodeStateGroup1Group6 (j : Lean.Json) : Except String StateGroup1Group6 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$656"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$646"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$636"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$626"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$616"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$606"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$596"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$586"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$576"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$566"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$546"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$536"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$526"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$516"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$506"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$496"
  return { s352 := BitVec.ofInt 1 v0, s353 := BitVec.ofInt 1 v1, s354 := BitVec.ofInt 1 v2, s355 := BitVec.ofInt 1 v3, s356 := BitVec.ofInt 1 v4, s357 := BitVec.ofInt 1 v5, s358 := BitVec.ofInt 1 v6, s359 := BitVec.ofInt 1 v7, s360 := BitVec.ofInt 1 v8, s361 := BitVec.ofInt 1 v9, s362 := BitVec.ofInt 1 v10, s363 := BitVec.ofInt 1 v11, s364 := BitVec.ofInt 1 v12, s365 := BitVec.ofInt 1 v13, s366 := BitVec.ofInt 1 v14, s367 := BitVec.ofInt 1 v15 }

def decodeStateGroup1Group7 (j : Lean.Json) : Except String StateGroup1Group7 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$486"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$476"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$466"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$456"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$436"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$426"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$416"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$406"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$396"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$386"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$376"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$366"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$356"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$346"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$326"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$316"
  return { s368 := BitVec.ofInt 1 v0, s369 := BitVec.ofInt 1 v1, s370 := BitVec.ofInt 1 v2, s371 := BitVec.ofInt 1 v3, s372 := BitVec.ofInt 1 v4, s373 := BitVec.ofInt 1 v5, s374 := BitVec.ofInt 1 v6, s375 := BitVec.ofInt 1 v7, s376 := BitVec.ofInt 1 v8, s377 := BitVec.ofInt 1 v9, s378 := BitVec.ofInt 1 v10, s379 := BitVec.ofInt 1 v11, s380 := BitVec.ofInt 1 v12, s381 := BitVec.ofInt 1 v13, s382 := BitVec.ofInt 1 v14, s383 := BitVec.ofInt 1 v15 }

def decodeStateGroup1Group8 (j : Lean.Json) : Except String StateGroup1Group8 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$306"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$296"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$286"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$276"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$266"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$256"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$246"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$236"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$216"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$206"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$196"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$186"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$176"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$166"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$156"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$146"
  return { s384 := BitVec.ofInt 1 v0, s385 := BitVec.ofInt 1 v1, s386 := BitVec.ofInt 1 v2, s387 := BitVec.ofInt 1 v3, s388 := BitVec.ofInt 1 v4, s389 := BitVec.ofInt 1 v5, s390 := BitVec.ofInt 1 v6, s391 := BitVec.ofInt 1 v7, s392 := BitVec.ofInt 1 v8, s393 := BitVec.ofInt 1 v9, s394 := BitVec.ofInt 1 v10, s395 := BitVec.ofInt 1 v11, s396 := BitVec.ofInt 1 v12, s397 := BitVec.ofInt 1 v13, s398 := BitVec.ofInt 1 v14, s399 := BitVec.ofInt 1 v15 }

def decodeStateGroup1Group9 (j : Lean.Json) : Except String StateGroup1Group9 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$136"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$126"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$106"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$96"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$86"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$76"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$66"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$56"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$46"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$36"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$26"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$16"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$5106"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$5096"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$5086"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$5076"
  return { s400 := BitVec.ofInt 1 v0, s401 := BitVec.ofInt 1 v1, s402 := BitVec.ofInt 1 v2, s403 := BitVec.ofInt 1 v3, s404 := BitVec.ofInt 1 v4, s405 := BitVec.ofInt 1 v5, s406 := BitVec.ofInt 1 v6, s407 := BitVec.ofInt 1 v7, s408 := BitVec.ofInt 1 v8, s409 := BitVec.ofInt 1 v9, s410 := BitVec.ofInt 1 v10, s411 := BitVec.ofInt 1 v11, s412 := BitVec.ofInt 1 v12, s413 := BitVec.ofInt 1 v13, s414 := BitVec.ofInt 1 v14, s415 := BitVec.ofInt 1 v15 }

def decodeStateGroup1Group10 (j : Lean.Json) : Except String StateGroup1Group10 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$5066"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$5056"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$5046"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$5036"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$5026"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$5016"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4996"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4986"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4976"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4966"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4956"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4946"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4936"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4926"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4916"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4906"
  return { s416 := BitVec.ofInt 1 v0, s417 := BitVec.ofInt 1 v1, s418 := BitVec.ofInt 1 v2, s419 := BitVec.ofInt 1 v3, s420 := BitVec.ofInt 1 v4, s421 := BitVec.ofInt 1 v5, s422 := BitVec.ofInt 1 v6, s423 := BitVec.ofInt 1 v7, s424 := BitVec.ofInt 1 v8, s425 := BitVec.ofInt 1 v9, s426 := BitVec.ofInt 1 v10, s427 := BitVec.ofInt 1 v11, s428 := BitVec.ofInt 1 v12, s429 := BitVec.ofInt 1 v13, s430 := BitVec.ofInt 1 v14, s431 := BitVec.ofInt 1 v15 }

def decodeStateGroup1Group11 (j : Lean.Json) : Except String StateGroup1Group11 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4886"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4876"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4866"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4856"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4846"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4836"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4826"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4816"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4806"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4796"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4776"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4766"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4756"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4746"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4736"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4726"
  return { s432 := BitVec.ofInt 1 v0, s433 := BitVec.ofInt 1 v1, s434 := BitVec.ofInt 1 v2, s435 := BitVec.ofInt 1 v3, s436 := BitVec.ofInt 1 v4, s437 := BitVec.ofInt 1 v5, s438 := BitVec.ofInt 1 v6, s439 := BitVec.ofInt 1 v7, s440 := BitVec.ofInt 1 v8, s441 := BitVec.ofInt 1 v9, s442 := BitVec.ofInt 1 v10, s443 := BitVec.ofInt 1 v11, s444 := BitVec.ofInt 1 v12, s445 := BitVec.ofInt 1 v13, s446 := BitVec.ofInt 1 v14, s447 := BitVec.ofInt 1 v15 }

def decodeStateGroup1Group12 (j : Lean.Json) : Except String StateGroup1Group12 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4716"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4706"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4696"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4686"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4666"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4656"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4646"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4636"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4626"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4616"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4606"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4596"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4586"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4556"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4436"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4326"
  return { s448 := BitVec.ofInt 1 v0, s449 := BitVec.ofInt 1 v1, s450 := BitVec.ofInt 1 v2, s451 := BitVec.ofInt 1 v3, s452 := BitVec.ofInt 1 v4, s453 := BitVec.ofInt 1 v5, s454 := BitVec.ofInt 1 v6, s455 := BitVec.ofInt 1 v7, s456 := BitVec.ofInt 1 v8, s457 := BitVec.ofInt 1 v9, s458 := BitVec.ofInt 1 v10, s459 := BitVec.ofInt 1 v11, s460 := BitVec.ofInt 1 v12, s461 := BitVec.ofInt 1 v13, s462 := BitVec.ofInt 1 v14, s463 := BitVec.ofInt 1 v15 }

def decodeStateGroup1Group13 (j : Lean.Json) : Except String StateGroup1Group13 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4216"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4106"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3996"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3886"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3776"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3666"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3556"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3446"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3326"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3216"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3106"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2996"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2886"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2776"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2666"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2556"
  return { s464 := BitVec.ofInt 1 v0, s465 := BitVec.ofInt 1 v1, s466 := BitVec.ofInt 1 v2, s467 := BitVec.ofInt 1 v3, s468 := BitVec.ofInt 1 v4, s469 := BitVec.ofInt 1 v5, s470 := BitVec.ofInt 1 v6, s471 := BitVec.ofInt 1 v7, s472 := BitVec.ofInt 1 v8, s473 := BitVec.ofInt 1 v9, s474 := BitVec.ofInt 1 v10, s475 := BitVec.ofInt 1 v11, s476 := BitVec.ofInt 1 v12, s477 := BitVec.ofInt 1 v13, s478 := BitVec.ofInt 1 v14, s479 := BitVec.ofInt 1 v15 }

def decodeStateGroup1Group14 (j : Lean.Json) : Except String StateGroup1Group14 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2446"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2336"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2216"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2106"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1996"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1886"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1776"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1666"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1556"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1446"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1336"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1226"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1106"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$996"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$886"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$776"
  return { s480 := BitVec.ofInt 1 v0, s481 := BitVec.ofInt 1 v1, s482 := BitVec.ofInt 1 v2, s483 := BitVec.ofInt 1 v3, s484 := BitVec.ofInt 1 v4, s485 := BitVec.ofInt 1 v5, s486 := BitVec.ofInt 1 v6, s487 := BitVec.ofInt 1 v7, s488 := BitVec.ofInt 1 v8, s489 := BitVec.ofInt 1 v9, s490 := BitVec.ofInt 1 v10, s491 := BitVec.ofInt 1 v11, s492 := BitVec.ofInt 1 v12, s493 := BitVec.ofInt 1 v13, s494 := BitVec.ofInt 1 v14, s495 := BitVec.ofInt 1 v15 }

def decodeStateGroup1Group15 (j : Lean.Json) : Except String StateGroup1Group15 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$666"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$556"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$446"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$336"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$226"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$116"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$5116"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$5006"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4896"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4786"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4676"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$4446"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3336"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2226"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1116"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$6"
  return { s496 := BitVec.ofInt 1 v0, s497 := BitVec.ofInt 1 v1, s498 := BitVec.ofInt 1 v2, s499 := BitVec.ofInt 1 v3, s500 := BitVec.ofInt 1 v4, s501 := BitVec.ofInt 1 v5, s502 := BitVec.ofInt 1 v6, s503 := BitVec.ofInt 1 v7, s504 := BitVec.ofInt 1 v8, s505 := BitVec.ofInt 1 v9, s506 := BitVec.ofInt 1 v10, s507 := BitVec.ofInt 1 v11, s508 := BitVec.ofInt 1 v12, s509 := BitVec.ofInt 1 v13, s510 := BitVec.ofInt 1 v14, s511 := BitVec.ofInt 1 v15 }

def decodeStateGroup1 (j : Lean.Json) : Except String StateGroup1 := do

  let g0 ← decodeStateGroup1Group0 j

  let g1 ← decodeStateGroup1Group1 j

  let g2 ← decodeStateGroup1Group2 j

  let g3 ← decodeStateGroup1Group3 j

  let g4 ← decodeStateGroup1Group4 j

  let g5 ← decodeStateGroup1Group5 j

  let g6 ← decodeStateGroup1Group6 j

  let g7 ← decodeStateGroup1Group7 j

  let g8 ← decodeStateGroup1Group8 j

  let g9 ← decodeStateGroup1Group9 j

  let g10 ← decodeStateGroup1Group10 j

  let g11 ← decodeStateGroup1Group11 j

  let g12 ← decodeStateGroup1Group12 j

  let g13 ← decodeStateGroup1Group13 j

  let g14 ← decodeStateGroup1Group14 j

  let g15 ← decodeStateGroup1Group15 j

  return { g0 := g0, g1 := g1, g2 := g2, g3 := g3, g4 := g4, g5 := g5, g6 := g6, g7 := g7, g8 := g8, g9 := g9, g10 := g10, g11 := g11, g12 := g12, g13 := g13, g14 := g14, g15 := g15 }

def decodeStateGroup2Group0 (j : Lean.Json) : Except String StateGroup2Group0 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4574"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4572"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4564"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4562"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4544"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4542"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4534"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4532"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4524"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4522"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4514"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4512"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4504"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4502"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4494"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4492"
  return { s512 := BitVec.ofInt 16 v0, s513 := BitVec.ofInt 16 v1, s514 := BitVec.ofInt 16 v2, s515 := BitVec.ofInt 16 v3, s516 := BitVec.ofInt 16 v4, s517 := BitVec.ofInt 16 v5, s518 := BitVec.ofInt 16 v6, s519 := BitVec.ofInt 16 v7, s520 := BitVec.ofInt 16 v8, s521 := BitVec.ofInt 16 v9, s522 := BitVec.ofInt 16 v10, s523 := BitVec.ofInt 16 v11, s524 := BitVec.ofInt 16 v12, s525 := BitVec.ofInt 16 v13, s526 := BitVec.ofInt 16 v14, s527 := BitVec.ofInt 16 v15 }

def decodeStateGroup2Group1 (j : Lean.Json) : Except String StateGroup2Group1 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4484"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4482"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4474"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4472"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4464"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4462"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4454"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4452"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4424"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4422"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4414"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4412"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4404"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4402"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4394"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4392"
  return { s528 := BitVec.ofInt 16 v0, s529 := BitVec.ofInt 16 v1, s530 := BitVec.ofInt 16 v2, s531 := BitVec.ofInt 16 v3, s532 := BitVec.ofInt 16 v4, s533 := BitVec.ofInt 16 v5, s534 := BitVec.ofInt 16 v6, s535 := BitVec.ofInt 16 v7, s536 := BitVec.ofInt 16 v8, s537 := BitVec.ofInt 16 v9, s538 := BitVec.ofInt 16 v10, s539 := BitVec.ofInt 16 v11, s540 := BitVec.ofInt 16 v12, s541 := BitVec.ofInt 16 v13, s542 := BitVec.ofInt 16 v14, s543 := BitVec.ofInt 16 v15 }

def decodeStateGroup2Group2 (j : Lean.Json) : Except String StateGroup2Group2 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4384"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4382"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4374"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4372"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4364"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4362"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4354"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4352"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4344"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4342"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4334"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4332"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4314"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4312"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4304"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4302"
  return { s544 := BitVec.ofInt 16 v0, s545 := BitVec.ofInt 16 v1, s546 := BitVec.ofInt 16 v2, s547 := BitVec.ofInt 16 v3, s548 := BitVec.ofInt 16 v4, s549 := BitVec.ofInt 16 v5, s550 := BitVec.ofInt 16 v6, s551 := BitVec.ofInt 16 v7, s552 := BitVec.ofInt 16 v8, s553 := BitVec.ofInt 16 v9, s554 := BitVec.ofInt 16 v10, s555 := BitVec.ofInt 16 v11, s556 := BitVec.ofInt 16 v12, s557 := BitVec.ofInt 16 v13, s558 := BitVec.ofInt 16 v14, s559 := BitVec.ofInt 16 v15 }

def decodeStateGroup2Group3 (j : Lean.Json) : Except String StateGroup2Group3 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4294"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4292"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4284"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4282"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4274"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4272"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4264"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4262"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4254"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4252"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4244"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4242"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4234"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4232"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4224"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4222"
  return { s560 := BitVec.ofInt 16 v0, s561 := BitVec.ofInt 16 v1, s562 := BitVec.ofInt 16 v2, s563 := BitVec.ofInt 16 v3, s564 := BitVec.ofInt 16 v4, s565 := BitVec.ofInt 16 v5, s566 := BitVec.ofInt 16 v6, s567 := BitVec.ofInt 16 v7, s568 := BitVec.ofInt 16 v8, s569 := BitVec.ofInt 16 v9, s570 := BitVec.ofInt 16 v10, s571 := BitVec.ofInt 16 v11, s572 := BitVec.ofInt 16 v12, s573 := BitVec.ofInt 16 v13, s574 := BitVec.ofInt 16 v14, s575 := BitVec.ofInt 16 v15 }

def decodeStateGroup2Group4 (j : Lean.Json) : Except String StateGroup2Group4 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4204"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4202"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4194"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4192"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4184"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4182"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4174"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4172"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4164"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4162"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4154"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4152"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4144"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4142"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4134"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4132"
  return { s576 := BitVec.ofInt 16 v0, s577 := BitVec.ofInt 16 v1, s578 := BitVec.ofInt 16 v2, s579 := BitVec.ofInt 16 v3, s580 := BitVec.ofInt 16 v4, s581 := BitVec.ofInt 16 v5, s582 := BitVec.ofInt 16 v6, s583 := BitVec.ofInt 16 v7, s584 := BitVec.ofInt 16 v8, s585 := BitVec.ofInt 16 v9, s586 := BitVec.ofInt 16 v10, s587 := BitVec.ofInt 16 v11, s588 := BitVec.ofInt 16 v12, s589 := BitVec.ofInt 16 v13, s590 := BitVec.ofInt 16 v14, s591 := BitVec.ofInt 16 v15 }

def decodeStateGroup2Group5 (j : Lean.Json) : Except String StateGroup2Group5 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4124"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4122"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4114"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4112"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4094"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4092"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4084"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4082"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4074"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4072"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4064"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4062"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4054"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4052"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4044"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4042"
  return { s592 := BitVec.ofInt 16 v0, s593 := BitVec.ofInt 16 v1, s594 := BitVec.ofInt 16 v2, s595 := BitVec.ofInt 16 v3, s596 := BitVec.ofInt 16 v4, s597 := BitVec.ofInt 16 v5, s598 := BitVec.ofInt 16 v6, s599 := BitVec.ofInt 16 v7, s600 := BitVec.ofInt 16 v8, s601 := BitVec.ofInt 16 v9, s602 := BitVec.ofInt 16 v10, s603 := BitVec.ofInt 16 v11, s604 := BitVec.ofInt 16 v12, s605 := BitVec.ofInt 16 v13, s606 := BitVec.ofInt 16 v14, s607 := BitVec.ofInt 16 v15 }

def decodeStateGroup2Group6 (j : Lean.Json) : Except String StateGroup2Group6 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4034"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4032"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4024"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4022"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4014"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4012"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4004"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4002"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3984"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3982"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3974"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3972"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3964"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3962"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3954"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3952"
  return { s608 := BitVec.ofInt 16 v0, s609 := BitVec.ofInt 16 v1, s610 := BitVec.ofInt 16 v2, s611 := BitVec.ofInt 16 v3, s612 := BitVec.ofInt 16 v4, s613 := BitVec.ofInt 16 v5, s614 := BitVec.ofInt 16 v6, s615 := BitVec.ofInt 16 v7, s616 := BitVec.ofInt 16 v8, s617 := BitVec.ofInt 16 v9, s618 := BitVec.ofInt 16 v10, s619 := BitVec.ofInt 16 v11, s620 := BitVec.ofInt 16 v12, s621 := BitVec.ofInt 16 v13, s622 := BitVec.ofInt 16 v14, s623 := BitVec.ofInt 16 v15 }

def decodeStateGroup2Group7 (j : Lean.Json) : Except String StateGroup2Group7 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3944"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3942"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3934"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3932"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3924"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3922"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3914"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3912"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3904"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3902"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3894"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3892"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3874"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3872"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3864"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3862"
  return { s624 := BitVec.ofInt 16 v0, s625 := BitVec.ofInt 16 v1, s626 := BitVec.ofInt 16 v2, s627 := BitVec.ofInt 16 v3, s628 := BitVec.ofInt 16 v4, s629 := BitVec.ofInt 16 v5, s630 := BitVec.ofInt 16 v6, s631 := BitVec.ofInt 16 v7, s632 := BitVec.ofInt 16 v8, s633 := BitVec.ofInt 16 v9, s634 := BitVec.ofInt 16 v10, s635 := BitVec.ofInt 16 v11, s636 := BitVec.ofInt 16 v12, s637 := BitVec.ofInt 16 v13, s638 := BitVec.ofInt 16 v14, s639 := BitVec.ofInt 16 v15 }

def decodeStateGroup2Group8 (j : Lean.Json) : Except String StateGroup2Group8 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3854"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3852"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3844"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3842"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3834"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3832"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3824"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3822"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3814"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3812"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3804"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3802"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3794"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3792"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3784"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3782"
  return { s640 := BitVec.ofInt 16 v0, s641 := BitVec.ofInt 16 v1, s642 := BitVec.ofInt 16 v2, s643 := BitVec.ofInt 16 v3, s644 := BitVec.ofInt 16 v4, s645 := BitVec.ofInt 16 v5, s646 := BitVec.ofInt 16 v6, s647 := BitVec.ofInt 16 v7, s648 := BitVec.ofInt 16 v8, s649 := BitVec.ofInt 16 v9, s650 := BitVec.ofInt 16 v10, s651 := BitVec.ofInt 16 v11, s652 := BitVec.ofInt 16 v12, s653 := BitVec.ofInt 16 v13, s654 := BitVec.ofInt 16 v14, s655 := BitVec.ofInt 16 v15 }

def decodeStateGroup2Group9 (j : Lean.Json) : Except String StateGroup2Group9 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3764"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3762"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3754"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3752"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3744"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3742"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3734"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3732"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3724"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3722"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3714"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3712"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3704"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3702"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3694"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3692"
  return { s656 := BitVec.ofInt 16 v0, s657 := BitVec.ofInt 16 v1, s658 := BitVec.ofInt 16 v2, s659 := BitVec.ofInt 16 v3, s660 := BitVec.ofInt 16 v4, s661 := BitVec.ofInt 16 v5, s662 := BitVec.ofInt 16 v6, s663 := BitVec.ofInt 16 v7, s664 := BitVec.ofInt 16 v8, s665 := BitVec.ofInt 16 v9, s666 := BitVec.ofInt 16 v10, s667 := BitVec.ofInt 16 v11, s668 := BitVec.ofInt 16 v12, s669 := BitVec.ofInt 16 v13, s670 := BitVec.ofInt 16 v14, s671 := BitVec.ofInt 16 v15 }

def decodeStateGroup2Group10 (j : Lean.Json) : Except String StateGroup2Group10 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3684"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3682"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3674"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3672"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3654"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3652"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3644"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3642"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3634"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3632"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3624"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3622"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3614"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3612"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3604"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3602"
  return { s672 := BitVec.ofInt 16 v0, s673 := BitVec.ofInt 16 v1, s674 := BitVec.ofInt 16 v2, s675 := BitVec.ofInt 16 v3, s676 := BitVec.ofInt 16 v4, s677 := BitVec.ofInt 16 v5, s678 := BitVec.ofInt 16 v6, s679 := BitVec.ofInt 16 v7, s680 := BitVec.ofInt 16 v8, s681 := BitVec.ofInt 16 v9, s682 := BitVec.ofInt 16 v10, s683 := BitVec.ofInt 16 v11, s684 := BitVec.ofInt 16 v12, s685 := BitVec.ofInt 16 v13, s686 := BitVec.ofInt 16 v14, s687 := BitVec.ofInt 16 v15 }

def decodeStateGroup2Group11 (j : Lean.Json) : Except String StateGroup2Group11 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3594"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3592"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3584"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3582"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3574"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3572"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3564"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3562"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3544"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3542"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3534"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3532"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3524"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3522"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3514"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3512"
  return { s688 := BitVec.ofInt 16 v0, s689 := BitVec.ofInt 16 v1, s690 := BitVec.ofInt 16 v2, s691 := BitVec.ofInt 16 v3, s692 := BitVec.ofInt 16 v4, s693 := BitVec.ofInt 16 v5, s694 := BitVec.ofInt 16 v6, s695 := BitVec.ofInt 16 v7, s696 := BitVec.ofInt 16 v8, s697 := BitVec.ofInt 16 v9, s698 := BitVec.ofInt 16 v10, s699 := BitVec.ofInt 16 v11, s700 := BitVec.ofInt 16 v12, s701 := BitVec.ofInt 16 v13, s702 := BitVec.ofInt 16 v14, s703 := BitVec.ofInt 16 v15 }

def decodeStateGroup2Group12 (j : Lean.Json) : Except String StateGroup2Group12 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3504"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3502"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3494"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3492"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3484"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3482"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3474"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3472"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3464"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3462"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3454"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3452"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3434"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3432"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3424"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3422"
  return { s704 := BitVec.ofInt 16 v0, s705 := BitVec.ofInt 16 v1, s706 := BitVec.ofInt 16 v2, s707 := BitVec.ofInt 16 v3, s708 := BitVec.ofInt 16 v4, s709 := BitVec.ofInt 16 v5, s710 := BitVec.ofInt 16 v6, s711 := BitVec.ofInt 16 v7, s712 := BitVec.ofInt 16 v8, s713 := BitVec.ofInt 16 v9, s714 := BitVec.ofInt 16 v10, s715 := BitVec.ofInt 16 v11, s716 := BitVec.ofInt 16 v12, s717 := BitVec.ofInt 16 v13, s718 := BitVec.ofInt 16 v14, s719 := BitVec.ofInt 16 v15 }

def decodeStateGroup2Group13 (j : Lean.Json) : Except String StateGroup2Group13 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3414"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3412"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3404"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3402"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3394"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3392"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3384"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3382"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3374"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3372"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3364"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3362"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3354"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3352"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3344"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3342"
  return { s720 := BitVec.ofInt 16 v0, s721 := BitVec.ofInt 16 v1, s722 := BitVec.ofInt 16 v2, s723 := BitVec.ofInt 16 v3, s724 := BitVec.ofInt 16 v4, s725 := BitVec.ofInt 16 v5, s726 := BitVec.ofInt 16 v6, s727 := BitVec.ofInt 16 v7, s728 := BitVec.ofInt 16 v8, s729 := BitVec.ofInt 16 v9, s730 := BitVec.ofInt 16 v10, s731 := BitVec.ofInt 16 v11, s732 := BitVec.ofInt 16 v12, s733 := BitVec.ofInt 16 v13, s734 := BitVec.ofInt 16 v14, s735 := BitVec.ofInt 16 v15 }

def decodeStateGroup2Group14 (j : Lean.Json) : Except String StateGroup2Group14 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3314"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3312"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3304"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3302"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3294"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3292"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3284"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3282"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3274"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3272"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3264"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3262"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3254"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3252"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3244"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3242"
  return { s736 := BitVec.ofInt 16 v0, s737 := BitVec.ofInt 16 v1, s738 := BitVec.ofInt 16 v2, s739 := BitVec.ofInt 16 v3, s740 := BitVec.ofInt 16 v4, s741 := BitVec.ofInt 16 v5, s742 := BitVec.ofInt 16 v6, s743 := BitVec.ofInt 16 v7, s744 := BitVec.ofInt 16 v8, s745 := BitVec.ofInt 16 v9, s746 := BitVec.ofInt 16 v10, s747 := BitVec.ofInt 16 v11, s748 := BitVec.ofInt 16 v12, s749 := BitVec.ofInt 16 v13, s750 := BitVec.ofInt 16 v14, s751 := BitVec.ofInt 16 v15 }

def decodeStateGroup2Group15 (j : Lean.Json) : Except String StateGroup2Group15 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3234"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3232"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3224"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3222"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3204"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3202"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3194"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3192"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3184"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3182"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3174"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3172"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3164"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3162"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3154"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3152"
  return { s752 := BitVec.ofInt 16 v0, s753 := BitVec.ofInt 16 v1, s754 := BitVec.ofInt 16 v2, s755 := BitVec.ofInt 16 v3, s756 := BitVec.ofInt 16 v4, s757 := BitVec.ofInt 16 v5, s758 := BitVec.ofInt 16 v6, s759 := BitVec.ofInt 16 v7, s760 := BitVec.ofInt 16 v8, s761 := BitVec.ofInt 16 v9, s762 := BitVec.ofInt 16 v10, s763 := BitVec.ofInt 16 v11, s764 := BitVec.ofInt 16 v12, s765 := BitVec.ofInt 16 v13, s766 := BitVec.ofInt 16 v14, s767 := BitVec.ofInt 16 v15 }

def decodeStateGroup2 (j : Lean.Json) : Except String StateGroup2 := do

  let g0 ← decodeStateGroup2Group0 j

  let g1 ← decodeStateGroup2Group1 j

  let g2 ← decodeStateGroup2Group2 j

  let g3 ← decodeStateGroup2Group3 j

  let g4 ← decodeStateGroup2Group4 j

  let g5 ← decodeStateGroup2Group5 j

  let g6 ← decodeStateGroup2Group6 j

  let g7 ← decodeStateGroup2Group7 j

  let g8 ← decodeStateGroup2Group8 j

  let g9 ← decodeStateGroup2Group9 j

  let g10 ← decodeStateGroup2Group10 j

  let g11 ← decodeStateGroup2Group11 j

  let g12 ← decodeStateGroup2Group12 j

  let g13 ← decodeStateGroup2Group13 j

  let g14 ← decodeStateGroup2Group14 j

  let g15 ← decodeStateGroup2Group15 j

  return { g0 := g0, g1 := g1, g2 := g2, g3 := g3, g4 := g4, g5 := g5, g6 := g6, g7 := g7, g8 := g8, g9 := g9, g10 := g10, g11 := g11, g12 := g12, g13 := g13, g14 := g14, g15 := g15 }

def decodeStateGroup3Group0 (j : Lean.Json) : Except String StateGroup3Group0 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3144"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3142"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3134"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3132"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3124"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3122"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3114"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3112"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3094"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3092"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3084"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3082"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3074"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3072"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3064"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3062"
  return { s768 := BitVec.ofInt 16 v0, s769 := BitVec.ofInt 16 v1, s770 := BitVec.ofInt 16 v2, s771 := BitVec.ofInt 16 v3, s772 := BitVec.ofInt 16 v4, s773 := BitVec.ofInt 16 v5, s774 := BitVec.ofInt 16 v6, s775 := BitVec.ofInt 16 v7, s776 := BitVec.ofInt 16 v8, s777 := BitVec.ofInt 16 v9, s778 := BitVec.ofInt 16 v10, s779 := BitVec.ofInt 16 v11, s780 := BitVec.ofInt 16 v12, s781 := BitVec.ofInt 16 v13, s782 := BitVec.ofInt 16 v14, s783 := BitVec.ofInt 16 v15 }

def decodeStateGroup3Group1 (j : Lean.Json) : Except String StateGroup3Group1 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3054"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3052"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3044"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3042"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3034"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3032"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3024"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3022"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3014"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3012"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3004"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3002"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2984"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2982"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2974"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2972"
  return { s784 := BitVec.ofInt 16 v0, s785 := BitVec.ofInt 16 v1, s786 := BitVec.ofInt 16 v2, s787 := BitVec.ofInt 16 v3, s788 := BitVec.ofInt 16 v4, s789 := BitVec.ofInt 16 v5, s790 := BitVec.ofInt 16 v6, s791 := BitVec.ofInt 16 v7, s792 := BitVec.ofInt 16 v8, s793 := BitVec.ofInt 16 v9, s794 := BitVec.ofInt 16 v10, s795 := BitVec.ofInt 16 v11, s796 := BitVec.ofInt 16 v12, s797 := BitVec.ofInt 16 v13, s798 := BitVec.ofInt 16 v14, s799 := BitVec.ofInt 16 v15 }

def decodeStateGroup3Group2 (j : Lean.Json) : Except String StateGroup3Group2 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2964"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2962"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2954"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2952"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2944"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2942"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2934"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2932"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2924"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2922"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2914"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2912"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2904"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2902"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2894"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2892"
  return { s800 := BitVec.ofInt 16 v0, s801 := BitVec.ofInt 16 v1, s802 := BitVec.ofInt 16 v2, s803 := BitVec.ofInt 16 v3, s804 := BitVec.ofInt 16 v4, s805 := BitVec.ofInt 16 v5, s806 := BitVec.ofInt 16 v6, s807 := BitVec.ofInt 16 v7, s808 := BitVec.ofInt 16 v8, s809 := BitVec.ofInt 16 v9, s810 := BitVec.ofInt 16 v10, s811 := BitVec.ofInt 16 v11, s812 := BitVec.ofInt 16 v12, s813 := BitVec.ofInt 16 v13, s814 := BitVec.ofInt 16 v14, s815 := BitVec.ofInt 16 v15 }

def decodeStateGroup3Group3 (j : Lean.Json) : Except String StateGroup3Group3 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2874"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2872"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2864"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2862"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2854"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2852"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2844"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2842"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2834"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2832"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2824"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2822"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2814"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2812"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2804"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2802"
  return { s816 := BitVec.ofInt 16 v0, s817 := BitVec.ofInt 16 v1, s818 := BitVec.ofInt 16 v2, s819 := BitVec.ofInt 16 v3, s820 := BitVec.ofInt 16 v4, s821 := BitVec.ofInt 16 v5, s822 := BitVec.ofInt 16 v6, s823 := BitVec.ofInt 16 v7, s824 := BitVec.ofInt 16 v8, s825 := BitVec.ofInt 16 v9, s826 := BitVec.ofInt 16 v10, s827 := BitVec.ofInt 16 v11, s828 := BitVec.ofInt 16 v12, s829 := BitVec.ofInt 16 v13, s830 := BitVec.ofInt 16 v14, s831 := BitVec.ofInt 16 v15 }

def decodeStateGroup3Group4 (j : Lean.Json) : Except String StateGroup3Group4 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2794"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2792"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2784"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2782"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2764"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2762"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2754"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2752"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2744"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2742"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2734"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2732"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2724"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2722"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2714"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2712"
  return { s832 := BitVec.ofInt 16 v0, s833 := BitVec.ofInt 16 v1, s834 := BitVec.ofInt 16 v2, s835 := BitVec.ofInt 16 v3, s836 := BitVec.ofInt 16 v4, s837 := BitVec.ofInt 16 v5, s838 := BitVec.ofInt 16 v6, s839 := BitVec.ofInt 16 v7, s840 := BitVec.ofInt 16 v8, s841 := BitVec.ofInt 16 v9, s842 := BitVec.ofInt 16 v10, s843 := BitVec.ofInt 16 v11, s844 := BitVec.ofInt 16 v12, s845 := BitVec.ofInt 16 v13, s846 := BitVec.ofInt 16 v14, s847 := BitVec.ofInt 16 v15 }

def decodeStateGroup3Group5 (j : Lean.Json) : Except String StateGroup3Group5 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2704"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2702"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2694"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2692"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2684"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2682"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2674"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2672"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2654"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2652"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2644"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2642"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2634"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2632"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2624"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2622"
  return { s848 := BitVec.ofInt 16 v0, s849 := BitVec.ofInt 16 v1, s850 := BitVec.ofInt 16 v2, s851 := BitVec.ofInt 16 v3, s852 := BitVec.ofInt 16 v4, s853 := BitVec.ofInt 16 v5, s854 := BitVec.ofInt 16 v6, s855 := BitVec.ofInt 16 v7, s856 := BitVec.ofInt 16 v8, s857 := BitVec.ofInt 16 v9, s858 := BitVec.ofInt 16 v10, s859 := BitVec.ofInt 16 v11, s860 := BitVec.ofInt 16 v12, s861 := BitVec.ofInt 16 v13, s862 := BitVec.ofInt 16 v14, s863 := BitVec.ofInt 16 v15 }

def decodeStateGroup3Group6 (j : Lean.Json) : Except String StateGroup3Group6 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2614"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2612"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2604"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2602"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2594"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2592"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2584"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2582"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2574"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2572"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2564"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2562"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2544"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2542"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2534"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2532"
  return { s864 := BitVec.ofInt 16 v0, s865 := BitVec.ofInt 16 v1, s866 := BitVec.ofInt 16 v2, s867 := BitVec.ofInt 16 v3, s868 := BitVec.ofInt 16 v4, s869 := BitVec.ofInt 16 v5, s870 := BitVec.ofInt 16 v6, s871 := BitVec.ofInt 16 v7, s872 := BitVec.ofInt 16 v8, s873 := BitVec.ofInt 16 v9, s874 := BitVec.ofInt 16 v10, s875 := BitVec.ofInt 16 v11, s876 := BitVec.ofInt 16 v12, s877 := BitVec.ofInt 16 v13, s878 := BitVec.ofInt 16 v14, s879 := BitVec.ofInt 16 v15 }

def decodeStateGroup3Group7 (j : Lean.Json) : Except String StateGroup3Group7 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2524"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2522"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2514"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2512"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2504"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2502"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2494"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2492"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2484"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2482"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2474"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2472"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2464"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2462"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2454"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2452"
  return { s880 := BitVec.ofInt 16 v0, s881 := BitVec.ofInt 16 v1, s882 := BitVec.ofInt 16 v2, s883 := BitVec.ofInt 16 v3, s884 := BitVec.ofInt 16 v4, s885 := BitVec.ofInt 16 v5, s886 := BitVec.ofInt 16 v6, s887 := BitVec.ofInt 16 v7, s888 := BitVec.ofInt 16 v8, s889 := BitVec.ofInt 16 v9, s890 := BitVec.ofInt 16 v10, s891 := BitVec.ofInt 16 v11, s892 := BitVec.ofInt 16 v12, s893 := BitVec.ofInt 16 v13, s894 := BitVec.ofInt 16 v14, s895 := BitVec.ofInt 16 v15 }

def decodeStateGroup3Group8 (j : Lean.Json) : Except String StateGroup3Group8 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2434"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2432"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2424"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2422"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2414"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2412"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2404"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2402"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2394"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2392"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2384"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2382"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2374"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2372"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2364"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2362"
  return { s896 := BitVec.ofInt 16 v0, s897 := BitVec.ofInt 16 v1, s898 := BitVec.ofInt 16 v2, s899 := BitVec.ofInt 16 v3, s900 := BitVec.ofInt 16 v4, s901 := BitVec.ofInt 16 v5, s902 := BitVec.ofInt 16 v6, s903 := BitVec.ofInt 16 v7, s904 := BitVec.ofInt 16 v8, s905 := BitVec.ofInt 16 v9, s906 := BitVec.ofInt 16 v10, s907 := BitVec.ofInt 16 v11, s908 := BitVec.ofInt 16 v12, s909 := BitVec.ofInt 16 v13, s910 := BitVec.ofInt 16 v14, s911 := BitVec.ofInt 16 v15 }

def decodeStateGroup3Group9 (j : Lean.Json) : Except String StateGroup3Group9 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2354"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2352"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2344"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2342"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2324"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2322"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2314"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2312"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2304"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2302"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2294"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2292"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2284"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2282"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2274"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2272"
  return { s912 := BitVec.ofInt 16 v0, s913 := BitVec.ofInt 16 v1, s914 := BitVec.ofInt 16 v2, s915 := BitVec.ofInt 16 v3, s916 := BitVec.ofInt 16 v4, s917 := BitVec.ofInt 16 v5, s918 := BitVec.ofInt 16 v6, s919 := BitVec.ofInt 16 v7, s920 := BitVec.ofInt 16 v8, s921 := BitVec.ofInt 16 v9, s922 := BitVec.ofInt 16 v10, s923 := BitVec.ofInt 16 v11, s924 := BitVec.ofInt 16 v12, s925 := BitVec.ofInt 16 v13, s926 := BitVec.ofInt 16 v14, s927 := BitVec.ofInt 16 v15 }

def decodeStateGroup3Group10 (j : Lean.Json) : Except String StateGroup3Group10 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2264"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2262"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2254"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2252"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2244"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2242"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2234"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2232"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2204"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2202"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2194"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2192"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2184"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2182"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2174"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2172"
  return { s928 := BitVec.ofInt 16 v0, s929 := BitVec.ofInt 16 v1, s930 := BitVec.ofInt 16 v2, s931 := BitVec.ofInt 16 v3, s932 := BitVec.ofInt 16 v4, s933 := BitVec.ofInt 16 v5, s934 := BitVec.ofInt 16 v6, s935 := BitVec.ofInt 16 v7, s936 := BitVec.ofInt 16 v8, s937 := BitVec.ofInt 16 v9, s938 := BitVec.ofInt 16 v10, s939 := BitVec.ofInt 16 v11, s940 := BitVec.ofInt 16 v12, s941 := BitVec.ofInt 16 v13, s942 := BitVec.ofInt 16 v14, s943 := BitVec.ofInt 16 v15 }

def decodeStateGroup3Group11 (j : Lean.Json) : Except String StateGroup3Group11 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2164"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2162"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2154"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2152"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2144"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2142"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2134"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2132"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2124"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2122"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2114"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2112"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2094"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2092"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2084"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2082"
  return { s944 := BitVec.ofInt 16 v0, s945 := BitVec.ofInt 16 v1, s946 := BitVec.ofInt 16 v2, s947 := BitVec.ofInt 16 v3, s948 := BitVec.ofInt 16 v4, s949 := BitVec.ofInt 16 v5, s950 := BitVec.ofInt 16 v6, s951 := BitVec.ofInt 16 v7, s952 := BitVec.ofInt 16 v8, s953 := BitVec.ofInt 16 v9, s954 := BitVec.ofInt 16 v10, s955 := BitVec.ofInt 16 v11, s956 := BitVec.ofInt 16 v12, s957 := BitVec.ofInt 16 v13, s958 := BitVec.ofInt 16 v14, s959 := BitVec.ofInt 16 v15 }

def decodeStateGroup3Group12 (j : Lean.Json) : Except String StateGroup3Group12 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2074"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2072"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2064"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2062"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2054"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2052"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2044"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2042"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2034"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2032"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2024"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2022"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2014"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2012"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2004"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2002"
  return { s960 := BitVec.ofInt 16 v0, s961 := BitVec.ofInt 16 v1, s962 := BitVec.ofInt 16 v2, s963 := BitVec.ofInt 16 v3, s964 := BitVec.ofInt 16 v4, s965 := BitVec.ofInt 16 v5, s966 := BitVec.ofInt 16 v6, s967 := BitVec.ofInt 16 v7, s968 := BitVec.ofInt 16 v8, s969 := BitVec.ofInt 16 v9, s970 := BitVec.ofInt 16 v10, s971 := BitVec.ofInt 16 v11, s972 := BitVec.ofInt 16 v12, s973 := BitVec.ofInt 16 v13, s974 := BitVec.ofInt 16 v14, s975 := BitVec.ofInt 16 v15 }

def decodeStateGroup3Group13 (j : Lean.Json) : Except String StateGroup3Group13 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1984"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1982"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1974"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1972"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1964"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1962"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1954"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1952"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1944"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1942"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1934"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1932"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1924"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1922"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1914"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1912"
  return { s976 := BitVec.ofInt 16 v0, s977 := BitVec.ofInt 16 v1, s978 := BitVec.ofInt 16 v2, s979 := BitVec.ofInt 16 v3, s980 := BitVec.ofInt 16 v4, s981 := BitVec.ofInt 16 v5, s982 := BitVec.ofInt 16 v6, s983 := BitVec.ofInt 16 v7, s984 := BitVec.ofInt 16 v8, s985 := BitVec.ofInt 16 v9, s986 := BitVec.ofInt 16 v10, s987 := BitVec.ofInt 16 v11, s988 := BitVec.ofInt 16 v12, s989 := BitVec.ofInt 16 v13, s990 := BitVec.ofInt 16 v14, s991 := BitVec.ofInt 16 v15 }

def decodeStateGroup3Group14 (j : Lean.Json) : Except String StateGroup3Group14 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1904"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1902"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1894"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1892"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1874"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1872"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1864"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1862"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1854"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1852"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1844"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1842"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1834"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1832"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1824"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1822"
  return { s992 := BitVec.ofInt 16 v0, s993 := BitVec.ofInt 16 v1, s994 := BitVec.ofInt 16 v2, s995 := BitVec.ofInt 16 v3, s996 := BitVec.ofInt 16 v4, s997 := BitVec.ofInt 16 v5, s998 := BitVec.ofInt 16 v6, s999 := BitVec.ofInt 16 v7, s1000 := BitVec.ofInt 16 v8, s1001 := BitVec.ofInt 16 v9, s1002 := BitVec.ofInt 16 v10, s1003 := BitVec.ofInt 16 v11, s1004 := BitVec.ofInt 16 v12, s1005 := BitVec.ofInt 16 v13, s1006 := BitVec.ofInt 16 v14, s1007 := BitVec.ofInt 16 v15 }

def decodeStateGroup3Group15 (j : Lean.Json) : Except String StateGroup3Group15 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1814"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1812"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1804"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1802"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1794"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1792"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1784"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1782"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1764"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1762"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1754"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1752"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1744"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1742"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1734"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1732"
  return { s1008 := BitVec.ofInt 16 v0, s1009 := BitVec.ofInt 16 v1, s1010 := BitVec.ofInt 16 v2, s1011 := BitVec.ofInt 16 v3, s1012 := BitVec.ofInt 16 v4, s1013 := BitVec.ofInt 16 v5, s1014 := BitVec.ofInt 16 v6, s1015 := BitVec.ofInt 16 v7, s1016 := BitVec.ofInt 16 v8, s1017 := BitVec.ofInt 16 v9, s1018 := BitVec.ofInt 16 v10, s1019 := BitVec.ofInt 16 v11, s1020 := BitVec.ofInt 16 v12, s1021 := BitVec.ofInt 16 v13, s1022 := BitVec.ofInt 16 v14, s1023 := BitVec.ofInt 16 v15 }

def decodeStateGroup3 (j : Lean.Json) : Except String StateGroup3 := do

  let g0 ← decodeStateGroup3Group0 j

  let g1 ← decodeStateGroup3Group1 j

  let g2 ← decodeStateGroup3Group2 j

  let g3 ← decodeStateGroup3Group3 j

  let g4 ← decodeStateGroup3Group4 j

  let g5 ← decodeStateGroup3Group5 j

  let g6 ← decodeStateGroup3Group6 j

  let g7 ← decodeStateGroup3Group7 j

  let g8 ← decodeStateGroup3Group8 j

  let g9 ← decodeStateGroup3Group9 j

  let g10 ← decodeStateGroup3Group10 j

  let g11 ← decodeStateGroup3Group11 j

  let g12 ← decodeStateGroup3Group12 j

  let g13 ← decodeStateGroup3Group13 j

  let g14 ← decodeStateGroup3Group14 j

  let g15 ← decodeStateGroup3Group15 j

  return { g0 := g0, g1 := g1, g2 := g2, g3 := g3, g4 := g4, g5 := g5, g6 := g6, g7 := g7, g8 := g8, g9 := g9, g10 := g10, g11 := g11, g12 := g12, g13 := g13, g14 := g14, g15 := g15 }

def decodeStateGroup4Group0 (j : Lean.Json) : Except String StateGroup4Group0 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1724"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1722"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1714"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1712"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1704"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1702"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1694"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1692"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1684"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1682"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1674"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1672"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1654"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1652"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1644"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1642"
  return { s1024 := BitVec.ofInt 16 v0, s1025 := BitVec.ofInt 16 v1, s1026 := BitVec.ofInt 16 v2, s1027 := BitVec.ofInt 16 v3, s1028 := BitVec.ofInt 16 v4, s1029 := BitVec.ofInt 16 v5, s1030 := BitVec.ofInt 16 v6, s1031 := BitVec.ofInt 16 v7, s1032 := BitVec.ofInt 16 v8, s1033 := BitVec.ofInt 16 v9, s1034 := BitVec.ofInt 16 v10, s1035 := BitVec.ofInt 16 v11, s1036 := BitVec.ofInt 16 v12, s1037 := BitVec.ofInt 16 v13, s1038 := BitVec.ofInt 16 v14, s1039 := BitVec.ofInt 16 v15 }

def decodeStateGroup4Group1 (j : Lean.Json) : Except String StateGroup4Group1 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1634"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1632"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1624"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1622"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1614"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1612"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1604"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1602"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1594"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1592"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1584"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1582"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1574"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1572"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1564"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1562"
  return { s1040 := BitVec.ofInt 16 v0, s1041 := BitVec.ofInt 16 v1, s1042 := BitVec.ofInt 16 v2, s1043 := BitVec.ofInt 16 v3, s1044 := BitVec.ofInt 16 v4, s1045 := BitVec.ofInt 16 v5, s1046 := BitVec.ofInt 16 v6, s1047 := BitVec.ofInt 16 v7, s1048 := BitVec.ofInt 16 v8, s1049 := BitVec.ofInt 16 v9, s1050 := BitVec.ofInt 16 v10, s1051 := BitVec.ofInt 16 v11, s1052 := BitVec.ofInt 16 v12, s1053 := BitVec.ofInt 16 v13, s1054 := BitVec.ofInt 16 v14, s1055 := BitVec.ofInt 16 v15 }

def decodeStateGroup4Group2 (j : Lean.Json) : Except String StateGroup4Group2 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1544"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1542"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1534"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1532"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1524"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1522"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1514"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1512"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1504"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1502"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1494"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1492"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1484"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1482"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1474"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1472"
  return { s1056 := BitVec.ofInt 16 v0, s1057 := BitVec.ofInt 16 v1, s1058 := BitVec.ofInt 16 v2, s1059 := BitVec.ofInt 16 v3, s1060 := BitVec.ofInt 16 v4, s1061 := BitVec.ofInt 16 v5, s1062 := BitVec.ofInt 16 v6, s1063 := BitVec.ofInt 16 v7, s1064 := BitVec.ofInt 16 v8, s1065 := BitVec.ofInt 16 v9, s1066 := BitVec.ofInt 16 v10, s1067 := BitVec.ofInt 16 v11, s1068 := BitVec.ofInt 16 v12, s1069 := BitVec.ofInt 16 v13, s1070 := BitVec.ofInt 16 v14, s1071 := BitVec.ofInt 16 v15 }

def decodeStateGroup4Group3 (j : Lean.Json) : Except String StateGroup4Group3 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1464"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1462"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1454"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1452"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1434"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1432"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1424"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1422"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1414"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1412"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1404"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1402"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1394"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1392"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1384"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1382"
  return { s1072 := BitVec.ofInt 16 v0, s1073 := BitVec.ofInt 16 v1, s1074 := BitVec.ofInt 16 v2, s1075 := BitVec.ofInt 16 v3, s1076 := BitVec.ofInt 16 v4, s1077 := BitVec.ofInt 16 v5, s1078 := BitVec.ofInt 16 v6, s1079 := BitVec.ofInt 16 v7, s1080 := BitVec.ofInt 16 v8, s1081 := BitVec.ofInt 16 v9, s1082 := BitVec.ofInt 16 v10, s1083 := BitVec.ofInt 16 v11, s1084 := BitVec.ofInt 16 v12, s1085 := BitVec.ofInt 16 v13, s1086 := BitVec.ofInt 16 v14, s1087 := BitVec.ofInt 16 v15 }

def decodeStateGroup4Group4 (j : Lean.Json) : Except String StateGroup4Group4 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1374"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1372"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1364"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1362"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1354"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1352"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1344"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1342"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1324"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1322"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1314"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1312"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1304"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1302"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1294"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1292"
  return { s1088 := BitVec.ofInt 16 v0, s1089 := BitVec.ofInt 16 v1, s1090 := BitVec.ofInt 16 v2, s1091 := BitVec.ofInt 16 v3, s1092 := BitVec.ofInt 16 v4, s1093 := BitVec.ofInt 16 v5, s1094 := BitVec.ofInt 16 v6, s1095 := BitVec.ofInt 16 v7, s1096 := BitVec.ofInt 16 v8, s1097 := BitVec.ofInt 16 v9, s1098 := BitVec.ofInt 16 v10, s1099 := BitVec.ofInt 16 v11, s1100 := BitVec.ofInt 16 v12, s1101 := BitVec.ofInt 16 v13, s1102 := BitVec.ofInt 16 v14, s1103 := BitVec.ofInt 16 v15 }

def decodeStateGroup4Group5 (j : Lean.Json) : Except String StateGroup4Group5 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1284"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1282"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1274"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1272"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1264"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1262"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1254"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1252"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1244"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1242"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1234"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1232"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1214"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1212"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1204"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1202"
  return { s1104 := BitVec.ofInt 16 v0, s1105 := BitVec.ofInt 16 v1, s1106 := BitVec.ofInt 16 v2, s1107 := BitVec.ofInt 16 v3, s1108 := BitVec.ofInt 16 v4, s1109 := BitVec.ofInt 16 v5, s1110 := BitVec.ofInt 16 v6, s1111 := BitVec.ofInt 16 v7, s1112 := BitVec.ofInt 16 v8, s1113 := BitVec.ofInt 16 v9, s1114 := BitVec.ofInt 16 v10, s1115 := BitVec.ofInt 16 v11, s1116 := BitVec.ofInt 16 v12, s1117 := BitVec.ofInt 16 v13, s1118 := BitVec.ofInt 16 v14, s1119 := BitVec.ofInt 16 v15 }

def decodeStateGroup4Group6 (j : Lean.Json) : Except String StateGroup4Group6 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1194"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1192"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1184"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1182"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1174"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1172"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1164"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1162"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1154"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1152"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1144"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1142"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1134"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1132"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1124"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1122"
  return { s1120 := BitVec.ofInt 16 v0, s1121 := BitVec.ofInt 16 v1, s1122 := BitVec.ofInt 16 v2, s1123 := BitVec.ofInt 16 v3, s1124 := BitVec.ofInt 16 v4, s1125 := BitVec.ofInt 16 v5, s1126 := BitVec.ofInt 16 v6, s1127 := BitVec.ofInt 16 v7, s1128 := BitVec.ofInt 16 v8, s1129 := BitVec.ofInt 16 v9, s1130 := BitVec.ofInt 16 v10, s1131 := BitVec.ofInt 16 v11, s1132 := BitVec.ofInt 16 v12, s1133 := BitVec.ofInt 16 v13, s1134 := BitVec.ofInt 16 v14, s1135 := BitVec.ofInt 16 v15 }

def decodeStateGroup4Group7 (j : Lean.Json) : Except String StateGroup4Group7 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1094"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1092"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1084"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1082"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1074"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1072"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1064"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1062"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1054"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1052"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1044"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1042"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1034"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1032"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1024"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1022"
  return { s1136 := BitVec.ofInt 16 v0, s1137 := BitVec.ofInt 16 v1, s1138 := BitVec.ofInt 16 v2, s1139 := BitVec.ofInt 16 v3, s1140 := BitVec.ofInt 16 v4, s1141 := BitVec.ofInt 16 v5, s1142 := BitVec.ofInt 16 v6, s1143 := BitVec.ofInt 16 v7, s1144 := BitVec.ofInt 16 v8, s1145 := BitVec.ofInt 16 v9, s1146 := BitVec.ofInt 16 v10, s1147 := BitVec.ofInt 16 v11, s1148 := BitVec.ofInt 16 v12, s1149 := BitVec.ofInt 16 v13, s1150 := BitVec.ofInt 16 v14, s1151 := BitVec.ofInt 16 v15 }

def decodeStateGroup4Group8 (j : Lean.Json) : Except String StateGroup4Group8 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1014"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1012"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1004"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1002"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$984"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$982"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$974"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$972"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$964"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$962"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$954"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$952"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$944"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$942"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$934"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$932"
  return { s1152 := BitVec.ofInt 16 v0, s1153 := BitVec.ofInt 16 v1, s1154 := BitVec.ofInt 16 v2, s1155 := BitVec.ofInt 16 v3, s1156 := BitVec.ofInt 16 v4, s1157 := BitVec.ofInt 16 v5, s1158 := BitVec.ofInt 16 v6, s1159 := BitVec.ofInt 16 v7, s1160 := BitVec.ofInt 16 v8, s1161 := BitVec.ofInt 16 v9, s1162 := BitVec.ofInt 16 v10, s1163 := BitVec.ofInt 16 v11, s1164 := BitVec.ofInt 16 v12, s1165 := BitVec.ofInt 16 v13, s1166 := BitVec.ofInt 16 v14, s1167 := BitVec.ofInt 16 v15 }

def decodeStateGroup4Group9 (j : Lean.Json) : Except String StateGroup4Group9 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$924"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$922"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$914"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$912"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$904"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$902"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$894"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$892"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$874"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$872"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$864"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$862"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$854"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$852"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$844"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$842"
  return { s1168 := BitVec.ofInt 16 v0, s1169 := BitVec.ofInt 16 v1, s1170 := BitVec.ofInt 16 v2, s1171 := BitVec.ofInt 16 v3, s1172 := BitVec.ofInt 16 v4, s1173 := BitVec.ofInt 16 v5, s1174 := BitVec.ofInt 16 v6, s1175 := BitVec.ofInt 16 v7, s1176 := BitVec.ofInt 16 v8, s1177 := BitVec.ofInt 16 v9, s1178 := BitVec.ofInt 16 v10, s1179 := BitVec.ofInt 16 v11, s1180 := BitVec.ofInt 16 v12, s1181 := BitVec.ofInt 16 v13, s1182 := BitVec.ofInt 16 v14, s1183 := BitVec.ofInt 16 v15 }

def decodeStateGroup4Group10 (j : Lean.Json) : Except String StateGroup4Group10 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$834"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$832"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$824"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$822"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$814"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$812"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$804"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$802"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$794"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$792"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$784"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$782"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$764"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$762"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$754"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$752"
  return { s1184 := BitVec.ofInt 16 v0, s1185 := BitVec.ofInt 16 v1, s1186 := BitVec.ofInt 16 v2, s1187 := BitVec.ofInt 16 v3, s1188 := BitVec.ofInt 16 v4, s1189 := BitVec.ofInt 16 v5, s1190 := BitVec.ofInt 16 v6, s1191 := BitVec.ofInt 16 v7, s1192 := BitVec.ofInt 16 v8, s1193 := BitVec.ofInt 16 v9, s1194 := BitVec.ofInt 16 v10, s1195 := BitVec.ofInt 16 v11, s1196 := BitVec.ofInt 16 v12, s1197 := BitVec.ofInt 16 v13, s1198 := BitVec.ofInt 16 v14, s1199 := BitVec.ofInt 16 v15 }

def decodeStateGroup4Group11 (j : Lean.Json) : Except String StateGroup4Group11 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$744"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$742"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$734"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$732"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$724"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$722"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$714"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$712"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$704"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$702"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$694"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$692"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$684"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$682"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$674"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$672"
  return { s1200 := BitVec.ofInt 16 v0, s1201 := BitVec.ofInt 16 v1, s1202 := BitVec.ofInt 16 v2, s1203 := BitVec.ofInt 16 v3, s1204 := BitVec.ofInt 16 v4, s1205 := BitVec.ofInt 16 v5, s1206 := BitVec.ofInt 16 v6, s1207 := BitVec.ofInt 16 v7, s1208 := BitVec.ofInt 16 v8, s1209 := BitVec.ofInt 16 v9, s1210 := BitVec.ofInt 16 v10, s1211 := BitVec.ofInt 16 v11, s1212 := BitVec.ofInt 16 v12, s1213 := BitVec.ofInt 16 v13, s1214 := BitVec.ofInt 16 v14, s1215 := BitVec.ofInt 16 v15 }

def decodeStateGroup4Group12 (j : Lean.Json) : Except String StateGroup4Group12 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$654"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$652"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$644"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$642"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$634"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$632"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$624"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$622"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$614"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$612"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$604"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$602"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$594"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$592"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$584"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$582"
  return { s1216 := BitVec.ofInt 16 v0, s1217 := BitVec.ofInt 16 v1, s1218 := BitVec.ofInt 16 v2, s1219 := BitVec.ofInt 16 v3, s1220 := BitVec.ofInt 16 v4, s1221 := BitVec.ofInt 16 v5, s1222 := BitVec.ofInt 16 v6, s1223 := BitVec.ofInt 16 v7, s1224 := BitVec.ofInt 16 v8, s1225 := BitVec.ofInt 16 v9, s1226 := BitVec.ofInt 16 v10, s1227 := BitVec.ofInt 16 v11, s1228 := BitVec.ofInt 16 v12, s1229 := BitVec.ofInt 16 v13, s1230 := BitVec.ofInt 16 v14, s1231 := BitVec.ofInt 16 v15 }

def decodeStateGroup4Group13 (j : Lean.Json) : Except String StateGroup4Group13 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$574"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$572"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$564"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$562"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$544"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$542"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$534"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$532"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$524"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$522"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$514"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$512"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$504"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$502"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$494"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$492"
  return { s1232 := BitVec.ofInt 16 v0, s1233 := BitVec.ofInt 16 v1, s1234 := BitVec.ofInt 16 v2, s1235 := BitVec.ofInt 16 v3, s1236 := BitVec.ofInt 16 v4, s1237 := BitVec.ofInt 16 v5, s1238 := BitVec.ofInt 16 v6, s1239 := BitVec.ofInt 16 v7, s1240 := BitVec.ofInt 16 v8, s1241 := BitVec.ofInt 16 v9, s1242 := BitVec.ofInt 16 v10, s1243 := BitVec.ofInt 16 v11, s1244 := BitVec.ofInt 16 v12, s1245 := BitVec.ofInt 16 v13, s1246 := BitVec.ofInt 16 v14, s1247 := BitVec.ofInt 16 v15 }

def decodeStateGroup4Group14 (j : Lean.Json) : Except String StateGroup4Group14 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$484"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$482"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$474"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$472"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$464"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$462"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$454"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$452"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$434"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$432"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$424"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$422"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$414"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$412"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$404"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$402"
  return { s1248 := BitVec.ofInt 16 v0, s1249 := BitVec.ofInt 16 v1, s1250 := BitVec.ofInt 16 v2, s1251 := BitVec.ofInt 16 v3, s1252 := BitVec.ofInt 16 v4, s1253 := BitVec.ofInt 16 v5, s1254 := BitVec.ofInt 16 v6, s1255 := BitVec.ofInt 16 v7, s1256 := BitVec.ofInt 16 v8, s1257 := BitVec.ofInt 16 v9, s1258 := BitVec.ofInt 16 v10, s1259 := BitVec.ofInt 16 v11, s1260 := BitVec.ofInt 16 v12, s1261 := BitVec.ofInt 16 v13, s1262 := BitVec.ofInt 16 v14, s1263 := BitVec.ofInt 16 v15 }

def decodeStateGroup4Group15 (j : Lean.Json) : Except String StateGroup4Group15 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$394"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$392"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$384"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$382"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$374"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$372"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$364"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$362"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$354"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$352"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$344"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$342"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$324"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$322"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$314"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$312"
  return { s1264 := BitVec.ofInt 16 v0, s1265 := BitVec.ofInt 16 v1, s1266 := BitVec.ofInt 16 v2, s1267 := BitVec.ofInt 16 v3, s1268 := BitVec.ofInt 16 v4, s1269 := BitVec.ofInt 16 v5, s1270 := BitVec.ofInt 16 v6, s1271 := BitVec.ofInt 16 v7, s1272 := BitVec.ofInt 16 v8, s1273 := BitVec.ofInt 16 v9, s1274 := BitVec.ofInt 16 v10, s1275 := BitVec.ofInt 16 v11, s1276 := BitVec.ofInt 16 v12, s1277 := BitVec.ofInt 16 v13, s1278 := BitVec.ofInt 16 v14, s1279 := BitVec.ofInt 16 v15 }

def decodeStateGroup4 (j : Lean.Json) : Except String StateGroup4 := do

  let g0 ← decodeStateGroup4Group0 j

  let g1 ← decodeStateGroup4Group1 j

  let g2 ← decodeStateGroup4Group2 j

  let g3 ← decodeStateGroup4Group3 j

  let g4 ← decodeStateGroup4Group4 j

  let g5 ← decodeStateGroup4Group5 j

  let g6 ← decodeStateGroup4Group6 j

  let g7 ← decodeStateGroup4Group7 j

  let g8 ← decodeStateGroup4Group8 j

  let g9 ← decodeStateGroup4Group9 j

  let g10 ← decodeStateGroup4Group10 j

  let g11 ← decodeStateGroup4Group11 j

  let g12 ← decodeStateGroup4Group12 j

  let g13 ← decodeStateGroup4Group13 j

  let g14 ← decodeStateGroup4Group14 j

  let g15 ← decodeStateGroup4Group15 j

  return { g0 := g0, g1 := g1, g2 := g2, g3 := g3, g4 := g4, g5 := g5, g6 := g6, g7 := g7, g8 := g8, g9 := g9, g10 := g10, g11 := g11, g12 := g12, g13 := g13, g14 := g14, g15 := g15 }

def decodeStateGroup5Group0 (j : Lean.Json) : Except String StateGroup5Group0 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$304"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$302"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$294"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$292"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$284"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$282"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$274"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$272"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$264"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$262"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$254"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$252"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$244"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$242"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$234"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$232"
  return { s1280 := BitVec.ofInt 16 v0, s1281 := BitVec.ofInt 16 v1, s1282 := BitVec.ofInt 16 v2, s1283 := BitVec.ofInt 16 v3, s1284 := BitVec.ofInt 16 v4, s1285 := BitVec.ofInt 16 v5, s1286 := BitVec.ofInt 16 v6, s1287 := BitVec.ofInt 16 v7, s1288 := BitVec.ofInt 16 v8, s1289 := BitVec.ofInt 16 v9, s1290 := BitVec.ofInt 16 v10, s1291 := BitVec.ofInt 16 v11, s1292 := BitVec.ofInt 16 v12, s1293 := BitVec.ofInt 16 v13, s1294 := BitVec.ofInt 16 v14, s1295 := BitVec.ofInt 16 v15 }

def decodeStateGroup5Group1 (j : Lean.Json) : Except String StateGroup5Group1 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$214"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$212"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$204"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$202"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$194"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$192"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$184"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$182"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$174"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$172"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$164"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$162"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$154"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$152"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$144"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$142"
  return { s1296 := BitVec.ofInt 16 v0, s1297 := BitVec.ofInt 16 v1, s1298 := BitVec.ofInt 16 v2, s1299 := BitVec.ofInt 16 v3, s1300 := BitVec.ofInt 16 v4, s1301 := BitVec.ofInt 16 v5, s1302 := BitVec.ofInt 16 v6, s1303 := BitVec.ofInt 16 v7, s1304 := BitVec.ofInt 16 v8, s1305 := BitVec.ofInt 16 v9, s1306 := BitVec.ofInt 16 v10, s1307 := BitVec.ofInt 16 v11, s1308 := BitVec.ofInt 16 v12, s1309 := BitVec.ofInt 16 v13, s1310 := BitVec.ofInt 16 v14, s1311 := BitVec.ofInt 16 v15 }

def decodeStateGroup5Group2 (j : Lean.Json) : Except String StateGroup5Group2 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$134"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$132"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$124"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$122"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$104"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$102"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$94"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$92"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$84"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$82"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$74"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$72"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$64"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$62"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$54"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$52"
  return { s1312 := BitVec.ofInt 16 v0, s1313 := BitVec.ofInt 16 v1, s1314 := BitVec.ofInt 16 v2, s1315 := BitVec.ofInt 16 v3, s1316 := BitVec.ofInt 16 v4, s1317 := BitVec.ofInt 16 v5, s1318 := BitVec.ofInt 16 v6, s1319 := BitVec.ofInt 16 v7, s1320 := BitVec.ofInt 16 v8, s1321 := BitVec.ofInt 16 v9, s1322 := BitVec.ofInt 16 v10, s1323 := BitVec.ofInt 16 v11, s1324 := BitVec.ofInt 16 v12, s1325 := BitVec.ofInt 16 v13, s1326 := BitVec.ofInt 16 v14, s1327 := BitVec.ofInt 16 v15 }

def decodeStateGroup5Group3 (j : Lean.Json) : Except String StateGroup5Group3 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$44"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$42"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$34"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$32"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$24"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$22"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$14"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$12"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$5104"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$5102"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$5094"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$5092"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$5084"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$5082"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$5074"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$5072"
  return { s1328 := BitVec.ofInt 16 v0, s1329 := BitVec.ofInt 16 v1, s1330 := BitVec.ofInt 16 v2, s1331 := BitVec.ofInt 16 v3, s1332 := BitVec.ofInt 16 v4, s1333 := BitVec.ofInt 16 v5, s1334 := BitVec.ofInt 16 v6, s1335 := BitVec.ofInt 16 v7, s1336 := BitVec.ofInt 16 v8, s1337 := BitVec.ofInt 16 v9, s1338 := BitVec.ofInt 16 v10, s1339 := BitVec.ofInt 16 v11, s1340 := BitVec.ofInt 16 v12, s1341 := BitVec.ofInt 16 v13, s1342 := BitVec.ofInt 16 v14, s1343 := BitVec.ofInt 16 v15 }

def decodeStateGroup5Group4 (j : Lean.Json) : Except String StateGroup5Group4 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$5064"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$5062"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$5054"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$5052"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$5044"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$5042"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$5034"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$5032"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$5024"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$5022"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$5014"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$5012"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4994"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4992"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4984"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4982"
  return { s1344 := BitVec.ofInt 16 v0, s1345 := BitVec.ofInt 16 v1, s1346 := BitVec.ofInt 16 v2, s1347 := BitVec.ofInt 16 v3, s1348 := BitVec.ofInt 16 v4, s1349 := BitVec.ofInt 16 v5, s1350 := BitVec.ofInt 16 v6, s1351 := BitVec.ofInt 16 v7, s1352 := BitVec.ofInt 16 v8, s1353 := BitVec.ofInt 16 v9, s1354 := BitVec.ofInt 16 v10, s1355 := BitVec.ofInt 16 v11, s1356 := BitVec.ofInt 16 v12, s1357 := BitVec.ofInt 16 v13, s1358 := BitVec.ofInt 16 v14, s1359 := BitVec.ofInt 16 v15 }

def decodeStateGroup5Group5 (j : Lean.Json) : Except String StateGroup5Group5 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4974"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4972"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4964"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4962"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4954"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4952"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4944"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4942"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4934"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4932"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4924"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4922"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4914"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4912"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4904"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4902"
  return { s1360 := BitVec.ofInt 16 v0, s1361 := BitVec.ofInt 16 v1, s1362 := BitVec.ofInt 16 v2, s1363 := BitVec.ofInt 16 v3, s1364 := BitVec.ofInt 16 v4, s1365 := BitVec.ofInt 16 v5, s1366 := BitVec.ofInt 16 v6, s1367 := BitVec.ofInt 16 v7, s1368 := BitVec.ofInt 16 v8, s1369 := BitVec.ofInt 16 v9, s1370 := BitVec.ofInt 16 v10, s1371 := BitVec.ofInt 16 v11, s1372 := BitVec.ofInt 16 v12, s1373 := BitVec.ofInt 16 v13, s1374 := BitVec.ofInt 16 v14, s1375 := BitVec.ofInt 16 v15 }

def decodeStateGroup5Group6 (j : Lean.Json) : Except String StateGroup5Group6 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4884"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4882"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4874"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4872"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4864"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4862"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4854"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4852"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4844"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4842"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4834"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4832"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4824"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4822"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4814"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4812"
  return { s1376 := BitVec.ofInt 16 v0, s1377 := BitVec.ofInt 16 v1, s1378 := BitVec.ofInt 16 v2, s1379 := BitVec.ofInt 16 v3, s1380 := BitVec.ofInt 16 v4, s1381 := BitVec.ofInt 16 v5, s1382 := BitVec.ofInt 16 v6, s1383 := BitVec.ofInt 16 v7, s1384 := BitVec.ofInt 16 v8, s1385 := BitVec.ofInt 16 v9, s1386 := BitVec.ofInt 16 v10, s1387 := BitVec.ofInt 16 v11, s1388 := BitVec.ofInt 16 v12, s1389 := BitVec.ofInt 16 v13, s1390 := BitVec.ofInt 16 v14, s1391 := BitVec.ofInt 16 v15 }

def decodeStateGroup5Group7 (j : Lean.Json) : Except String StateGroup5Group7 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4804"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4802"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4794"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4792"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4774"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4772"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4764"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4762"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4754"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4752"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4744"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4742"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4734"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4732"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4724"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4722"
  return { s1392 := BitVec.ofInt 16 v0, s1393 := BitVec.ofInt 16 v1, s1394 := BitVec.ofInt 16 v2, s1395 := BitVec.ofInt 16 v3, s1396 := BitVec.ofInt 16 v4, s1397 := BitVec.ofInt 16 v5, s1398 := BitVec.ofInt 16 v6, s1399 := BitVec.ofInt 16 v7, s1400 := BitVec.ofInt 16 v8, s1401 := BitVec.ofInt 16 v9, s1402 := BitVec.ofInt 16 v10, s1403 := BitVec.ofInt 16 v11, s1404 := BitVec.ofInt 16 v12, s1405 := BitVec.ofInt 16 v13, s1406 := BitVec.ofInt 16 v14, s1407 := BitVec.ofInt 16 v15 }

def decodeStateGroup5Group8 (j : Lean.Json) : Except String StateGroup5Group8 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4714"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4712"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4704"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4702"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4694"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4692"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4684"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4682"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4664"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4662"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4654"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4652"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4644"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4642"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4634"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4632"
  return { s1408 := BitVec.ofInt 16 v0, s1409 := BitVec.ofInt 16 v1, s1410 := BitVec.ofInt 16 v2, s1411 := BitVec.ofInt 16 v3, s1412 := BitVec.ofInt 16 v4, s1413 := BitVec.ofInt 16 v5, s1414 := BitVec.ofInt 16 v6, s1415 := BitVec.ofInt 16 v7, s1416 := BitVec.ofInt 16 v8, s1417 := BitVec.ofInt 16 v9, s1418 := BitVec.ofInt 16 v10, s1419 := BitVec.ofInt 16 v11, s1420 := BitVec.ofInt 16 v12, s1421 := BitVec.ofInt 16 v13, s1422 := BitVec.ofInt 16 v14, s1423 := BitVec.ofInt 16 v15 }

def decodeStateGroup5Group9 (j : Lean.Json) : Except String StateGroup5Group9 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4624"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4622"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4614"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4612"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4604"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4602"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4594"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4592"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4584"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4582"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4554"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4552"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4434"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4432"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4324"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4322"
  return { s1424 := BitVec.ofInt 16 v0, s1425 := BitVec.ofInt 16 v1, s1426 := BitVec.ofInt 16 v2, s1427 := BitVec.ofInt 16 v3, s1428 := BitVec.ofInt 16 v4, s1429 := BitVec.ofInt 16 v5, s1430 := BitVec.ofInt 16 v6, s1431 := BitVec.ofInt 16 v7, s1432 := BitVec.ofInt 16 v8, s1433 := BitVec.ofInt 16 v9, s1434 := BitVec.ofInt 16 v10, s1435 := BitVec.ofInt 16 v11, s1436 := BitVec.ofInt 16 v12, s1437 := BitVec.ofInt 16 v13, s1438 := BitVec.ofInt 16 v14, s1439 := BitVec.ofInt 16 v15 }

def decodeStateGroup5Group10 (j : Lean.Json) : Except String StateGroup5Group10 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4214"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4212"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4104"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4102"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3994"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3992"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3884"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3882"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3774"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3772"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3664"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3662"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3554"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3552"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3444"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3442"
  return { s1440 := BitVec.ofInt 16 v0, s1441 := BitVec.ofInt 16 v1, s1442 := BitVec.ofInt 16 v2, s1443 := BitVec.ofInt 16 v3, s1444 := BitVec.ofInt 16 v4, s1445 := BitVec.ofInt 16 v5, s1446 := BitVec.ofInt 16 v6, s1447 := BitVec.ofInt 16 v7, s1448 := BitVec.ofInt 16 v8, s1449 := BitVec.ofInt 16 v9, s1450 := BitVec.ofInt 16 v10, s1451 := BitVec.ofInt 16 v11, s1452 := BitVec.ofInt 16 v12, s1453 := BitVec.ofInt 16 v13, s1454 := BitVec.ofInt 16 v14, s1455 := BitVec.ofInt 16 v15 }

def decodeStateGroup5Group11 (j : Lean.Json) : Except String StateGroup5Group11 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3324"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3322"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3214"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3212"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3104"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3102"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2994"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2992"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2884"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2882"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2774"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2772"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2664"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2662"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2554"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2552"
  return { s1456 := BitVec.ofInt 16 v0, s1457 := BitVec.ofInt 16 v1, s1458 := BitVec.ofInt 16 v2, s1459 := BitVec.ofInt 16 v3, s1460 := BitVec.ofInt 16 v4, s1461 := BitVec.ofInt 16 v5, s1462 := BitVec.ofInt 16 v6, s1463 := BitVec.ofInt 16 v7, s1464 := BitVec.ofInt 16 v8, s1465 := BitVec.ofInt 16 v9, s1466 := BitVec.ofInt 16 v10, s1467 := BitVec.ofInt 16 v11, s1468 := BitVec.ofInt 16 v12, s1469 := BitVec.ofInt 16 v13, s1470 := BitVec.ofInt 16 v14, s1471 := BitVec.ofInt 16 v15 }

def decodeStateGroup5Group12 (j : Lean.Json) : Except String StateGroup5Group12 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2444"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2442"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2334"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2332"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2214"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2212"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2104"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2102"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1994"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1992"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1884"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1882"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1774"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1772"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1664"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1662"
  return { s1472 := BitVec.ofInt 16 v0, s1473 := BitVec.ofInt 16 v1, s1474 := BitVec.ofInt 16 v2, s1475 := BitVec.ofInt 16 v3, s1476 := BitVec.ofInt 16 v4, s1477 := BitVec.ofInt 16 v5, s1478 := BitVec.ofInt 16 v6, s1479 := BitVec.ofInt 16 v7, s1480 := BitVec.ofInt 16 v8, s1481 := BitVec.ofInt 16 v9, s1482 := BitVec.ofInt 16 v10, s1483 := BitVec.ofInt 16 v11, s1484 := BitVec.ofInt 16 v12, s1485 := BitVec.ofInt 16 v13, s1486 := BitVec.ofInt 16 v14, s1487 := BitVec.ofInt 16 v15 }

def decodeStateGroup5Group13 (j : Lean.Json) : Except String StateGroup5Group13 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1554"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1552"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1444"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1442"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1334"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1332"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1224"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1222"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1104"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1102"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$994"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$992"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$884"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$882"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$774"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$772"
  return { s1488 := BitVec.ofInt 16 v0, s1489 := BitVec.ofInt 16 v1, s1490 := BitVec.ofInt 16 v2, s1491 := BitVec.ofInt 16 v3, s1492 := BitVec.ofInt 16 v4, s1493 := BitVec.ofInt 16 v5, s1494 := BitVec.ofInt 16 v6, s1495 := BitVec.ofInt 16 v7, s1496 := BitVec.ofInt 16 v8, s1497 := BitVec.ofInt 16 v9, s1498 := BitVec.ofInt 16 v10, s1499 := BitVec.ofInt 16 v11, s1500 := BitVec.ofInt 16 v12, s1501 := BitVec.ofInt 16 v13, s1502 := BitVec.ofInt 16 v14, s1503 := BitVec.ofInt 16 v15 }

def decodeStateGroup5Group14 (j : Lean.Json) : Except String StateGroup5Group14 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$664"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$662"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$554"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$552"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$444"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$442"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$334"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$332"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$224"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$222"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$114"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$112"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$5114"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$5112"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$5004"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$5002"
  return { s1504 := BitVec.ofInt 16 v0, s1505 := BitVec.ofInt 16 v1, s1506 := BitVec.ofInt 16 v2, s1507 := BitVec.ofInt 16 v3, s1508 := BitVec.ofInt 16 v4, s1509 := BitVec.ofInt 16 v5, s1510 := BitVec.ofInt 16 v6, s1511 := BitVec.ofInt 16 v7, s1512 := BitVec.ofInt 16 v8, s1513 := BitVec.ofInt 16 v9, s1514 := BitVec.ofInt 16 v10, s1515 := BitVec.ofInt 16 v11, s1516 := BitVec.ofInt 16 v12, s1517 := BitVec.ofInt 16 v13, s1518 := BitVec.ofInt 16 v14, s1519 := BitVec.ofInt 16 v15 }

def decodeStateGroup5Group15 (j : Lean.Json) : Except String StateGroup5Group15 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4894"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4892"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4784"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4782"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4674"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4672"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4444"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4442"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3334"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3332"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2224"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2222"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1114"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1112"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$4"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2"
  return { s1520 := BitVec.ofInt 16 v0, s1521 := BitVec.ofInt 16 v1, s1522 := BitVec.ofInt 16 v2, s1523 := BitVec.ofInt 16 v3, s1524 := BitVec.ofInt 16 v4, s1525 := BitVec.ofInt 16 v5, s1526 := BitVec.ofInt 16 v6, s1527 := BitVec.ofInt 16 v7, s1528 := BitVec.ofInt 16 v8, s1529 := BitVec.ofInt 16 v9, s1530 := BitVec.ofInt 16 v10, s1531 := BitVec.ofInt 16 v11, s1532 := BitVec.ofInt 16 v12, s1533 := BitVec.ofInt 16 v13, s1534 := BitVec.ofInt 16 v14, s1535 := BitVec.ofInt 16 v15 }

def decodeStateGroup5 (j : Lean.Json) : Except String StateGroup5 := do

  let g0 ← decodeStateGroup5Group0 j

  let g1 ← decodeStateGroup5Group1 j

  let g2 ← decodeStateGroup5Group2 j

  let g3 ← decodeStateGroup5Group3 j

  let g4 ← decodeStateGroup5Group4 j

  let g5 ← decodeStateGroup5Group5 j

  let g6 ← decodeStateGroup5Group6 j

  let g7 ← decodeStateGroup5Group7 j

  let g8 ← decodeStateGroup5Group8 j

  let g9 ← decodeStateGroup5Group9 j

  let g10 ← decodeStateGroup5Group10 j

  let g11 ← decodeStateGroup5Group11 j

  let g12 ← decodeStateGroup5Group12 j

  let g13 ← decodeStateGroup5Group13 j

  let g14 ← decodeStateGroup5Group14 j

  let g15 ← decodeStateGroup5Group15 j

  return { g0 := g0, g1 := g1, g2 := g2, g3 := g3, g4 := g4, g5 := g5, g6 := g6, g7 := g7, g8 := g8, g9 := g9, g10 := g10, g11 := g11, g12 := g12, g13 := g13, g14 := g14, g15 := g15 }

def decodeState (j : Lean.Json) : Except String State := do

  let g0 ← decodeStateGroup0 j

  let g1 ← decodeStateGroup1 j

  let g2 ← decodeStateGroup2 j

  let g3 ← decodeStateGroup3 j

  let g4 ← decodeStateGroup4 j

  let g5 ← decodeStateGroup5 j

  return { g0 := g0, g1 := g1, g2 := g2, g3 := g3, g4 := g4, g5 := g5 }
def encodeOutputs (o : Outputs) : Lean.Json := Lean.Json.mkObj [("q", Lean.toJson o.o0.toNat)]

def unwrap (r : Except String α) : IO α :=
  match r with
  | .ok x => pure x
  | .error e => throw (IO.userError e)
def main (args : List String) : IO Unit := do
  let [path] := args | throw (IO.userError "Supply request path")
  let j ← unwrap (Lean.Json.parse (← IO.FS.readFile path))
  let rows ← unwrap (j.getObjValAs? (Array Lean.Json) "trace")
  let mut state ← unwrap (decodeState (← unwrap (j.getObjVal? "initial")))
  if !initialValid state then throw (IO.userError "Initial state violates known-bit constraints")
  let mut cycle : Nat := 0
  for row in rows do
    let inputs ← unwrap (decodeInputs (← unwrap (row.getObjVal? "inputs")))
    let low := evaluate ({ inputs with g0 := { inputs.g0 with g0 := { inputs.g0.g0 with i1 := 0 } } }) state
    if !low.outputDefined || !low.transitionDefined then throw (IO.userError "Undefined low-clock operation")
    let high := evaluate ({ inputs with g0 := { inputs.g0 with g0 := { inputs.g0.g0 with i1 := 1 } } }) low.nextState
    if !high.outputDefined || !high.transitionDefined then throw (IO.userError "Undefined high-clock operation")
    let pre := low.outputs
    let post := high.outputs
    state := high.nextState
    IO.println ((Lean.Json.mkObj [("cycle", Lean.toJson cycle),
      ("pre", encodeOutputs pre), ("post", encodeOutputs post)]).compress)
    cycle := cycle + 1
