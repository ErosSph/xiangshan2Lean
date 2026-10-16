FIRRTL version 1.1.0
circuit RegisterIdioms : @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\RegisterIdioms-w3\reference\rtl\RegisterIdioms.fir 1:0]
  module RegisterIdioms : @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\RegisterIdioms-w3\reference\rtl\RegisterIdioms.fir 2:2]
    input clock : Clock @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\RegisterIdioms-w3\reference\rtl\RegisterIdioms.fir 3:4]
    input reset : UInt<1> @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\RegisterIdioms-w3\reference\rtl\RegisterIdioms.fir 4:4]
    input in : UInt<3> @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\RegisterIdioms-w3\reference\rtl\RegisterIdioms.fir 5:4]
    input en : UInt<1> @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\RegisterIdioms-w3\reference\rtl\RegisterIdioms.fir 6:4]
    output out : UInt<3> @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\RegisterIdioms-w3\reference\rtl\RegisterIdioms.fir 7:4]

    reg delayed : UInt<3>, clock with :
      reset => (UInt<1>("h0"), delayed) @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\RegisterIdioms-w3\reference\rtl\RegisterIdioms.fir 9:4]
    reg held : UInt<3>, clock with :
      reset => (UInt<1>("h0"), held) @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\RegisterIdioms-w3\reference\rtl\RegisterIdioms.fir 12:4]
    node _GEN_0 = mux(en, delayed, held) @[Reg.scala 36:18 E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\RegisterIdioms-w3\reference\rtl\RegisterIdioms.fir 14:4 Reg.scala 36:22 E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\RegisterIdioms-w3\reference\rtl\RegisterIdioms.fir 12:4 15:6]
    reg explicit : UInt<3>, clock with :
      reset => (UInt<1>("h0"), explicit) @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\RegisterIdioms-w3\reference\rtl\RegisterIdioms.fir 16:4]
    out <= explicit @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\RegisterIdioms-w3\reference\rtl\RegisterIdioms.fir 19:4 Mainstream.scala 24:7]
    delayed <= mux(reset, UInt<3>("h0"), in) @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\RegisterIdioms-w3\reference\rtl\RegisterIdioms.fir 11:4 9:{4,4} Mainstream.scala 20:24]
    held <= mux(reset, UInt<3>("h0"), _GEN_0) @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\RegisterIdioms-w3\reference\rtl\RegisterIdioms.fir 12:{4,4}]
    explicit <= mux(reset, UInt<1>("h0"), held) @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\RegisterIdioms-w3\reference\rtl\RegisterIdioms.fir 16:{4,4} Mainstream.scala 23:12 E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\RegisterIdioms-w3\reference\rtl\RegisterIdioms.fir 18:4]
