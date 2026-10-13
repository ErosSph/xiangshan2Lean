module SwitchMachine(
  input        clock,
  input        reset,
  input  [1:0] in,
  input        en,
  output [1:0] out
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg [1:0] state; // @[Mainstream.scala 45:22]
  reg [1:0] data; // @[Mainstream.scala 46:21]
  wire [1:0] _data_T_1 = data + 2'h1; // @[Mainstream.scala 49:29]
  assign out = state == 2'h2 ? data : 2'h0; // @[Mainstream.scala 52:13]
  always @(posedge clock) begin
    if (reset) begin // @[Mainstream.scala 45:22]
      state <= 2'h0; // @[Mainstream.scala 45:22]
    end else if (2'h0 == state) begin // @[Mainstream.scala 47:17]
      if (en) begin // @[Mainstream.scala 48:25]
        state <= 2'h1; // @[Mainstream.scala 48:45]
      end
    end else if (2'h1 == state) begin // @[Mainstream.scala 47:17]
      state <= 2'h2; // @[Mainstream.scala 49:42]
    end else if (2'h2 == state) begin // @[Mainstream.scala 47:17]
      state <= 2'h0; // @[Mainstream.scala 50:22]
    end
    if (reset) begin // @[Mainstream.scala 46:21]
      data <= 2'h0; // @[Mainstream.scala 46:21]
    end else if (2'h0 == state) begin // @[Mainstream.scala 47:17]
      if (en) begin // @[Mainstream.scala 48:25]
        data <= in; // @[Mainstream.scala 48:32]
      end
    end else if (2'h1 == state) begin // @[Mainstream.scala 47:17]
      data <= _data_T_1; // @[Mainstream.scala 49:21]
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
  state = _RAND_0[1:0];
  _RAND_1 = {1{`RANDOM}};
  data = _RAND_1[1:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
