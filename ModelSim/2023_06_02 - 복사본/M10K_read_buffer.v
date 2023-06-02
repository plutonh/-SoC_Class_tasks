module M10K_read_buffer#(
	parameter DATA_LEN = 32,
	parameter M = 8,
	parameter N = 8,
	parameter ADDRESS_SIZE = 4,
	parameter OFFSET = 4'd0,
	parameter READ0 = 4'd0,
	parameter READ1 = 4'd1,
	parameter READ2 = 4'd2,
	parameter READ3 = 4'd3,
	parameter READ4 = 4'd4,
	parameter READ5 = 4'd5,
	parameter READ6 = 4'd6,
	parameter READ7 = 4'd7,
	parameter WAIT  = 4'd8,
	parameter DONE  = 4'd9,
	parameter IDLE  = 4'd15	
)(
	input 					 		     i_clk,
	input 					 		     i_rstn,
	input							     i_read_reset,
	input							     i_read_start,
	input       [DATA_LEN*N-1:0]	  	 i_read_data,
	
	output      [DATA_LEN*M*N-1:0]	     o_store_mat,
	output	reg [ADDRESS_SIZE-1:0]       o_read_addr,
	output      [3:0]  					 o_state,
	output								 o_done
);
	reg  [3:0] state;     
	reg  [3:0] next_state;
	
	reg  [DATA_LEN*N-1:0] store_vec [0:M-1];
	
	assign o_state = state;
	assign o_done  = (state == DONE);
	
	genvar i;	
	generate
	for(i=0; i<M; i=i+1) begin: OUTPUT_MERGE
		assign o_store_mat[(DATA_LEN*N)*((i)) +: (DATA_LEN*N)] = store_vec[i];
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
			IDLE: begin
						// YOUR CODE HERE //
						if(i_read_start) next_state = READ0;
						else			 next_state = IDLE;
					end
			READ0: begin
						// YOUR CODE HERE //
						next_state = READ1;
					end
			READ1: begin
						// YOUR CODE HERE //
						next_state = READ2;
					end
			READ2: begin
						// YOUR CODE HERE //
						next_state = READ3;
					end
			READ3: begin
						// YOUR CODE HERE //
						next_state = READ4;
					end
			READ4: begin
						// YOUR CODE HERE //
						next_state = READ5;
					end
			READ5: begin
						// YOUR CODE HERE //
						next_state = READ6;
					end
			READ6: begin
						// YOUR CODE HERE //
						next_state = READ7;
					end
			READ7: begin
						// YOUR CODE HERE //
						next_state = WAIT;
					end
			WAIT: begin
						// YOUR CODE HERE //
						next_state = DONE;
					end
			DONE:  begin
					    // YOUR CODE HERE //
						if(i_read_reset) next_state = IDLE;
						else			 next_state = DONE;
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
			store_vec[0] <= 0;
			store_vec[1] <= 0;
			store_vec[2] <= 0;
			store_vec[3] <= 0;
			store_vec[4] <= 0;
			store_vec[5] <= 0;
			store_vec[6] <= 0;
			store_vec[7] <= 0;
			o_read_addr  <= 0;
		end
		else begin
			case(state)
				READ0: begin
							o_read_addr  <= OFFSET + READ0;
						end
				READ1: begin
							store_vec[0] <= i_read_data;
							o_read_addr  <= OFFSET + READ1;
						end
				READ2: begin
							o_read_addr  <= OFFSET + READ2;
							store_vec[1] <= i_read_data;
						end
				READ3: begin
							o_read_addr  <= OFFSET + READ3;
							store_vec[2] <= i_read_data;
						end
				READ4: begin
							o_read_addr  <= OFFSET + READ4;
							store_vec[3] <= i_read_data;
						end
				READ5: begin
							o_read_addr  <= OFFSET + READ5;
							store_vec[4] <= i_read_data;
						end
				READ6: begin
							o_read_addr  <= OFFSET + READ6;
							store_vec[5] <= i_read_data;
						end
				READ7: begin
							o_read_addr  <= OFFSET + READ7;
							store_vec[6] <= i_read_data;
						end
				WAIT:  begin
							store_vec[7] <= i_read_data;
						end
				DONE:  begin
							store_vec[0] <= store_vec[0];
							store_vec[1] <= store_vec[1];
							store_vec[2] <= store_vec[2];
							store_vec[3] <= store_vec[3];
							store_vec[4] <= store_vec[4];
							store_vec[5] <= store_vec[5];
							store_vec[6] <= store_vec[6];
							store_vec[7] <= store_vec[7];
					    end
			endcase
		end
	end
	////////////////////
endmodule