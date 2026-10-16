import probes.SyncMemory
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open probes.SyncMemory
def p : Params := { n := (8 : Int), w := (65 : Int) }
def inputsTrace : List (Inputs p × Bool) := [
  ({ write := true, readEnable := true, waddr := (BitVec.ofInt _ (5 : Int)), raddr := (BitVec.ofInt _ (7 : Int)), data := (BitVec.ofInt _ (1358736949838177847 : Int)) }, true),
  ({ write := false, readEnable := true, waddr := (BitVec.ofInt _ (3 : Int)), raddr := (BitVec.ofInt _ (2 : Int)), data := (BitVec.ofInt _ (26781488172453841940 : Int)) }, false),
  ({ write := false, readEnable := true, waddr := (BitVec.ofInt _ (2 : Int)), raddr := (BitVec.ofInt _ (3 : Int)), data := (BitVec.ofInt _ (32203424398702201502 : Int)) }, false),
  ({ write := true, readEnable := true, waddr := (BitVec.ofInt _ (5 : Int)), raddr := (BitVec.ofInt _ (7 : Int)), data := (BitVec.ofInt _ (27206506674344466245 : Int)) }, false),
  ({ write := true, readEnable := true, waddr := (BitVec.ofInt _ (6 : Int)), raddr := (BitVec.ofInt _ (3 : Int)), data := (BitVec.ofInt _ (31131896787279800392 : Int)) }, false),
  ({ write := false, readEnable := true, waddr := (BitVec.ofInt _ (0 : Int)), raddr := (BitVec.ofInt _ (7 : Int)), data := (BitVec.ofInt _ (17132182396913534892 : Int)) }, false),
  ({ write := true, readEnable := true, waddr := (BitVec.ofInt _ (2 : Int)), raddr := (BitVec.ofInt _ (0 : Int)), data := (BitVec.ofInt _ (22209808400943317033 : Int)) }, false),
  ({ write := false, readEnable := true, waddr := (BitVec.ofInt _ (0 : Int)), raddr := (BitVec.ofInt _ (7 : Int)), data := (BitVec.ofInt _ (19757577365217010959 : Int)) }, false),
  ({ write := false, readEnable := true, waddr := (BitVec.ofInt _ (4 : Int)), raddr := (BitVec.ofInt _ (2 : Int)), data := (BitVec.ofInt _ (33806790077006384778 : Int)) }, false),
  ({ write := false, readEnable := true, waddr := (BitVec.ofInt _ (6 : Int)), raddr := (BitVec.ofInt _ (2 : Int)), data := (BitVec.ofInt _ (11877084023196831941 : Int)) }, false),
  ({ write := false, readEnable := true, waddr := (BitVec.ofInt _ (3 : Int)), raddr := (BitVec.ofInt _ (7 : Int)), data := (BitVec.ofInt _ (29363506918350887646 : Int)) }, false),
  ({ write := false, readEnable := true, waddr := (BitVec.ofInt _ (5 : Int)), raddr := (BitVec.ofInt _ (4 : Int)), data := (BitVec.ofInt _ (27020180490924327820 : Int)) }, false),
  ({ write := true, readEnable := true, waddr := (BitVec.ofInt _ (4 : Int)), raddr := (BitVec.ofInt _ (3 : Int)), data := (BitVec.ofInt _ (25117026730015622380 : Int)) }, false),
  ({ write := true, readEnable := true, waddr := (BitVec.ofInt _ (2 : Int)), raddr := (BitVec.ofInt _ (5 : Int)), data := (BitVec.ofInt _ (30223915569124587435 : Int)) }, false),
  ({ write := false, readEnable := true, waddr := (BitVec.ofInt _ (5 : Int)), raddr := (BitVec.ofInt _ (3 : Int)), data := (BitVec.ofInt _ (14523945897447868416 : Int)) }, false),
  ({ write := false, readEnable := true, waddr := (BitVec.ofInt _ (1 : Int)), raddr := (BitVec.ofInt _ (4 : Int)), data := (BitVec.ofInt _ (25642552809013799801 : Int)) }, false),
  ({ write := true, readEnable := true, waddr := (BitVec.ofInt _ (3 : Int)), raddr := (BitVec.ofInt _ (5 : Int)), data := (BitVec.ofInt _ (30732200890085069662 : Int)) }, false),
  ({ write := true, readEnable := true, waddr := (BitVec.ofInt _ (0 : Int)), raddr := (BitVec.ofInt _ (5 : Int)), data := (BitVec.ofInt _ (13491981417592138371 : Int)) }, false),
  ({ write := false, readEnable := true, waddr := (BitVec.ofInt _ (5 : Int)), raddr := (BitVec.ofInt _ (0 : Int)), data := (BitVec.ofInt _ (19866612291026214687 : Int)) }, false),
  ({ write := false, readEnable := true, waddr := (BitVec.ofInt _ (5 : Int)), raddr := (BitVec.ofInt _ (2 : Int)), data := (BitVec.ofInt _ (33563152514723274964 : Int)) }, false),
  ({ write := false, readEnable := true, waddr := (BitVec.ofInt _ (4 : Int)), raddr := (BitVec.ofInt _ (3 : Int)), data := (BitVec.ofInt _ (4143375483643395874 : Int)) }, false),
  ({ write := true, readEnable := true, waddr := (BitVec.ofInt _ (1 : Int)), raddr := (BitVec.ofInt _ (6 : Int)), data := (BitVec.ofInt _ (21552199923127482371 : Int)) }, false),
  ({ write := false, readEnable := true, waddr := (BitVec.ofInt _ (1 : Int)), raddr := (BitVec.ofInt _ (7 : Int)), data := (BitVec.ofInt _ (5001064848129243787 : Int)) }, false),
  ({ write := true, readEnable := true, waddr := (BitVec.ofInt _ (6 : Int)), raddr := (BitVec.ofInt _ (5 : Int)), data := (BitVec.ofInt _ (31679256769258816354 : Int)) }, false),
  ({ write := false, readEnable := true, waddr := (BitVec.ofInt _ (7 : Int)), raddr := (BitVec.ofInt _ (7 : Int)), data := (BitVec.ofInt _ (15559237543755187230 : Int)) }, true),
  ({ write := false, readEnable := true, waddr := (BitVec.ofInt _ (1 : Int)), raddr := (BitVec.ofInt _ (0 : Int)), data := (BitVec.ofInt _ (784481317040692027 : Int)) }, false),
  ({ write := true, readEnable := true, waddr := (BitVec.ofInt _ (4 : Int)), raddr := (BitVec.ofInt _ (7 : Int)), data := (BitVec.ofInt _ (36366770992267324080 : Int)) }, false),
  ({ write := true, readEnable := true, waddr := (BitVec.ofInt _ (5 : Int)), raddr := (BitVec.ofInt _ (7 : Int)), data := (BitVec.ofInt _ (19843949951111048368 : Int)) }, false),
  ({ write := false, readEnable := true, waddr := (BitVec.ofInt _ (4 : Int)), raddr := (BitVec.ofInt _ (7 : Int)), data := (BitVec.ofInt _ (30522067631327418910 : Int)) }, false),
  ({ write := false, readEnable := true, waddr := (BitVec.ofInt _ (4 : Int)), raddr := (BitVec.ofInt _ (4 : Int)), data := (BitVec.ofInt _ (29218812537477133056 : Int)) }, false),
  ({ write := true, readEnable := true, waddr := (BitVec.ofInt _ (6 : Int)), raddr := (BitVec.ofInt _ (5 : Int)), data := (BitVec.ofInt _ (13167432107232284556 : Int)) }, false),
  ({ write := false, readEnable := true, waddr := (BitVec.ofInt _ (6 : Int)), raddr := (BitVec.ofInt _ (6 : Int)), data := (BitVec.ofInt _ (8829475658362150798 : Int)) }, false),
  ({ write := true, readEnable := true, waddr := (BitVec.ofInt _ (6 : Int)), raddr := (BitVec.ofInt _ (1 : Int)), data := (BitVec.ofInt _ (23056091162542755482 : Int)) }, false),
  ({ write := false, readEnable := true, waddr := (BitVec.ofInt _ (7 : Int)), raddr := (BitVec.ofInt _ (0 : Int)), data := (BitVec.ofInt _ (16471283266478743284 : Int)) }, false),
  ({ write := true, readEnable := true, waddr := (BitVec.ofInt _ (0 : Int)), raddr := (BitVec.ofInt _ (7 : Int)), data := (BitVec.ofInt _ (9372982186470679233 : Int)) }, false),
  ({ write := true, readEnable := true, waddr := (BitVec.ofInt _ (6 : Int)), raddr := (BitVec.ofInt _ (5 : Int)), data := (BitVec.ofInt _ (34662408570783731332 : Int)) }, false),
  ({ write := false, readEnable := true, waddr := (BitVec.ofInt _ (0 : Int)), raddr := (BitVec.ofInt _ (2 : Int)), data := (BitVec.ofInt _ (28162144959449735258 : Int)) }, false),
  ({ write := false, readEnable := true, waddr := (BitVec.ofInt _ (0 : Int)), raddr := (BitVec.ofInt _ (4 : Int)), data := (BitVec.ofInt _ (32650527431873258793 : Int)) }, false),
  ({ write := true, readEnable := true, waddr := (BitVec.ofInt _ (5 : Int)), raddr := (BitVec.ofInt _ (2 : Int)), data := (BitVec.ofInt _ (8721270685008284864 : Int)) }, false),
  ({ write := true, readEnable := true, waddr := (BitVec.ofInt _ (2 : Int)), raddr := (BitVec.ofInt _ (7 : Int)), data := (BitVec.ofInt _ (14763070052335005156 : Int)) }, false),
  ({ write := false, readEnable := true, waddr := (BitVec.ofInt _ (3 : Int)), raddr := (BitVec.ofInt _ (3 : Int)), data := (BitVec.ofInt _ (35755172179829022630 : Int)) }, false),
  ({ write := true, readEnable := true, waddr := (BitVec.ofInt _ (1 : Int)), raddr := (BitVec.ofInt _ (2 : Int)), data := (BitVec.ofInt _ (35127294161350507790 : Int)) }, false),
  ({ write := true, readEnable := true, waddr := (BitVec.ofInt _ (4 : Int)), raddr := (BitVec.ofInt _ (7 : Int)), data := (BitVec.ofInt _ (25110800828406753068 : Int)) }, false),
  ({ write := false, readEnable := true, waddr := (BitVec.ofInt _ (5 : Int)), raddr := (BitVec.ofInt _ (5 : Int)), data := (BitVec.ofInt _ (32612351989626145655 : Int)) }, false),
  ({ write := true, readEnable := true, waddr := (BitVec.ofInt _ (5 : Int)), raddr := (BitVec.ofInt _ (4 : Int)), data := (BitVec.ofInt _ (16132488279700790840 : Int)) }, false),
  ({ write := false, readEnable := true, waddr := (BitVec.ofInt _ (7 : Int)), raddr := (BitVec.ofInt _ (7 : Int)), data := (BitVec.ofInt _ (21521974873863698336 : Int)) }, false),
  ({ write := false, readEnable := true, waddr := (BitVec.ofInt _ (0 : Int)), raddr := (BitVec.ofInt _ (6 : Int)), data := (BitVec.ofInt _ (12876073559458615511 : Int)) }, false),
  ({ write := true, readEnable := true, waddr := (BitVec.ofInt _ (6 : Int)), raddr := (BitVec.ofInt _ (0 : Int)), data := (BitVec.ofInt _ (12830033909609752495 : Int)) }, false)]
