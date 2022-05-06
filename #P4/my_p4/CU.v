`timescale 1ns / 1ps
module CU (
    input [31:0] Instr,
    
    output [2:0] Br,
    output [2:0] A3Sel,
    output [2:0] WDSel,
    output RFWr,
    output EXTop,
    output BSel,
    output DMWr,
    output [3:0] ALUControl,
    output [2:0] DMtype,

    output isBeq,
    output isSlt
);
    // 2 cuts, meaningful code
    wire [5:0] func;
    wire [5:0] opcode;

    // instructions_number
    parameter OP_BEQ = 6'b000100;
    
    parameter OP_SW  = 6'b101011;
    parameter OP_SH  = 6'b101001;
    parameter OP_SB  = 6'b101000;

    parameter OP_LW  = 6'b100011;
    parameter OP_LH  = 6'b100001;
    parameter OP_LB  = 6'b100000;

    parameter OP_J  = 6'b000010;
    parameter OP_JAL  = 6'b000011;

    parameter OP_ORI  = 6'b001101;
    parameter OP_LUI  = 6'b001111;
    parameter OP_ADDIU  = 6'b001001;

    parameter FUNC_ADDU = 6'b100001;
    parameter FUNC_SUBU = 6'b100011 ;
    parameter FUNC_SLL = 6'b000000;
    parameter FUNC_JR = 6'b001000;
    parameter FUNC_AND = 6'b100100;
    parameter FUNC_SLT = 6'b101010;
    parameter FUNC_JALR= 6'b001001 ;
    
    assign func = Instr[5:0];
    assign opcode = Instr[31:26];

    // wires instruction
    wire  beq,  sw,sh,sb,  lw,lh,lb,  j,jal,   ori,lui,addiu   ,addu,subu,sll,jr,and_,slt,jalr; // and : can't use
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

    //
    assign isBeq = (opcode == OP_BEQ)? 1'b1 : 1'b0;
    assign isSlt = (opcode == 6'd0 && func == FUNC_SLT)? 1'b1 : 1'b0 ;
   
    //TYPE
    wire BRANCH;
    wire STORE;
    wire LOAD;
    wire R;
    assign BRANCH = (beq == 1'b1)? 1'b1 : 1'b0 ;
    assign STORE =  ((sw == 1'b1)||(sh == 1'b1)||(sb == 1'b1))? 1'b1 : 1'b0 ;
    assign LOAD =  ((lw == 1'b1)||(lh == 1'b1)||(lb == 1'b1))? 1'b1 : 1'b0 ;
    assign R =  (opcode == 6'd0)? 1'b1 : 1'b0 ;
    


    //ALUControl
    assign ALUControl = (subu == 1'b1)? 4'b0001 
                       :(and_ == 1'b1)? 4'b0010
                       :(ori == 1'b1)? 4'b0011
                       :(lui == 1'b1)? 4'b0100
                       :(sll == 1'b1)? 4'b0101  
                       : 4'b0000   ;
    
    //Br   select PC
    assign Br = (beq == 1'b1)? 3'b001
               :(j == 1'b1)? 3'b010
               :(jal == 1'b1)? 3'b011
               :(jr == 1'b1)? 3'b100
               :(jalr == 1'b1)? 3'b101
               : 3'b000  ;

    //A3Sel     select of A3 of GRF
    assign A3Sel = (R == 1'b1)? 3'b001
                  :(jal == 1'b1)? 3'b010
                  : 3'b000  ;
    
    //WDSel     select of WriteData of GRF
    assign WDSel = (LOAD == 1'b1)? 3'b001
                  :(jal == 1'b1 || jalr == 1'b1)? 3'b010
                  :(slt == 1'b1)? 3'b011
                  : 3'b000  ; 

    //RFWr       GRF write enable(not + or)
    assign RFWr = ((STORE == 1'b1)||(BRANCH == 1'b1)||(jr == 1'b1)||(j == 1'b1))? 1'b0 : 1'b1 ;
    
   //EXTop     signed ~ yes
   assign EXTop = ((STORE == 1'b1)||(LOAD == 1'b1)||(addiu == 1'b1))? 1'b1 : 1'b0 ;

   //BSel     select ScrB of ALU / not use imm as B(not + or)
   assign BSel = ((R == 1'b1)||(BRANCH == 1'b1)||(j == 1'b1)||(jal == 1'b1))? 1'b0 : 1'b1 ;
   
   //DMWr   DM enabled
   assign  DMWr = STORE;

   //DMtype
   assign  DMtype =(lh == 1'b1 || sh == 1'b1)? 3'b001
                  :(lb == 1'b1 || sb == 1'b1)? 3'b010
                  : 3'b000  ; 

endmodule