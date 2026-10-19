module MacroGuard(input clock, input d, output reg q);
`ifdef ENABLE_INITIAL_REG_
  initial q = 1'b0;
`endif
  always @(posedge clock) q <= d;
endmodule
