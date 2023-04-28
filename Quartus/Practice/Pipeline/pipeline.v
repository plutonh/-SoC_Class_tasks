//module pipeline (out, in, clock); 
//	output out; 
//	input in, clock; 
//	reg out, pipe[1:2]; 
//	always @(posedge clock) begin 
//		out     <= pipe[2]; 
//		pipe[2] <= pipe[1]; 
//		pipe[1] <= in; 
//	end 
//endmodule

module pipeline (out, in, clock); 
	output out;
	input in, clock;
	wire slout, s2out;
	pipestage s1 (slout, in, clock), s2 (s2out, slout, clock), s3 (out, s2out, clock);
endmodule

module pipestage (out, in, clock);
	output out;
	input in, clock;
	reg out;
	
	always @(posedge clock) begin
		out <= in;
	end
endmodule