def outputsJson (o : Outputs p) : Lean.Json := Lean.Json.mkObj [("out", Lean.toJson (o.«out»).toNat)]
def stateJson (s : State p) : Lean.Json := Lean.Json.mkObj [("memory", Lean.Json.arr (((List.finRange 8).map (fun j0 => Lean.toJson ((s.memory) j0).toNat)).toArray)), ("__memory_memory_read_0", Lean.toJson (s.__memory_memory_read_0).toNat), ("__memory_memory_read_0_valid", Lean.toJson (s.__memory_memory_read_0_valid))]
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := { write := true, readEnable := true, waddr := (BitVec.ofInt _ (5 : Int)), raddr := (BitVec.ofInt _ (7 : Int)), data := (BitVec.ofInt _ (1358736949838177847 : Int)) }
  let mut state : State p := { memory := (fun j => match j.val with | 0 => (BitVec.ofInt _ (0 : Int)) | 1 => (BitVec.ofInt _ (0 : Int)) | 2 => (BitVec.ofInt _ (0 : Int)) | 3 => (BitVec.ofInt _ (0 : Int)) | 4 => (BitVec.ofInt _ (0 : Int)) | 5 => (BitVec.ofInt _ (0 : Int)) | 6 => (BitVec.ofInt _ (0 : Int)) | 7 => (BitVec.ofInt _ (0 : Int)) | _ => default), __memory_memory_read_0 := (BitVec.ofInt _ (0 : Int)), __memory_memory_read_0_valid := false }
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
