module LogicState(input clk, input a, b,
  output logic procedural, exact, output logic merged);
  always_ff @(posedge clk) begin
    if (a == b) procedural <= 1'b1;
    else procedural <= 1'b0;
    if (a === b) exact <= 1'b1;
    else exact <= 1'b0;
    merged <= (a == b) ? a : b;
  end
endmodule
