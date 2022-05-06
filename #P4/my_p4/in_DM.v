`timescale 1ns / 1ps
module IN_DM (
    input [31:0] addr,
    input [2:0] bit_type,
    input [31:0] NewData,
    input [31:0] OldData,

    output [31:0] in_DM

);
    wire [31:0] SW;
    wire [31:0] SH;
    wire [31:0] SB;

    assign SW = NewData;
    assign SH = (addr[1] == 1'b0 ) ?   { OldData[31:16] , NewData[15:0]}
                :(addr[1] == 1'b1 ) ? { NewData[15:0] , OldData[15:0]}
                :32'd0  ;
    
    assign SB = (addr[1:0] == 2'b00 ) ? { OldData[31:8] ,NewData[7:0]}
                 :(addr[1:0] == 2'b01 ) ? { OldData[31:16] ,NewData[7:0] ,OldData[7:0]}
                 :(addr[1:0] == 2'b10 ) ? { OldData[31:24] ,NewData[7:0] , OldData[15:0]}
                 :(addr[1:0] == 2'b11 ) ? { NewData[7:0] , OldData[23:0]}
                 :32'd0  ;
    
    assign in_DM = (bit_type == 2'b00 )? SW 
                  :(bit_type == 2'b01 )? SH
                  :(bit_type == 2'b10 )? SB
                  :32'd0 ;
    
endmodule