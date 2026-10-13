module NamedBundle(
  input        clock,
  input        reset,
  input  [2:0] io_in,
  output [2:0] io_out
);
  assign io_out = io_in + 3'h1; // @[Advanced.scala 86:19]
endmodule
