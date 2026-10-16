module PipelineLane(
  input        clock,
  input        reset,
  input  [3:0] in,
  input        en,
  output [3:0] out
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [3:0] r; // @[Hierarchy.scala 25:18]
  wire [3:0] _r_T_1 = in + 4'h1; // @[Hierarchy.scala 26:22]
  assign out = r; // @[Hierarchy.scala 27:7]
  always @(posedge clock) begin
    if (reset) begin // @[Hierarchy.scala 25:18]
      r <= 4'h0; // @[Hierarchy.scala 25:18]
    end else if (en) begin // @[Hierarchy.scala 26:12]
      r <= _r_T_1; // @[Hierarchy.scala 26:16]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  r = _RAND_0[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module PipelineLane_1(
  input        clock,
  input        reset,
  input  [3:0] in,
  input        en,
  output [3:0] out
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [3:0] r; // @[Hierarchy.scala 25:18]
  wire [3:0] _r_T_1 = in + 4'h2; // @[Hierarchy.scala 26:22]
  assign out = r; // @[Hierarchy.scala 27:7]
  always @(posedge clock) begin
    if (reset) begin // @[Hierarchy.scala 25:18]
      r <= 4'h0; // @[Hierarchy.scala 25:18]
    end else if (en) begin // @[Hierarchy.scala 26:12]
      r <= _r_T_1; // @[Hierarchy.scala 26:16]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  r = _RAND_0[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module HierarchicalPipeline(
  input        clock,
  input        reset,
  input  [2:0] in,
  input        en,
  output [3:0] out
);
  wire  a_clock; // @[Hierarchy.scala 11:17]
  wire  a_reset; // @[Hierarchy.scala 11:17]
  wire [3:0] a_in; // @[Hierarchy.scala 11:17]
  wire  a_en; // @[Hierarchy.scala 11:17]
  wire [3:0] a_out; // @[Hierarchy.scala 11:17]
  wire  b_clock; // @[Hierarchy.scala 12:17]
  wire  b_reset; // @[Hierarchy.scala 12:17]
  wire [3:0] b_in; // @[Hierarchy.scala 12:17]
  wire  b_en; // @[Hierarchy.scala 12:17]
  wire [3:0] b_out; // @[Hierarchy.scala 12:17]
  PipelineLane a ( // @[Hierarchy.scala 11:17]
    .clock(a_clock),
    .reset(a_reset),
    .in(a_in),
    .en(a_en),
    .out(a_out)
  );
  PipelineLane_1 b ( // @[Hierarchy.scala 12:17]
    .clock(b_clock),
    .reset(b_reset),
    .in(b_in),
    .en(b_en),
    .out(b_out)
  );
  assign out = b_out; // @[Hierarchy.scala 17:7]
  assign a_clock = clock;
  assign a_reset = reset;
  assign a_in = {{1'd0}, in}; // @[Hierarchy.scala 13:8]
  assign a_en = en; // @[Hierarchy.scala 14:8]
  assign b_clock = clock;
  assign b_reset = reset;
  assign b_in = a_out; // @[Hierarchy.scala 15:8]
  assign b_en = en; // @[Hierarchy.scala 16:8]
endmodule
