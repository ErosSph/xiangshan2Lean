circuit BitOperations :
  module BitOperations :
    input clock : Clock
    input reset : UInt<1>
    input in : UInt<8>
    output out : UInt<8>
    output left : UInt<10>
    output right : UInt<8>
    output bit : UInt<1>
    output any : UInt<1>
    output all : UInt<1>
    output parity : UInt<1>

    node _out_T = bits(in, 7, 0) @[Features.scala 122:12]
    out <= _out_T @[Features.scala 122:7]
    node _left_T = shl(in, 2) @[Features.scala 123:14]
    left <= _left_T @[Features.scala 123:8]
    node _right_T = shr(in, 1) @[Features.scala 124:15]
    right <= _right_T @[Features.scala 124:9]
    node _bit_T = bits(in, 0, 0) @[Features.scala 125:12]
    bit <= _bit_T @[Features.scala 125:7]
    node _any_T = orr(in) @[Features.scala 126:13]
    any <= _any_T @[Features.scala 126:7]
    node _all_T = andr(in) @[Features.scala 127:13]
    all <= _all_T @[Features.scala 127:7]
    node _parity_T = xorr(in) @[Features.scala 128:16]
    parity <= _parity_T @[Features.scala 128:10]

