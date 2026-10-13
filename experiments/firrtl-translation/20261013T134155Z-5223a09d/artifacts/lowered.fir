FIRRTL version 1.1.0
circuit RegisterFile :
  module RegisterFile :
    input clock : Clock
    input reset : UInt<1>
    input write : UInt<1>
    input waddr : UInt<3>
    input raddr : UInt<3>
    input data : UInt<7>
    output out : UInt<7>

    reg registers_0 : UInt<7>, clock with :
      reset => (UInt<1>("h0"), registers_0) @[Designs.scala 12:26]
    reg registers_1 : UInt<7>, clock with :
      reset => (UInt<1>("h0"), registers_1) @[Designs.scala 12:26]
    reg registers_2 : UInt<7>, clock with :
      reset => (UInt<1>("h0"), registers_2) @[Designs.scala 12:26]
    reg registers_3 : UInt<7>, clock with :
      reset => (UInt<1>("h0"), registers_3) @[Designs.scala 12:26]
    reg registers_4 : UInt<7>, clock with :
      reset => (UInt<1>("h0"), registers_4) @[Designs.scala 12:26]
    reg registers_5 : UInt<7>, clock with :
      reset => (UInt<1>("h0"), registers_5) @[Designs.scala 12:26]
    reg registers_6 : UInt<7>, clock with :
      reset => (UInt<1>("h0"), registers_6) @[Designs.scala 12:26]
    reg registers_7 : UInt<7>, clock with :
      reset => (UInt<1>("h0"), registers_7) @[Designs.scala 12:26]
    node _registers_waddr = data @[Designs.scala 13:{34,34}]
    node _GEN_0 = mux(eq(UInt<1>("h0"), waddr), _registers_waddr, registers_0) @[Designs.scala 12:26 13:{34,34}]
    node _GEN_1 = mux(eq(UInt<1>("h1"), waddr), _registers_waddr, registers_1) @[Designs.scala 12:26 13:{34,34}]
    node _GEN_2 = mux(eq(UInt<2>("h2"), waddr), _registers_waddr, registers_2) @[Designs.scala 12:26 13:{34,34}]
    node _GEN_3 = mux(eq(UInt<2>("h3"), waddr), _registers_waddr, registers_3) @[Designs.scala 12:26 13:{34,34}]
    node _GEN_4 = mux(eq(UInt<3>("h4"), waddr), _registers_waddr, registers_4) @[Designs.scala 12:26 13:{34,34}]
    node _GEN_5 = mux(eq(UInt<3>("h5"), waddr), _registers_waddr, registers_5) @[Designs.scala 12:26 13:{34,34}]
    node _GEN_6 = mux(eq(UInt<3>("h6"), waddr), _registers_waddr, registers_6) @[Designs.scala 12:26 13:{34,34}]
    node _GEN_7 = mux(eq(UInt<3>("h7"), waddr), _registers_waddr, registers_7) @[Designs.scala 12:26 13:{34,34}]
    node _GEN_8 = mux(write, _GEN_0, registers_0) @[Designs.scala 13:15 12:26]
    node _GEN_9 = mux(write, _GEN_1, registers_1) @[Designs.scala 13:15 12:26]
    node _GEN_10 = mux(write, _GEN_2, registers_2) @[Designs.scala 13:15 12:26]
    node _GEN_11 = mux(write, _GEN_3, registers_3) @[Designs.scala 13:15 12:26]
    node _GEN_12 = mux(write, _GEN_4, registers_4) @[Designs.scala 13:15 12:26]
    node _GEN_13 = mux(write, _GEN_5, registers_5) @[Designs.scala 13:15 12:26]
    node _GEN_14 = mux(write, _GEN_6, registers_6) @[Designs.scala 13:15 12:26]
    node _GEN_15 = mux(write, _GEN_7, registers_7) @[Designs.scala 13:15 12:26]
    node _GEN_16 = validif(eq(UInt<1>("h0"), raddr), registers_0) @[Designs.scala 14:{7,7}]
    node _GEN_17 = mux(eq(UInt<1>("h1"), raddr), registers_1, _GEN_16) @[Designs.scala 14:{7,7}]
    node _GEN_18 = mux(eq(UInt<2>("h2"), raddr), registers_2, _GEN_17) @[Designs.scala 14:{7,7}]
    node _GEN_19 = mux(eq(UInt<2>("h3"), raddr), registers_3, _GEN_18) @[Designs.scala 14:{7,7}]
    node _GEN_20 = mux(eq(UInt<3>("h4"), raddr), registers_4, _GEN_19) @[Designs.scala 14:{7,7}]
    node _GEN_21 = mux(eq(UInt<3>("h5"), raddr), registers_5, _GEN_20) @[Designs.scala 14:{7,7}]
    node _GEN_22 = mux(eq(UInt<3>("h6"), raddr), registers_6, _GEN_21) @[Designs.scala 14:{7,7}]
    node _GEN_23 = mux(eq(UInt<3>("h7"), raddr), registers_7, _GEN_22) @[Designs.scala 14:{7,7}]
    node _registers_WIRE_0 = UInt<7>("h0") @[Designs.scala 12:{34,34}]
    node _registers_WIRE_1 = UInt<7>("h0") @[Designs.scala 12:{34,34}]
    node _registers_WIRE_2 = UInt<7>("h0") @[Designs.scala 12:{34,34}]
    node _registers_WIRE_3 = UInt<7>("h0") @[Designs.scala 12:{34,34}]
    node _registers_WIRE_4 = UInt<7>("h0") @[Designs.scala 12:{34,34}]
    node _registers_WIRE_5 = UInt<7>("h0") @[Designs.scala 12:{34,34}]
    node _registers_WIRE_6 = UInt<7>("h0") @[Designs.scala 12:{34,34}]
    node _registers_WIRE_7 = UInt<7>("h0") @[Designs.scala 12:{34,34}]
    node _registers_raddr = _GEN_23 @[Designs.scala 14:7]
    out <= _registers_raddr @[Designs.scala 14:7]
    registers_0 <= mux(reset, _registers_WIRE_0, _GEN_8) @[Designs.scala 12:{26,26}]
    registers_1 <= mux(reset, _registers_WIRE_1, _GEN_9) @[Designs.scala 12:{26,26}]
    registers_2 <= mux(reset, _registers_WIRE_2, _GEN_10) @[Designs.scala 12:{26,26}]
    registers_3 <= mux(reset, _registers_WIRE_3, _GEN_11) @[Designs.scala 12:{26,26}]
    registers_4 <= mux(reset, _registers_WIRE_4, _GEN_12) @[Designs.scala 12:{26,26}]
    registers_5 <= mux(reset, _registers_WIRE_5, _GEN_13) @[Designs.scala 12:{26,26}]
    registers_6 <= mux(reset, _registers_WIRE_6, _GEN_14) @[Designs.scala 12:{26,26}]
    registers_7 <= mux(reset, _registers_WIRE_7, _GEN_15) @[Designs.scala 12:{26,26}]
