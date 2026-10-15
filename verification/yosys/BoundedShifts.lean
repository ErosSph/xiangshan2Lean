import Chisel2Lean.Functional
open Chisel2Lean.Functional

-- Generic equalities are checked in the runtime module for every width/count.
#print axioms boundedShiftLeft_eq
#print axioms boundedShiftRight_eq
#print axioms boundedArithShiftRight_eq

example (value : BitVec 65) : boundedShiftLeft value (2^64-1) = 0 := by
  rw [boundedShiftLeft_eq]
  exact BitVec.shiftLeft_eq_zero (by decide)

#eval (boundedShiftLeft (1#65) (2^64-1)).toNat
#eval (boundedShiftRight (1#65) (2^64-1)).toNat
#eval (boundedArithShiftRight (0x10000000000000000#65) (2^64-1)).toNat
