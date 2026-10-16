module ReservedPorts(
  input   clock,
  input   reset,
  output  bit_,
  output  class_
);
  assign bit_ = clock & reset; // @[Advanced.scala 47:16]
  assign class_ = clock | reset; // @[Advanced.scala 48:20]
endmodule
