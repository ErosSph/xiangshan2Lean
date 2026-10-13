module Fifo(
  input        clock,
  input        reset,
  input        enq,
  input        deq,
  input  [6:0] data,
  output [6:0] out,
  output       full,
  output       empty
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
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
`endif // RANDOMIZE_REG_INIT
  reg [6:0] storage_0; // @[Designs.scala 25:24]
  reg [6:0] storage_1; // @[Designs.scala 25:24]
  reg [6:0] storage_2; // @[Designs.scala 25:24]
  reg [6:0] storage_3; // @[Designs.scala 25:24]
  reg [6:0] storage_4; // @[Designs.scala 25:24]
  reg [6:0] storage_5; // @[Designs.scala 25:24]
  reg [6:0] storage_6; // @[Designs.scala 25:24]
  reg [6:0] storage_7; // @[Designs.scala 25:24]
  reg [2:0] read; // @[Designs.scala 26:21]
  reg [2:0] write; // @[Designs.scala 27:22]
  reg [3:0] count; // @[Designs.scala 28:22]
  wire  push = enq & count < 4'h8; // @[Designs.scala 29:18]
  wire  pop = deq & count != 4'h0; // @[Designs.scala 30:17]
  wire [2:0] _write_T_2 = write + 3'h1; // @[Designs.scala 33:54]
  wire [2:0] _read_T_2 = read + 3'h1; // @[Designs.scala 35:61]
  wire [3:0] _count_T_1 = count + 4'h1; // @[Designs.scala 36:39]
  wire [3:0] _count_T_3 = count - 4'h1; // @[Designs.scala 37:39]
  wire [6:0] _GEN_21 = 3'h1 == read ? storage_1 : storage_0; // @[Designs.scala 38:{7,7}]
  wire [6:0] _GEN_22 = 3'h2 == read ? storage_2 : _GEN_21; // @[Designs.scala 38:{7,7}]
  wire [6:0] _GEN_23 = 3'h3 == read ? storage_3 : _GEN_22; // @[Designs.scala 38:{7,7}]
  wire [6:0] _GEN_24 = 3'h4 == read ? storage_4 : _GEN_23; // @[Designs.scala 38:{7,7}]
  wire [6:0] _GEN_25 = 3'h5 == read ? storage_5 : _GEN_24; // @[Designs.scala 38:{7,7}]
  wire [6:0] _GEN_26 = 3'h6 == read ? storage_6 : _GEN_25; // @[Designs.scala 38:{7,7}]
  assign out = 3'h7 == read ? storage_7 : _GEN_26; // @[Designs.scala 38:{7,7}]
  assign full = count == 4'h8; // @[Designs.scala 39:17]
  assign empty = count == 4'h0; // @[Designs.scala 40:18]
  always @(posedge clock) begin
    if (reset) begin // @[Designs.scala 25:24]
      storage_0 <= 7'h0; // @[Designs.scala 25:24]
    end else if (push) begin // @[Designs.scala 31:14]
      if (3'h0 == write) begin // @[Designs.scala 32:20]
        storage_0 <= data; // @[Designs.scala 32:20]
      end
    end
    if (reset) begin // @[Designs.scala 25:24]
      storage_1 <= 7'h0; // @[Designs.scala 25:24]
    end else if (push) begin // @[Designs.scala 31:14]
      if (3'h1 == write) begin // @[Designs.scala 32:20]
        storage_1 <= data; // @[Designs.scala 32:20]
      end
    end
    if (reset) begin // @[Designs.scala 25:24]
      storage_2 <= 7'h0; // @[Designs.scala 25:24]
    end else if (push) begin // @[Designs.scala 31:14]
      if (3'h2 == write) begin // @[Designs.scala 32:20]
        storage_2 <= data; // @[Designs.scala 32:20]
      end
    end
    if (reset) begin // @[Designs.scala 25:24]
      storage_3 <= 7'h0; // @[Designs.scala 25:24]
    end else if (push) begin // @[Designs.scala 31:14]
      if (3'h3 == write) begin // @[Designs.scala 32:20]
        storage_3 <= data; // @[Designs.scala 32:20]
      end
    end
    if (reset) begin // @[Designs.scala 25:24]
      storage_4 <= 7'h0; // @[Designs.scala 25:24]
    end else if (push) begin // @[Designs.scala 31:14]
      if (3'h4 == write) begin // @[Designs.scala 32:20]
        storage_4 <= data; // @[Designs.scala 32:20]
      end
    end
    if (reset) begin // @[Designs.scala 25:24]
      storage_5 <= 7'h0; // @[Designs.scala 25:24]
    end else if (push) begin // @[Designs.scala 31:14]
      if (3'h5 == write) begin // @[Designs.scala 32:20]
        storage_5 <= data; // @[Designs.scala 32:20]
      end
    end
    if (reset) begin // @[Designs.scala 25:24]
      storage_6 <= 7'h0; // @[Designs.scala 25:24]
    end else if (push) begin // @[Designs.scala 31:14]
      if (3'h6 == write) begin // @[Designs.scala 32:20]
        storage_6 <= data; // @[Designs.scala 32:20]
      end
    end
    if (reset) begin // @[Designs.scala 25:24]
      storage_7 <= 7'h0; // @[Designs.scala 25:24]
    end else if (push) begin // @[Designs.scala 31:14]
      if (3'h7 == write) begin // @[Designs.scala 32:20]
        storage_7 <= data; // @[Designs.scala 32:20]
      end
    end
    if (reset) begin // @[Designs.scala 26:21]
      read <= 3'h0; // @[Designs.scala 26:21]
    end else if (pop) begin // @[Designs.scala 35:13]
      if (read == 3'h7) begin // @[Designs.scala 35:26]
        read <= 3'h0;
      end else begin
        read <= _read_T_2;
      end
    end
    if (reset) begin // @[Designs.scala 27:22]
      write <= 3'h0; // @[Designs.scala 27:22]
    end else if (push) begin // @[Designs.scala 31:14]
      if (write == 3'h7) begin // @[Designs.scala 33:17]
        write <= 3'h0;
      end else begin
        write <= _write_T_2;
      end
    end
    if (reset) begin // @[Designs.scala 28:22]
      count <= 4'h0; // @[Designs.scala 28:22]
    end else if (pop & ~push) begin // @[Designs.scala 37:22]
      count <= _count_T_3; // @[Designs.scala 37:30]
    end else if (push & ~pop) begin // @[Designs.scala 36:22]
      count <= _count_T_1; // @[Designs.scala 36:30]
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
  storage_0 = _RAND_0[6:0];
  _RAND_1 = {1{`RANDOM}};
  storage_1 = _RAND_1[6:0];
  _RAND_2 = {1{`RANDOM}};
  storage_2 = _RAND_2[6:0];
  _RAND_3 = {1{`RANDOM}};
  storage_3 = _RAND_3[6:0];
  _RAND_4 = {1{`RANDOM}};
  storage_4 = _RAND_4[6:0];
  _RAND_5 = {1{`RANDOM}};
  storage_5 = _RAND_5[6:0];
  _RAND_6 = {1{`RANDOM}};
  storage_6 = _RAND_6[6:0];
  _RAND_7 = {1{`RANDOM}};
  storage_7 = _RAND_7[6:0];
  _RAND_8 = {1{`RANDOM}};
  read = _RAND_8[2:0];
  _RAND_9 = {1{`RANDOM}};
  write = _RAND_9[2:0];
  _RAND_10 = {1{`RANDOM}};
  count = _RAND_10[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
