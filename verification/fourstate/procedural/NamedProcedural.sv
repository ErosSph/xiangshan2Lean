module NamedProcedural(input clk, choose, input [1:0] a,b,
                       output reg [1:0] q,r,s);
  reg [1:0] hidden;
  always @(posedge clk) begin : outer_scope
    automatic logic [1:0] temp = a;
    begin : inner_scope
      automatic logic [1:0] temp = b;
      if (choose) temp = a;
      q <= temp;
      temp = q;
      r <= temp;
    end : inner_scope
    s <= temp;
    hidden <= {temp[0],temp[1]};
    temp = b;
  end : outer_scope
endmodule
