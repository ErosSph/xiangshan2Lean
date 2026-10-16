module ComparatorControl(input clk, reset,
  input signed [3:0] a, b, input [3:0] u,
  output logic signed [3:0] selected,
  output less_signed, less_mixed, same_case);
  assign less_signed = a < b;
  assign less_mixed = a < u;
  assign same_case = a === b;
  always_ff @(posedge clk) begin
    if (reset) selected <= 4'sd0;
    else if (a < b) selected <= a + b;
    else selected <= a - b;
  end
endmodule
