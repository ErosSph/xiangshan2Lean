import probes.Arithmetic
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.Arithmetic
def p : Params := { aWidth := (128 : Int), bWidth := (65 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ io_a := (BitVec.ofInt _ (199786079455810795641884007829290970705 : Int)), io_b := (BitVec.ofInt _ (11068249182358415890 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (52096630278522010683371757209779893657 : Int)), io_b := (BitVec.ofInt _ (25768231011913817324 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (161711876577834715148508054557439175481 : Int)), io_b := (BitVec.ofInt _ (33071341065308219070 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (179893466481934341980710604642561872822 : Int)), io_b := (BitVec.ofInt _ (22209808400943317033 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (286294950408024274038415605754775241330 : Int)), io_b := (BitVec.ofInt _ (18162706201876985059 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (100233700330137880016649331391237100386 : Int)), io_b := (BitVec.ofInt _ (33806790077006384778 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (231435861451351375300349202795458981357 : Int)), io_b := (BitVec.ofInt _ (14008862305554434748 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (158151987420582323784216292154638079017 : Int)), io_b := (BitVec.ofInt _ (15203696076386819428 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (203666503889943696312023784326784603226 : Int)), io_b := (BitVec.ofInt _ (13257378044490745408 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (91135348134992976106708858244748709739 : Int)), io_b := (BitVec.ofInt _ (3836022510526387568 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (189834160090394277255322743522800116363 : Int)), io_b := (BitVec.ofInt _ (23618018567413234713 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (57630629385207121213693897139127147496 : Int)), io_b := (BitVec.ofInt _ (24557660523502983805 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (179143245613426909251588061179324396224 : Int)), io_b := (BitVec.ofInt _ (7640619212141257374 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (62553844568724272204094469803878667313 : Int)), io_b := (BitVec.ofInt _ (10876544242404062696 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (139579284209909602828809937354678176130 : Int)), io_b := (BitVec.ofInt _ (32795285936171624290 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (299243356268016955142736568950754726704 : Int)), io_b := (BitVec.ofInt _ (35170714739843255271 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (4917462072436426639431435532777640678 : Int)), io_b := (BitVec.ofInt _ (604630340569620264 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (293112999151274879207289519733307351023 : Int)), io_b := (BitVec.ofInt _ (15559237543755187230 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (340203152512482144228801460776725311479 : Int)), io_b := (BitVec.ofInt _ (18929952534919580057 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (330566150360621226975821196441056360756 : Int)), io_b := (BitVec.ofInt _ (12542766549496203811 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (56297885079784883985675387283367963824 : Int)), io_b := (BitVec.ofInt _ (29182231240256892067 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (55553904500922470031232923555188972062 : Int)), io_b := (BitVec.ofInt _ (30048331306343040557 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (42490128125666795380644983702052136208 : Int)), io_b := (BitVec.ofInt _ (36286374195293794535 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (198709590095598186781530738818752084953 : Int)), io_b := (BitVec.ofInt _ (34837234256336118205 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (75337237006899938255418060667901932196 : Int)), io_b := (BitVec.ofInt _ (34347870805577847877 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (85027446094604277578561792438502114701 : Int)), io_b := (BitVec.ofInt _ (17822333659859232320 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (12887113208998920466811273920818154172 : Int)), io_b := (BitVec.ofInt _ (9372982186470679233 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (124228394805530864422387356395758788057 : Int)), io_b := (BitVec.ofInt _ (416016088331017858 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (111766764786144197637208791209964568462 : Int)), io_b := (BitVec.ofInt _ (22696225133343863252 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (160879048323893420482370809902233948526 : Int)), io_b := (BitVec.ofInt _ (33664812529798238660 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (27568404465877382405125655786372115940 : Int)), io_b := (BitVec.ofInt _ (23664212358271853480 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (307701838475406150141176935126681574579 : Int)), io_b := (BitVec.ofInt _ (26494954369132176677 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (184455842379612072837550368873138198667 : Int)), io_b := (BitVec.ofInt _ (24922927348792174310 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (278455691012525547027447397353010678370 : Int)), io_b := (BitVec.ofInt _ (9889934851903349927 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (198757059695270708069671299358048434617 : Int)), io_b := (BitVec.ofInt _ (806605060783086945 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (232011956700951429422958701165899638997 : Int)), io_b := (BitVec.ofInt _ (9635134264170982824 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (236672351987586290889734211730998592498 : Int)), io_b := (BitVec.ofInt _ (30869759253076095998 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (125977471022426575886241951109073824000 : Int)), io_b := (BitVec.ofInt _ (4432422044112450777 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (23721673268736655873990588870758712908 : Int)), io_b := (BitVec.ofInt _ (31173272675118597546 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (264656685604807287109173943471602721336 : Int)), io_b := (BitVec.ofInt _ (6552874237724230532 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (321420707780116580319509891587796365297 : Int)), io_b := (BitVec.ofInt _ (26727505874557683823 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (239064416533598282954186690698018857493 : Int)), io_b := (BitVec.ofInt _ (3411896940003263300 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (93558012624431732819438441413631641407 : Int)), io_b := (BitVec.ofInt _ (18623496140700452930 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (4978779204579379998244429445063551821 : Int)), io_b := (BitVec.ofInt _ (25879409048115663183 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (10847821935325255535245457600687849869 : Int)), io_b := (BitVec.ofInt _ (25254255851716489277 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (88265011487716390981907169320367722143 : Int)), io_b := (BitVec.ofInt _ (19292755969868636472 : Int)), io_choose := false }, false),
  ({ io_a := (BitVec.ofInt _ (249303605537107533213006301522682971753 : Int)), io_b := (BitVec.ofInt _ (35429636619625541245 : Int)), io_choose := true }, false),
  ({ io_a := (BitVec.ofInt _ (139330953380638941025190697189247574165 : Int)), io_b := (BitVec.ofInt _ (10653085655679271183 : Int)), io_choose := false }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("io.carry", Lean.toJson (o.io_carry).toNat), ("io.concat", Lean.toJson (o.io_concat).toNat), ("io.equal", Lean.toJson (o.io_equal)), ("io.less", Lean.toJson (o.io_less)), ("io.product", Lean.toJson (o.io_product).toNat), ("io.selected", Lean.toJson (o.io_selected).toNat), ("io.sub", Lean.toJson (o.io_sub).toNat), ("io.sum", Lean.toJson (o.io_sum).toNat), ("io.xor", Lean.toJson (o.io_xor).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj []
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { io_a := (BitVec.ofInt _ (199786079455810795641884007829290970705 : Int)), io_b := (BitVec.ofInt _ (11068249182358415890 : Int)), io_choose := false }
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
