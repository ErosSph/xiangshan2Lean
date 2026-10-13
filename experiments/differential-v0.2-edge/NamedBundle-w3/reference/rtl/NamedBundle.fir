circuit NamedBundle :
  module NamedBundle :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip in : UInt<3>, out : UInt<3>}

    node _io_out_T = add(io.in, UInt<1>("h1")) @[Advanced.scala 86:19]
    node _io_out_T_1 = tail(_io_out_T, 1) @[Advanced.scala 86:19]
    io.out <= _io_out_T_1 @[Advanced.scala 86:10]

