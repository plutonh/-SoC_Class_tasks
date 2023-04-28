/*module FSM(o, a, b, clk, reset);

	output o; reg o;
	input a, b, clk, reset;
	reg [1:0] state;

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			state <= 2'b00;
		end
		else begin
			case (state)
				2'b00: begin
					state <= a ? 2'b00 : 2'b01;
					o <= a & b;
				end
				2'b01: begin 
					state <= 2'b10; 
					o <= 0; 
				end
			endcase
		end
	end
	
endmodule*/

module FSM(o, a, b, clk, reset);

	output o;
	reg o;
	input a, b, clk, reset;
	reg [1:0] state, nextState;
	
	always @(a or b or state) begin
		case (state)
			2'b00: begin
				nextState = a ? 2'b00 : 2'b01;
				o = a & b;
			end
			2'b01: begin 
				nextState = 2'b10; 
				o = 0; 
			end
		endcase
	end
	
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			state <= 2'b00;
		end 
		else begin
			state <= nextState;
		end
	end

endmodule