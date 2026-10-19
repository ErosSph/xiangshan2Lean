module AsyncFlat(input clock, input reset, input d, output reg q);
  always @(posedge clock or posedge reset) begin
    if (reset) q <= 1'b0;
    else q <= d;
  end
endmodule
