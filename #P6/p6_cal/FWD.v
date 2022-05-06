`timescale 1ns / 1ps
`include "macro.v"

module FWD (
    input [31:0] D_Instr,
    input [31:0] E_Instr,
    input [31:0] M_Instr,
    input [31:0] W_Instr,
    
    output [3:0] F_RS_D_Sel,
    output [3:0] F_RT_D_Sel,

    output [3:0] F_RS_E_Sel,
    output [3:0] F_RT_E_Sel,

    output [3:0] F_RT_M_Sel
);

    // D
    wire [4:0] D_rs, D_rt;
    wire D_BRANCH, D_LOAD, D_STORE, D_CAL_R, D_CAL_I, D_j_reg ;
    CU d_cu (
    .Instr(D_Instr), 
    .rs(D_rs), 
    .rt(D_rt), 

    .BRANCH(D_BRANCH), 
    .LOAD(D_LOAD), 
    .STORE(D_STORE), 
    .CAL_R(D_CAL_R), 
    .CAL_I(D_CAL_I), 
    .j_reg(D_j_reg) 
    );
    
    // E
    wire [4:0] E_rs, E_rt;
    wire [4:0] E_A3;
    wire E_LOAD, E_STORE, E_CAL_R, E_CAL_I;
    wire E_j_link ;
    CU e_cu (
    .Instr(E_Instr), 
    .rs(E_rs), 
    .rt(E_rt), 

    .A3(E_A3), 

    .LOAD(E_LOAD), 
    .STORE(E_STORE), 
    .CAL_R(E_CAL_R), 
    .CAL_I(E_CAL_I), 
   
    .j_link(E_j_link)
    );
    
    // M
    wire [4:0] M_rt;
    wire [4:0] M_A3;
    wire M_STORE;
    wire M_CAL_R, M_CAL_I, M_j_link ;
    CU m_cu (
    .Instr(M_Instr), 
    .rt(M_rt), 

    .A3(M_A3), 
  
    .STORE(M_STORE), 

    .CAL_R(M_CAL_R), 
    .CAL_I(M_CAL_I), 
    .j_link(M_j_link)
    );

    // W
    wire [4:0] W_A3;
    wire W_LOAD, W_CAL_R, W_CAL_I, W_j_link ;
    CU w_cu (
    .Instr(W_Instr), 
    
    .A3(W_A3), 

    .LOAD(W_LOAD), 
    .CAL_R(W_CAL_R), 
    .CAL_I(W_CAL_I), 
    .j_link(W_j_link)
    );

    wire F_RS_D_instructions = D_BRANCH | D_LOAD | D_STORE | D_CAL_R | D_CAL_I | D_j_reg ;
    assign  F_RS_D_Sel = (D_rs == 5'd0) ? `F_zero
                       : (  (F_RS_D_instructions==1'b1) && (E_j_link==1'b1) && (D_rs == E_A3) && (D_rs != 5'd0) ) ?  `FfromE  // E---D
                       : (  (F_RS_D_instructions==1'b1) && (M_CAL_R==1'b1) && (D_rs == M_A3) && (D_rs != 5'd0) )  ?  `FfromM  // M---D
                       : (  (F_RS_D_instructions==1'b1) && (M_CAL_I==1'b1) && (D_rs == M_A3) && (D_rs != 5'd0) )  ?  `FfromM
                       : (  (F_RS_D_instructions==1'b1) && (M_j_link==1'b1) && (D_rs == M_A3) && (D_rs != 5'd0) )  ?  `FfromM
                  //     : (  (F_RS_D_instructions==1'b1) && (W_LOAD==1'b1) && (D_rs == W_A3) && (D_rs != 5'd0) )  ? `FfromW  // W---D
                  //     : (  (F_RS_D_instructions==1'b1) && (W_CAL_R==1'b1) && (D_rs == W_A3) && (D_rs != 5'd0) )  ?  `FfromW
                  //     : (  (F_RS_D_instructions==1'b1) && (W_CAL_I==1'b1) && (D_rs == W_A3) && (D_rs != 5'd0) )  ?  `FfromW
                  //     : (  (F_RS_D_instructions==1'b1) && (W_j_link==1'b1) && (D_rs == W_A3) && (D_rs != 5'd0) )  ? `FfromW
                       : `FtoD_D_original ;
    
    wire F_RT_D_instructions = D_BRANCH | D_STORE | D_CAL_R ; 
    assign  F_RT_D_Sel =(D_rt == 5'd0) ? `F_zero
                       : (  (F_RT_D_instructions==1'b1) && (E_j_link==1'b1) && (D_rt == E_A3) && (D_rt != 5'd0) ) ?  `FfromE  // E---D
                       : (  (F_RT_D_instructions==1'b1) && (M_CAL_R==1'b1) && (D_rt == M_A3) && (D_rt != 5'd0) )  ?  `FfromM  // M---D
                       : (  (F_RT_D_instructions==1'b1) && (M_CAL_I==1'b1) && (D_rt == M_A3) && (D_rt != 5'd0) )  ?  `FfromM
                       : (  (F_RT_D_instructions==1'b1) && (M_j_link==1'b1) && (D_rt == M_A3) && (D_rt != 5'd0) )  ?  `FfromM
                  //     : (  (F_RT_D_instructions==1'b1) && (W_LOAD==1'b1) && (D_rt == W_A3) && (D_rt != 5'd0) )  ?  `FfromW   // W---D
                  //     : (  (F_RT_D_instructions==1'b1) && (W_CAL_R==1'b1) && (D_rt == W_A3) && (D_rt != 5'd0) )  ?  `FfromW
                  //     : (  (F_RT_D_instructions==1'b1) && (W_CAL_I==1'b1) && (D_rt == W_A3) && (D_rt != 5'd0) )  ?  `FfromW
                  //     : (  (F_RT_D_instructions==1'b1) && (W_j_link==1'b1) && (D_rt == W_A3) && (D_rt != 5'd0) )  ? `FfromW
                       : `FtoD_D_original ;

    wire F_RS_E_instructions =  E_LOAD | E_STORE | E_CAL_R | E_CAL_I  ;
    assign  F_RS_E_Sel = (E_rs == 5'd0) ? `F_zero
                       : (  (F_RS_E_instructions==1'b1) && (M_CAL_R==1'b1) && (E_rs == M_A3) && (E_rs != 5'd0) )  ?  `FfromM  // M---E
                       : (  (F_RS_E_instructions==1'b1) && (M_CAL_I==1'b1) && (E_rs == M_A3) && (E_rs != 5'd0) )  ?  `FfromM
                       : (  (F_RS_E_instructions==1'b1) && (M_j_link==1'b1) && (E_rs == M_A3) && (E_rs != 5'd0) )  ?  `FfromM
                       : (  (F_RS_E_instructions==1'b1) && (W_LOAD==1'b1) && (E_rs == W_A3) && (E_rs != 5'd0) )  ?  `FfromW  // W---E
                       : (  (F_RS_E_instructions==1'b1) && (W_CAL_R==1'b1) && (E_rs == W_A3) && (E_rs != 5'd0) )  ?  `FfromW
                       : (  (F_RS_E_instructions==1'b1) && (W_CAL_I==1'b1) && (E_rs == W_A3) && (E_rs != 5'd0) )  ?  `FfromW
                       : (  (F_RS_E_instructions==1'b1) && (W_j_link==1'b1) && (E_rs == W_A3) && (E_rs != 5'd0) )  ?  `FfromW
                       :  `FtoE_E_original ;

    wire F_RT_E_instructions =  E_STORE | E_CAL_R  ;
    assign  F_RT_E_Sel = (E_rt == 5'd0) ? `F_zero
                       : (  (F_RT_E_instructions==1'b1) && (M_CAL_R==1'b1) && (E_rt == M_A3) && (E_rt != 5'd0) )  ? `FfromM  // M---E
                       : (  (F_RT_E_instructions==1'b1) && (M_CAL_I==1'b1) && (E_rt == M_A3) && (E_rt != 5'd0) )  ?  `FfromM
                       : (  (F_RT_E_instructions==1'b1) && (M_j_link==1'b1) && (E_rt == M_A3) && (E_rt != 5'd0) )  ? `FfromM
                       : (  (F_RT_E_instructions==1'b1) && (W_LOAD==1'b1) && (E_rt == W_A3) && (E_rt != 5'd0) )  ?  `FfromW    // W---E
                       : (  (F_RT_E_instructions==1'b1) && (W_CAL_R==1'b1) && (E_rt == W_A3) && (E_rt != 5'd0) )  ?  `FfromW
                       : (  (F_RT_E_instructions==1'b1) && (W_CAL_I==1'b1) && (E_rt == W_A3) && (E_rt != 5'd0) )  ?  `FfromW
                       : (  (F_RT_E_instructions==1'b1) && (W_j_link==1'b1) && (E_rt == W_A3) && (E_rt != 5'd0) )  ?  `FfromW
                       :  `FtoE_E_original ;

    wire F_RT_M_instructions =  M_STORE  ;
    assign  F_RT_M_Sel = (M_rt == 5'd0) ? `F_zero
                       : (  (F_RT_M_instructions==1'b1) && (W_LOAD==1'b1) && (M_rt == W_A3) && (M_rt != 5'd0) )  ?  `FfromW   // W---M
                       : (  (F_RT_M_instructions==1'b1) && (W_CAL_R==1'b1) && (M_rt == W_A3) && (M_rt != 5'd0) )  ?  `FfromW
                       : (  (F_RT_M_instructions==1'b1) && (W_CAL_I==1'b1) && (M_rt == W_A3) && (M_rt != 5'd0) )  ?  `FfromW
                       : (  (F_RT_M_instructions==1'b1) && (W_j_link==1'b1) && (M_rt == W_A3) && (M_rt != 5'd0) )  ?  `FfromW
                       : `FtoM_M_original ;
    
endmodule