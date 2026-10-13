module VectorReset(
  input        clock,
  input        reset,
  input  [7:0] in_0,
  input  [7:0] in_1,
  input  [7:0] in_2,
  input  [7:0] in_3,
  input  [7:0] in_4,
  input        en,
  output [7:0] out_0,
  output [7:0] out_1,
  output [7:0] out_2,
  output [7:0] out_3,
  output [7:0] out_4
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
`endif // RANDOMIZE_REG_INIT
  reg [7:0] regs_0; // @[Mainstream.scala 10:21]
  reg [7:0] regs_1; // @[Mainstream.scala 10:21]
  reg [7:0] regs_2; // @[Mainstream.scala 10:21]
  reg [7:0] regs_3; // @[Mainstream.scala 10:21]
  reg [7:0] regs_4; // @[Mainstream.scala 10:21]
  wire [7:0] _regs_0_T_1 = in_0 + 8'h1; // @[Mainstream.scala 11:54]
  wire [7:0] _regs_1_T_1 = in_1 + 8'h1; // @[Mainstream.scala 11:54]
  wire [7:0] _regs_2_T_1 = in_2 + 8'h1; // @[Mainstream.scala 11:54]
  wire [7:0] _regs_3_T_1 = in_3 + 8'h1; // @[Mainstream.scala 11:54]
  wire [7:0] _regs_4_T_1 = in_4 + 8'h1; // @[Mainstream.scala 11:54]
  assign out_0 = regs_0; // @[Mainstream.scala 12:7]
  assign out_1 = regs_1; // @[Mainstream.scala 12:7]
  assign out_2 = regs_2; // @[Mainstream.scala 12:7]
  assign out_3 = regs_3; // @[Mainstream.scala 12:7]
  assign out_4 = regs_4; // @[Mainstream.scala 12:7]
  always @(posedge clock) begin
    if (reset) begin // @[Mainstream.scala 10:21]
      regs_0 <= 8'h0; // @[Mainstream.scala 10:21]
    end else if (en) begin // @[Mainstream.scala 11:35]
      regs_0 <= _regs_0_T_1; // @[Mainstream.scala 11:45]
    end
    if (reset) begin // @[Mainstream.scala 10:21]
      regs_1 <= 8'h0; // @[Mainstream.scala 10:21]
    end else if (en) begin // @[Mainstream.scala 11:35]
      regs_1 <= _regs_1_T_1; // @[Mainstream.scala 11:45]
    end
    if (reset) begin // @[Mainstream.scala 10:21]
      regs_2 <= 8'h0; // @[Mainstream.scala 10:21]
    end else if (en) begin // @[Mainstream.scala 11:35]
      regs_2 <= _regs_2_T_1; // @[Mainstream.scala 11:45]
    end
    if (reset) begin // @[Mainstream.scala 10:21]
      regs_3 <= 8'h0; // @[Mainstream.scala 10:21]
    end else if (en) begin // @[Mainstream.scala 11:35]
      regs_3 <= _regs_3_T_1; // @[Mainstream.scala 11:45]
    end
    if (reset) begin // @[Mainstream.scala 10:21]
      regs_4 <= 8'h0; // @[Mainstream.scala 10:21]
    end else if (en) begin // @[Mainstream.scala 11:35]
      regs_4 <= _regs_4_T_1; // @[Mainstream.scala 11:45]
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
  regs_0 = _RAND_0[7:0];
  _RAND_1 = {1{`RANDOM}};
  regs_1 = _RAND_1[7:0];
  _RAND_2 = {1{`RANDOM}};
  regs_2 = _RAND_2[7:0];
  _RAND_3 = {1{`RANDOM}};
  regs_3 = _RAND_3[7:0];
  _RAND_4 = {1{`RANDOM}};
  regs_4 = _RAND_4[7:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
