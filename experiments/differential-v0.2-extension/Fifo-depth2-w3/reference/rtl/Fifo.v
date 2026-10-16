module Fifo(
  input        clock,
  input        reset,
  input        enq,
  input        deq,
  input  [2:0] data,
  output [2:0] out,
  output       full,
  output       empty
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
`endif // RANDOMIZE_REG_INIT
  reg [2:0] storage_0; // @[Designs.scala 25:24]
  reg [2:0] storage_1; // @[Designs.scala 25:24]
  reg  read; // @[Designs.scala 26:21]
  reg  write; // @[Designs.scala 27:22]
  reg [1:0] count; // @[Designs.scala 28:22]
  wire  push = enq & count < 2'h2; // @[Designs.scala 29:18]
  wire  pop = deq & count != 2'h0; // @[Designs.scala 30:17]
  wire [1:0] _count_T_1 = count + 2'h1; // @[Designs.scala 36:39]
  wire [1:0] _count_T_3 = count - 2'h1; // @[Designs.scala 37:39]
  assign out = read ? storage_1 : storage_0; // @[Designs.scala 38:{7,7}]
  assign full = count == 2'h2; // @[Designs.scala 39:17]
  assign empty = count == 2'h0; // @[Designs.scala 40:18]
  always @(posedge clock) begin
    if (reset) begin // @[Designs.scala 25:24]
      storage_0 <= 3'h0; // @[Designs.scala 25:24]
    end else if (push) begin // @[Designs.scala 31:14]
      if (~write) begin // @[Designs.scala 32:20]
        storage_0 <= data; // @[Designs.scala 32:20]
      end
    end
    if (reset) begin // @[Designs.scala 25:24]
      storage_1 <= 3'h0; // @[Designs.scala 25:24]
    end else if (push) begin // @[Designs.scala 31:14]
      if (write) begin // @[Designs.scala 32:20]
        storage_1 <= data; // @[Designs.scala 32:20]
      end
    end
    if (reset) begin // @[Designs.scala 26:21]
      read <= 1'h0; // @[Designs.scala 26:21]
    end else if (pop) begin // @[Designs.scala 35:13]
      if (read) begin // @[Designs.scala 35:26]
        read <= 1'h0;
      end else begin
        read <= read + 1'h1;
      end
    end
    if (reset) begin // @[Designs.scala 27:22]
      write <= 1'h0; // @[Designs.scala 27:22]
    end else if (push) begin // @[Designs.scala 31:14]
      if (write) begin // @[Designs.scala 33:17]
        write <= 1'h0;
      end else begin
        write <= write + 1'h1;
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
  storage_0 = _RAND_0[2:0];
  _RAND_1 = {1{`RANDOM}};
  storage_1 = _RAND_1[2:0];
  _RAND_2 = {1{`RANDOM}};
  read = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  write = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  count = _RAND_4[1:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
