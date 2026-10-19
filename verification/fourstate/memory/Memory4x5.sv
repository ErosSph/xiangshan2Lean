module Memory4x5(input clk, en, en2, ren,
 input [2:0] addr, addr2, raddr, input [4:0] data, data2, output [4:0] q);
 reg [4:0] Memory[0:3];
 always @(posedge clk) begin
   if (en) Memory[addr] <= data;
   if (en2) Memory[addr2][1:0] <= data2[1:0];
 end
 assign q = ren ? Memory[raddr] : 5'bx;
endmodule
