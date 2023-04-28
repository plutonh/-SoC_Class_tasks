module led_10bit_controller_condition(sw, leds);

	input 	  [9:0] sw;
	output reg [9:0] leds;
	
	always @(sw) begin
		if(sw == 10'b0000000000)      leds = 10'b1111111111;
		else if(sw == 10'b1111111111) leds = 10'b0000000000;
		else                          leds = sw;
	end

endmodule