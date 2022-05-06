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
   
    output [3:0] MD_Control,
    
    output [3:0] ALUControl,
    output BSel,
   
    output [2:0] DMtype,
    output [2:0] OP_LOAD,
    output DMWr,


  //  output [2:0] A3Sel,
    output [2:0] WDSel,
    output RFWr,
    output [4:0] A3,
    output [2:0] A3Sel,
    
    //type
    output shift_s,
    output shift_v,
    output md,
    output mt,
    output mf,
    
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
    parameter OP_BNE = 6'b000101;
    parameter OP_BLEZ = 6'b000110;
    parameter OP_BGTZ = 6'b000111;
    parameter OP_BLTZ = 6'b000001;
    parameter OP_BGEZ = 6'b000001;
    parameter RT_BLEZ = 5'b00000;
    parameter RT_BGTZ = 5'b00000;
    parameter RT_BLTZ = 5'b00000;
    parameter RT_BGEZ = 5'b00001;

    parameter OP_SW  = 6'b101011; ///////// S
    parameter OP_SH  = 6'b101001;
    parameter OP_SB  = 6'b101000;

    parameter OP_LW  = 6'b100011; ////////  L
    parameter OP_LH  = 6'b100001;
    parameter OP_LB  = 6'b100000;
    parameter OP_LHU  = 6'b100101;
    parameter OP_LBU  = 6'b100100;

    parameter OP_J  = 6'b000010;   ///////  j_26
    parameter OP_JAL  = 6'b000011;
    
    parameter FUNC_JR = 6'b001000;      ///////  j_r
    parameter FUNC_JALR= 6'b001001 ;
    

    parameter OP_ORI  = 6'b001101;  /////  cal_i
    parameter OP_LUI  = 6'b001111;

    parameter OP_ADDIU  = 6'b001001;
    parameter OP_ADDI = 6'b001000;

    parameter OP_ANDI = 6'b001100;
    parameter OP_XORI = 6'b001110;

    parameter OP_SLTI = 6'b001010;
    parameter OP_SLTIU = 6'b001011;


    parameter FUNC_ADDU = 6'b100001;  /////cal_R
    parameter FUNC_ADD = 6'b100000;
    parameter FUNC_SUBU = 6'b100011 ;
    parameter FUNC_SUB = 6'b100010 ;

    parameter FUNC_AND = 6'b100100;
    parameter FUNC_OR = 6'b100101;
    parameter FUNC_XOR = 6'b100110;
    parameter FUNC_NOR = 6'b100111;

    parameter FUNC_SLL = 6'b000000;
    parameter FUNC_SLLV = 6'b000100;
    parameter FUNC_SRA = 6'b000011;
    parameter FUNC_SRAV = 6'b000111;
    parameter FUNC_SRL = 6'b000010;
    parameter FUNC_SRLV = 6'b000110;

    parameter FUNC_SLT = 6'b101010;
    parameter FUNC_SLTU = 6'b101011;


    parameter FUNC_MULT = 6'b011000 ;        // R_ md
    parameter FUNC_MULTU = 6'b011001 ;
    parameter FUNC_DIV = 6'b011010 ;
    parameter FUNC_DIVU = 6'b011011 ;

    parameter FUNC_MTHI = 6'b010001 ;        // R_ mt
    parameter FUNC_MTLO = 6'b010011 ;

    parameter FUNC_MFHI = 6'b010000 ;        // R_ mf
    parameter FUNC_MFLO = 6'b010010 ;

