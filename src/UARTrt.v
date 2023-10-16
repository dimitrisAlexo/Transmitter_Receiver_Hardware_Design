module UARTrt(reset, clk, Tx_DATA, baud_select, Tx_EN, Tx_WR, Tx_BUSY, Rx_DATA, Rx_EN, Rx_FERROR, 
Rx_PERROR, Rx_VALID);

	input reset, clk;
	input [2:0] baud_select;
	input Rx_EN;
	input [7:0] Tx_DATA;
	input Tx_EN, Tx_WR;

	output Tx_BUSY;
	output Rx_FERROR, Rx_PERROR, Rx_VALID;
	output [7:0] Rx_DATA;

	wire TxD;

	UARTtransmitter uTx(reset, clk, Tx_DATA, baud_select, Tx_WR, Tx_EN, TxD, Tx_BUSY);
	UARTreceiver uRx(reset, clk, Rx_DATA, baud_select, Rx_EN, TxD, Rx_FERROR, Rx_PERROR, Rx_VALID);


endmodule