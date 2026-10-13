circuit ElaborationWidth :
  module ElaborationWidth :
    input clock : Clock
    input reset : UInt<1>
    input in : UInt<2>
    output out : UInt<6>

    node _out_T = add(UInt<2>("h3"), UInt<1>("h1")) @[Advanced.scala 10:19]
    node _out_T_1 = tail(_out_T, 1) @[Advanced.scala 10:19]
    out <= _out_T_1 @[Advanced.scala 10:7]

