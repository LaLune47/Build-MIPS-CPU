module splitter (
    input [31:0] A,
    output reg [7:0] O1,  //31:24
    output reg [7:0] O2,  //23:16
    output reg [7:0] O3,  //15:8
    output reg [7:0] O4   //7:0
); 
    
always @(*) begin
		O1={A[31],A[30],A[29],A[28],A[27],A[26],A[25],A[24]};
        O2={A[23],A[22],A[21],A[20],A[19],A[18],A[17],A[16]};
        O3={A[15],A[14],A[13],A[12],A[11],A[10],A[9],A[8]};
        O4={A[7],A[6],A[5],A[4],A[3],A[2],A[1],A[0]};
	end

endmodule