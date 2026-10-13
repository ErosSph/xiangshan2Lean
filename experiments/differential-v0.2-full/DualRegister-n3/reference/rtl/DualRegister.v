module DualRegister(
  input        clock,
  input        reset,
  input  [2:0] io_in,
  output [2:0] io_a,
  output [2:0] io_b
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg [2:0] first; // @[Probes.scala 22:22]
  reg [2:0] second; // @[Probes.scala 23:23]
  assign io_a = first; // @[Probes.scala 26:8]
  assign io_b = second; // @[Probes.scala 27:8]
  always @(posedge clock) begin
    if (reset) begin // @[Probes.scala 22:22]
      first <= 3'h0; // @[Probes.scala 22:22]
    end else begin
      first <= io_in; // @[Probes.scala 24:9]
    end
    if (reset) begin // @[Probes.scala 23:23]
      second <= 3'h0; // @[Probes.scala 23:23]
    end else begin
      second <= first; // @[Probes.scala 25:10]
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
  first = _RAND_0[2:0];
  _RAND_1 = {1{`RANDOM}};
  second = _RAND_1[2:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
