module M10K_write#(
	parameter DATA_LEN = 32,
	parameter M = 8,
	parameter N = 8,
	parameter ADDRESS_SIZE = 4,
	parameter OFFSET = 0,
	parameter WRITE0 = 4'd0,
	parameter WRITE1 = 4'd1,
	parameter WRITE2 = 4'd2,
	parameter WRITE3 = 4'd3,
	parameter WRITE4 = 4'd4,
	parameter WRITE5 = 4'd5,
	parameter WRITE6 = 4'd6,
	parameter WRITE7 = 4'd7,
    parameter DONE   = 4'd8,
	parameter IDLE   = 4'd15 
)(
	input 					 		 		i_clk,
	input 					 		  	    i_rstn,
	input							     	i_write_start,
	input       [DATA_LEN*M*N-1:0]	        i_in_mat,
	
	output	reg [ADDRESS_SIZE-1:0]	        o_write_addr,
	output  reg [DATA_LEN*N-1:0]	  	    o_write_data,
	output  reg						        o_write_start,
	output      [3:0]					    o_state,
	output 							        o_done
);
	reg  [3:0] state;     
	reg  [3:0] next_state;
	
	wire [DATA_LEN*N-1:0] in_vec [0:M-1];
	
	assign o_state = state;
	assign o_done = (state == DONE);
	
	genvar i;
	generate
	for(i=0; i<M; i=i+1) begin: INPUT_PARSE
		assign in_vec[i] = i_in_mat[(DATA_LEN*N)*((i)) +: (DATA_LEN*N)];
	end
	endgenerate
	
	always @(posedge i_clk, negedge i_rstn) begin
		if(!i_rstn) begin
			state <= IDLE;
		end
		else begin
			state <= next_state;
		end	
	end
		
	always @(*) begin // next state logic
		case(state) 
			IDLE:  begin
						// YOUR CODE HERE //
						if(i_write_start) next_state = WRITE0;
						else			  next_state = IDLE;
					end
			WRITE0: begin
						// YOUR CODE HERE //
						next_state = WRITE1;
					end
			WRITE1: begin
						// YOUR CODE HERE //
						next_state = WRITE2;
					end
			WRITE2: begin
						// YOUR CODE HERE //
						next_state = WRITE3;
					end
			WRITE3: begin
						// YOUR CODE HERE //
						next_state = WRITE4;
					end
			WRITE4: begin
						// YOUR CODE HERE //
						next_state = WRITE5;
					end
			WRITE5: begin
						// YOUR CODE HERE //
						next_state = WRITE6;
					end
			WRITE6: begin
						// YOUR CODE HERE //
						next_state = WRITE7;
					end
			WRITE7: begin
						// YOUR CODE HERE //
						next_state = DONE;
					end
			DONE: begin
						// YOUR CODE HERE //
						next_state = IDLE;
					end
			default:begin	
						// YOUR CODE HERE //
						next_state = IDLE;
					end
		endcase
	end
	
	// YOUR CODE HERE //
	always @(posedge i_clk, negedge i_rstn) begin // output logic
		if(!i_rstn) begin
			o_write_start <= 0;
			o_write_addr  <= 0;
			o_write_data  <= 0;
		end
		else begin
			case(next_state)
				WRITE0: begin
							o_write_addr  <= OFFSET + WRITE0;
							o_write_start <= 1;
							o_write_data  <= in_vec[0];
						end
				WRITE1: begin
							o_write_addr  <= OFFSET + WRITE1;
							o_write_start <= 1;
							o_write_data  <= in_vec[1];
						end
				WRITE2: begin
							o_write_addr  <= OFFSET + WRITE2;
							o_write_start <= 1;
							o_write_data  <= in_vec[2];
						end
				WRITE3: begin
							o_write_addr  <= OFFSET + WRITE3;
							o_write_start <= 1;
							o_write_data  <= in_vec[3];
						end
				WRITE4: begin
							o_write_addr  <= OFFSET + WRITE4;
							o_write_start <= 1;
							o_write_data  <= in_vec[4];
						end
				WRITE5: begin
							o_write_addr  <= OFFSET + WRITE5;
							o_write_start <= 1;
							o_write_data  <= in_vec[5];
						end
				WRITE6: begin
							o_write_addr  <= OFFSET + WRITE6;
							o_write_start <= 1;
							o_write_data  <= in_vec[6];
						end
				WRITE7: begin
							o_write_addr  <= OFFSET + WRITE7;
							o_write_start <= 1;
							o_write_data  <= in_vec[7];
						end
				default: begin
							o_write_start <= 0;
							o_write_addr  <= 0;
							o_write_data  <= 0;
						end
			endcase
		end
	end
	////////////////////	
endmodule