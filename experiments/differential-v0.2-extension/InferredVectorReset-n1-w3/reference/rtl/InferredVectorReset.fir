circuit InferredVectorReset :
  module InferredVectorReset :
    input clock : Clock
    input reset : UInt<1>
    input in : UInt<3>[1]
    output out : UInt<1>[1]

    wire _r_WIRE : UInt<1>[1] @[Mainstream.scala 126:26]
    _r_WIRE[0] <= UInt<1>("h0") @[Mainstream.scala 126:26]
    reg r : UInt<1>[1], clock with :
      reset => (reset, _r_WIRE) @[Mainstream.scala 126:18]
    r[0] <= in[0] @[Mainstream.scala 127:31]
    out <= r @[Mainstream.scala 128:7]

