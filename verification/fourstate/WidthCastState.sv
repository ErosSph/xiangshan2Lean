module WidthCastState(input clk, en, input [3:0] a, b, input [1:0] amount,
  output logic [7:0] total, inverse, shifted);
  always_ff @(posedge clk) begin
    if (en) begin
      total <= 8'(a + b);
      inverse <= 8'(~a);
      shifted <= 8'(a << amount);
    end
  end
endmodule
