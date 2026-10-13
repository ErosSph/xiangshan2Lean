circuit MixedReset :
  module MixedReset :
    input clock : Clock
    input reset : UInt<1>
    input in : UInt<3>
    output initialized : UInt<3>
    output uninitialized : UInt<3>

    reg a : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[Advanced.scala 71:18]
    reg b : UInt<3>, clock with :
      reset => (UInt<1>("h0"), b) @[Advanced.scala 72:14]
    a <= b @[Advanced.scala 73:5]
    b <= in @[Advanced.scala 74:5]
    initialized <= a @[Advanced.scala 75:15]
    uninitialized <= b @[Advanced.scala 76:17]

