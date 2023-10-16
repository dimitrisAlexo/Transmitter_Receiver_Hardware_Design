`timescale 1ns / 1ps

module UARTreceiver_tb;

reg reset, clk;
reg [2:0] baud_select;
reg Rx_EN; 
reg RxD;

reg [7:0] Rx_DATA;
reg Rx_FERROR;
reg Rx_PERROR;
reg Rx_VALID;
reg Rx_RECEIVE;
  
real baud_rate;


	UARTreceiver test (reset, clk, Rx_DATA, baud_select, Rx_EN, RxD, Rx_FERROR, Rx_PERROR, Rx_VALID, Rx_RECEIVE); // instatiate receiver test
  
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
  
initial begin

	$dumpfile("dump.vcd"); $dumpvars;

	clk = 0; // our clock is initialy set to 0
	reset = 1; // our reset signal is initialy set to 1
   	baud_select = 3'b111;
  	RxD = 1;

	#100; // after 100 timing units, i.e. ns
					
	reset = 0; // set reset signal to 0
  	
	Rx_EN = 1;
	
	
  	#(10**9/(baud_rate))
	RxD = 0;
	#(10**9/(baud_rate))
	RxD = 1;
	#(10**9/(baud_rate))
	RxD = 0;
	#(10**9/(baud_rate))
	RxD = 1;
	#(10**9/(baud_rate))
	RxD = 1;
	#(10**9/(baud_rate))
	RxD = 1;
	#(10**9/(baud_rate))
	RxD = 0;
	#(10**9/(baud_rate))
	RxD = 1;
	#(10**9/(baud_rate))
	RxD = 1;
	#(10**9/(baud_rate))
	RxD = 0;
	#(10**9/(baud_rate))
	RxD = 1;
	#(10**9/(baud_rate))
	RxD = 1;
	#(10**9/(baud_rate))
	RxD = 1;
	#(10**9/(baud_rate))
	RxD = 1;
	#(10**9/(baud_rate))
	RxD = 1;
	#(10**9/(baud_rate))
	RxD = 1;
  
  	#(10**9/(baud_rate))
	RxD = 0; //start bit
	#(10**9/(baud_rate))
	RxD = 1; //data
	#(10**9/(baud_rate))
	RxD = 0; //data
	#(10**9/(baud_rate))
	RxD = 1; //data
	#(10**9/(baud_rate))
	RxD = 1; //data
	#(10**9/(baud_rate))
	RxD = 1; //data
	#(10**9/(baud_rate))
	RxD = 0; //data
	#(10**9/(baud_rate))
	RxD = 1; //data
	#(10**9/(baud_rate))
	RxD = 1; //data
	#(10**9/(baud_rate))
	RxD = 0; //parity bit
	#(10**9/(baud_rate))
	RxD = 1; //stop bit
	#(10**9/(baud_rate))
	RxD = 1; //stop bit
	#(10**9/(baud_rate))
	RxD = 1; //stop bit
	#(10**9/(baud_rate))
	RxD = 1; //stop bit
	#(10**9/(baud_rate))
	RxD = 1; //stop bit
	#(10**9/(baud_rate))
	RxD = 1; //stop bit
  
	#1000000 $finish;	 // after 10000 timing units, i.e. ns, finish our simulation
end
	
always #10 clk = ~ clk; // create our clock, with a period of 20ns

endmodule