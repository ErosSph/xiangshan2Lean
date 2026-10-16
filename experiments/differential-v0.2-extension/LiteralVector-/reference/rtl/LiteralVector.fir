circuit LiteralVector :
  module LiteralVector :
    input a : UInt<3>
    output out : UInt<4>[3]

    wire v : UInt<4>[3] @[Mainstream.scala 105:18]
    v[0] <= a @[Mainstream.scala 105:18]
    v[1] <= UInt<1>("h1") @[Mainstream.scala 105:18]
    v[2] <= UInt<4>("h7") @[Mainstream.scala 105:18]
    out <= v @[Mainstream.scala 106:7]

