`timescale 1ns / 1ps
module EXT (
    input [15:0] imm16,
    input EXTOp,
    output [31:0] EXTout
);
    assign EXTout = (EXTOp == 1'd0) ? { 16'd0 , imm16 }
                    :(EXTOp == 1'd1) ? { {16{imm16[15]}} , imm16 }
                    :32'd0 ;

endmodule