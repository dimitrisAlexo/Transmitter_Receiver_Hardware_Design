`timescale 1ns / 1ps

module UARTtransmitter_tb;

reg clk, reset;
reg [7:0] Tx_DATA;
reg [2:0] baud_select;
reg Tx_EN;
reg Tx_WR;
reg TxD;
reg Tx_BUSY;

  UARTtransmitter test (reset, clk, Tx_DATA, baud_select, Tx_WR, Tx_EN, TxD, Tx_BUSY); // instatiate test

initial begin
  
  	$dumpfile("dump.vcd"); $dumpvars;

	clk = 0; // our clock is initialy set to 0
	reset = 1; // our reset signal is initialy set to 1
  	Tx_EN = 0;
   Tx_WR = 0;
   baud_select = 3'b111;

	#100; // after 100 timing units, i.e. ns
					
	reset = 0; // set reset signal to 0
  	
	Tx_WR = 1;
	Tx_EN = 1;
	Tx_DATA = 8'b10100101;
 	@(posedge Tx_BUSY) Tx_WR = 0;
					
	#500000 $finish;	 // after 10000 timing units, i.e. ns, finish our simulation
end
	
always #10 clk = ~ clk; // create our clock, with a period of 20ns

endmodule