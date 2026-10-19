module AsyncSwap(input clock, reset, enable, output reg q, r);
  always @(posedge reset or posedge clock) begin
    if (reset) begin q <= 1'b0; r <= 1'b1; end
    else if (enable) begin q <= r; r <= q; end
  end
endmodule
