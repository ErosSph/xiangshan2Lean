module Latch1(input clk, d, output reg q);
  always_latch if (!clk) q = d;
endmodule

module GatedRegister(input clk, en, te, d, output gclk, output reg q);
  ClockGate gate(.TE(te), .E(en), .CK(clk), .Q(gclk));
  always @(posedge gclk) q <= d;
endmodule

module DualClock(input ca, cb, d, output reg qa, qb);
  always @(posedge ca) qa <= d;
  always @(posedge cb) qb <= qa;
endmodule

module InvertedClock(input clk, d, output nclk, output reg q);
  assign nclk = ~clk;
  always @(posedge nclk) q <= d;
endmodule

module DualReset(input ca, cb, reset, d, output reg qa, qb);
  always @(posedge ca or posedge reset)
    if (reset) qa <= 1'b0; else qa <= d;
  always @(posedge cb) qb <= qa;
endmodule

module NegativeClock(input clk, reset, d, output reg q);
  always @(negedge clk or posedge reset)
    if (reset) q <= 1'b0; else q <= d;
endmodule
