import probes.SignedArithmetic
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.SignedArithmetic
def p : Params := { w := (65 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ io_a := (BitVec.ofInt _ (8432683584078134192 : Int)), io_b := (BitVec.ofInt _ (31466055360833404999 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (8736934838265906401 : Int)), io_b := (BitVec.ofInt _ (10963424438691962082 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (345263234306749454 : Int)), io_b := (BitVec.ofInt _ (10255938408063151289 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (22153149478883899424 : Int)), io_b := (BitVec.ofInt _ (13423104104524810856 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (4137205505084429078 : Int)), io_b := (BitVec.ofInt _ (24451129711297924062 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (28793930542741334841 : Int)), io_b := (BitVec.ofInt _ (26401202784172544789 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (34899215526198529468 : Int)), io_b := (BitVec.ofInt _ (5643853747818135930 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (15100826644819010302 : Int)), io_b := (BitVec.ofInt _ (19743235008886848798 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (28505508204724940907 : Int)), io_b := (BitVec.ofInt _ (14846046626509893547 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (7761531925499232686 : Int)), io_b := (BitVec.ofInt _ (22456091620877347692 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (13457016453206672100 : Int)), io_b := (BitVec.ofInt _ (28629639965747428713 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (15688005050050355824 : Int)), io_b := (BitVec.ofInt _ (33109748741013256037 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (29363506918350887646 : Int)), io_b := (BitVec.ofInt _ (24491479794491044608 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (27020180490924327820 : Int)), io_b := (BitVec.ofInt _ (15203696076386819428 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (30316523039719132585 : Int)), io_b := (BitVec.ofInt _ (13196156406209887411 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (25117026730015622380 : Int)), io_b := (BitVec.ofInt _ (29487527372709771375 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (13257378044490745408 : Int)), io_b := (BitVec.ofInt _ (3613314171473495955 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (17065276352689214665 : Int)), io_b := (BitVec.ofInt _ (14523945897447868416 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (26766699603962367680 : Int)), io_b := (BitVec.ofInt _ (28511712269457513448 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (22789225541365612903 : Int)), io_b := (BitVec.ofInt _ (30732200890085069662 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (3674922730546603421 : Int)), io_b := (BitVec.ofInt _ (28158118877718639988 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (7640619212141257374 : Int)), io_b := (BitVec.ofInt _ (6321258387163650950 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (33563152514723274964 : Int)), io_b := (BitVec.ofInt _ (9997824441916440232 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (4143375483643395874 : Int)), io_b := (BitVec.ofInt _ (26013352232427334450 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (32795285936171624290 : Int)), io_b := (BitVec.ofInt _ (6740625402820610980 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (18713320226812083852 : Int)), io_b := (BitVec.ofInt _ (604630340569620264 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (5611362284379806510 : Int)), io_b := (BitVec.ofInt _ (34336431596887253683 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (15559237543755187230 : Int)), io_b := (BitVec.ofInt _ (18096619143048019956 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (20394457530234963340 : Int)), io_b := (BitVec.ofInt _ (24885760059616442166 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (13878595077862812739 : Int)), io_b := (BitVec.ofInt _ (21498658539201653483 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (29182231240256892067 : Int)), io_b := (BitVec.ofInt _ (35492224443084826939 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (30522067631327418910 : Int)), io_b := (BitVec.ofInt _ (23077582891609300510 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (29218812537477133056 : Int)), io_b := (BitVec.ofInt _ (34837234256336118205 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (22530783875306364348 : Int)), io_b := (BitVec.ofInt _ (34347870805577847877 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (31755689590043357935 : Int)), io_b := (BitVec.ofInt _ (34601824846669706574 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (9539273384577395575 : Int)), io_b := (BitVec.ofInt _ (28215948536168940103 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (5976147770799131020 : Int)), io_b := (BitVec.ofInt _ (19145355880622715122 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (9372982186470679233 : Int)), io_b := (BitVec.ofInt _ (13235338175257617492 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (34774803642799785065 : Int)), io_b := (BitVec.ofInt _ (5710830220554788347 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (26569584860859333045 : Int)), io_b := (BitVec.ofInt _ (10120555231805897970 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (33855856300764835974 : Int)), io_b := (BitVec.ofInt _ (3362143331594408302 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (7035883095905406880 : Int)), io_b := (BitVec.ofInt _ (1494486200693167024 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (23664212358271853480 : Int)), io_b := (BitVec.ofInt _ (14412273090012965838 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (34381840417344249011 : Int)), io_b := (BitVec.ofInt _ (27289190968135071725 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (23586009729029176479 : Int)), io_b := (BitVec.ofInt _ (25110800828406753068 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (29810097779477274178 : Int)), io_b := (BitVec.ofInt _ (28311668962475036125 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (36646806105136942322 : Int)), io_b := (BitVec.ofInt _ (16132488279700790840 : Int)) }, false),
  ({ io_a := (BitVec.ofInt _ (17569630528726823281 : Int)), io_b := (BitVec.ofInt _ (8791621725745670686 : Int)) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("io.extended", Lean.toJson (o.io_extended).toNat), ("io.less", Lean.toJson (o.io_less)), ("io.product", Lean.toJson (o.io_product).toNat), ("io.shr", Lean.toJson (o.io_shr).toNat), ("io.sum", Lean.toJson (o.io_sum).toNat), ("io.wide", Lean.toJson (o.io_wide).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj []
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { io_a := (BitVec.ofInt _ (8432683584078134192 : Int)), io_b := (BitVec.ofInt _ (31466055360833404999 : Int)) }
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
