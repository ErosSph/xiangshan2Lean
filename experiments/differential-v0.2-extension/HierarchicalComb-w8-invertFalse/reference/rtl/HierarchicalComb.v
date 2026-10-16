module CombLane(
  input  [7:0] io_in,
  output [7:0] io_out
);
  assign io_out = io_in; // @[Hierarchy.scala 51:10]
endmodule
module HierarchicalComb(
  input  [7:0] a,
  output [7:0] out
);
  wire [7:0] child_io_in; // @[Hierarchy.scala 43:21]
  wire [7:0] child_io_out; // @[Hierarchy.scala 43:21]
  CombLane child ( // @[Hierarchy.scala 43:21]
    .io_in(child_io_in),
    .io_out(child_io_out)
  );
  assign out = child_io_out + 8'h1; // @[Hierarchy.scala 45:23]
  assign child_io_in = a; // @[Hierarchy.scala 44:15]
endmodule
