module InferredRegisters(
  input         clock,
  input         reset,
  input  [64:0] in,
  output [65:0] out
);
`ifdef RANDOMIZE_REG_INIT
  reg [95:0] _RAND_0;
  reg [95:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg [64:0] unforced; // @[Mainstream.scala 113:25]
  wire [65:0] _widened_T = in + 65'h1; // @[Mainstream.scala 114:28]
  reg [65:0] widened; // @[Mainstream.scala 114:24]
  wire [65:0] _GEN_0 = {{1'd0}, unforced}; // @[Mainstream.scala 119:18]
  wire [65:0] _out_T_1 = widened + _GEN_0; // @[Mainstream.scala 119:18]
  wire [66:0] _out_T_2 = {{1'd0}, _out_T_1}; // @[Mainstream.scala 119:29]
  assign out = _out_T_2[65:0]; // @[Mainstream.scala 119:29]
  always @(posedge clock) begin
    if (reset) begin // @[Mainstream.scala 113:25]
      unforced <= 65'h0; // @[Mainstream.scala 113:25]
    end else begin
      unforced <= in; // @[Mainstream.scala 118:12]
    end
    if (reset) begin // @[Mainstream.scala 114:24]
      widened <= 66'h0; // @[Mainstream.scala 114:24]
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
  _RAND_0 = {3{`RANDOM}};
  unforced = _RAND_0[64:0];
  _RAND_1 = {3{`RANDOM}};
  widened = _RAND_1[65:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
