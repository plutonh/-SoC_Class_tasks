module shift_led(clk, reset_n, board_led);

	parameter SEC_CNT = 50000000;

	input            clk, reset_n;
	output reg [9:0] board_led;
	
	reg [25:0] count;
	reg [3:0] direct_count;
	reg       direct;
	
	always @(posedge clk or negedge reset_n) begin
		if(!reset_n) begin
			board_led <= 10'b0000000001;
			direct_count <= 0;
			direct <= 0;
		end
		else begin
			count <= count + 1;
			if(count == SEC_CNT) begin
				case(direct)
					0:       board_led <= board_led << 1;
					default: board_led <= board_led >> 1;
				endcase
				
				direct_count <= direct_count + 1;
				count <= 0;
				
				if(direct_count == 8) begin
					direct <= ~direct;
					direct_count <= 0;
				end
			end
		end
	end

endmodule