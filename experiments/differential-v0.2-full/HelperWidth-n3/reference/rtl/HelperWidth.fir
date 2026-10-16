circuit HelperWidth :
  module HelperWidth :
    input clock : Clock
    input reset : UInt<1>
    input in : UInt<4>
    output out : UInt<6>

    out <= in @[Features.scala 89:7]

