circuit BoolState :
  module BoolState :
    input clock : Clock
    input reset : UInt<1>
    input enable : UInt<1>
    output out : UInt<1>

    reg r : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Advanced.scala 54:18]
    when enable : @[Advanced.scala 55:16]
      node _r_T = eq(r, UInt<1>("h0")) @[Advanced.scala 55:23]
      r <= _r_T @[Advanced.scala 55:20]
    out <= r @[Advanced.scala 56:7]

