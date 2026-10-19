`ifndef FOURSTATE_OPS_INCLUDED
`define FOURSTATE_OPS_INCLUDED
`include "constants.svh"
`define MUX(s,a,b) ((s) ? (a) : (b))
`define XOR(a,b) ((a) ^ (b) ^ `ZERO)
`endif
