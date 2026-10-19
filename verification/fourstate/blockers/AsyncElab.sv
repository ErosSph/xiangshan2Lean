module AsyncElab(input clock, input reset, input d, output reg q);
  wire alias_d = d;
  always @(posedge clock or posedge reset) begin
    if (reset) q <= 1'b0;
    else q <= alias_d;
  end
endmodule
