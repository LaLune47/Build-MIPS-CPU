`timescale 1ns / 1ps
`include "macro.v"

module GRF (
    input [31:0] pc,
    
    input clk,
    input reset,
    input WE,

    input [4:0] a1,
    input [4:0] a2,
    input [4:0] a3,
    input [31:0] WD,

    output [31:0] RD1,
    output [31:0] RD2
);
    reg [31:0] Grf[0:31];
    integer i;

    wire [31:0] tmpRD1 =  Grf[a1];
    wire [31:0] tmpRD2 =  Grf[a2];
    assign RD1 = ((a1 == a3) &&  a3 && WE) ? WD : Grf[a1];   
    assign RD2 = ((a2 == a3) &&  a3 && WE) ? WD : Grf[a2];
    
    initial begin
        for (i=0; i<32; i=i+1) 
           Grf[i] <= 32'd0;
    end

    always @(posedge clk ) begin
        if(reset) begin
            for (i=0; i<32; i=i+1) 
                Grf[i] <= 32'd0;
        end

        else if(WE && a3) begin
                Grf[a3] <= WD ;
            //    $display("%d@%h: $%d <= %h", $time, pc, a3, WD);
					 //$display("@%h: $%d <= %h", pc, a3, WD);
        end
    end

endmodule