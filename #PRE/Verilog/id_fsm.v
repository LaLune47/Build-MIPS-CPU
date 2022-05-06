`define s0 2'b00   //��ĿǰΪֹֻ�����֣�Ҳ����id��û��ʼ
`define s1 2'b01   //��ĿǰΪֹֻ����ĸ
`define s2 2'b10   //����id��ʽ����ĸ������

module id_fsm (
    input [7:0] char,
    input clk,
    output out 
);
    reg [1:0] status;
    initial begin
        status<=`s0;
    end

    always @(posedge clk) begin
      
      case (status)
        `s0:begin
                if ((char >= 8'd65 && char <= 8'd90) || (char >= 8'd97 && char <= 8'd122)) begin
                   status<=`s1;
                end
                else begin
                   status<=`s0;
                end
        end

        `s1:begin
                if((char >= 8'd65 && char <= 8'd90) || (char >= 8'd97 && char <= 8'd122)) begin
                    status<=`s1;
                end
                else if (char >= 8'd48 && char <= 8'd57) begin
                    status<=`s2;
                end
                else begin
                    status<=`s0;
                end

        end

        `s2:begin
                if ((char >= 8'd65 && char <= 8'd90) || (char >= 8'd97 && char <= 8'd122)) begin
                    status<=`s1;
                end
                else if (char >= 8'd48 && char <= 8'd57) begin
                    status<=`s2;
                end
                else begin
                    status<=`s0;
                end
        end
        default: status<=`s0;
      endcase  

    end

    assign out = (status==`s2) ? 1'b1 : 1'b0 ;

endmodule

