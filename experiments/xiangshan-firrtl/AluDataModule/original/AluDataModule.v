module LeftShiftModule(
  input  [5:0]  io_shamt,
  input  [5:0]  io_revShamt,
  input  [63:0] io_sllSrc,
  output [63:0] io_sll,
  output [63:0] io_revSll
);
  wire [126:0] _GEN_0 = {{63'd0}, io_sllSrc}; // @[Alu.scala 53:23]
  wire [126:0] _io_sll_T = _GEN_0 << io_shamt; // @[Alu.scala 53:23]
  wire [126:0] _GEN_1 = {{63'd0}, io_sllSrc}; // @[Alu.scala 54:26]
  wire [126:0] _io_revSll_T = _GEN_1 << io_revShamt; // @[Alu.scala 54:26]
  assign io_sll = _io_sll_T[63:0]; // @[Alu.scala 53:10]
  assign io_revSll = _io_revSll_T[63:0]; // @[Alu.scala 54:13]
endmodule
module RightShiftModule(
  input  [5:0]  io_shamt,
  input  [5:0]  io_revShamt,
  input  [63:0] io_srlSrc,
  input  [63:0] io_sraSrc,
  output [63:0] io_srl,
  output [63:0] io_sra,
  output [63:0] io_revSrl
);
  assign io_srl = io_srlSrc >> io_shamt; // @[Alu.scala 77:24]
  assign io_sra = $signed(io_sraSrc) >>> io_shamt; // @[Alu.scala 78:53]
  assign io_revSrl = io_srlSrc >> io_revShamt; // @[Alu.scala 79:27]
endmodule
module AddModule(
  input  [63:0] io_src_0,
  input  [63:0] io_src_1,
  input  [31:0] io_srcw,
  output [63:0] io_add,
  output [31:0] io_addw
);
  assign io_add = io_src_0 + io_src_1; // @[Alu.scala 32:23]
  assign io_addw = io_srcw + io_src_1[31:0]; // @[Alu.scala 34:22]
endmodule
module SubModule(
  input  [63:0] io_src_0,
  input  [63:0] io_src_1,
  output [64:0] io_sub
);
  wire [63:0] _io_sub_T = ~io_src_1; // @[Alu.scala 42:28]
  wire [64:0] _io_sub_T_1 = io_src_0 + _io_sub_T; // @[Alu.scala 42:24]
  assign io_sub = _io_sub_T_1 + 65'h1; // @[Alu.scala 42:50]
endmodule
module LeftShiftWordModule(
  input  [4:0]  io_shamt,
  input  [4:0]  io_revShamt,
  input  [31:0] io_sllSrc,
  output [31:0] io_sllw,
  output [31:0] io_revSllw
);
  wire [62:0] _GEN_0 = {{31'd0}, io_sllSrc}; // @[Alu.scala 65:24]
  wire [62:0] _io_sllw_T = _GEN_0 << io_shamt; // @[Alu.scala 65:24]
  wire [62:0] _GEN_1 = {{31'd0}, io_sllSrc}; // @[Alu.scala 66:27]
  wire [62:0] _io_revSllw_T = _GEN_1 << io_revShamt; // @[Alu.scala 66:27]
  assign io_sllw = _io_sllw_T[31:0]; // @[Alu.scala 65:11]
  assign io_revSllw = _io_revSllw_T[31:0]; // @[Alu.scala 66:14]
endmodule
module RightShiftWordModule(
  input  [4:0]  io_shamt,
  input  [4:0]  io_revShamt,
  input  [31:0] io_srlSrc,
  input  [31:0] io_sraSrc,
  output [31:0] io_srlw,
  output [31:0] io_sraw,
  output [31:0] io_revSrlw
);
  assign io_srlw = io_srlSrc >> io_shamt; // @[Alu.scala 91:24]
  assign io_sraw = $signed(io_sraSrc) >>> io_shamt; // @[Alu.scala 92:53]
  assign io_revSrlw = io_srlSrc >> io_revShamt; // @[Alu.scala 93:27]
endmodule
module ShiftResultSelect(
  input  [3:0]  io_func,
  input  [63:0] io_sll,
  input  [63:0] io_srl,
  input  [63:0] io_sra,
  input  [63:0] io_rol,
  input  [63:0] io_ror,
  input  [63:0] io_bclr,
  input  [63:0] io_bset,
  input  [63:0] io_binv,
  input  [63:0] io_bext,
  output [63:0] io_shiftRes
);
  wire [63:0] _io_shiftRes_T_2 = io_func[1] ? io_ror : io_rol; // @[Alu.scala 150:37]
  wire [63:0] _GEN_2 = 3'h2 == io_func[2:0] ? io_bclr : io_sll; // @[Alu.scala 150:{21,21}]
  wire [63:0] _GEN_3 = 3'h3 == io_func[2:0] ? io_bset : _GEN_2; // @[Alu.scala 150:{21,21}]
  wire [63:0] _GEN_4 = 3'h4 == io_func[2:0] ? io_binv : _GEN_3; // @[Alu.scala 150:{21,21}]
  wire [63:0] _GEN_5 = 3'h5 == io_func[2:0] ? io_srl : _GEN_4; // @[Alu.scala 150:{21,21}]
  wire [63:0] _GEN_6 = 3'h6 == io_func[2:0] ? io_bext : _GEN_5; // @[Alu.scala 150:{21,21}]
  wire [63:0] _GEN_7 = 3'h7 == io_func[2:0] ? io_sra : _GEN_6; // @[Alu.scala 150:{21,21}]
  assign io_shiftRes = io_func[3] ? _io_shiftRes_T_2 : _GEN_7; // @[Alu.scala 150:21]
endmodule
module MiscResultSelect(
  input  [5:0]  io_func,
  input  [63:0] io_and,
  input  [63:0] io_or,
  input  [63:0] io_xor,
  input  [63:0] io_orcb,
  input  [63:0] io_orh48,
  input  [63:0] io_sextb,
  input  [63:0] io_packh,
  input  [63:0] io_sexth,
  input  [63:0] io_packw,
  input  [63:0] io_revb,
  input  [63:0] io_rev8,
  input  [63:0] io_pack,
  input  [63:0] io_src,
  output [63:0] io_miscRes
);
  wire [63:0] _GEN_1 = 2'h1 == io_func[1:0] ? io_packh : io_sextb; // @[Alu.scala 112:{22,22}]
  wire [63:0] _GEN_2 = 2'h2 == io_func[1:0] ? io_sexth : _GEN_1; // @[Alu.scala 112:{22,22}]
  wire [63:0] _GEN_3 = 2'h3 == io_func[1:0] ? io_packw : _GEN_2; // @[Alu.scala 112:{22,22}]
  wire [63:0] _GEN_5 = 2'h1 == io_func[2:1] ? io_or : io_and; // @[Alu.scala 112:{22,22}]
  wire [63:0] _GEN_6 = 2'h2 == io_func[2:1] ? io_xor : _GEN_5; // @[Alu.scala 112:{22,22}]
  wire [63:0] _GEN_7 = 2'h3 == io_func[2:1] ? io_orcb : _GEN_6; // @[Alu.scala 112:{22,22}]
  wire [63:0] logicBase = io_func[3] ? _GEN_3 : _GEN_7; // @[Alu.scala 112:22]
  wire [63:0] _customRes_T_1 = {31'h0,io_src[31:0],1'h0}; // @[Cat.scala 31:58]
  wire [63:0] _customRes_T_3 = {30'h0,io_src[31:0],2'h0}; // @[Cat.scala 31:58]
  wire [63:0] _customRes_T_5 = {29'h0,io_src[31:0],3'h0}; // @[Cat.scala 31:58]
  wire [63:0] _customRes_T_7 = {56'h0,io_src[15:8]}; // @[Cat.scala 31:58]
  wire [63:0] _GEN_9 = 2'h1 == io_func[1:0] ? _customRes_T_3 : _customRes_T_1; // @[Alu.scala 120:{21,21}]
  wire [63:0] _GEN_10 = 2'h2 == io_func[1:0] ? _customRes_T_5 : _GEN_9; // @[Alu.scala 120:{21,21}]
  wire [63:0] _GEN_11 = 2'h3 == io_func[1:0] ? _customRes_T_7 : _GEN_10; // @[Alu.scala 120:{21,21}]
  wire [63:0] _GEN_13 = 2'h1 == io_func[1:0] ? io_rev8 : io_revb; // @[Alu.scala 120:{21,21}]
  wire [63:0] _GEN_14 = 2'h2 == io_func[1:0] ? io_pack : _GEN_13; // @[Alu.scala 120:{21,21}]
  wire [63:0] _GEN_15 = 2'h3 == io_func[1:0] ? io_orh48 : _GEN_14; // @[Alu.scala 120:{21,21}]
  wire [63:0] logicAdv = io_func[3] ? _GEN_11 : _GEN_15; // @[Alu.scala 120:21]
  wire [14:0] _mask_T_2 = io_func[0] ? 15'h7fff : 15'h0; // @[Bitwise.scala 74:12]
  wire [15:0] mask = {_mask_T_2,1'h1}; // @[Cat.scala 31:58]
  wire [63:0] _GEN_16 = {{48'd0}, mask}; // @[Alu.scala 123:29]
  wire [63:0] maskedLogicRes = _GEN_16 & _GEN_7; // @[Alu.scala 123:29]
  wire [63:0] _io_miscRes_T_2 = io_func[4] ? logicAdv : logicBase; // @[Alu.scala 125:52]
  assign io_miscRes = io_func[5] ? maskedLogicRes : _io_miscRes_T_2; // @[Alu.scala 125:20]
endmodule
module WordResultSelect(
  input  [6:0]  io_func,
  input  [31:0] io_sllw,
  input  [31:0] io_srlw,
  input  [31:0] io_sraw,
  input  [31:0] io_rolw,
  input  [31:0] io_rorw,
  input  [31:0] io_addw,
  input  [31:0] io_subw,
  output [63:0] io_wordRes
);
  wire [31:0] addsubRes = ~io_func[2] & io_func[1] ? io_subw : io_addw; // @[Alu.scala 160:22]
  wire [31:0] _shiftRes_T_2 = io_func[0] ? io_rorw : io_rolw; // @[Alu.scala 161:37]
  wire [31:0] _shiftRes_T_5 = io_func[0] ? io_srlw : io_sllw; // @[Alu.scala 162:47]
  wire [31:0] _shiftRes_T_6 = io_func[1] ? io_sraw : _shiftRes_T_5; // @[Alu.scala 162:22]
  wire [31:0] shiftRes = io_func[2] ? _shiftRes_T_2 : _shiftRes_T_6; // @[Alu.scala 161:21]
  wire [31:0] wordRes = io_func[3] ? shiftRes : addsubRes; // @[Alu.scala 163:20]
  wire  io_wordRes_signBit = wordRes[31]; // @[BitUtils.scala 80:20]
  wire [31:0] _io_wordRes_T_1 = io_wordRes_signBit ? 32'hffffffff : 32'h0; // @[Bitwise.scala 74:12]
  assign io_wordRes = {_io_wordRes_T_1,wordRes}; // @[Cat.scala 31:58]
endmodule
module AluResSel(
  input  [2:0]  io_func,
  input  [63:0] io_addRes,
  input  [63:0] io_shiftRes,
  input  [63:0] io_miscRes,
  input  [63:0] io_compareRes,
  input  [63:0] io_wordRes,
  output [63:0] io_aluRes
);
  wire [63:0] _res_T_3 = io_func[0] ? io_wordRes : io_shiftRes; // @[Alu.scala 175:43]
  wire [63:0] _res_T_7 = io_func[0] ? io_compareRes : io_addRes; // @[Alu.scala 176:33]
  wire [63:0] _res_T_8 = ~io_func[2] ? _res_T_7 : io_miscRes; // @[Alu.scala 176:16]
  assign io_aluRes = io_func[2:1] == 2'h0 ? _res_T_3 : _res_T_8; // @[Alu.scala 175:16]
endmodule
module AluDataModule(
  input         clock,
  input         reset,
  input  [63:0] io_src_0,
  input  [63:0] io_src_1,
  input  [6:0]  io_func,
  input         io_pred_taken,
  input         io_isBranch,
  output [63:0] io_result,
  output        io_taken,
  output        io_mispredict
);
  wire [5:0] leftShiftModule_io_shamt; // @[Alu.scala 194:31]
  wire [5:0] leftShiftModule_io_revShamt; // @[Alu.scala 194:31]
  wire [63:0] leftShiftModule_io_sllSrc; // @[Alu.scala 194:31]
  wire [63:0] leftShiftModule_io_sll; // @[Alu.scala 194:31]
  wire [63:0] leftShiftModule_io_revSll; // @[Alu.scala 194:31]
  wire [5:0] rightShiftModule_io_shamt; // @[Alu.scala 208:32]
  wire [5:0] rightShiftModule_io_revShamt; // @[Alu.scala 208:32]
  wire [63:0] rightShiftModule_io_srlSrc; // @[Alu.scala 208:32]
  wire [63:0] rightShiftModule_io_sraSrc; // @[Alu.scala 208:32]
  wire [63:0] rightShiftModule_io_srl; // @[Alu.scala 208:32]
  wire [63:0] rightShiftModule_io_sra; // @[Alu.scala 208:32]
  wire [63:0] rightShiftModule_io_revSrl; // @[Alu.scala 208:32]
  wire [63:0] addModule_io_src_0; // @[Alu.scala 222:25]
  wire [63:0] addModule_io_src_1; // @[Alu.scala 222:25]
  wire [31:0] addModule_io_srcw; // @[Alu.scala 222:25]
  wire [63:0] addModule_io_add; // @[Alu.scala 222:25]
  wire [31:0] addModule_io_addw; // @[Alu.scala 222:25]
  wire [63:0] subModule_io_src_0; // @[Alu.scala 233:25]
  wire [63:0] subModule_io_src_1; // @[Alu.scala 233:25]
  wire [64:0] subModule_io_sub; // @[Alu.scala 233:25]
  wire [4:0] leftShiftWordModule_io_shamt; // @[Alu.scala 237:35]
  wire [4:0] leftShiftWordModule_io_revShamt; // @[Alu.scala 237:35]
  wire [31:0] leftShiftWordModule_io_sllSrc; // @[Alu.scala 237:35]
  wire [31:0] leftShiftWordModule_io_sllw; // @[Alu.scala 237:35]
  wire [31:0] leftShiftWordModule_io_revSllw; // @[Alu.scala 237:35]
  wire [4:0] rightShiftWordModule_io_shamt; // @[Alu.scala 244:36]
  wire [4:0] rightShiftWordModule_io_revShamt; // @[Alu.scala 244:36]
  wire [31:0] rightShiftWordModule_io_srlSrc; // @[Alu.scala 244:36]
  wire [31:0] rightShiftWordModule_io_sraSrc; // @[Alu.scala 244:36]
  wire [31:0] rightShiftWordModule_io_srlw; // @[Alu.scala 244:36]
  wire [31:0] rightShiftWordModule_io_sraw; // @[Alu.scala 244:36]
  wire [31:0] rightShiftWordModule_io_revSrlw; // @[Alu.scala 244:36]
  wire [3:0] shiftResSel_io_func; // @[Alu.scala 315:27]
  wire [63:0] shiftResSel_io_sll; // @[Alu.scala 315:27]
  wire [63:0] shiftResSel_io_srl; // @[Alu.scala 315:27]
  wire [63:0] shiftResSel_io_sra; // @[Alu.scala 315:27]
  wire [63:0] shiftResSel_io_rol; // @[Alu.scala 315:27]
  wire [63:0] shiftResSel_io_ror; // @[Alu.scala 315:27]
  wire [63:0] shiftResSel_io_bclr; // @[Alu.scala 315:27]
  wire [63:0] shiftResSel_io_bset; // @[Alu.scala 315:27]
  wire [63:0] shiftResSel_io_binv; // @[Alu.scala 315:27]
  wire [63:0] shiftResSel_io_bext; // @[Alu.scala 315:27]
  wire [63:0] shiftResSel_io_shiftRes; // @[Alu.scala 315:27]
  wire [5:0] miscResSel_io_func; // @[Alu.scala 328:26]
  wire [63:0] miscResSel_io_and; // @[Alu.scala 328:26]
  wire [63:0] miscResSel_io_or; // @[Alu.scala 328:26]
  wire [63:0] miscResSel_io_xor; // @[Alu.scala 328:26]
  wire [63:0] miscResSel_io_orcb; // @[Alu.scala 328:26]
  wire [63:0] miscResSel_io_orh48; // @[Alu.scala 328:26]
  wire [63:0] miscResSel_io_sextb; // @[Alu.scala 328:26]
  wire [63:0] miscResSel_io_packh; // @[Alu.scala 328:26]
  wire [63:0] miscResSel_io_sexth; // @[Alu.scala 328:26]
  wire [63:0] miscResSel_io_packw; // @[Alu.scala 328:26]
  wire [63:0] miscResSel_io_revb; // @[Alu.scala 328:26]
  wire [63:0] miscResSel_io_rev8; // @[Alu.scala 328:26]
  wire [63:0] miscResSel_io_pack; // @[Alu.scala 328:26]
  wire [63:0] miscResSel_io_src; // @[Alu.scala 328:26]
  wire [63:0] miscResSel_io_miscRes; // @[Alu.scala 328:26]
  wire [6:0] wordResSel_io_func; // @[Alu.scala 345:26]
  wire [31:0] wordResSel_io_sllw; // @[Alu.scala 345:26]
  wire [31:0] wordResSel_io_srlw; // @[Alu.scala 345:26]
  wire [31:0] wordResSel_io_sraw; // @[Alu.scala 345:26]
  wire [31:0] wordResSel_io_rolw; // @[Alu.scala 345:26]
  wire [31:0] wordResSel_io_rorw; // @[Alu.scala 345:26]
  wire [31:0] wordResSel_io_addw; // @[Alu.scala 345:26]
  wire [31:0] wordResSel_io_subw; // @[Alu.scala 345:26]
  wire [63:0] wordResSel_io_wordRes; // @[Alu.scala 345:26]
  wire [2:0] aluResSel_io_func; // @[Alu.scala 356:25]
  wire [63:0] aluResSel_io_addRes; // @[Alu.scala 356:25]
  wire [63:0] aluResSel_io_shiftRes; // @[Alu.scala 356:25]
  wire [63:0] aluResSel_io_miscRes; // @[Alu.scala 356:25]
  wire [63:0] aluResSel_io_compareRes; // @[Alu.scala 356:25]
  wire [63:0] aluResSel_io_wordRes; // @[Alu.scala 356:25]
  wire [63:0] aluResSel_io_aluRes; // @[Alu.scala 356:25]
  wire [5:0] shamt = io_src_1[5:0]; // @[Alu.scala 190:19]
  wire [5:0] _revShamt_T_1 = ~shamt; // @[Alu.scala 191:18]
  wire [5:0] revShamt = _revShamt_T_1 + 6'h1; // @[Alu.scala 191:29]
  wire [31:0] _leftShiftModule_io_sllSrc_T_2 = io_func[0] ? 32'hffffffff : 32'h0; // @[Bitwise.scala 74:12]
  wire [63:0] _leftShiftModule_io_sllSrc_T_4 = {_leftShiftModule_io_sllSrc_T_2,32'hffffffff}; // @[Cat.scala 31:58]
  wire [63:0] _leftShiftModule_io_sllSrc_T_5 = _leftShiftModule_io_sllSrc_T_4 & io_src_0; // @[Alu.scala 197:70]
  wire [63:0] bitShift = 64'h1 << shamt; // @[Alu.scala 202:22]
  wire [63:0] _bclr_T = ~bitShift; // @[Alu.scala 203:21]
  wire  bext = rightShiftModule_io_srl[0]; // @[Alu.scala 216:17]
  wire [63:0] _addModule_io_srcw_T_5 = {63'h0,io_src_0[0]}; // @[Cat.scala 31:58]
  wire [63:0] _addModule_io_srcw_T_7 = ~io_func[2] & io_func[0] ? _addModule_io_srcw_T_5 : {{32'd0}, io_src_0[31:0]}; // @[Alu.scala 223:27]
  wire [63:0] addwResultAll_0 = {63'h0,addModule_io_addw[0]}; // @[Cat.scala 31:58]
  wire [63:0] addwResultAll_1 = {56'h0,addModule_io_addw[7:0]}; // @[Cat.scala 31:58]
  wire [63:0] addwResultAll_2 = {48'h0,addModule_io_addw[15:0]}; // @[Cat.scala 31:58]
  wire  addwResultAll_signBit = addModule_io_addw[15]; // @[BitUtils.scala 80:20]
  wire [47:0] _addwResultAll_T_8 = addwResultAll_signBit ? 48'hffffffffffff : 48'h0; // @[Bitwise.scala 74:12]
  wire [63:0] addwResultAll_3 = {_addwResultAll_T_8,addModule_io_addw[15:0]}; // @[Cat.scala 31:58]
  wire [63:0] _GEN_1 = 2'h1 == io_func[1:0] ? addwResultAll_1 : addwResultAll_0; // @[Alu.scala 230:{17,17}]
  wire [63:0] _GEN_2 = 2'h2 == io_func[1:0] ? addwResultAll_2 : _GEN_1; // @[Alu.scala 230:{17,17}]
  wire [63:0] _GEN_3 = 2'h3 == io_func[1:0] ? addwResultAll_3 : _GEN_2; // @[Alu.scala 230:{17,17}]
  wire [63:0] addw = io_func[2] ? _GEN_3 : {{32'd0}, addModule_io_addw}; // @[Alu.scala 230:17]
  wire [63:0] shaddSource_0 = {_leftShiftModule_io_sllSrc_T_5[62:0],1'h0}; // @[Cat.scala 31:58]
  wire [63:0] shaddSource_1 = {_leftShiftModule_io_sllSrc_T_5[61:0],2'h0}; // @[Cat.scala 31:58]
  wire [63:0] shaddSource_2 = {_leftShiftModule_io_sllSrc_T_5[60:0],3'h0}; // @[Cat.scala 31:58]
  wire [63:0] shaddSource_3 = {_leftShiftModule_io_sllSrc_T_5[59:0],4'h0}; // @[Cat.scala 31:58]
  wire [63:0] sraddSource_0 = {29'h0,io_src_0[63:29]}; // @[Cat.scala 31:58]
  wire [63:0] sraddSource_1 = {30'h0,io_src_0[63:30]}; // @[Cat.scala 31:58]
  wire [63:0] sraddSource_2 = {31'h0,io_src_0[63:31]}; // @[Cat.scala 31:58]
  wire [63:0] sraddSource_3 = {32'h0,io_src_0[63:32]}; // @[Cat.scala 31:58]
  wire [63:0] _addModule_io_src_0_T_7 = io_func[1] ? _addModule_io_srcw_T_5 : _leftShiftModule_io_sllSrc_T_5; // @[Alu.scala 274:8]
  wire [63:0] _GEN_5 = 2'h1 == io_func[1:0] ? sraddSource_1 : sraddSource_0; // @[Alu.scala 273:{8,8}]
  wire [63:0] _GEN_6 = 2'h2 == io_func[1:0] ? sraddSource_2 : _GEN_5; // @[Alu.scala 273:{8,8}]
  wire [63:0] _GEN_7 = 2'h3 == io_func[1:0] ? sraddSource_3 : _GEN_6; // @[Alu.scala 273:{8,8}]
  wire [63:0] _addModule_io_src_0_T_8 = io_func[2] ? _GEN_7 : _addModule_io_src_0_T_7; // @[Alu.scala 273:8]
  wire [63:0] _GEN_9 = 2'h1 == io_func[2:1] ? shaddSource_1 : shaddSource_0; // @[Alu.scala 272:{29,29}]
  wire [63:0] _GEN_10 = 2'h2 == io_func[2:1] ? shaddSource_2 : _GEN_9; // @[Alu.scala 272:{29,29}]
  wire [63:0] _GEN_11 = 2'h3 == io_func[2:1] ? shaddSource_3 : _GEN_10; // @[Alu.scala 272:{29,29}]
  wire  sltu = ~subModule_io_sub[64]; // @[Alu.scala 283:17]
  wire  slt = io_src_0[63] ^ io_src_1[63] ^ sltu; // @[Alu.scala 284:49]
  wire [63:0] maxMin = slt ^ io_func[0] ? io_src_1 : io_src_0; // @[Alu.scala 285:20]
  wire [63:0] maxMinU = sltu ^ io_func[0] ? io_src_1 : io_src_0; // @[Alu.scala 286:20]
  wire [63:0] _compareRes_T_2 = io_func[1] ? maxMin : maxMinU; // @[Alu.scala 287:36]
  wire [64:0] _compareRes_T_5 = io_func[0] ? {{64'd0}, sltu} : subModule_io_sub; // @[Alu.scala 287:85]
  wire [64:0] _compareRes_T_6 = io_func[1] ? {{64'd0}, slt} : _compareRes_T_5; // @[Alu.scala 287:67]
  wire [64:0] compareRes = io_func[2] ? {{1'd0}, _compareRes_T_2} : _compareRes_T_6; // @[Alu.scala 287:23]
  wire [63:0] _logicSrc2_T_4 = ~io_src_1; // @[Alu.scala 290:44]
  wire [63:0] logicSrc2 = ~io_func[5] & io_func[0] ? _logicSrc2_T_4 : io_src_1; // @[Alu.scala 290:22]
  wire [63:0] xor_ = io_src_0 ^ logicSrc2; // @[Alu.scala 293:22]
  wire  _orcb_T_1 = |io_src_0[7:0]; // @[Alu.scala 294:73]
  wire [7:0] _orcb_T_3 = _orcb_T_1 ? 8'hff : 8'h0; // @[Bitwise.scala 74:12]
  wire  _orcb_T_5 = |io_src_0[15:8]; // @[Alu.scala 294:73]
  wire [7:0] _orcb_T_7 = _orcb_T_5 ? 8'hff : 8'h0; // @[Bitwise.scala 74:12]
  wire  _orcb_T_9 = |io_src_0[23:16]; // @[Alu.scala 294:73]
  wire [7:0] _orcb_T_11 = _orcb_T_9 ? 8'hff : 8'h0; // @[Bitwise.scala 74:12]
  wire  _orcb_T_13 = |io_src_0[31:24]; // @[Alu.scala 294:73]
  wire [7:0] _orcb_T_15 = _orcb_T_13 ? 8'hff : 8'h0; // @[Bitwise.scala 74:12]
  wire  _orcb_T_17 = |io_src_0[39:32]; // @[Alu.scala 294:73]
  wire [7:0] _orcb_T_19 = _orcb_T_17 ? 8'hff : 8'h0; // @[Bitwise.scala 74:12]
  wire  _orcb_T_21 = |io_src_0[47:40]; // @[Alu.scala 294:73]
  wire [7:0] _orcb_T_23 = _orcb_T_21 ? 8'hff : 8'h0; // @[Bitwise.scala 74:12]
  wire  _orcb_T_25 = |io_src_0[55:48]; // @[Alu.scala 294:73]
  wire [7:0] _orcb_T_27 = _orcb_T_25 ? 8'hff : 8'h0; // @[Bitwise.scala 74:12]
  wire  _orcb_T_29 = |io_src_0[63:56]; // @[Alu.scala 294:73]
  wire [7:0] _orcb_T_31 = _orcb_T_29 ? 8'hff : 8'h0; // @[Bitwise.scala 74:12]
  wire [31:0] orcb_lo = {_orcb_T_15,_orcb_T_11,_orcb_T_7,_orcb_T_3}; // @[Cat.scala 31:58]
  wire [31:0] orcb_hi = {_orcb_T_31,_orcb_T_27,_orcb_T_23,_orcb_T_19}; // @[Cat.scala 31:58]
  wire [63:0] _orh48_T_1 = {io_src_0[63:8],8'h0}; // @[Cat.scala 31:58]
  wire  sextb_signBit = io_src_0[7]; // @[BitUtils.scala 80:20]
  wire [55:0] _sextb_T_2 = sextb_signBit ? 56'hffffffffffffff : 56'h0; // @[Bitwise.scala 74:12]
  wire [15:0] packh = {io_src_1[7:0],io_src_0[7:0]}; // @[Cat.scala 31:58]
  wire  sexth_signBit = io_src_0[15]; // @[BitUtils.scala 80:20]
  wire [47:0] _sexth_T_2 = sexth_signBit ? 48'hffffffffffff : 48'h0; // @[Bitwise.scala 74:12]
  wire [31:0] _packw_T_2 = {io_src_1[15:0],io_src_0[15:0]}; // @[Cat.scala 31:58]
  wire  packw_signBit = _packw_T_2[31]; // @[BitUtils.scala 80:20]
  wire [31:0] _packw_T_4 = packw_signBit ? 32'hffffffff : 32'h0; // @[Bitwise.scala 74:12]
  wire [7:0] _GEN_12 = {{4'd0}, io_src_0[7:4]}; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_4 = _GEN_12 & 8'hf; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_6 = {io_src_0[3:0], 4'h0}; // @[Bitwise.scala 105:70]
  wire [7:0] _revb_T_8 = _revb_T_6 & 8'hf0; // @[Bitwise.scala 105:80]
  wire [7:0] _revb_T_9 = _revb_T_4 | _revb_T_8; // @[Bitwise.scala 105:39]
  wire [7:0] _GEN_13 = {{2'd0}, _revb_T_9[7:2]}; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_14 = _GEN_13 & 8'h33; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_16 = {_revb_T_9[5:0], 2'h0}; // @[Bitwise.scala 105:70]
  wire [7:0] _revb_T_18 = _revb_T_16 & 8'hcc; // @[Bitwise.scala 105:80]
  wire [7:0] _revb_T_19 = _revb_T_14 | _revb_T_18; // @[Bitwise.scala 105:39]
  wire [7:0] _GEN_14 = {{1'd0}, _revb_T_19[7:1]}; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_24 = _GEN_14 & 8'h55; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_26 = {_revb_T_19[6:0], 1'h0}; // @[Bitwise.scala 105:70]
  wire [7:0] _revb_T_28 = _revb_T_26 & 8'haa; // @[Bitwise.scala 105:80]
  wire [7:0] _revb_T_29 = _revb_T_24 | _revb_T_28; // @[Bitwise.scala 105:39]
  wire [7:0] _GEN_15 = {{4'd0}, io_src_0[15:12]}; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_34 = _GEN_15 & 8'hf; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_36 = {io_src_0[11:8], 4'h0}; // @[Bitwise.scala 105:70]
  wire [7:0] _revb_T_38 = _revb_T_36 & 8'hf0; // @[Bitwise.scala 105:80]
  wire [7:0] _revb_T_39 = _revb_T_34 | _revb_T_38; // @[Bitwise.scala 105:39]
  wire [7:0] _GEN_16 = {{2'd0}, _revb_T_39[7:2]}; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_44 = _GEN_16 & 8'h33; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_46 = {_revb_T_39[5:0], 2'h0}; // @[Bitwise.scala 105:70]
  wire [7:0] _revb_T_48 = _revb_T_46 & 8'hcc; // @[Bitwise.scala 105:80]
  wire [7:0] _revb_T_49 = _revb_T_44 | _revb_T_48; // @[Bitwise.scala 105:39]
  wire [7:0] _GEN_17 = {{1'd0}, _revb_T_49[7:1]}; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_54 = _GEN_17 & 8'h55; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_56 = {_revb_T_49[6:0], 1'h0}; // @[Bitwise.scala 105:70]
  wire [7:0] _revb_T_58 = _revb_T_56 & 8'haa; // @[Bitwise.scala 105:80]
  wire [7:0] _revb_T_59 = _revb_T_54 | _revb_T_58; // @[Bitwise.scala 105:39]
  wire [7:0] _GEN_18 = {{4'd0}, io_src_0[23:20]}; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_64 = _GEN_18 & 8'hf; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_66 = {io_src_0[19:16], 4'h0}; // @[Bitwise.scala 105:70]
  wire [7:0] _revb_T_68 = _revb_T_66 & 8'hf0; // @[Bitwise.scala 105:80]
  wire [7:0] _revb_T_69 = _revb_T_64 | _revb_T_68; // @[Bitwise.scala 105:39]
  wire [7:0] _GEN_19 = {{2'd0}, _revb_T_69[7:2]}; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_74 = _GEN_19 & 8'h33; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_76 = {_revb_T_69[5:0], 2'h0}; // @[Bitwise.scala 105:70]
  wire [7:0] _revb_T_78 = _revb_T_76 & 8'hcc; // @[Bitwise.scala 105:80]
  wire [7:0] _revb_T_79 = _revb_T_74 | _revb_T_78; // @[Bitwise.scala 105:39]
  wire [7:0] _GEN_20 = {{1'd0}, _revb_T_79[7:1]}; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_84 = _GEN_20 & 8'h55; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_86 = {_revb_T_79[6:0], 1'h0}; // @[Bitwise.scala 105:70]
  wire [7:0] _revb_T_88 = _revb_T_86 & 8'haa; // @[Bitwise.scala 105:80]
  wire [7:0] _revb_T_89 = _revb_T_84 | _revb_T_88; // @[Bitwise.scala 105:39]
  wire [7:0] _GEN_21 = {{4'd0}, io_src_0[31:28]}; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_94 = _GEN_21 & 8'hf; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_96 = {io_src_0[27:24], 4'h0}; // @[Bitwise.scala 105:70]
  wire [7:0] _revb_T_98 = _revb_T_96 & 8'hf0; // @[Bitwise.scala 105:80]
  wire [7:0] _revb_T_99 = _revb_T_94 | _revb_T_98; // @[Bitwise.scala 105:39]
  wire [7:0] _GEN_22 = {{2'd0}, _revb_T_99[7:2]}; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_104 = _GEN_22 & 8'h33; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_106 = {_revb_T_99[5:0], 2'h0}; // @[Bitwise.scala 105:70]
  wire [7:0] _revb_T_108 = _revb_T_106 & 8'hcc; // @[Bitwise.scala 105:80]
  wire [7:0] _revb_T_109 = _revb_T_104 | _revb_T_108; // @[Bitwise.scala 105:39]
  wire [7:0] _GEN_23 = {{1'd0}, _revb_T_109[7:1]}; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_114 = _GEN_23 & 8'h55; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_116 = {_revb_T_109[6:0], 1'h0}; // @[Bitwise.scala 105:70]
  wire [7:0] _revb_T_118 = _revb_T_116 & 8'haa; // @[Bitwise.scala 105:80]
  wire [7:0] _revb_T_119 = _revb_T_114 | _revb_T_118; // @[Bitwise.scala 105:39]
  wire [7:0] _GEN_24 = {{4'd0}, io_src_0[39:36]}; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_124 = _GEN_24 & 8'hf; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_126 = {io_src_0[35:32], 4'h0}; // @[Bitwise.scala 105:70]
  wire [7:0] _revb_T_128 = _revb_T_126 & 8'hf0; // @[Bitwise.scala 105:80]
  wire [7:0] _revb_T_129 = _revb_T_124 | _revb_T_128; // @[Bitwise.scala 105:39]
  wire [7:0] _GEN_25 = {{2'd0}, _revb_T_129[7:2]}; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_134 = _GEN_25 & 8'h33; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_136 = {_revb_T_129[5:0], 2'h0}; // @[Bitwise.scala 105:70]
  wire [7:0] _revb_T_138 = _revb_T_136 & 8'hcc; // @[Bitwise.scala 105:80]
  wire [7:0] _revb_T_139 = _revb_T_134 | _revb_T_138; // @[Bitwise.scala 105:39]
  wire [7:0] _GEN_26 = {{1'd0}, _revb_T_139[7:1]}; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_144 = _GEN_26 & 8'h55; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_146 = {_revb_T_139[6:0], 1'h0}; // @[Bitwise.scala 105:70]
  wire [7:0] _revb_T_148 = _revb_T_146 & 8'haa; // @[Bitwise.scala 105:80]
  wire [7:0] _revb_T_149 = _revb_T_144 | _revb_T_148; // @[Bitwise.scala 105:39]
  wire [7:0] _GEN_27 = {{4'd0}, io_src_0[47:44]}; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_154 = _GEN_27 & 8'hf; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_156 = {io_src_0[43:40], 4'h0}; // @[Bitwise.scala 105:70]
  wire [7:0] _revb_T_158 = _revb_T_156 & 8'hf0; // @[Bitwise.scala 105:80]
  wire [7:0] _revb_T_159 = _revb_T_154 | _revb_T_158; // @[Bitwise.scala 105:39]
  wire [7:0] _GEN_28 = {{2'd0}, _revb_T_159[7:2]}; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_164 = _GEN_28 & 8'h33; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_166 = {_revb_T_159[5:0], 2'h0}; // @[Bitwise.scala 105:70]
  wire [7:0] _revb_T_168 = _revb_T_166 & 8'hcc; // @[Bitwise.scala 105:80]
  wire [7:0] _revb_T_169 = _revb_T_164 | _revb_T_168; // @[Bitwise.scala 105:39]
  wire [7:0] _GEN_29 = {{1'd0}, _revb_T_169[7:1]}; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_174 = _GEN_29 & 8'h55; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_176 = {_revb_T_169[6:0], 1'h0}; // @[Bitwise.scala 105:70]
  wire [7:0] _revb_T_178 = _revb_T_176 & 8'haa; // @[Bitwise.scala 105:80]
  wire [7:0] _revb_T_179 = _revb_T_174 | _revb_T_178; // @[Bitwise.scala 105:39]
  wire [7:0] _GEN_30 = {{4'd0}, io_src_0[55:52]}; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_184 = _GEN_30 & 8'hf; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_186 = {io_src_0[51:48], 4'h0}; // @[Bitwise.scala 105:70]
  wire [7:0] _revb_T_188 = _revb_T_186 & 8'hf0; // @[Bitwise.scala 105:80]
  wire [7:0] _revb_T_189 = _revb_T_184 | _revb_T_188; // @[Bitwise.scala 105:39]
  wire [7:0] _GEN_31 = {{2'd0}, _revb_T_189[7:2]}; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_194 = _GEN_31 & 8'h33; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_196 = {_revb_T_189[5:0], 2'h0}; // @[Bitwise.scala 105:70]
  wire [7:0] _revb_T_198 = _revb_T_196 & 8'hcc; // @[Bitwise.scala 105:80]
  wire [7:0] _revb_T_199 = _revb_T_194 | _revb_T_198; // @[Bitwise.scala 105:39]
  wire [7:0] _GEN_32 = {{1'd0}, _revb_T_199[7:1]}; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_204 = _GEN_32 & 8'h55; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_206 = {_revb_T_199[6:0], 1'h0}; // @[Bitwise.scala 105:70]
  wire [7:0] _revb_T_208 = _revb_T_206 & 8'haa; // @[Bitwise.scala 105:80]
  wire [7:0] _revb_T_209 = _revb_T_204 | _revb_T_208; // @[Bitwise.scala 105:39]
  wire [7:0] _GEN_33 = {{4'd0}, io_src_0[63:60]}; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_214 = _GEN_33 & 8'hf; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_216 = {io_src_0[59:56], 4'h0}; // @[Bitwise.scala 105:70]
  wire [7:0] _revb_T_218 = _revb_T_216 & 8'hf0; // @[Bitwise.scala 105:80]
  wire [7:0] _revb_T_219 = _revb_T_214 | _revb_T_218; // @[Bitwise.scala 105:39]
  wire [7:0] _GEN_34 = {{2'd0}, _revb_T_219[7:2]}; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_224 = _GEN_34 & 8'h33; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_226 = {_revb_T_219[5:0], 2'h0}; // @[Bitwise.scala 105:70]
  wire [7:0] _revb_T_228 = _revb_T_226 & 8'hcc; // @[Bitwise.scala 105:80]
  wire [7:0] _revb_T_229 = _revb_T_224 | _revb_T_228; // @[Bitwise.scala 105:39]
  wire [7:0] _GEN_35 = {{1'd0}, _revb_T_229[7:1]}; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_234 = _GEN_35 & 8'h55; // @[Bitwise.scala 105:31]
  wire [7:0] _revb_T_236 = {_revb_T_229[6:0], 1'h0}; // @[Bitwise.scala 105:70]
  wire [7:0] _revb_T_238 = _revb_T_236 & 8'haa; // @[Bitwise.scala 105:80]
  wire [7:0] _revb_T_239 = _revb_T_234 | _revb_T_238; // @[Bitwise.scala 105:39]
  wire [31:0] revb_lo = {_revb_T_119,_revb_T_89,_revb_T_59,_revb_T_29}; // @[Cat.scala 31:58]
  wire [31:0] revb_hi = {_revb_T_239,_revb_T_209,_revb_T_179,_revb_T_149}; // @[Cat.scala 31:58]
  wire [31:0] rev8_lo = {io_src_0[39:32],io_src_0[47:40],io_src_0[55:48],io_src_0[63:56]}; // @[Cat.scala 31:58]
  wire [31:0] rev8_hi = {io_src_0[7:0],io_src_0[15:8],io_src_0[23:16],io_src_0[31:24]}; // @[Cat.scala 31:58]
  wire  _T_1 = ~(|xor_); // @[Alu.scala 308:48]
  wire  _taken_T_1 = 2'h0 == io_func[3:2]; // @[LookupTree.scala 24:34]
  wire  _taken_T_2 = 2'h2 == io_func[3:2]; // @[LookupTree.scala 24:34]
  wire  _taken_T_3 = 2'h3 == io_func[3:2]; // @[LookupTree.scala 24:34]
  wire  _taken_T_8 = _taken_T_1 & _T_1 | _taken_T_2 & slt | _taken_T_3 & sltu; // @[Mux.scala 27:73]
  wire  taken = _taken_T_8 ^ io_func[1]; // @[Alu.scala 312:72]
  LeftShiftModule leftShiftModule ( // @[Alu.scala 194:31]
    .io_shamt(leftShiftModule_io_shamt),
    .io_revShamt(leftShiftModule_io_revShamt),
    .io_sllSrc(leftShiftModule_io_sllSrc),
    .io_sll(leftShiftModule_io_sll),
    .io_revSll(leftShiftModule_io_revSll)
  );
  RightShiftModule rightShiftModule ( // @[Alu.scala 208:32]
    .io_shamt(rightShiftModule_io_shamt),
    .io_revShamt(rightShiftModule_io_revShamt),
    .io_srlSrc(rightShiftModule_io_srlSrc),
    .io_sraSrc(rightShiftModule_io_sraSrc),
    .io_srl(rightShiftModule_io_srl),
    .io_sra(rightShiftModule_io_sra),
    .io_revSrl(rightShiftModule_io_revSrl)
  );
  AddModule addModule ( // @[Alu.scala 222:25]
    .io_src_0(addModule_io_src_0),
    .io_src_1(addModule_io_src_1),
    .io_srcw(addModule_io_srcw),
    .io_add(addModule_io_add),
    .io_addw(addModule_io_addw)
  );
  SubModule subModule ( // @[Alu.scala 233:25]
    .io_src_0(subModule_io_src_0),
    .io_src_1(subModule_io_src_1),
    .io_sub(subModule_io_sub)
  );
  LeftShiftWordModule leftShiftWordModule ( // @[Alu.scala 237:35]
    .io_shamt(leftShiftWordModule_io_shamt),
    .io_revShamt(leftShiftWordModule_io_revShamt),
    .io_sllSrc(leftShiftWordModule_io_sllSrc),
    .io_sllw(leftShiftWordModule_io_sllw),
    .io_revSllw(leftShiftWordModule_io_revSllw)
  );
  RightShiftWordModule rightShiftWordModule ( // @[Alu.scala 244:36]
    .io_shamt(rightShiftWordModule_io_shamt),
    .io_revShamt(rightShiftWordModule_io_revShamt),
    .io_srlSrc(rightShiftWordModule_io_srlSrc),
    .io_sraSrc(rightShiftWordModule_io_sraSrc),
    .io_srlw(rightShiftWordModule_io_srlw),
    .io_sraw(rightShiftWordModule_io_sraw),
    .io_revSrlw(rightShiftWordModule_io_revSrlw)
  );
  ShiftResultSelect shiftResSel ( // @[Alu.scala 315:27]
    .io_func(shiftResSel_io_func),
    .io_sll(shiftResSel_io_sll),
    .io_srl(shiftResSel_io_srl),
    .io_sra(shiftResSel_io_sra),
    .io_rol(shiftResSel_io_rol),
    .io_ror(shiftResSel_io_ror),
    .io_bclr(shiftResSel_io_bclr),
    .io_bset(shiftResSel_io_bset),
    .io_binv(shiftResSel_io_binv),
    .io_bext(shiftResSel_io_bext),
    .io_shiftRes(shiftResSel_io_shiftRes)
  );
  MiscResultSelect miscResSel ( // @[Alu.scala 328:26]
    .io_func(miscResSel_io_func),
    .io_and(miscResSel_io_and),
    .io_or(miscResSel_io_or),
    .io_xor(miscResSel_io_xor),
    .io_orcb(miscResSel_io_orcb),
    .io_orh48(miscResSel_io_orh48),
    .io_sextb(miscResSel_io_sextb),
    .io_packh(miscResSel_io_packh),
    .io_sexth(miscResSel_io_sexth),
    .io_packw(miscResSel_io_packw),
    .io_revb(miscResSel_io_revb),
    .io_rev8(miscResSel_io_rev8),
    .io_pack(miscResSel_io_pack),
    .io_src(miscResSel_io_src),
    .io_miscRes(miscResSel_io_miscRes)
  );
  WordResultSelect wordResSel ( // @[Alu.scala 345:26]
    .io_func(wordResSel_io_func),
    .io_sllw(wordResSel_io_sllw),
    .io_srlw(wordResSel_io_srlw),
    .io_sraw(wordResSel_io_sraw),
    .io_rolw(wordResSel_io_rolw),
    .io_rorw(wordResSel_io_rorw),
    .io_addw(wordResSel_io_addw),
    .io_subw(wordResSel_io_subw),
    .io_wordRes(wordResSel_io_wordRes)
  );
  AluResSel aluResSel ( // @[Alu.scala 356:25]
    .io_func(aluResSel_io_func),
    .io_addRes(aluResSel_io_addRes),
    .io_shiftRes(aluResSel_io_shiftRes),
    .io_miscRes(aluResSel_io_miscRes),
    .io_compareRes(aluResSel_io_compareRes),
    .io_wordRes(aluResSel_io_wordRes),
    .io_aluRes(aluResSel_io_aluRes)
  );
  assign io_result = aluResSel_io_aluRes; // @[Alu.scala 365:13]
  assign io_taken = _taken_T_8 ^ io_func[1]; // @[Alu.scala 312:72]
  assign io_mispredict = (io_pred_taken ^ taken) & io_isBranch; // @[Alu.scala 367:44]
  assign leftShiftModule_io_shamt = io_src_1[5:0]; // @[Alu.scala 190:19]
  assign leftShiftModule_io_revShamt = _revShamt_T_1 + 6'h1; // @[Alu.scala 191:29]
  assign leftShiftModule_io_sllSrc = _leftShiftModule_io_sllSrc_T_4 & io_src_0; // @[Alu.scala 197:70]
  assign rightShiftModule_io_shamt = io_src_1[5:0]; // @[Alu.scala 190:19]
  assign rightShiftModule_io_revShamt = _revShamt_T_1 + 6'h1; // @[Alu.scala 191:29]
  assign rightShiftModule_io_srlSrc = io_src_0; // @[Alu.scala 214:30]
  assign rightShiftModule_io_sraSrc = io_src_0; // @[Alu.scala 215:30]
  assign addModule_io_src_0 = io_func[3] ? _GEN_11 : _addModule_io_src_0_T_8; // @[Alu.scala 272:29]
  assign addModule_io_src_1 = io_src_1; // @[Alu.scala 276:23]
  assign addModule_io_srcw = _addModule_io_srcw_T_7[31:0]; // @[Alu.scala 223:21]
  assign subModule_io_src_0 = io_src_0; // @[Alu.scala 281:23]
  assign subModule_io_src_1 = io_src_1; // @[Alu.scala 282:23]
  assign leftShiftWordModule_io_shamt = shamt[4:0]; // @[Alu.scala 241:32]
  assign leftShiftWordModule_io_revShamt = revShamt[4:0]; // @[Alu.scala 242:35]
  assign leftShiftWordModule_io_sllSrc = io_src_0[31:0]; // @[Alu.scala 240:33]
  assign rightShiftWordModule_io_shamt = shamt[4:0]; // @[Alu.scala 248:33]
  assign rightShiftWordModule_io_revShamt = revShamt[4:0]; // @[Alu.scala 249:36]
  assign rightShiftWordModule_io_srlSrc = io_src_0[31:0]; // @[Alu.scala 250:34]
  assign rightShiftWordModule_io_sraSrc = io_src_0[31:0]; // @[Alu.scala 251:34]
  assign shiftResSel_io_func = io_func[3:0]; // @[Alu.scala 316:30]
  assign shiftResSel_io_sll = leftShiftModule_io_sll; // @[Alu.scala 317:23]
  assign shiftResSel_io_srl = rightShiftModule_io_srl; // @[Alu.scala 318:23]
  assign shiftResSel_io_sra = rightShiftModule_io_sra; // @[Alu.scala 319:23]
  assign shiftResSel_io_rol = rightShiftModule_io_revSrl | leftShiftModule_io_sll; // @[Alu.scala 218:20]
  assign shiftResSel_io_ror = rightShiftModule_io_srl | leftShiftModule_io_revSll; // @[Alu.scala 219:17]
  assign shiftResSel_io_bclr = io_src_0 & _bclr_T; // @[Alu.scala 203:19]
  assign shiftResSel_io_bset = io_src_0 | bitShift; // @[Alu.scala 204:19]
  assign shiftResSel_io_binv = io_src_0 ^ bitShift; // @[Alu.scala 205:19]
  assign shiftResSel_io_bext = {{63'd0}, bext}; // @[Alu.scala 325:23]
  assign miscResSel_io_func = io_func[5:0]; // @[Alu.scala 329:32]
  assign miscResSel_io_and = io_src_0 & logicSrc2; // @[Alu.scala 291:22]
  assign miscResSel_io_or = io_src_0 | logicSrc2; // @[Alu.scala 292:22]
  assign miscResSel_io_xor = io_src_0 ^ logicSrc2; // @[Alu.scala 293:22]
  assign miscResSel_io_orcb = {orcb_hi,orcb_lo}; // @[Cat.scala 31:58]
  assign miscResSel_io_orh48 = _orh48_T_1 | io_src_1; // @[Alu.scala 295:44]
  assign miscResSel_io_sextb = {_sextb_T_2,io_src_0[7:0]}; // @[Cat.scala 31:58]
  assign miscResSel_io_packh = {{48'd0}, packh}; // @[Alu.scala 336:25]
  assign miscResSel_io_sexth = {_sexth_T_2,io_src_0[15:0]}; // @[Cat.scala 31:58]
  assign miscResSel_io_packw = {_packw_T_4,_packw_T_2}; // @[Cat.scala 31:58]
  assign miscResSel_io_revb = {revb_hi,revb_lo}; // @[Cat.scala 31:58]
  assign miscResSel_io_rev8 = {rev8_hi,rev8_lo}; // @[Cat.scala 31:58]
  assign miscResSel_io_pack = {io_src_1[31:0],io_src_0[31:0]}; // @[Cat.scala 31:58]
  assign miscResSel_io_src = io_src_0; // @[Alu.scala 342:25]
  assign wordResSel_io_func = io_func; // @[Alu.scala 346:22]
  assign wordResSel_io_sllw = leftShiftWordModule_io_sllw; // @[Alu.scala 349:22]
  assign wordResSel_io_srlw = rightShiftWordModule_io_srlw; // @[Alu.scala 350:22]
  assign wordResSel_io_sraw = rightShiftWordModule_io_sraw; // @[Alu.scala 351:22]
  assign wordResSel_io_rolw = rightShiftWordModule_io_revSrlw | leftShiftWordModule_io_sllw; // @[Alu.scala 253:22]
  assign wordResSel_io_rorw = rightShiftWordModule_io_srlw | leftShiftWordModule_io_revSllw; // @[Alu.scala 254:19]
  assign wordResSel_io_addw = addw[31:0]; // @[Alu.scala 347:22]
  assign wordResSel_io_subw = subModule_io_sub[31:0]; // @[Alu.scala 348:22]
  assign aluResSel_io_func = io_func[6:4]; // @[Alu.scala 357:28]
  assign aluResSel_io_addRes = addModule_io_add; // @[Alu.scala 358:23]
  assign aluResSel_io_shiftRes = shiftResSel_io_shiftRes; // @[Alu.scala 360:25]
  assign aluResSel_io_miscRes = miscResSel_io_miscRes; // @[Alu.scala 361:24]
  assign aluResSel_io_compareRes = compareRes[63:0]; // @[Alu.scala 359:27]
  assign aluResSel_io_wordRes = wordResSel_io_wordRes; // @[Alu.scala 362:24]
endmodule
