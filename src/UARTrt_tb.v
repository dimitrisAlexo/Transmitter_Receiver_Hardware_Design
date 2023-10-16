`timescale 1ns / 1ps

module UARTrt_tb;

reg clk, reset;
reg [2:0] baud_select;
reg [7:0] Tx_DATA;
wire Rx_FERROR, Rx_PERROR, Rx_VALID;
reg Tx_EN, Tx_WR, Rx_EN;
wire Tx_BUSY;
wire [7:0] Rx_DATA;


UARTrt test(reset, clk, Tx_DATA, baud_select, Tx_EN, Tx_WR, Tx_BUSY, Rx_DATA, Rx_EN, Rx_FERROR, 
Rx_PERROR, Rx_VALID);

initial 
begin
		$dumpfile("dump.vcd"); $dumpvars;
    	clk = 0;
    	reset = 1;
    	Rx_EN = 0;
		Tx_EN = 0;
		Tx_WR = 0;
    	baud_select = 3'b111;

    	#100 reset = 0; 
		Tx_DATA = 8'b11011010;
    	Rx_EN = 1;
		Tx_EN = 1;
		Tx_WR = 1;
    	#6000000 $finish;
end

always #10 clk = ~clk;



endmodule