import Records.Many
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
open Records.Many
def decodeInputsGroup0Group0 (j : Lean.Json) : Except String InputsGroup0Group0 := do
  let v0 ← j.getObjValAs? Int "reset"
  let v1 ← j.getObjValAs? Int "clock"
  let v2 ← j.getObjValAs? Int "en"
  let v3 ← j.getObjValAs? Int "d0"
  let v4 ← j.getObjValAs? Int "expected0"
  let v5 ← j.getObjValAs? Int "d1"
  let v6 ← j.getObjValAs? Int "expected1"
  let v7 ← j.getObjValAs? Int "d2"
  let v8 ← j.getObjValAs? Int "expected2"
  let v9 ← j.getObjValAs? Int "d3"
  let v10 ← j.getObjValAs? Int "expected3"
  let v11 ← j.getObjValAs? Int "d4"
  let v12 ← j.getObjValAs? Int "expected4"
  let v13 ← j.getObjValAs? Int "d5"
  let v14 ← j.getObjValAs? Int "expected5"
  let v15 ← j.getObjValAs? Int "d6"
  return { i0 := BitVec.ofInt 1 v0, i1 := BitVec.ofInt 1 v1, i2 := BitVec.ofInt 1 v2, i3 := BitVec.ofInt 8 v3, i4 := BitVec.ofInt 8 v4, i5 := BitVec.ofInt 8 v5, i6 := BitVec.ofInt 8 v6, i7 := BitVec.ofInt 8 v7, i8 := BitVec.ofInt 8 v8, i9 := BitVec.ofInt 8 v9, i10 := BitVec.ofInt 8 v10, i11 := BitVec.ofInt 8 v11, i12 := BitVec.ofInt 8 v12, i13 := BitVec.ofInt 8 v13, i14 := BitVec.ofInt 8 v14, i15 := BitVec.ofInt 8 v15 }

def decodeInputsGroup0Group1 (j : Lean.Json) : Except String InputsGroup0Group1 := do
  let v0 ← j.getObjValAs? Int "expected6"
  let v1 ← j.getObjValAs? Int "d7"
  let v2 ← j.getObjValAs? Int "expected7"
  let v3 ← j.getObjValAs? Int "d8"
  let v4 ← j.getObjValAs? Int "expected8"
  let v5 ← j.getObjValAs? Int "d9"
  let v6 ← j.getObjValAs? Int "expected9"
  let v7 ← j.getObjValAs? Int "d10"
  let v8 ← j.getObjValAs? Int "expected10"
  let v9 ← j.getObjValAs? Int "d11"
  let v10 ← j.getObjValAs? Int "expected11"
  let v11 ← j.getObjValAs? Int "d12"
  let v12 ← j.getObjValAs? Int "expected12"
  let v13 ← j.getObjValAs? Int "d13"
  let v14 ← j.getObjValAs? Int "expected13"
  let v15 ← j.getObjValAs? Int "d14"
  return { i16 := BitVec.ofInt 8 v0, i17 := BitVec.ofInt 8 v1, i18 := BitVec.ofInt 8 v2, i19 := BitVec.ofInt 8 v3, i20 := BitVec.ofInt 8 v4, i21 := BitVec.ofInt 8 v5, i22 := BitVec.ofInt 8 v6, i23 := BitVec.ofInt 8 v7, i24 := BitVec.ofInt 8 v8, i25 := BitVec.ofInt 8 v9, i26 := BitVec.ofInt 8 v10, i27 := BitVec.ofInt 8 v11, i28 := BitVec.ofInt 8 v12, i29 := BitVec.ofInt 8 v13, i30 := BitVec.ofInt 8 v14, i31 := BitVec.ofInt 8 v15 }

def decodeInputsGroup0Group2 (j : Lean.Json) : Except String InputsGroup0Group2 := do
  let v0 ← j.getObjValAs? Int "expected14"
  let v1 ← j.getObjValAs? Int "d15"
  let v2 ← j.getObjValAs? Int "expected15"
  let v3 ← j.getObjValAs? Int "d16"
  let v4 ← j.getObjValAs? Int "expected16"
  let v5 ← j.getObjValAs? Int "d17"
  let v6 ← j.getObjValAs? Int "expected17"
  let v7 ← j.getObjValAs? Int "d18"
  let v8 ← j.getObjValAs? Int "expected18"
  let v9 ← j.getObjValAs? Int "d19"
  let v10 ← j.getObjValAs? Int "expected19"
  let v11 ← j.getObjValAs? Int "d20"
  let v12 ← j.getObjValAs? Int "expected20"
  let v13 ← j.getObjValAs? Int "d21"
  let v14 ← j.getObjValAs? Int "expected21"
  let v15 ← j.getObjValAs? Int "d22"
  return { i32 := BitVec.ofInt 8 v0, i33 := BitVec.ofInt 8 v1, i34 := BitVec.ofInt 8 v2, i35 := BitVec.ofInt 8 v3, i36 := BitVec.ofInt 8 v4, i37 := BitVec.ofInt 8 v5, i38 := BitVec.ofInt 8 v6, i39 := BitVec.ofInt 8 v7, i40 := BitVec.ofInt 8 v8, i41 := BitVec.ofInt 8 v9, i42 := BitVec.ofInt 8 v10, i43 := BitVec.ofInt 8 v11, i44 := BitVec.ofInt 8 v12, i45 := BitVec.ofInt 8 v13, i46 := BitVec.ofInt 8 v14, i47 := BitVec.ofInt 8 v15 }

def decodeInputsGroup0Group3 (j : Lean.Json) : Except String InputsGroup0Group3 := do
  let v0 ← j.getObjValAs? Int "expected22"
  let v1 ← j.getObjValAs? Int "d23"
  let v2 ← j.getObjValAs? Int "expected23"
  let v3 ← j.getObjValAs? Int "d24"
  let v4 ← j.getObjValAs? Int "expected24"
  let v5 ← j.getObjValAs? Int "d25"
  let v6 ← j.getObjValAs? Int "expected25"
  let v7 ← j.getObjValAs? Int "d26"
  let v8 ← j.getObjValAs? Int "expected26"
  let v9 ← j.getObjValAs? Int "d27"
  let v10 ← j.getObjValAs? Int "expected27"
  let v11 ← j.getObjValAs? Int "d28"
  let v12 ← j.getObjValAs? Int "expected28"
  let v13 ← j.getObjValAs? Int "d29"
  let v14 ← j.getObjValAs? Int "expected29"
  let v15 ← j.getObjValAs? Int "d30"
  return { i48 := BitVec.ofInt 8 v0, i49 := BitVec.ofInt 8 v1, i50 := BitVec.ofInt 8 v2, i51 := BitVec.ofInt 8 v3, i52 := BitVec.ofInt 8 v4, i53 := BitVec.ofInt 8 v5, i54 := BitVec.ofInt 8 v6, i55 := BitVec.ofInt 8 v7, i56 := BitVec.ofInt 8 v8, i57 := BitVec.ofInt 8 v9, i58 := BitVec.ofInt 8 v10, i59 := BitVec.ofInt 8 v11, i60 := BitVec.ofInt 8 v12, i61 := BitVec.ofInt 8 v13, i62 := BitVec.ofInt 8 v14, i63 := BitVec.ofInt 8 v15 }

def decodeInputsGroup0Group4 (j : Lean.Json) : Except String InputsGroup0Group4 := do
  let v0 ← j.getObjValAs? Int "expected30"
  let v1 ← j.getObjValAs? Int "d31"
  let v2 ← j.getObjValAs? Int "expected31"
  let v3 ← j.getObjValAs? Int "d32"
  let v4 ← j.getObjValAs? Int "expected32"
  let v5 ← j.getObjValAs? Int "d33"
  let v6 ← j.getObjValAs? Int "expected33"
  let v7 ← j.getObjValAs? Int "d34"
  let v8 ← j.getObjValAs? Int "expected34"
  let v9 ← j.getObjValAs? Int "d35"
  let v10 ← j.getObjValAs? Int "expected35"
  let v11 ← j.getObjValAs? Int "d36"
  let v12 ← j.getObjValAs? Int "expected36"
  let v13 ← j.getObjValAs? Int "d37"
  let v14 ← j.getObjValAs? Int "expected37"
  let v15 ← j.getObjValAs? Int "d38"
  return { i64 := BitVec.ofInt 8 v0, i65 := BitVec.ofInt 8 v1, i66 := BitVec.ofInt 8 v2, i67 := BitVec.ofInt 8 v3, i68 := BitVec.ofInt 8 v4, i69 := BitVec.ofInt 8 v5, i70 := BitVec.ofInt 8 v6, i71 := BitVec.ofInt 8 v7, i72 := BitVec.ofInt 8 v8, i73 := BitVec.ofInt 8 v9, i74 := BitVec.ofInt 8 v10, i75 := BitVec.ofInt 8 v11, i76 := BitVec.ofInt 8 v12, i77 := BitVec.ofInt 8 v13, i78 := BitVec.ofInt 8 v14, i79 := BitVec.ofInt 8 v15 }

def decodeInputsGroup0Group5 (j : Lean.Json) : Except String InputsGroup0Group5 := do
  let v0 ← j.getObjValAs? Int "expected38"
  let v1 ← j.getObjValAs? Int "d39"
  let v2 ← j.getObjValAs? Int "expected39"
  let v3 ← j.getObjValAs? Int "d40"
  let v4 ← j.getObjValAs? Int "expected40"
  let v5 ← j.getObjValAs? Int "d41"
  let v6 ← j.getObjValAs? Int "expected41"
  let v7 ← j.getObjValAs? Int "d42"
  let v8 ← j.getObjValAs? Int "expected42"
  let v9 ← j.getObjValAs? Int "d43"
  let v10 ← j.getObjValAs? Int "expected43"
  let v11 ← j.getObjValAs? Int "d44"
  let v12 ← j.getObjValAs? Int "expected44"
  let v13 ← j.getObjValAs? Int "d45"
  let v14 ← j.getObjValAs? Int "expected45"
  let v15 ← j.getObjValAs? Int "d46"
  return { i80 := BitVec.ofInt 8 v0, i81 := BitVec.ofInt 8 v1, i82 := BitVec.ofInt 8 v2, i83 := BitVec.ofInt 8 v3, i84 := BitVec.ofInt 8 v4, i85 := BitVec.ofInt 8 v5, i86 := BitVec.ofInt 8 v6, i87 := BitVec.ofInt 8 v7, i88 := BitVec.ofInt 8 v8, i89 := BitVec.ofInt 8 v9, i90 := BitVec.ofInt 8 v10, i91 := BitVec.ofInt 8 v11, i92 := BitVec.ofInt 8 v12, i93 := BitVec.ofInt 8 v13, i94 := BitVec.ofInt 8 v14, i95 := BitVec.ofInt 8 v15 }

def decodeInputsGroup0Group6 (j : Lean.Json) : Except String InputsGroup0Group6 := do
  let v0 ← j.getObjValAs? Int "expected46"
  let v1 ← j.getObjValAs? Int "d47"
  let v2 ← j.getObjValAs? Int "expected47"
  let v3 ← j.getObjValAs? Int "d48"
  let v4 ← j.getObjValAs? Int "expected48"
  let v5 ← j.getObjValAs? Int "d49"
  let v6 ← j.getObjValAs? Int "expected49"
  let v7 ← j.getObjValAs? Int "d50"
  let v8 ← j.getObjValAs? Int "expected50"
  let v9 ← j.getObjValAs? Int "d51"
  let v10 ← j.getObjValAs? Int "expected51"
  let v11 ← j.getObjValAs? Int "d52"
  let v12 ← j.getObjValAs? Int "expected52"
  let v13 ← j.getObjValAs? Int "d53"
  let v14 ← j.getObjValAs? Int "expected53"
  let v15 ← j.getObjValAs? Int "d54"
  return { i96 := BitVec.ofInt 8 v0, i97 := BitVec.ofInt 8 v1, i98 := BitVec.ofInt 8 v2, i99 := BitVec.ofInt 8 v3, i100 := BitVec.ofInt 8 v4, i101 := BitVec.ofInt 8 v5, i102 := BitVec.ofInt 8 v6, i103 := BitVec.ofInt 8 v7, i104 := BitVec.ofInt 8 v8, i105 := BitVec.ofInt 8 v9, i106 := BitVec.ofInt 8 v10, i107 := BitVec.ofInt 8 v11, i108 := BitVec.ofInt 8 v12, i109 := BitVec.ofInt 8 v13, i110 := BitVec.ofInt 8 v14, i111 := BitVec.ofInt 8 v15 }

def decodeInputsGroup0Group7 (j : Lean.Json) : Except String InputsGroup0Group7 := do
  let v0 ← j.getObjValAs? Int "expected54"
  let v1 ← j.getObjValAs? Int "d55"
  let v2 ← j.getObjValAs? Int "expected55"
  let v3 ← j.getObjValAs? Int "d56"
  let v4 ← j.getObjValAs? Int "expected56"
  let v5 ← j.getObjValAs? Int "d57"
  let v6 ← j.getObjValAs? Int "expected57"
  let v7 ← j.getObjValAs? Int "d58"
  let v8 ← j.getObjValAs? Int "expected58"
  let v9 ← j.getObjValAs? Int "d59"
  let v10 ← j.getObjValAs? Int "expected59"
  let v11 ← j.getObjValAs? Int "d60"
  let v12 ← j.getObjValAs? Int "expected60"
  let v13 ← j.getObjValAs? Int "d61"
  let v14 ← j.getObjValAs? Int "expected61"
  let v15 ← j.getObjValAs? Int "d62"
  return { i112 := BitVec.ofInt 8 v0, i113 := BitVec.ofInt 8 v1, i114 := BitVec.ofInt 8 v2, i115 := BitVec.ofInt 8 v3, i116 := BitVec.ofInt 8 v4, i117 := BitVec.ofInt 8 v5, i118 := BitVec.ofInt 8 v6, i119 := BitVec.ofInt 8 v7, i120 := BitVec.ofInt 8 v8, i121 := BitVec.ofInt 8 v9, i122 := BitVec.ofInt 8 v10, i123 := BitVec.ofInt 8 v11, i124 := BitVec.ofInt 8 v12, i125 := BitVec.ofInt 8 v13, i126 := BitVec.ofInt 8 v14, i127 := BitVec.ofInt 8 v15 }

def decodeInputsGroup0Group8 (j : Lean.Json) : Except String InputsGroup0Group8 := do
  let v0 ← j.getObjValAs? Int "expected62"
  let v1 ← j.getObjValAs? Int "d63"
  let v2 ← j.getObjValAs? Int "expected63"
  let v3 ← j.getObjValAs? Int "d64"
  let v4 ← j.getObjValAs? Int "expected64"
  let v5 ← j.getObjValAs? Int "d65"
  let v6 ← j.getObjValAs? Int "expected65"
  let v7 ← j.getObjValAs? Int "d66"
  let v8 ← j.getObjValAs? Int "expected66"
  let v9 ← j.getObjValAs? Int "d67"
  let v10 ← j.getObjValAs? Int "expected67"
  let v11 ← j.getObjValAs? Int "d68"
  let v12 ← j.getObjValAs? Int "expected68"
  let v13 ← j.getObjValAs? Int "d69"
  let v14 ← j.getObjValAs? Int "expected69"
  let v15 ← j.getObjValAs? Int "d70"
  return { i128 := BitVec.ofInt 8 v0, i129 := BitVec.ofInt 8 v1, i130 := BitVec.ofInt 8 v2, i131 := BitVec.ofInt 8 v3, i132 := BitVec.ofInt 8 v4, i133 := BitVec.ofInt 8 v5, i134 := BitVec.ofInt 8 v6, i135 := BitVec.ofInt 8 v7, i136 := BitVec.ofInt 8 v8, i137 := BitVec.ofInt 8 v9, i138 := BitVec.ofInt 8 v10, i139 := BitVec.ofInt 8 v11, i140 := BitVec.ofInt 8 v12, i141 := BitVec.ofInt 8 v13, i142 := BitVec.ofInt 8 v14, i143 := BitVec.ofInt 8 v15 }

def decodeInputsGroup0Group9 (j : Lean.Json) : Except String InputsGroup0Group9 := do
  let v0 ← j.getObjValAs? Int "expected70"
  let v1 ← j.getObjValAs? Int "d71"
  let v2 ← j.getObjValAs? Int "expected71"
  let v3 ← j.getObjValAs? Int "d72"
  let v4 ← j.getObjValAs? Int "expected72"
  let v5 ← j.getObjValAs? Int "d73"
  let v6 ← j.getObjValAs? Int "expected73"
  let v7 ← j.getObjValAs? Int "d74"
  let v8 ← j.getObjValAs? Int "expected74"
  let v9 ← j.getObjValAs? Int "d75"
  let v10 ← j.getObjValAs? Int "expected75"
  let v11 ← j.getObjValAs? Int "d76"
  let v12 ← j.getObjValAs? Int "expected76"
  let v13 ← j.getObjValAs? Int "d77"
  let v14 ← j.getObjValAs? Int "expected77"
  let v15 ← j.getObjValAs? Int "d78"
  return { i144 := BitVec.ofInt 8 v0, i145 := BitVec.ofInt 8 v1, i146 := BitVec.ofInt 8 v2, i147 := BitVec.ofInt 8 v3, i148 := BitVec.ofInt 8 v4, i149 := BitVec.ofInt 8 v5, i150 := BitVec.ofInt 8 v6, i151 := BitVec.ofInt 8 v7, i152 := BitVec.ofInt 8 v8, i153 := BitVec.ofInt 8 v9, i154 := BitVec.ofInt 8 v10, i155 := BitVec.ofInt 8 v11, i156 := BitVec.ofInt 8 v12, i157 := BitVec.ofInt 8 v13, i158 := BitVec.ofInt 8 v14, i159 := BitVec.ofInt 8 v15 }

def decodeInputsGroup0Group10 (j : Lean.Json) : Except String InputsGroup0Group10 := do
  let v0 ← j.getObjValAs? Int "expected78"
  let v1 ← j.getObjValAs? Int "d79"
  let v2 ← j.getObjValAs? Int "expected79"
  let v3 ← j.getObjValAs? Int "d80"
  let v4 ← j.getObjValAs? Int "expected80"
  let v5 ← j.getObjValAs? Int "d81"
  let v6 ← j.getObjValAs? Int "expected81"
  let v7 ← j.getObjValAs? Int "d82"
  let v8 ← j.getObjValAs? Int "expected82"
  let v9 ← j.getObjValAs? Int "d83"
  let v10 ← j.getObjValAs? Int "expected83"
  let v11 ← j.getObjValAs? Int "d84"
  let v12 ← j.getObjValAs? Int "expected84"
  let v13 ← j.getObjValAs? Int "d85"
  let v14 ← j.getObjValAs? Int "expected85"
  let v15 ← j.getObjValAs? Int "d86"
  return { i160 := BitVec.ofInt 8 v0, i161 := BitVec.ofInt 8 v1, i162 := BitVec.ofInt 8 v2, i163 := BitVec.ofInt 8 v3, i164 := BitVec.ofInt 8 v4, i165 := BitVec.ofInt 8 v5, i166 := BitVec.ofInt 8 v6, i167 := BitVec.ofInt 8 v7, i168 := BitVec.ofInt 8 v8, i169 := BitVec.ofInt 8 v9, i170 := BitVec.ofInt 8 v10, i171 := BitVec.ofInt 8 v11, i172 := BitVec.ofInt 8 v12, i173 := BitVec.ofInt 8 v13, i174 := BitVec.ofInt 8 v14, i175 := BitVec.ofInt 8 v15 }

def decodeInputsGroup0Group11 (j : Lean.Json) : Except String InputsGroup0Group11 := do
  let v0 ← j.getObjValAs? Int "expected86"
  let v1 ← j.getObjValAs? Int "d87"
  let v2 ← j.getObjValAs? Int "expected87"
  let v3 ← j.getObjValAs? Int "d88"
  let v4 ← j.getObjValAs? Int "expected88"
  let v5 ← j.getObjValAs? Int "d89"
  let v6 ← j.getObjValAs? Int "expected89"
  let v7 ← j.getObjValAs? Int "d90"
  let v8 ← j.getObjValAs? Int "expected90"
  let v9 ← j.getObjValAs? Int "d91"
  let v10 ← j.getObjValAs? Int "expected91"
  let v11 ← j.getObjValAs? Int "d92"
  let v12 ← j.getObjValAs? Int "expected92"
  let v13 ← j.getObjValAs? Int "d93"
  let v14 ← j.getObjValAs? Int "expected93"
  let v15 ← j.getObjValAs? Int "d94"
  return { i176 := BitVec.ofInt 8 v0, i177 := BitVec.ofInt 8 v1, i178 := BitVec.ofInt 8 v2, i179 := BitVec.ofInt 8 v3, i180 := BitVec.ofInt 8 v4, i181 := BitVec.ofInt 8 v5, i182 := BitVec.ofInt 8 v6, i183 := BitVec.ofInt 8 v7, i184 := BitVec.ofInt 8 v8, i185 := BitVec.ofInt 8 v9, i186 := BitVec.ofInt 8 v10, i187 := BitVec.ofInt 8 v11, i188 := BitVec.ofInt 8 v12, i189 := BitVec.ofInt 8 v13, i190 := BitVec.ofInt 8 v14, i191 := BitVec.ofInt 8 v15 }

