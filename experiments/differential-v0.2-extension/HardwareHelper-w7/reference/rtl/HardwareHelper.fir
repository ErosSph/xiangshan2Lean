circuit HardwareHelper :
  module HardwareHelper :
    input in : UInt<7>
    output out : UInt<7>

    node _out_sum_T = add(in, UInt<7>("h1")) @[Mainstream.scala 90:51]
    node out_sum = tail(_out_sum_T, 1) @[Mainstream.scala 90:51]
    node _out_T = xor(out_sum, UInt<7>("h1")) @[Mainstream.scala 90:60]
    out <= _out_T @[Mainstream.scala 91:7]

