circuit RegisterIdioms :
  module RegisterIdioms :
    input clock : Clock
    input reset : UInt<1>
    input in : UInt<3>
    input en : UInt<1>
    output out : UInt<3>

    reg delayed : UInt, clock with :
      reset => (reset, UInt<3>("h0")) @[Mainstream.scala 20:24]
    delayed <= in @[Mainstream.scala 20:24]
    reg held : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[Reg.scala 35:20]
    when en : @[Reg.scala 36:18]
      held <= delayed @[Reg.scala 36:22]
    reg explicit : UInt<3>, clock with :
      reset => (reset, UInt<1>("h0")) @[Mainstream.scala 22:25]
    explicit <= held @[Mainstream.scala 23:12]
    out <= explicit @[Mainstream.scala 24:7]

