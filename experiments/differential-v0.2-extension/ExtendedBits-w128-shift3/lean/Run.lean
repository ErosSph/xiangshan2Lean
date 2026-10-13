import probes.ExtendedBits
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.ExtendedBits
def p : Params := { w := (128 : Int), shift := (3 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ «in» := (BitVec.ofInt _ (199786079455810795641884007829290970705 : Int)), flag := false, amount := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (204173160011010698592404176109630888982 : Int)), flag := false, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (15888145950846901150885750927776156264 : Int)), flag := false, amount := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (253765961258974952824912813682760900340 : Int)), flag := true, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (285569883673006819381175124684503843194 : Int)), flag := true, amount := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (256531870052618872559566963634649944385 : Int)), flag := true, amount := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (153633973501482490952418176563563995459 : Int)), flag := false, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (78763348143962651898596862843416502188 : Int)), flag := true, amount := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (73959408105159469245987108571635794361 : Int)), flag := false, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (187841274449651047469026972860055350570 : Int)), flag := true, amount := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (201378730308480191950000333428157897618 : Int)), flag := false, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (111505692834466440789046909239928750155 : Int)), flag := true, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (243426119981996575100995003670532320532 : Int)), flag := false, amount := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (66896689528598767573766834091423477579 : Int)), flag := false, amount := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (189834160090394277255322743522800116363 : Int)), flag := true, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (151200428278524411178162666032722650603 : Int)), flag := false, amount := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (320379626200675854841877664448851579586 : Int)), flag := true, amount := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (14716703249937654299067623936879659692 : Int)), flag := false, amount := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (184427308773910599117244787647263983355 : Int)), flag := false, amount := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (259333775472491055714792586250726536412 : Int)), flag := true, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (57285549286416875885440352404048422754 : Int)), flag := false, amount := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (92253363349465286619121518746548009654 : Int)), flag := true, amount := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (103511363964820487409304971192487084898 : Int)), flag := true, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (118778879978548998998423328908251308635 : Int)), flag := false, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (198034784267892098614972646426427429897 : Int)), flag := true, amount := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (154252208736565386965462674989620731422 : Int)), flag := false, amount := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (290656113059441478095112523370968854759 : Int)), flag := true, amount := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (162875077774854746849784427414198539705 : Int)), flag := true, amount := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (85027446094604277578561792438502114701 : Int)), flag := false, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (172901003601263197597915035620354551101 : Int)), flag := true, amount := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (201407204442828119453262278877590289442 : Int)), flag := true, amount := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (278397686986458275384063531149987257586 : Int)), flag := true, amount := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (78389089553150223872760422638988656371 : Int)), flag := true, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (303884682916221841148492707541759914145 : Int)), flag := false, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (74644599890008781166976705052239598512 : Int)), flag := true, amount := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (333974863961511281952381328478901169102 : Int)), flag := true, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (148463275571055508503970421362420168685 : Int)), flag := true, amount := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (119464495449887285085550193833813696066 : Int)), flag := true, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (268912709529583503194453254367116622889 : Int)), flag := true, amount := (BitVec.ofInt _ (0 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (56727995538032588486291206496055270597 : Int)), flag := false, amount := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (12218978537724044247036191889535100405 : Int)), flag := false, amount := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (321332505459518068590986567048897780583 : Int)), flag := true, amount := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (316213713268675372080043765444250003907 : Int)), flag := false, amount := (BitVec.ofInt _ (3 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (158073106442539946238878858906611949661 : Int)), flag := true, amount := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (166441632522149073872963699467550573994 : Int)), flag := true, amount := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (206048251344459332350320671289832670084 : Int)), flag := true, amount := (BitVec.ofInt _ (1 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (221279693577209132176733709517594852998 : Int)), flag := true, amount := (BitVec.ofInt _ (2 : Int)) }, false),
  ({ «in» := (BitVec.ofInt _ (62938389658112950885027779737278881667 : Int)), flag := false, amount := (BitVec.ofInt _ (3 : Int)) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("inverted", Lean.toJson (o.inverted).toNat), ("negative", Lean.toJson (o.negative).toNat), ("concatenated", Lean.toJson (o.concatenated).toNat), ("isZero", Lean.toJson (o.isZero)), ("shifted", Lean.toJson (o.shifted).toNat), ("dynamic", Lean.toJson (o.dynamic).toNat), ("padded", Lean.toJson (o.padded).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj []
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { «in» := (BitVec.ofInt _ (199786079455810795641884007829290970705 : Int)), flag := false, amount := (BitVec.ofInt _ (1 : Int)) }
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
