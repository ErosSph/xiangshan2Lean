module GenerateAudit #(parameter N=3, parameter ZERO=0)
  (input [3:0] a, output [3:0] y);
  for (genvar i=0; i<N; i=i+1) begin:g
    wire n;
    assign n=a[i];
  end
  for (genvar j=5; j<ZERO; j++) begin:empty
    reg unsupported_memory[0:1];
  end
  // Static references remain inside this module, across generate scopes.
  assign y={a[3],g[2].n,g[1].n,g[0].n};
endmodule
