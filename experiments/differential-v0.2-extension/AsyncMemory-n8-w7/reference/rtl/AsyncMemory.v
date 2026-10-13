module AsyncMemory(
  input        clock,
  input        reset,
  input        write,
  input  [2:0] waddr,
  input  [2:0] raddr,
  input  [6:0] data,
  output [6:0] out
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
  reg [6:0] memory [0:7]; // @[Memories.scala 11:19]
  wire  memory_out_MPORT_en; // @[Memories.scala 11:19]
  wire [2:0] memory_out_MPORT_addr; // @[Memories.scala 11:19]
  wire [6:0] memory_out_MPORT_data; // @[Memories.scala 11:19]
  wire [6:0] memory_MPORT_data; // @[Memories.scala 11:19]
  wire [2:0] memory_MPORT_addr; // @[Memories.scala 11:19]
  wire  memory_MPORT_mask; // @[Memories.scala 11:19]
  wire  memory_MPORT_en; // @[Memories.scala 11:19]
  assign memory_out_MPORT_en = 1'h1;
  assign memory_out_MPORT_addr = raddr;
  assign memory_out_MPORT_data = memory[memory_out_MPORT_addr]; // @[Memories.scala 11:19]
  assign memory_MPORT_data = data;
  assign memory_MPORT_addr = waddr;
  assign memory_MPORT_mask = 1'h1;
  assign memory_MPORT_en = write;
  assign out = memory_out_MPORT_data; // @[Memories.scala 13:7]
  always @(posedge clock) begin
    if (memory_MPORT_en & memory_MPORT_mask) begin
      memory[memory_MPORT_addr] <= memory_MPORT_data; // @[Memories.scala 11:19]
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
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 8; initvar = initvar+1)
    memory[initvar] = _RAND_0[6:0];
`endif // RANDOMIZE_MEM_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
