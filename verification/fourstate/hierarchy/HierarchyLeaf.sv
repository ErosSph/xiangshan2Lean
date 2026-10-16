module HierarchyLeaf #(parameter integer W=4, parameter integer STYLE=0,
  parameter integer STEP=1)(input clock, reset, en,
  input signed [W-1:0] d, output signed [W-1:0] y);
  localparam integer LG=$clog2(4);
  localparam integer DB=$bits(d);
  for(genvar i=0;i<LG;i=i+1) begin: bank
    logic signed [1:DB] q;
    if(i==0) begin: first_stage
      always_ff @(posedge clock) begin
        if(reset) q<=DB'(1'b0);
        else if(en) q<=d+STEP;
      end
    end else begin: later_stage
      always @(posedge clock) begin
        if(reset) q<=DB'(1'b0);
        else if(en) q<=bank[i-1].q;
      end
    end
  end
  case(STYLE)
    0: begin: direct_path assign y=bank[0].q; end
    1: begin: pipeline_path assign y=bank[1].q; end
    default: begin: inverse_path assign y=~bank[1].q; end
  endcase
  if(0) begin: inactive_memory
    reg unused_memory[0:1];
    initial unused_memory[0]=0;
  end
endmodule
