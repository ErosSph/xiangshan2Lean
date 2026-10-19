module AssertionQuiet(input clk,d,output reg q);
  always @(posedge clk) begin : success
    ok: assert(1'b1) else $error("unreachable_failure");
    q <= d;
  end
endmodule
