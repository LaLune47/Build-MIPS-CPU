`timescale 1ns / 1ps
`include "macro.v"

module CU (
    input [31:0] Instr,
    
    // meaningful parts of instructions
    output [4:0] rs,
    output [4:0] rt,
    output [4:0] rd,
    output [4:0] shamt,
    output [15:0] imm16,
    output [25:0] imm26,

    // controlling
    output [2:0] Br,
    output [3:0] b_type,

    output EXTop,
   
    output [3:0] ALUControl,
    output BSel,
   
    output [2:0] DMtype,
    output DMWr,


  //  output [2:0] A3Sel,
    output [2:0] WDSel,
    output RFWr,
    output [4:0] A3,
    output [2:0] A3Sel,
    
    //type
    output BRANCH,
    output LOAD,
    output STORE,
    output CAL_R,
    output CAL_I,
    output j_26,
    output j_reg,
    output j_link
);

    // cuts
    assign rs = Instr[25:21];
    assign rt = Instr[20:16];
    assign rd = Instr[15:11];
    assign shamt = Instr[10:6];
    assign imm16 = Instr[15:0];
    assign imm26 = Instr[25:0];


    // select the instructions
    wire [5:0] func;
    wire [5:0] opcode;
    assign func = Instr[5:0];
    assign opcode = Instr[31:26];

//////instructions_number///////////////////////////////////////////
    parameter OP_BEQ = 6'b000100; ///////// B
    parameter OP_SW  = 6'b101011; ///////// S
    parameter OP_SH  = 6'b101001;
    parameter OP_SB  = 6'b101000;
    parameter OP_LW  = 6'b100011; ////////  L
    parameter OP_LH  = 6'b100001;
    parameter OP_LB  = 6'b100000;
    parameter OP_J  = 6'b000010;   ///////  J_imm26
    parameter OP_JAL  = 6'b000011;
    parameter OP_ORI  = 6'b001101;  /////  cal imm
    parameter OP_LUI  = 6'b001111;
    parameter OP_ADDIU  = 6'b001001;

    parameter FUNC_ADDU = 6'b100001;  ///// R
    parameter FUNC_SUBU = 6'b100011 ;
    parameter FUNC_SLL = 6'b000000;
    parameter FUNC_JR = 6'b001000;
    parameter FUNC_AND = 6'b100100;
    parameter FUNC_SLT = 6'b101010;
    parameter FUNC_JALR= 6'b001001 ;
////////////////////////////////////////////////////////////////////////////////////

    // wires instruction
    //B
    assign beq = (opcode == OP_BEQ)? 1'b1 : 1'b0;
    //S 
    assign sw = (opcode == OP_SW)? 1'b1 : 1'b0;   
    assign sh = (opcode == OP_SH)? 1'b1 : 1'b0;
    assign sb = (opcode == OP_SB)? 1'b1 : 1'b0; 
    //L
    assign lw = (opcode == OP_LW)? 1'b1 : 1'b0;  
    assign lh = (opcode == OP_LH)? 1'b1 : 1'b0;
    assign lb = (opcode == OP_LB)? 1'b1 : 1'b0; 
    //type J
    assign j = (opcode == OP_J)? 1'b1 : 1'b0;
    assign jal = (opcode == OP_JAL)? 1'b1 : 1'b0; 
    //type I
    assign ori = (opcode == OP_ORI)? 1'b1 : 1'b0;  
    assign lui = (opcode == OP_LUI)? 1'b1 : 1'b0;
    assign addiu = (opcode == OP_ADDIU)? 1'b1 : 1'b0; 
    //type R
    assign addu = (opcode == 6'd0 && func == FUNC_ADDU)? 1'b1 : 1'b0 ;
    assign subu = (opcode == 6'd0 && func == FUNC_SUBU)? 1'b1 : 1'b0 ;
    assign sll = (opcode == 6'd0 && func == FUNC_SLL)? 1'b1 : 1'b0 ;
    assign jr = (opcode == 6'd0 && func == FUNC_JR)? 1'b1 : 1'b0 ;
    assign and_ = (opcode == 6'd0 && func == FUNC_AND)? 1'b1 : 1'b0 ;
    assign slt = (opcode == 6'd0 && func == FUNC_SLT)? 1'b1 : 1'b0 ;
    assign jalr = (opcode == 6'd0 && func == FUNC_JALR)? 1'b1 : 1'b0 ;


    //TYPE
    assign BRANCH = beq ;
    assign STORE =  sw | sh | sb ;
    assign LOAD =   lw | lh | lb ;

    assign CAL_R  = addu | subu | sll | and_ | slt ;
    assign CAL_I  =  ori | lui | addiu ;
    
    assign j_26  = j | jal ;
    assign j_reg = jr |jalr ;
    assign j_link = jal | jalr ;
    
    
///////////////////////////////////////////////////////////////////////////////////   control
    /// D
    assign EXTop = ( STORE | LOAD | addiu )? `EXT_sign : `EXT_zero ;
    //  zero :andi | ori ;
    
    assign Br = (BRANCH == 1'b1)? `NPC_branch
               : j_26  ? `NPC_26
               : j_reg ? `NPC_reg
               : `NPC_pc4  ;
    assign b_type = beq ? `B_beq : 4'b1111 ;
    
    /// D
    assign ALUControl = (subu == 1'b1)? `ALU_sub
                       :(and_ == 1'b1)? `ALU_and
                       :(ori == 1'b1)?  `ALU_or
                       :(lui == 1'b1)?  `ALU_lui
                       :(sll == 1'b1)?  `ALU_sll
                       :(slt == 1'b1)?  `ALU_slt
                       : `ALU_add   ;
    assign BSel = (CAL_R )? `ScrB_RD2 
                 :(CAL_I | LOAD | STORE) ? `ScrB_EXT 
                 : `ScrB_RD2  ;

    /// M
    assign  DMtype = ( lw | sw )? `bit_w
                  : ( lh | sh )? `bit_h
                  : ( lb | sb )? `bit_b 
                  :  `bit_w  ; 
    assign  DMWr = STORE;

    /// W
    assign WDSel = (LOAD )? `WD_load
                  :(j_link )? `WD_addr_jalX
                  : `WD_ALU  ; 
    assign RFWr = !(!A3);
    assign A3 = ( CAL_R | jalr )? rd
                : ( CAL_I | LOAD )? rt
                : ( jal ) ? 5'd31 
                : 5'd0 ;

    assign A3Sel = ( CAL_R | jalr )? `a3_rd
                : ( CAL_I | LOAD )?  `a3_rt
                : ( jal ) ? `a3_31
                : `a3_0;
    
    
endmodule