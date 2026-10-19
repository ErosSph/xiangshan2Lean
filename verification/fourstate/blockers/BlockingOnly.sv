module BlockingOnly(input clock, input d, output reg q);
  reg t;
  always @(posedge clock) begin
    t = d;
    q <= t;
  end
endmodule
