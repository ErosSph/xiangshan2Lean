module WidthState(input clk, input signed [3:0] d, input en,
  output logic signed [3:0] q, output logic signed [7:0] expanded,
  output [7:0] observed);
  assign observed = q;
  always_ff @(posedge clk) begin
    if (en) begin
      q <= d;
      expanded <= q;
    end
  end
endmodule
