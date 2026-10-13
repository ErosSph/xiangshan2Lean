FIRRTL version 1.1.0
circuit BundlePipeline :
  module BundlePipeline :
    input clock : Clock
    input reset : UInt<1>
    input in_data : UInt<8>
    input in_valid : UInt<1>
    output out_data : UInt<8>
    output out_valid : UInt<1>

    reg r_data : UInt<8>, clock with :
      reset => (UInt<1>("h0"), r_data) @[Mainstream.scala 35:18]
    reg r_valid : UInt<1>, clock with :
      reset => (UInt<1>("h0"), r_valid) @[Mainstream.scala 35:18]
    out_data <= r_data @[Mainstream.scala 36:7]
    out_valid <= r_valid @[Mainstream.scala 36:7]
    r_data <= in_data @[Mainstream.scala 35:18]
    r_valid <= in_valid @[Mainstream.scala 35:18]
