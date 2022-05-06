`timescale 1ns / 1ps
module DM (
    input [31:0] pc, 

    input WE,
    input [31:0] addr,
    input [9:0] A,
    input [31:0] WD,
    input clk,
    input reset,
    output [31:0] RD
);
    reg [31:0] memory[0:1023];
    integer i;

    initial begin
        for(i=0;i<1024;i=i+1) begin
            memory[i] <= 32'd0 ; 
        end
    end

    always @(posedge clk ) begin
        if(reset) begin
            for(i=0;i<1024;i=i+1) begin             // 有事没事多打（）
                memory[i] <= 32'd0 ;
            end 
        end

        else if(WE) begin
            memory[A] <= WD ;
            $display("@%h: *%h <= %h", pc, addr, WD);
        end
    end

    assign  RD = memory[A] ; 

endmodule