module Fifo(
  input        clock,
  input        reset,
  input        enq,
  input        deq,
  input  [3:0] data,
  output [3:0] out,
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
`endif // RANDOMIZE_REG_INIT
  reg [3:0] storage_0; // @[Designs.scala 25:24]
  reg [3:0] storage_1; // @[Designs.scala 25:24]
  reg [3:0] storage_2; // @[Designs.scala 25:24]
  reg [1:0] read; // @[Designs.scala 26:21]
  reg [1:0] write; // @[Designs.scala 27:22]
  reg [1:0] count; // @[Designs.scala 28:22]
  wire  push = enq & count < 2'h3; // @[Designs.scala 29:18]
  wire  pop = deq & count != 2'h0; // @[Designs.scala 30:17]
  wire [1:0] _write_T_2 = write + 2'h1; // @[Designs.scala 33:54]
  wire [1:0] _read_T_2 = read + 2'h1; // @[Designs.scala 35:61]
  wire [1:0] _count_T_1 = count + 2'h1; // @[Designs.scala 36:39]
  wire [1:0] _count_T_3 = count - 2'h1; // @[Designs.scala 37:39]
  wire [3:0] _GEN_11 = 2'h1 == read ? storage_1 : storage_0; // @[Designs.scala 38:{7,7}]
  assign out = 2'h2 == read ? storage_2 : _GEN_11; // @[Designs.scala 38:{7,7}]
  assign full = count == 2'h3; // @[Designs.scala 39:17]
  assign empty = count == 2'h0; // @[Designs.scala 40:18]
  always @(posedge clock) begin
    if (reset) begin // @[Designs.scala 25:24]
      storage_0 <= 4'h0; // @[Designs.scala 25:24]
    end else if (push) begin // @[Designs.scala 31:14]
      if (2'h0 == write) begin // @[Designs.scala 32:20]
        storage_0 <= data; // @[Designs.scala 32:20]
      end
    end
    if (reset) begin // @[Designs.scala 25:24]
      storage_1 <= 4'h0; // @[Designs.scala 25:24]
    end else if (push) begin // @[Designs.scala 31:14]
      if (2'h1 == write) begin // @[Designs.scala 32:20]
        storage_1 <= data; // @[Designs.scala 32:20]
      end
    end
    if (reset) begin // @[Designs.scala 25:24]
      storage_2 <= 4'h0; // @[Designs.scala 25:24]
    end else if (push) begin // @[Designs.scala 31:14]
      if (2'h2 == write) begin // @[Designs.scala 32:20]
        storage_2 <= data; // @[Designs.scala 32:20]
      end
    end
    if (reset) begin // @[Designs.scala 26:21]
      read <= 2'h0; // @[Designs.scala 26:21]
    end else if (pop) begin // @[Designs.scala 35:13]
      if (read == 2'h2) begin // @[Designs.scala 35:26]
        read <= 2'h0;
      end else begin
        read <= _read_T_2;
      end
    end
    if (reset) begin // @[Designs.scala 27:22]
      write <= 2'h0; // @[Designs.scala 27:22]
    end else if (push) begin // @[Designs.scala 31:14]
      if (write == 2'h2) begin // @[Designs.scala 33:17]
        write <= 2'h0;
      end else begin
        write <= _write_T_2;
      end
    end
    if (reset) begin // @[Designs.scala 28:22]
      count <= 2'h0; // @[Designs.scala 28:22]
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
  storage_0 = _RAND_0[3:0];
  _RAND_1 = {1{`RANDOM}};
  storage_1 = _RAND_1[3:0];
  _RAND_2 = {1{`RANDOM}};
  storage_2 = _RAND_2[3:0];
  _RAND_3 = {1{`RANDOM}};
  read = _RAND_3[1:0];
  _RAND_4 = {1{`RANDOM}};
  write = _RAND_4[1:0];
  _RAND_5 = {1{`RANDOM}};
  count = _RAND_5[1:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
