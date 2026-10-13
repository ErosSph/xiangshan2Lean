module Priority(
  input        clock,
  input        reset,
  input        io_en,
  input        io_clear,
  output [7:0] io_q
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [7:0] cnt; // @[Probes.scala 36:20]
  wire [7:0] _cnt_T_1 = cnt + 8'h1; // @[Probes.scala 37:28]
  assign io_q = cnt; // @[Probes.scala 39:8]
  always @(posedge clock) begin
    if (reset) begin // @[Probes.scala 36:20]
      cnt <= 8'h0; // @[Probes.scala 36:20]
    end else if (io_clear) begin // @[Probes.scala 38:18]
      cnt <= 8'h0; // @[Probes.scala 38:24]
    end else if (io_en) begin // @[Probes.scala 37:15]
      cnt <= _cnt_T_1; // @[Probes.scala 37:21]
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
  cnt = _RAND_0[7:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
