FIRRTL version 1.1.0
circuit PrimitiveWidths :
  module PrimitiveWidths :
    input u : UInt<3>
    input s : SInt<3>
    input t : SInt<5>
    input amount : UInt<4>
    output addCarry : UInt<4>
    output subBorrow : UInt<4>
    output negUnsigned : SInt<4>
    output negSigned : SInt<4>
    output cvtUnsigned : SInt<4>
    output signedAnd : UInt<5>
    output signedNot : UInt<3>
    output arithmeticShift : SInt<3>
    output logicalOvershift : UInt<1>
    addCarry <= add(u, UInt<1>(1))
    subBorrow <= sub(u, UInt<1>(1))
    negUnsigned <= neg(u)
    negSigned <= neg(s)
    cvtUnsigned <= cvt(u)
    signedAnd <= and(s, t)
    signedNot <= not(s)
    arithmeticShift <= dshr(s, amount)
    logicalOvershift <= shr(u, 9)
