`timescale 1ns / 1ps
`include "macro.v"

module ALU (
    input [3:0] ALUControl,
    input [4:0] shamt,
    input [31:0] A,
    input [31:0] B,

    output [31:0] ALUout
); 
    wire SLT =( $signed(A) < $signed(B) )? 32'd1 : 32'd0;

    assign ALUout = (ALUControl == `ALU_add) ? (A + B)
                  : (ALUControl == `ALU_sub) ? (A - B)
                  : (ALUControl == `ALU_and) ? (A & B)
                  : (ALUControl == `ALU_or) ? (A | B)
                  : (ALUControl == `ALU_lui) ? { B[15:0] , 16'd0 }
                  : (ALUControl == `ALU_sll) ? (B << shamt)
                  : (ALUControl == `ALU_slt) ? SLT
                  : 32'd0 ;

endmodule