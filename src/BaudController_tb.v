`timescale 1ns / 1ps

module BaudController_tb;

reg reset, clk, sample_ENABLE;
reg [2:0] baud_select;

BaudController test (reset, clk, baud_select, sample_ENABLE); // instatiate test

initial begin

	$dumpfile("dump.vcd"); $dumpvars;

	clk = 0; // our clock is initialy set to 0
	reset = 1; // our reset signal is initialy set to 1

	#100; // after 100 timing units, i.e. ns
					
	reset = 0; // set reset signal to 0
	
	baud_select = 3'b111;
					
	#10000 $finish;	 // after 10000 timing units, i.e. ns, finish our simulation
end
	
always #10 clk = ~ clk; // create our clock, with a period of 20ns

endmodule
