module MaskedMemory(input clock, input [1:0] addr0,addr1,readAddr,
 input en0,en1, input [1:0] mask0,mask1, input [7:0] data0,data1, output [7:0] q);
 reg [7:0] mem[0:3];
 always @(posedge clock) begin
  for(integer j=0;j<2;j=j+1) begin
   if(en0 && mask0[j]) mem[addr0][4*j+:4] <= data0[4*j+:4];
   if(en1 && mask1[j]) mem[addr1][4*j+:4] <= data1[4*j+:4];
  end
 end
 assign q=mem[readAddr]; endmodule