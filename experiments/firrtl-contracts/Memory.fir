circuit Memory :
  module Memory :
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
    m.r.clk <= clock
    m.r.en <= UInt<1>(1)
    m.r.addr <= addr
    m.w.clk <= clock
    m.w.en <= UInt<1>(0)
    m.w.addr <= addr
    m.w.data <= UInt<8>(0)
    m.w.mask <= UInt<1>(1)
    q <= m.r.data
