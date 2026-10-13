FIRRTL version 1.1.0
circuit Priority : @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\Priority-n3\reference\rtl\Priority.fir 1:0]
  module Priority : @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\Priority-n3\reference\rtl\Priority.fir 2:2]
    input clock : Clock @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\Priority-n3\reference\rtl\Priority.fir 3:4]
    input reset : UInt<1> @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\Priority-n3\reference\rtl\Priority.fir 4:4]
    input io_en : UInt<1> @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\Priority-n3\reference\rtl\Priority.fir 5:4]
    input io_clear : UInt<1> @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\Priority-n3\reference\rtl\Priority.fir 5:4]
    output io_q : UInt<3> @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\Priority-n3\reference\rtl\Priority.fir 5:4]

    reg cnt : UInt<3>, clock with :
      reset => (UInt<1>("h0"), cnt) @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\Priority-n3\reference\rtl\Priority.fir 7:4]
    node _cnt_T = add(cnt, UInt<1>("h1")) @[Probes.scala 37:28 E:\ICT\chisel2lean4\experiments\differential-v0.2-full\Priority-n3\reference\rtl\Priority.fir 10:6]
    node _cnt_T_1 = tail(_cnt_T, 1) @[Probes.scala 37:28 E:\ICT\chisel2lean4\experiments\differential-v0.2-full\Priority-n3\reference\rtl\Priority.fir 11:6]
    node _GEN_0 = mux(io_en, _cnt_T_1, cnt) @[Probes.scala 37:15 E:\ICT\chisel2lean4\experiments\differential-v0.2-full\Priority-n3\reference\rtl\Priority.fir 9:4 Probes.scala 37:21 E:\ICT\chisel2lean4\experiments\differential-v0.2-full\Priority-n3\reference\rtl\Priority.fir 12:6 7:4]
    node _GEN_1 = mux(io_clear, UInt<1>("h0"), _GEN_0) @[Probes.scala 38:18 E:\ICT\chisel2lean4\experiments\differential-v0.2-full\Priority-n3\reference\rtl\Priority.fir 13:4 Probes.scala 38:24 E:\ICT\chisel2lean4\experiments\differential-v0.2-full\Priority-n3\reference\rtl\Priority.fir 14:6]
    io_q <= cnt @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\Priority-n3\reference\rtl\Priority.fir 15:4 Probes.scala 39:8]
    cnt <= mux(reset, UInt<3>("h0"), _GEN_1) @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\Priority-n3\reference\rtl\Priority.fir 7:{4,4}]
