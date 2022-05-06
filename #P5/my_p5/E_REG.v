`timescale 1ns / 1ps
`include "macro.v"

module E_REG (
    input clk,
    input reset,
    input EN,

    input [31:0] Instr,
    input [31:0] pc,
    input [31:0] EXT,
    input [31:0] RD1,
    input [31:0] RD2,

    output reg [31:0] Instr_out,
    output reg [31:0] pc_out,
    output reg [31:0] EXT_out,
    output reg [31:0] RD1_out, 
    output reg [31:0] RD2_out

);
    always @(posedge clk ) begin
        if(reset) begin
            Instr_out <= 32'd0 ;
            pc_out <= 32'd0 ;
            EXT_out <= 32'd0 ;
            RD1_out <= 32'd0 ;
            RD2_out <= 32'd0 ;
        end

        else if(EN) begin
            Instr_out <= Instr ;
            pc_out <= pc ;
            EXT_out <= EXT ;
            RD1_out <= RD1 ;
            RD2_out <= RD2 ;
        end
 
    end

endmodule