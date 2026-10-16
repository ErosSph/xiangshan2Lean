module CombCell #(parameter integer W=4)(input signed [W-1:0] d,
  output signed [W-1:0] y);
  assign y=d;
endmodule
module DataParameter #(parameter [3:0] MASK=4'b10xz)(input choose,output [3:0] y);
  assign y=choose ? MASK : 4'bz001;
endmodule
module HierarchyComb(input signed [3:0] a,input [0:7] b,input choose,
  output signed [7:0] widened,output [3:0] narrow,output signed [64:0] wide,
  output [3:0] param_value);
  CombCell #(4) c4(~a,widened);
  CombCell #(8) c8(b,narrow);
  CombCell #(65) c65(a,wide);
  DataParameter p(choose,param_value);
endmodule
