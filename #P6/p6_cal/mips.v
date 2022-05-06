`timescale 1ns / 1ps
`include "macro.v"

module mips (
    input clk,
    input reset,
     
    input  [31:0] i_inst_rdata,   // F_Instr 
    input  [31:0] m_data_rdata,   // OldData

    output [31:0] i_inst_addr,   // F_pc
    output [31:0] m_data_addr,   // ALUout in DM
    output reg [31:0] m_data_wdata,    // newdata in DM
    output reg [3:0] m_data_byteen,    // 四位字节使能
    output [31:0] m_inst_addr,  //M_pc

    output w_grf_we,
    output [4:0] w_grf_addr,
    output [31:0] w_grf_wdata,
    output [31:0] w_inst_addr
);
    ///   stall   ///////////////////////////////////
    wire E_MDstall;
    wire [31:0] F_Instr =  i_inst_rdata ;
    wire [31:0]  D_Instr, E_Instr, M_Instr, W_Instr ;
    wire stall;
    wire [31:0] F_pc, D_pc, E_pc, M_pc, W_pc;

     STALL my_STALL (
     .D_Instr(D_Instr), 
     .E_Instr(E_Instr), 
     .M_Instr(M_Instr), 
     .E_MDstall(E_MDstall),
     .stall(stall)
     );
    
    wire PC_en = !stall ;
    wire D_en = !stall ;
	wire E_en = 1'b1;
	wire M_en = 1'b1;
	wire W_en = 1'b1;

    wire D_reset = 1'b0 ;
    wire E_reset = stall;
	wire M_reset = 1'b0;
	wire W_reset = 1'b0;
    
    ///// FWD
    wire [31:0] Forward_RS_D, Forward_RT_D, Forward_RS_E, Forward_RT_E, Forward_RT_M;
   

    ///  F  /////////////////////////////////////
    wire [31:0] npc;

    PC my_PC (
    .clk(clk), 
    .reset(reset), 
    .WE(PC_en), 
    .npc(npc), 
    .pc(F_pc)
    // .Instr(F_Instr)
    );


    ///  D  /////////////////////////////////////
    D_REG my_D_REG (
    .clk(clk), 
    .reset(reset || D_reset), 
    .EN(D_en), 
    .Instr(F_Instr), 
    .pc(F_pc), 
    .Instr_out(D_Instr), 
    .pc_out(D_pc)
    );


    wire [4:0] D_rs, D_rt;
    wire [15:0] D_imm16;
    wire [25:0] D_imm26;
    wire [2:0] D_Br;
    wire [3:0] D_b_type;
    wire D_EXTop;

    CU my_D_CU (
    .Instr(D_Instr), 
    .rs(D_rs), 
    .rt(D_rt), 
    .imm16(D_imm16), 
    .imm26(D_imm26), 
    .Br(D_Br), 
    .b_type(D_b_type), 
    .EXTop(D_EXTop)
    );

       // 多个阶段都可以回�
    wire [2:0] W_WDSel;
    wire W_RFWr;
    wire [4:0] W_A3;

    CU my_W_CU (
    .Instr(W_Instr), 
    .WDSel(W_WDSel), 
    .RFWr(W_RFWr), 
    .A3(W_A3)
    );
    wire [31:0] W_ALUout, W_DMout, W_MD_out;
    wire [31:0] W_WD = ( W_WDSel == `WD_ALU ) ? W_ALUout 
                      :( W_WDSel == `WD_MuxDiv    ) ? W_MD_out
                      :( W_WDSel == `WD_load ) ? W_DMout
                      :( W_WDSel == `WD_addr_jalX ) ? W_pc + 32'd8
                      : 32'd0  ;

    wire [31:0] D_RS, D_RT ;
        
    GRF my_GRF (
    .pc(W_pc), 
    .clk(clk), 
    .reset(reset), 
    .WE(W_RFWr), 
    .a1(D_rs), 
    .a2(D_rt), 
    .a3(W_A3), 
    .WD(W_WD), 
    .RD1(D_RS), 
    .RD2(D_RT)
    );
    
    wire [31:0] D_EXTout;
    EXT my_EXT (
    .imm16(D_imm16), 
    .EXTop(D_EXTop), 
    .EXTout(D_EXTout)
    );
    
    wire D_b_jump;
    CMP my_CMP (
    .rsRD1(Forward_RS_D), 
    .rtRD2(Forward_RT_D), 
    .b_type(D_b_type), 
    .b_jump(D_b_jump)
    );

    NPC my_NPC (
    .D_pc(D_pc), 
    .F_pc(F_pc), 
    .imm26(D_imm26), 
    .rsRD1(Forward_RS_D), 
    .Br(D_Br), 
    .b_jump(D_b_jump), 
    .npc(npc)
    );

    ///  E  /////////////////////////////////////
    wire [31:0] E_EXTout, E_RS, E_RT;
    E_REG my_E_REG (
    .clk(clk), 
    .reset(reset || E_reset), 
    .EN(E_en), 
    .Instr(D_Instr), 
    .pc(D_pc), 
    .EXT(D_EXTout), 
    .RD1(Forward_RS_D), 
    .RD2(Forward_RT_D), 
    .Instr_out(E_Instr), 
    .pc_out(E_pc), 
    .EXT_out(E_EXTout), 
    .RD1_out(E_RS), 
    .RD2_out(E_RT)
    );

    wire [3:0] E_ALUControl;
    wire [3:0] E_MD_Control;
    wire E_BSel;
    wire [4:0] E_shamt ,E_rs ,E_rt;
    CU my_E_CU (
    .Instr(E_Instr), 
    .shamt(E_shamt), 
    .rs(E_rs), 
    .rt(E_rt), 
    .MD_Control(E_MD_Control),
    .ALUControl(E_ALUControl), 
    .BSel(E_BSel)
    );

    wire [31:0] E_ALUout;
    wire [31:0] E_B = (E_BSel == `ScrB_RD2)?  Forward_RT_E : E_EXTout ;

    ALU my_ALU (
    .ALUControl(E_ALUControl), 
    .shamt(E_shamt), 
    .A(Forward_RS_E), 
    .B(E_B), 
    .ALUout(E_ALUout)
    );

    wire [31:0] E_MD_out;
    
    MULT_DIV my_MULT_DIV(
    .clk(clk),
    .reset(reset),
    .RS(Forward_RS_E),
    .RT(Forward_RT_E),
    .type(E_MD_Control),

    .MDstall(E_MDstall),
    .MD_out(E_MD_out)
);
    

    ///  M  /////////////////////////////////////
    wire [31:0] M_ALUout, M_MD_out, M_RT;
    M_REG my_M_REG (
    .clk(clk), 
    .reset(reset || M_reset), 
    .EN(M_en), 
    .Instr(E_Instr), 
    .pc(E_pc), 
    .ALUout(E_ALUout), 
    .RD2(Forward_RT_E),
    .MD_out(E_MD_out),

    .Instr_out(M_Instr), 
    .pc_out(M_pc), 
    .ALUout_out(M_ALUout), 
    .RD2_out(M_RT),
    .MD_out_out(M_MD_out)
    );

    wire [2:0] M_DMtype;
    wire [2:0] M_OP_LOAD;
    wire M_DMWr;
    wire [4:0] M_rt;
    CU my_M_CU (
    .Instr(M_Instr), 
    .rt(M_rt), 
    .DMtype(M_DMtype), 
    .OP_LOAD(M_OP_LOAD),
    .DMWr(M_DMWr)
    );
    
    wire [31:0] M_DMout ;
    // DM my_DM (
    // .addr(M_ALUout), 
    // .bit_type(M_DMtype), 
    // .NewData(Forward_RT_M), 
    // .pc(M_pc), 
    // .WE(M_DMWr), 
    // .clk(clk), 
    // .reset(reset), 
    // .OUT_DM(M_DMout)
    // );

    wire [31:0] OldData = m_data_rdata;
    BE  my_BE (
    .A(M_ALUout[1:0]), 
    .OldData(OldData),
    .OP_LOAD(M_OP_LOAD),
    .DMout(M_DMout)
    );


    ///  W /////////////////////////////////////
    //wire [31:0] W_ALUout, W_DMout ,W_MD_out;
    W_REG my_W_REG (
    .clk(clk), 
    .reset(reset || W_reset), 
    .EN(W_en), 
    .Instr(M_Instr), 
    .pc(M_pc), 
    .ALUout(M_ALUout), 
    .DMout(M_DMout), 
    .MD_out(M_MD_out),

    .Instr_out(W_Instr), 
    .pc_out(W_pc), 
    .ALUout_out(W_ALUout), 
    .DMout_out(W_DMout),
    .MD_out_out(W_MD_out)
    );

     

    ////  pre FWD //////////////////////////////////////////////////////////
        // E_WD
    wire [2:0] E_WDSel;
    wire E_RFWr;
    wire [4:0] E_A3;

    CU my_E_CU_2 (
    .Instr(E_Instr), 
    .WDSel(E_WDSel), 
    .RFWr(E_RFWr), 
    .A3(E_A3)
    );
    
    wire [31:0] E_WD;
    assign E_WD =  ( E_WDSel == `WD_ALU ) ? E_ALUout  //  不对就注释掉
                       :( E_WDSel == `WD_MuxDiv ) ? E_MD_out  //  不对就注释掉
                      :( E_WDSel == `WD_addr_jalX ) ? E_pc + 32'd8
                      : 32'd0  ;
    
           
        // M_WD
    wire [2:0] M_WDSel;
    wire M_RFWr;
    wire [4:0] M_A3;

    CU my_M_CU_2 (
    .Instr(M_Instr), 
    .WDSel(M_WDSel), 
    .RFWr(M_RFWr), 
    .A3(M_A3)
    );
    
    wire [31:0] M_WD;
    assign M_WD = ( M_WDSel == `WD_ALU ) ? M_ALUout 
                      :( M_WDSel == `WD_MuxDiv ) ? M_MD_out
                      :( M_WDSel == `WD_load ) ? M_DMout   //  不对就注释掉
                      :( M_WDSel == `WD_addr_jalX ) ? M_pc + 32'd8
                      : 32'd0  ;


     // FWD /////////////////////////////////////////
    // wire [3:0] F_RS_D_Sel, F_RT_D_Sel, F_RS_E_Sel, F_RT_E_Sel, F_RT_M_Sel;
    // FWD my_FWD (
    // .D_Instr(D_Instr), 
    // .E_Instr(E_Instr), 
    // .M_Instr(M_Instr), 
    // .W_Instr(W_Instr), 
    // .F_RS_D_Sel(F_RS_D_Sel), 
    // .F_RT_D_Sel(F_RT_D_Sel), 
    // .F_RS_E_Sel(F_RS_E_Sel), 
    // .F_RT_E_Sel(F_RT_E_Sel), 
    // .F_RT_M_Sel(F_RT_M_Sel)
    // );

    // assign Forward_RS_D = (F_RS_D_Sel == `F_zero ) ? 32'd0
    //                      :(F_RS_D_Sel == `FfromE) ?  E_WD
    //                      :(F_RS_D_Sel == `FfromM) ?  M_WD
    //             //         :(F_RS_D_Sel == `FfromW) ?  W_WD
    //                      :(F_RS_D_Sel == `FtoD_D_original) ?  D_RS 
    //                      : 32'd0  ;
                         
    // assign Forward_RT_D = (F_RT_D_Sel == `F_zero ) ? 32'd0
    //                      :(F_RT_D_Sel == `FfromE) ?  E_WD
    //                      :(F_RT_D_Sel == `FfromM) ?  M_WD
    //             //         :(F_RT_D_Sel == `FfromW) ?  W_WD
    //                      :(F_RT_D_Sel == `FtoD_D_original) ?  D_RT 
    //                      : 32'd0  ;

    // assign Forward_RS_E = (F_RS_E_Sel == `F_zero ) ? 32'd0
    //                      :(F_RS_E_Sel == `FfromM) ? M_WD
    //                      :(F_RS_E_Sel == `FfromW) ?  W_WD
    //                      :(F_RS_E_Sel == `FtoE_E_original) ?  E_RS 
    //                      : 32'd0  ;

    // assign Forward_RT_E = (F_RT_E_Sel == `F_zero ) ? 32'd0
    //                      :(F_RT_E_Sel == `FfromM) ? M_WD
    //                      :(F_RT_E_Sel == `FfromW) ?  W_WD
    //                      :(F_RT_E_Sel == `FtoE_E_original) ?  E_RT
    //                      : 32'd0  ;

    // assign Forward_RT_M = (F_RT_M_Sel == `F_zero ) ? 32'd0
    //                      :(F_RT_M_Sel == `FfromW) ?  W_WD
    //                      :(F_RT_M_Sel == `FtoM_M_original) ?  M_RT
    //                      : 32'd0  ;
    // ////////////////
    

    assign Forward_RS_D = (D_rs == 5'd0 ) ? 32'd0
                         :( (D_rs == E_A3) && E_RFWr) ?  E_WD    // E_RFWr 非必要
                         :( (D_rs == M_A3) && M_RFWr) ?  M_WD
                //       :( (D_rs == W_A3) && W_RFWr) ?  W_WD
                         : D_RS ;
                         
    assign Forward_RT_D = (D_rt == 5'd0 ) ? 32'd0
                         :( (D_rt == E_A3) && E_RFWr) ?  E_WD
                         :( (D_rt == M_A3) && M_RFWr) ?  M_WD
                //       :( (D_rt == W_A3) && W_RFWr) ?  W_WD
                         : D_RT  ;
    
    
    assign Forward_RS_E = (E_rs == 5'd0 ) ? 32'd0
                         :( (E_rs == M_A3) && M_RFWr) ?  M_WD
                         :( (E_rs == W_A3) && W_RFWr) ?  W_WD
                         : E_RS ;
                         
    assign Forward_RT_E = (E_rt == 5'd0 ) ? 32'd0
                         :( (E_rt == M_A3) && M_RFWr) ?  M_WD
                         :( (E_rt == W_A3) && W_RFWr) ?  W_WD
                         : E_RT  ;


    assign Forward_RT_M = (M_rt == 5'd0 ) ? 32'd0
                         :( (M_rt == W_A3) && W_RFWr) ?  W_WD
                         : M_RT ;

     
    //////////////////   P6  ///////////////////////////////////////////////////////
    assign i_inst_addr = F_pc ; 
    assign m_data_addr = M_ALUout ;
   // assign m_data_wdata  = Forward_RT_M;

    always @(*) begin
        if(M_DMtype == `bit_w) begin
            m_data_byteen = 4'b1111 ;
            m_data_wdata = Forward_RT_M;
        end
           
        else if(M_DMtype == `bit_h) begin
            if(M_ALUout[1] == 1'b0) begin
                m_data_byteen = 4'b0011 ;
                m_data_wdata = { 16'd0, Forward_RT_M[15:0] };
            end
            else begin
                m_data_byteen = 4'b1100 ;   
                m_data_wdata = { Forward_RT_M[15:0] , 16'd0 };
            end
        end

        else if(M_DMtype == `bit_b) begin
            if(M_ALUout[1:0] == 2'b00) begin
                m_data_byteen = 4'b0001 ;
                m_data_wdata = { 24'd0, Forward_RT_M[7:0] };
            end
            else if(M_ALUout[1:0] == 2'b01) begin
                m_data_byteen = 4'b0010 ;
                m_data_wdata = { 16'd0, Forward_RT_M[7:0] ,8'd0 };
            end
            else if(M_ALUout[1:0] == 2'b10) begin
                m_data_byteen = 4'b0100 ;
                m_data_wdata = { 8'd0, Forward_RT_M[7:0] ,16'd0 };
            end
            else  begin
                m_data_byteen = 4'b1000 ;   
                m_data_wdata = { Forward_RT_M[7:0] ,24'd0 };

            end 
        end
        
        else    m_data_byteen = 4'b0000 ;
    end
     

    assign m_inst_addr = M_pc ; 

    assign w_grf_we	=  W_RFWr ;
    assign w_grf_addr = W_A3 ;
    assign w_grf_wdata = W_WD ;
    assign w_inst_addr = W_pc ;
endmodule