def decodeInputsGroup0Group12 (j : Lean.Json) : Except String InputsGroup0Group12 := do
  let v0 ← j.getObjValAs? Int "expected94"
  let v1 ← j.getObjValAs? Int "d95"
  let v2 ← j.getObjValAs? Int "expected95"
  let v3 ← j.getObjValAs? Int "d96"
  let v4 ← j.getObjValAs? Int "expected96"
  let v5 ← j.getObjValAs? Int "d97"
  let v6 ← j.getObjValAs? Int "expected97"
  let v7 ← j.getObjValAs? Int "d98"
  let v8 ← j.getObjValAs? Int "expected98"
  let v9 ← j.getObjValAs? Int "d99"
  let v10 ← j.getObjValAs? Int "expected99"
  let v11 ← j.getObjValAs? Int "d100"
  let v12 ← j.getObjValAs? Int "expected100"
  let v13 ← j.getObjValAs? Int "d101"
  let v14 ← j.getObjValAs? Int "expected101"
  let v15 ← j.getObjValAs? Int "d102"
  return { i192 := BitVec.ofInt 8 v0, i193 := BitVec.ofInt 8 v1, i194 := BitVec.ofInt 8 v2, i195 := BitVec.ofInt 8 v3, i196 := BitVec.ofInt 8 v4, i197 := BitVec.ofInt 8 v5, i198 := BitVec.ofInt 8 v6, i199 := BitVec.ofInt 8 v7, i200 := BitVec.ofInt 8 v8, i201 := BitVec.ofInt 8 v9, i202 := BitVec.ofInt 8 v10, i203 := BitVec.ofInt 8 v11, i204 := BitVec.ofInt 8 v12, i205 := BitVec.ofInt 8 v13, i206 := BitVec.ofInt 8 v14, i207 := BitVec.ofInt 8 v15 }

def decodeInputsGroup0Group13 (j : Lean.Json) : Except String InputsGroup0Group13 := do
  let v0 ← j.getObjValAs? Int "expected102"
  let v1 ← j.getObjValAs? Int "d103"
  let v2 ← j.getObjValAs? Int "expected103"
  let v3 ← j.getObjValAs? Int "d104"
  let v4 ← j.getObjValAs? Int "expected104"
  let v5 ← j.getObjValAs? Int "d105"
  let v6 ← j.getObjValAs? Int "expected105"
  let v7 ← j.getObjValAs? Int "d106"
  let v8 ← j.getObjValAs? Int "expected106"
  let v9 ← j.getObjValAs? Int "d107"
  let v10 ← j.getObjValAs? Int "expected107"
  let v11 ← j.getObjValAs? Int "d108"
  let v12 ← j.getObjValAs? Int "expected108"
  let v13 ← j.getObjValAs? Int "d109"
  let v14 ← j.getObjValAs? Int "expected109"
  let v15 ← j.getObjValAs? Int "d110"
  return { i208 := BitVec.ofInt 8 v0, i209 := BitVec.ofInt 8 v1, i210 := BitVec.ofInt 8 v2, i211 := BitVec.ofInt 8 v3, i212 := BitVec.ofInt 8 v4, i213 := BitVec.ofInt 8 v5, i214 := BitVec.ofInt 8 v6, i215 := BitVec.ofInt 8 v7, i216 := BitVec.ofInt 8 v8, i217 := BitVec.ofInt 8 v9, i218 := BitVec.ofInt 8 v10, i219 := BitVec.ofInt 8 v11, i220 := BitVec.ofInt 8 v12, i221 := BitVec.ofInt 8 v13, i222 := BitVec.ofInt 8 v14, i223 := BitVec.ofInt 8 v15 }

def decodeInputsGroup0Group14 (j : Lean.Json) : Except String InputsGroup0Group14 := do
  let v0 ← j.getObjValAs? Int "expected110"
  let v1 ← j.getObjValAs? Int "d111"
  let v2 ← j.getObjValAs? Int "expected111"
  let v3 ← j.getObjValAs? Int "d112"
  let v4 ← j.getObjValAs? Int "expected112"
  let v5 ← j.getObjValAs? Int "d113"
  let v6 ← j.getObjValAs? Int "expected113"
  let v7 ← j.getObjValAs? Int "d114"
  let v8 ← j.getObjValAs? Int "expected114"
  let v9 ← j.getObjValAs? Int "d115"
  let v10 ← j.getObjValAs? Int "expected115"
  let v11 ← j.getObjValAs? Int "d116"
  let v12 ← j.getObjValAs? Int "expected116"
  let v13 ← j.getObjValAs? Int "d117"
  let v14 ← j.getObjValAs? Int "expected117"
  let v15 ← j.getObjValAs? Int "d118"
  return { i224 := BitVec.ofInt 8 v0, i225 := BitVec.ofInt 8 v1, i226 := BitVec.ofInt 8 v2, i227 := BitVec.ofInt 8 v3, i228 := BitVec.ofInt 8 v4, i229 := BitVec.ofInt 8 v5, i230 := BitVec.ofInt 8 v6, i231 := BitVec.ofInt 8 v7, i232 := BitVec.ofInt 8 v8, i233 := BitVec.ofInt 8 v9, i234 := BitVec.ofInt 8 v10, i235 := BitVec.ofInt 8 v11, i236 := BitVec.ofInt 8 v12, i237 := BitVec.ofInt 8 v13, i238 := BitVec.ofInt 8 v14, i239 := BitVec.ofInt 8 v15 }

def decodeInputsGroup0Group15 (j : Lean.Json) : Except String InputsGroup0Group15 := do
  let v0 ← j.getObjValAs? Int "expected118"
  let v1 ← j.getObjValAs? Int "d119"
  let v2 ← j.getObjValAs? Int "expected119"
  let v3 ← j.getObjValAs? Int "d120"
  let v4 ← j.getObjValAs? Int "expected120"
  let v5 ← j.getObjValAs? Int "d121"
  let v6 ← j.getObjValAs? Int "expected121"
  let v7 ← j.getObjValAs? Int "d122"
  let v8 ← j.getObjValAs? Int "expected122"
  let v9 ← j.getObjValAs? Int "d123"
  let v10 ← j.getObjValAs? Int "expected123"
  let v11 ← j.getObjValAs? Int "d124"
  let v12 ← j.getObjValAs? Int "expected124"
  let v13 ← j.getObjValAs? Int "d125"
  let v14 ← j.getObjValAs? Int "expected125"
  let v15 ← j.getObjValAs? Int "d126"
  return { i240 := BitVec.ofInt 8 v0, i241 := BitVec.ofInt 8 v1, i242 := BitVec.ofInt 8 v2, i243 := BitVec.ofInt 8 v3, i244 := BitVec.ofInt 8 v4, i245 := BitVec.ofInt 8 v5, i246 := BitVec.ofInt 8 v6, i247 := BitVec.ofInt 8 v7, i248 := BitVec.ofInt 8 v8, i249 := BitVec.ofInt 8 v9, i250 := BitVec.ofInt 8 v10, i251 := BitVec.ofInt 8 v11, i252 := BitVec.ofInt 8 v12, i253 := BitVec.ofInt 8 v13, i254 := BitVec.ofInt 8 v14, i255 := BitVec.ofInt 8 v15 }

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
  let v0 ← j.getObjValAs? Int "expected126"
  let v1 ← j.getObjValAs? Int "d127"
  let v2 ← j.getObjValAs? Int "expected127"
  let v3 ← j.getObjValAs? Int "d128"
  let v4 ← j.getObjValAs? Int "expected128"
  let v5 ← j.getObjValAs? Int "d129"
  let v6 ← j.getObjValAs? Int "expected129"
  let v7 ← j.getObjValAs? Int "d130"
  let v8 ← j.getObjValAs? Int "expected130"
  let v9 ← j.getObjValAs? Int "d131"
  let v10 ← j.getObjValAs? Int "expected131"
  let v11 ← j.getObjValAs? Int "d132"
  let v12 ← j.getObjValAs? Int "expected132"
  let v13 ← j.getObjValAs? Int "d133"
  let v14 ← j.getObjValAs? Int "expected133"
  let v15 ← j.getObjValAs? Int "d134"
  return { i256 := BitVec.ofInt 8 v0, i257 := BitVec.ofInt 8 v1, i258 := BitVec.ofInt 8 v2, i259 := BitVec.ofInt 8 v3, i260 := BitVec.ofInt 8 v4, i261 := BitVec.ofInt 8 v5, i262 := BitVec.ofInt 8 v6, i263 := BitVec.ofInt 8 v7, i264 := BitVec.ofInt 8 v8, i265 := BitVec.ofInt 8 v9, i266 := BitVec.ofInt 8 v10, i267 := BitVec.ofInt 8 v11, i268 := BitVec.ofInt 8 v12, i269 := BitVec.ofInt 8 v13, i270 := BitVec.ofInt 8 v14, i271 := BitVec.ofInt 8 v15 }

def decodeInputsGroup1Group1 (j : Lean.Json) : Except String InputsGroup1Group1 := do
  let v0 ← j.getObjValAs? Int "expected134"
  let v1 ← j.getObjValAs? Int "d135"
  let v2 ← j.getObjValAs? Int "expected135"
  let v3 ← j.getObjValAs? Int "d136"
  let v4 ← j.getObjValAs? Int "expected136"
  let v5 ← j.getObjValAs? Int "d137"
  let v6 ← j.getObjValAs? Int "expected137"
  let v7 ← j.getObjValAs? Int "d138"
  let v8 ← j.getObjValAs? Int "expected138"
  let v9 ← j.getObjValAs? Int "d139"
  let v10 ← j.getObjValAs? Int "expected139"
  let v11 ← j.getObjValAs? Int "d140"
  let v12 ← j.getObjValAs? Int "expected140"
  let v13 ← j.getObjValAs? Int "d141"
  let v14 ← j.getObjValAs? Int "expected141"
  let v15 ← j.getObjValAs? Int "d142"
  return { i272 := BitVec.ofInt 8 v0, i273 := BitVec.ofInt 8 v1, i274 := BitVec.ofInt 8 v2, i275 := BitVec.ofInt 8 v3, i276 := BitVec.ofInt 8 v4, i277 := BitVec.ofInt 8 v5, i278 := BitVec.ofInt 8 v6, i279 := BitVec.ofInt 8 v7, i280 := BitVec.ofInt 8 v8, i281 := BitVec.ofInt 8 v9, i282 := BitVec.ofInt 8 v10, i283 := BitVec.ofInt 8 v11, i284 := BitVec.ofInt 8 v12, i285 := BitVec.ofInt 8 v13, i286 := BitVec.ofInt 8 v14, i287 := BitVec.ofInt 8 v15 }

def decodeInputsGroup1Group2 (j : Lean.Json) : Except String InputsGroup1Group2 := do
  let v0 ← j.getObjValAs? Int "expected142"
  let v1 ← j.getObjValAs? Int "d143"
  let v2 ← j.getObjValAs? Int "expected143"
  let v3 ← j.getObjValAs? Int "d144"
  let v4 ← j.getObjValAs? Int "expected144"
  let v5 ← j.getObjValAs? Int "d145"
  let v6 ← j.getObjValAs? Int "expected145"
  let v7 ← j.getObjValAs? Int "d146"
  let v8 ← j.getObjValAs? Int "expected146"
  let v9 ← j.getObjValAs? Int "d147"
  let v10 ← j.getObjValAs? Int "expected147"
  let v11 ← j.getObjValAs? Int "d148"
  let v12 ← j.getObjValAs? Int "expected148"
  let v13 ← j.getObjValAs? Int "d149"
  let v14 ← j.getObjValAs? Int "expected149"
  let v15 ← j.getObjValAs? Int "d150"
  return { i288 := BitVec.ofInt 8 v0, i289 := BitVec.ofInt 8 v1, i290 := BitVec.ofInt 8 v2, i291 := BitVec.ofInt 8 v3, i292 := BitVec.ofInt 8 v4, i293 := BitVec.ofInt 8 v5, i294 := BitVec.ofInt 8 v6, i295 := BitVec.ofInt 8 v7, i296 := BitVec.ofInt 8 v8, i297 := BitVec.ofInt 8 v9, i298 := BitVec.ofInt 8 v10, i299 := BitVec.ofInt 8 v11, i300 := BitVec.ofInt 8 v12, i301 := BitVec.ofInt 8 v13, i302 := BitVec.ofInt 8 v14, i303 := BitVec.ofInt 8 v15 }

def decodeInputsGroup1Group3 (j : Lean.Json) : Except String InputsGroup1Group3 := do
  let v0 ← j.getObjValAs? Int "expected150"
  let v1 ← j.getObjValAs? Int "d151"
  let v2 ← j.getObjValAs? Int "expected151"
  let v3 ← j.getObjValAs? Int "d152"
  let v4 ← j.getObjValAs? Int "expected152"
  let v5 ← j.getObjValAs? Int "d153"
  let v6 ← j.getObjValAs? Int "expected153"
  let v7 ← j.getObjValAs? Int "d154"
  let v8 ← j.getObjValAs? Int "expected154"
  let v9 ← j.getObjValAs? Int "d155"
  let v10 ← j.getObjValAs? Int "expected155"
  let v11 ← j.getObjValAs? Int "d156"
  let v12 ← j.getObjValAs? Int "expected156"
  let v13 ← j.getObjValAs? Int "d157"
  let v14 ← j.getObjValAs? Int "expected157"
  let v15 ← j.getObjValAs? Int "d158"
  return { i304 := BitVec.ofInt 8 v0, i305 := BitVec.ofInt 8 v1, i306 := BitVec.ofInt 8 v2, i307 := BitVec.ofInt 8 v3, i308 := BitVec.ofInt 8 v4, i309 := BitVec.ofInt 8 v5, i310 := BitVec.ofInt 8 v6, i311 := BitVec.ofInt 8 v7, i312 := BitVec.ofInt 8 v8, i313 := BitVec.ofInt 8 v9, i314 := BitVec.ofInt 8 v10, i315 := BitVec.ofInt 8 v11, i316 := BitVec.ofInt 8 v12, i317 := BitVec.ofInt 8 v13, i318 := BitVec.ofInt 8 v14, i319 := BitVec.ofInt 8 v15 }

def decodeInputsGroup1Group4 (j : Lean.Json) : Except String InputsGroup1Group4 := do
  let v0 ← j.getObjValAs? Int "expected158"
  let v1 ← j.getObjValAs? Int "d159"
  let v2 ← j.getObjValAs? Int "expected159"
  let v3 ← j.getObjValAs? Int "c2l_undefined_0"
  let v4 ← j.getObjValAs? Int "c2l_undefined_1"
  let v5 ← j.getObjValAs? Int "c2l_undefined_2"
  let v6 ← j.getObjValAs? Int "c2l_undefined_3"
  let v7 ← j.getObjValAs? Int "c2l_undefined_4"
  let v8 ← j.getObjValAs? Int "c2l_undefined_5"
  let v9 ← j.getObjValAs? Int "c2l_undefined_6"
  let v10 ← j.getObjValAs? Int "c2l_undefined_7"
  let v11 ← j.getObjValAs? Int "c2l_undefined_8"
  let v12 ← j.getObjValAs? Int "c2l_undefined_9"
  let v13 ← j.getObjValAs? Int "c2l_undefined_10"
  let v14 ← j.getObjValAs? Int "c2l_undefined_11"
  let v15 ← j.getObjValAs? Int "c2l_undefined_12"
  return { i320 := BitVec.ofInt 8 v0, i321 := BitVec.ofInt 8 v1, i322 := BitVec.ofInt 8 v2, i323 := BitVec.ofInt 8 v3, i324 := BitVec.ofInt 8 v4, i325 := BitVec.ofInt 8 v5, i326 := BitVec.ofInt 8 v6, i327 := BitVec.ofInt 8 v7, i328 := BitVec.ofInt 8 v8, i329 := BitVec.ofInt 8 v9, i330 := BitVec.ofInt 8 v10, i331 := BitVec.ofInt 8 v11, i332 := BitVec.ofInt 8 v12, i333 := BitVec.ofInt 8 v13, i334 := BitVec.ofInt 8 v14, i335 := BitVec.ofInt 8 v15 }

def decodeInputsGroup1Group5 (j : Lean.Json) : Except String InputsGroup1Group5 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_13"
  let v1 ← j.getObjValAs? Int "c2l_undefined_14"
  let v2 ← j.getObjValAs? Int "c2l_undefined_15"
  let v3 ← j.getObjValAs? Int "c2l_undefined_16"
  let v4 ← j.getObjValAs? Int "c2l_undefined_17"
  let v5 ← j.getObjValAs? Int "c2l_undefined_18"
  let v6 ← j.getObjValAs? Int "c2l_undefined_19"
  let v7 ← j.getObjValAs? Int "c2l_undefined_20"
  let v8 ← j.getObjValAs? Int "c2l_undefined_21"
  let v9 ← j.getObjValAs? Int "c2l_undefined_22"
  let v10 ← j.getObjValAs? Int "c2l_undefined_23"
  let v11 ← j.getObjValAs? Int "c2l_undefined_24"
  let v12 ← j.getObjValAs? Int "c2l_undefined_25"
  let v13 ← j.getObjValAs? Int "c2l_undefined_26"
  let v14 ← j.getObjValAs? Int "c2l_undefined_27"
  let v15 ← j.getObjValAs? Int "c2l_undefined_28"
  return { i336 := BitVec.ofInt 8 v0, i337 := BitVec.ofInt 8 v1, i338 := BitVec.ofInt 8 v2, i339 := BitVec.ofInt 8 v3, i340 := BitVec.ofInt 8 v4, i341 := BitVec.ofInt 8 v5, i342 := BitVec.ofInt 8 v6, i343 := BitVec.ofInt 8 v7, i344 := BitVec.ofInt 8 v8, i345 := BitVec.ofInt 8 v9, i346 := BitVec.ofInt 8 v10, i347 := BitVec.ofInt 8 v11, i348 := BitVec.ofInt 8 v12, i349 := BitVec.ofInt 8 v13, i350 := BitVec.ofInt 8 v14, i351 := BitVec.ofInt 8 v15 }

def decodeInputsGroup1Group6 (j : Lean.Json) : Except String InputsGroup1Group6 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_29"
  let v1 ← j.getObjValAs? Int "c2l_undefined_30"
  let v2 ← j.getObjValAs? Int "c2l_undefined_31"
  let v3 ← j.getObjValAs? Int "c2l_undefined_32"
  let v4 ← j.getObjValAs? Int "c2l_undefined_33"
  let v5 ← j.getObjValAs? Int "c2l_undefined_34"
  let v6 ← j.getObjValAs? Int "c2l_undefined_35"
  let v7 ← j.getObjValAs? Int "c2l_undefined_36"
  let v8 ← j.getObjValAs? Int "c2l_undefined_37"
  let v9 ← j.getObjValAs? Int "c2l_undefined_38"
  let v10 ← j.getObjValAs? Int "c2l_undefined_39"
  let v11 ← j.getObjValAs? Int "c2l_undefined_40"
  let v12 ← j.getObjValAs? Int "c2l_undefined_41"
  let v13 ← j.getObjValAs? Int "c2l_undefined_42"
  let v14 ← j.getObjValAs? Int "c2l_undefined_43"
  let v15 ← j.getObjValAs? Int "c2l_undefined_44"
  return { i352 := BitVec.ofInt 8 v0, i353 := BitVec.ofInt 8 v1, i354 := BitVec.ofInt 8 v2, i355 := BitVec.ofInt 8 v3, i356 := BitVec.ofInt 8 v4, i357 := BitVec.ofInt 8 v5, i358 := BitVec.ofInt 8 v6, i359 := BitVec.ofInt 8 v7, i360 := BitVec.ofInt 8 v8, i361 := BitVec.ofInt 8 v9, i362 := BitVec.ofInt 8 v10, i363 := BitVec.ofInt 8 v11, i364 := BitVec.ofInt 8 v12, i365 := BitVec.ofInt 8 v13, i366 := BitVec.ofInt 8 v14, i367 := BitVec.ofInt 8 v15 }

