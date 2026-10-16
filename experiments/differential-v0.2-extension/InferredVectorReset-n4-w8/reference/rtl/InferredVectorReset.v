module InferredVectorReset(
  input        clock,
  input        reset,
  input  [7:0] in_0,
  input  [7:0] in_1,
  input  [7:0] in_2,
  input  [7:0] in_3,
  output       out_0,
  output       out_1,
  output       out_2,
  output       out_3
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg  r_0; // @[Mainstream.scala 126:18]
  reg  r_1; // @[Mainstream.scala 126:18]
  reg  r_2; // @[Mainstream.scala 126:18]
  reg  r_3; // @[Mainstream.scala 126:18]
  wire [7:0] _GEN_0 = reset ? 8'h0 : in_0; // @[Mainstream.scala 126:{18,18} 127:31]
  wire [7:0] _GEN_1 = reset ? 8'h0 : in_1; // @[Mainstream.scala 126:{18,18} 127:31]
  wire [7:0] _GEN_2 = reset ? 8'h0 : in_2; // @[Mainstream.scala 126:{18,18} 127:31]
  wire [7:0] _GEN_3 = reset ? 8'h0 : in_3; // @[Mainstream.scala 126:{18,18} 127:31]
  assign out_0 = r_0; // @[Mainstream.scala 128:7]
  assign out_1 = r_1; // @[Mainstream.scala 128:7]
  assign out_2 = r_2; // @[Mainstream.scala 128:7]
  assign out_3 = r_3; // @[Mainstream.scala 128:7]
  always @(posedge clock) begin
    r_0 <= _GEN_0[0]; // @[Mainstream.scala 126:{18,18} 127:31]
    r_1 <= _GEN_1[0]; // @[Mainstream.scala 126:{18,18} 127:31]
    r_2 <= _GEN_2[0]; // @[Mainstream.scala 126:{18,18} 127:31]
    r_3 <= _GEN_3[0]; // @[Mainstream.scala 126:{18,18} 127:31]
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
  r_0 = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  r_1 = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  r_2 = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  r_3 = _RAND_3[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
