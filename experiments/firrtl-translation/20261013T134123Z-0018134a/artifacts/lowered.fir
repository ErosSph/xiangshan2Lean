FIRRTL version 1.1.0
circuit ExtendedBits :
  module ExtendedBits :
    input clock : Clock
    input reset : UInt<1>
    input in : UInt<128>
    input flag : UInt<1>
    input amount : UInt<2>
    output inverted : UInt<128>
    output negative : UInt<129>
    output concatenated : UInt<130>
    output isZero : UInt<1>
    output shifted : UInt<128>
    output dynamic : UInt<128>
    output padded : UInt<131>

    node _inverted_T = not(in) @[Advanced.scala 33:15]
    node _negative_T = sub(UInt<1>("h0"), in) @[Advanced.scala 34:15]
    node _negative_T_1 = tail(_negative_T, 1) @[Advanced.scala 34:15]
    node _concatenated_T = sub(UInt<1>("h0"), in) @[Advanced.scala 35:29]
    node _concatenated_T_1 = tail(_concatenated_T, 1) @[Advanced.scala 35:29]
    node _concatenated_T_2 = cat(flag, _concatenated_T_1) @[Cat.scala 33:92]
    node _isZero_T = eq(in, UInt<1>("h0")) @[Advanced.scala 36:13]
    node _shifted_T = shr(in, 3) @[Advanced.scala 37:17]
    node _dynamic_T = dshr(in, amount) @[Advanced.scala 38:17]
    node _padded_T = pad(in, 131) @[Advanced.scala 39:19]
    inverted <= _inverted_T @[Advanced.scala 33:12]
    negative <= pad(_negative_T_1, 129) @[Advanced.scala 34:12]
    concatenated <= pad(_concatenated_T_2, 130) @[Advanced.scala 35:16]
    isZero <= _isZero_T @[Advanced.scala 36:10]
    shifted <= pad(_shifted_T, 128) @[Advanced.scala 37:11]
    dynamic <= _dynamic_T @[Advanced.scala 38:11]
    padded <= _padded_T @[Advanced.scala 39:10]
