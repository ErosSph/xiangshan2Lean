module CollisionCell(input clk,d,output logic q);
  always_ff @(posedge clk) q<=d;
endmodule
module CollisionOuter(input clk,d,output y);
  CollisionCell b(clk,d,y);
endmodule
module PathCollision(input clk,d0,d1,output y0,y1);
  CollisionOuter a(clk,d0,y0);
  CollisionCell a_b(clk,d1,y1);
endmodule
