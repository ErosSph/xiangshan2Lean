FIRRTL version 1.1.0
circuit Division : @[E:\ICT\chisel2lean4\experiments\firrtl-contracts\division.fir 1:0]
  module Division : @[E:\ICT\chisel2lean4\experiments\firrtl-contracts\division.fir 2:2]
    input a : UInt<8> @[E:\ICT\chisel2lean4\experiments\firrtl-contracts\division.fir 3:4]
    input b : UInt<8> @[E:\ICT\chisel2lean4\experiments\firrtl-contracts\division.fir 4:4]
    output q : UInt<8> @[E:\ICT\chisel2lean4\experiments\firrtl-contracts\division.fir 5:4]

    q <= div(a, b) @[E:\ICT\chisel2lean4\experiments\firrtl-contracts\division.fir 6:4]
