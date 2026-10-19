module AssertionOrder(input clk,a,b,check,output reg q,r);
  always @(posedge clk) begin : update
    automatic logic t;
    t = a;
    before_local: assert(t) else $error("local_before");
    t = b;
    assert(t) else $error("local_after");
    q <= a;
    old_state: assert(q) else $error("old_state");
    if (check) begin : branch
      automatic logic inner = t;
      guarded: assert(inner) else $error("guarded");
    end
    r <= q;
  end
endmodule
