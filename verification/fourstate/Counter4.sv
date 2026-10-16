module Counter4(input clk, reset, en, input [3:0] load,
  output logic [3:0] q, output [4:0] widened,
  output [3:0] decreased, negated);
  always_ff @(posedge clk) begin
    if (reset) q <= 4'd0;
    else if (en) q <= q + 4'd1;
    else q <= load;
  end
  assign widened = q + 4'd1;
  assign decreased = q - 4'd1;
  assign negated = -q;
endmodule
