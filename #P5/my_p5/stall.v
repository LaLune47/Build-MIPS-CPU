`timescale 1ns / 1ps
`include "macro.v"

module STALL (
    input [31:0] D_Instr,
    input [31:0] E_Instr,
    input [31:0] M_Instr,
    output stall
);  
    // D Tuse
    wire D_BRANCH, D_LOAD, D_STORE, D_CAL_R, D_CAL_I, D_j_reg  ;
    wire [4:0] D_rs,D_rt;
    CU stall_D_CU (
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

    wire [2:0] Tuse_rs,Tuse_rt;
    
    assign  Tuse_rs = (D_BRANCH | D_j_reg)? 3'd0
                  : (D_LOAD | D_STORE | D_CAL_I |D_CAL_R) ?  3'd1 
                  : 3'd3 ;
    assign  Tuse_rt = (D_BRANCH )? 3'd0
                  : (D_CAL_R) ?  3'd1 
                  : (D_STORE) ?  3'd2 
                  : 3'd3 ;

    // E Tnew
    wire E_LOAD, E_CAL_R, E_CAL_I;
    wire [4:0] E_A3;
    wire E_WE;
    CU stall_E_CU (
    .Instr(E_Instr), 
    .A3(E_A3), 
    .DMWr(E_WE), 
    .LOAD(E_LOAD), 
    .CAL_R(E_CAL_R), 
    .CAL_I(E_CAL_I)
    );

    wire [2:0] Tnew_E;          // 冲突并不在意写入的是rs、rt，只在意具体位置
    assign Tnew_E = (E_CAL_I | E_CAL_R) ? 3'd1 
                     : ( E_LOAD ) ?  3'd2
                     : 3'd0 ;
    wire stall_E_rs = ( Tuse_rs<Tnew_E ) && (D_rs == E_A3) && (D_rs != 5'd0) ;
    wire stall_E_rt = ( Tuse_rt<Tnew_E ) && (D_rt == E_A3) && (D_rt != 5'd0) ;
    

    // M Tnew
    wire M_LOAD;
    wire [4:0] M_A3;
    wire M_WE;
    CU stall_M_CU (
    .Instr(M_Instr), 
    .A3(M_A3), 
    .DMWr(M_WE), 
    .LOAD(M_LOAD)
    );
    
    wire [2:0] Tnew_M;          // 冲突并不在意写入的是rs、rt，只在意具体位置
    assign Tnew_M =  ( M_LOAD ) ?  3'd1 : 3'd0 ;

    wire stall_M_rs = ( Tuse_rs<Tnew_M ) && (D_rs == M_A3) && (D_rs != 5'd0) ;
    wire stall_M_rt = ( Tuse_rt<Tnew_M ) && (D_rt == M_A3) && (D_rt != 5'd0) ;
   


    assign stall = stall_E_rs | stall_E_rt | stall_M_rs | stall_M_rt ;

endmodule