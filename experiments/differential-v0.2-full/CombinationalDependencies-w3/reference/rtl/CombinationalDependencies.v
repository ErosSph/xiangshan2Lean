module CombinationalDependencies(
  input        clock,
  input        reset,
  input  [2:0] io_in,
  input        io_en,
  output [2:0] io_out
);
  assign io_out = io_en ? io_in : 3'h0; // @[Features.scala 74:{15,19} 71:5]
endmodule
