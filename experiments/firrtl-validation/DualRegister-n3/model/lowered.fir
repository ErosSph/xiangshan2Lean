FIRRTL version 1.1.0
circuit DualRegister : @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\DualRegister-n3\reference\rtl\DualRegister.fir 1:0]
  module DualRegister : @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\DualRegister-n3\reference\rtl\DualRegister.fir 2:2]
    input clock : Clock @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\DualRegister-n3\reference\rtl\DualRegister.fir 3:4]
    input reset : UInt<1> @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\DualRegister-n3\reference\rtl\DualRegister.fir 4:4]
    input io_in : UInt<3> @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\DualRegister-n3\reference\rtl\DualRegister.fir 5:4]
    output io_a : UInt<3> @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\DualRegister-n3\reference\rtl\DualRegister.fir 5:4]
    output io_b : UInt<3> @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\DualRegister-n3\reference\rtl\DualRegister.fir 5:4]

    reg first : UInt<3>, clock with :
      reset => (UInt<1>("h0"), first) @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\DualRegister-n3\reference\rtl\DualRegister.fir 7:4]
    reg second : UInt<3>, clock with :
      reset => (UInt<1>("h0"), second) @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\DualRegister-n3\reference\rtl\DualRegister.fir 9:4]
    io_a <= first @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\DualRegister-n3\reference\rtl\DualRegister.fir 13:4 Probes.scala 26:8]
    io_b <= second @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\DualRegister-n3\reference\rtl\DualRegister.fir 14:4 Probes.scala 27:8]
    first <= mux(reset, UInt<3>("h0"), io_in) @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\DualRegister-n3\reference\rtl\DualRegister.fir 11:4 7:{4,4} Probes.scala 24:9]
    second <= mux(reset, UInt<3>("h0"), first) @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\DualRegister-n3\reference\rtl\DualRegister.fir 12:4 9:{4,4} Probes.scala 25:10]
