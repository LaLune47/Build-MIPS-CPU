`timescale 1ns / 1ps
`include "macro.v"
/// 对CU部分的判断的都留到哦PRE_FORWARD进行
module mips (
    input clk,
    input reset
); 
//// adding wires: 
    wire D_b_link, E_b_link, M_b_link, W_b_link;
//// changes in CU_e_2, CU_M_2 ,CU_W /// D_CMP /// E_REG, M_REG, W_REG 
 assign gwa_res = ...
    			(bgezal | bltzal)?((b_j)?5'd31: 5'b0 ):
				...	     


    
    ///   stall   ///////////////////////////////////
    ///// FWD  ////////////////////////////////
    ///  F  /////////////////////////////////////
    ///  D  /////////////////////////////////////
    // 多个阶段都可以回
    CU my_W_CU (
    .b_link(W_b_link)    // input  , 这个会改变A3
    );
    wire [31:0] W_WD =

                ////////////////////////////////
    wire D_b_link;
    CMP my_CMP (
    .b_link(D_b_link)   // output，这个信号会一直流水下去

    );


    ///  E  /////////////////////////////////////
    E_REG my_E_REG (
    .b_link(D_b_link),
    .b_link_out(E_b_link)
    );


    ///  M  /////////////////////////////////////
    M_REG my_M_REG (
    .b_link(E_b_link),
    .b_link_out(M_b_link)
    );


    ///  W /////////////////////////////////////
    W_REG my_W_REG (
    .b_link(M_b_link),
    .b_link_out(W_b_link)
    );


    ////  pre FWD //////////////////////////////////////////////////////////
        // E_WD
    CU my_E_CU_2 (
    .b_link(E_b_link)    // input  , 这个会改变A3
    );
    assign E_WD = 

        // M_WD
    CU my_M_CU_2 (
    .b_link(M_b_link)    // input  , 这个会改变A3
    );
    assign M_WD = 
    
    ///  FWD /////////////////////////////////////////
    
endmodule