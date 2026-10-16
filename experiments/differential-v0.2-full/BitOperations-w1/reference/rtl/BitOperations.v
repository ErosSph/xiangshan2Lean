module BitOperations(
  input        clock,
  input        reset,
  input        in,
  output       out,
  output [2:0] left,
  output       right,
  output       bit_,
  output       any,
  output       all,
  output       parity
);
  assign out = in; // @[Features.scala 122:12]
  assign left = {in, 2'h0}; // @[Features.scala 123:14]
  assign right = 1'h0; // @[Features.scala 124:15]
  assign bit_ = in; // @[Features.scala 125:12]
  assign any = |in; // @[Features.scala 126:13]
  assign all = &in; // @[Features.scala 127:13]
  assign parity = ^in; // @[Features.scala 128:16]
endmodule
