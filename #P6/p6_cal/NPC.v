`timescale 1ns / 1ps
`include "macro.v"

module NPC (
    input [31:0] D_pc,
    input [31:0] F_pc,
    input [25:0] imm26,
    input [31:0] rsRD1,
    input [2:0] Br,
    input b_jump,

    output [31:0] npc
);

    assign  npc = (Br == `NPC_pc4 )? F_pc + 32'd4
                : (Br == `NPC_branch && b_jump == 1'b1 )? D_pc + 32'd4 + {{15{imm26[15]}},imm26[14:0],2'b00}
                : (Br == `NPC_26 )? { D_pc[31:28] , imm26 , 2'b00}
                : (Br == `NPC_reg )? rsRD1[31:0] 
                : F_pc + 32'd4 ;

endmodule