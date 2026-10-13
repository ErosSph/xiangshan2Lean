FIRRTL version 1.1.0
circuit ResetFromInput :
  module ResetFromInput :
    input clock : Clock
    input reset : UInt<1>
    input in : UInt<3>
    output out : UInt<3>

    reg r : UInt<3>, clock with :
      reset => (UInt<1>("h0"), r) @[Advanced.scala 62:18]
    node _r_T = add(r, UInt<1>("h1")) @[Advanced.scala 63:10]
    node _r_T_1 = tail(_r_T, 1) @[Advanced.scala 63:10]
    out <= r @[Advanced.scala 64:7]
    r <= mux(reset, in, _r_T_1) @[Advanced.scala 62:{18,18} 63:5]
