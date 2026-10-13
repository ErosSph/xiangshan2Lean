module RegisterFile(
  input        clock,
  input        reset,
  input        write,
  input  [2:0] waddr,
  input  [2:0] raddr,
  input  [2:0] data,
  output [2:0] out
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg [2:0] registers_0; // @[Designs.scala 12:26]
  reg [2:0] registers_1; // @[Designs.scala 12:26]
  assign out = raddr[0] ? registers_1 : registers_0; // @[Designs.scala 14:{7,7}]
  always @(posedge clock) begin
    if (reset) begin // @[Designs.scala 12:26]
      registers_0 <= 3'h0; // @[Designs.scala 12:26]
    end else if (write) begin // @[Designs.scala 13:15]
      if (~waddr[0]) begin // @[Designs.scala 13:34]
        registers_0 <= data; // @[Designs.scala 13:34]
      end
    end
    if (reset) begin // @[Designs.scala 12:26]
      registers_1 <= 3'h0; // @[Designs.scala 12:26]
    end else if (write) begin // @[Designs.scala 13:15]
      if (waddr[0]) begin // @[Designs.scala 13:34]
        registers_1 <= data; // @[Designs.scala 13:34]
      end
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
  registers_0 = _RAND_0[2:0];
  _RAND_1 = {1{`RANDOM}};
  registers_1 = _RAND_1[2:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
