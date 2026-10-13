module CombinationalDependencies(
  input        clock,
  input        reset,
  input  [8:0] io_in,
  input        io_en,
  output [8:0] io_out
);
  assign io_out = io_en ? io_in : 9'h0; // @[Features.scala 74:{15,19} 71:5]
endmodule
