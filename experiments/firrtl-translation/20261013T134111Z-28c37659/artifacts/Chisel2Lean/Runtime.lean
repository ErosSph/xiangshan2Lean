import Lean

/-! Executable support for generated Chisel 3.5.6 semantics. No extra axioms. -/
namespace Chisel2Lean.Runtime

/-- Scala Int arithmetic uses two's-complement 32-bit wraparound. -/
def int32 (x : Int) : Int := (x + 2147483648) % 4294967296 - 2147483648

def log2Ceil (x : Int) : Int :=
  if x <= 1 then 0 else Int.ofNat (Nat.log2 (x.toNat - 1) + 1)

def unsignedWidth (x : Int) : Int :=
  if x == 0 then 1 else Int.ofNat (Nat.log2 x.toNat + 1)

def signedWidth (x : Int) : Int :=
  let magnitude := if x < 0 then -x - 1 else x
  if magnitude == 0 then 1 else Int.ofNat (Nat.log2 magnitude.toNat + 2)

/-- Check literal representability without constructing a potentially huge 2^width. -/
def fitsUnsigned (value width : Int) : Bool :=
  decide (value >= 0 ∧ width >= 0 ∧
    Int.ofNat (if value == 0 then 0 else Nat.log2 value.toNat + 1) <= width)

def fitsSigned (value width : Int) : Bool :=
  let magnitude := if value < 0 then -value - 1 else value
  decide (width >= 1 ∧
    Int.ofNat ((if magnitude == 0 then 0 else Nat.log2 magnitude.toNat + 1) + 1) <= width)

/-- Accepted Vec accesses must be in range; the generator's domain records it.
    Generate-loop indices are bounded by the same symbolic Vec length. -/
def vecGet {n : Nat} {α : Type} [Inhabited α] (v : Fin n → α) (i : Nat) : α :=
  if h : i < n then v ⟨i, h⟩ else default

def xorR {n : Nat} (v : BitVec n) : Bool :=
  (List.range n).foldl (fun parity i => parity != v.getLsbD i) false

def fill (value width count : Nat) : Nat :=
  (List.range count).foldl (fun acc _ => acc * 2 ^ width + value) 0

def vecIndex (size index : Nat) : Nat :=
  index % 2 ^ (log2Ceil (Int.ofNat size)).toNat

def lookupComplete (width : Int) (keys : List Int) : Bool :=
  if width < 0 || width > log2Ceil (Int.ofNat (keys.length + 1)) then false else
    let cardinality := 2 ^ width.toNat
    ((keys.map (fun k => k.toNat % cardinality)).eraseDups.length == cardinality)

end Chisel2Lean.Runtime
