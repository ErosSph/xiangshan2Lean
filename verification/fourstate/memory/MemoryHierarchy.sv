module MemoryLeaf(input clock,en,a,input [2:0] d,output [2:0] q);
  reg [2:0] m[0:1];
  always @(posedge clock) if(en) m[a]<=d;
  assign q=m[a];
endmodule
module MemoryHierarchy(input clk,e0,e1,a,input [2:0] d0,d1,output [2:0] q0,q1);
  MemoryLeaf x(.clock(clk),.en(e0),.a(a),.d(d0),.q(q0));
  MemoryLeaf y(.clock(clk),.en(e1),.a(a),.d(d1),.q(q1));
endmodule
