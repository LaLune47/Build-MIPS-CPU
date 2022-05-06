
// Br
`define NPC_pc4  3'b000
`define NPC_branch  3'b001
`define NPC_26  3'b010
`define NPC_reg  3'b011

// b_type
`define B_beq   4'b0000

// EXTop
`define EXT_zero   1'b0
`define EXT_sign   1'b1

//ALUcontrol
`define ALU_add  4'b0000
`define ALU_sub  4'b0001
`define ALU_and  4'b0010
`define ALU_or   4'b0011
`define ALU_lui  4'b0100
`define ALU_sll  4'b0101
`define ALU_slt  4'b0110

//Bsel
`define ScrB_RD2  1'b1
`define ScrB_EXT  1'b0

// DMtype
`define bit_w   3'b000
`define bit_h   3'b001
`define bit_b   3'b010

// A3Sel
`define a3_rt    3'b000
`define a3_rd    3'b001
`define a3_31   3'b010
`define a3_0    3'b011

// WDSel
`define WD_ALU  3'b000
`define WD_load  3'b001
`define WD_addr_jalX  3'b010

// fwd
`define  F_zero           4'd0
`define  FtoD_D_original  4'd1
`define  FtoE_E_original  4'd2
`define  FtoM_M_original  4'd3
`define  FfromE           4'd4
`define  FfromM           4'd5
`define  FfromW           4'd6