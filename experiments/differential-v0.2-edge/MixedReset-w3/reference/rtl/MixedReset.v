module MixedReset(
  input        clock,
  input        reset,
  input  [2:0] in,
  output [2:0] initialized,
  output [2:0] uninitialized
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg [2:0] a; // @[Advanced.scala 71:18]
  reg [2:0] b; // @[Advanced.scala 72:14]
  assign initialized = a; // @[Advanced.scala 75:15]
  assign uninitialized = b; // @[Advanced.scala 76:17]
  always @(posedge clock) begin
    if (reset) begin // @[Advanced.scala 71:18]
      a <= 3'h0; // @[Advanced.scala 71:18]
    end else begin
      a <= b; // @[Advanced.scala 73:5]
    end
    b <= in; // @[Advanced.scala 74:5]
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
  a = _RAND_0[2:0];
  _RAND_1 = {1{`RANDOM}};
  b = _RAND_1[2:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
