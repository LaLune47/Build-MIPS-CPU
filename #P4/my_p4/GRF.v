`timescale 1ns / 1ps
module GRF (
    input clk,
    input reset,

    input [31:0] pc,

    input RegWrite,

    input [4:0] a1,
    input [4:0] a2,
    input [4:0] a3,
    input [31:0] WD,

    output [31:0] RD1,
    output [31:0] RD2
);
    reg [31:0] Grf[0:31];
    integer i;

    assign RD1 = Grf[a1];
    assign RD2 = Grf[a2];
    
    initial begin
        for (i=0; i<32; i=i+1) 
           Grf[i] <= 32'd0;
    end

    always @(posedge clk ) begin
        if(reset) begin
            for (i=0; i<32; i=i+1) 
                Grf[i] <= 32'd0;
        end

        else if(RegWrite) begin
            if(a3 != 5'd0) begin
                Grf[a3] <= WD ;
                $display("@%h: $%d <= %h", pc, a3, WD);
            end 
        end
    end

endmodule