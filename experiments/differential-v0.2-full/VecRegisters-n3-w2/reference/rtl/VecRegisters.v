module VecRegisters(
  input        clock,
  input        reset,
  input  [1:0] io_in_0,
  input  [1:0] io_in_1,
  input  [1:0] io_in_2,
  output [1:0] io_out_0,
  output [1:0] io_out_1,
  output [1:0] io_out_2
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [1:0] registers_0; // @[Features.scala 105:22]
  reg [1:0] registers_1; // @[Features.scala 105:22]
  reg [1:0] registers_2; // @[Features.scala 105:22]
  assign io_out_0 = registers_0; // @[Features.scala 108:15]
  assign io_out_1 = registers_1; // @[Features.scala 108:15]
  assign io_out_2 = registers_2; // @[Features.scala 108:15]
  always @(posedge clock) begin
    registers_0 <= io_in_0; // @[Features.scala 107:18]
    registers_1 <= io_in_1; // @[Features.scala 107:18]
    registers_2 <= io_in_2; // @[Features.scala 107:18]
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
  registers_0 = _RAND_0[1:0];
  _RAND_1 = {1{`RANDOM}};
  registers_1 = _RAND_1[1:0];
  _RAND_2 = {1{`RANDOM}};
  registers_2 = _RAND_2[1:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
