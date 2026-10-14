FIRRTL version 6.0.0
circuit Chisel2LeanReference :
  layer Verification, bind, "verification" :
    layer Assert, bind, "verification\assert" :
      layer Temporal, inline :
    layer Assume, bind, "verification\assume" :
      layer Temporal, inline :
    layer Cover, bind, "verification\cover" :
      layer Temporal, inline :

  module ElasticStage : @[\\reference\\src\\main\\scala\\Handshake.scala 9:7]
    input clock : Clock @[\\reference\\src\\main\\scala\\Handshake.scala 9:7]
    input reset : Reset @[\\reference\\src\\main\\scala\\Handshake.scala 9:7]
    output io : { flip in : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<65>}, out : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<65>}} @[\\reference\\src\\main\\scala\\Handshake.scala 10:14]

    regreset valid : UInt<1>, clock, reset, UInt<1>(0h0) @[\\reference\\src\\main\\scala\\Handshake.scala 14:22]
    reg data : UInt<65>, clock @[\\reference\\src\\main\\scala\\Handshake.scala 15:17]
    node _io_in_ready_T = eq(valid, UInt<1>(0h0)) @[\\reference\\src\\main\\scala\\Handshake.scala 16:18]
    node _io_in_ready_T_1 = or(_io_in_ready_T, io.out.ready) @[\\reference\\src\\main\\scala\\Handshake.scala 16:25]
    connect io.in.ready, _io_in_ready_T_1 @[\\reference\\src\\main\\scala\\Handshake.scala 16:15]
    when io.in.ready : @[\\reference\\src\\main\\scala\\Handshake.scala 17:21]
      connect valid, io.in.valid @[\\reference\\src\\main\\scala\\Handshake.scala 18:11]
      when io.in.valid : @[\\reference\\src\\main\\scala\\Handshake.scala 19:23]
        connect data, io.in.bits @[\\reference\\src\\main\\scala\\Handshake.scala 19:30]
    connect io.out.valid, valid @[\\reference\\src\\main\\scala\\Handshake.scala 21:16]
    connect io.out.bits, data @[\\reference\\src\\main\\scala\\Handshake.scala 22:15]


  module ElasticStage_1 : @[\\reference\\src\\main\\scala\\Handshake.scala 9:7]
    input clock : Clock @[\\reference\\src\\main\\scala\\Handshake.scala 9:7]
    input reset : Reset @[\\reference\\src\\main\\scala\\Handshake.scala 9:7]
    output io : { flip in : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<65>}, out : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<65>}} @[\\reference\\src\\main\\scala\\Handshake.scala 10:14]

    regreset valid : UInt<1>, clock, reset, UInt<1>(0h0) @[\\reference\\src\\main\\scala\\Handshake.scala 14:22]
    reg data : UInt<65>, clock @[\\reference\\src\\main\\scala\\Handshake.scala 15:17]
    node _io_in_ready_T = eq(valid, UInt<1>(0h0)) @[\\reference\\src\\main\\scala\\Handshake.scala 16:18]
    node _io_in_ready_T_1 = or(_io_in_ready_T, io.out.ready) @[\\reference\\src\\main\\scala\\Handshake.scala 16:25]
    connect io.in.ready, _io_in_ready_T_1 @[\\reference\\src\\main\\scala\\Handshake.scala 16:15]
    when io.in.ready : @[\\reference\\src\\main\\scala\\Handshake.scala 17:21]
      connect valid, io.in.valid @[\\reference\\src\\main\\scala\\Handshake.scala 18:11]
      when io.in.valid : @[\\reference\\src\\main\\scala\\Handshake.scala 19:23]
        connect data, io.in.bits @[\\reference\\src\\main\\scala\\Handshake.scala 19:30]
    connect io.out.valid, valid @[\\reference\\src\\main\\scala\\Handshake.scala 21:16]
    connect io.out.bits, data @[\\reference\\src\\main\\scala\\Handshake.scala 22:15]


  module ElasticStage_2 : @[\\reference\\src\\main\\scala\\Handshake.scala 9:7]
    input clock : Clock @[\\reference\\src\\main\\scala\\Handshake.scala 9:7]
    input reset : Reset @[\\reference\\src\\main\\scala\\Handshake.scala 9:7]
    output io : { flip in : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<65>}, out : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<65>}} @[\\reference\\src\\main\\scala\\Handshake.scala 10:14]

    regreset valid : UInt<1>, clock, reset, UInt<1>(0h0) @[\\reference\\src\\main\\scala\\Handshake.scala 14:22]
    reg data : UInt<65>, clock @[\\reference\\src\\main\\scala\\Handshake.scala 15:17]
    node _io_in_ready_T = eq(valid, UInt<1>(0h0)) @[\\reference\\src\\main\\scala\\Handshake.scala 16:18]
    node _io_in_ready_T_1 = or(_io_in_ready_T, io.out.ready) @[\\reference\\src\\main\\scala\\Handshake.scala 16:25]
    connect io.in.ready, _io_in_ready_T_1 @[\\reference\\src\\main\\scala\\Handshake.scala 16:15]
    when io.in.ready : @[\\reference\\src\\main\\scala\\Handshake.scala 17:21]
      connect valid, io.in.valid @[\\reference\\src\\main\\scala\\Handshake.scala 18:11]
      when io.in.valid : @[\\reference\\src\\main\\scala\\Handshake.scala 19:23]
        connect data, io.in.bits @[\\reference\\src\\main\\scala\\Handshake.scala 19:30]
    connect io.out.valid, valid @[\\reference\\src\\main\\scala\\Handshake.scala 21:16]
    connect io.out.bits, data @[\\reference\\src\\main\\scala\\Handshake.scala 22:15]


  module HandshakeTop : @[\\reference\\src\\main\\scala\\Handshake.scala 25:7]
    input clock : Clock @[\\reference\\src\\main\\scala\\Handshake.scala 25:7]
    input reset : Reset @[\\reference\\src\\main\\scala\\Handshake.scala 25:7]
    output io : { flip in : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<65>}, out : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<65>}} @[\\reference\\src\\main\\scala\\Handshake.scala 27:14]

    inst chain_0 of ElasticStage @[\\reference\\src\\main\\scala\\Handshake.scala 32:76]
    connect chain_0.clock, clock
    connect chain_0.reset, reset
    inst chain_1 of ElasticStage_1 @[\\reference\\src\\main\\scala\\Handshake.scala 32:76]
    connect chain_1.clock, clock
    connect chain_1.reset, reset
    inst chain_2 of ElasticStage_2 @[\\reference\\src\\main\\scala\\Handshake.scala 32:76]
    connect chain_2.clock, clock
    connect chain_2.reset, reset
    connect chain_0.io.in, io.in @[\\reference\\src\\main\\scala\\Handshake.scala 33:20]
    connect chain_1.io.in, chain_0.io.out @[\\reference\\src\\main\\scala\\Handshake.scala 34:70]
    connect chain_2.io.in, chain_1.io.out @[\\reference\\src\\main\\scala\\Handshake.scala 34:70]
    connect io.out.bits, chain_2.io.out.bits @[\\reference\\src\\main\\scala\\Handshake.scala 35:10]
    connect io.out.valid, chain_2.io.out.valid @[\\reference\\src\\main\\scala\\Handshake.scala 35:10]
    connect chain_2.io.out.ready, io.out.ready @[\\reference\\src\\main\\scala\\Handshake.scala 35:10]


  public module Chisel2LeanReference : @[\\reference\\src\\main\\scala\\GenerateRTL.scala 35:11]
    input clock : Clock @[\\reference\\src\\main\\scala\\GenerateRTL.scala 35:11]
    input reset : UInt<1> @[\\reference\\src\\main\\scala\\GenerateRTL.scala 35:11]
    input c2l_port_0 : UInt<65> @[\\reference\\src\\main\\scala\\GenerateRTL.scala 49:50]
    output c2l_port_1 : UInt<1> @[\\reference\\src\\main\\scala\\GenerateRTL.scala 49:85]
    input c2l_port_2 : UInt<1> @[\\reference\\src\\main\\scala\\GenerateRTL.scala 49:50]
    output c2l_port_3 : UInt<65> @[\\reference\\src\\main\\scala\\GenerateRTL.scala 49:85]
    input c2l_port_4 : UInt<1> @[\\reference\\src\\main\\scala\\GenerateRTL.scala 49:50]
    output c2l_port_5 : UInt<1> @[\\reference\\src\\main\\scala\\GenerateRTL.scala 49:85]

    inst HandshakeTop of HandshakeTop @[\\reference\\src\\main\\scala\\GenerateRTL.scala 37:24]
    connect HandshakeTop.clock, clock
    connect HandshakeTop.reset, reset
    connect HandshakeTop.io.in.bits, c2l_port_0 @[\\reference\\src\\main\\scala\\GenerateRTL.scala 51:42]
    connect c2l_port_1, HandshakeTop.io.in.ready @[\\reference\\src\\main\\scala\\GenerateRTL.scala 51:60]
    connect HandshakeTop.io.in.valid, c2l_port_2 @[\\reference\\src\\main\\scala\\GenerateRTL.scala 51:42]
    connect c2l_port_3, HandshakeTop.io.out.bits @[\\reference\\src\\main\\scala\\GenerateRTL.scala 51:60]
    connect HandshakeTop.io.out.ready, c2l_port_4 @[\\reference\\src\\main\\scala\\GenerateRTL.scala 51:42]
    connect c2l_port_5, HandshakeTop.io.out.valid @[\\reference\\src\\main\\scala\\GenerateRTL.scala 51:60]

