`timescale 1ns / 1ps
module mips (
    input clk,
    input reset
);
    wire [31:0]  pc, npc, PC_4 ,RD1, RD2, Instr, ALUin, ALUout, EXTout;
    wire [25:0] imm26;
    wire [4:0] shamt, rs, rt, rd;
    wire [15:0] imm16; 

    wire ALUequal, ALUgreater, ALUless;

    wire PCSrc;
    wire RegWrite;
    wire [3:0] ALU_C;
    wire [2:0] Br;
    wire [2:0] DM_bit_type;
    wire MemWrite;
    wire EXTOp;
    wire [2:0] A3Sel;
    wire [2:0] WDSel;
    wire BSel;

    wire isBeq;
    wire isSlt;

    wire [31:0] DM_origin;
    wire [31:0] in_DM;
    wire [31:0] DMout;

    wire [4:0] RegAddr;
    wire [31:0] RegData;
    wire [9:0] MemAddr;
    assign MemAddr = ALUout[11:2];


//模块实例化时，前面是模块端口，后面是总电路导线wire
    NPC my_NPC(
            .pc(pc),
            .Br(Br),
            .imm16(imm16),
            .imm26(imm26),
            .RD1(RD1),
            .PCSrc(PCSrc),
            .PC_4(PC_4),
            .npc(npc));

    PC_IM  my_PC_IM (
		.clk(clk), 
		.reset(reset), 
		.npc(npc), 
		.pc(pc), 
		.Instr(Instr), 
		.shamt(shamt), 
		.rs(rs), 
		.rt(rt), 
		.rd(rd), 
		.imm16(imm16), 
		.imm26(imm26)
	);
    
    GRF my_GRF (
    .clk(clk), 
    .reset(reset), 
    .pc(pc), 
    .RegWrite(RegWrite), 
    .a1(rs), 
    .a2(rt), 
    .a3(RegAddr), 
    .WD(RegData), 
    .RD1(RD1), 
    .RD2(RD2)
    );

    ALU my_ALU (
    .ALUControl(ALU_C), 
    .shamt(shamt), 
    .ScrA(RD1), 
    .ScrB(ALUin), 
    .ALUout(ALUout), 
    .ALUequal(ALUequal), 
    .ALUgreater(ALUgreater), 
    .ALUless(ALUless)
    );
    
    IN_DM  my_IN_DM (
    .addr(ALUout), 
    .bit_type(DM_bit_type), 
    .NewData(RD2), 
    .OldData(DM_origin), 
    .in_DM(in_DM)
    );

    DM  my_DM (
    .pc(pc), 
    .WE(MemWrite), 
    .addr(ALUout), 
    .A(MemAddr), 
    .WD(in_DM), 
    .clk(clk), 
    .reset(reset), 
    .RD(DM_origin)
    );
    
    OUT_DM  my_OUT_DM (
    .addr(ALUout), 
    .bit_type(DM_bit_type), 
    .data(DM_origin), 
    .OUT_DM(DMout)
    );

    EXT my_EXT (
    .imm16(imm16), 
    .EXTOp(EXTOp), 
    .EXTout(EXTout)
    );
    
    CU my_CU (
    .Instr(Instr), 
    .Br(Br), 
    .A3Sel(A3Sel), 
    .WDSel(WDSel), 
    .RFWr(RegWrite), 
    .EXTop(EXTOp), 
    .BSel(BSel), 
    .DMWr(MemWrite), 
    .ALUControl(ALU_C), 
    .DMtype(DM_bit_type), 
    .isBeq(isBeq), 
    .isSlt(isSlt)
    );
    
    // wiring the wires  (MUX in CPU)
    assign PCSrc = ALUequal & isBeq ;

    assign RegAddr = (A3Sel == 3'b000)? rt 
                    :(A3Sel == 3'b001)? rd
                    :(A3Sel == 3'b010)? 5'b11111
                    : 5'd0 ;
    
    wire judge_slt;
    assign RegData = (WDSel == 3'b000)? ALUout
                    :(WDSel == 3'b001)? DMout
                    :(WDSel == 3'b010)? PC_4
                    :(WDSel == 3'b011)? judge_slt
                    :  32'd0  ;
    assign judge_slt = ((ALUless == 1'b1) && (isSlt == 1'b1))? 32'b1 : 32'b0 ;

    assign ALUin = (BSel == 1'b1) ? EXTout : RD2 ;


endmodule