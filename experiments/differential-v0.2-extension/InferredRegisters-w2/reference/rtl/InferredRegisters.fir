circuit InferredRegisters :
  module InferredRegisters :
    input clock : Clock
    input reset : UInt<1>
    input in : UInt<2>
    output out : UInt<3>

    reg unforced : UInt, clock with :
      reset => (reset, UInt<1>("h0")) @[Mainstream.scala 113:25]
    node _widened_T = add(in, UInt<1>("h1")) @[Mainstream.scala 114:28]
    reg widened : UInt, clock with :
      reset => (reset, UInt<1>("h0")) @[Mainstream.scala 114:24]
    widened <= _widened_T @[Mainstream.scala 114:24]
    wire wire : UInt @[Mainstream.scala 115:18]
    wire <= in @[Mainstream.scala 116:8]
    wire <= UInt<1>("h0") @[Mainstream.scala 117:8]
    unforced <= in @[Mainstream.scala 118:12]
    node _out_T = add(widened, unforced) @[Mainstream.scala 119:18]
    node _out_T_1 = tail(_out_T, 1) @[Mainstream.scala 119:18]
    node _out_T_2 = add(_out_T_1, wire) @[Mainstream.scala 119:29]
    node _out_T_3 = tail(_out_T_2, 1) @[Mainstream.scala 119:29]
    out <= _out_T_3 @[Mainstream.scala 119:7]

