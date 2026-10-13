import probes.Counter
import FIRRTL.Counter

namespace CounterBridge

def sourceParams : probes.Counter.Params := ⟨4⟩
def fixedParams : FIRRTL.Counter.Params := ⟨⟩
def sourceInputs (en : Bool) : probes.Counter.Inputs sourceParams := ⟨en⟩
def fixedInputs (en reset : Bool) : FIRRTL.Counter.Inputs fixedParams :=
  { reset := BitVec.ofNat 1 (if reset then 1 else 0),
    io_en := BitVec.ofNat 1 (if en then 1 else 0) }

/-- A fixed-configuration bridge between the two generated models, all states and inputs. -/
theorem transition_agrees : ∀ (cnt : BitVec 4) (en reset : Bool),
    (probes.Counter.step sourceParams (sourceInputs en) ⟨cnt⟩ reset).cnt =
    (FIRRTL.Counter.step fixedParams (fixedInputs en reset) ⟨cnt⟩).cnt := by
  decide

theorem output_agrees (cnt : BitVec 4) (en reset : Bool) :
    (probes.Counter.output sourceParams (sourceInputs en) ⟨cnt⟩).io_q =
    (FIRRTL.Counter.output fixedParams (fixedInputs en reset) ⟨cnt⟩).io_q := by
  rfl

def sourceRun (cnt : BitVec 4) : List (Bool × Bool) → BitVec 4
  | [] => cnt
  | (en, reset) :: rest => sourceRun
      (probes.Counter.step sourceParams (sourceInputs en) ⟨cnt⟩ reset).cnt rest

def fixedRun (cnt : BitVec 4) : List (Bool × Bool) → BitVec 4
  | [] => cnt
  | (en, reset) :: rest => fixedRun
      (FIRRTL.Counter.step fixedParams (fixedInputs en reset) ⟨cnt⟩).cnt rest

/-- Every finite input/reset sequence, with arbitrary length and initial state. -/
theorem all_cycles_agree (cnt : BitVec 4) (trace : List (Bool × Bool)) :
    sourceRun cnt trace = fixedRun cnt trace := by
  induction trace generalizing cnt with
  | nil => rfl
  | cons entry rest ih =>
    rcases entry with ⟨en, reset⟩
    simp only [sourceRun, fixedRun]
    rw [transition_agrees]
    exact ih _

end CounterBridge
