module SwapCell(input clock,d,output logic q);
  always_ff @(posedge clock) q<=d;
endmodule
module HierarchySwap(input clk,output q0,q1);
  wire clock_alias;
  assign clock_alias=clk;
  SwapCell u0(clock_alias,q1,q0);
  SwapCell u1(clock_alias,q0,q1);
endmodule
