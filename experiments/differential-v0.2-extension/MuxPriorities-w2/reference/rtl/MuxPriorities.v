module MuxPriorities(
  input  [1:0] a,
  input  [1:0] b,
  input  [1:0] c,
  input  [1:0] sel,
  input        x,
  input        y,
  output [1:0] lookup,
  output [1:0] muxcase,
  output [1:0] priority_,
  output [2:0] widthCheck
);
  wire [1:0] _lookup_T_1 = 2'h0 == sel ? a : 2'h0; // @[Mux.scala 81:58]
  wire [1:0] _lookup_T_3 = 2'h0 == sel ? b : _lookup_T_1; // @[Mux.scala 81:58]
  wire [1:0] _muxcase_T = y ? b : c; // @[Mux.scala 101:16]
  wire [1:0] _exhaustive_T_1 = 2'h1 == sel ? b : a; // @[Mux.scala 81:58]
  wire [1:0] _exhaustive_T_3 = 2'h2 == sel ? c : _exhaustive_T_1; // @[Mux.scala 81:58]
  wire [1:0] exhaustive = 2'h3 == sel ? a : _exhaustive_T_3; // @[Mux.scala 81:58]
  assign lookup = 2'h1 == sel ? c : _lookup_T_3; // @[Mux.scala 81:58]
  assign muxcase = x ? a : _muxcase_T; // @[Mux.scala 101:16]
  assign priority_ = x ? a : _muxcase_T; // @[Mux.scala 47:70]
  assign widthCheck = exhaustive + 2'h1; // @[Muxes.scala 21:28]
endmodule
