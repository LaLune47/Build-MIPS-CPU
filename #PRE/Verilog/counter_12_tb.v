`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:42:40 10/06/2021
// Design Name:   code
// Module Name:   C:/Users/28728/Desktop/code1/code1_tb.v
// Project Name:  code1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: code
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module code1_tb;

	// Inputs
	reg Clk;
	reg Reset;
	reg Slt;
	reg En;

	// Outputs
	wire [63:0] Output0;
	wire [63:0] Output1;

	// Instantiate the Unit Under Test (UUT)
	code uut (
		.Clk(Clk), 
		.Reset(Reset), 
		.Slt(Slt), 
		.En(En), 
		.Output0(Output0), 
		.Output1(Output1)
	);

   
	initial begin
		// Initialize Inputs
		Clk = 0;
		Reset = 1;
		Slt = 0;
		En = 0;
		
		#100
		Reset=0;
		
		#20 En=1'b1;
		#90 Slt=1'b1;
		#90 En=1'b0;
		#40 Reset=1'b1;		
		
		#20 Slt=1'b0;
		#20 En=1'b1;
		#90 Slt=1'b1;
		#90 En=1'b0;
	
		
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
    
   always  #10 Clk=~Clk;
		
endmodule




`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:27:16 11/02/2021
// Design Name:   pre_counter
// Module Name:   C:/Users/28728/Desktop/Computer Organization/pre_p1/pre_counter_tb.v
// Project Name:  pre_p1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: pre_counter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module pre_counter_tb;

	// Inputs
	reg Clk;
	reg Reset;
	reg Slt;
	reg En;

	// Outputs
	wire [63:0] Output0;
	wire [63:0] Output1;

	// Instantiate the Unit Under Test (UUT)
	pre_counter uut (
		.Clk(Clk), 
		.Reset(Reset), 
		.Slt(Slt), 
		.En(En), 
		.Output0(Output0), 
		.Output1(Output1)
	);

	initial begin
		// Initialize Inputs
		Clk = 0;
		Reset = 1;
		Slt = 0;
		En = 0;

		// Wait 100 ns for global reset to finish
		#100 
		Reset=0;
		
		
		
		#2 En=1;
        Slt=0;
		
		#10  En=0;
		#10  Reset=1;
		
		#10  Reset=0;
		En=1;
		
		#2 Slt=1;
		
		#10  En=0;
		
		#100;
		
		
	end
    
   always #1 Clk=~Clk;	 
	
endmodule
