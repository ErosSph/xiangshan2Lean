circuit ElaborationLiteral :
  module ElaborationLiteral :
    input clock : Clock
    input reset : UInt<1>
    input in : UInt<4>
    output out : UInt<4>

    out <= UInt<4>("hf") @[Advanced.scala 18:7]

