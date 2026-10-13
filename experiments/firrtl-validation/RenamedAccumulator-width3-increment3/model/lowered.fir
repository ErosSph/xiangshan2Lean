FIRRTL version 1.1.0
circuit RenamedAccumulator : @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\RenamedAccumulator-width3-increment3\reference\rtl\RenamedAccumulator.fir 1:0]
  module RenamedAccumulator : @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\RenamedAccumulator-width3-increment3\reference\rtl\RenamedAccumulator.fir 2:2]
    input clock : Clock @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\RenamedAccumulator-width3-increment3\reference\rtl\RenamedAccumulator.fir 3:4]
    input reset : UInt<1> @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\RenamedAccumulator-width3-increment3\reference\rtl\RenamedAccumulator.fir 4:4]
    input active : UInt<1> @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\RenamedAccumulator-width3-increment3\reference\rtl\RenamedAccumulator.fir 5:4]
    output result : UInt<3> @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\RenamedAccumulator-width3-increment3\reference\rtl\RenamedAccumulator.fir 6:4]

    reg storage : UInt<3>, clock with :
      reset => (UInt<1>("h0"), storage) @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\RenamedAccumulator-width3-increment3\reference\rtl\RenamedAccumulator.fir 8:4]
    node _storage_T = add(storage, UInt<3>("h3")) @[Features.scala 12:37 E:\ICT\chisel2lean4\experiments\differential-v0.2-full\RenamedAccumulator-width3-increment3\reference\rtl\RenamedAccumulator.fir 11:6]
    node _storage_T_1 = tail(_storage_T, 1) @[Features.scala 12:37 E:\ICT\chisel2lean4\experiments\differential-v0.2-full\RenamedAccumulator-width3-increment3\reference\rtl\RenamedAccumulator.fir 12:6]
    node _GEN_0 = mux(active, _storage_T_1, storage) @[Features.scala 12:16 E:\ICT\chisel2lean4\experiments\differential-v0.2-full\RenamedAccumulator-width3-increment3\reference\rtl\RenamedAccumulator.fir 10:4 Features.scala 12:26 E:\ICT\chisel2lean4\experiments\differential-v0.2-full\RenamedAccumulator-width3-increment3\reference\rtl\RenamedAccumulator.fir 13:6 8:4]
    result <= storage @[Features.scala 13:10 E:\ICT\chisel2lean4\experiments\differential-v0.2-full\RenamedAccumulator-width3-increment3\reference\rtl\RenamedAccumulator.fir 14:4]
    storage <= mux(reset, UInt<3>("h0"), _GEN_0) @[E:\ICT\chisel2lean4\experiments\differential-v0.2-full\RenamedAccumulator-width3-increment3\reference\rtl\RenamedAccumulator.fir 8:{4,4}]
