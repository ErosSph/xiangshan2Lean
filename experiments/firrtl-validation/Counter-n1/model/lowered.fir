FIRRTL version 1.1.0
circuit Counter : @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\Counter-n1\reference\rtl\Counter.fir 1:0]
  module Counter : @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\Counter-n1\reference\rtl\Counter.fir 2:2]
    input clock : Clock @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\Counter-n1\reference\rtl\Counter.fir 3:4]
    input reset : UInt<1> @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\Counter-n1\reference\rtl\Counter.fir 4:4]
    input io_en : UInt<1> @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\Counter-n1\reference\rtl\Counter.fir 5:4]
    output io_q : UInt<1> @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\Counter-n1\reference\rtl\Counter.fir 5:4]

    reg cnt : UInt<1>, clock with :
      reset => (UInt<1>("h0"), cnt) @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\Counter-n1\reference\rtl\Counter.fir 7:4]
    node _cnt_T = add(cnt, UInt<1>("h1")) @[Probes.scala 12:28 E:\ICT\chisel2lean4\experiments\differential-v0.2-full\Counter-n1\reference\rtl\Counter.fir 10:6]
    node _cnt_T_1 = tail(_cnt_T, 1) @[Probes.scala 12:28 E:\ICT\chisel2lean4\experiments\differential-v0.2-full\Counter-n1\reference\rtl\Counter.fir 11:6]
    node _GEN_0 = mux(io_en, _cnt_T_1, cnt) @[Probes.scala 12:15 E:\ICT\chisel2lean4\experiments\differential-v0.2-full\Counter-n1\reference\rtl\Counter.fir 9:4 Probes.scala 12:21 E:\ICT\chisel2lean4\experiments\differential-v0.2-full\Counter-n1\reference\rtl\Counter.fir 12:6 7:4]
    io_q <= cnt @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\Counter-n1\reference\rtl\Counter.fir 13:4 Probes.scala 13:8]
    cnt <= mux(reset, UInt<1>("h0"), _GEN_0) @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\Counter-n1\reference\rtl\Counter.fir 7:{4,4}]
