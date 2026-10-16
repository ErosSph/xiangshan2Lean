module SequentialControl(input clk, reset, en, d,
  output logic q, stage, chosen, priority_q, output observed);
  reg hidden;
  assign observed = hidden;
  always_ff @(posedge clk) begin
    if (reset) begin
      q <= 1'b0;
      stage <= 1'b0;
      chosen <= 1'b0;
      priority_q <= 1'b0;
    end else begin
      if (en) q <= d;
      stage <= q;
      chosen <= en ? d : q;
      priority_q <= d;
      if (en) priority_q <= q;
    end
  end
  always @(posedge clk) begin
    if (!reset) hidden <= priority_q;
  end
endmodule
