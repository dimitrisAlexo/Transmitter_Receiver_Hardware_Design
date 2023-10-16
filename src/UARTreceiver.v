module UARTreceiver(reset, clk, Rx_DATA, baud_select, Rx_EN, RxD, Rx_FERROR, Rx_PERROR, Rx_VALID);

input reset, clk;
input [2:0] baud_select;
input Rx_EN;
input RxD;

output reg Rx_FERROR, Rx_PERROR, Rx_VALID;
output reg [7:0] Rx_DATA;

wire Rx_sample_ENABLE;

reg [7:0] temp_DATA = 0;
reg [3:0] sample_counter = 0;
reg [3:0] bit_counter = 0;

reg[2:0] current_state, next_state;
parameter RxIDLE = 3'b000, RxSTART = 3'b001,RxDATA = 3'b010,RxPARITY = 3'b011,RxSTOP = 3'b100;


BaudController BaudControllerINSTANCE(reset, clk, baud_select, Rx_sample_ENABLE);


always@(posedge Rx_sample_ENABLE or posedge reset)
begin: SAMPLE_COUNTER
	if (reset)
	begin
		sample_counter <= 0;
	end	
	else 
	begin
    if (sample_counter == 15)
		begin 			
			sample_counter <= 0;
		end
	else
		begin
			sample_counter <= sample_counter + 1;
		end
	end
end


always@(posedge Rx_sample_ENABLE or posedge reset)
begin: STATE_MEMORY
  	if(reset)
    begin
      current_state <= RxIDLE;
    end
  	else 
    begin
      current_state <= next_state;
    end 
end	


always@(current_state or Rx_EN or sample_counter) //no current_state
begin: NEXT_STATE_LOGIC
  	case(current_state) 
		RxIDLE: if(Rx_EN == 1 && RxD==0) 
		begin
		next_state = RxSTART;
		end
		else
		next_state = RxIDLE;
		
		RxSTART:if(sample_counter == 7) 
		begin
		next_state = RxDATA;    
		end
		RxDATA: if(sample_counter == 7 && bit_counter < 7) 
		begin
		next_state = RxDATA;
		end
		else if(sample_counter == 7 && bit_counter == 7)
		next_state = RxPARITY; 

		RxPARITY: if(sample_counter == 7) 
		begin
		next_state = RxSTOP;
		end

      RxSTOP: if(sample_counter == 7 && bit_counter == 15) 
		begin
		next_state = RxIDLE;
		end
	endcase   
end


always@(current_state or sample_counter)
 begin: OUTPUT_LOGIC
  case(current_state)
    RxSTART: 
	begin
      Rx_PERROR = 0;
      Rx_FERROR = 0;
      Rx_VALID = 0;
      bit_counter = 0;
	  Rx_DATA = 8'b0000_0000;
    end
    RxDATA: 
	begin
      if(sample_counter == 7) begin
        temp_DATA[bit_counter] = RxD;
      	bit_counter = bit_counter + 1;
      end
    end
    RxPARITY: if(sample_counter == 7) 
	begin
      bit_counter = bit_counter + 1;
      if (RxD != ^temp_DATA)
      	Rx_PERROR = 1;
      	temp_DATA = 8'b0000_0000;
    end
    RxSTOP: if(sample_counter == 7) 
	begin
      bit_counter = bit_counter + 1;
      if (RxD != 1)
        begin
          Rx_FERROR = 1;
          Rx_VALID = 0;
        end
      else
        if (~Rx_FERROR && ~Rx_PERROR && bit_counter == 15)
		begin
        	Rx_VALID = 1;
      		Rx_DATA[7:0] = temp_DATA[7:0];
			temp_DATA = 8'b0000_0000;
		end
    end
    
   
  endcase
 end


endmodule