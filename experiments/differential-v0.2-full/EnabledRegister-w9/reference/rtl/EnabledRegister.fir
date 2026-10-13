circuit EnabledRegister :
  module EnabledRegister :
    input clock : Clock
    input reset : UInt<1>
    input in : UInt<9>
    input en : UInt<1>
    output out : UInt<9>

    reg r : UInt<9>, clock with :
      reset => (UInt<1>("h0"), r) @[Reg.scala 19:16]
    when en : @[Reg.scala 20:18]
      r <= in @[Reg.scala 20:22]
    out <= r @[Features.scala 97:7]

