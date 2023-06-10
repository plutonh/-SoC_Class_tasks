`timescale 1ns / 1ns
module mat_mul#(
	parameter DATA_LEN = 32,
	parameter M = 8,
	parameter N = 8,
	parameter K = 8,
	parameter STATE_SIZE = 4,
	parameter VEC0   	= 4'd0,
	parameter VEC1   	= 4'd1,
	parameter VEC2   	= 4'd2,
	parameter VEC3   	= 4'd3,
	parameter VEC4   	= 4'd4,
	parameter VEC5   	= 4'd5,
	parameter VEC6   	= 4'd6,
	parameter VEC7   	= 4'd7,
	parameter COPY_VEC7 = 4'd8,
	parameter MUL_STORE_VEC7 = 4'd9,
	parameter ACCUM_AND_DONE = 4'd10,
	parameter IDLE		= 4'b1111,
	parameter ROW_SIZE = (DATA_LEN*K),
	parameter MAT_SIZE = (DATA_LEN*K*M)
)(
	input 					 				  i_clk,
	input 					 				  i_rstn,
	input 					 				  i_start,
	input  signed  [MAT_SIZE-1:0]		  	  i_mat_a,
	input  signed  [MAT_SIZE-1:0]		  	  i_mat_b,
	output signed  [MAT_SIZE-1:0]		  	  o_mat_c,
	output [3:0]  		 	     			  o_state,
    output 									  o_done	
);
	reg   [STATE_SIZE-1:0] state ; // register
	reg   [STATE_SIZE-1:0] next_state ; // for combinational
	
	wire  accum_start;
	
	wire signed [DATA_LEN-1:0] parse_mat_a [0:M-1][0:K-1] ;
	wire signed [DATA_LEN-1:0] parse_mat_b [0:K-1][0:N-1] ;
	wire signed [DATA_LEN-1:0] parse_mat_c [0:M-1][0:K-1] ;
	wire signed [DATA_LEN-1:0] parse_mat_outer [0:M-1][0:N-1] ;
	wire signed [DATA_LEN-1:0] parse_vec_at [0:M-1] ;
	wire signed [DATA_LEN-1:0] parse_vec_b [0:N-1] ;
	
	reg  signed [ROW_SIZE-1:0] vec_at;
	reg  signed [ROW_SIZE-1:0] vec_b;
	wire signed [MAT_SIZE-1:0] mat_outer; // output of mat_outer -> used by PARSE_MAT_OUTER
	
	assign o_state = state;
	
	genvar i;
	generate
	for(i=0; i<K; i=i+1) begin: PARSE_MAT_A	    
		assign parse_mat_a[0][i] = i_mat_a[(ROW_SIZE*0) + (DATA_LEN*i) +: DATA_LEN]; // parse [0][0] of each 8*8 array, total legnth is DATA_LEN
		assign parse_mat_a[1][i] = i_mat_a[(ROW_SIZE*1) + (DATA_LEN*i) +: DATA_LEN];
		assign parse_mat_a[2][i] = i_mat_a[(ROW_SIZE*2) + (DATA_LEN*i) +: DATA_LEN];
		assign parse_mat_a[3][i] = i_mat_a[(ROW_SIZE*3) + (DATA_LEN*i) +: DATA_LEN];
		assign parse_mat_a[4][i] = i_mat_a[(ROW_SIZE*4) + (DATA_LEN*i) +: DATA_LEN];
		assign parse_mat_a[5][i] = i_mat_a[(ROW_SIZE*5) + (DATA_LEN*i) +: DATA_LEN];
		assign parse_mat_a[6][i] = i_mat_a[(ROW_SIZE*6) + (DATA_LEN*i) +: DATA_LEN];
		assign parse_mat_a[7][i] = i_mat_a[(ROW_SIZE*7) + (DATA_LEN*i) +: DATA_LEN];
	end
	endgenerate

	generate
	for(i=0; i<N; i=i+1) begin: PARSE_MAT_B    
		assign parse_mat_b[0][i] = i_mat_b[(ROW_SIZE*0) + (DATA_LEN*i) +: DATA_LEN];
		assign parse_mat_b[1][i] = i_mat_b[(ROW_SIZE*1) + (DATA_LEN*i) +: DATA_LEN];
		assign parse_mat_b[2][i] = i_mat_b[(ROW_SIZE*2) + (DATA_LEN*i) +: DATA_LEN];
		assign parse_mat_b[3][i] = i_mat_b[(ROW_SIZE*3) + (DATA_LEN*i) +: DATA_LEN];
		assign parse_mat_b[4][i] = i_mat_b[(ROW_SIZE*4) + (DATA_LEN*i) +: DATA_LEN];
		assign parse_mat_b[5][i] = i_mat_b[(ROW_SIZE*5) + (DATA_LEN*i) +: DATA_LEN];
		assign parse_mat_b[6][i] = i_mat_b[(ROW_SIZE*6) + (DATA_LEN*i) +: DATA_LEN];
		assign parse_mat_b[7][i] = i_mat_b[(ROW_SIZE*7) + (DATA_LEN*i) +: DATA_LEN];
	end
	endgenerate

	generate
	for(i=0; i<N; i=i+1) begin: PARSE_MAT_C    
		assign parse_mat_c[0][i] = o_mat_c[(ROW_SIZE*0) + (DATA_LEN*i) +: DATA_LEN];
		assign parse_mat_c[1][i] = o_mat_c[(ROW_SIZE*1) + (DATA_LEN*i) +: DATA_LEN];
		assign parse_mat_c[2][i] = o_mat_c[(ROW_SIZE*2) + (DATA_LEN*i) +: DATA_LEN];
		assign parse_mat_c[3][i] = o_mat_c[(ROW_SIZE*3) + (DATA_LEN*i) +: DATA_LEN];
		assign parse_mat_c[4][i] = o_mat_c[(ROW_SIZE*4) + (DATA_LEN*i) +: DATA_LEN];
		assign parse_mat_c[5][i] = o_mat_c[(ROW_SIZE*5) + (DATA_LEN*i) +: DATA_LEN];
		assign parse_mat_c[6][i] = o_mat_c[(ROW_SIZE*6) + (DATA_LEN*i) +: DATA_LEN];
		assign parse_mat_c[7][i] = o_mat_c[(ROW_SIZE*7) + (DATA_LEN*i) +: DATA_LEN];
	end
	endgenerate

	generate
	for(i=0; i<N; i=i+1) begin: PARSE_VECTORS   
		assign parse_vec_at[i] = vec_at[(DATA_LEN * i) +: DATA_LEN];
		assign parse_vec_b[i]  =  vec_b[(DATA_LEN * i) +: DATA_LEN];
	end
	endgenerate

	generate
	for(i=0; i<N; i=i+1) begin: PARSE_MAT_OUTER    
		assign parse_mat_outer[0][i] = mat_outer[(ROW_SIZE*0) + (DATA_LEN*i) +: DATA_LEN];
		assign parse_mat_outer[1][i] = mat_outer[(ROW_SIZE*1) + (DATA_LEN*i) +: DATA_LEN];
		assign parse_mat_outer[2][i] = mat_outer[(ROW_SIZE*2) + (DATA_LEN*i) +: DATA_LEN];
		assign parse_mat_outer[3][i] = mat_outer[(ROW_SIZE*3) + (DATA_LEN*i) +: DATA_LEN];
		assign parse_mat_outer[4][i] = mat_outer[(ROW_SIZE*4) + (DATA_LEN*i) +: DATA_LEN];
		assign parse_mat_outer[5][i] = mat_outer[(ROW_SIZE*5) + (DATA_LEN*i) +: DATA_LEN];
		assign parse_mat_outer[6][i] = mat_outer[(ROW_SIZE*6) + (DATA_LEN*i) +: DATA_LEN];
		assign parse_mat_outer[7][i] = mat_outer[(ROW_SIZE*7) + (DATA_LEN*i) +: DATA_LEN];
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

	always @(*) begin	// next_state logic
		case(state)    
			IDLE: begin if(i_start) next_state = VEC0;
				        else        next_state = IDLE; end     			       		
			VEC0:   		next_state = VEC1;	
			VEC1:   		next_state = VEC2;				
			VEC2:   		next_state = VEC3;					
			VEC3:   		next_state = VEC4;						
			VEC4:   		next_state = VEC5;				
			VEC5:   		next_state = VEC6;				
			VEC6:   		next_state = VEC7;			
			VEC7:   		next_state = COPY_VEC7;					
			COPY_VEC7:      next_state = MUL_STORE_VEC7;				
			MUL_STORE_VEC7: next_state = ACCUM_AND_DONE;        						
			ACCUM_AND_DONE: next_state = IDLE;	               				
			default: 	    next_state = IDLE;				
		endcase
	end
	
	// YOUR CODE HERE //

	always @(posedge i_clk, negedge i_rstn) begin // output logic
		if(!i_rstn) begin
			vec_at <= 0;
			vec_b  <= 0;
		end
		else begin
			case(next_state)
				IDLE:   begin vec_at <= {parse_mat_a[7][0], parse_mat_a[6][0], parse_mat_a[5][0], parse_mat_a[4][0], parse_mat_a[3][0], parse_mat_a[2][0], parse_mat_a[1][0], parse_mat_a[0][0]};
				              vec_b  <= {parse_mat_b[0][7], parse_mat_b[0][6], parse_mat_b[0][5], parse_mat_b[0][4], parse_mat_b[0][3], parse_mat_b[0][2], parse_mat_b[0][1], parse_mat_b[0][0]}; end	
				VEC0:   begin vec_at <= {parse_mat_a[7][1], parse_mat_a[6][1], parse_mat_a[5][1], parse_mat_a[4][1], parse_mat_a[3][1], parse_mat_a[2][1], parse_mat_a[1][1], parse_mat_a[0][1]};
							  vec_b  <= {parse_mat_b[1][7], parse_mat_b[1][6], parse_mat_b[1][5], parse_mat_b[1][4], parse_mat_b[1][3], parse_mat_b[1][2], parse_mat_b[1][1], parse_mat_b[1][0]}; end		
				VEC1:   begin vec_at <= {parse_mat_a[7][2], parse_mat_a[6][2], parse_mat_a[5][2], parse_mat_a[4][2], parse_mat_a[3][2], parse_mat_a[2][2], parse_mat_a[1][2], parse_mat_a[0][2]};
						      vec_b  <= {parse_mat_b[2][7], parse_mat_b[2][6], parse_mat_b[2][5], parse_mat_b[2][4], parse_mat_b[2][3], parse_mat_b[2][2], parse_mat_b[2][1], parse_mat_b[2][0]}; end	
				VEC2:   begin vec_at <= {parse_mat_a[7][3], parse_mat_a[6][3], parse_mat_a[5][3], parse_mat_a[4][3], parse_mat_a[3][3], parse_mat_a[2][3], parse_mat_a[1][3], parse_mat_a[0][3]};
						      vec_b  <= {parse_mat_b[3][7], parse_mat_b[3][6], parse_mat_b[3][5], parse_mat_b[3][4], parse_mat_b[3][3], parse_mat_b[3][2], parse_mat_b[3][1], parse_mat_b[3][0]}; end
				VEC3:   begin vec_at <= {parse_mat_a[7][4], parse_mat_a[6][4], parse_mat_a[5][4], parse_mat_a[4][4], parse_mat_a[3][4], parse_mat_a[2][4], parse_mat_a[1][4], parse_mat_a[0][4]};
							  vec_b  <= {parse_mat_b[4][7], parse_mat_b[4][6], parse_mat_b[4][5], parse_mat_b[4][4], parse_mat_b[4][3], parse_mat_b[4][2], parse_mat_b[4][1], parse_mat_b[4][0]}; end		
				VEC4:   begin vec_at <= {parse_mat_a[7][5], parse_mat_a[6][5], parse_mat_a[5][5], parse_mat_a[4][5], parse_mat_a[3][5], parse_mat_a[2][5], parse_mat_a[1][5], parse_mat_a[0][5]};
							  vec_b  <= {parse_mat_b[5][7], parse_mat_b[5][6], parse_mat_b[5][5], parse_mat_b[5][4], parse_mat_b[5][3], parse_mat_b[5][2], parse_mat_b[5][1], parse_mat_b[5][0]}; end	
				VEC5:   begin vec_at <= {parse_mat_a[7][6], parse_mat_a[6][6], parse_mat_a[5][6], parse_mat_a[4][6], parse_mat_a[3][6], parse_mat_a[2][6], parse_mat_a[1][6], parse_mat_a[0][6]};
							  vec_b  <= {parse_mat_b[6][7], parse_mat_b[6][6], parse_mat_b[6][5], parse_mat_b[6][4], parse_mat_b[6][3], parse_mat_b[6][2], parse_mat_b[6][1], parse_mat_b[6][0]}; end		
				VEC6:   begin vec_at <= {parse_mat_a[7][7], parse_mat_a[6][7], parse_mat_a[5][7], parse_mat_a[4][7], parse_mat_a[3][7], parse_mat_a[2][7], parse_mat_a[1][7], parse_mat_a[0][7]};
							  vec_b  <= {parse_mat_b[7][7], parse_mat_b[7][6], parse_mat_b[7][5], parse_mat_b[7][4], parse_mat_b[7][3], parse_mat_b[7][2], parse_mat_b[7][1], parse_mat_b[7][0]}; end
			    default begin vec_at <= 0;
				              vec_b  <= 0; end		
			endcase
		end	
	end

	mat_outer M1(i_clk, i_rstn, vec_at, vec_b, mat_outer);
	mat_accum M2(i_clk, i_rstn, accum_start, mat_outer, o_mat_c);

	assign accum_start = (state == VEC1) ? 1 : 0;
	assign o_done      = (state == ACCUM_AND_DONE) ? 1 : 0;

	////////////////////

endmodule
