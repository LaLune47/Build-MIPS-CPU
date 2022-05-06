module code (
    input Clk,
    input Reset,
    input Slt,
    input En,
    output reg [63:0] Output0,
    output reg [63:0] Output1
);

reg [1:0] count=2'b00;

always @(posedge Clk) begin
    if (Reset==1'b1) begin
        Output0<=64'h00000000;
        Output1<=64'h00000000;
        count<=2'b01;
    end

    else if(En==1'b1) begin
        if(Slt==1'b0) begin
            Output0<=Output0+64'h00000001;
            Output1<=Output1; 
        end

        else  begin
            count<=count+2'b01;
            if(count==2'b00) begin
                Output1<=Output1+64'h00000001;
                Output0<=Output0;
            end
				
				else  begin
                Output1<=Output1;
                Output0<=Output0;				
				end
        end
    end

    else begin
        Output1<=Output1;
        Output0<=Output0;
    end
end

endmodule