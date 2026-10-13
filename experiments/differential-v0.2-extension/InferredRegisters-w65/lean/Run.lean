import probes.InferredRegisters
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.InferredRegisters
def p : Params := { w := (65 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ «in» := (BitVec.ofInt _ (8432683584078134192 : Int)) }, true),
  ({ «in» := (BitVec.ofInt _ (31466055360833404999 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (8736934838265906401 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (10963424438691962082 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (345263234306749454 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (10255938408063151289 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (22153149478883899424 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (13423104104524810856 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (4137205505084429078 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (24451129711297924062 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (28793930542741334841 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (26401202784172544789 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (34899215526198529468 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (5643853747818135930 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (15100826644819010302 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (19743235008886848798 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (28505508204724940907 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (14846046626509893547 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (7761531925499232686 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (22456091620877347692 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (13457016453206672100 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (28629639965747428713 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (15688005050050355824 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (33109748741013256037 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (29363506918350887646 : Int)) }, true),
  ({ «in» := (BitVec.ofInt _ (24491479794491044608 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (27020180490924327820 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (15203696076386819428 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (30316523039719132585 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (13196156406209887411 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (25117026730015622380 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (29487527372709771375 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (13257378044490745408 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (3613314171473495955 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (17065276352689214665 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (14523945897447868416 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (26766699603962367680 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (28511712269457513448 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (22789225541365612903 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (30732200890085069662 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (3674922730546603421 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (28158118877718639988 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (7640619212141257374 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (6321258387163650950 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (33563152514723274964 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (9997824441916440232 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (4143375483643395874 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (26013352232427334450 : Int)) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("out", Lean.toJson (o.«out»).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("unforced", Lean.toJson (s.unforced).toNat), ("widened", Lean.toJson (s.widened).toNat)]
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { «in» := (BitVec.ofInt _ (8432683584078134192 : Int)) }
  let mut state : State p := resetState p first
  let mut cycle : Nat := 0
  for entry in inputsTrace do
    let (inputs, reset) := entry
    if !outputDefined p inputs state && !(cycle == 0 && true) then throw (IO.userError "Undefined output operation in input trace")
    let pre := output p inputs state
    if !transitionDefined p inputs state reset then throw (IO.userError "Undefined transition operation in input trace")
    let next := step p inputs state reset
    if !outputDefined p inputs next then throw (IO.userError "Undefined output operation after clock edge")
    let post := output p inputs next
    IO.println (Lean.Json.mkObj [("cycle", Lean.toJson cycle), ("pre", outputsJson pre),
      ("post", outputsJson post), ("state", stateJson next)]).compress
    state := next
    cycle := cycle + 1