def decodeInputsGroup1Group7 (j : Lean.Json) : Except String InputsGroup1Group7 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_45"
  let v1 ← j.getObjValAs? Int "c2l_undefined_46"
  let v2 ← j.getObjValAs? Int "c2l_undefined_47"
  let v3 ← j.getObjValAs? Int "c2l_undefined_48"
  let v4 ← j.getObjValAs? Int "c2l_undefined_49"
  let v5 ← j.getObjValAs? Int "c2l_undefined_50"
  let v6 ← j.getObjValAs? Int "c2l_undefined_51"
  let v7 ← j.getObjValAs? Int "c2l_undefined_52"
  let v8 ← j.getObjValAs? Int "c2l_undefined_53"
  let v9 ← j.getObjValAs? Int "c2l_undefined_54"
  let v10 ← j.getObjValAs? Int "c2l_undefined_55"
  let v11 ← j.getObjValAs? Int "c2l_undefined_56"
  let v12 ← j.getObjValAs? Int "c2l_undefined_57"
  let v13 ← j.getObjValAs? Int "c2l_undefined_58"
  let v14 ← j.getObjValAs? Int "c2l_undefined_59"
  let v15 ← j.getObjValAs? Int "c2l_undefined_60"
  return { i368 := BitVec.ofInt 8 v0, i369 := BitVec.ofInt 8 v1, i370 := BitVec.ofInt 8 v2, i371 := BitVec.ofInt 8 v3, i372 := BitVec.ofInt 8 v4, i373 := BitVec.ofInt 8 v5, i374 := BitVec.ofInt 8 v6, i375 := BitVec.ofInt 8 v7, i376 := BitVec.ofInt 8 v8, i377 := BitVec.ofInt 8 v9, i378 := BitVec.ofInt 8 v10, i379 := BitVec.ofInt 8 v11, i380 := BitVec.ofInt 8 v12, i381 := BitVec.ofInt 8 v13, i382 := BitVec.ofInt 8 v14, i383 := BitVec.ofInt 8 v15 }

def decodeInputsGroup1Group8 (j : Lean.Json) : Except String InputsGroup1Group8 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_61"
  let v1 ← j.getObjValAs? Int "c2l_undefined_62"
  let v2 ← j.getObjValAs? Int "c2l_undefined_63"
  let v3 ← j.getObjValAs? Int "c2l_undefined_64"
  let v4 ← j.getObjValAs? Int "c2l_undefined_65"
  let v5 ← j.getObjValAs? Int "c2l_undefined_66"
  let v6 ← j.getObjValAs? Int "c2l_undefined_67"
  let v7 ← j.getObjValAs? Int "c2l_undefined_68"
  let v8 ← j.getObjValAs? Int "c2l_undefined_69"
  let v9 ← j.getObjValAs? Int "c2l_undefined_70"
  let v10 ← j.getObjValAs? Int "c2l_undefined_71"
  let v11 ← j.getObjValAs? Int "c2l_undefined_72"
  let v12 ← j.getObjValAs? Int "c2l_undefined_73"
  let v13 ← j.getObjValAs? Int "c2l_undefined_74"
  let v14 ← j.getObjValAs? Int "c2l_undefined_75"
  let v15 ← j.getObjValAs? Int "c2l_undefined_76"
  return { i384 := BitVec.ofInt 8 v0, i385 := BitVec.ofInt 8 v1, i386 := BitVec.ofInt 8 v2, i387 := BitVec.ofInt 8 v3, i388 := BitVec.ofInt 8 v4, i389 := BitVec.ofInt 8 v5, i390 := BitVec.ofInt 8 v6, i391 := BitVec.ofInt 8 v7, i392 := BitVec.ofInt 8 v8, i393 := BitVec.ofInt 8 v9, i394 := BitVec.ofInt 8 v10, i395 := BitVec.ofInt 8 v11, i396 := BitVec.ofInt 8 v12, i397 := BitVec.ofInt 8 v13, i398 := BitVec.ofInt 8 v14, i399 := BitVec.ofInt 8 v15 }

def decodeInputsGroup1Group9 (j : Lean.Json) : Except String InputsGroup1Group9 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_77"
  let v1 ← j.getObjValAs? Int "c2l_undefined_78"
  let v2 ← j.getObjValAs? Int "c2l_undefined_79"
  let v3 ← j.getObjValAs? Int "c2l_undefined_80"
  let v4 ← j.getObjValAs? Int "c2l_undefined_81"
  let v5 ← j.getObjValAs? Int "c2l_undefined_82"
  let v6 ← j.getObjValAs? Int "c2l_undefined_83"
  let v7 ← j.getObjValAs? Int "c2l_undefined_84"
  let v8 ← j.getObjValAs? Int "c2l_undefined_85"
  let v9 ← j.getObjValAs? Int "c2l_undefined_86"
  let v10 ← j.getObjValAs? Int "c2l_undefined_87"
  let v11 ← j.getObjValAs? Int "c2l_undefined_88"
  let v12 ← j.getObjValAs? Int "c2l_undefined_89"
  let v13 ← j.getObjValAs? Int "c2l_undefined_90"
  let v14 ← j.getObjValAs? Int "c2l_undefined_91"
  let v15 ← j.getObjValAs? Int "c2l_undefined_92"
  return { i400 := BitVec.ofInt 8 v0, i401 := BitVec.ofInt 8 v1, i402 := BitVec.ofInt 8 v2, i403 := BitVec.ofInt 8 v3, i404 := BitVec.ofInt 8 v4, i405 := BitVec.ofInt 8 v5, i406 := BitVec.ofInt 8 v6, i407 := BitVec.ofInt 8 v7, i408 := BitVec.ofInt 8 v8, i409 := BitVec.ofInt 8 v9, i410 := BitVec.ofInt 8 v10, i411 := BitVec.ofInt 8 v11, i412 := BitVec.ofInt 8 v12, i413 := BitVec.ofInt 8 v13, i414 := BitVec.ofInt 8 v14, i415 := BitVec.ofInt 8 v15 }

def decodeInputsGroup1Group10 (j : Lean.Json) : Except String InputsGroup1Group10 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_93"
  let v1 ← j.getObjValAs? Int "c2l_undefined_94"
  let v2 ← j.getObjValAs? Int "c2l_undefined_95"
  let v3 ← j.getObjValAs? Int "c2l_undefined_96"
  let v4 ← j.getObjValAs? Int "c2l_undefined_97"
  let v5 ← j.getObjValAs? Int "c2l_undefined_98"
  let v6 ← j.getObjValAs? Int "c2l_undefined_99"
  let v7 ← j.getObjValAs? Int "c2l_undefined_100"
  let v8 ← j.getObjValAs? Int "c2l_undefined_101"
  let v9 ← j.getObjValAs? Int "c2l_undefined_102"
  let v10 ← j.getObjValAs? Int "c2l_undefined_103"
  let v11 ← j.getObjValAs? Int "c2l_undefined_104"
  let v12 ← j.getObjValAs? Int "c2l_undefined_105"
  let v13 ← j.getObjValAs? Int "c2l_undefined_106"
  let v14 ← j.getObjValAs? Int "c2l_undefined_107"
  let v15 ← j.getObjValAs? Int "c2l_undefined_108"
  return { i416 := BitVec.ofInt 8 v0, i417 := BitVec.ofInt 8 v1, i418 := BitVec.ofInt 8 v2, i419 := BitVec.ofInt 8 v3, i420 := BitVec.ofInt 8 v4, i421 := BitVec.ofInt 8 v5, i422 := BitVec.ofInt 8 v6, i423 := BitVec.ofInt 8 v7, i424 := BitVec.ofInt 8 v8, i425 := BitVec.ofInt 8 v9, i426 := BitVec.ofInt 8 v10, i427 := BitVec.ofInt 8 v11, i428 := BitVec.ofInt 8 v12, i429 := BitVec.ofInt 8 v13, i430 := BitVec.ofInt 8 v14, i431 := BitVec.ofInt 8 v15 }

def decodeInputsGroup1Group11 (j : Lean.Json) : Except String InputsGroup1Group11 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_109"
  let v1 ← j.getObjValAs? Int "c2l_undefined_110"
  let v2 ← j.getObjValAs? Int "c2l_undefined_111"
  let v3 ← j.getObjValAs? Int "c2l_undefined_112"
  let v4 ← j.getObjValAs? Int "c2l_undefined_113"
  let v5 ← j.getObjValAs? Int "c2l_undefined_114"
  let v6 ← j.getObjValAs? Int "c2l_undefined_115"
  let v7 ← j.getObjValAs? Int "c2l_undefined_116"
  let v8 ← j.getObjValAs? Int "c2l_undefined_117"
  let v9 ← j.getObjValAs? Int "c2l_undefined_118"
  let v10 ← j.getObjValAs? Int "c2l_undefined_119"
  let v11 ← j.getObjValAs? Int "c2l_undefined_120"
  let v12 ← j.getObjValAs? Int "c2l_undefined_121"
  let v13 ← j.getObjValAs? Int "c2l_undefined_122"
  let v14 ← j.getObjValAs? Int "c2l_undefined_123"
  let v15 ← j.getObjValAs? Int "c2l_undefined_124"
  return { i432 := BitVec.ofInt 8 v0, i433 := BitVec.ofInt 8 v1, i434 := BitVec.ofInt 8 v2, i435 := BitVec.ofInt 8 v3, i436 := BitVec.ofInt 8 v4, i437 := BitVec.ofInt 8 v5, i438 := BitVec.ofInt 8 v6, i439 := BitVec.ofInt 8 v7, i440 := BitVec.ofInt 8 v8, i441 := BitVec.ofInt 8 v9, i442 := BitVec.ofInt 8 v10, i443 := BitVec.ofInt 8 v11, i444 := BitVec.ofInt 8 v12, i445 := BitVec.ofInt 8 v13, i446 := BitVec.ofInt 8 v14, i447 := BitVec.ofInt 8 v15 }

def decodeInputsGroup1Group12 (j : Lean.Json) : Except String InputsGroup1Group12 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_125"
  let v1 ← j.getObjValAs? Int "c2l_undefined_126"
  let v2 ← j.getObjValAs? Int "c2l_undefined_127"
  let v3 ← j.getObjValAs? Int "c2l_undefined_128"
  let v4 ← j.getObjValAs? Int "c2l_undefined_129"
  let v5 ← j.getObjValAs? Int "c2l_undefined_130"
  let v6 ← j.getObjValAs? Int "c2l_undefined_131"
  let v7 ← j.getObjValAs? Int "c2l_undefined_132"
  let v8 ← j.getObjValAs? Int "c2l_undefined_133"
  let v9 ← j.getObjValAs? Int "c2l_undefined_134"
  let v10 ← j.getObjValAs? Int "c2l_undefined_135"
  let v11 ← j.getObjValAs? Int "c2l_undefined_136"
  let v12 ← j.getObjValAs? Int "c2l_undefined_137"
  let v13 ← j.getObjValAs? Int "c2l_undefined_138"
  let v14 ← j.getObjValAs? Int "c2l_undefined_139"
  let v15 ← j.getObjValAs? Int "c2l_undefined_140"
  return { i448 := BitVec.ofInt 8 v0, i449 := BitVec.ofInt 8 v1, i450 := BitVec.ofInt 8 v2, i451 := BitVec.ofInt 8 v3, i452 := BitVec.ofInt 8 v4, i453 := BitVec.ofInt 8 v5, i454 := BitVec.ofInt 8 v6, i455 := BitVec.ofInt 8 v7, i456 := BitVec.ofInt 8 v8, i457 := BitVec.ofInt 8 v9, i458 := BitVec.ofInt 8 v10, i459 := BitVec.ofInt 8 v11, i460 := BitVec.ofInt 8 v12, i461 := BitVec.ofInt 8 v13, i462 := BitVec.ofInt 8 v14, i463 := BitVec.ofInt 8 v15 }

def decodeInputsGroup1Group13 (j : Lean.Json) : Except String InputsGroup1Group13 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_141"
  let v1 ← j.getObjValAs? Int "c2l_undefined_142"
  let v2 ← j.getObjValAs? Int "c2l_undefined_143"
  let v3 ← j.getObjValAs? Int "c2l_undefined_144"
  let v4 ← j.getObjValAs? Int "c2l_undefined_145"
  let v5 ← j.getObjValAs? Int "c2l_undefined_146"
  let v6 ← j.getObjValAs? Int "c2l_undefined_147"
  let v7 ← j.getObjValAs? Int "c2l_undefined_148"
  let v8 ← j.getObjValAs? Int "c2l_undefined_149"
  let v9 ← j.getObjValAs? Int "c2l_undefined_150"
  let v10 ← j.getObjValAs? Int "c2l_undefined_151"
  let v11 ← j.getObjValAs? Int "c2l_undefined_152"
  let v12 ← j.getObjValAs? Int "c2l_undefined_153"
  let v13 ← j.getObjValAs? Int "c2l_undefined_154"
  let v14 ← j.getObjValAs? Int "c2l_undefined_155"
  let v15 ← j.getObjValAs? Int "c2l_undefined_156"
  return { i464 := BitVec.ofInt 8 v0, i465 := BitVec.ofInt 8 v1, i466 := BitVec.ofInt 8 v2, i467 := BitVec.ofInt 8 v3, i468 := BitVec.ofInt 8 v4, i469 := BitVec.ofInt 8 v5, i470 := BitVec.ofInt 8 v6, i471 := BitVec.ofInt 8 v7, i472 := BitVec.ofInt 8 v8, i473 := BitVec.ofInt 8 v9, i474 := BitVec.ofInt 8 v10, i475 := BitVec.ofInt 8 v11, i476 := BitVec.ofInt 8 v12, i477 := BitVec.ofInt 8 v13, i478 := BitVec.ofInt 8 v14, i479 := BitVec.ofInt 8 v15 }

def decodeInputsGroup1Group14 (j : Lean.Json) : Except String InputsGroup1Group14 := do
  let v0 ← j.getObjValAs? Int "c2l_undefined_157"
  let v1 ← j.getObjValAs? Int "c2l_undefined_158"
  let v2 ← j.getObjValAs? Int "c2l_undefined_159"
  return { i480 := BitVec.ofInt 8 v0, i481 := BitVec.ofInt 8 v1, i482 := BitVec.ofInt 8 v2 }

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

  return { g0 := g0, g1 := g1, g2 := g2, g3 := g3, g4 := g4, g5 := g5, g6 := g6, g7 := g7, g8 := g8, g9 := g9, g10 := g10, g11 := g11, g12 := g12, g13 := g13, g14 := g14 }

def decodeInputs (j : Lean.Json) : Except String Inputs := do

  let g0 ← decodeInputsGroup0 j

  let g1 ← decodeInputsGroup1 j

  return { g0 := g0, g1 := g1 }
def decodeStateGroup0Group0 (j : Lean.Json) : Except String StateGroup0Group0 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$16"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$30"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$44"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$58"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$72"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$86"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$100"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$114"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$128"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$142"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$156"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$170"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$184"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$198"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$212"
  return { s0 := BitVec.ofInt 1 v0, s1 := BitVec.ofInt 1 v1, s2 := BitVec.ofInt 1 v2, s3 := BitVec.ofInt 1 v3, s4 := BitVec.ofInt 1 v4, s5 := BitVec.ofInt 1 v5, s6 := BitVec.ofInt 1 v6, s7 := BitVec.ofInt 1 v7, s8 := BitVec.ofInt 1 v8, s9 := BitVec.ofInt 1 v9, s10 := BitVec.ofInt 1 v10, s11 := BitVec.ofInt 1 v11, s12 := BitVec.ofInt 1 v12, s13 := BitVec.ofInt 1 v13, s14 := BitVec.ofInt 1 v14, s15 := BitVec.ofInt 1 v15 }

def decodeStateGroup0Group1 (j : Lean.Json) : Except String StateGroup0Group1 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$226"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$240"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$254"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$268"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$282"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$296"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$310"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$324"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$338"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$352"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$366"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$380"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$394"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$408"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$422"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$436"
  return { s16 := BitVec.ofInt 1 v0, s17 := BitVec.ofInt 1 v1, s18 := BitVec.ofInt 1 v2, s19 := BitVec.ofInt 1 v3, s20 := BitVec.ofInt 1 v4, s21 := BitVec.ofInt 1 v5, s22 := BitVec.ofInt 1 v6, s23 := BitVec.ofInt 1 v7, s24 := BitVec.ofInt 1 v8, s25 := BitVec.ofInt 1 v9, s26 := BitVec.ofInt 1 v10, s27 := BitVec.ofInt 1 v11, s28 := BitVec.ofInt 1 v12, s29 := BitVec.ofInt 1 v13, s30 := BitVec.ofInt 1 v14, s31 := BitVec.ofInt 1 v15 }

def decodeStateGroup0Group2 (j : Lean.Json) : Except String StateGroup0Group2 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$450"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$464"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$478"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$492"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$506"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$520"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$534"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$548"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$562"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$576"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$590"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$604"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$618"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$632"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$646"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$660"
  return { s32 := BitVec.ofInt 1 v0, s33 := BitVec.ofInt 1 v1, s34 := BitVec.ofInt 1 v2, s35 := BitVec.ofInt 1 v3, s36 := BitVec.ofInt 1 v4, s37 := BitVec.ofInt 1 v5, s38 := BitVec.ofInt 1 v6, s39 := BitVec.ofInt 1 v7, s40 := BitVec.ofInt 1 v8, s41 := BitVec.ofInt 1 v9, s42 := BitVec.ofInt 1 v10, s43 := BitVec.ofInt 1 v11, s44 := BitVec.ofInt 1 v12, s45 := BitVec.ofInt 1 v13, s46 := BitVec.ofInt 1 v14, s47 := BitVec.ofInt 1 v15 }

def decodeStateGroup0Group3 (j : Lean.Json) : Except String StateGroup0Group3 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$674"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$688"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$702"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$716"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$730"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$744"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$758"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$772"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$786"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$800"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$814"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$828"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$842"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$856"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$870"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$884"
  return { s48 := BitVec.ofInt 1 v0, s49 := BitVec.ofInt 1 v1, s50 := BitVec.ofInt 1 v2, s51 := BitVec.ofInt 1 v3, s52 := BitVec.ofInt 1 v4, s53 := BitVec.ofInt 1 v5, s54 := BitVec.ofInt 1 v6, s55 := BitVec.ofInt 1 v7, s56 := BitVec.ofInt 1 v8, s57 := BitVec.ofInt 1 v9, s58 := BitVec.ofInt 1 v10, s59 := BitVec.ofInt 1 v11, s60 := BitVec.ofInt 1 v12, s61 := BitVec.ofInt 1 v13, s62 := BitVec.ofInt 1 v14, s63 := BitVec.ofInt 1 v15 }

def decodeStateGroup0Group4 (j : Lean.Json) : Except String StateGroup0Group4 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$898"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$912"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$926"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$940"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$954"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$968"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$982"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$996"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1010"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1024"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1038"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1052"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1066"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1080"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1094"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1108"
  return { s64 := BitVec.ofInt 1 v0, s65 := BitVec.ofInt 1 v1, s66 := BitVec.ofInt 1 v2, s67 := BitVec.ofInt 1 v3, s68 := BitVec.ofInt 1 v4, s69 := BitVec.ofInt 1 v5, s70 := BitVec.ofInt 1 v6, s71 := BitVec.ofInt 1 v7, s72 := BitVec.ofInt 1 v8, s73 := BitVec.ofInt 1 v9, s74 := BitVec.ofInt 1 v10, s75 := BitVec.ofInt 1 v11, s76 := BitVec.ofInt 1 v12, s77 := BitVec.ofInt 1 v13, s78 := BitVec.ofInt 1 v14, s79 := BitVec.ofInt 1 v15 }

def decodeStateGroup0Group5 (j : Lean.Json) : Except String StateGroup0Group5 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1122"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1136"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1150"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1164"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1178"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1192"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1206"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1220"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1234"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1248"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1262"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1276"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1290"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1304"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1318"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1332"
  return { s80 := BitVec.ofInt 1 v0, s81 := BitVec.ofInt 1 v1, s82 := BitVec.ofInt 1 v2, s83 := BitVec.ofInt 1 v3, s84 := BitVec.ofInt 1 v4, s85 := BitVec.ofInt 1 v5, s86 := BitVec.ofInt 1 v6, s87 := BitVec.ofInt 1 v7, s88 := BitVec.ofInt 1 v8, s89 := BitVec.ofInt 1 v9, s90 := BitVec.ofInt 1 v10, s91 := BitVec.ofInt 1 v11, s92 := BitVec.ofInt 1 v12, s93 := BitVec.ofInt 1 v13, s94 := BitVec.ofInt 1 v14, s95 := BitVec.ofInt 1 v15 }

def decodeStateGroup0Group6 (j : Lean.Json) : Except String StateGroup0Group6 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1346"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1360"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1374"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1388"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1402"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1416"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1430"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1444"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1458"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1472"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1486"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1500"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1514"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1528"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1542"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1556"
  return { s96 := BitVec.ofInt 1 v0, s97 := BitVec.ofInt 1 v1, s98 := BitVec.ofInt 1 v2, s99 := BitVec.ofInt 1 v3, s100 := BitVec.ofInt 1 v4, s101 := BitVec.ofInt 1 v5, s102 := BitVec.ofInt 1 v6, s103 := BitVec.ofInt 1 v7, s104 := BitVec.ofInt 1 v8, s105 := BitVec.ofInt 1 v9, s106 := BitVec.ofInt 1 v10, s107 := BitVec.ofInt 1 v11, s108 := BitVec.ofInt 1 v12, s109 := BitVec.ofInt 1 v13, s110 := BitVec.ofInt 1 v14, s111 := BitVec.ofInt 1 v15 }

