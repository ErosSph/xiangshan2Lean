module ProceduralLocals(input clk, input en, input choose,
  input [1:0] a, input [1:0] b,
  output reg [1:0] q, output reg [1:0] r,
  output reg [1:0] s, output reg [1:0] fresh);
  always @(posedge clk) begin
    automatic logic [1:0] t;
    automatic logic [1:0] scratch;
    fresh <= scratch;
    scratch = a;
    t = q;
    q <= a;
    r <= q;
    t = t ^ b;
    if (en) t = a;
    if (choose) begin
      automatic logic [1:0] t;
      t = b;
      s <= t;
    end else s <= a;
    q <= t;
    t = b;
  end
endmodule
