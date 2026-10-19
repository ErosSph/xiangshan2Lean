module LocalDeclOnly(input clock, input d, output reg q);
  always @(posedge clock) begin
    logic t;
    q <= t;
  end
endmodule
