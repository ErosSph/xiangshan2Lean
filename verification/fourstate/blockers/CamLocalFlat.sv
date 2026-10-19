module CamLocalFlat(input clock, input d, output reg q);
  always @(posedge clock) begin
    automatic logic t;
    t = d;
    q <= t;
  end
endmodule
