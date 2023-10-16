module UARTtoLED(reset, clk, Tx_DATA, baud_select, Tx_EN, Tx_WR, Tx_BUSY, Rx_DATA, Rx_EN,
 Rx_FERROR, Rx_PERROR, Rx_VALID, an3, an2, an1, an0, a, b, c, d, e, f, g);
	
	input reset, clk;
	input [2:0] baud_select;
	input Rx_EN;
	input [7:0] Tx_DATA;
	input Tx_EN, Tx_WR;

	output Tx_BUSY;
	output Rx_FERROR, Rx_PERROR, Rx_VALID;
	output [7:0] Rx_DATA;
	output an3, an2, an1, an0; // our anodes
	output a, b, c, d, e, f, g;	//	our signals
	reg [15:0] Rx_WORD;
	
	reg flag = 0;
	reg [3:0] counter = 0;
	wire Rx_RECEIVE;
	wire sample_ENABLE;
	
	UARTrt transceiver(reset, clk, Tx_DATA, baud_select, Tx_EN, Tx_WR, Tx_BUSY,
	Rx_DATA, Rx_EN, Rx_FERROR, Rx_PERROR, Rx_VALID, Rx_RECEIVE);
	
	BaudController BaudControllerINSTANCE(reset, clk, baud_select, sample_ENABLE);
	
	always @(posedge Rx_RECEIVE)
	begin
		flag = 1;
	end
	
	always @(posedge sample_ENABLE)
	begin
		if (flag == 1)
		begin
			if (counter == 15*16 && Rx_VALID)
			begin
              Rx_WORD[7:0] = Rx_DATA;
			end
			else if (counter == 31*16 && Rx_VALID)
			begin
				Rx_WORD[15:8] = Rx_DATA;
				counter = 0;
			end
			else if (Rx_FERROR || Rx_PERROR)
			begin
				Rx_WORD = 16'b1111_1111_1111_1111;
			end
			counter = counter + 1;
		end
	end
	
	FourDigitLEDdriver ledakia(clk, reset, Rx_WORD, an3, an2, an1, an0, a, b, c, d, e, f, g);

endmodule