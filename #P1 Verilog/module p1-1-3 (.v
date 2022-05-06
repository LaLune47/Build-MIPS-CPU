module p1-1-3 (
    input clk,
    inout reset,
    input [7:0] in,
    output out
);
parameter  emptyStr= 3'd0;
parameter  number_1= 3'd1;
parameter  op_1=  3'd2;
parameter equal = 3'd3;
parameter number_2 = 3'd4;
parameter op_2 = 3'd5;
parameter fail = 3'd6;

reg [2:0] state;

initial begin
    state<=emptyStr;
end

always @(posedge clk ,posedge reset) begin
    if(reset)begin
        state<=emptyStr;
    end


    else   begin
    case(state)
    emptyStr:begin
        if(in<="9"&&in>="0")
            state<=number_1;
        else if(in==" ")
            state<=emptyStr;
        else if(in=="+"||in=="-"||in=="*"||in=="/"||in=="=")
            state<=fail;
        else 
            state<=fail;
    end
    
    number_1:begin
        if(in=="+"||in=="-"||in=="*"||in=="/")
            state<=op_1;
        else if(in<="9"&&in>="0")
            state<=fail;
        else if(in=="")
            state<=number_1;
        else if(in=="=")
            state<=equal;
        else 
            state<=fail;
    end
    
    op_1:begin
        if(in<="9"&&in>="0")
            state<=number_1;
        else if(in==" ")
            state<=op_1;
        else if(in=="+"||in=="-"||in=="*"||in=="/"||in=="=")
            state<=fail;
        else state<=fail;
    end

    equal:begin
        if(in<="9"&&in>="0")
            state<=number_2;
        else  if(in=="+"||in=="-"||in=="*"||in=="/"||in=="=")
            state<=fail;
        else  if(in==" ")
            state<=equal;
        else   state<=fail;
    end

    number_2:begin
        if(in=="+"||in=="-"||in=="*"||in=="/")
            state<=op_2;
        else if(in<="9"&&in>="0")
            state<=fail;
        else if(in=="")
            state<=number_2;
        else if(in=="=")
            state<=equal;
        else 
            state<=fail;
    end

    op_2:begin
        if(in<="9"&&in>="0")
            state<=number_2;
        else if(in==" ")
            state<=op_2;
        else if(in=="+"||in=="-"||in=="*"||in=="/"||in=="=")
            state<=fail;
        else state<=fail;
    end

    fail:state<=fail;
    
    default:state<=fail;
    endcase
    end
end
 
assign  out = (state==number_2)?1'b1:1'b0;

endmodule