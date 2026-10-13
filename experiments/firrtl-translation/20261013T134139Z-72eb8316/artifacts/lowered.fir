FIRRTL version 1.1.0
circuit Fifo :
  module Fifo :
    input clock : Clock
    input reset : UInt<1>
    input enq : UInt<1>
    input deq : UInt<1>
    input data : UInt<3>
    output out : UInt<3>
    output full : UInt<1>
    output empty : UInt<1>

    reg storage_0 : UInt<3>, clock with :
      reset => (UInt<1>("h0"), storage_0) @[Designs.scala 25:24]
    reg storage_1 : UInt<3>, clock with :
      reset => (UInt<1>("h0"), storage_1) @[Designs.scala 25:24]
    reg read : UInt<1>, clock with :
      reset => (UInt<1>("h0"), read) @[Designs.scala 26:21]
    reg write : UInt<1>, clock with :
      reset => (UInt<1>("h0"), write) @[Designs.scala 27:22]
    reg count : UInt<2>, clock with :
      reset => (UInt<1>("h0"), count) @[Designs.scala 28:22]
    node _push_T = lt(count, UInt<2>("h2")) @[Designs.scala 29:27]
    node push = and(enq, _push_T) @[Designs.scala 29:18]
    node _pop_T = neq(count, UInt<1>("h0")) @[Designs.scala 30:26]
    node pop = and(deq, _pop_T) @[Designs.scala 30:17]
    node _storage_write = data @[Designs.scala 32:{20,20}]
    node _GEN_0 = mux(eq(UInt<1>("h0"), write), _storage_write, storage_0) @[Designs.scala 32:{20,20} 25:24]
    node _GEN_1 = mux(eq(UInt<1>("h1"), write), _storage_write, storage_1) @[Designs.scala 32:{20,20} 25:24]
    node _write_T = eq(write, UInt<1>("h1")) @[Designs.scala 33:24]
    node _write_T_1 = add(write, UInt<1>("h1")) @[Designs.scala 33:54]
    node _write_T_2 = tail(_write_T_1, 1) @[Designs.scala 33:54]
    node _write_T_3 = mux(_write_T, UInt<1>("h0"), _write_T_2) @[Designs.scala 33:17]
    node _GEN_2 = mux(push, _GEN_0, storage_0) @[Designs.scala 31:14 25:24]
    node _GEN_3 = mux(push, _GEN_1, storage_1) @[Designs.scala 31:14 25:24]
    node _GEN_4 = mux(push, _write_T_3, write) @[Designs.scala 31:14 33:11 27:22]
    node _read_T = eq(read, UInt<1>("h1")) @[Designs.scala 35:32]
    node _read_T_1 = add(read, UInt<1>("h1")) @[Designs.scala 35:61]
    node _read_T_2 = tail(_read_T_1, 1) @[Designs.scala 35:61]
    node _read_T_3 = mux(_read_T, UInt<1>("h0"), _read_T_2) @[Designs.scala 35:26]
    node _GEN_5 = mux(pop, _read_T_3, read) @[Designs.scala 35:{13,20} 26:21]
    node _T = eq(pop, UInt<1>("h0")) @[Designs.scala 36:16]
    node _T_1 = and(push, _T) @[Designs.scala 36:13]
    node _count_T = add(count, UInt<1>("h1")) @[Designs.scala 36:39]
    node _count_T_1 = tail(_count_T, 1) @[Designs.scala 36:39]
    node _GEN_6 = mux(_T_1, _count_T_1, count) @[Designs.scala 28:22 36:{22,30}]
    node _T_2 = eq(push, UInt<1>("h0")) @[Designs.scala 37:15]
    node _T_3 = and(pop, _T_2) @[Designs.scala 37:12]
    node _count_T_2 = sub(count, UInt<1>("h1")) @[Designs.scala 37:39]
    node _count_T_3 = tail(_count_T_2, 1) @[Designs.scala 37:39]
    node _GEN_7 = mux(_T_3, _count_T_3, _GEN_6) @[Designs.scala 37:{22,30}]
    node _GEN_8 = validif(eq(UInt<1>("h0"), read), storage_0) @[Designs.scala 38:{7,7}]
    node _GEN_9 = mux(eq(UInt<1>("h1"), read), storage_1, _GEN_8) @[Designs.scala 38:{7,7}]
    node _full_T = eq(count, UInt<2>("h2")) @[Designs.scala 39:17]
    node _empty_T = eq(count, UInt<1>("h0")) @[Designs.scala 40:18]
    node _storage_WIRE_0 = UInt<3>("h0") @[Designs.scala 25:{32,32}]
    node _storage_WIRE_1 = UInt<3>("h0") @[Designs.scala 25:{32,32}]
    node _storage_read = _GEN_9 @[Designs.scala 38:7]
    out <= _storage_read @[Designs.scala 38:7]
    full <= _full_T @[Designs.scala 39:8]
    empty <= _empty_T @[Designs.scala 40:9]
    storage_0 <= mux(reset, _storage_WIRE_0, _GEN_2) @[Designs.scala 25:{24,24}]
    storage_1 <= mux(reset, _storage_WIRE_1, _GEN_3) @[Designs.scala 25:{24,24}]
    read <= mux(reset, UInt<1>("h0"), _GEN_5) @[Designs.scala 26:{21,21}]
    write <= mux(reset, UInt<1>("h0"), _GEN_4) @[Designs.scala 27:{22,22}]
    count <= mux(reset, UInt<2>("h0"), _GEN_7) @[Designs.scala 28:{22,22}]
