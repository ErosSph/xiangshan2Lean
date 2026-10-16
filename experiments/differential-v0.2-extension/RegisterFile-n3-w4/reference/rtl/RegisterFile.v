module RegisterFile(
  input        clock,
  input        reset,
  input        write,
  input  [2:0] waddr,
  input  [2:0] raddr,
  input  [3:0] data,
  output [3:0] out
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [3:0] registers_0; // @[Designs.scala 12:26]
  reg [3:0] registers_1; // @[Designs.scala 12:26]
  reg [3:0] registers_2; // @[Designs.scala 12:26]
  wire [3:0] _GEN_7 = 2'h1 == raddr[1:0] ? registers_1 : registers_0; // @[Designs.scala 14:{7,7}]
  assign out = 2'h2 == raddr[1:0] ? registers_2 : _GEN_7; // @[Designs.scala 14:{7,7}]
  always @(posedge clock) begin
    if (reset) begin // @[Designs.scala 12:26]
      registers_0 <= 4'h0; // @[Designs.scala 12:26]
    end else if (write) begin // @[Designs.scala 13:15]
      if (2'h0 == waddr[1:0]) begin // @[Designs.scala 13:34]
        registers_0 <= data; // @[Designs.scala 13:34]
      end
    end
    if (reset) begin // @[Designs.scala 12:26]
      registers_1 <= 4'h0; // @[Designs.scala 12:26]
    end else if (write) begin // @[Designs.scala 13:15]
      if (2'h1 == waddr[1:0]) begin // @[Designs.scala 13:34]
        registers_1 <= data; // @[Designs.scala 13:34]
      end
    end
    if (reset) begin // @[Designs.scala 12:26]
      registers_2 <= 4'h0; // @[Designs.scala 12:26]
    end else if (write) begin // @[Designs.scala 13:15]
      if (2'h2 == waddr[1:0]) begin // @[Designs.scala 13:34]
        registers_2 <= data; // @[Designs.scala 13:34]
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
  registers_0 = _RAND_0[3:0];
  _RAND_1 = {1{`RANDOM}};
  registers_1 = _RAND_1[3:0];
  _RAND_2 = {1{`RANDOM}};
  registers_2 = _RAND_2[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
