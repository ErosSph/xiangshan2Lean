FIRRTL version 1.1.0
circuit ResetFromInput : @[E:\ICT\chisel2lean4\experiments\differential-v0.2-edge\ResetFromInput-w3\reference\rtl\ResetFromInput.fir 1:0]
  module ResetFromInput : @[E:\ICT\chisel2lean4\experiments\differential-v0.2-edge\ResetFromInput-w3\reference\rtl\ResetFromInput.fir 2:2]
    input clock : Clock @[E:\ICT\chisel2lean4\experiments\differential-v0.2-edge\ResetFromInput-w3\reference\rtl\ResetFromInput.fir 3:4]
    input reset : UInt<1> @[E:\ICT\chisel2lean4\experiments\differential-v0.2-edge\ResetFromInput-w3\reference\rtl\ResetFromInput.fir 4:4]
    input in : UInt<3> @[E:\ICT\chisel2lean4\experiments\differential-v0.2-edge\ResetFromInput-w3\reference\rtl\ResetFromInput.fir 5:4]
    output out : UInt<3> @[E:\ICT\chisel2lean4\experiments\differential-v0.2-edge\ResetFromInput-w3\reference\rtl\ResetFromInput.fir 6:4]

    reg r : UInt<3>, clock with :
      reset => (UInt<1>("h0"), r) @[E:\ICT\chisel2lean4\experiments\differential-v0.2-edge\ResetFromInput-w3\reference\rtl\ResetFromInput.fir 8:4]
    node _r_T = add(r, UInt<1>("h1")) @[Advanced.scala 63:10 E:\ICT\chisel2lean4\experiments\differential-v0.2-edge\ResetFromInput-w3\reference\rtl\ResetFromInput.fir 10:4]
    node _r_T_1 = tail(_r_T, 1) @[Advanced.scala 63:10 E:\ICT\chisel2lean4\experiments\differential-v0.2-edge\ResetFromInput-w3\reference\rtl\ResetFromInput.fir 11:4]
    out <= r @[Advanced.scala 64:7 E:\ICT\chisel2lean4\experiments\differential-v0.2-edge\ResetFromInput-w3\reference\rtl\ResetFromInput.fir 13:4]
    r <= mux(reset, in, _r_T_1) @[E:\ICT\chisel2lean4\experiments\differential-v0.2-edge\ResetFromInput-w3\reference\rtl\ResetFromInput.fir 12:4 8:{4,4} Advanced.scala 63:5]
