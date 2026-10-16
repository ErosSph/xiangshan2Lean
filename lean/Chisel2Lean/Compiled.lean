import Chisel2Lean.Incremental
namespace Chisel2Lean.Functional

@[inline] def compiledAt (values : Array α) (index : Nat) : Except String α :=
  match values[index]? with
  | some value => .ok value
  | none => .error s!"Array index {index} is out of range ({values.size})"

@[inline] def compiledRequire (condition : Bool) (message : String) : Except String Unit :=
  if condition then .ok () else .error message

@[inline] def Value.asBitsCompiled (value : Value) (width : Nat) : Except String (BitVec width) :=
  match value with
  | .bits n b =>
    if h : n = width then .ok (h ▸ b) else .error "Bitvector width mismatch"
  | _ => .error "Expected a bitvector"

@[inline] def Value.asBoolCompiled : Value → Except String Bool
  | .boolean value => .ok value
  | _ => .error "Expected a Boolean"

@[inline] def Value.nonzeroCompiled : Value → Except String Bool
  | .bits _ value => .ok (value != 0)
  | _ => .error "Expected a bitvector predicate"

@[inline] def evaluateNodeCompiled (inputs states : Array Value) (values : Array Value) (domains : Array Bool)
    (node : Node) : Except String (Value × Bool) := do
  if node.operation == 0 then
    match node.sort with
    | .bits width => return (.bits width (BitVec.ofNat width node.extra), true)
    | .boolean => return (.boolean (node.extra != 0), true)
    | _ => throw "Invalid constant sort"
  if node.operation == 1 || node.operation == 2 then
    return (← compiledAt (if node.operation == 1 then inputs else states) node.extra, true)
  let args ← node.args.mapM (compiledAt values)
  let deps ← node.args.mapM (compiledAt domains)
  let defined := deps.all id
  if node.operation == 3 then
    let condition ← (← compiledAt args 0).asBoolCompiled
    let index := if condition then 1 else 2
    return (← compiledAt args index, (← compiledAt deps 0) && (← compiledAt deps index))
  if node.operation == 27 || node.operation == 28 then
    match ← compiledAt args 0 with
    | .memory addressWidth width words =>
      let address ← (← compiledAt args 1).asBitsCompiled addressWidth
      let index := address.toNat
      if h : index < words.size then
        if node.operation == 27 then return (.bits width words[index], defined)
        let word ← (← compiledAt args 2).asBitsCompiled width
        return (.memory addressWidth width (words.set index word), defined)
      else throw "Memory value has an invalid word count"
    | _ => throw "Expected a memory value"
  match ← compiledAt args 0 with
  | .bits width a =>
    match node.operation with
    | 4 =>
      match ← compiledAt args 1 with
      | .bits rightWidth b => return (.bits (width + rightWidth) (a ++ b), defined)
      | _ => throw "Expected concatenation bits"
    | 5 | 6 | 7 =>
      match node.sort with
      | .bits resultWidth =>
        let result := if node.operation == 5 then BitVec.extractLsb' node.extra resultWidth a
          else if node.operation == 6 then a.setWidth resultWidth else a.signExtend resultWidth
        return (.bits resultWidth result, defined)
      | _ => throw "Expected bitvector result sort"
    | 8 => return (.bits width (~~~a), defined)
    | 9 => return (.bits width (-a), defined)
    | 20 =>
      let mut result := a
      for index in [1:args.size] do result := result ^^^ (← (← compiledAt args index).asBitsCompiled width)
      return (.bits width result, defined)
    | operation =>
      let b ← (← compiledAt args 1).asBitsCompiled width
      match operation with
      | 10 => return (.bits width (BitVec.udiv a b), defined && b != 0)
      | 11 => return (.bits width (BitVec.umod a b), defined && b != 0)
      | 12 => return (.bits width (boundedShiftLeft a b.toNat), defined)
      | 13 => return (.bits width (boundedShiftRight a b.toNat), defined)
      | 14 => return (.bits width (boundedArithShiftRight a b.toNat), defined)
      | 15 => return (.bits width (a + b), defined)
      | 16 => return (.bits width (a - b), defined)
      | 17 => return (.bits width (a * b), defined)
      | 18 => return (.bits width (a &&& b), defined)
      | 19 => return (.bits width (a ||| b), defined)
      | 21 => return (.boolean (a == b), defined)
      | 22 => return (.boolean (a != b), defined)
      | 23 => return (.boolean (decide (a.toNat > b.toNat)), defined)
      | 24 => return (.boolean (decide (a.toNat ≥ b.toNat)), defined)
      | 25 => return (.boolean (decide (a.toInt > b.toInt)), defined)
      | 26 => return (.boolean (decide (a.toInt ≥ b.toInt)), defined)
      | _ => throw "Unsupported operation during evaluation"
  | _ => throw "Expected a bitvector operand"

@[inline] def compiledSchedule (pending : Array UInt64) (index : Nat) : Except String (Array UInt64) := do
  let block := index / 64
  let bit := (1 : UInt64) <<< UInt64.ofNat (index % 64)
  return pending.set! block ((← compiledAt pending block) ||| bit)


theorem compiledAt_eq (values : Array α) (index : Nat) :
    compiledAt values index = arrayAt values index := rfl
theorem compiledRequire_eq (condition : Bool) (message : String) :
    compiledRequire condition message = require condition message := rfl
theorem asBitsCompiled_eq (value : Value) (width : Nat) :
    value.asBitsCompiled width = value.asBits width := rfl
theorem asBoolCompiled_eq (value : Value) : value.asBoolCompiled = value.asBool := rfl
theorem nonzeroCompiled_eq (value : Value) : value.nonzeroCompiled = value.nonzero := rfl
theorem evaluateNodeCompiled_eq (inputs states values : Array Value) (domains : Array Bool) (node : Node) :
    evaluateNodeCompiled inputs states values domains node = evaluateNode inputs states values domains node := rfl
theorem compiledSchedule_eq (pending : Array UInt64) (index : Nat) :
    compiledSchedule pending index = scheduleNode pending index := rfl
#print axioms compiledAt_eq
#print axioms evaluateNodeCompiled_eq
#print axioms compiledSchedule_eq
end Chisel2Lean.Functional
