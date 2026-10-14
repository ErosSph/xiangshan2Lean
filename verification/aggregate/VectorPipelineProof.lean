import aggregate.BundleVectorPipeline

open aggregate.BundleVectorPipeline

namespace VectorPipelineProof

theorem holds_without_enable (p : Params) (i : Inputs p) (s : State p)
    (disabled : i.enable = false) : step p i s false = s := by
  cases s
  simp [step, disabled]

theorem captures_when_enabled (p : Params) (i : Inputs p) (s : State p)
    (enabled : i.enable = true) : step p i s false = resetState p i := by
  simp [step, resetState, enabled]

theorem reset_captures_input (p : Params) (i : Inputs p) (s : State p) :
    step p i s true = resetState p i := by
  rfl

end VectorPipelineProof
