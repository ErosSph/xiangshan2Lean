module HierarchyTop(input clk, reset, en,
  input signed [3:0] a, input signed [0:7] b, input signed [68:4] wide,
  output signed [3:0] p0,p1, output signed [7:0] p8,
  output signed [64:0] p65, output signed [3:0] nested,
  output signed [7:0] widened);
  HierarchyLeaf #(.W(4),.STEP(0)) u0(clk,reset,en,a,p0);
  HierarchyLeaf #(.W(4),.STEP(0)) u1(clk,reset,en,~a,p1);
  HierarchyLeaf #(8,1,-1) u8(clk,reset,en,b,p8);
  HierarchyLeaf #(65,2,-1) u65(clk,reset,en,wide,p65);
  HierarchyMiddle middle(clk,reset,en,a,nested);
  HierarchyLeaf #(4,0,0) narrow_to_wide(clk,reset,en,a,widened);
endmodule
