module RegisterFile(
  input        clock,
  input        reset,
  input        write,
  input  [2:0] waddr,
  input  [2:0] raddr,
  input  [6:0] data,
  output [6:0] out
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
`endif // RANDOMIZE_REG_INIT
  reg [6:0] registers_0; // @[Designs.scala 12:26]
  reg [6:0] registers_1; // @[Designs.scala 12:26]
  reg [6:0] registers_2; // @[Designs.scala 12:26]
  reg [6:0] registers_3; // @[Designs.scala 12:26]
  reg [6:0] registers_4; // @[Designs.scala 12:26]
  reg [6:0] registers_5; // @[Designs.scala 12:26]
  reg [6:0] registers_6; // @[Designs.scala 12:26]
  reg [6:0] registers_7; // @[Designs.scala 12:26]
  wire [6:0] _GEN_17 = 3'h1 == raddr ? registers_1 : registers_0; // @[Designs.scala 14:{7,7}]
  wire [6:0] _GEN_18 = 3'h2 == raddr ? registers_2 : _GEN_17; // @[Designs.scala 14:{7,7}]
  wire [6:0] _GEN_19 = 3'h3 == raddr ? registers_3 : _GEN_18; // @[Designs.scala 14:{7,7}]
  wire [6:0] _GEN_20 = 3'h4 == raddr ? registers_4 : _GEN_19; // @[Designs.scala 14:{7,7}]
  wire [6:0] _GEN_21 = 3'h5 == raddr ? registers_5 : _GEN_20; // @[Designs.scala 14:{7,7}]
  wire [6:0] _GEN_22 = 3'h6 == raddr ? registers_6 : _GEN_21; // @[Designs.scala 14:{7,7}]
  assign out = 3'h7 == raddr ? registers_7 : _GEN_22; // @[Designs.scala 14:{7,7}]
  always @(posedge clock) begin
    if (reset) begin // @[Designs.scala 12:26]
      registers_0 <= 7'h0; // @[Designs.scala 12:26]
    end else if (write) begin // @[Designs.scala 13:15]
      if (3'h0 == waddr) begin // @[Designs.scala 13:34]
        registers_0 <= data; // @[Designs.scala 13:34]
      end
    end
    if (reset) begin // @[Designs.scala 12:26]
      registers_1 <= 7'h0; // @[Designs.scala 12:26]
    end else if (write) begin // @[Designs.scala 13:15]
      if (3'h1 == waddr) begin // @[Designs.scala 13:34]
        registers_1 <= data; // @[Designs.scala 13:34]
      end
    end
    if (reset) begin // @[Designs.scala 12:26]
      registers_2 <= 7'h0; // @[Designs.scala 12:26]
    end else if (write) begin // @[Designs.scala 13:15]
      if (3'h2 == waddr) begin // @[Designs.scala 13:34]
        registers_2 <= data; // @[Designs.scala 13:34]
      end
    end
    if (reset) begin // @[Designs.scala 12:26]
      registers_3 <= 7'h0; // @[Designs.scala 12:26]
    end else if (write) begin // @[Designs.scala 13:15]
      if (3'h3 == waddr) begin // @[Designs.scala 13:34]
        registers_3 <= data; // @[Designs.scala 13:34]
      end
    end
    if (reset) begin // @[Designs.scala 12:26]
      registers_4 <= 7'h0; // @[Designs.scala 12:26]
    end else if (write) begin // @[Designs.scala 13:15]
      if (3'h4 == waddr) begin // @[Designs.scala 13:34]
        registers_4 <= data; // @[Designs.scala 13:34]
      end
    end
    if (reset) begin // @[Designs.scala 12:26]
      registers_5 <= 7'h0; // @[Designs.scala 12:26]
    end else if (write) begin // @[Designs.scala 13:15]
      if (3'h5 == waddr) begin // @[Designs.scala 13:34]
        registers_5 <= data; // @[Designs.scala 13:34]
      end
    end
    if (reset) begin // @[Designs.scala 12:26]
      registers_6 <= 7'h0; // @[Designs.scala 12:26]
    end else if (write) begin // @[Designs.scala 13:15]
      if (3'h6 == waddr) begin // @[Designs.scala 13:34]
        registers_6 <= data; // @[Designs.scala 13:34]
      end
    end
    if (reset) begin // @[Designs.scala 12:26]
      registers_7 <= 7'h0; // @[Designs.scala 12:26]
    end else if (write) begin // @[Designs.scala 13:15]
      if (3'h7 == waddr) begin // @[Designs.scala 13:34]
        registers_7 <= data; // @[Designs.scala 13:34]
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
  registers_0 = _RAND_0[6:0];
  _RAND_1 = {1{`RANDOM}};
  registers_1 = _RAND_1[6:0];
  _RAND_2 = {1{`RANDOM}};
  registers_2 = _RAND_2[6:0];
  _RAND_3 = {1{`RANDOM}};
  registers_3 = _RAND_3[6:0];
  _RAND_4 = {1{`RANDOM}};
  registers_4 = _RAND_4[6:0];
  _RAND_5 = {1{`RANDOM}};
  registers_5 = _RAND_5[6:0];
  _RAND_6 = {1{`RANDOM}};
  registers_6 = _RAND_6[6:0];
  _RAND_7 = {1{`RANDOM}};
  registers_7 = _RAND_7[6:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
