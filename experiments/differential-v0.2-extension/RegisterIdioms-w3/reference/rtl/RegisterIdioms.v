module RegisterIdioms(
  input        clock,
  input        reset,
  input  [2:0] in,
  input        en,
  output [2:0] out
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [2:0] delayed; // @[Mainstream.scala 20:24]
  reg [2:0] held; // @[Reg.scala 35:20]
  reg [2:0] explicit; // @[Mainstream.scala 22:25]
  assign out = explicit; // @[Mainstream.scala 24:7]
  always @(posedge clock) begin
    if (reset) begin // @[Mainstream.scala 20:24]
      delayed <= 3'h0; // @[Mainstream.scala 20:24]
    end else begin
      delayed <= in; // @[Mainstream.scala 20:24]
    end
    if (reset) begin // @[Reg.scala 35:20]
      held <= 3'h0; // @[Reg.scala 35:20]
    end else if (en) begin // @[Reg.scala 36:18]
      held <= delayed; // @[Reg.scala 36:22]
    end
    if (reset) begin // @[Mainstream.scala 22:25]
      explicit <= 3'h0; // @[Mainstream.scala 22:25]
    end else begin
      explicit <= held; // @[Mainstream.scala 23:12]
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
  delayed = _RAND_0[2:0];
  _RAND_1 = {1{`RANDOM}};
  held = _RAND_1[2:0];
  _RAND_2 = {1{`RANDOM}};
  explicit = _RAND_2[2:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
