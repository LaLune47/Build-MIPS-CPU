`timescale 1ns / 1ps
`include "macro.v"

module MULT_DIV(
    input clk,
    input reset,

    input [31:0] RS,
    input [31:0] RT,

    input [3:0] type,

    output MDstall,
    output [31:0] MD_out
);

    reg [31:0] HI, LO , HItmp, LOtmp ;
    reg [3:0] state;
    
    wire start = (type==`MD_div)|(type==`MD_divu)|(type==`MD_mult)|(type==`MD_multu);
    reg busy;

    assign MDstall = busy | start;
    assign MD_out = (type==`MD_mfhi) ? HI 
                  : (type==`MD_mflo) ? LO
                  : 32'd0;

    initial begin
        HI <= 32'd0 ;
        LO <= 32'd0 ;
        HItmp <= 32'd0 ;
        LOtmp <= 32'd0 ;
        state <= 4'd0 ;
        busy  <= 1'd0 ;
    end

    wire [32:0] rs = { 1'd0 , RS };
    wire [32:0] rt = { 1'd0 , RT };
    reg [1:0]  space ;

    always @(posedge clk ) begin
        if(reset) begin
        HI <= 32'd0 ;
        LO <= 32'd0 ;
        HItmp <= 32'd0 ;
        LOtmp <= 32'd0 ;
        state <= 4'd0 ;
        busy  <= 1'd0 ;
        space <= 2'd0 ;
        end
        
        else  begin
            if(state == 4'd0) begin
                case(type)                 
                    `MD_mult:  begin
                        busy <= 1'd1 ;
                        state <= 4'd5;
                        {HItmp, LOtmp} <= $signed(RS)*$signed(RT);
                        HI <= HI ;
                        LO <= LO ;
                    end
                    `MD_multu: begin
                        busy <= 1'd1 ;
                        state <= 4'd5;
                        { space , HItmp, LOtmp} <= $signed(rs)*$signed(rt);
                        HI <= HI ;
                        LO <= LO ;
                    end
                    `MD_div: begin
                        busy <= 1'd1 ;
                        state <= 4'd10;
                        LOtmp <= $signed(RS) / $signed(RT);
                        HItmp <= $signed(RS) % $signed(RT);
                        HI <= HI ;
                        LO <= LO ;
                    end
                    `MD_divu: begin
                        busy <= 1'd1 ;
                        state <= 4'd10;
                        LOtmp <= $signed(rs) / $signed(rt);
                        HItmp <= $signed(rs) % $signed(rt);
                        HI <= HI ;
                        LO <= LO ;
                    end
                    `MD_mthi: begin 
                        HI <= RS ; 
                        LO <= LO ;
                        HI <= HItmp ;
                        LO <= LOtmp ;
                    end
                    `MD_mtlo:  begin 
                        LO <= RS ;
                        HI <= HI ;
                        HI <= HItmp ;
                        LO <= LOtmp ;
                    end
                    4'b1111 : begin
                        HI <= HI;
                        LO <= LO;
                        HI <= HItmp ;
                        LO <= LOtmp ;
                    end
                endcase
            end
            
            else if (state == 4'd1) begin
                busy <= 1'd0;
                state <= 4'd0;
                HI <= HItmp;
                LO <= LOtmp;
            end

            else  begin
                state <= state - 4'd1 ;
                HI <= HI;
                LO <= LO;
                HI <= HItmp ;
                LO <= LOtmp ;
            end
        end
    end
				
endmodule