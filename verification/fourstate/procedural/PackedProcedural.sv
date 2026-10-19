module PackedProcedural(input clk, en, input [7:0] data,
                        input [2:0] idx, input [1:0] bitidx,
                        output reg [7:0] q, output reg [3:0] reads,
                        output reg [3:0] widths);
  always @(posedge clk) begin : packed_process
    automatic logic [1:0][3:0] down = data;
    automatic logic [0:1][0:3] up = data;
    automatic logic signed [1:0][1:0] signed_temp = data[3:0];
    automatic logic signed [1:0] narrow;
    narrow = signed_temp[1];
    reads <= {down[idx][bitidx], up[idx][bitidx], down[2][0], up[3][1]};
    if (en) down[idx][bitidx] = data[0];
    up[0] = down[1];
    q <= {up[0], down[0]};
    widths <= narrow;
  end : packed_process
endmodule
