FIRRTL version 1.1.0
circuit BundlePipeline : @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\BundlePipeline-w8\reference\rtl\BundlePipeline.fir 1:0]
  module BundlePipeline : @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\BundlePipeline-w8\reference\rtl\BundlePipeline.fir 2:2]
    input clock : Clock @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\BundlePipeline-w8\reference\rtl\BundlePipeline.fir 3:4]
    input reset : UInt<1> @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\BundlePipeline-w8\reference\rtl\BundlePipeline.fir 4:4]
    input in_data : UInt<8> @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\BundlePipeline-w8\reference\rtl\BundlePipeline.fir 5:4]
    input in_valid : UInt<1> @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\BundlePipeline-w8\reference\rtl\BundlePipeline.fir 5:4]
    output out_data : UInt<8> @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\BundlePipeline-w8\reference\rtl\BundlePipeline.fir 6:4]
    output out_valid : UInt<1> @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\BundlePipeline-w8\reference\rtl\BundlePipeline.fir 6:4]

    reg r_data : UInt<8>, clock with :
      reset => (UInt<1>("h0"), r_data) @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\BundlePipeline-w8\reference\rtl\BundlePipeline.fir 8:4]
    reg r_valid : UInt<1>, clock with :
      reset => (UInt<1>("h0"), r_valid) @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\BundlePipeline-w8\reference\rtl\BundlePipeline.fir 8:4]
    out_data <= r_data @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\BundlePipeline-w8\reference\rtl\BundlePipeline.fir 12:4 Mainstream.scala 36:7]
    out_valid <= r_valid @[E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\BundlePipeline-w8\reference\rtl\BundlePipeline.fir 12:4 Mainstream.scala 36:7]
    r_data <= in_data @[Mainstream.scala 35:18 E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\BundlePipeline-w8\reference\rtl\BundlePipeline.fir 11:4]
    r_valid <= in_valid @[Mainstream.scala 35:18 E:\ICT\chisel2lean4\experiments\differential-v0.2-extension\BundlePipeline-w8\reference\rtl\BundlePipeline.fir 10:4]
