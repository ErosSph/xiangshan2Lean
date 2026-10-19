module ResetLeaf(input clock, reset, d, output reg q);
  reg hidden;
  always @(posedge clock or posedge reset)
    if (reset) begin q <= 1'b0; hidden <= 1'b1; end
    else begin q <= hidden; hidden <= d; end
endmodule

module PortReset(input clk, rst, d, spare, output q);
  ResetLeaf leaf(.clock(clk), .reset(rst), .d(d), .q(q));
endmodule

module ResetMiddle(input c, r, d, output q);
  ResetLeaf leaf(.clock(c), .reset(r), .d(d), .q(q));
endmodule

module DeepReset(input clk, rst, d, spare, output q);
  ResetMiddle middle(.c(clk), .r(rst), .d(d), .q(q));
endmodule

module NetReset(input clk, rst, d, spare, output q);
  wire first = rst;
  wire second;
  assign second = first;
  ResetMiddle middle(.c(clk), .r(second), .d(d), .q(q));
endmodule

module SharedReset(input clk, rst, d, spare, output q, other);
  wire alias_reset = rst;
  ResetLeaf first(.clock(clk), .reset(alias_reset), .d(d), .q(q));
  ResetMiddle second(.c(clk), .r(rst), .d(spare), .q(other));
endmodule