def decodeStateGroup0Group7 (j : Lean.Json) : Except String StateGroup0Group7 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1570"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1584"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1598"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1612"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1626"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1640"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1654"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1668"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1682"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1696"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1710"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1724"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1738"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1752"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1766"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1780"
  return { s112 := BitVec.ofInt 1 v0, s113 := BitVec.ofInt 1 v1, s114 := BitVec.ofInt 1 v2, s115 := BitVec.ofInt 1 v3, s116 := BitVec.ofInt 1 v4, s117 := BitVec.ofInt 1 v5, s118 := BitVec.ofInt 1 v6, s119 := BitVec.ofInt 1 v7, s120 := BitVec.ofInt 1 v8, s121 := BitVec.ofInt 1 v9, s122 := BitVec.ofInt 1 v10, s123 := BitVec.ofInt 1 v11, s124 := BitVec.ofInt 1 v12, s125 := BitVec.ofInt 1 v13, s126 := BitVec.ofInt 1 v14, s127 := BitVec.ofInt 1 v15 }

def decodeStateGroup0Group8 (j : Lean.Json) : Except String StateGroup0Group8 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1794"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1808"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1822"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1836"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1850"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1864"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1878"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1892"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1906"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1920"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1934"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1948"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1962"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1976"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$1990"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2004"
  return { s128 := BitVec.ofInt 1 v0, s129 := BitVec.ofInt 1 v1, s130 := BitVec.ofInt 1 v2, s131 := BitVec.ofInt 1 v3, s132 := BitVec.ofInt 1 v4, s133 := BitVec.ofInt 1 v5, s134 := BitVec.ofInt 1 v6, s135 := BitVec.ofInt 1 v7, s136 := BitVec.ofInt 1 v8, s137 := BitVec.ofInt 1 v9, s138 := BitVec.ofInt 1 v10, s139 := BitVec.ofInt 1 v11, s140 := BitVec.ofInt 1 v12, s141 := BitVec.ofInt 1 v13, s142 := BitVec.ofInt 1 v14, s143 := BitVec.ofInt 1 v15 }

def decodeStateGroup0Group9 (j : Lean.Json) : Except String StateGroup0Group9 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2018"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2032"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2046"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2060"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2074"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2088"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2102"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2116"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2130"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2144"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2158"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2172"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2186"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2200"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2214"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2228"
  return { s144 := BitVec.ofInt 1 v0, s145 := BitVec.ofInt 1 v1, s146 := BitVec.ofInt 1 v2, s147 := BitVec.ofInt 1 v3, s148 := BitVec.ofInt 1 v4, s149 := BitVec.ofInt 1 v5, s150 := BitVec.ofInt 1 v6, s151 := BitVec.ofInt 1 v7, s152 := BitVec.ofInt 1 v8, s153 := BitVec.ofInt 1 v9, s154 := BitVec.ofInt 1 v10, s155 := BitVec.ofInt 1 v11, s156 := BitVec.ofInt 1 v12, s157 := BitVec.ofInt 1 v13, s158 := BitVec.ofInt 1 v14, s159 := BitVec.ofInt 1 v15 }

def decodeStateGroup0Group10 (j : Lean.Json) : Except String StateGroup0Group10 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2246"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2256"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2966"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3076"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3186"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3296"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3406"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3516"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3626"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3736"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2266"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2376"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2486"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2596"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2706"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2816"
  return { s160 := BitVec.ofInt 1 v0, s161 := BitVec.ofInt 1 v1, s162 := BitVec.ofInt 1 v2, s163 := BitVec.ofInt 1 v3, s164 := BitVec.ofInt 1 v4, s165 := BitVec.ofInt 1 v5, s166 := BitVec.ofInt 1 v6, s167 := BitVec.ofInt 1 v7, s168 := BitVec.ofInt 1 v8, s169 := BitVec.ofInt 1 v9, s170 := BitVec.ofInt 1 v10, s171 := BitVec.ofInt 1 v11, s172 := BitVec.ofInt 1 v12, s173 := BitVec.ofInt 1 v13, s174 := BitVec.ofInt 1 v14, s175 := BitVec.ofInt 1 v15 }

def decodeStateGroup0Group11 (j : Lean.Json) : Except String StateGroup0Group11 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2926"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2936"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2946"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2956"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2976"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2986"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2996"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3006"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3016"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3026"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3036"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3046"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3056"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3066"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3086"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3096"
  return { s176 := BitVec.ofInt 1 v0, s177 := BitVec.ofInt 1 v1, s178 := BitVec.ofInt 1 v2, s179 := BitVec.ofInt 1 v3, s180 := BitVec.ofInt 1 v4, s181 := BitVec.ofInt 1 v5, s182 := BitVec.ofInt 1 v6, s183 := BitVec.ofInt 1 v7, s184 := BitVec.ofInt 1 v8, s185 := BitVec.ofInt 1 v9, s186 := BitVec.ofInt 1 v10, s187 := BitVec.ofInt 1 v11, s188 := BitVec.ofInt 1 v12, s189 := BitVec.ofInt 1 v13, s190 := BitVec.ofInt 1 v14, s191 := BitVec.ofInt 1 v15 }

def decodeStateGroup0Group12 (j : Lean.Json) : Except String StateGroup0Group12 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3106"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3116"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3126"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3136"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3146"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3156"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3166"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3176"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3196"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3206"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3216"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3226"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3236"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3246"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3256"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3266"
  return { s192 := BitVec.ofInt 1 v0, s193 := BitVec.ofInt 1 v1, s194 := BitVec.ofInt 1 v2, s195 := BitVec.ofInt 1 v3, s196 := BitVec.ofInt 1 v4, s197 := BitVec.ofInt 1 v5, s198 := BitVec.ofInt 1 v6, s199 := BitVec.ofInt 1 v7, s200 := BitVec.ofInt 1 v8, s201 := BitVec.ofInt 1 v9, s202 := BitVec.ofInt 1 v10, s203 := BitVec.ofInt 1 v11, s204 := BitVec.ofInt 1 v12, s205 := BitVec.ofInt 1 v13, s206 := BitVec.ofInt 1 v14, s207 := BitVec.ofInt 1 v15 }

def decodeStateGroup0Group13 (j : Lean.Json) : Except String StateGroup0Group13 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3276"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3286"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3306"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3316"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3326"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3336"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3346"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3356"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3366"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3376"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3386"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3396"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3416"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3426"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3436"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3446"
  return { s208 := BitVec.ofInt 1 v0, s209 := BitVec.ofInt 1 v1, s210 := BitVec.ofInt 1 v2, s211 := BitVec.ofInt 1 v3, s212 := BitVec.ofInt 1 v4, s213 := BitVec.ofInt 1 v5, s214 := BitVec.ofInt 1 v6, s215 := BitVec.ofInt 1 v7, s216 := BitVec.ofInt 1 v8, s217 := BitVec.ofInt 1 v9, s218 := BitVec.ofInt 1 v10, s219 := BitVec.ofInt 1 v11, s220 := BitVec.ofInt 1 v12, s221 := BitVec.ofInt 1 v13, s222 := BitVec.ofInt 1 v14, s223 := BitVec.ofInt 1 v15 }

def decodeStateGroup0Group14 (j : Lean.Json) : Except String StateGroup0Group14 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3456"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3466"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3476"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3486"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3496"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3506"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3526"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3536"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3546"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3556"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3566"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3576"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3586"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3596"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3606"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3616"
  return { s224 := BitVec.ofInt 1 v0, s225 := BitVec.ofInt 1 v1, s226 := BitVec.ofInt 1 v2, s227 := BitVec.ofInt 1 v3, s228 := BitVec.ofInt 1 v4, s229 := BitVec.ofInt 1 v5, s230 := BitVec.ofInt 1 v6, s231 := BitVec.ofInt 1 v7, s232 := BitVec.ofInt 1 v8, s233 := BitVec.ofInt 1 v9, s234 := BitVec.ofInt 1 v10, s235 := BitVec.ofInt 1 v11, s236 := BitVec.ofInt 1 v12, s237 := BitVec.ofInt 1 v13, s238 := BitVec.ofInt 1 v14, s239 := BitVec.ofInt 1 v15 }

def decodeStateGroup0Group15 (j : Lean.Json) : Except String StateGroup0Group15 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3636"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3646"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3656"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3666"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3676"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3686"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3696"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3706"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3716"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3726"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3746"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3756"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3766"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3776"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3786"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3796"
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
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3806"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3816"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3826"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$3836"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2276"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2286"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2296"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2306"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2316"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2326"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2336"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2346"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2356"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2366"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2386"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2396"
  return { s256 := BitVec.ofInt 1 v0, s257 := BitVec.ofInt 1 v1, s258 := BitVec.ofInt 1 v2, s259 := BitVec.ofInt 1 v3, s260 := BitVec.ofInt 1 v4, s261 := BitVec.ofInt 1 v5, s262 := BitVec.ofInt 1 v6, s263 := BitVec.ofInt 1 v7, s264 := BitVec.ofInt 1 v8, s265 := BitVec.ofInt 1 v9, s266 := BitVec.ofInt 1 v10, s267 := BitVec.ofInt 1 v11, s268 := BitVec.ofInt 1 v12, s269 := BitVec.ofInt 1 v13, s270 := BitVec.ofInt 1 v14, s271 := BitVec.ofInt 1 v15 }

def decodeStateGroup1Group1 (j : Lean.Json) : Except String StateGroup1Group1 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2406"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2416"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2426"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2436"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2446"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2456"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2466"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2476"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2496"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2506"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2516"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2526"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2536"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2546"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2556"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2566"
  return { s272 := BitVec.ofInt 1 v0, s273 := BitVec.ofInt 1 v1, s274 := BitVec.ofInt 1 v2, s275 := BitVec.ofInt 1 v3, s276 := BitVec.ofInt 1 v4, s277 := BitVec.ofInt 1 v5, s278 := BitVec.ofInt 1 v6, s279 := BitVec.ofInt 1 v7, s280 := BitVec.ofInt 1 v8, s281 := BitVec.ofInt 1 v9, s282 := BitVec.ofInt 1 v10, s283 := BitVec.ofInt 1 v11, s284 := BitVec.ofInt 1 v12, s285 := BitVec.ofInt 1 v13, s286 := BitVec.ofInt 1 v14, s287 := BitVec.ofInt 1 v15 }

def decodeStateGroup1Group2 (j : Lean.Json) : Except String StateGroup1Group2 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2576"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2586"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2606"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2616"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2626"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2636"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2646"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2656"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2666"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2676"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2686"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2696"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2716"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2726"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2736"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2746"
  return { s288 := BitVec.ofInt 1 v0, s289 := BitVec.ofInt 1 v1, s290 := BitVec.ofInt 1 v2, s291 := BitVec.ofInt 1 v3, s292 := BitVec.ofInt 1 v4, s293 := BitVec.ofInt 1 v5, s294 := BitVec.ofInt 1 v6, s295 := BitVec.ofInt 1 v7, s296 := BitVec.ofInt 1 v8, s297 := BitVec.ofInt 1 v9, s298 := BitVec.ofInt 1 v10, s299 := BitVec.ofInt 1 v11, s300 := BitVec.ofInt 1 v12, s301 := BitVec.ofInt 1 v13, s302 := BitVec.ofInt 1 v14, s303 := BitVec.ofInt 1 v15 }

def decodeStateGroup1Group3 (j : Lean.Json) : Except String StateGroup1Group3 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2756"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2766"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2776"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2786"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2796"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2806"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2826"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2836"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2846"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2856"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2866"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2876"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2886"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2896"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2906"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:92:sample_control_edge$2916"
  return { s304 := BitVec.ofInt 1 v0, s305 := BitVec.ofInt 1 v1, s306 := BitVec.ofInt 1 v2, s307 := BitVec.ofInt 1 v3, s308 := BitVec.ofInt 1 v4, s309 := BitVec.ofInt 1 v5, s310 := BitVec.ofInt 1 v6, s311 := BitVec.ofInt 1 v7, s312 := BitVec.ofInt 1 v8, s313 := BitVec.ofInt 1 v9, s314 := BitVec.ofInt 1 v10, s315 := BitVec.ofInt 1 v11, s316 := BitVec.ofInt 1 v12, s317 := BitVec.ofInt 1 v13, s318 := BitVec.ofInt 1 v14, s319 := BitVec.ofInt 1 v15 }

def decodeStateGroup1Group4 (j : Lean.Json) : Except String StateGroup1Group4 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2244"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2242"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2254"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2252"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2964"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2962"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3074"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3072"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3184"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3182"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3294"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3292"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3404"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3402"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3514"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3512"
  return { s320 := BitVec.ofInt 8 v0, s321 := BitVec.ofInt 8 v1, s322 := BitVec.ofInt 8 v2, s323 := BitVec.ofInt 8 v3, s324 := BitVec.ofInt 8 v4, s325 := BitVec.ofInt 8 v5, s326 := BitVec.ofInt 8 v6, s327 := BitVec.ofInt 8 v7, s328 := BitVec.ofInt 8 v8, s329 := BitVec.ofInt 8 v9, s330 := BitVec.ofInt 8 v10, s331 := BitVec.ofInt 8 v11, s332 := BitVec.ofInt 8 v12, s333 := BitVec.ofInt 8 v13, s334 := BitVec.ofInt 8 v14, s335 := BitVec.ofInt 8 v15 }

def decodeStateGroup1Group5 (j : Lean.Json) : Except String StateGroup1Group5 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3624"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3622"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3734"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3732"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2264"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2262"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2374"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2372"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2484"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2482"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2594"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2592"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2704"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2702"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2814"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2812"
  return { s336 := BitVec.ofInt 8 v0, s337 := BitVec.ofInt 8 v1, s338 := BitVec.ofInt 8 v2, s339 := BitVec.ofInt 8 v3, s340 := BitVec.ofInt 8 v4, s341 := BitVec.ofInt 8 v5, s342 := BitVec.ofInt 8 v6, s343 := BitVec.ofInt 8 v7, s344 := BitVec.ofInt 8 v8, s345 := BitVec.ofInt 8 v9, s346 := BitVec.ofInt 8 v10, s347 := BitVec.ofInt 8 v11, s348 := BitVec.ofInt 8 v12, s349 := BitVec.ofInt 8 v13, s350 := BitVec.ofInt 8 v14, s351 := BitVec.ofInt 8 v15 }

def decodeStateGroup1Group6 (j : Lean.Json) : Except String StateGroup1Group6 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2924"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2922"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2934"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2932"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2944"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2942"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2954"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2952"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2974"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2972"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2984"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2982"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2994"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2992"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3004"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3002"
  return { s352 := BitVec.ofInt 8 v0, s353 := BitVec.ofInt 8 v1, s354 := BitVec.ofInt 8 v2, s355 := BitVec.ofInt 8 v3, s356 := BitVec.ofInt 8 v4, s357 := BitVec.ofInt 8 v5, s358 := BitVec.ofInt 8 v6, s359 := BitVec.ofInt 8 v7, s360 := BitVec.ofInt 8 v8, s361 := BitVec.ofInt 8 v9, s362 := BitVec.ofInt 8 v10, s363 := BitVec.ofInt 8 v11, s364 := BitVec.ofInt 8 v12, s365 := BitVec.ofInt 8 v13, s366 := BitVec.ofInt 8 v14, s367 := BitVec.ofInt 8 v15 }

def decodeStateGroup1Group7 (j : Lean.Json) : Except String StateGroup1Group7 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3014"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3012"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3024"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3022"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3034"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3032"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3044"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3042"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3054"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3052"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3064"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3062"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3084"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3082"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3094"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3092"
  return { s368 := BitVec.ofInt 8 v0, s369 := BitVec.ofInt 8 v1, s370 := BitVec.ofInt 8 v2, s371 := BitVec.ofInt 8 v3, s372 := BitVec.ofInt 8 v4, s373 := BitVec.ofInt 8 v5, s374 := BitVec.ofInt 8 v6, s375 := BitVec.ofInt 8 v7, s376 := BitVec.ofInt 8 v8, s377 := BitVec.ofInt 8 v9, s378 := BitVec.ofInt 8 v10, s379 := BitVec.ofInt 8 v11, s380 := BitVec.ofInt 8 v12, s381 := BitVec.ofInt 8 v13, s382 := BitVec.ofInt 8 v14, s383 := BitVec.ofInt 8 v15 }

def decodeStateGroup1Group8 (j : Lean.Json) : Except String StateGroup1Group8 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3104"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3102"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3114"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3112"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3124"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3122"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3134"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3132"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3144"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3142"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3154"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3152"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3164"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3162"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3174"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3172"
  return { s384 := BitVec.ofInt 8 v0, s385 := BitVec.ofInt 8 v1, s386 := BitVec.ofInt 8 v2, s387 := BitVec.ofInt 8 v3, s388 := BitVec.ofInt 8 v4, s389 := BitVec.ofInt 8 v5, s390 := BitVec.ofInt 8 v6, s391 := BitVec.ofInt 8 v7, s392 := BitVec.ofInt 8 v8, s393 := BitVec.ofInt 8 v9, s394 := BitVec.ofInt 8 v10, s395 := BitVec.ofInt 8 v11, s396 := BitVec.ofInt 8 v12, s397 := BitVec.ofInt 8 v13, s398 := BitVec.ofInt 8 v14, s399 := BitVec.ofInt 8 v15 }

def decodeStateGroup1Group9 (j : Lean.Json) : Except String StateGroup1Group9 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3194"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3192"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3204"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3202"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3214"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3212"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3224"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3222"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3234"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3232"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3244"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3242"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3254"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3252"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3264"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3262"
  return { s400 := BitVec.ofInt 8 v0, s401 := BitVec.ofInt 8 v1, s402 := BitVec.ofInt 8 v2, s403 := BitVec.ofInt 8 v3, s404 := BitVec.ofInt 8 v4, s405 := BitVec.ofInt 8 v5, s406 := BitVec.ofInt 8 v6, s407 := BitVec.ofInt 8 v7, s408 := BitVec.ofInt 8 v8, s409 := BitVec.ofInt 8 v9, s410 := BitVec.ofInt 8 v10, s411 := BitVec.ofInt 8 v11, s412 := BitVec.ofInt 8 v12, s413 := BitVec.ofInt 8 v13, s414 := BitVec.ofInt 8 v14, s415 := BitVec.ofInt 8 v15 }

def decodeStateGroup1Group10 (j : Lean.Json) : Except String StateGroup1Group10 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3274"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3272"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3284"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3282"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3304"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3302"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3314"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3312"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3324"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3322"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3334"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3332"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3344"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3342"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3354"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3352"
  return { s416 := BitVec.ofInt 8 v0, s417 := BitVec.ofInt 8 v1, s418 := BitVec.ofInt 8 v2, s419 := BitVec.ofInt 8 v3, s420 := BitVec.ofInt 8 v4, s421 := BitVec.ofInt 8 v5, s422 := BitVec.ofInt 8 v6, s423 := BitVec.ofInt 8 v7, s424 := BitVec.ofInt 8 v8, s425 := BitVec.ofInt 8 v9, s426 := BitVec.ofInt 8 v10, s427 := BitVec.ofInt 8 v11, s428 := BitVec.ofInt 8 v12, s429 := BitVec.ofInt 8 v13, s430 := BitVec.ofInt 8 v14, s431 := BitVec.ofInt 8 v15 }

def decodeStateGroup1Group11 (j : Lean.Json) : Except String StateGroup1Group11 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3364"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3362"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3374"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3372"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3384"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3382"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3394"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3392"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3414"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3412"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3424"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3422"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3434"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3432"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3444"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3442"
  return { s432 := BitVec.ofInt 8 v0, s433 := BitVec.ofInt 8 v1, s434 := BitVec.ofInt 8 v2, s435 := BitVec.ofInt 8 v3, s436 := BitVec.ofInt 8 v4, s437 := BitVec.ofInt 8 v5, s438 := BitVec.ofInt 8 v6, s439 := BitVec.ofInt 8 v7, s440 := BitVec.ofInt 8 v8, s441 := BitVec.ofInt 8 v9, s442 := BitVec.ofInt 8 v10, s443 := BitVec.ofInt 8 v11, s444 := BitVec.ofInt 8 v12, s445 := BitVec.ofInt 8 v13, s446 := BitVec.ofInt 8 v14, s447 := BitVec.ofInt 8 v15 }

def decodeStateGroup1Group12 (j : Lean.Json) : Except String StateGroup1Group12 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3454"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3452"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3464"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3462"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3474"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3472"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3484"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3482"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3494"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3492"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3504"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3502"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3524"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3522"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3534"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3532"
  return { s448 := BitVec.ofInt 8 v0, s449 := BitVec.ofInt 8 v1, s450 := BitVec.ofInt 8 v2, s451 := BitVec.ofInt 8 v3, s452 := BitVec.ofInt 8 v4, s453 := BitVec.ofInt 8 v5, s454 := BitVec.ofInt 8 v6, s455 := BitVec.ofInt 8 v7, s456 := BitVec.ofInt 8 v8, s457 := BitVec.ofInt 8 v9, s458 := BitVec.ofInt 8 v10, s459 := BitVec.ofInt 8 v11, s460 := BitVec.ofInt 8 v12, s461 := BitVec.ofInt 8 v13, s462 := BitVec.ofInt 8 v14, s463 := BitVec.ofInt 8 v15 }

