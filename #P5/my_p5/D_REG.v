`timescale 1ns / 1ps
`include "macro.v"

module D_REG (
    input clk,
    input reset,
    input EN,

    input [31:0] Instr,
    input [31:0] pc,

    output reg [31:0] Instr_out,
    output reg [31:0] pc_out
);
    always @(posedge clk ) begin
        if(reset) begin
            Instr_out <= 32'd0 ;
            pc_out <= 32'd0 ;
        end

        else if(EN) begin
            Instr_out <= Instr ;
            pc_out <= pc;
        end
 
    end

endmodule