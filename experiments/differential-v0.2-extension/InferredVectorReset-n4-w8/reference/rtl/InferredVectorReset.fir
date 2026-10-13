circuit InferredVectorReset :
  module InferredVectorReset :
    input clock : Clock
    input reset : UInt<1>
    input in : UInt<8>[4]
    output out : UInt<1>[4]

    wire _r_WIRE : UInt<1>[4] @[Mainstream.scala 126:26]
    _r_WIRE[0] <= UInt<1>("h0") @[Mainstream.scala 126:26]
    _r_WIRE[1] <= UInt<1>("h0") @[Mainstream.scala 126:26]
    _r_WIRE[2] <= UInt<1>("h0") @[Mainstream.scala 126:26]
    _r_WIRE[3] <= UInt<1>("h0") @[Mainstream.scala 126:26]
    reg r : UInt<1>[4], clock with :
      reset => (reset, _r_WIRE) @[Mainstream.scala 126:18]
    r[0] <= in[0] @[Mainstream.scala 127:31]
    r[1] <= in[1] @[Mainstream.scala 127:31]
    r[2] <= in[2] @[Mainstream.scala 127:31]
    r[3] <= in[3] @[Mainstream.scala 127:31]
    out <= r @[Mainstream.scala 128:7]

