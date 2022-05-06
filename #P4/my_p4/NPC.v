`timescale 1ns / 1ps
module NPC (
    input [31:0] pc,
    input [2:0] Br,
    input [15:0] imm16,
    input [25:0] imm26,
    input [31:0] RD1,
    input  PCSrc,
    output [31:0] PC_4,
    output [31:0] npc
);
    assign  PC_4 = pc + 32'd4 ;
    assign  npc = (Br == 3'b000 )? pc + 32'd4
                : (Br == 3'b001 && PCSrc == 1'b1 )? pc + 32'd4 + {{15{imm16[15]}},imm16[14:0],2'b00}
                : (Br == 3'b010 || Br == 3'b011 )? { pc[31:28] , imm26 , 2'b00}
                : (Br == 3'b100 || Br == 3'b101 )? RD1[31:0] 
                : pc + 32'd4 ;

endmodule