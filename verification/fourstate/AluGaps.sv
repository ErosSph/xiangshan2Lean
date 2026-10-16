module AluGaps(input [3:0] a,b, input [3:0] index,
  input signed [3:0] signed_index,
  output [7:0] repeated, output all_bits,any_bits,
  output [3:0] selected,ascending_selected,static_word,connected,
  output [1:0] static_slice, output [64:0] wide_repeated);
  wire [3:0] n=a;
  wire [5:2][3:0] words={a,b,4'bxz01,n};
  wire [2:5][0:3] ascending_words={a,b,4'bxz01,n};
  assign repeated={2{n}};
  assign wide_repeated={65{a[0]}};
  assign all_bits=&a;
  assign any_bits=|a;
  assign selected=words[index];
  assign ascending_selected=ascending_words[signed_index];
  assign static_word=words[5];
  assign static_slice=ascending_words[2][0:1];
  assign connected=n;
endmodule
