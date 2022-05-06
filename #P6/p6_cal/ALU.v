`timescale 1ns / 1ps
`include "macro.v"

module ALU (
    input [3:0] ALUControl,
    input [4:0] shamt,
    input [31:0] A,
    input [31:0] B,

    output [31:0] ALUout
);  
    wire [32:0] a = { 1'b0 , A };
    wire [32:0] b = { 1'b0 , B };

    wire SLT =( $signed(A) < $signed(B) )? 32'd1 : 32'd0;
    wire SLTU =( $signed(a) < $signed(b) )? 32'd1 : 32'd0;
    wire [4:0] shamt_V = A[4:0] ; 

    assign ALUout = (ALUControl == `ALU_add) ? (A + B)
                  : (ALUControl == `ALU_sub) ? (A - B)
                  : (ALUControl == `ALU_and) ? (A & B)
                  : (ALUControl == `ALU_or) ? (A | B)
                  : (ALUControl == `ALU_lui) ? { B[15:0] , 16'd0 }

                  : (ALUControl == `ALU_sll) ? (B << shamt)
                  : (ALUControl == `ALU_sllv) ? (B << shamt_V)
                  : (ALUControl == `ALU_sra) ?  $signed($signed(B) >>> shamt)
                  : (ALUControl == `ALU_srav) ?  $signed($signed(B) >>> shamt_V)
                  : (ALUControl == `ALU_srl) ? (B >> shamt)
                  : (ALUControl == `ALU_srlv) ? (B >> shamt_V)
                  
                  : (ALUControl == `ALU_slt) ? SLT
                  : (ALUControl == `ALU_sltu) ? SLTU
                  : (ALUControl == `ALU_xor) ? (A ^ B)
                  : (ALUControl == `ALU_nor) ? ~(A | B)
                  : 32'd0 ;

endmodule