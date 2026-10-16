import leanparam.AnnotatedBank
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open leanparam.AnnotatedBank
def p : Params := { n := (2 : Int), w := (63 : Int), extra := true }
def inputsTrace : List (Inputs p × Bool) := [
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (559543822221989865 : Int)) | 1 => (BitVec.ofInt _ (12238994951278904985 : Int)) | _ => default) }, true),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (10830524619768603393 : Int)) | 1 => (BitVec.ofInt _ (1593652247575540673 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (3418035200263968829 : Int)) | 1 => (BitVec.ofInt _ (14735981717589969091 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (5964391858251208875 : Int)) | 1 => (BitVec.ofInt _ (6318230038034197416 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (17898085060894742755 : Int)) | 1 => (BitVec.ofInt _ (3027749834405784019 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (5951241582993755596 : Int)) | 1 => (BitVec.ofInt _ (14745110551275302224 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (5577370087760803542 : Int)) | 1 => (BitVec.ofInt _ (10555549798869066592 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (17193802972333107081 : Int)) | 1 => (BitVec.ofInt _ (17894237966418082754 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (5659839686966629062 : Int)) | 1 => (BitVec.ofInt _ (8539663039055589710 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (12713009862883791744 : Int)) | 1 => (BitVec.ofInt _ (5341929754120199940 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (18102870385316691984 : Int)) | 1 => (BitVec.ofInt _ (7081103287140363074 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (15594735892605782048 : Int)) | 1 => (BitVec.ofInt _ (2839602646780260421 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (18252790581417453629 : Int)) | 1 => (BitVec.ofInt _ (3278967759178037542 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (2063158416515481267 : Int)) | 1 => (BitVec.ofInt _ (16215533508739893324 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (1921870663601595020 : Int)) | 1 => (BitVec.ofInt _ (17178054040224316830 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (5739351498107410584 : Int)) | 1 => (BitVec.ofInt _ (6441049202008987559 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (14666510832836811266 : Int)) | 1 => (BitVec.ofInt _ (6809292593932564930 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (10930438399560742778 : Int)) | 1 => (BitVec.ofInt _ (2154611789029396412 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (2667361011757762762 : Int)) | 1 => (BitVec.ofInt _ (10266682108794308529 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (904748877901252368 : Int)) | 1 => (BitVec.ofInt _ (503558520467377012 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (8343416078121339526 : Int)) | 1 => (BitVec.ofInt _ (1115638968584499365 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (10020122029540186094 : Int)) | 1 => (BitVec.ofInt _ (15915994253676472947 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (3627231211159834883 : Int)) | 1 => (BitVec.ofInt _ (6669286044793535959 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (10644815379815891353 : Int)) | 1 => (BitVec.ofInt _ (8838000522921658393 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (15913769671709101179 : Int)) | 1 => (BitVec.ofInt _ (9349526574189301234 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (10017478081591584438 : Int)) | 1 => (BitVec.ofInt _ (168672670847687157 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (9589580021487577656 : Int)) | 1 => (BitVec.ofInt _ (5319637290505623399 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (9685845497182567293 : Int)) | 1 => (BitVec.ofInt _ (7954146682426370628 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (3478182642257748132 : Int)) | 1 => (BitVec.ofInt _ (1354165548463510998 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (9989439431540335236 : Int)) | 1 => (BitVec.ofInt _ (12708607489589097421 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (17059803330101822100 : Int)) | 1 => (BitVec.ofInt _ (8039939114238648416 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (4187294482049103971 : Int)) | 1 => (BitVec.ofInt _ (6156076697532101059 : Int)) | _ => default) }, true),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (14522461945572682142 : Int)) | 1 => (BitVec.ofInt _ (14087868569892495276 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (13440509310306477826 : Int)) | 1 => (BitVec.ofInt _ (16263902025446620569 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (18326766487615595183 : Int)) | 1 => (BitVec.ofInt _ (8069084231193273174 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (9976877718685644121 : Int)) | 1 => (BitVec.ofInt _ (16050834387474340422 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (7134277144520061784 : Int)) | 1 => (BitVec.ofInt _ (1614306976796133330 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (1036972959025397937 : Int)) | 1 => (BitVec.ofInt _ (15106646091929719175 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (8003915158139621880 : Int)) | 1 => (BitVec.ofInt _ (463965564385362047 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (16423276823093566686 : Int)) | 1 => (BitVec.ofInt _ (3150534322222068608 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (12476006348759890441 : Int)) | 1 => (BitVec.ofInt _ (17737027702451735013 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (13483111394477789797 : Int)) | 1 => (BitVec.ofInt _ (2224850944530324909 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (4032776106037118993 : Int)) | 1 => (BitVec.ofInt _ (14535766252281968332 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (8685975098404435390 : Int)) | 1 => (BitVec.ofInt _ (15351698240991132741 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (12786425171693070641 : Int)) | 1 => (BitVec.ofInt _ (1868257277367183039 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (14959947051163918811 : Int)) | 1 => (BitVec.ofInt _ (5854870349382706312 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (4070899745310671092 : Int)) | 1 => (BitVec.ofInt _ (11496480539513066154 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (1604003095135783881 : Int)) | 1 => (BitVec.ofInt _ (3677691401161333575 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (15549847508312607562 : Int)) | 1 => (BitVec.ofInt _ (2782971831944583154 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (10950105351225447784 : Int)) | 1 => (BitVec.ofInt _ (7754658195134354375 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (6148912216893265337 : Int)) | 1 => (BitVec.ofInt _ (6250452362909991862 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (2579683811098398058 : Int)) | 1 => (BitVec.ofInt _ (6651717901508766794 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (1796911852039993493 : Int)) | 1 => (BitVec.ofInt _ (17957153186770413139 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (16312589848929923834 : Int)) | 1 => (BitVec.ofInt _ (15839597673541262773 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (14942721826189067179 : Int)) | 1 => (BitVec.ofInt _ (12255702105675414640 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (16728234796709047129 : Int)) | 1 => (BitVec.ofInt _ (10216366654095562030 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (10975081259575808852 : Int)) | 1 => (BitVec.ofInt _ (6515799307884465071 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (8490954480129721000 : Int)) | 1 => (BitVec.ofInt _ (9410936329517385343 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (13039493518510858904 : Int)) | 1 => (BitVec.ofInt _ (6286071569291270535 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (11314160002587460867 : Int)) | 1 => (BitVec.ofInt _ (16487465027297282600 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (1648246898236700792 : Int)) | 1 => (BitVec.ofInt _ (12861231036018515941 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (4387706650777905066 : Int)) | 1 => (BitVec.ofInt _ (5218765401396936336 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (9102481171441551296 : Int)) | 1 => (BitVec.ofInt _ (12046302108007769590 : Int)) | _ => default) }, false),
  ({ data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (7210312690463709026 : Int)) | 1 => (BitVec.ofInt _ (7230713369174934128 : Int)) | _ => default) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("out", Lean.Json.arr (((List.finRange 2).map (fun j0 => Lean.toJson ((o.«out») j0).toNat)).toArray))]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("stored", Lean.Json.arr (((List.finRange 2).map (fun j0 => Lean.toJson ((s.stored) j0).toNat)).toArray))]
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { data := (fun j => match j.val with | 0 => (BitVec.ofInt _ (559543822221989865 : Int)) | 1 => (BitVec.ofInt _ (12238994951278904985 : Int)) | _ => default) }
  let mut state : State p := resetState p first
  let mut cycle : Nat := 0
  for entry in inputsTrace do
    let (inputs, reset) := entry
    if !outputDefined p inputs state && !(cycle == 0 && false) then throw (IO.userError "Undefined output operation in input trace")
    let pre := output p inputs state
    if !transitionDefined p inputs state reset then throw (IO.userError "Undefined transition operation in input trace")
    let next := step p inputs state reset
    if !outputDefined p inputs next then throw (IO.userError "Undefined output operation after clock edge")
    let post := output p inputs next
    IO.println (Lean.Json.mkObj [("cycle", Lean.toJson cycle), ("pre", outputsJson pre),
      ("post", outputsJson post), ("state", stateJson next)]).compress
    state := next
    cycle := cycle + 1
