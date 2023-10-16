`timescale 1ns / 1ps

module FourDigitLEDdriver_tb;

reg clk, reset;
wire [6:0] LED;
reg [15:0] word;

  FourDigitLEDdriver test (clk, reset, word, an3, an2, an1, an0, a, b, c, d, e, f, g); // instatiate decoder test

initial begin
  
  	$dumpfile("dump.vcd"); $dumpvars;

	clk = 0; // our clock is initialy set to 0
	reset = 1; // our reset signal is initialy set to 1

	#100; // after 100 timing units, i.e. ns
					
	reset = 0; // set reset signal to 0

	#200 word = 16'b0010_0101_0111_1100;
					
	#10000 $finish;	 // after 10000 timing units, i.e. ns, finish our simulation
end
	
always #10 clk = ~ clk; // create our clock, with a period of 20ns

endmodule