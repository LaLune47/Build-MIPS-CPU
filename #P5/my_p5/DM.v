`timescale 1ns / 1ps
`include "macro.v"

module DM (
    //DM_in
    input [31:0] addr,    //ALUout  == address ( base + offset )
    input [2:0] bit_type,   //control the length of S/L 
    input [31:0] NewData,   // RD2

    //DM
    input [31:0] pc, 
    input WE,
    input clk,
    input reset,

    //DM out
    output [31:0] OUT_DM
);
    

////////////////////////   INITIAL  DM
    reg [31:0] memory[0:8191];
    integer i;

    initial begin
        for(i=0;i<8192;i=i+1) begin
            memory[i] <= 32'd0 ; 
        end
    end

    wire [12:0] A;
    assign A = addr[14:2];

////////////////  IN_DM
    wire [31:0] SW;
    wire [31:0] SH;
    wire [31:0] SB;
    
    wire [31:0] OldData;
    assign  OldData = memory[A] ; 
    
    assign SW = NewData;
    assign SH = (addr[1] == 1'b0 ) ?   { OldData[31:16] , NewData[15:0]}
                :(addr[1] == 1'b1 ) ? { NewData[15:0] , OldData[15:0]}
                :32'd0  ;
    assign SB = (addr[1:0] == 2'b00 ) ? { OldData[31:8] ,NewData[7:0]}
                 :(addr[1:0] == 2'b01 ) ? { OldData[31:16] ,NewData[7:0] ,OldData[7:0]}
                 :(addr[1:0] == 2'b10 ) ? { OldData[31:24] ,NewData[7:0] , OldData[15:0]}
                 :(addr[1:0] == 2'b11 ) ? { NewData[7:0] , OldData[23:0]}
                 :32'd0  ;

    wire [31:0] WD;   // getting the writing data for DM
    assign WD = (bit_type == `bit_w )? SW 
                  :(bit_type == `bit_h )? SH
                  :(bit_type == `bit_b )? SB
                  :32'd0 ;
                
//////////////////   renew  DM
    always @(posedge clk ) begin
        if(reset) begin
            for(i=0;i<8192;i=i+1) begin             // 有事没事多打（）
                memory[i] <= 32'd0 ;
            end 
        end

        else if(WE) begin
            memory[A] <= WD ;
            $display("%d@%h: *%h <= %h", $time, pc,  {addr[31:2],2'd0}, WD);
				//$display("@%h: *%h <= %h", pc,  {addr[31:2],2'd0}, WD);
        end
    end

////////////////////  DM out
    wire [31:0] LW;
    wire [31:0] LH;
    wire [31:0] LB;

    assign LW = OldData ;
    assign LH = (addr[1] == 1'b0)? { {16{OldData[15]}} , OldData[15:0]}
                 :(addr[1] == 1'b1)? { {16{OldData[31]}} , OldData[31:16]}
                 :32'd0 ;          
    assign LB = (addr[1:0] == 2'b00)? { {24{OldData[7]}} , OldData[7:0]}
                 :(addr[1:0] == 2'b01)? { {24{OldData[15]}} , OldData[15:8]}
                 :(addr[1:0] == 2'b10)? { {24{OldData[23]}} , OldData[23:16]}
                 :(addr[1:0] == 2'b11)? { {24{OldData[31]}} , OldData[31:24]}
                 :32'd0 ;
    assign OUT_DM = (bit_type == `bit_w )? LW
                    :(bit_type == `bit_h )? LH
                    :(bit_type == `bit_b)? LB
                    :32'd0 ; 
    

endmodule