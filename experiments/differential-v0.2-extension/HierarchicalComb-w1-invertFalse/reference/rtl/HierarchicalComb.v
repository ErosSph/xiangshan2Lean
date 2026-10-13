module CombLane(
  input   io_in,
  output  io_out
);
  assign io_out = io_in; // @[Hierarchy.scala 51:10]
endmodule
module HierarchicalComb(
  input   a,
  output  out
);
  wire  child_io_in; // @[Hierarchy.scala 43:21]
  wire  child_io_out; // @[Hierarchy.scala 43:21]
  CombLane child ( // @[Hierarchy.scala 43:21]
    .io_in(child_io_in),
    .io_out(child_io_out)
  );
  assign out = child_io_out + 1'h1; // @[Hierarchy.scala 45:23]
  assign child_io_in = a; // @[Hierarchy.scala 44:15]
endmodule
