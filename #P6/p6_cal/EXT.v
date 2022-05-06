`timescale 1ns / 1ps
`include "macro.v"

module EXT (
    input [15:0] imm16,
    input EXTop,
    output [31:0] EXTout
);
    assign EXTout = (EXTop == `EXT_zero) ? { 16'd0 , imm16 }
                    :(EXTop == `EXT_sign) ? { {16{imm16[15]}} , imm16 }
                    :32'd0 ;

endmodule