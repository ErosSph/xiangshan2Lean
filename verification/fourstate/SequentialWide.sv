module SequentialWide(input clk, reset_n, en,
  input [2:5] d4, input [64:0] d65,
  output reg [8:11] q4, output logic [64:0] q65, stage65);
  always @(posedge clk) begin
    if (!reset_n) begin
      q4 <= 4'b0011;
      q65 <= 65'd1;
      stage65 <= 65'd0;
    end else if (en) begin
      q4 <= {d4[2:3],d4[4:5]};
      q65 <= d65;
      stage65 <= q65;
    end
  end
endmodule