def decodeStateGroup1Group13 (j : Lean.Json) : Except String StateGroup1Group13 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3544"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3542"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3554"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3552"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3564"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3562"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3574"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3572"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3584"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3582"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3594"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3592"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3604"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3602"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3614"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3612"
  return { s464 := BitVec.ofInt 8 v0, s465 := BitVec.ofInt 8 v1, s466 := BitVec.ofInt 8 v2, s467 := BitVec.ofInt 8 v3, s468 := BitVec.ofInt 8 v4, s469 := BitVec.ofInt 8 v5, s470 := BitVec.ofInt 8 v6, s471 := BitVec.ofInt 8 v7, s472 := BitVec.ofInt 8 v8, s473 := BitVec.ofInt 8 v9, s474 := BitVec.ofInt 8 v10, s475 := BitVec.ofInt 8 v11, s476 := BitVec.ofInt 8 v12, s477 := BitVec.ofInt 8 v13, s478 := BitVec.ofInt 8 v14, s479 := BitVec.ofInt 8 v15 }

def decodeStateGroup1Group14 (j : Lean.Json) : Except String StateGroup1Group14 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3634"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3632"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3644"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3642"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3654"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3652"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3664"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3662"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3674"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3672"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3684"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3682"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3694"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3692"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3704"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3702"
  return { s480 := BitVec.ofInt 8 v0, s481 := BitVec.ofInt 8 v1, s482 := BitVec.ofInt 8 v2, s483 := BitVec.ofInt 8 v3, s484 := BitVec.ofInt 8 v4, s485 := BitVec.ofInt 8 v5, s486 := BitVec.ofInt 8 v6, s487 := BitVec.ofInt 8 v7, s488 := BitVec.ofInt 8 v8, s489 := BitVec.ofInt 8 v9, s490 := BitVec.ofInt 8 v10, s491 := BitVec.ofInt 8 v11, s492 := BitVec.ofInt 8 v12, s493 := BitVec.ofInt 8 v13, s494 := BitVec.ofInt 8 v14, s495 := BitVec.ofInt 8 v15 }

def decodeStateGroup1Group15 (j : Lean.Json) : Except String StateGroup1Group15 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3714"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3712"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3724"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3722"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3744"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3742"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3754"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3752"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3764"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3762"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3774"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3772"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3784"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3782"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3794"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3792"
  return { s496 := BitVec.ofInt 8 v0, s497 := BitVec.ofInt 8 v1, s498 := BitVec.ofInt 8 v2, s499 := BitVec.ofInt 8 v3, s500 := BitVec.ofInt 8 v4, s501 := BitVec.ofInt 8 v5, s502 := BitVec.ofInt 8 v6, s503 := BitVec.ofInt 8 v7, s504 := BitVec.ofInt 8 v8, s505 := BitVec.ofInt 8 v9, s506 := BitVec.ofInt 8 v10, s507 := BitVec.ofInt 8 v11, s508 := BitVec.ofInt 8 v12, s509 := BitVec.ofInt 8 v13, s510 := BitVec.ofInt 8 v14, s511 := BitVec.ofInt 8 v15 }

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
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3804"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3802"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3814"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3812"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3824"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3822"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3834"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$3832"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2274"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2272"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2284"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2282"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2294"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2292"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2304"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2302"
  return { s512 := BitVec.ofInt 8 v0, s513 := BitVec.ofInt 8 v1, s514 := BitVec.ofInt 8 v2, s515 := BitVec.ofInt 8 v3, s516 := BitVec.ofInt 8 v4, s517 := BitVec.ofInt 8 v5, s518 := BitVec.ofInt 8 v6, s519 := BitVec.ofInt 8 v7, s520 := BitVec.ofInt 8 v8, s521 := BitVec.ofInt 8 v9, s522 := BitVec.ofInt 8 v10, s523 := BitVec.ofInt 8 v11, s524 := BitVec.ofInt 8 v12, s525 := BitVec.ofInt 8 v13, s526 := BitVec.ofInt 8 v14, s527 := BitVec.ofInt 8 v15 }

def decodeStateGroup2Group1 (j : Lean.Json) : Except String StateGroup2Group1 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2314"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2312"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2324"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2322"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2334"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2332"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2344"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2342"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2354"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2352"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2364"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2362"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2384"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2382"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2394"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2392"
  return { s528 := BitVec.ofInt 8 v0, s529 := BitVec.ofInt 8 v1, s530 := BitVec.ofInt 8 v2, s531 := BitVec.ofInt 8 v3, s532 := BitVec.ofInt 8 v4, s533 := BitVec.ofInt 8 v5, s534 := BitVec.ofInt 8 v6, s535 := BitVec.ofInt 8 v7, s536 := BitVec.ofInt 8 v8, s537 := BitVec.ofInt 8 v9, s538 := BitVec.ofInt 8 v10, s539 := BitVec.ofInt 8 v11, s540 := BitVec.ofInt 8 v12, s541 := BitVec.ofInt 8 v13, s542 := BitVec.ofInt 8 v14, s543 := BitVec.ofInt 8 v15 }

def decodeStateGroup2Group2 (j : Lean.Json) : Except String StateGroup2Group2 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2404"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2402"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2414"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2412"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2424"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2422"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2434"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2432"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2444"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2442"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2454"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2452"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2464"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2462"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2474"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2472"
  return { s544 := BitVec.ofInt 8 v0, s545 := BitVec.ofInt 8 v1, s546 := BitVec.ofInt 8 v2, s547 := BitVec.ofInt 8 v3, s548 := BitVec.ofInt 8 v4, s549 := BitVec.ofInt 8 v5, s550 := BitVec.ofInt 8 v6, s551 := BitVec.ofInt 8 v7, s552 := BitVec.ofInt 8 v8, s553 := BitVec.ofInt 8 v9, s554 := BitVec.ofInt 8 v10, s555 := BitVec.ofInt 8 v11, s556 := BitVec.ofInt 8 v12, s557 := BitVec.ofInt 8 v13, s558 := BitVec.ofInt 8 v14, s559 := BitVec.ofInt 8 v15 }

def decodeStateGroup2Group3 (j : Lean.Json) : Except String StateGroup2Group3 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2494"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2492"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2504"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2502"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2514"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2512"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2524"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2522"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2534"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2532"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2544"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2542"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2554"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2552"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2564"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2562"
  return { s560 := BitVec.ofInt 8 v0, s561 := BitVec.ofInt 8 v1, s562 := BitVec.ofInt 8 v2, s563 := BitVec.ofInt 8 v3, s564 := BitVec.ofInt 8 v4, s565 := BitVec.ofInt 8 v5, s566 := BitVec.ofInt 8 v6, s567 := BitVec.ofInt 8 v7, s568 := BitVec.ofInt 8 v8, s569 := BitVec.ofInt 8 v9, s570 := BitVec.ofInt 8 v10, s571 := BitVec.ofInt 8 v11, s572 := BitVec.ofInt 8 v12, s573 := BitVec.ofInt 8 v13, s574 := BitVec.ofInt 8 v14, s575 := BitVec.ofInt 8 v15 }

def decodeStateGroup2Group4 (j : Lean.Json) : Except String StateGroup2Group4 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2574"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2572"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2584"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2582"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2604"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2602"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2614"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2612"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2624"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2622"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2634"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2632"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2644"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2642"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2654"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2652"
  return { s576 := BitVec.ofInt 8 v0, s577 := BitVec.ofInt 8 v1, s578 := BitVec.ofInt 8 v2, s579 := BitVec.ofInt 8 v3, s580 := BitVec.ofInt 8 v4, s581 := BitVec.ofInt 8 v5, s582 := BitVec.ofInt 8 v6, s583 := BitVec.ofInt 8 v7, s584 := BitVec.ofInt 8 v8, s585 := BitVec.ofInt 8 v9, s586 := BitVec.ofInt 8 v10, s587 := BitVec.ofInt 8 v11, s588 := BitVec.ofInt 8 v12, s589 := BitVec.ofInt 8 v13, s590 := BitVec.ofInt 8 v14, s591 := BitVec.ofInt 8 v15 }

def decodeStateGroup2Group5 (j : Lean.Json) : Except String StateGroup2Group5 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2664"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2662"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2674"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2672"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2684"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2682"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2694"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2692"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2714"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2712"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2724"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2722"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2734"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2732"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2744"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2742"
  return { s592 := BitVec.ofInt 8 v0, s593 := BitVec.ofInt 8 v1, s594 := BitVec.ofInt 8 v2, s595 := BitVec.ofInt 8 v3, s596 := BitVec.ofInt 8 v4, s597 := BitVec.ofInt 8 v5, s598 := BitVec.ofInt 8 v6, s599 := BitVec.ofInt 8 v7, s600 := BitVec.ofInt 8 v8, s601 := BitVec.ofInt 8 v9, s602 := BitVec.ofInt 8 v10, s603 := BitVec.ofInt 8 v11, s604 := BitVec.ofInt 8 v12, s605 := BitVec.ofInt 8 v13, s606 := BitVec.ofInt 8 v14, s607 := BitVec.ofInt 8 v15 }

def decodeStateGroup2Group6 (j : Lean.Json) : Except String StateGroup2Group6 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2754"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2752"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2764"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2762"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2774"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2772"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2784"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2782"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2794"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2792"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2804"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2802"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2824"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2822"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2834"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2832"
  return { s608 := BitVec.ofInt 8 v0, s609 := BitVec.ofInt 8 v1, s610 := BitVec.ofInt 8 v2, s611 := BitVec.ofInt 8 v3, s612 := BitVec.ofInt 8 v4, s613 := BitVec.ofInt 8 v5, s614 := BitVec.ofInt 8 v6, s615 := BitVec.ofInt 8 v7, s616 := BitVec.ofInt 8 v8, s617 := BitVec.ofInt 8 v9, s618 := BitVec.ofInt 8 v10, s619 := BitVec.ofInt 8 v11, s620 := BitVec.ofInt 8 v12, s621 := BitVec.ofInt 8 v13, s622 := BitVec.ofInt 8 v14, s623 := BitVec.ofInt 8 v15 }

def decodeStateGroup2Group7 (j : Lean.Json) : Except String StateGroup2Group7 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2844"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2842"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2854"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2852"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2864"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2862"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2874"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2872"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2884"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2882"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2894"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2892"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2904"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2902"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2914"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2912"
  return { s624 := BitVec.ofInt 8 v0, s625 := BitVec.ofInt 8 v1, s626 := BitVec.ofInt 8 v2, s627 := BitVec.ofInt 8 v3, s628 := BitVec.ofInt 8 v4, s629 := BitVec.ofInt 8 v5, s630 := BitVec.ofInt 8 v6, s631 := BitVec.ofInt 8 v7, s632 := BitVec.ofInt 8 v8, s633 := BitVec.ofInt 8 v9, s634 := BitVec.ofInt 8 v10, s635 := BitVec.ofInt 8 v11, s636 := BitVec.ofInt 8 v12, s637 := BitVec.ofInt 8 v13, s638 := BitVec.ofInt 8 v14, s639 := BitVec.ofInt 8 v15 }

def decodeStateGroup2Group8 (j : Lean.Json) : Except String StateGroup2Group8 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$8"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$22"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$36"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$50"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$64"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$78"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$92"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$106"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$120"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$134"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$148"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$162"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$176"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$190"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$204"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$218"
  return { s640 := BitVec.ofInt 1 v0, s641 := BitVec.ofInt 1 v1, s642 := BitVec.ofInt 1 v2, s643 := BitVec.ofInt 1 v3, s644 := BitVec.ofInt 1 v4, s645 := BitVec.ofInt 1 v5, s646 := BitVec.ofInt 1 v6, s647 := BitVec.ofInt 1 v7, s648 := BitVec.ofInt 1 v8, s649 := BitVec.ofInt 1 v9, s650 := BitVec.ofInt 1 v10, s651 := BitVec.ofInt 1 v11, s652 := BitVec.ofInt 1 v12, s653 := BitVec.ofInt 1 v13, s654 := BitVec.ofInt 1 v14, s655 := BitVec.ofInt 1 v15 }

def decodeStateGroup2Group9 (j : Lean.Json) : Except String StateGroup2Group9 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$232"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$246"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$260"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$274"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$288"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$302"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$316"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$330"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$344"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$358"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$372"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$386"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$400"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$414"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$428"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$442"
  return { s656 := BitVec.ofInt 1 v0, s657 := BitVec.ofInt 1 v1, s658 := BitVec.ofInt 1 v2, s659 := BitVec.ofInt 1 v3, s660 := BitVec.ofInt 1 v4, s661 := BitVec.ofInt 1 v5, s662 := BitVec.ofInt 1 v6, s663 := BitVec.ofInt 1 v7, s664 := BitVec.ofInt 1 v8, s665 := BitVec.ofInt 1 v9, s666 := BitVec.ofInt 1 v10, s667 := BitVec.ofInt 1 v11, s668 := BitVec.ofInt 1 v12, s669 := BitVec.ofInt 1 v13, s670 := BitVec.ofInt 1 v14, s671 := BitVec.ofInt 1 v15 }

def decodeStateGroup2Group10 (j : Lean.Json) : Except String StateGroup2Group10 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$456"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$470"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$484"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$498"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$512"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$526"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$540"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$554"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$568"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$582"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$596"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$610"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$624"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$638"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$652"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$666"
  return { s672 := BitVec.ofInt 1 v0, s673 := BitVec.ofInt 1 v1, s674 := BitVec.ofInt 1 v2, s675 := BitVec.ofInt 1 v3, s676 := BitVec.ofInt 1 v4, s677 := BitVec.ofInt 1 v5, s678 := BitVec.ofInt 1 v6, s679 := BitVec.ofInt 1 v7, s680 := BitVec.ofInt 1 v8, s681 := BitVec.ofInt 1 v9, s682 := BitVec.ofInt 1 v10, s683 := BitVec.ofInt 1 v11, s684 := BitVec.ofInt 1 v12, s685 := BitVec.ofInt 1 v13, s686 := BitVec.ofInt 1 v14, s687 := BitVec.ofInt 1 v15 }

def decodeStateGroup2Group11 (j : Lean.Json) : Except String StateGroup2Group11 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$680"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$694"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$708"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$722"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$736"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$750"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$764"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$778"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$792"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$806"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$820"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$834"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$848"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$862"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$876"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$890"
  return { s688 := BitVec.ofInt 1 v0, s689 := BitVec.ofInt 1 v1, s690 := BitVec.ofInt 1 v2, s691 := BitVec.ofInt 1 v3, s692 := BitVec.ofInt 1 v4, s693 := BitVec.ofInt 1 v5, s694 := BitVec.ofInt 1 v6, s695 := BitVec.ofInt 1 v7, s696 := BitVec.ofInt 1 v8, s697 := BitVec.ofInt 1 v9, s698 := BitVec.ofInt 1 v10, s699 := BitVec.ofInt 1 v11, s700 := BitVec.ofInt 1 v12, s701 := BitVec.ofInt 1 v13, s702 := BitVec.ofInt 1 v14, s703 := BitVec.ofInt 1 v15 }

def decodeStateGroup2Group12 (j : Lean.Json) : Except String StateGroup2Group12 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$904"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$918"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$932"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$946"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$960"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$974"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$988"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1002"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1016"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1030"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1044"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1058"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1072"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1086"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1100"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1114"
  return { s704 := BitVec.ofInt 1 v0, s705 := BitVec.ofInt 1 v1, s706 := BitVec.ofInt 1 v2, s707 := BitVec.ofInt 1 v3, s708 := BitVec.ofInt 1 v4, s709 := BitVec.ofInt 1 v5, s710 := BitVec.ofInt 1 v6, s711 := BitVec.ofInt 1 v7, s712 := BitVec.ofInt 1 v8, s713 := BitVec.ofInt 1 v9, s714 := BitVec.ofInt 1 v10, s715 := BitVec.ofInt 1 v11, s716 := BitVec.ofInt 1 v12, s717 := BitVec.ofInt 1 v13, s718 := BitVec.ofInt 1 v14, s719 := BitVec.ofInt 1 v15 }

def decodeStateGroup2Group13 (j : Lean.Json) : Except String StateGroup2Group13 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1128"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1142"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1156"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1170"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1184"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1198"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1212"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1226"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1240"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1254"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1268"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1282"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1296"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1310"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1324"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1338"
  return { s720 := BitVec.ofInt 1 v0, s721 := BitVec.ofInt 1 v1, s722 := BitVec.ofInt 1 v2, s723 := BitVec.ofInt 1 v3, s724 := BitVec.ofInt 1 v4, s725 := BitVec.ofInt 1 v5, s726 := BitVec.ofInt 1 v6, s727 := BitVec.ofInt 1 v7, s728 := BitVec.ofInt 1 v8, s729 := BitVec.ofInt 1 v9, s730 := BitVec.ofInt 1 v10, s731 := BitVec.ofInt 1 v11, s732 := BitVec.ofInt 1 v12, s733 := BitVec.ofInt 1 v13, s734 := BitVec.ofInt 1 v14, s735 := BitVec.ofInt 1 v15 }

def decodeStateGroup2Group14 (j : Lean.Json) : Except String StateGroup2Group14 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1352"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1366"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1380"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1394"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1408"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1422"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1436"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1450"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1464"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1478"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1492"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1506"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1520"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1534"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1548"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1562"
  return { s736 := BitVec.ofInt 1 v0, s737 := BitVec.ofInt 1 v1, s738 := BitVec.ofInt 1 v2, s739 := BitVec.ofInt 1 v3, s740 := BitVec.ofInt 1 v4, s741 := BitVec.ofInt 1 v5, s742 := BitVec.ofInt 1 v6, s743 := BitVec.ofInt 1 v7, s744 := BitVec.ofInt 1 v8, s745 := BitVec.ofInt 1 v9, s746 := BitVec.ofInt 1 v10, s747 := BitVec.ofInt 1 v11, s748 := BitVec.ofInt 1 v12, s749 := BitVec.ofInt 1 v13, s750 := BitVec.ofInt 1 v14, s751 := BitVec.ofInt 1 v15 }

def decodeStateGroup2Group15 (j : Lean.Json) : Except String StateGroup2Group15 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1576"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1590"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1604"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1618"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1632"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1646"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1660"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1674"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1688"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1702"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1716"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1730"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1744"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1758"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1772"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1786"
  return { s752 := BitVec.ofInt 1 v0, s753 := BitVec.ofInt 1 v1, s754 := BitVec.ofInt 1 v2, s755 := BitVec.ofInt 1 v3, s756 := BitVec.ofInt 1 v4, s757 := BitVec.ofInt 1 v5, s758 := BitVec.ofInt 1 v6, s759 := BitVec.ofInt 1 v7, s760 := BitVec.ofInt 1 v8, s761 := BitVec.ofInt 1 v9, s762 := BitVec.ofInt 1 v10, s763 := BitVec.ofInt 1 v11, s764 := BitVec.ofInt 1 v12, s765 := BitVec.ofInt 1 v13, s766 := BitVec.ofInt 1 v14, s767 := BitVec.ofInt 1 v15 }

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
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1800"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1814"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1828"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1842"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1856"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1870"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1884"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1898"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1912"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1926"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1940"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1954"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1968"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1982"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1996"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2010"
  return { s768 := BitVec.ofInt 1 v0, s769 := BitVec.ofInt 1 v1, s770 := BitVec.ofInt 1 v2, s771 := BitVec.ofInt 1 v3, s772 := BitVec.ofInt 1 v4, s773 := BitVec.ofInt 1 v5, s774 := BitVec.ofInt 1 v6, s775 := BitVec.ofInt 1 v7, s776 := BitVec.ofInt 1 v8, s777 := BitVec.ofInt 1 v9, s778 := BitVec.ofInt 1 v10, s779 := BitVec.ofInt 1 v11, s780 := BitVec.ofInt 1 v12, s781 := BitVec.ofInt 1 v13, s782 := BitVec.ofInt 1 v14, s783 := BitVec.ofInt 1 v15 }

def decodeStateGroup3Group1 (j : Lean.Json) : Except String StateGroup3Group1 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2024"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2038"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2052"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2066"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2080"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2094"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2108"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2122"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2136"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2150"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2164"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2178"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2192"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2206"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2220"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2234"
  return { s784 := BitVec.ofInt 1 v0, s785 := BitVec.ofInt 1 v1, s786 := BitVec.ofInt 1 v2, s787 := BitVec.ofInt 1 v3, s788 := BitVec.ofInt 1 v4, s789 := BitVec.ofInt 1 v5, s790 := BitVec.ofInt 1 v6, s791 := BitVec.ofInt 1 v7, s792 := BitVec.ofInt 1 v8, s793 := BitVec.ofInt 1 v9, s794 := BitVec.ofInt 1 v10, s795 := BitVec.ofInt 1 v11, s796 := BitVec.ofInt 1 v12, s797 := BitVec.ofInt 1 v13, s798 := BitVec.ofInt 1 v14, s799 := BitVec.ofInt 1 v15 }

