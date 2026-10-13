module SyncMemory(
  input        clock,
  input        reset,
  input        write,
  input        readEnable,
  input  [2:0] waddr,
  input  [2:0] raddr,
  input  [3:0] data,
  output [3:0] out
);
`ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_GARBAGE_ASSIGN
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg [3:0] memory [0:2]; // @[Memories.scala 24:27]
  wire  memory_out_MPORT_en; // @[Memories.scala 24:27]
  wire [1:0] memory_out_MPORT_addr; // @[Memories.scala 24:27]
  wire [3:0] memory_out_MPORT_data; // @[Memories.scala 24:27]
  wire [3:0] memory_MPORT_data; // @[Memories.scala 24:27]
  wire [1:0] memory_MPORT_addr; // @[Memories.scala 24:27]
  wire  memory_MPORT_mask; // @[Memories.scala 24:27]
  wire  memory_MPORT_en; // @[Memories.scala 24:27]
  reg  memory_out_MPORT_en_pipe_0;
  reg [1:0] memory_out_MPORT_addr_pipe_0;
  assign memory_out_MPORT_en = memory_out_MPORT_en_pipe_0;
  assign memory_out_MPORT_addr = memory_out_MPORT_addr_pipe_0;
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign memory_out_MPORT_data = memory[memory_out_MPORT_addr]; // @[Memories.scala 24:27]
  `else
  assign memory_out_MPORT_data = memory_out_MPORT_addr >= 2'h3 ? _RAND_1[3:0] : memory[memory_out_MPORT_addr]; // @[Memories.scala 24:27]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign memory_MPORT_data = data;
  assign memory_MPORT_addr = waddr[1:0];
  assign memory_MPORT_mask = 1'h1;
  assign memory_MPORT_en = write;
  assign out = memory_out_MPORT_data; // @[Memories.scala 26:7]
  always @(posedge clock) begin
    if (memory_MPORT_en & memory_MPORT_mask) begin
      memory[memory_MPORT_addr] <= memory_MPORT_data; // @[Memories.scala 24:27]
    end
    memory_out_MPORT_en_pipe_0 <= readEnable;
    if (readEnable) begin
      memory_out_MPORT_addr_pipe_0 <= raddr[1:0];
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
`ifdef RANDOMIZE_GARBAGE_ASSIGN
  _RAND_1 = {1{`RANDOM}};
`endif // RANDOMIZE_GARBAGE_ASSIGN
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 3; initvar = initvar+1)
    memory[initvar] = _RAND_0[3:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  memory_out_MPORT_en_pipe_0 = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  memory_out_MPORT_addr_pipe_0 = _RAND_3[1:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
