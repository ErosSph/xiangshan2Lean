circuit ElaborationLiteral :
  module ElaborationLiteral :
    input clock : Clock
    input reset : UInt<1>
    input in : UInt<1>
    output out : UInt<1>

    out <= UInt<1>("h1") @[Advanced.scala 18:7]