def decodeStateGroup3Group2 (j : Lean.Json) : Except String StateGroup3Group2 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$14"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$28"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$42"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$56"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$70"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$84"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$98"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$112"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$126"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$140"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$154"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$168"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$182"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$196"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$210"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$224"
  return { s800 := BitVec.ofInt 1 v0, s801 := BitVec.ofInt 1 v1, s802 := BitVec.ofInt 1 v2, s803 := BitVec.ofInt 1 v3, s804 := BitVec.ofInt 1 v4, s805 := BitVec.ofInt 1 v5, s806 := BitVec.ofInt 1 v6, s807 := BitVec.ofInt 1 v7, s808 := BitVec.ofInt 1 v8, s809 := BitVec.ofInt 1 v9, s810 := BitVec.ofInt 1 v10, s811 := BitVec.ofInt 1 v11, s812 := BitVec.ofInt 1 v12, s813 := BitVec.ofInt 1 v13, s814 := BitVec.ofInt 1 v14, s815 := BitVec.ofInt 1 v15 }

def decodeStateGroup3Group3 (j : Lean.Json) : Except String StateGroup3Group3 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$238"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$252"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$266"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$280"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$294"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$308"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$322"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$336"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$350"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$364"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$378"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$392"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$406"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$420"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$434"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$448"
  return { s816 := BitVec.ofInt 1 v0, s817 := BitVec.ofInt 1 v1, s818 := BitVec.ofInt 1 v2, s819 := BitVec.ofInt 1 v3, s820 := BitVec.ofInt 1 v4, s821 := BitVec.ofInt 1 v5, s822 := BitVec.ofInt 1 v6, s823 := BitVec.ofInt 1 v7, s824 := BitVec.ofInt 1 v8, s825 := BitVec.ofInt 1 v9, s826 := BitVec.ofInt 1 v10, s827 := BitVec.ofInt 1 v11, s828 := BitVec.ofInt 1 v12, s829 := BitVec.ofInt 1 v13, s830 := BitVec.ofInt 1 v14, s831 := BitVec.ofInt 1 v15 }

def decodeStateGroup3Group4 (j : Lean.Json) : Except String StateGroup3Group4 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$462"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$476"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$490"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$504"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$518"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$532"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$546"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$560"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$574"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$588"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$602"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$616"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$630"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$644"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$658"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$672"
  return { s832 := BitVec.ofInt 1 v0, s833 := BitVec.ofInt 1 v1, s834 := BitVec.ofInt 1 v2, s835 := BitVec.ofInt 1 v3, s836 := BitVec.ofInt 1 v4, s837 := BitVec.ofInt 1 v5, s838 := BitVec.ofInt 1 v6, s839 := BitVec.ofInt 1 v7, s840 := BitVec.ofInt 1 v8, s841 := BitVec.ofInt 1 v9, s842 := BitVec.ofInt 1 v10, s843 := BitVec.ofInt 1 v11, s844 := BitVec.ofInt 1 v12, s845 := BitVec.ofInt 1 v13, s846 := BitVec.ofInt 1 v14, s847 := BitVec.ofInt 1 v15 }

def decodeStateGroup3Group5 (j : Lean.Json) : Except String StateGroup3Group5 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$686"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$700"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$714"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$728"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$742"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$756"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$770"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$784"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$798"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$812"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$826"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$840"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$854"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$868"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$882"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$896"
  return { s848 := BitVec.ofInt 1 v0, s849 := BitVec.ofInt 1 v1, s850 := BitVec.ofInt 1 v2, s851 := BitVec.ofInt 1 v3, s852 := BitVec.ofInt 1 v4, s853 := BitVec.ofInt 1 v5, s854 := BitVec.ofInt 1 v6, s855 := BitVec.ofInt 1 v7, s856 := BitVec.ofInt 1 v8, s857 := BitVec.ofInt 1 v9, s858 := BitVec.ofInt 1 v10, s859 := BitVec.ofInt 1 v11, s860 := BitVec.ofInt 1 v12, s861 := BitVec.ofInt 1 v13, s862 := BitVec.ofInt 1 v14, s863 := BitVec.ofInt 1 v15 }

def decodeStateGroup3Group6 (j : Lean.Json) : Except String StateGroup3Group6 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$910"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$924"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$938"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$952"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$966"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$980"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$994"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1008"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1022"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1036"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1050"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1064"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1078"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1092"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1106"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1120"
  return { s864 := BitVec.ofInt 1 v0, s865 := BitVec.ofInt 1 v1, s866 := BitVec.ofInt 1 v2, s867 := BitVec.ofInt 1 v3, s868 := BitVec.ofInt 1 v4, s869 := BitVec.ofInt 1 v5, s870 := BitVec.ofInt 1 v6, s871 := BitVec.ofInt 1 v7, s872 := BitVec.ofInt 1 v8, s873 := BitVec.ofInt 1 v9, s874 := BitVec.ofInt 1 v10, s875 := BitVec.ofInt 1 v11, s876 := BitVec.ofInt 1 v12, s877 := BitVec.ofInt 1 v13, s878 := BitVec.ofInt 1 v14, s879 := BitVec.ofInt 1 v15 }

def decodeStateGroup3Group7 (j : Lean.Json) : Except String StateGroup3Group7 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1134"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1148"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1162"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1176"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1190"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1204"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1218"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1232"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1246"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1260"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1274"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1288"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1302"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1316"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1330"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1344"
  return { s880 := BitVec.ofInt 1 v0, s881 := BitVec.ofInt 1 v1, s882 := BitVec.ofInt 1 v2, s883 := BitVec.ofInt 1 v3, s884 := BitVec.ofInt 1 v4, s885 := BitVec.ofInt 1 v5, s886 := BitVec.ofInt 1 v6, s887 := BitVec.ofInt 1 v7, s888 := BitVec.ofInt 1 v8, s889 := BitVec.ofInt 1 v9, s890 := BitVec.ofInt 1 v10, s891 := BitVec.ofInt 1 v11, s892 := BitVec.ofInt 1 v12, s893 := BitVec.ofInt 1 v13, s894 := BitVec.ofInt 1 v14, s895 := BitVec.ofInt 1 v15 }

def decodeStateGroup3Group8 (j : Lean.Json) : Except String StateGroup3Group8 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1358"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1372"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1386"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1400"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1414"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1428"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1442"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1456"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1470"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1484"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1498"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1512"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1526"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1540"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1554"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1568"
  return { s896 := BitVec.ofInt 1 v0, s897 := BitVec.ofInt 1 v1, s898 := BitVec.ofInt 1 v2, s899 := BitVec.ofInt 1 v3, s900 := BitVec.ofInt 1 v4, s901 := BitVec.ofInt 1 v5, s902 := BitVec.ofInt 1 v6, s903 := BitVec.ofInt 1 v7, s904 := BitVec.ofInt 1 v8, s905 := BitVec.ofInt 1 v9, s906 := BitVec.ofInt 1 v10, s907 := BitVec.ofInt 1 v11, s908 := BitVec.ofInt 1 v12, s909 := BitVec.ofInt 1 v13, s910 := BitVec.ofInt 1 v14, s911 := BitVec.ofInt 1 v15 }

def decodeStateGroup3Group9 (j : Lean.Json) : Except String StateGroup3Group9 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1582"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1596"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1610"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1624"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1638"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1652"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1666"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1680"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1694"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1708"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1722"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1736"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1750"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1764"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1778"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1792"
  return { s912 := BitVec.ofInt 1 v0, s913 := BitVec.ofInt 1 v1, s914 := BitVec.ofInt 1 v2, s915 := BitVec.ofInt 1 v3, s916 := BitVec.ofInt 1 v4, s917 := BitVec.ofInt 1 v5, s918 := BitVec.ofInt 1 v6, s919 := BitVec.ofInt 1 v7, s920 := BitVec.ofInt 1 v8, s921 := BitVec.ofInt 1 v9, s922 := BitVec.ofInt 1 v10, s923 := BitVec.ofInt 1 v11, s924 := BitVec.ofInt 1 v12, s925 := BitVec.ofInt 1 v13, s926 := BitVec.ofInt 1 v14, s927 := BitVec.ofInt 1 v15 }

def decodeStateGroup3Group10 (j : Lean.Json) : Except String StateGroup3Group10 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1806"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1820"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1834"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1848"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1862"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1876"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1890"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1904"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1918"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1932"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1946"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1960"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1974"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$1988"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2002"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2016"
  return { s928 := BitVec.ofInt 1 v0, s929 := BitVec.ofInt 1 v1, s930 := BitVec.ofInt 1 v2, s931 := BitVec.ofInt 1 v3, s932 := BitVec.ofInt 1 v4, s933 := BitVec.ofInt 1 v5, s934 := BitVec.ofInt 1 v6, s935 := BitVec.ofInt 1 v7, s936 := BitVec.ofInt 1 v8, s937 := BitVec.ofInt 1 v9, s938 := BitVec.ofInt 1 v10, s939 := BitVec.ofInt 1 v11, s940 := BitVec.ofInt 1 v12, s941 := BitVec.ofInt 1 v13, s942 := BitVec.ofInt 1 v14, s943 := BitVec.ofInt 1 v15 }

def decodeStateGroup3Group11 (j : Lean.Json) : Except String StateGroup3Group11 := do
  let v0 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2030"
  let v1 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2044"
  let v2 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2058"
  let v3 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2072"
  let v4 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2086"
  let v5 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2100"
  let v6 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2114"
  let v7 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2128"
  let v8 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2142"
  let v9 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2156"
  let v10 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2170"
  let v11 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2184"
  let v12 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2198"
  let v13 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2212"
  let v14 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2226"
  let v15 ← j.getObjValAs? Int "$auto$clk2fflogic.cc:108:sample_data$2240"
  return { s944 := BitVec.ofInt 1 v0, s945 := BitVec.ofInt 1 v1, s946 := BitVec.ofInt 1 v2, s947 := BitVec.ofInt 1 v3, s948 := BitVec.ofInt 1 v4, s949 := BitVec.ofInt 1 v5, s950 := BitVec.ofInt 1 v6, s951 := BitVec.ofInt 1 v7, s952 := BitVec.ofInt 1 v8, s953 := BitVec.ofInt 1 v9, s954 := BitVec.ofInt 1 v10, s955 := BitVec.ofInt 1 v11, s956 := BitVec.ofInt 1 v12, s957 := BitVec.ofInt 1 v13, s958 := BitVec.ofInt 1 v14, s959 := BitVec.ofInt 1 v15 }

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

  return { g0 := g0, g1 := g1, g2 := g2, g3 := g3, g4 := g4, g5 := g5, g6 := g6, g7 := g7, g8 := g8, g9 := g9, g10 := g10, g11 := g11 }

def decodeState (j : Lean.Json) : Except String State := do

  let g0 ← decodeStateGroup0 j

  let g1 ← decodeStateGroup1 j

  let g2 ← decodeStateGroup2 j

  let g3 ← decodeStateGroup3 j

  return { g0 := g0, g1 := g1, g2 := g2, g3 := g3 }
