module Unrelated(input clk, d, output logic q);
  initial q=0;
  always @(negedge clk) q=d;
endmodule
