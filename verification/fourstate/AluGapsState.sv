module AluGapsState(input clk,en, input [3:0] a,index,
  output logic [3:0] q, output any_bits);
  wire [1:0][3:0] words={a,q};
  wire [3:0] n=words[index];
  assign any_bits=|q;
  always_ff @(posedge clk) if(en) q<=n;
endmodule
