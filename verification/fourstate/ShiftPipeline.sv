module ShiftPipeline(input clk, reset,
  input signed [64:0] data, input [6:0] amount,
  output logic signed [64:0] stage, result,
  output signed [64:0] left_shift, right_shift, arithmetic_left, arithmetic_right);
  assign left_shift = data << amount;
  assign right_shift = data >> amount;
  assign arithmetic_left = data <<< amount;
  assign arithmetic_right = data >>> amount;
  always_ff @(posedge clk) begin
    if (reset) begin
      stage <= 65'd0;
      result <= 65'd0;
    end else begin
      stage <= data;
      result <= stage >>> amount;
    end
  end
endmodule
