import xiangshan.validation.SfencePipeline

open xiangshan.validation.SfencePipeline

namespace SfencePipelineProof

def captured (p : Params) (i : Inputs p) : Outputs p :=
  { result_bits_addr := i.request_bits_addr
    result_bits_asid := i.request_bits_asid
    result_bits_rs1 := i.request_bits_rs1
    result_bits_rs2 := i.request_bits_rs2
    result_valid := i.request_valid }

theorem holds_without_enable (p : Params) (i : Inputs p) (s : State p)
    (disabled : i.enable = false) :
    output p i (step p i s false) = output p i s := by
  simp [output, step, disabled]

theorem captures_when_enabled (p : Params) (i : Inputs p) (s : State p)
    (enabled : i.enable = true) :
    output p i (step p i s false) = captured p i := by
  simp [output, step, captured, enabled]

theorem reset_captures_input (p : Params) (i : Inputs p) (s : State p) :
    output p i (step p i s true) = captured p i := by
  rfl

end SfencePipelineProof
