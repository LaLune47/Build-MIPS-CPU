`timescale  1ns / 1ps

module tb_id_fsm;    

// id_fsm Parameters
parameter PERIOD  = 10;


// id_fsm Inputs
reg   [7:0]  char                          = 0 ;
reg   clk                                  = 0 ;

// id_fsm Outputs
wire  out                                  ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end



id_fsm  u_id_fsm (
    .char                    ( char  [7:0] ),
    .clk                     ( clk         ),
    .out                     ( out         )
);

initial
begin
     char=8'd48;
	  #10
	  char=8'd31;
	  #10
	  char=8'd48;
	  
	  #10
	  char=8'd97;   //数字打头的试完了
	  #10
	  char=8'd97;
	  #10
	  char=8'd97;
	  
	  #10
	  char=8'd48;
	  #10
	  char=8'd48;
	  
	  #10
	  char=8'd97;
	  #10
	  char=8'd49;
	  
	  #100 ; 
    
end

endmodule
