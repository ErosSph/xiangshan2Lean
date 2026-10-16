module SequentialSwap(input clk, reset, en, output reg a, b);
  always @(posedge clk) begin
    if (reset) a <= 1'b0;
    else if (en) a <= b;
  end
  always @(posedge clk) begin
    if (reset) b <= 1'b1;
    else if (en) b <= a;
  end
endmodule
