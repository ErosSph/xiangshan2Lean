import xiangshan.backend.fu.RightShiftModule

namespace XiangShanRightShiftProof

open xiangshan.backend.fu.RightShiftModule

/-- The generated arithmetic output equals Lean's signed bit-vector operation
    for every parameter width, input bit pattern, and six-bit shift amount. -/
theorem arithmetic_right (p : Params) (i : Inputs p) (s : State p) :
    (output p i s).io_sra = i.io_sraSrc.sshiftRight i.io_shamt.toNat := by
  simp only [output, BitVec.ofNat_toNat, BitVec.setWidth_eq, BitVec.ofInt_toInt]

/-- The generated first logical output equals the standard unsigned operation. -/
theorem logical_right (p : Params) (i : Inputs p) (s : State p) :
    (output p i s).io_srl = i.io_srlSrc >>> i.io_shamt.toNat := by
  apply BitVec.eq_of_toNat_eq
  simp only [output, BitVec.toNat_ofNat, BitVec.toNat_ushiftRight]
  exact Nat.mod_eq_of_lt (Nat.lt_of_le_of_lt (Nat.shiftRight_le _ _) i.io_srlSrc.isLt)

/-- The second logical output uses its independent shift input. -/
theorem reverse_logical_right (p : Params) (i : Inputs p) (s : State p) :
    (output p i s).io_revSrl = i.io_srlSrc >>> i.io_revShamt.toNat := by
  apply BitVec.eq_of_toNat_eq
  simp only [output, BitVec.toNat_ofNat, BitVec.toNat_ushiftRight]
  exact Nat.mod_eq_of_lt (Nat.lt_of_le_of_lt (Nat.shiftRight_le _ _) i.io_srlSrc.isLt)

end XiangShanRightShiftProof
