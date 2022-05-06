`timescale 1ns / 1ps
`include "macro.v"

module PC (
    input clk,
    input reset,
    input WE,
    input [31:0] npc,

    output reg [31:0] pc
    // output [31:0] Instr
);  
    // reg [31:0] IM[0:8191];  //
    
    initial begin
        pc <= 32'h0000_3000 ;
        // $readmemh("code.txt", IM);
    end
    
    always @(posedge clk ) begin
        if(reset) 
            pc <= 32'h0000_3000;
        else if(WE)
            pc <= npc ; 
    end

    // assign Instr = IM[pc[14:2] - 13'b0110000000000 ];
    
endmodule