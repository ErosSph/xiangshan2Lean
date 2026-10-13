module ConditionalPriority(
  input   clock,
  input   reset,
  input   a,
  input   b,
  input   c,
  output  combinational,
  output  sequential
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg  r; // @[Control.scala 11:18]
  wire [1:0] _GEN_0 = b ? 2'h2 : 2'h3; // @[Control.scala 14:{18,26} 15:24]
  wire [1:0] _GEN_1 = a ? 2'h1 : _GEN_0; // @[Control.scala 13:{11,19}]
  wire [1:0] _GEN_2 = b ? 2'h1 : 2'h2; // @[Control.scala 17:{13,17,40}]
  wire  _r_T_1 = r + 1'h1; // @[Control.scala 19:25]
  wire [1:0] _GEN_3 = c ? 2'h3 : {{1'd0}, _r_T_1}; // @[Control.scala 18:{17,21} 19:20]
  wire [1:0] _GEN_4 = a ? _GEN_2 : _GEN_3; // @[Control.scala 16:11]
  wire [1:0] _GEN_5 = reset ? 2'h0 : _GEN_4; // @[Control.scala 11:{18,18}]
  assign combinational = _GEN_1[0]; // @[Control.scala 12:19]
  assign sequential = r; // @[Control.scala 21:14]
  always @(posedge clock) begin
    r <= _GEN_5[0]; // @[Control.scala 11:{18,18}]
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
  r = _RAND_0[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
