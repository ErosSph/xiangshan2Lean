module BitOperations(
  input        clock,
  input        reset,
  input  [2:0] in,
  output [2:0] out,
  output [4:0] left,
  output [2:0] right,
  output       bit_,
  output       any,
  output       all,
  output       parity
);
  assign out = in; // @[Features.scala 122:12]
  assign left = {in, 2'h0}; // @[Features.scala 123:14]
  assign right = {{1'd0}, in[2:1]}; // @[Features.scala 124:9]
  assign bit_ = in[0]; // @[Features.scala 125:12]
  assign any = |in; // @[Features.scala 126:13]
  assign all = &in; // @[Features.scala 127:13]
  assign parity = ^in; // @[Features.scala 128:16]
endmodule
