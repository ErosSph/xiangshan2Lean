FIRRTL version 1.1.0
circuit SignedDivision : @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\SignedDivision-w8\reference\rtl\SignedDivision.fir 1:0]
  module SignedDivision : @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\SignedDivision-w8\reference\rtl\SignedDivision.fir 2:2]
    input a : SInt<8> @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\SignedDivision-w8\reference\rtl\SignedDivision.fir 3:4]
    input b : SInt<8> @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\SignedDivision-w8\reference\rtl\SignedDivision.fir 4:4]
    output quotient : SInt<9> @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\SignedDivision-w8\reference\rtl\SignedDivision.fir 5:4]
    output remainder : SInt<8> @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\SignedDivision-w8\reference\rtl\SignedDivision.fir 6:4]

    node _quotient_T = div(a, b) @[Mainstream.scala 82:17 E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\SignedDivision-w8\reference\rtl\SignedDivision.fir 8:4]
    node _remainder_T = rem(a, b) @[Mainstream.scala 83:18 E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\SignedDivision-w8\reference\rtl\SignedDivision.fir 10:4]
    quotient <= _quotient_T @[Mainstream.scala 82:12 E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\SignedDivision-w8\reference\rtl\SignedDivision.fir 9:4]
    remainder <= _remainder_T @[Mainstream.scala 83:13 E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\SignedDivision-w8\reference\rtl\SignedDivision.fir 11:4]
