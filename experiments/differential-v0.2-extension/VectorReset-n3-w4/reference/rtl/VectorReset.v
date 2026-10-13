module VectorReset(
  input        clock,
  input        reset,
  input  [3:0] in_0,
  input  [3:0] in_1,
  input  [3:0] in_2,
  input        en,
  output [3:0] out_0,
  output [3:0] out_1,
  output [3:0] out_2
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [3:0] regs_0; // @[Mainstream.scala 10:21]
  reg [3:0] regs_1; // @[Mainstream.scala 10:21]
  reg [3:0] regs_2; // @[Mainstream.scala 10:21]
  wire [3:0] _regs_0_T_1 = in_0 + 4'h1; // @[Mainstream.scala 11:54]
  wire [3:0] _regs_1_T_1 = in_1 + 4'h1; // @[Mainstream.scala 11:54]
  wire [3:0] _regs_2_T_1 = in_2 + 4'h1; // @[Mainstream.scala 11:54]
  assign out_0 = regs_0; // @[Mainstream.scala 12:7]
  assign out_1 = regs_1; // @[Mainstream.scala 12:7]
  assign out_2 = regs_2; // @[Mainstream.scala 12:7]
  always @(posedge clock) begin
    if (reset) begin // @[Mainstream.scala 10:21]
      regs_0 <= 4'h0; // @[Mainstream.scala 10:21]
    end else if (en) begin // @[Mainstream.scala 11:35]
      regs_0 <= _regs_0_T_1; // @[Mainstream.scala 11:45]
    end
    if (reset) begin // @[Mainstream.scala 10:21]
      regs_1 <= 4'h0; // @[Mainstream.scala 10:21]
    end else if (en) begin // @[Mainstream.scala 11:35]
      regs_1 <= _regs_1_T_1; // @[Mainstream.scala 11:45]
    end
    if (reset) begin // @[Mainstream.scala 10:21]
      regs_2 <= 4'h0; // @[Mainstream.scala 10:21]
    end else if (en) begin // @[Mainstream.scala 11:35]
      regs_2 <= _regs_2_T_1; // @[Mainstream.scala 11:45]
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
  regs_0 = _RAND_0[3:0];
  _RAND_1 = {1{`RANDOM}};
  regs_1 = _RAND_1[3:0];
  _RAND_2 = {1{`RANDOM}};
  regs_2 = _RAND_2[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
