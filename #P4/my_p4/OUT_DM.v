`timescale 1ns / 1ps
module OUT_DM (
    input [31:0] addr,
    input [2:0] bit_type,
    input [31:0] data,

    output [31:0] OUT_DM
);
    wire [31:0] LW;
    wire [31:0] LH;
    wire [31:0] LB;

    assign LW = data ;
    assign LH = (addr[1] == 1'b0)? { {16{data[15]}} , data[15:0]}
                 :(addr[1] == 1'b1)? { {16{data[31]}} , data[31:16]}
                 :32'd0 ;
                 
    assign LB = (addr[1:0] == 2'b00)? { {24{data[7]}} , data[7:0]}
                 :(addr[1:0] == 2'b01)? { {24{data[15]}} , data[15:8]}
                 :(addr[1:0] == 2'b10)? { {24{data[23]}} , data[23:16]}
                 :(addr[1:0] == 2'b11)? { {24{data[31]}} , data[31:24]}
                 :32'd0 ;
    
    assign OUT_DM = (bit_type == 2'b00 )? LW
                    :(bit_type == 2'b01 )? LH
                    :(bit_type == 2'b10 )? LB
                    :32'd0 ; 
    
endmodule