////////////////////////////////////////////////////////////////////////////////////

    // wires instruction
    //B
    wire beq = (opcode == OP_BEQ)? 1'b1 : 1'b0;
    wire bne = (opcode == OP_BNE)? 1'b1 : 1'b0;
    wire blez = (opcode == OP_BLEZ && rt == RT_BLEZ )? 1'b1 : 1'b0;
    wire bgtz = (opcode == OP_BGTZ && rt == RT_BGTZ )? 1'b1 : 1'b0;
    wire bltz = (opcode == OP_BLTZ && rt == RT_BLTZ )? 1'b1 : 1'b0;
    wire bgez = (opcode == OP_BGEZ && rt == RT_BGEZ )? 1'b1 : 1'b0;

    //S 
    wire sw = (opcode == OP_SW)? 1'b1 : 1'b0;   
    wire sh = (opcode == OP_SH)? 1'b1 : 1'b0;
    wire sb = (opcode == OP_SB)? 1'b1 : 1'b0; 
    //L
    wire lw = (opcode == OP_LW)? 1'b1 : 1'b0;  
    wire lh = (opcode == OP_LH)? 1'b1 : 1'b0;
    wire lb = (opcode == OP_LB)? 1'b1 : 1'b0; 
    wire lhu = (opcode == OP_LHU)? 1'b1 : 1'b0; 
    wire lbu = (opcode == OP_LBU)? 1'b1 : 1'b0; 


    //j_26
    wire j = (opcode == OP_J)? 1'b1 : 1'b0;
    wire jal = (opcode == OP_JAL)? 1'b1 : 1'b0; 
    //j_r
    wire jr = (opcode == 6'd0 && func == FUNC_JR)? 1'b1 : 1'b0 ;
    wire jalr = (opcode == 6'd0 && func == FUNC_JALR)? 1'b1 : 1'b0 ;
    

    //cal_i 
    wire lui = (opcode == OP_LUI)? 1'b1 : 1'b0;

    wire addiu = (opcode == OP_ADDIU)? 1'b1 : 1'b0; 
    wire addi = (opcode == OP_ADDI)? 1'b1 : 1'b0; 

    wire andi = (opcode == OP_ANDI)? 1'b1 : 1'b0; 
    wire xori = (opcode == OP_XORI)? 1'b1 : 1'b0; 
    wire ori = (opcode == OP_ORI)? 1'b1 : 1'b0; 
    
    wire slti = (opcode == OP_SLTI)? 1'b1 : 1'b0; 
    wire sltiu = (opcode == OP_SLTIU)? 1'b1 : 1'b0; 


    //cal R
    wire addu = (opcode == 6'd0 && func == FUNC_ADDU)? 1'b1 : 1'b0 ;
    wire add = (opcode == 6'd0 && func == FUNC_ADD)? 1'b1 : 1'b0 ;
    wire subu = (opcode == 6'd0 && func == FUNC_SUBU)? 1'b1 : 1'b0 ;
    wire sub = (opcode == 6'd0 && func == FUNC_SUB)? 1'b1 : 1'b0 ;

    wire sll = (opcode == 6'd0 && func == FUNC_SLL)? 1'b1 : 1'b0 ;
    wire sllv = (opcode == 6'd0 && func == FUNC_SLLV)? 1'b1 : 1'b0 ;
    wire sra = (opcode == 6'd0 && func == FUNC_SRA)? 1'b1 : 1'b0 ;
    wire srav = (opcode == 6'd0 && func == FUNC_SRAV)? 1'b1 : 1'b0 ;
    wire srl = (opcode == 6'd0 && func == FUNC_SRL)? 1'b1 : 1'b0 ;
    wire srlv = (opcode == 6'd0 && func == FUNC_SRLV)? 1'b1 : 1'b0 ;

    wire and_ = (opcode == 6'd0 && func == FUNC_AND)? 1'b1 : 1'b0 ;
    wire or_ = (opcode == 6'd0 && func == FUNC_OR)? 1'b1 : 1'b0 ;
    wire xor_ = (opcode == 6'd0 && func == FUNC_XOR)? 1'b1 : 1'b0 ;
    wire nor_ = (opcode == 6'd0 && func == FUNC_NOR)? 1'b1 : 1'b0 ;

    wire slt = (opcode == 6'd0 && func == FUNC_SLT)? 1'b1 : 1'b0;
    wire sltu = (opcode == 6'd0 && func == FUNC_SLTU)? 1'b1 : 1'b0;
    
    
    // md
    wire  mult = (opcode == 6'd0 && func == FUNC_MULT )? 1'b1 : 1'b0 ;
    wire  multu = (opcode == 6'd0 && func == FUNC_MULTU )? 1'b1 : 1'b0 ;
    wire  div = (opcode == 6'd0 && func == FUNC_DIV )? 1'b1 : 1'b0 ;
    wire  divu = (opcode == 6'd0 && func == FUNC_DIVU )? 1'b1 : 1'b0 ;
    // mt
    wire  mtlo = (opcode == 6'd0 && func == FUNC_MTLO )? 1'b1 : 1'b0 ;
    wire  mthi = (opcode == 6'd0 && func == FUNC_MTHI )? 1'b1 : 1'b0 ;
    // mf
    wire  mflo = (opcode == 6'd0 && func == FUNC_MFLO )? 1'b1 : 1'b0 ;
    wire  mfhi = (opcode == 6'd0 && func == FUNC_MFHI )? 1'b1 : 1'b0 ;


 

    //TYPE
    assign BRANCH = beq | bne | blez | bgtz | bltz | bgez;
    assign STORE =  sw | sh | sb ;
    assign LOAD =   lw | lh | lb | lhu | lbu ;

    assign CAL_R  = ( addu | subu | add | sub ) | ( and_ | or_ | xor_ | nor_) | ( sll | sra | srl) | (sllv|srav|srlv) | (slt|sltu);
    assign CAL_I  =  lui | ( addiu | addi ) | (ori | andi| xori ) | ( slti|sltiu );
    
    assign j_26  = j | jal ;
    assign j_reg = jr |jalr ;
    assign j_link = jal | jalr ;

    assign shift_s = sll | sra | srl ;
    assign shift_v = sllv | srav |srlv ;
    
    assign md = mult | multu | div | divu ;
    assign mt = mtlo | mthi ;
    assign mf = mflo | mfhi ;
    
///////////////////////////////////////////////////////////////////////////////////   control
    /// D
    assign EXTop = ( STORE | LOAD | addiu | addi | slti | sltiu)? `EXT_sign : `EXT_zero ;
    //  zero : andi | ori | xori ;
    
    assign Br = (BRANCH == 1'b1)? `NPC_branch
               : j_26  ? `NPC_26
               : j_reg ? `NPC_reg
               : `NPC_pc4  ;
    assign b_type = beq ? `B_beq 
                   : bne ? `B_bne
                   : blez ? `B_blez
                   : bgtz ? `B_bgtz
                   : bltz ? `B_bltz
                   : bgez ? `B_bgez
                   : 4'b1111 ;
    
    /// D
    assign ALUControl = (subu | sub )? `ALU_sub
                       :(and_ | andi)? `ALU_and
                       :(ori  | or_ )?  `ALU_or
                       :(lui == 1'b1)?  `ALU_lui
                       
                       :(sll == 1'b1)?  `ALU_sll
                       :(sllv == 1'b1)?  `ALU_sllv
                       :(sra == 1'b1)?  `ALU_sra
                       :(srav == 1'b1)?  `ALU_srav
                       :(srl == 1'b1)?  `ALU_srl
                       :(srlv == 1'b1)?  `ALU_srlv

                       :(slt  | slti )?  `ALU_slt
                       :(sltu | sltiu)?  `ALU_sltu
                       :(xor_ | xori )?  `ALU_xor
                       :( nor_ )?  `ALU_nor
                       : `ALU_add   ;


    assign BSel = (CAL_R )? `ScrB_RD2 
                 :(CAL_I | LOAD | STORE) ? `ScrB_EXT 
                 : `ScrB_RD2  ;

    assign MD_Control = (mult) ? `MD_mult
                       :(multu) ? `MD_multu
                       :(div) ? `MD_div
                       :(divu) ? `MD_divu
                       :(mtlo) ? `MD_mtlo
                       :(mthi) ? `MD_mthi 
                       :(mflo) ? `MD_mflo
                       :(mfhi) ? `MD_mfhi
                       :4'b1111 ;

    /// M
    assign  DMtype = ( sw )? `bit_w
                  : (  sh )? `bit_h
                  : (  sb )? `bit_b 
                  :  `bit_error  ; 
                  
    assign  DMWr = STORE;
    assign  OP_LOAD = ( lw ) ? `E_L_no
                     :( lbu ) ? `E_L_unsign_b 
                     :( lb ) ?  `E_L_sign_b 
                     :( lhu ) ?  `E_L_unsign_h
                     :( lh ) ? `E_L_sign_h
                     : `E_L_error ;

    /// W
    assign WDSel = (LOAD )? `WD_load
                  :(j_link )? `WD_addr_jalX
                  :( mf ) ? `WD_MuxDiv 
                  : `WD_ALU  ; 

    assign RFWr = !(!A3);
    
    assign A3 = ( CAL_R | jalr | mf )? rd
                : ( CAL_I | LOAD )? rt
                : ( jal ) ? 5'd31 
                : 5'd0 ;

endmodule