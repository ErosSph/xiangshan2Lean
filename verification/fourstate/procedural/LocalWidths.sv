module LocalWidths(input clk, input en, input [1:0] a,
  output reg [3:0] q, output reg [3:0] r);
  always @(posedge clk) begin
    automatic logic signed [1:0] narrow_s;
    automatic logic [3:0] wide;
    automatic logic guard;
    narrow_s = a;
    wide = narrow_s;
    guard = en;
    if (guard) wide = {a, a};
    q <= wide;
    r <= narrow_s;
  end
endmodule
