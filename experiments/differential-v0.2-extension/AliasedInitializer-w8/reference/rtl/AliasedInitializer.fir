circuit AliasedInitializer :
  module AliasedInitializer :
    input clock : Clock
    input reset : UInt<1>
    input in : UInt<8>
    output out : UInt<8>

    reg r : UInt<2>, clock with :
      reset => (reset, UInt<2>("h0")) @[Mainstream.scala 136:18]
    r <= in @[Mainstream.scala 137:5]
    out <= r @[Mainstream.scala 138:7]

