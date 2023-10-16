module BaudController(reset, clk, baud_select, sample_ENABLE);

input clk, reset;
input [2:0] baud_select;
output reg sample_ENABLE;

real baud_rate;
integer temp;
reg [13:0] counter;

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
		
		if($ceil(10**9/(16*20*baud_rate))-(10**9/(16*20*baud_rate)) < (10**9/(16*20*baud_rate)) - $floor(10**9/(16*20*baud_rate)))
			temp = $ceil(10**9/(16*20*baud_rate));
		else temp = $floor(10**9/(16*20*baud_rate));
		
	end
	
always@(posedge clk or posedge reset)
	begin
		if (reset)
		begin
			counter = 14'b00000000000000;
			sample_ENABLE = 1'b0;
		end	
		else 
		begin
			if (counter == temp)
			begin
				counter = 14'b00000000000000;
				sample_ENABLE = 1'b1;
			end
			else
			begin
				counter = counter + 1'b1;
				sample_ENABLE = 1'b0;
			end
		end
	end
	
endmodule