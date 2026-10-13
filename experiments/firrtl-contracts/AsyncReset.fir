circuit AsyncReset :
  module AsyncReset :
    input clock : Clock
    input reset : AsyncReset
    output q : UInt<8>
    reg r : UInt<8>, clock with :
      reset => (reset, UInt<8>(0))
    r <= UInt<8>(1)
    q <= r
