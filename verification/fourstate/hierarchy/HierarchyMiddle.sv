module HierarchyMiddle(input clk, reset, en, input signed [3:0] d,
  output signed [3:0] y);
  wire clock_alias;
  wire signed [3:0] link;
  assign clock_alias=clk;
  HierarchyLeaf #(4,0,0) u0(clock_alias,reset,en,d,link);
  HierarchyLeaf #(.W(4),.STYLE(1),.STEP(0)) u1(.clock(clock_alias),
    .reset(reset),.en(en),.d(link),.y(y));
endmodule
