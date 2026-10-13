circuit ElaborationLiteral :
  module ElaborationLiteral :
    input clock : Clock
    input reset : UInt<1>
    input in : UInt<3>
    output out : UInt<3>

    out <= UInt<3>("h1") @[Advanced.scala 18:7]

