`timescale 1ns / 1ps
module ALU (
    input [3:0] ALUControl,
    input [4:0] shamt,
    input [31:0] ScrA,
    input [31:0] ScrB,

    output [31:0] ALUout,
    output ALUequal,
    output ALUgreater,
    output ALUless
);
    assign ALUout = (ALUControl == 4'b0000) ? (ScrA + ScrB)
                  : (ALUControl == 4'b0001) ? (ScrA - ScrB)
                  : (ALUControl == 4'b0010) ? (ScrA & ScrB)
                  : (ALUControl == 4'b0011) ? (ScrA | ScrB)
                  : (ALUControl == 4'b0100) ? { ScrB[15:0] , 16'd0 }
                  : (ALUControl == 4'b0101) ? (ScrB << shamt)
                  : 32'd0 ;
    assign ALUequal = (ScrA == ScrB) ? 1'b1 : 1'b0 ;
    assign ALUgreater = (ScrA > ScrB) ? 1'b1 : 1'b0 ;
    assign ALUless = (ScrA < ScrB) ? 1'b1 : 1'b0 ;

endmodule