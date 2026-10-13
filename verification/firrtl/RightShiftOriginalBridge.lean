import xiangshan.backend.fu.RightShiftModule
import FIRRTL.RightShiftModule

namespace RightShiftOriginalBridge

def sourceParams : xiangshan.backend.fu.RightShiftModule.Params := ⟨64⟩
def fixedParams : FIRRTL.RightShiftModule.Params := ⟨⟩
def inputsMap (i : xiangshan.backend.fu.RightShiftModule.Inputs sourceParams)
    (reset : BitVec 1) : FIRRTL.RightShiftModule.Inputs fixedParams :=
  { reset := reset, io_shamt := i.io_shamt, io_revShamt := i.io_revShamt,
    io_srlSrc := i.io_srlSrc, io_sraSrc := i.io_sraSrc }

/-- Actual v2.1/MinimalConfig FIRRTL model equals the source model at XLEN=64.
    Quantifies over all source bit patterns, shift amounts and reset values. -/
theorem all_outputs_agree
    (i : xiangshan.backend.fu.RightShiftModule.Inputs sourceParams) (reset : BitVec 1) :
    let a := xiangshan.backend.fu.RightShiftModule.output sourceParams i ⟨⟩
    let b := FIRRTL.RightShiftModule.output fixedParams (inputsMap i reset) ⟨⟩
    a.io_srl = b.io_srl ∧ a.io_sra = b.io_sra ∧ a.io_revSrl = b.io_revSrl := by
  exact ⟨rfl, rfl, rfl⟩

end RightShiftOriginalBridge
