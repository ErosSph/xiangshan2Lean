module BoolGate(
  input   in,
  output  out
);
  assign out = ~in; // @[Features.scala 80:23]
endmodule
