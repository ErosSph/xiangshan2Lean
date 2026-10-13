circuit Assertion :
  module Assertion :
    input clock : Clock
    input en : UInt<1>
    output q : UInt<1>
    q <= en
    assert(clock, en, UInt<1>(1), "contract")
