module AsyncRegister(input clock, reset, enable, d, output reg q, output q_n);
  always @(posedge clock or posedge reset) begin
    if (reset) q <= 1'b0;
    else if (enable) q <= d;
  end
  assign q_n = ~q;
endmodule
