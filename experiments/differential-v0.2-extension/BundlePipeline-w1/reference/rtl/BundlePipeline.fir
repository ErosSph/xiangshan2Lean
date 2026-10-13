circuit BundlePipeline :
  module BundlePipeline :
    input clock : Clock
    input reset : UInt<1>
    input in : { data : UInt<1>, valid : UInt<1>}
    output out : { data : UInt<1>, valid : UInt<1>}

    reg r : { data : UInt<1>, valid : UInt<1>}, clock with :
      reset => (UInt<1>("h0"), r) @[Mainstream.scala 35:18]
    r.valid <= in.valid @[Mainstream.scala 35:18]
    r.data <= in.data @[Mainstream.scala 35:18]
    out <= r @[Mainstream.scala 36:7]

