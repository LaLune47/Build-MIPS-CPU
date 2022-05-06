`define emptyStr 2'b00
`define number   2'b01
`define op       2'b10
`define fault    2'b11

module string(
    input clk,
    input clr,
    input [7:0] in,
    output out
);
   
   reg  [1:0]  state;
   initial begin
       state<=`emptyStr;
   end

    always @(posedge clk , posedge clr) begin
        if(clr==1'b1)   state<=`emptyStr;
        
        else begin
            case(state)
                `emptyStr:  begin 
                    if(in<="9"&&in>="0")   state<=`number;
                    else  state<=`fault;
                end

                `number:    begin
                    if(in=="+"||in=="*")   state<=`op;
                    else  state<=`fault;
                end

                `op:   begin
                    if(in<="9"&&in>="0")   state<=`number;
                    else  state<=`fault;
                end

                `fault: state<=`fault;
            endcase
        end

    end
    
    assign  out = (state==`number) ? 1'b1 : 1'b0 ;

endmodule