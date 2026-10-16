module ParameterLookup(
  input  [1:0] sel,
  input  [1:0] a,
  input  [1:0] b,
  output [1:0] out
);
  wire [1:0] _out_T_1 = a + b; // @[Designs.scala 49:64]
  wire [1:0] _out_T_3 = 2'h0 == sel ? a : 2'h0; // @[Mux.scala 81:58]
  wire [1:0] _out_T_5 = 2'h1 == sel ? b : _out_T_3; // @[Mux.scala 81:58]
  assign out = 2'h2 == sel ? _out_T_1 : _out_T_5; // @[Mux.scala 81:58]
endmodule
