circuit MultiClock :
  module MultiClock :
    input a : Clock
    input b : Clock
    output q : UInt<8>
    reg r : UInt<8>, a
    reg s : UInt<8>, b
    r <= UInt<8>(1)
    s <= r
    q <= s
