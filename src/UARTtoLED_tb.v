`timescale 1ns / 1ps

module UARTtoLED_tb;

//(reset, clk, Tx_DATA, baud_select, Tx_EN, Tx_WR, Tx_BUSY, Rx_DATA, Rx_EN,
 //Rx_FERROR, Rx_PERROR, Rx_VALID, an3, an2, an1, an0, a, b, c, d, e, f, g);
	
	reg reset, clk;
	reg [2:0] baud_select;
	reg Rx_EN;
	reg [7:0] Tx_DATA;
	reg Tx_EN, Tx_WR;

	reg Tx_BUSY;
	reg Rx_FERROR, Rx_PERROR, Rx_VALID;
	reg [7:0] Rx_DATA;
	reg [15:0] Rx_WORD;
	
	real baud_rate;
	
	
	UARTtoLED test(reset, clk, Tx_DATA, baud_select, Tx_EN, Tx_WR, Tx_BUSY, Rx_DATA, Rx_EN,
	Rx_FERROR, Rx_PERROR, Rx_VALID, an3, an2, an1, an0, a, b, c, d, e, f, g);
	
	always@(baud_select)
	begin
		case(baud_select)
			3'b000:baud_rate = 300;
			3'b001:baud_rate = 1200;
			3'b010:baud_rate = 4800;
			3'b011:baud_rate = 9600;
			3'b100:baud_rate = 19200;
			3'b101:baud_rate = 38400;
			3'b110:baud_rate = 57600;
			3'b111:baud_rate = 115200;
		endcase
		
	end
	
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
		
		#(10**9/(baud_rate))  // delay for the second package
		
		Rx_EN = 0;
		Tx_EN = 0;
		Tx_WR = 0;
		baud_select = 3'b111;

		#100 reset = 0; 
		Tx_DATA = 8'b10001010;
		Rx_EN = 1;
		Tx_EN = 1;
		Tx_WR = 1;
		
		#60000 $finish;
	end
	

always #10 clk = ~clk;



endmodule