import probes.Counter
import Modern.Counter4

namespace ModernCounterBridge

def sourceParams : probes.Counter.Params := ⟨4⟩
def fixedParams : Modern.Counter4.Params := ⟨⟩

def sourceInputs (en : Bool) : probes.Counter.Inputs sourceParams := ⟨en⟩
def fixedInputs (en reset : Bool) : Modern.Counter4.Inputs fixedParams :=
  { reset := BitVec.ofNat 1 (if reset then 1 else 0),
    c2l_port_0 := BitVec.ofNat 1 (if en then 1 else 0) }

def fixedValue : Modern.Counter4.State fixedParams → BitVec 4
  | ⟨value⟩ => value

/-- Same Chisel 7.3 counter, source model vs official elaboration/CIRCT model. -/
theorem transition_agrees : ∀ (cnt : BitVec 4) (en reset : Bool),
    (probes.Counter.step sourceParams (sourceInputs en) ⟨cnt⟩ reset).cnt =
    fixedValue (Modern.Counter4.step fixedParams (fixedInputs en reset) ⟨cnt⟩) := by
  decide

theorem output_agrees (cnt : BitVec 4) (en reset : Bool) :
    (probes.Counter.output sourceParams (sourceInputs en) ⟨cnt⟩).io_q =
    (Modern.Counter4.output fixedParams (fixedInputs en reset) ⟨cnt⟩).c2l_port_1 := by
  rfl

def sourceRun (cnt : BitVec 4) : List (Bool × Bool) → BitVec 4
  | [] => cnt
  | (en, reset) :: rest => sourceRun
      (probes.Counter.step sourceParams (sourceInputs en) ⟨cnt⟩ reset).cnt rest

def fixedRun (cnt : BitVec 4) : List (Bool × Bool) → BitVec 4
  | [] => cnt
  | (en, reset) :: rest => fixedRun
      (fixedValue (Modern.Counter4.step fixedParams (fixedInputs en reset) ⟨cnt⟩)) rest

/-- All counter initial states and every finite enable/reset sequence. -/
theorem all_cycles_agree (cnt : BitVec 4) (trace : List (Bool × Bool)) :
    sourceRun cnt trace = fixedRun cnt trace := by
  induction trace generalizing cnt with
  | nil => rfl
  | cons entry rest ih =>
    rcases entry with ⟨en, reset⟩
    simp only [sourceRun, fixedRun]
    rw [transition_agrees]
    exact ih _

end ModernCounterBridge
