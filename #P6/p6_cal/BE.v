`timescale 1ns / 1ps
`include "macro.v"

module BE(
    input [1:0] A,                 //	I	最低两位地址
    input [31:0] OldData,
    input [2:0] OP_LOAD,           //数据扩展控制�
	output [31:0] DMout
);

    wire [31:0] LW = OldData ;
    wire [31:0] LH = (A[1] == 1'b0)? { {16{OldData[15]}} , OldData[15:0]}
                 :(A[1] == 1'b1)? { {16{OldData[31]}} , OldData[31:16]}
                 :32'd0 ;          
    wire [31:0] LB = (A == 2'b00)? { {24{OldData[7]}} , OldData[7:0]}
                 :(A == 2'b01)? { {24{OldData[15]}} , OldData[15:8]}
                 :(A == 2'b10)? { {24{OldData[23]}} , OldData[23:16]}
                 :(A == 2'b11)? { {24{OldData[31]}} , OldData[31:24]}
                 :32'd0 ;

    wire [31:0] LHU = (A[1] == 1'b0)? { 16'd0 , OldData[15:0]}
                 :(A[1] == 1'b1)? { 16'd0 , OldData[31:16]}
                 :32'd0 ;       
    wire [31:0] LBU = (A == 2'b00)? { 24'd0 , OldData[7:0]}
                 :(A == 2'b01)? { 24'd0 , OldData[15:8]}
                 :(A == 2'b10)? { 24'd0 , OldData[23:16]}
                 :(A == 2'b11)? { 24'd0 , OldData[31:24]}
                 :32'd0 ;

    assign DMout =  (OP_LOAD == `E_L_no) ? LW
                   :(OP_LOAD == `E_L_unsign_b)? LBU
                   :(OP_LOAD == `E_L_sign_b)? LB
                   :(OP_LOAD == `E_L_unsign_h )? LHU
                   :(OP_LOAD == `E_L_sign_h)? LH
                    :32'd0 ; 


endmodule