def encodeOutputs (o : Outputs) : Lean.Json := Lean.Json.mkObj [("q0", Lean.toJson o.g0.g0.o0.toNat), ("q1", Lean.toJson o.g0.g0.o1.toNat), ("q2", Lean.toJson o.g0.g0.o2.toNat), ("q3", Lean.toJson o.g0.g0.o3.toNat), ("q4", Lean.toJson o.g0.g0.o4.toNat), ("q5", Lean.toJson o.g0.g0.o5.toNat), ("q6", Lean.toJson o.g0.g0.o6.toNat), ("q7", Lean.toJson o.g0.g0.o7.toNat), ("q8", Lean.toJson o.g0.g0.o8.toNat), ("q9", Lean.toJson o.g0.g0.o9.toNat), ("q10", Lean.toJson o.g0.g0.o10.toNat), ("q11", Lean.toJson o.g0.g0.o11.toNat), ("q12", Lean.toJson o.g0.g0.o12.toNat), ("q13", Lean.toJson o.g0.g0.o13.toNat), ("q14", Lean.toJson o.g0.g0.o14.toNat), ("q15", Lean.toJson o.g0.g0.o15.toNat), ("q16", Lean.toJson o.g0.g1.o16.toNat), ("q17", Lean.toJson o.g0.g1.o17.toNat), ("q18", Lean.toJson o.g0.g1.o18.toNat), ("q19", Lean.toJson o.g0.g1.o19.toNat), ("q20", Lean.toJson o.g0.g1.o20.toNat), ("q21", Lean.toJson o.g0.g1.o21.toNat), ("q22", Lean.toJson o.g0.g1.o22.toNat), ("q23", Lean.toJson o.g0.g1.o23.toNat), ("q24", Lean.toJson o.g0.g1.o24.toNat), ("q25", Lean.toJson o.g0.g1.o25.toNat), ("q26", Lean.toJson o.g0.g1.o26.toNat), ("q27", Lean.toJson o.g0.g1.o27.toNat), ("q28", Lean.toJson o.g0.g1.o28.toNat), ("q29", Lean.toJson o.g0.g1.o29.toNat), ("q30", Lean.toJson o.g0.g1.o30.toNat), ("q31", Lean.toJson o.g0.g1.o31.toNat), ("q32", Lean.toJson o.g0.g2.o32.toNat), ("q33", Lean.toJson o.g0.g2.o33.toNat), ("q34", Lean.toJson o.g0.g2.o34.toNat), ("q35", Lean.toJson o.g0.g2.o35.toNat), ("q36", Lean.toJson o.g0.g2.o36.toNat), ("q37", Lean.toJson o.g0.g2.o37.toNat), ("q38", Lean.toJson o.g0.g2.o38.toNat), ("q39", Lean.toJson o.g0.g2.o39.toNat), ("q40", Lean.toJson o.g0.g2.o40.toNat), ("q41", Lean.toJson o.g0.g2.o41.toNat), ("q42", Lean.toJson o.g0.g2.o42.toNat), ("q43", Lean.toJson o.g0.g2.o43.toNat), ("q44", Lean.toJson o.g0.g2.o44.toNat), ("q45", Lean.toJson o.g0.g2.o45.toNat), ("q46", Lean.toJson o.g0.g2.o46.toNat), ("q47", Lean.toJson o.g0.g2.o47.toNat), ("q48", Lean.toJson o.g0.g3.o48.toNat), ("q49", Lean.toJson o.g0.g3.o49.toNat), ("q50", Lean.toJson o.g0.g3.o50.toNat), ("q51", Lean.toJson o.g0.g3.o51.toNat), ("q52", Lean.toJson o.g0.g3.o52.toNat), ("q53", Lean.toJson o.g0.g3.o53.toNat), ("q54", Lean.toJson o.g0.g3.o54.toNat), ("q55", Lean.toJson o.g0.g3.o55.toNat), ("q56", Lean.toJson o.g0.g3.o56.toNat), ("q57", Lean.toJson o.g0.g3.o57.toNat), ("q58", Lean.toJson o.g0.g3.o58.toNat), ("q59", Lean.toJson o.g0.g3.o59.toNat), ("q60", Lean.toJson o.g0.g3.o60.toNat), ("q61", Lean.toJson o.g0.g3.o61.toNat), ("q62", Lean.toJson o.g0.g3.o62.toNat), ("q63", Lean.toJson o.g0.g3.o63.toNat), ("q64", Lean.toJson o.g0.g4.o64.toNat), ("q65", Lean.toJson o.g0.g4.o65.toNat), ("q66", Lean.toJson o.g0.g4.o66.toNat), ("q67", Lean.toJson o.g0.g4.o67.toNat), ("q68", Lean.toJson o.g0.g4.o68.toNat), ("q69", Lean.toJson o.g0.g4.o69.toNat), ("q70", Lean.toJson o.g0.g4.o70.toNat), ("q71", Lean.toJson o.g0.g4.o71.toNat), ("q72", Lean.toJson o.g0.g4.o72.toNat), ("q73", Lean.toJson o.g0.g4.o73.toNat), ("q74", Lean.toJson o.g0.g4.o74.toNat), ("q75", Lean.toJson o.g0.g4.o75.toNat), ("q76", Lean.toJson o.g0.g4.o76.toNat), ("q77", Lean.toJson o.g0.g4.o77.toNat), ("q78", Lean.toJson o.g0.g4.o78.toNat), ("q79", Lean.toJson o.g0.g4.o79.toNat), ("q80", Lean.toJson o.g0.g5.o80.toNat), ("q81", Lean.toJson o.g0.g5.o81.toNat), ("q82", Lean.toJson o.g0.g5.o82.toNat), ("q83", Lean.toJson o.g0.g5.o83.toNat), ("q84", Lean.toJson o.g0.g5.o84.toNat), ("q85", Lean.toJson o.g0.g5.o85.toNat), ("q86", Lean.toJson o.g0.g5.o86.toNat), ("q87", Lean.toJson o.g0.g5.o87.toNat), ("q88", Lean.toJson o.g0.g5.o88.toNat), ("q89", Lean.toJson o.g0.g5.o89.toNat), ("q90", Lean.toJson o.g0.g5.o90.toNat), ("q91", Lean.toJson o.g0.g5.o91.toNat), ("q92", Lean.toJson o.g0.g5.o92.toNat), ("q93", Lean.toJson o.g0.g5.o93.toNat), ("q94", Lean.toJson o.g0.g5.o94.toNat), ("q95", Lean.toJson o.g0.g5.o95.toNat), ("q96", Lean.toJson o.g0.g6.o96.toNat), ("q97", Lean.toJson o.g0.g6.o97.toNat), ("q98", Lean.toJson o.g0.g6.o98.toNat), ("q99", Lean.toJson o.g0.g6.o99.toNat), ("q100", Lean.toJson o.g0.g6.o100.toNat), ("q101", Lean.toJson o.g0.g6.o101.toNat), ("q102", Lean.toJson o.g0.g6.o102.toNat), ("q103", Lean.toJson o.g0.g6.o103.toNat), ("q104", Lean.toJson o.g0.g6.o104.toNat), ("q105", Lean.toJson o.g0.g6.o105.toNat), ("q106", Lean.toJson o.g0.g6.o106.toNat), ("q107", Lean.toJson o.g0.g6.o107.toNat), ("q108", Lean.toJson o.g0.g6.o108.toNat), ("q109", Lean.toJson o.g0.g6.o109.toNat), ("q110", Lean.toJson o.g0.g6.o110.toNat), ("q111", Lean.toJson o.g0.g6.o111.toNat), ("q112", Lean.toJson o.g0.g7.o112.toNat), ("q113", Lean.toJson o.g0.g7.o113.toNat), ("q114", Lean.toJson o.g0.g7.o114.toNat), ("q115", Lean.toJson o.g0.g7.o115.toNat), ("q116", Lean.toJson o.g0.g7.o116.toNat), ("q117", Lean.toJson o.g0.g7.o117.toNat), ("q118", Lean.toJson o.g0.g7.o118.toNat), ("q119", Lean.toJson o.g0.g7.o119.toNat), ("q120", Lean.toJson o.g0.g7.o120.toNat), ("q121", Lean.toJson o.g0.g7.o121.toNat), ("q122", Lean.toJson o.g0.g7.o122.toNat), ("q123", Lean.toJson o.g0.g7.o123.toNat), ("q124", Lean.toJson o.g0.g7.o124.toNat), ("q125", Lean.toJson o.g0.g7.o125.toNat), ("q126", Lean.toJson o.g0.g7.o126.toNat), ("q127", Lean.toJson o.g0.g7.o127.toNat), ("q128", Lean.toJson o.g0.g8.o128.toNat), ("q129", Lean.toJson o.g0.g8.o129.toNat), ("q130", Lean.toJson o.g0.g8.o130.toNat), ("q131", Lean.toJson o.g0.g8.o131.toNat), ("q132", Lean.toJson o.g0.g8.o132.toNat), ("q133", Lean.toJson o.g0.g8.o133.toNat), ("q134", Lean.toJson o.g0.g8.o134.toNat), ("q135", Lean.toJson o.g0.g8.o135.toNat), ("q136", Lean.toJson o.g0.g8.o136.toNat), ("q137", Lean.toJson o.g0.g8.o137.toNat), ("q138", Lean.toJson o.g0.g8.o138.toNat), ("q139", Lean.toJson o.g0.g8.o139.toNat), ("q140", Lean.toJson o.g0.g8.o140.toNat), ("q141", Lean.toJson o.g0.g8.o141.toNat), ("q142", Lean.toJson o.g0.g8.o142.toNat), ("q143", Lean.toJson o.g0.g8.o143.toNat), ("q144", Lean.toJson o.g0.g9.o144.toNat), ("q145", Lean.toJson o.g0.g9.o145.toNat), ("q146", Lean.toJson o.g0.g9.o146.toNat), ("q147", Lean.toJson o.g0.g9.o147.toNat), ("q148", Lean.toJson o.g0.g9.o148.toNat), ("q149", Lean.toJson o.g0.g9.o149.toNat), ("q150", Lean.toJson o.g0.g9.o150.toNat), ("q151", Lean.toJson o.g0.g9.o151.toNat), ("q152", Lean.toJson o.g0.g9.o152.toNat), ("q153", Lean.toJson o.g0.g9.o153.toNat), ("q154", Lean.toJson o.g0.g9.o154.toNat), ("q155", Lean.toJson o.g0.g9.o155.toNat), ("q156", Lean.toJson o.g0.g9.o156.toNat), ("q157", Lean.toJson o.g0.g9.o157.toNat), ("q158", Lean.toJson o.g0.g9.o158.toNat), ("q159", Lean.toJson o.g0.g9.o159.toNat)]
def checkEffects (r : Evaluation) : IO Unit := do
  if r.outputs.g0.g10.o160 != 0 && r.outputs.g0.g10.o161 == 0 then
    throw (IO.userError "assert failed at work/design.v:465.101-465.127")
  if r.outputs.g0.g10.o162 != 0 && r.outputs.g0.g10.o163 == 0 then
    throw (IO.userError "assert failed at work/design.v:466.101-466.127")
  if r.outputs.g0.g10.o164 != 0 && r.outputs.g0.g10.o165 == 0 then
    throw (IO.userError "assert failed at work/design.v:467.101-467.127")
  if r.outputs.g0.g10.o166 != 0 && r.outputs.g0.g10.o167 == 0 then
    throw (IO.userError "assert failed at work/design.v:336.97-336.121")
  if r.outputs.g0.g10.o168 != 0 && r.outputs.g0.g10.o169 == 0 then
    throw (IO.userError "assert failed at work/design.v:468.101-468.127")
  if r.outputs.g0.g10.o170 != 0 && r.outputs.g0.g10.o171 == 0 then
    throw (IO.userError "assert failed at work/design.v:469.101-469.127")
  if r.outputs.g0.g10.o172 != 0 && r.outputs.g0.g10.o173 == 0 then
    throw (IO.userError "assert failed at work/design.v:470.101-470.127")
  if r.outputs.g0.g10.o174 != 0 && r.outputs.g0.g10.o175 == 0 then
    throw (IO.userError "assert failed at work/design.v:471.101-471.127")
  if r.outputs.g0.g11.o176 != 0 && r.outputs.g0.g11.o177 == 0 then
    throw (IO.userError "assert failed at work/design.v:472.101-472.127")
  if r.outputs.g0.g11.o178 != 0 && r.outputs.g0.g11.o179 == 0 then
    throw (IO.userError "assert failed at work/design.v:473.101-473.127")
  if r.outputs.g0.g11.o180 != 0 && r.outputs.g0.g11.o181 == 0 then
    throw (IO.userError "assert failed at work/design.v:474.101-474.127")
  if r.outputs.g0.g11.o182 != 0 && r.outputs.g0.g11.o183 == 0 then
    throw (IO.userError "assert failed at work/design.v:475.101-475.127")
  if r.outputs.g0.g11.o184 != 0 && r.outputs.g0.g11.o185 == 0 then
    throw (IO.userError "assert failed at work/design.v:476.101-476.127")
  if r.outputs.g0.g11.o186 != 0 && r.outputs.g0.g11.o187 == 0 then
    throw (IO.userError "assert failed at work/design.v:477.101-477.127")
  if r.outputs.g0.g11.o188 != 0 && r.outputs.g0.g11.o189 == 0 then
    throw (IO.userError "assert failed at work/design.v:337.97-337.121")
  if r.outputs.g0.g11.o190 != 0 && r.outputs.g0.g11.o191 == 0 then
    throw (IO.userError "assert failed at work/design.v:478.101-478.127")
  if r.outputs.g0.g12.o192 != 0 && r.outputs.g0.g12.o193 == 0 then
    throw (IO.userError "assert failed at work/design.v:323.93-323.115")
  if r.outputs.g0.g12.o194 != 0 && r.outputs.g0.g12.o195 == 0 then
    throw (IO.userError "assert failed at work/design.v:479.101-479.127")
  if r.outputs.g0.g12.o196 != 0 && r.outputs.g0.g12.o197 == 0 then
    throw (IO.userError "assert failed at work/design.v:480.101-480.127")
  if r.outputs.g0.g12.o198 != 0 && r.outputs.g0.g12.o199 == 0 then
    throw (IO.userError "assert failed at work/design.v:481.101-481.127")
  if r.outputs.g0.g12.o200 != 0 && r.outputs.g0.g12.o201 == 0 then
    throw (IO.userError "assert failed at work/design.v:338.97-338.121")
  if r.outputs.g0.g12.o202 != 0 && r.outputs.g0.g12.o203 == 0 then
    throw (IO.userError "assert failed at work/design.v:339.97-339.121")
  if r.outputs.g0.g12.o204 != 0 && r.outputs.g0.g12.o205 == 0 then
    throw (IO.userError "assert failed at work/design.v:340.97-340.121")
  if r.outputs.g0.g12.o206 != 0 && r.outputs.g0.g12.o207 == 0 then
    throw (IO.userError "assert failed at work/design.v:341.97-341.121")
  if r.outputs.g0.g13.o208 != 0 && r.outputs.g0.g13.o209 == 0 then
    throw (IO.userError "assert failed at work/design.v:342.97-342.121")
  if r.outputs.g0.g13.o210 != 0 && r.outputs.g0.g13.o211 == 0 then
    throw (IO.userError "assert failed at work/design.v:343.97-343.121")
  if r.outputs.g0.g13.o212 != 0 && r.outputs.g0.g13.o213 == 0 then
    throw (IO.userError "assert failed at work/design.v:344.97-344.121")
  if r.outputs.g0.g13.o214 != 0 && r.outputs.g0.g13.o215 == 0 then
    throw (IO.userError "assert failed at work/design.v:345.97-345.121")
  if r.outputs.g0.g13.o216 != 0 && r.outputs.g0.g13.o217 == 0 then
    throw (IO.userError "assert failed at work/design.v:346.97-346.121")
  if r.outputs.g0.g13.o218 != 0 && r.outputs.g0.g13.o219 == 0 then
    throw (IO.userError "assert failed at work/design.v:347.97-347.121")
  if r.outputs.g0.g13.o220 != 0 && r.outputs.g0.g13.o221 == 0 then
    throw (IO.userError "assert failed at work/design.v:324.93-324.115")
  if r.outputs.g0.g13.o222 != 0 && r.outputs.g0.g13.o223 == 0 then
    throw (IO.userError "assert failed at work/design.v:348.97-348.121")
  if r.outputs.g0.g14.o224 != 0 && r.outputs.g0.g14.o225 == 0 then
    throw (IO.userError "assert failed at work/design.v:349.97-349.121")
  if r.outputs.g0.g14.o226 != 0 && r.outputs.g0.g14.o227 == 0 then
    throw (IO.userError "assert failed at work/design.v:350.97-350.121")
  if r.outputs.g0.g14.o228 != 0 && r.outputs.g0.g14.o229 == 0 then
    throw (IO.userError "assert failed at work/design.v:351.97-351.121")
  if r.outputs.g0.g14.o230 != 0 && r.outputs.g0.g14.o231 == 0 then
    throw (IO.userError "assert failed at work/design.v:352.97-352.121")
  if r.outputs.g0.g14.o232 != 0 && r.outputs.g0.g14.o233 == 0 then
    throw (IO.userError "assert failed at work/design.v:353.97-353.121")
  if r.outputs.g0.g14.o234 != 0 && r.outputs.g0.g14.o235 == 0 then
    throw (IO.userError "assert failed at work/design.v:354.97-354.121")
  if r.outputs.g0.g14.o236 != 0 && r.outputs.g0.g14.o237 == 0 then
    throw (IO.userError "assert failed at work/design.v:355.97-355.121")
  if r.outputs.g0.g14.o238 != 0 && r.outputs.g0.g14.o239 == 0 then
    throw (IO.userError "assert failed at work/design.v:356.97-356.121")
  if r.outputs.g0.g15.o240 != 0 && r.outputs.g0.g15.o241 == 0 then
    throw (IO.userError "assert failed at work/design.v:357.97-357.121")
  if r.outputs.g0.g15.o242 != 0 && r.outputs.g0.g15.o243 == 0 then
    throw (IO.userError "assert failed at work/design.v:325.93-325.115")
  if r.outputs.g0.g15.o244 != 0 && r.outputs.g0.g15.o245 == 0 then
    throw (IO.userError "assert failed at work/design.v:358.97-358.121")
  if r.outputs.g0.g15.o246 != 0 && r.outputs.g0.g15.o247 == 0 then
    throw (IO.userError "assert failed at work/design.v:359.97-359.121")
  if r.outputs.g0.g15.o248 != 0 && r.outputs.g0.g15.o249 == 0 then
    throw (IO.userError "assert failed at work/design.v:360.97-360.121")
  if r.outputs.g0.g15.o250 != 0 && r.outputs.g0.g15.o251 == 0 then
    throw (IO.userError "assert failed at work/design.v:361.97-361.121")
  if r.outputs.g0.g15.o252 != 0 && r.outputs.g0.g15.o253 == 0 then
    throw (IO.userError "assert failed at work/design.v:362.97-362.121")
  if r.outputs.g0.g15.o254 != 0 && r.outputs.g0.g15.o255 == 0 then
    throw (IO.userError "assert failed at work/design.v:363.97-363.121")
  if r.outputs.g1.g0.o256 != 0 && r.outputs.g1.g0.o257 == 0 then
    throw (IO.userError "assert failed at work/design.v:364.97-364.121")
  if r.outputs.g1.g0.o258 != 0 && r.outputs.g1.g0.o259 == 0 then
    throw (IO.userError "assert failed at work/design.v:365.97-365.121")
  if r.outputs.g1.g0.o260 != 0 && r.outputs.g1.g0.o261 == 0 then
    throw (IO.userError "assert failed at work/design.v:366.97-366.121")
  if r.outputs.g1.g0.o262 != 0 && r.outputs.g1.g0.o263 == 0 then
    throw (IO.userError "assert failed at work/design.v:367.97-367.121")
  if r.outputs.g1.g0.o264 != 0 && r.outputs.g1.g0.o265 == 0 then
    throw (IO.userError "assert failed at work/design.v:326.93-326.115")
  if r.outputs.g1.g0.o266 != 0 && r.outputs.g1.g0.o267 == 0 then
    throw (IO.userError "assert failed at work/design.v:368.97-368.121")
  if r.outputs.g1.g0.o268 != 0 && r.outputs.g1.g0.o269 == 0 then
    throw (IO.userError "assert failed at work/design.v:369.97-369.121")
  if r.outputs.g1.g0.o270 != 0 && r.outputs.g1.g0.o271 == 0 then
    throw (IO.userError "assert failed at work/design.v:370.97-370.121")
  if r.outputs.g1.g1.o272 != 0 && r.outputs.g1.g1.o273 == 0 then
    throw (IO.userError "assert failed at work/design.v:371.97-371.121")
  if r.outputs.g1.g1.o274 != 0 && r.outputs.g1.g1.o275 == 0 then
    throw (IO.userError "assert failed at work/design.v:372.97-372.121")
  if r.outputs.g1.g1.o276 != 0 && r.outputs.g1.g1.o277 == 0 then
    throw (IO.userError "assert failed at work/design.v:373.97-373.121")
  if r.outputs.g1.g1.o278 != 0 && r.outputs.g1.g1.o279 == 0 then
    throw (IO.userError "assert failed at work/design.v:374.97-374.121")
  if r.outputs.g1.g1.o280 != 0 && r.outputs.g1.g1.o281 == 0 then
    throw (IO.userError "assert failed at work/design.v:375.97-375.121")
  if r.outputs.g1.g1.o282 != 0 && r.outputs.g1.g1.o283 == 0 then
    throw (IO.userError "assert failed at work/design.v:376.97-376.121")
  if r.outputs.g1.g1.o284 != 0 && r.outputs.g1.g1.o285 == 0 then
    throw (IO.userError "assert failed at work/design.v:377.97-377.121")
  if r.outputs.g1.g1.o286 != 0 && r.outputs.g1.g1.o287 == 0 then
    throw (IO.userError "assert failed at work/design.v:327.93-327.115")
  if r.outputs.g1.g2.o288 != 0 && r.outputs.g1.g2.o289 == 0 then
    throw (IO.userError "assert failed at work/design.v:378.97-378.121")
  if r.outputs.g1.g2.o290 != 0 && r.outputs.g1.g2.o291 == 0 then
    throw (IO.userError "assert failed at work/design.v:322.93-322.115")
  if r.outputs.g1.g2.o292 != 0 && r.outputs.g1.g2.o293 == 0 then
    throw (IO.userError "assert failed at work/design.v:379.97-379.121")
  if r.outputs.g1.g2.o294 != 0 && r.outputs.g1.g2.o295 == 0 then
    throw (IO.userError "assert failed at work/design.v:380.97-380.121")
  if r.outputs.g1.g2.o296 != 0 && r.outputs.g1.g2.o297 == 0 then
    throw (IO.userError "assert failed at work/design.v:381.97-381.121")
  if r.outputs.g1.g2.o298 != 0 && r.outputs.g1.g2.o299 == 0 then
    throw (IO.userError "assert failed at work/design.v:382.97-382.121")
  if r.outputs.g1.g2.o300 != 0 && r.outputs.g1.g2.o301 == 0 then
    throw (IO.userError "assert failed at work/design.v:383.97-383.121")
  if r.outputs.g1.g2.o302 != 0 && r.outputs.g1.g2.o303 == 0 then
    throw (IO.userError "assert failed at work/design.v:384.97-384.121")
  if r.outputs.g1.g3.o304 != 0 && r.outputs.g1.g3.o305 == 0 then
    throw (IO.userError "assert failed at work/design.v:385.97-385.121")
  if r.outputs.g1.g3.o306 != 0 && r.outputs.g1.g3.o307 == 0 then
    throw (IO.userError "assert failed at work/design.v:386.97-386.121")
  if r.outputs.g1.g3.o308 != 0 && r.outputs.g1.g3.o309 == 0 then
    throw (IO.userError "assert failed at work/design.v:387.97-387.121")
  if r.outputs.g1.g3.o310 != 0 && r.outputs.g1.g3.o311 == 0 then
    throw (IO.userError "assert failed at work/design.v:328.93-328.115")
  if r.outputs.g1.g3.o312 != 0 && r.outputs.g1.g3.o313 == 0 then
    throw (IO.userError "assert failed at work/design.v:388.97-388.121")
  if r.outputs.g1.g3.o314 != 0 && r.outputs.g1.g3.o315 == 0 then
    throw (IO.userError "assert failed at work/design.v:389.97-389.121")
  if r.outputs.g1.g3.o316 != 0 && r.outputs.g1.g3.o317 == 0 then
    throw (IO.userError "assert failed at work/design.v:390.97-390.121")
  if r.outputs.g1.g3.o318 != 0 && r.outputs.g1.g3.o319 == 0 then
    throw (IO.userError "assert failed at work/design.v:391.97-391.121")
  if r.outputs.g1.g4.o320 != 0 && r.outputs.g1.g4.o321 == 0 then
    throw (IO.userError "assert failed at work/design.v:392.97-392.121")
  if r.outputs.g1.g4.o322 != 0 && r.outputs.g1.g4.o323 == 0 then
    throw (IO.userError "assert failed at work/design.v:393.97-393.121")
  if r.outputs.g1.g4.o324 != 0 && r.outputs.g1.g4.o325 == 0 then
    throw (IO.userError "assert failed at work/design.v:394.97-394.121")
  if r.outputs.g1.g4.o326 != 0 && r.outputs.g1.g4.o327 == 0 then
    throw (IO.userError "assert failed at work/design.v:395.97-395.121")
  if r.outputs.g1.g4.o328 != 0 && r.outputs.g1.g4.o329 == 0 then
    throw (IO.userError "assert failed at work/design.v:396.97-396.121")
  if r.outputs.g1.g4.o330 != 0 && r.outputs.g1.g4.o331 == 0 then
    throw (IO.userError "assert failed at work/design.v:397.97-397.121")
  if r.outputs.g1.g4.o332 != 0 && r.outputs.g1.g4.o333 == 0 then
    throw (IO.userError "assert failed at work/design.v:329.93-329.115")
  if r.outputs.g1.g4.o334 != 0 && r.outputs.g1.g4.o335 == 0 then
    throw (IO.userError "assert failed at work/design.v:398.97-398.121")
  if r.outputs.g1.g5.o336 != 0 && r.outputs.g1.g5.o337 == 0 then
    throw (IO.userError "assert failed at work/design.v:399.97-399.121")
  if r.outputs.g1.g5.o338 != 0 && r.outputs.g1.g5.o339 == 0 then
    throw (IO.userError "assert failed at work/design.v:400.97-400.121")
  if r.outputs.g1.g5.o340 != 0 && r.outputs.g1.g5.o341 == 0 then
    throw (IO.userError "assert failed at work/design.v:401.97-401.121")
  if r.outputs.g1.g5.o342 != 0 && r.outputs.g1.g5.o343 == 0 then
    throw (IO.userError "assert failed at work/design.v:402.97-402.121")
  if r.outputs.g1.g5.o344 != 0 && r.outputs.g1.g5.o345 == 0 then
    throw (IO.userError "assert failed at work/design.v:403.97-403.121")
  if r.outputs.g1.g5.o346 != 0 && r.outputs.g1.g5.o347 == 0 then
    throw (IO.userError "assert failed at work/design.v:404.97-404.121")
  if r.outputs.g1.g5.o348 != 0 && r.outputs.g1.g5.o349 == 0 then
    throw (IO.userError "assert failed at work/design.v:405.97-405.121")
  if r.outputs.g1.g5.o350 != 0 && r.outputs.g1.g5.o351 == 0 then
    throw (IO.userError "assert failed at work/design.v:406.97-406.121")
  if r.outputs.g1.g6.o352 != 0 && r.outputs.g1.g6.o353 == 0 then
    throw (IO.userError "assert failed at work/design.v:407.97-407.121")
  if r.outputs.g1.g6.o354 != 0 && r.outputs.g1.g6.o355 == 0 then
    throw (IO.userError "assert failed at work/design.v:330.93-330.115")
  if r.outputs.g1.g6.o356 != 0 && r.outputs.g1.g6.o357 == 0 then
    throw (IO.userError "assert failed at work/design.v:408.97-408.121")
  if r.outputs.g1.g6.o358 != 0 && r.outputs.g1.g6.o359 == 0 then
    throw (IO.userError "assert failed at work/design.v:409.97-409.121")
  if r.outputs.g1.g6.o360 != 0 && r.outputs.g1.g6.o361 == 0 then
    throw (IO.userError "assert failed at work/design.v:410.97-410.121")
  if r.outputs.g1.g6.o362 != 0 && r.outputs.g1.g6.o363 == 0 then
    throw (IO.userError "assert failed at work/design.v:411.97-411.121")
  if r.outputs.g1.g6.o364 != 0 && r.outputs.g1.g6.o365 == 0 then
    throw (IO.userError "assert failed at work/design.v:412.97-412.121")
  if r.outputs.g1.g6.o366 != 0 && r.outputs.g1.g6.o367 == 0 then
    throw (IO.userError "assert failed at work/design.v:413.97-413.121")
  if r.outputs.g1.g7.o368 != 0 && r.outputs.g1.g7.o369 == 0 then
    throw (IO.userError "assert failed at work/design.v:414.97-414.121")
  if r.outputs.g1.g7.o370 != 0 && r.outputs.g1.g7.o371 == 0 then
    throw (IO.userError "assert failed at work/design.v:415.97-415.121")
  if r.outputs.g1.g7.o372 != 0 && r.outputs.g1.g7.o373 == 0 then
    throw (IO.userError "assert failed at work/design.v:416.97-416.121")
  if r.outputs.g1.g7.o374 != 0 && r.outputs.g1.g7.o375 == 0 then
    throw (IO.userError "assert failed at work/design.v:417.97-417.121")
  if r.outputs.g1.g7.o376 != 0 && r.outputs.g1.g7.o377 == 0 then
    throw (IO.userError "assert failed at work/design.v:331.93-331.115")
  if r.outputs.g1.g7.o378 != 0 && r.outputs.g1.g7.o379 == 0 then
    throw (IO.userError "assert failed at work/design.v:418.97-418.121")
  if r.outputs.g1.g7.o380 != 0 && r.outputs.g1.g7.o381 == 0 then
    throw (IO.userError "assert failed at work/design.v:419.97-419.121")
  if r.outputs.g1.g7.o382 != 0 && r.outputs.g1.g7.o383 == 0 then
    throw (IO.userError "assert failed at work/design.v:420.97-420.121")
  if r.outputs.g1.g8.o384 != 0 && r.outputs.g1.g8.o385 == 0 then
    throw (IO.userError "assert failed at work/design.v:421.97-421.121")
  if r.outputs.g1.g8.o386 != 0 && r.outputs.g1.g8.o387 == 0 then
    throw (IO.userError "assert failed at work/design.v:422.101-422.127")
  if r.outputs.g1.g8.o388 != 0 && r.outputs.g1.g8.o389 == 0 then
    throw (IO.userError "assert failed at work/design.v:423.101-423.127")
  if r.outputs.g1.g8.o390 != 0 && r.outputs.g1.g8.o391 == 0 then
    throw (IO.userError "assert failed at work/design.v:424.101-424.127")
  if r.outputs.g1.g8.o392 != 0 && r.outputs.g1.g8.o393 == 0 then
    throw (IO.userError "assert failed at work/design.v:425.101-425.127")
  if r.outputs.g1.g8.o394 != 0 && r.outputs.g1.g8.o395 == 0 then
    throw (IO.userError "assert failed at work/design.v:426.101-426.127")
  if r.outputs.g1.g8.o396 != 0 && r.outputs.g1.g8.o397 == 0 then
    throw (IO.userError "assert failed at work/design.v:427.101-427.127")
  if r.outputs.g1.g8.o398 != 0 && r.outputs.g1.g8.o399 == 0 then
    throw (IO.userError "assert failed at work/design.v:332.97-332.121")
  if r.outputs.g1.g9.o400 != 0 && r.outputs.g1.g9.o401 == 0 then
    throw (IO.userError "assert failed at work/design.v:428.101-428.127")
  if r.outputs.g1.g9.o402 != 0 && r.outputs.g1.g9.o403 == 0 then
    throw (IO.userError "assert failed at work/design.v:429.101-429.127")
  if r.outputs.g1.g9.o404 != 0 && r.outputs.g1.g9.o405 == 0 then
    throw (IO.userError "assert failed at work/design.v:430.101-430.127")
  if r.outputs.g1.g9.o406 != 0 && r.outputs.g1.g9.o407 == 0 then
    throw (IO.userError "assert failed at work/design.v:431.101-431.127")
  if r.outputs.g1.g9.o408 != 0 && r.outputs.g1.g9.o409 == 0 then
    throw (IO.userError "assert failed at work/design.v:432.101-432.127")
  if r.outputs.g1.g9.o410 != 0 && r.outputs.g1.g9.o411 == 0 then
    throw (IO.userError "assert failed at work/design.v:433.101-433.127")
  if r.outputs.g1.g9.o412 != 0 && r.outputs.g1.g9.o413 == 0 then
    throw (IO.userError "assert failed at work/design.v:434.101-434.127")
  if r.outputs.g1.g9.o414 != 0 && r.outputs.g1.g9.o415 == 0 then
    throw (IO.userError "assert failed at work/design.v:435.101-435.127")
  if r.outputs.g1.g10.o416 != 0 && r.outputs.g1.g10.o417 == 0 then
    throw (IO.userError "assert failed at work/design.v:436.101-436.127")
  if r.outputs.g1.g10.o418 != 0 && r.outputs.g1.g10.o419 == 0 then
    throw (IO.userError "assert failed at work/design.v:437.101-437.127")
  if r.outputs.g1.g10.o420 != 0 && r.outputs.g1.g10.o421 == 0 then
    throw (IO.userError "assert failed at work/design.v:333.97-333.121")
  if r.outputs.g1.g10.o422 != 0 && r.outputs.g1.g10.o423 == 0 then
    throw (IO.userError "assert failed at work/design.v:438.101-438.127")
  if r.outputs.g1.g10.o424 != 0 && r.outputs.g1.g10.o425 == 0 then
    throw (IO.userError "assert failed at work/design.v:439.101-439.127")
  if r.outputs.g1.g10.o426 != 0 && r.outputs.g1.g10.o427 == 0 then
    throw (IO.userError "assert failed at work/design.v:440.101-440.127")
  if r.outputs.g1.g10.o428 != 0 && r.outputs.g1.g10.o429 == 0 then
    throw (IO.userError "assert failed at work/design.v:441.101-441.127")
  if r.outputs.g1.g10.o430 != 0 && r.outputs.g1.g10.o431 == 0 then
    throw (IO.userError "assert failed at work/design.v:442.101-442.127")
  if r.outputs.g1.g11.o432 != 0 && r.outputs.g1.g11.o433 == 0 then
    throw (IO.userError "assert failed at work/design.v:443.101-443.127")
  if r.outputs.g1.g11.o434 != 0 && r.outputs.g1.g11.o435 == 0 then
    throw (IO.userError "assert failed at work/design.v:444.101-444.127")
  if r.outputs.g1.g11.o436 != 0 && r.outputs.g1.g11.o437 == 0 then
    throw (IO.userError "assert failed at work/design.v:445.101-445.127")
  if r.outputs.g1.g11.o438 != 0 && r.outputs.g1.g11.o439 == 0 then
    throw (IO.userError "assert failed at work/design.v:446.101-446.127")
  if r.outputs.g1.g11.o440 != 0 && r.outputs.g1.g11.o441 == 0 then
    throw (IO.userError "assert failed at work/design.v:447.101-447.127")
  if r.outputs.g1.g11.o442 != 0 && r.outputs.g1.g11.o443 == 0 then
    throw (IO.userError "assert failed at work/design.v:334.97-334.121")
  if r.outputs.g1.g11.o444 != 0 && r.outputs.g1.g11.o445 == 0 then
    throw (IO.userError "assert failed at work/design.v:448.101-448.127")
  if r.outputs.g1.g11.o446 != 0 && r.outputs.g1.g11.o447 == 0 then
    throw (IO.userError "assert failed at work/design.v:449.101-449.127")
  if r.outputs.g1.g12.o448 != 0 && r.outputs.g1.g12.o449 == 0 then
    throw (IO.userError "assert failed at work/design.v:450.101-450.127")
  if r.outputs.g1.g12.o450 != 0 && r.outputs.g1.g12.o451 == 0 then
    throw (IO.userError "assert failed at work/design.v:451.101-451.127")
  if r.outputs.g1.g12.o452 != 0 && r.outputs.g1.g12.o453 == 0 then
    throw (IO.userError "assert failed at work/design.v:452.101-452.127")
  if r.outputs.g1.g12.o454 != 0 && r.outputs.g1.g12.o455 == 0 then
    throw (IO.userError "assert failed at work/design.v:453.101-453.127")
  if r.outputs.g1.g12.o456 != 0 && r.outputs.g1.g12.o457 == 0 then
    throw (IO.userError "assert failed at work/design.v:454.101-454.127")
  if r.outputs.g1.g12.o458 != 0 && r.outputs.g1.g12.o459 == 0 then
    throw (IO.userError "assert failed at work/design.v:455.101-455.127")
  if r.outputs.g1.g12.o460 != 0 && r.outputs.g1.g12.o461 == 0 then
    throw (IO.userError "assert failed at work/design.v:456.101-456.127")
  if r.outputs.g1.g12.o462 != 0 && r.outputs.g1.g12.o463 == 0 then
    throw (IO.userError "assert failed at work/design.v:457.101-457.127")
  if r.outputs.g1.g13.o464 != 0 && r.outputs.g1.g13.o465 == 0 then
    throw (IO.userError "assert failed at work/design.v:335.97-335.121")
  if r.outputs.g1.g13.o466 != 0 && r.outputs.g1.g13.o467 == 0 then
    throw (IO.userError "assert failed at work/design.v:458.101-458.127")
  if r.outputs.g1.g13.o468 != 0 && r.outputs.g1.g13.o469 == 0 then
    throw (IO.userError "assert failed at work/design.v:459.101-459.127")
  if r.outputs.g1.g13.o470 != 0 && r.outputs.g1.g13.o471 == 0 then
    throw (IO.userError "assert failed at work/design.v:460.101-460.127")
  if r.outputs.g1.g13.o472 != 0 && r.outputs.g1.g13.o473 == 0 then
    throw (IO.userError "assert failed at work/design.v:461.101-461.127")
  if r.outputs.g1.g13.o474 != 0 && r.outputs.g1.g13.o475 == 0 then
    throw (IO.userError "assert failed at work/design.v:462.101-462.127")
  if r.outputs.g1.g13.o476 != 0 && r.outputs.g1.g13.o477 == 0 then
    throw (IO.userError "assert failed at work/design.v:463.101-463.127")
  if r.outputs.g1.g13.o478 != 0 && r.outputs.g1.g13.o479 == 0 then
    throw (IO.userError "assert failed at work/design.v:464.101-464.127")
  pure ()

