FIRRTL version 6.0.0
circuit Memory :
  public module Memory :
    input clock : Clock
    input addr : UInt<2>
    output q : UInt<8>
    mem m :
      data-type => UInt<8>
      depth => 4
      read-latency => 0
      write-latency => 1
      reader => r
      writer => w
      read-under-write => undefined
    connect m.r.clk, clock
    connect m.r.en, UInt<1>(1)
    connect m.r.addr, addr
    connect m.w.clk, clock
    connect m.w.en, UInt<1>(0)
    connect m.w.addr, addr
    connect m.w.data, UInt<8>(0)
    connect m.w.mask, UInt<1>(1)
    connect q, m.r.data
