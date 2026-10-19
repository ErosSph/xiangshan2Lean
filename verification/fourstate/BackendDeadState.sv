module BackendDeadState(
  input clk, reset, en, d,
  input [4:0] a, b,
  output logic q,
  output logic [4:0] r
);
  always @(posedge clk) begin
    if (reset) q <= 1'b0;
    else if (en) q <= 1'({(a+b), d});
    if (en) r <= a+b;
  end
endmodule
