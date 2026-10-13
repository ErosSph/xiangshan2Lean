circuit ConditionalPriority :
  module ConditionalPriority :
    input clock : Clock
    input reset : UInt<1>
    input a : UInt<1>
    input b : UInt<1>
    input c : UInt<1>
    output combinational : UInt<7>
    output sequential : UInt<7>

    reg r : UInt<7>, clock with :
      reset => (reset, UInt<7>("h0")) @[Control.scala 11:18]
    wire value : UInt<7> @[Control.scala 12:19]
    when a : @[Control.scala 13:11]
      value <= UInt<1>("h1") @[Control.scala 13:19]
    else :
      when b : @[Control.scala 14:18]
        value <= UInt<2>("h2") @[Control.scala 14:26]
      else :
        value <= UInt<2>("h3") @[Control.scala 15:24]
    when a : @[Control.scala 16:11]
      when b : @[Control.scala 17:13]
        r <= UInt<1>("h1") @[Control.scala 17:17]
      else :
        r <= UInt<2>("h2") @[Control.scala 17:40]
    else :
      when c : @[Control.scala 18:17]
        r <= UInt<2>("h3") @[Control.scala 18:21]
      else :
        node _r_T = add(r, UInt<1>("h1")) @[Control.scala 19:25]
        node _r_T_1 = tail(_r_T, 1) @[Control.scala 19:25]
        r <= _r_T_1 @[Control.scala 19:20]
    combinational <= value @[Control.scala 20:17]
    sequential <= r @[Control.scala 21:14]

