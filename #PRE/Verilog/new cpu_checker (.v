module cpu_checker (
    input clk,
    input reset,
    input [7:1] char,
    output  [1:0] format_type
);
`define s0 4'd0
`define s1 4'd1
`define s2 4'd2
`define s3 4'd3
`define s4 4'd4
`define s5 4'd5
`define s6 4'd6
`define s7 4'd7
`define s8 4'd8
`define s9 4'd9
`define s10 4'd10
`define s11 4'd11
`define s12 4'd12
`define s13 4'd13
`define s14 4'd14

`define  YES  1'b1
`define  NO  1'b0

wire digit = (char >= "0" && char <= "9") ? `YES : `NO;
wire hexdigit = (digit == `YES) ? `YES :
                (char >= "a" && char <= "f") ? `YES : `NO;

    reg [3:0]  status;
   reg [2:0]  numDec;  
    reg [3:0]  numHex;
    reg typeReg; 

    initial begin
        state<=`s0;
    end

    assign format_type = (status != `s14) ? 2'b00 :
                    ((typeReg == 1'b0) ? 2'b01 : 2'b10) ;
    
    initial begin
        state<=`s0;
        numDec<=3'd0;
        numHex<=4'd0;
    end
    
    always @(posedge clk ) begin
        if(reset) begin
            state<=`s0;
            numDec<=3'd0;
            numHex<=4'd0;
        end

        else begin
            case(state)
            `s0:begin
                if(char=="^")
                    state<=`s1;
                else   
                    state<=`s0;
            end

            `s1:begin
                if(char=="^")
                    state<=`s1;
                else if(digit)begin
                    state<=`s2;
                    numDec<=3'd2;  //因为这个的状态设计，读入第一个数就是第一个状态，跳到后面的状态就是从2开始计数
                end
                else   
                    state<=`s0;
            end

            `s2:begin
                if(char=="^")
                    state<=`s1;
                else of(char=="@")
                    state<=`s3;
                else if(digit) begin
                    numDec<=numDec+3'd1;
                    if(numDec<=3'd4) 
                        state<=`s2;
                    else  begin
                        state<=`s0;
                        numDec<=3'd0;
                    end
                end
                else   
                    state<=`s0;
            end

            `s3: begin
                if(char=="^")
                    state<=`s1;
                else if(hexdigit)  begin
                    state<=`s4;
                    numHex<=4'd2;
                end
                else   
                    state<=`s0;
            end

            `s4:begin
                if(char=="^")
                    state<=`s1;
                else of(char==":") begin
                    if(numHex==4'd8)
                        state<=`s5;
                    else  begin
                        state<=`s0;
                        numHex<=4'd0;
                    end
                end
                else if(hexdigit) begin
                    numHex<=numHex+4'd1;
                    if(numHex<=4'd8) 
                        state<=`s4;
                    else  begin
                        state<=`s0;
                        numHex<=4'd0;
                    end
                end
                else   
                    state<=`s0;
            end

            `s5:begin
                if(char=="^")
                    state<=`s1;
                else if(char==" ")
                    state<=`s5;
                else if(char=="$") begin
                    typeReg<=0;
                    state<=`s6;
                end
                else if(char=="*") begin
                    typeReg<=1;
                    state<=`s7;
                end
                else   
                    state<=`s0;
            end
            
            `s6:begin
                if(char=="^")
                    state<=`s1;
                else if(digit)begin
                    state<=`s8;
                    numDec<=3'd2;
                end
                else   
                    state<=`s0;
            end

            `s7:begin
                if(char=="^")
                    state<=`s1;
                else if(hexdigit)begin
                    state<=`s9;
                    numHex<=4'd2;
                end
                else   
                    state<=`s0;
            end

             `s8:begin
                if(char=="^")
                    state<=`s1;
                else if(char=="<")
                    state<=`s11;
                else if(char==" ")
                    state<=`s10;
                else if(digit) begin
                    numDec<=numDec+3'd1;
                    if(numDec<=3'd4) 
                        state<=`s8;
                    else  begin
                        state<=`s0;
                        numDec<=3'd0;
                    end
                end
                else   
                    state<=`s0;
            end

            `s9: begin
                if(char=="^")
                    state<=`s1;
                else if(char==" "||char=="<") begin
                    if(numHex==4'd8) begin
                        if(char==" ")  state<=`s10;
                        else if(char=="*")   state<=`s11;
                    end
                    else  begin
                        state<=`s0;
                        numHex<=4'd0;
                    end
                end
                else if(hexdigit) begin
                    numDec<=numDec+4'd1;
                    if(numDec<=4'd8) 
                        state<=`s9;
                    else  begin
                        state<=`s0;
                        numDec<=4'd0;
                    end
                end
                else   
                    state<=`s0;
            end
            
            `s10:begin
                if(char=="^")
                    state<=`s1;
                else if(char==" ")
                    state<=`s10;
                else if(char=="<")
                    state<=`s11;
                else   
                    state<=`s0;
            end

            `s11:begin
                if(char=="^")
                    state<=`s1;
                else if(char=="=")
                    state<=`s12;
                else   
                    state<=`s0;
            end

            `s12:begin
                if(char=="^")
                    state<=`s1;
                else if(char==" ")
                    state<=`s12;
                else if(hexdigit) begin
                    state<=`s13;
                    numHex<=4'd2;
                end
                else   
                    state<=`s0;
            end

            `s13:begin
                if(char=="^")
                    state<=`s1;
                else of(char=="#") begin
                    if(numHex==4'd8)
                        state<=`s14;
                    else  begin
                        state<=`s0;
                        numHex<=4'd0;
                    end
                end
                else if(hexdigit) begin
                    numHex<=numHex+4'd1;
                    if(numHex<=4'd8) 
                        state<=`s13;
                    else  begin
                        state<=`s0;
                        numHex<=4'd0;
                    end
                end
                else   
                    state<=`s0;
            end

            `s14:begin
                if(char=="^")
                    state<=`s1;
                else 
                    state<=`s0;
            end
            
            default:  state<=`s0;
        end
    end