def encodeEffects (o : Outputs) : Lean.Json := Id.run do
  let mut events : Array Lean.Json := #[]
  if o.g0.g10.o160 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (0 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g10.o161.toNat)])
  if o.g0.g10.o162 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (1 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g10.o163.toNat)])
  if o.g0.g10.o164 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (2 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g10.o165.toNat)])
  if o.g0.g10.o166 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (3 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g10.o167.toNat)])
  if o.g0.g10.o168 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (4 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g10.o169.toNat)])
  if o.g0.g10.o170 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (5 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g10.o171.toNat)])
  if o.g0.g10.o172 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (6 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g10.o173.toNat)])
  if o.g0.g10.o174 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (7 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g10.o175.toNat)])
  if o.g0.g11.o176 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (8 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g11.o177.toNat)])
  if o.g0.g11.o178 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (9 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g11.o179.toNat)])
  if o.g0.g11.o180 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (10 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g11.o181.toNat)])
  if o.g0.g11.o182 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (11 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g11.o183.toNat)])
  if o.g0.g11.o184 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (12 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g11.o185.toNat)])
  if o.g0.g11.o186 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (13 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g11.o187.toNat)])
  if o.g0.g11.o188 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (14 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g11.o189.toNat)])
  if o.g0.g11.o190 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (15 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g11.o191.toNat)])
  if o.g0.g12.o192 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (16 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g12.o193.toNat)])
  if o.g0.g12.o194 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (17 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g12.o195.toNat)])
  if o.g0.g12.o196 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (18 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g12.o197.toNat)])
  if o.g0.g12.o198 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (19 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g12.o199.toNat)])
  if o.g0.g12.o200 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (20 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g12.o201.toNat)])
  if o.g0.g12.o202 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (21 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g12.o203.toNat)])
  if o.g0.g12.o204 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (22 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g12.o205.toNat)])
  if o.g0.g12.o206 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (23 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g12.o207.toNat)])
  if o.g0.g13.o208 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (24 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g13.o209.toNat)])
  if o.g0.g13.o210 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (25 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g13.o211.toNat)])
  if o.g0.g13.o212 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (26 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g13.o213.toNat)])
  if o.g0.g13.o214 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (27 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g13.o215.toNat)])
  if o.g0.g13.o216 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (28 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g13.o217.toNat)])
  if o.g0.g13.o218 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (29 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g13.o219.toNat)])
  if o.g0.g13.o220 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (30 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g13.o221.toNat)])
  if o.g0.g13.o222 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (31 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g13.o223.toNat)])
  if o.g0.g14.o224 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (32 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g14.o225.toNat)])
  if o.g0.g14.o226 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (33 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g14.o227.toNat)])
  if o.g0.g14.o228 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (34 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g14.o229.toNat)])
  if o.g0.g14.o230 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (35 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g14.o231.toNat)])
  if o.g0.g14.o232 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (36 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g14.o233.toNat)])
  if o.g0.g14.o234 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (37 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g14.o235.toNat)])
  if o.g0.g14.o236 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (38 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g14.o237.toNat)])
  if o.g0.g14.o238 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (39 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g14.o239.toNat)])
  if o.g0.g15.o240 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (40 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g15.o241.toNat)])
  if o.g0.g15.o242 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (41 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g15.o243.toNat)])
  if o.g0.g15.o244 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (42 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g15.o245.toNat)])
  if o.g0.g15.o246 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (43 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g15.o247.toNat)])
  if o.g0.g15.o248 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (44 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g15.o249.toNat)])
  if o.g0.g15.o250 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (45 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g15.o251.toNat)])
  if o.g0.g15.o252 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (46 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g15.o253.toNat)])
  if o.g0.g15.o254 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (47 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g0.g15.o255.toNat)])
  if o.g1.g0.o256 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (48 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g0.o257.toNat)])
  if o.g1.g0.o258 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (49 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g0.o259.toNat)])
  if o.g1.g0.o260 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (50 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g0.o261.toNat)])
  if o.g1.g0.o262 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (51 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g0.o263.toNat)])
  if o.g1.g0.o264 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (52 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g0.o265.toNat)])
  if o.g1.g0.o266 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (53 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g0.o267.toNat)])
  if o.g1.g0.o268 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (54 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g0.o269.toNat)])
  if o.g1.g0.o270 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (55 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g0.o271.toNat)])
  if o.g1.g1.o272 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (56 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g1.o273.toNat)])
  if o.g1.g1.o274 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (57 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g1.o275.toNat)])
  if o.g1.g1.o276 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (58 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g1.o277.toNat)])
  if o.g1.g1.o278 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (59 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g1.o279.toNat)])
  if o.g1.g1.o280 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (60 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g1.o281.toNat)])
  if o.g1.g1.o282 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (61 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g1.o283.toNat)])
  if o.g1.g1.o284 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (62 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g1.o285.toNat)])
  if o.g1.g1.o286 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (63 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g1.o287.toNat)])
  if o.g1.g2.o288 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (64 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g2.o289.toNat)])
  if o.g1.g2.o290 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (65 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g2.o291.toNat)])
  if o.g1.g2.o292 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (66 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g2.o293.toNat)])
  if o.g1.g2.o294 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (67 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g2.o295.toNat)])
  if o.g1.g2.o296 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (68 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g2.o297.toNat)])
  if o.g1.g2.o298 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (69 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g2.o299.toNat)])
  if o.g1.g2.o300 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (70 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g2.o301.toNat)])
  if o.g1.g2.o302 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (71 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g2.o303.toNat)])
  if o.g1.g3.o304 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (72 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g3.o305.toNat)])
  if o.g1.g3.o306 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (73 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g3.o307.toNat)])
  if o.g1.g3.o308 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (74 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g3.o309.toNat)])
  if o.g1.g3.o310 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (75 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g3.o311.toNat)])
  if o.g1.g3.o312 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (76 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g3.o313.toNat)])
  if o.g1.g3.o314 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (77 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g3.o315.toNat)])
  if o.g1.g3.o316 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (78 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g3.o317.toNat)])
  if o.g1.g3.o318 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (79 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g3.o319.toNat)])
  if o.g1.g4.o320 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (80 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g4.o321.toNat)])
  if o.g1.g4.o322 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (81 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g4.o323.toNat)])
  if o.g1.g4.o324 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (82 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g4.o325.toNat)])
  if o.g1.g4.o326 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (83 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g4.o327.toNat)])
  if o.g1.g4.o328 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (84 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g4.o329.toNat)])
  if o.g1.g4.o330 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (85 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g4.o331.toNat)])
  if o.g1.g4.o332 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (86 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g4.o333.toNat)])
  if o.g1.g4.o334 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (87 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g4.o335.toNat)])
  if o.g1.g5.o336 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (88 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g5.o337.toNat)])
  if o.g1.g5.o338 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (89 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g5.o339.toNat)])
  if o.g1.g5.o340 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (90 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g5.o341.toNat)])
  if o.g1.g5.o342 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (91 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g5.o343.toNat)])
  if o.g1.g5.o344 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (92 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g5.o345.toNat)])
  if o.g1.g5.o346 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (93 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g5.o347.toNat)])
  if o.g1.g5.o348 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (94 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g5.o349.toNat)])
  if o.g1.g5.o350 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (95 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g5.o351.toNat)])
  if o.g1.g6.o352 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (96 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g6.o353.toNat)])
  if o.g1.g6.o354 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (97 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g6.o355.toNat)])
  if o.g1.g6.o356 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (98 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g6.o357.toNat)])
  if o.g1.g6.o358 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (99 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g6.o359.toNat)])
  if o.g1.g6.o360 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (100 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g6.o361.toNat)])
  if o.g1.g6.o362 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (101 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g6.o363.toNat)])
  if o.g1.g6.o364 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (102 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g6.o365.toNat)])
  if o.g1.g6.o366 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (103 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g6.o367.toNat)])
  if o.g1.g7.o368 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (104 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g7.o369.toNat)])
  if o.g1.g7.o370 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (105 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g7.o371.toNat)])
  if o.g1.g7.o372 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (106 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g7.o373.toNat)])
  if o.g1.g7.o374 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (107 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g7.o375.toNat)])
  if o.g1.g7.o376 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (108 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g7.o377.toNat)])
  if o.g1.g7.o378 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (109 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g7.o379.toNat)])
  if o.g1.g7.o380 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (110 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g7.o381.toNat)])
  if o.g1.g7.o382 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (111 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g7.o383.toNat)])
  if o.g1.g8.o384 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (112 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g8.o385.toNat)])
  if o.g1.g8.o386 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (113 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g8.o387.toNat)])
  if o.g1.g8.o388 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (114 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g8.o389.toNat)])
  if o.g1.g8.o390 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (115 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g8.o391.toNat)])
  if o.g1.g8.o392 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (116 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g8.o393.toNat)])
  if o.g1.g8.o394 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (117 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g8.o395.toNat)])
  if o.g1.g8.o396 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (118 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g8.o397.toNat)])
  if o.g1.g8.o398 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (119 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g8.o399.toNat)])
  if o.g1.g9.o400 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (120 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g9.o401.toNat)])
  if o.g1.g9.o402 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (121 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g9.o403.toNat)])
  if o.g1.g9.o404 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (122 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g9.o405.toNat)])
  if o.g1.g9.o406 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (123 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g9.o407.toNat)])
  if o.g1.g9.o408 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (124 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g9.o409.toNat)])
  if o.g1.g9.o410 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (125 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g9.o411.toNat)])
  if o.g1.g9.o412 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (126 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g9.o413.toNat)])
  if o.g1.g9.o414 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (127 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g9.o415.toNat)])
  if o.g1.g10.o416 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (128 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g10.o417.toNat)])
  if o.g1.g10.o418 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (129 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g10.o419.toNat)])
  if o.g1.g10.o420 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (130 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g10.o421.toNat)])
  if o.g1.g10.o422 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (131 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g10.o423.toNat)])
  if o.g1.g10.o424 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (132 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g10.o425.toNat)])
  if o.g1.g10.o426 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (133 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g10.o427.toNat)])
  if o.g1.g10.o428 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (134 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g10.o429.toNat)])
  if o.g1.g10.o430 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (135 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g10.o431.toNat)])
  if o.g1.g11.o432 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (136 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g11.o433.toNat)])
  if o.g1.g11.o434 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (137 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g11.o435.toNat)])
  if o.g1.g11.o436 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (138 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g11.o437.toNat)])
  if o.g1.g11.o438 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (139 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g11.o439.toNat)])
  if o.g1.g11.o440 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (140 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g11.o441.toNat)])
  if o.g1.g11.o442 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (141 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g11.o443.toNat)])
  if o.g1.g11.o444 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (142 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g11.o445.toNat)])
  if o.g1.g11.o446 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (143 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g11.o447.toNat)])
  if o.g1.g12.o448 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (144 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g12.o449.toNat)])
  if o.g1.g12.o450 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (145 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g12.o451.toNat)])
  if o.g1.g12.o452 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (146 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g12.o453.toNat)])
  if o.g1.g12.o454 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (147 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g12.o455.toNat)])
  if o.g1.g12.o456 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (148 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g12.o457.toNat)])
  if o.g1.g12.o458 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (149 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g12.o459.toNat)])
  if o.g1.g12.o460 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (150 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g12.o461.toNat)])
  if o.g1.g12.o462 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (151 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g12.o463.toNat)])
  if o.g1.g13.o464 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (152 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g13.o465.toNat)])
  if o.g1.g13.o466 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (153 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g13.o467.toNat)])
  if o.g1.g13.o468 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (154 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g13.o469.toNat)])
  if o.g1.g13.o470 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (155 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g13.o471.toNat)])
  if o.g1.g13.o472 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (156 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g13.o473.toNat)])
  if o.g1.g13.o474 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (157 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g13.o475.toNat)])
  if o.g1.g13.o476 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (158 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g13.o477.toNat)])
  if o.g1.g13.o478 != 0 then
    events := events.push (Lean.Json.mkObj [("index", Lean.toJson (159 : Nat)), ("kind", Lean.toJson "assert"), ("condition", Lean.toJson o.g1.g13.o479.toNat)])
  return Lean.Json.arr events
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
    checkEffects low
    let high := evaluate ({ inputs with g0 := { inputs.g0 with g0 := { inputs.g0.g0 with i1 := 1 } } }) low.nextState
    if !high.outputDefined || !high.transitionDefined then throw (IO.userError "Undefined high-clock operation")
    checkEffects high
    let pre := low.outputs
    let post := high.outputs
    state := high.nextState
    IO.println ((Lean.Json.mkObj [("cycle", Lean.toJson cycle),
      ("pre", encodeOutputs pre), ("post", encodeOutputs post), ("effects_pre", encodeEffects pre), ("effects_post", encodeEffects post)]).compress)
    cycle := cycle + 1
