import Counter

/-! Example client proofs over the generated API. These are model properties;
    they do not prove equivalence of the Scala frontend to Chisel. -/
namespace CounterClient

theorem output_is_state (p : Counter.Params) (i : Counter.Inputs p) (s : Counter.State p) :
    (Counter.output p i s).q = s.cnt := by
  rfl

theorem disabled_holds (p : Counter.Params) (s : Counter.State p) :
    Counter.step p { en := false } s false = s := by
  cases s
  rfl

end CounterClient
