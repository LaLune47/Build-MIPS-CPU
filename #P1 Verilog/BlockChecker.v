`define other    4'd0

`define b_begin  4'd1
`define e_begin  4'd2
`define g_begin  4'd3
`define i_begin  4'd4
`define n_begin  4'd5

`define e_end    4'd6
`define n_end    4'd7
`define d_end    4'd8

`define block  4'd9

`define d_end_wrong  4'd10  //设置一个wire，wire本质也是随着num变化的，根本就是无效变量；必须还是设置一个状态！！这样才可以利用memory功能
`define wrong  4'd11

module BlockChecker (
    input clk,
    input reset, //异步
    input [7:0] in,
    output result
);
    reg [31:0] num_Begin;
    reg [31:0] num_End;
    reg [3:0] state;

    initial begin
        num_Begin<=32'd0;
        num_End<=32'd0;
        state<=`block;
    end

    always @(posedge clk,posedge reset) begin
        if(reset == 1'b1)  begin
            num_Begin<=32'd0;
            num_End<=32'd0;
            state<=`block;
        end

        else begin
            case(state)
               `other: begin
                    if(in==" ")  state<=`block;
                    else  state<=`other;
               end
               
               `block: begin
                    if(in=="b"||in=="B")  state<=`b_begin;
                    else if(in=="e"||in=="E")  state<=`e_end;
                    else if(in==" ")  state<=`block;
                    else  state<=`other;
               end

               `b_begin: begin
                    if(in=="e"||in=="E")  state<=`e_begin;
                    else if(in==" ")  state<=`block;
                    else  state<=`other;
               end

                `e_begin: begin
                    if(in=="g"||in=="G")  state<=`g_begin;
                    else if(in==" ")  state<=`block;
                    else  state<=`other;
               end

                `g_begin: begin
                    if(in=="i"||in=="I")  state<=`i_begin;
                    else if(in==" ")  state<=`block;
                    else  state<=`other;
               end

                `i_begin: begin
                    if(in=="n"||in=="N") begin 
                        state<=`n_begin;
                        num_Begin<=num_Begin+32'd1;
                    end
                    else if(in==" ")  state<=`block;
                    else  state<=`other;
               end

               `n_begin: begin
                    if(in==" ")  state<=`block;
                    else begin
                        num_Begin<=num_Begin-32'd1;
                        state<=`other;
                    end 
               end

                `e_end: begin
                    if(in=="n"||in=="N")  state<=`n_end;
                    else if(in==" ")  state<=`block;
                    else  state<=`other;
               end

                `n_end: begin
                    if((in=="d"||in=="D")&&(num_End==num_Begin)) begin
                         state<=`d_end_wrong;
                         num_End<=num_End+32'd1;
                    end
                    else if((in=="d"||in=="D")&&(num_End!=num_Begin)) begin
                         state<=`d_end;
                         num_End<=num_End+32'd1;
                    end
                    else if(in==" ")  state<=`block;
                    else  state<=`other;
               end

               `d_end_wrong:begin
                    if(in==" ")  state<=`wrong;
                    else begin
                        num_End<=num_End-32'd1;
                        state<=`other;
                    end 
               end

                `d_end: begin
                    if(in==" ")  state<=`block;
                    else begin
                        num_End<=num_End-32'd1;
                        state<=`other;
                    end 
               end

               `wrong: state<=`wrong;

				default:  state<=`other;
					
            endcase
        end
    end
    
    
    assign  result = ((num_End==num_Begin)&&state!=`wrong&&state!=`d_end_wrong)?1'b1:1'b0;

endmodule