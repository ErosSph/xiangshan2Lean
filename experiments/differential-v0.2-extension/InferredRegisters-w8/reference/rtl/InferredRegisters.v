module InferredRegisters(
  input        clock,
  input        reset,
  input  [7:0] in,
  output [8:0] out
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg [7:0] unforced; // @[Mainstream.scala 113:25]
  wire [8:0] _widened_T = in + 8'h1; // @[Mainstream.scala 114:28]
  reg [8:0] widened; // @[Mainstream.scala 114:24]
  wire [8:0] _GEN_0 = {{1'd0}, unforced}; // @[Mainstream.scala 119:18]
  wire [8:0] _out_T_1 = widened + _GEN_0; // @[Mainstream.scala 119:18]
  wire [9:0] _out_T_2 = {{1'd0}, _out_T_1}; // @[Mainstream.scala 119:29]
  assign out = _out_T_2[8:0]; // @[Mainstream.scala 119:29]
  always @(posedge clock) begin
    if (reset) begin // @[Mainstream.scala 113:25]
      unforced <= 8'h0; // @[Mainstream.scala 113:25]
    end else begin
      unforced <= in; // @[Mainstream.scala 118:12]
    end
    if (reset) begin // @[Mainstream.scala 114:24]
      widened <= 9'h0; // @[Mainstream.scala 114:24]
    end else begin
      widened <= _widened_T; // @[Mainstream.scala 114:24]
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
  unforced = _RAND_0[7:0];
  _RAND_1 = {1{`RANDOM}};
  widened = _RAND_1[8:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
