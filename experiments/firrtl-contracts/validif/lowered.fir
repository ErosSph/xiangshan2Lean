FIRRTL version 1.1.0
circuit ConditionalValue : @[E:\ICT\chisel2lean4\experiments\firrtl-contracts\validif.fir 1:0]
  module ConditionalValue : @[E:\ICT\chisel2lean4\experiments\firrtl-contracts\validif.fir 2:2]
    input en : UInt<1> @[E:\ICT\chisel2lean4\experiments\firrtl-contracts\validif.fir 3:4]
    input a : UInt<8> @[E:\ICT\chisel2lean4\experiments\firrtl-contracts\validif.fir 4:4]
    output q : UInt<8> @[E:\ICT\chisel2lean4\experiments\firrtl-contracts\validif.fir 5:4]

    q <= validif(en, a) @[E:\ICT\chisel2lean4\experiments\firrtl-contracts\validif.fir 6:4]
