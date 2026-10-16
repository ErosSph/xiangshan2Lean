circuit ReservedPorts :
  module ReservedPorts :
    input clock : UInt<1>
    input reset : UInt<1>
    output bit : UInt<1>
    output class : UInt<1>

    node _bit_T = and(clock, reset) @[Advanced.scala 47:16]
    bit <= _bit_T @[Advanced.scala 47:7]
    node _class_T = or(clock, reset) @[Advanced.scala 48:20]
    class <= _class_T @[Advanced.scala 48:11]

