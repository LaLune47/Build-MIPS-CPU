`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:46:42 11/10/2021
// Design Name:   cpu_checker
// Module Name:   C:/Users/28728/Desktop/Computer Organization/new_cpuchecker/tb.v
// Project Name:  new_cpuchecker
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: cpu_checker
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb;

		// Inputs
	reg clk;
	reg reset;
	reg [7:0] char;

	// Outputs
	wire [1:0] format_type;
	wire [3:0] error_code;

	// Instantiate the Unit Under Test (UUT)
	cpu_checker uut (
		.clk(clk), 
		.reset(reset), 
		.char(char), 
		.format_type(format_type)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		char = 0;

		#10 reset = 0;
		#2 char = "^";
#2 char = "2";

#2 char = "@";
#2 char = "0";
#2 char = "0";
#2 char = "0";
#2 char = "0";
#2 char = "3";
#2 char = "0";
#2 char = "f";
#2 char = "4";
#2 char = ":";
#2 char = " ";
#2 char = "$";
#2 char = "3";
#2 char = "1";
#2 char = " ";
#2 char = "<";
#2 char = "=";
#2 char = "1";
#2 char = "2";
#2 char = "3";
#2 char = "4";
#2 char = "5";
#2 char = "6";
#2 char = "7";
#2 char = "8";
#2 char = "#";
#2 char = "^";
#2 char = "2";
#2 char = "4";
#2 char = "2";
#2 char = "@";
#2 char = "0";
#2 char = "0";
#2 char = "0";
#2 char = "0";
#2 char = "3";
#2 char = "0";
#2 char = "f";
#2 char = "4";
#2 char = ":";
#2 char = " ";
#2 char = "$";
#2 char = "3";
#2 char = "1";
#2 char = " ";
#2 char = "<";
#2 char = "=";
#2 char = "1";
#2 char = "2";
#2 char = "3";
#2 char = "2";
#2 char = "1";
#2 char = "5";
#2 char = "#";

		#20;
	end

    always #1 clk = ~clk;
      
endmodule

