`timescale 1ns / 1ps
module PC_IM (
    input clk,
    input reset,
    input [31:0] npc,

    output reg [31:0] pc,
    output [31:0] Instr,

    output [4:0] shamt,
    output [4:0] rs,
    output [4:0] rt,
    output [4:0] rd,
    output [15:0] imm16,
    output [25:0] imm26
);  
    reg [31:0] IM[0:1023];
    
    initial begin
        pc <= 32'h0000_3000 ;
        $readmemh("code.txt", IM);
    end
    
    always @(posedge clk ) begin
        if(reset) 
            pc <= 32'h0000_3000;
        else 
            pc <= npc ; 
    end

    assign Instr = IM[pc[11:2]];
    
    assign shamt = Instr[10:6];
    assign rs = Instr[25:21];
    assign rt = Instr[20:16];
    assign rd = Instr[15:11];
    assign imm16 = Instr[15:0];
    assign imm26 = Instr[25:0];

    
endmodule