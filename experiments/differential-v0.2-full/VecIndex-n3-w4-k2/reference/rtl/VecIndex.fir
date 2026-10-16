circuit VecIndex :
  module VecIndex :
    input clock : Clock
    input reset : UInt<1>
    input in : UInt<4>[3]
    output out : UInt<4>

    out <= in[2] @[Features.scala 134:7]

