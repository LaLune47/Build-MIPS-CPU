`timescale 1ns / 1ps
`include "macro.v"

module CMP (
    input [31:0] rsRD1,
    input [31:0] rtRD2,
    input [3:0] b_type,
    output b_jump
);
    wire equal = ( rsRD1 == rtRD2 ) ;

    assign b_jump = equal && (b_type == `B_beq) ;
    
endmodule