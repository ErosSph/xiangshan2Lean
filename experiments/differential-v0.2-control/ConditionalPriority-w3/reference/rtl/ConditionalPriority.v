module ConditionalPriority(
  input        clock,
  input        reset,
  input        a,
  input        b,
  input        c,
  output [2:0] combinational,
  output [2:0] sequential
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [2:0] r; // @[Control.scala 11:18]
  wire [1:0] _GEN_0 = b ? 2'h2 : 2'h3; // @[Control.scala 14:{18,26} 15:24]
  wire [1:0] _GEN_1 = a ? 2'h1 : _GEN_0; // @[Control.scala 13:{11,19}]
  wire [1:0] _GEN_2 = b ? 2'h1 : 2'h2; // @[Control.scala 17:{13,17,40}]
  wire [2:0] _r_T_1 = r + 3'h1; // @[Control.scala 19:25]
  assign combinational = {{1'd0}, _GEN_1}; // @[Control.scala 12:19]
  assign sequential = r; // @[Control.scala 21:14]
  always @(posedge clock) begin
    if (reset) begin // @[Control.scala 11:18]
      r <= 3'h0; // @[Control.scala 11:18]
    end else if (a) begin // @[Control.scala 16:11]
      r <= {{1'd0}, _GEN_2};
    end else if (c) begin // @[Control.scala 18:17]
      r <= 3'h3; // @[Control.scala 18:21]
    end else begin
      r <= _r_T_1; // @[Control.scala 19:20]
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
  r = _RAND_0[2:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
