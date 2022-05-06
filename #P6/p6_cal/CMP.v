`timescale 1ns / 1ps
`include "macro.v"

module CMP (
    input [31:0] rsRD1,
    input [31:0] rtRD2,
    input [3:0] b_type,
    output b_jump
);
    wire equal = ( rsRD1 == rtRD2 ) ;
    wire not_equal = ~equal ;
    wire less_equal_zero = ( $signed(rsRD1) <= $signed(32'd0) ) ;
    wire greater_zero =  ( $signed(rsRD1) > $signed(32'd0) ) ;
    wire less_zero = ( $signed(rsRD1) < $signed(32'd0) ) ;
    wire greater_equal_zero =  ( $signed(rsRD1) >= $signed(32'd0) ) ;
    
    // wire equal = (rs == rt);
    // wire eq0 = !(|rs);
    // wire gt0 = (!rs[31]) && !eq0;
    // wire le0 = (rs[31]) && !eq0;

    assign b_jump =  (equal && (b_type == `B_beq)) 
                   || (not_equal && (b_type == `B_bne)) 
                   || (less_equal_zero && (b_type == `B_blez)) 
                   || (greater_zero && (b_type == `B_bgtz)) 
                   || (less_zero && (b_type == `B_bltz)) 
                   || (greater_equal_zero && (b_type == `B_bgez)) ;
    
endmodule