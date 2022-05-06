`timescale 1ns / 1ps
`include "macro.v"

module M_REG (
    input clk,
    input reset,
    input EN,

    input [31:0] Instr,
    input [31:0] pc,
    input [31:0] ALUout,
    input [31:0] RD2,
    input [31:0] MD_out,

    output reg [31:0] Instr_out,
    output reg [31:0] pc_out,
    output reg [31:0] ALUout_out,
    output reg [31:0] RD2_out,
    output reg [31:0] MD_out_out

);
    always @(posedge clk ) begin
        if(reset) begin
            Instr_out <= 32'd0 ;
            pc_out <= 32'd0 ;
            ALUout_out <= 32'd0 ;
            RD2_out <= 32'd0 ;
            MD_out_out <= 32'd0 ;
        end

        else if(EN) begin
            Instr_out <= Instr ;
            pc_out <= pc ;
            ALUout_out <= ALUout;
            RD2_out <= RD2 ;
            MD_out_out <= MD_out ;
        end
 
    end

endmodule