circuit ElaborationWidth :
  module ElaborationWidth :
    input clock : Clock
    input reset : UInt<1>
    input in : UInt<4>
    output out : UInt<8>

    node _out_T = add(in, UInt<1>("h1")) @[Advanced.scala 10:19]
    node _out_T_1 = tail(_out_T, 1) @[Advanced.scala 10:19]
    out <= _out_T_1 @[Advanced.scala 10:7]

