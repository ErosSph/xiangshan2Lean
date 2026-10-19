module MemoryNBA(input clk,en,en2,input signed [1:0] a,input [2:0] d,
                 output [2:0] q0,q1,qa);
  reg [2:0] m[0:1];
  always @(posedge clk) begin
    if (en) begin
      m[0] <= d;
      m[1] <= m[0];
    end
    if (en2) m[0] <= m[1];
  end
  assign q0=m[0];
  assign q1=m[1];
  assign qa=m[a];
endmodule
