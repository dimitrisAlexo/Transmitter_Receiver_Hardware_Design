module UARTtransmitter(reset, clk, Tx_DATA, baud_select, Tx_WR, Tx_EN, TxD, Tx_BUSY); 

input reset, clk;
input [7:0] Tx_DATA;
input [2:0] baud_select;
input Tx_EN;
input Tx_WR;

output reg TxD;
output reg Tx_BUSY;

wire Tx_sample_ENABLE;
reg[3:0] sample_counter = 0;
reg[3:0] bit_counter = 0;

reg[2:0] current_state, next_state;
parameter TxIDLE = 3'b000, TxSTART = 3'b001,TxDATA = 3'b010,TxPARITY = 3'b011,TxSTOP = 3'b100;


BaudController BaudControllerINSTANCE(reset, clk, baud_select, Tx_sample_ENABLE);


always@(posedge Tx_sample_ENABLE or posedge reset)
begin: SAMPLE_COUNTER
	if (reset)
	begin
		sample_counter = 0;
	end	
	else 
	begin
      if (sample_counter == 15)
		begin 			
			sample_counter = 0;
		end
		else
		begin
			sample_counter = sample_counter + 1;
		end
	end
end


always@(posedge Tx_sample_ENABLE or posedge reset)
begin: STATE_MEMORY
  if(reset)
    begin
      current_state <= TxIDLE;
    end
  else 
    begin
      current_state <= next_state;
    end 
end	
  

always@(current_state or sample_counter or Tx_WR or Tx_EN)
begin: NEXT_STATE_LOGIC
  case(current_state) 
    TxIDLE: if(Tx_EN && Tx_WR)
	begin
      next_state = TxSTART;
    end
    else
      next_state = TxIDLE;
    
    TxSTART: if(sample_counter == 15)
	begin
      next_state = TxDATA;
    end
    TxDATA: if(sample_counter == 15 && bit_counter < 8)
	begin
      next_state = TxDATA;
    end
    else if(sample_counter == 15 && bit_counter == 8)
      next_state = TxPARITY; 

    TxPARITY:if(sample_counter == 15)
	begin
      next_state = TxSTOP;
    end

    TxSTOP: if(sample_counter == 15)
	begin
		if (~Tx_WR)
			next_state = TxIDLE;
		else 
			next_state = TxSTART;
	end

    endcase   
end


  always@(current_state or sample_counter)
 begin: OUTPUT_LOGIC
  case(current_state)
    TxIDLE: 
	begin
		TxD = 1;
     	Tx_BUSY = 0;
    end
    TxSTART: 
	begin
		TxD = 0;
      	Tx_BUSY = 1; 
      	bit_counter = 0;
    end
    TxDATA: if(sample_counter == 0 && bit_counter<8) 
	begin
      TxD = Tx_DATA[bit_counter];
      bit_counter = bit_counter+1;
    end
    TxPARITY: if(sample_counter == 0) 
	begin
      TxD = ^Tx_DATA;  // even parity
    end
    TxSTOP: if(sample_counter == 0) 
	begin
      TxD = 1;
    end

  endcase
 end

endmodule