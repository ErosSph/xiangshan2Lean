module CamLocalElab(input clock, input d, output reg q);
  wire alias_d = d;
  always @(posedge clock) begin
    automatic logic t;
    t = alias_d;
    q <= t;
  end
endmodule
