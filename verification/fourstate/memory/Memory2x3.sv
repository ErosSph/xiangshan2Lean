module Memory2x3(input clk, en, en2, ren,
 input [1:0] addr, addr2, raddr, input [2:0] data, data2, output [2:0] q);
 reg [2:0] Memory[0:1];
 always @(posedge clk) begin
   if (en) Memory[addr] <= data;
   if (en2) Memory[addr2][1:0] <= data2[1:0];
 end
 assign q = ren ? Memory[raddr] : 3'bx;
endmodule
