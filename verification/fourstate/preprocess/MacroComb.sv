`include "ops.svh"
module MacroComb(input s, a, b, output y);
`ifdef SELECT_XOR
  assign y = `XOR(a,b);
`elsif SELECT_A
  assign y = a;
`else
  assign y = `MUX(s,a,b);
`endif
`ifdef NEVER_ACTIVE
  initial unsupported_initial();
  `include "inactive-missing.svh"
`endif
endmodule
