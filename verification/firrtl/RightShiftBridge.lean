import xiangshan.backend.fu.RightShiftModule
import FIRRTL.OriginalRightShiftReference

namespace RightShiftBridge

-- Explicit maps avoid assuming that source and FIRRTL record layouts coincide.
def sourceParams : xiangshan.backend.fu.RightShiftModule.Params := ⟨64⟩
def fixedParams : FIRRTL.OriginalRightShiftReference.Params := ⟨⟩
def inputsMap (i : xiangshan.backend.fu.RightShiftModule.Inputs sourceParams)
    (reset : BitVec 1) : FIRRTL.OriginalRightShiftReference.Inputs fixedParams :=
  { reset := reset, io_shamt := i.io_shamt, io_revShamt := i.io_revShamt,
    io_srlSrc := i.io_srlSrc, io_sraSrc := i.io_sraSrc }

/-- All 64-bit source patterns, all six-bit shift amounts, and either reset input. -/
theorem logical_agrees (i : xiangshan.backend.fu.RightShiftModule.Inputs sourceParams) (reset : BitVec 1) :
    (xiangshan.backend.fu.RightShiftModule.output sourceParams i ⟨⟩).io_srl =
    (FIRRTL.OriginalRightShiftReference.output fixedParams (inputsMap i reset) ⟨⟩).io_srl := by rfl

theorem arithmetic_agrees (i : xiangshan.backend.fu.RightShiftModule.Inputs sourceParams) (reset : BitVec 1) :
    (xiangshan.backend.fu.RightShiftModule.output sourceParams i ⟨⟩).io_sra =
    (FIRRTL.OriginalRightShiftReference.output fixedParams (inputsMap i reset) ⟨⟩).io_sra := by rfl

theorem reverse_agrees (i : xiangshan.backend.fu.RightShiftModule.Inputs sourceParams) (reset : BitVec 1) :
    (xiangshan.backend.fu.RightShiftModule.output sourceParams i ⟨⟩).io_revSrl =
    (FIRRTL.OriginalRightShiftReference.output fixedParams (inputsMap i reset) ⟨⟩).io_revSrl := by rfl

end RightShiftBridge
