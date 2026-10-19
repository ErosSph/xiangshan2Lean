module NetAliasClockControl(input clock, input d, output reg q);
  wire alias_d = d;
  always @(posedge clock) begin
    q <= alias_d;
  end
endmodule
