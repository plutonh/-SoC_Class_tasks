`timescale 1ns/1ns
module tb_mat_mul;

	parameter DATA_LEN = 32;
	parameter M = 8;
	parameter N = 8;
	parameter K = 8;
	parameter STATE_SIZE = 4;
	parameter VEC0   	= 4'd0;
	parameter VEC1   	= 4'd1;
	parameter VEC2   	= 4'd2;
	parameter VEC3   	= 4'd3;
	parameter VEC4   	= 4'd4;
	parameter VEC5   	= 4'd5;
	parameter VEC6   	= 4'd6;
	parameter VEC7   	= 4'd7;
	parameter COPY_VEC7 = 4'd8;
	parameter MUL_STORE_VEC7 = 4'd9;
	parameter ACCUM_AND_DONE = 4'd10;
	parameter IDLE		= 4'b1111;
	parameter ROW_SIZE = (DATA_LEN*K);
	parameter MAT_SIZE = (DATA_LEN*K*M);
	parameter CLK_CYCLE = 10;
	
	reg 					 			i_clk	  ;
	reg 					 			i_rstn    ;
	reg 					 			i_start1   ;
	reg 					 			i_start2   ;
	reg   signed [MAT_SIZE-1:0]	  		i_mat_a   ;
    reg   signed [MAT_SIZE-1:0]	  		i_mat_b   ;
	wire  signed [MAT_SIZE-1:0]	  		o_mat_c   ;
	wire  [3:0]						 	o_state   ;
	wire 					 			i_start   ;
	wire							    o_done	 ;
	reg  signed [DATA_LEN-1:0] mode;
	wire signed [DATA_LEN-1:0] parse_mat_a [0:M-1][0:K-1] ;
	wire signed [DATA_LEN-1:0] parse_mat_b [0:K-1][0:N-1] ;
	wire signed [DATA_LEN-1:0] parse_mat_c [0:M-1][0:N-1] ;


	genvar i;
	generate
	for(i=0; i<K; i=i+1) begin: PARSE_MAT_A	    
		assign parse_mat_a[0][i] = i_mat_a[(ROW_SIZE*0) + (DATA_LEN*i) +: DATA_LEN];
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
	for(i=0; i<K; i=i+1) begin: PARSE_MAT_B	    
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

	
	 initial begin
	 	i_clk  = 1'b1; 
	 	i_rstn = 1'b0; 
		i_start1= 1'b0; 
		#10
		i_rstn = 1'b1; 
		#20
		i_start1= 1'b1;
		#10
		i_start1= 1'b0;
		#2000
		$stop;
	 end	

	always #(CLK_CYCLE/2) i_clk = ~i_clk;
	assign i_start = i_start1 | i_start2;
	
	mat_mul u0
	(
		.i_clk    ( i_clk    ),
		.i_rstn   ( i_rstn   ),
		.i_start  ( i_start  ),
		.i_mat_a  ( i_mat_a  ),
		.i_mat_b  ( i_mat_b  ),
		.o_mat_c  ( o_mat_c  ),
		.o_state  ( o_state  ),
		.o_done   ( o_done   )
	);
    
	always @(posedge i_clk, negedge i_rstn) begin
		if(!i_rstn) begin
			mode <= 0;
			i_start2 = 1'b0;
		end
		else begin
			if(o_state == ACCUM_AND_DONE) begin
				mode = mode+1;
				i_start2 = 1'b1;
			end
			else begin
				mode = mode;
				i_start2 = 1'b0;
			end
		end
	end
	
	generate
	for(i=0; i<K; i=i+1) begin: IMPUT_GEN	    
		always @(*) begin
			if((mode == 32'd0)) begin
				
				i_mat_a[(ROW_SIZE*0) + (DATA_LEN*i) +: DATA_LEN] <= 0;
				i_mat_a[(ROW_SIZE*1) + (DATA_LEN*i) +: DATA_LEN] <= 0;
				i_mat_a[(ROW_SIZE*2) + (DATA_LEN*i) +: DATA_LEN] <= 0;
				i_mat_a[(ROW_SIZE*3) + (DATA_LEN*i) +: DATA_LEN] <= 0;
				i_mat_a[(ROW_SIZE*4) + (DATA_LEN*i) +: DATA_LEN] <= 0;
				i_mat_a[(ROW_SIZE*5) + (DATA_LEN*i) +: DATA_LEN] <= 0;
				i_mat_a[(ROW_SIZE*6) + (DATA_LEN*i) +: DATA_LEN] <= 0;
				i_mat_a[(ROW_SIZE*7) + (DATA_LEN*i) +: DATA_LEN] <= 0;
																   
				i_mat_b[(ROW_SIZE*0) + (DATA_LEN*i) +: DATA_LEN] <= 0;
				i_mat_b[(ROW_SIZE*1) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				i_mat_b[(ROW_SIZE*2) + (DATA_LEN*i) +: DATA_LEN] <= 2;
				i_mat_b[(ROW_SIZE*3) + (DATA_LEN*i) +: DATA_LEN] <= 3;
				i_mat_b[(ROW_SIZE*4) + (DATA_LEN*i) +: DATA_LEN] <= 4;
				i_mat_b[(ROW_SIZE*5) + (DATA_LEN*i) +: DATA_LEN] <= 5;
				i_mat_b[(ROW_SIZE*6) + (DATA_LEN*i) +: DATA_LEN] <= 6;
				i_mat_b[(ROW_SIZE*7) + (DATA_LEN*i) +: DATA_LEN] <= 7;
			end                                                        
			else if(mode == 32'd1) begin                                
				i_mat_a[(ROW_SIZE*0) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				i_mat_a[(ROW_SIZE*1) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				i_mat_a[(ROW_SIZE*2) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				i_mat_a[(ROW_SIZE*3) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				i_mat_a[(ROW_SIZE*4) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				i_mat_a[(ROW_SIZE*5) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				i_mat_a[(ROW_SIZE*6) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				i_mat_a[(ROW_SIZE*7) + (DATA_LEN*i) +: DATA_LEN] <= 1;
																   
				i_mat_b[(ROW_SIZE*0) + (DATA_LEN*i) +: DATA_LEN] <= 0;
				i_mat_b[(ROW_SIZE*1) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				i_mat_b[(ROW_SIZE*2) + (DATA_LEN*i) +: DATA_LEN] <= 2;
				i_mat_b[(ROW_SIZE*3) + (DATA_LEN*i) +: DATA_LEN] <= 3;
				i_mat_b[(ROW_SIZE*4) + (DATA_LEN*i) +: DATA_LEN] <= 4;
				i_mat_b[(ROW_SIZE*5) + (DATA_LEN*i) +: DATA_LEN] <= 5;
				i_mat_b[(ROW_SIZE*6) + (DATA_LEN*i) +: DATA_LEN] <= 6;
				i_mat_b[(ROW_SIZE*7) + (DATA_LEN*i) +: DATA_LEN] <= 7;
			end                                                        
			else if(mode == 32'd2) begin                                
																	   
				i_mat_a[(ROW_SIZE*0) + (DATA_LEN*i) +: DATA_LEN] <= 2;
				i_mat_a[(ROW_SIZE*1) + (DATA_LEN*i) +: DATA_LEN] <= 2;
				i_mat_a[(ROW_SIZE*2) + (DATA_LEN*i) +: DATA_LEN] <= 2;
				i_mat_a[(ROW_SIZE*3) + (DATA_LEN*i) +: DATA_LEN] <= 2;
				i_mat_a[(ROW_SIZE*4) + (DATA_LEN*i) +: DATA_LEN] <= 2;
				i_mat_a[(ROW_SIZE*5) + (DATA_LEN*i) +: DATA_LEN] <= 2;
				i_mat_a[(ROW_SIZE*6) + (DATA_LEN*i) +: DATA_LEN] <= 2;
				i_mat_a[(ROW_SIZE*7) + (DATA_LEN*i) +: DATA_LEN] <= 2;
																   
				i_mat_b[(ROW_SIZE*0) + (DATA_LEN*i) +: DATA_LEN] <= 0;
				i_mat_b[(ROW_SIZE*1) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				i_mat_b[(ROW_SIZE*2) + (DATA_LEN*i) +: DATA_LEN] <= 2;
				i_mat_b[(ROW_SIZE*3) + (DATA_LEN*i) +: DATA_LEN] <= 3;
				i_mat_b[(ROW_SIZE*4) + (DATA_LEN*i) +: DATA_LEN] <= 4;
				i_mat_b[(ROW_SIZE*5) + (DATA_LEN*i) +: DATA_LEN] <= 5;
				i_mat_b[(ROW_SIZE*6) + (DATA_LEN*i) +: DATA_LEN] <= 6;
				i_mat_b[(ROW_SIZE*7) + (DATA_LEN*i) +: DATA_LEN] <= 7;
																	   
			end                                                        
			else if(mode == 32'd3) begin                                
																	   
				i_mat_a[(ROW_SIZE*0) + (DATA_LEN*i) +: DATA_LEN] <= 3;
				i_mat_a[(ROW_SIZE*1) + (DATA_LEN*i) +: DATA_LEN] <= 3;
				i_mat_a[(ROW_SIZE*2) + (DATA_LEN*i) +: DATA_LEN] <= 3;
				i_mat_a[(ROW_SIZE*3) + (DATA_LEN*i) +: DATA_LEN] <= 3;
				i_mat_a[(ROW_SIZE*4) + (DATA_LEN*i) +: DATA_LEN] <= 3;
				i_mat_a[(ROW_SIZE*5) + (DATA_LEN*i) +: DATA_LEN] <= 3;
				i_mat_a[(ROW_SIZE*6) + (DATA_LEN*i) +: DATA_LEN] <= 3;
				i_mat_a[(ROW_SIZE*7) + (DATA_LEN*i) +: DATA_LEN] <= 3;
																   
				i_mat_b[(ROW_SIZE*0) + (DATA_LEN*i) +: DATA_LEN] <= 0;
				i_mat_b[(ROW_SIZE*1) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				i_mat_b[(ROW_SIZE*2) + (DATA_LEN*i) +: DATA_LEN] <= 2;
				i_mat_b[(ROW_SIZE*3) + (DATA_LEN*i) +: DATA_LEN] <= 3;
				i_mat_b[(ROW_SIZE*4) + (DATA_LEN*i) +: DATA_LEN] <= 4;
				i_mat_b[(ROW_SIZE*5) + (DATA_LEN*i) +: DATA_LEN] <= 5;
				i_mat_b[(ROW_SIZE*6) + (DATA_LEN*i) +: DATA_LEN] <= 6;
				i_mat_b[(ROW_SIZE*7) + (DATA_LEN*i) +: DATA_LEN] <= 7;
																	   
			end                                                        
			else if(mode == 32'd4) begin                                
																	   
				i_mat_a[(ROW_SIZE*0) + (DATA_LEN*i) +: DATA_LEN] <= 0;
				i_mat_a[(ROW_SIZE*1) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				i_mat_a[(ROW_SIZE*2) + (DATA_LEN*i) +: DATA_LEN] <= 2;
				i_mat_a[(ROW_SIZE*3) + (DATA_LEN*i) +: DATA_LEN] <= 3;
				i_mat_a[(ROW_SIZE*4) + (DATA_LEN*i) +: DATA_LEN] <= 4;
				i_mat_a[(ROW_SIZE*5) + (DATA_LEN*i) +: DATA_LEN] <= 5;
				i_mat_a[(ROW_SIZE*6) + (DATA_LEN*i) +: DATA_LEN] <= 6;
				i_mat_a[(ROW_SIZE*7) + (DATA_LEN*i) +: DATA_LEN] <= 7;
																   
				i_mat_b[(ROW_SIZE*0) + (DATA_LEN*i) +: DATA_LEN] <= 0;
				i_mat_b[(ROW_SIZE*1) + (DATA_LEN*i) +: DATA_LEN] <= 0;
				i_mat_b[(ROW_SIZE*2) + (DATA_LEN*i) +: DATA_LEN] <= 0;
				i_mat_b[(ROW_SIZE*3) + (DATA_LEN*i) +: DATA_LEN] <= 0;
				i_mat_b[(ROW_SIZE*4) + (DATA_LEN*i) +: DATA_LEN] <= 0;
				i_mat_b[(ROW_SIZE*5) + (DATA_LEN*i) +: DATA_LEN] <= 0;
				i_mat_b[(ROW_SIZE*6) + (DATA_LEN*i) +: DATA_LEN] <= 0;
				i_mat_b[(ROW_SIZE*7) + (DATA_LEN*i) +: DATA_LEN] <= 0;
																	   
			end                                                        
			else if(mode == 32'd5) begin                                
																	   
				i_mat_a[(ROW_SIZE*0) + (DATA_LEN*i) +: DATA_LEN] <= 0;
				i_mat_a[(ROW_SIZE*1) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				i_mat_a[(ROW_SIZE*2) + (DATA_LEN*i) +: DATA_LEN] <= 2;
				i_mat_a[(ROW_SIZE*3) + (DATA_LEN*i) +: DATA_LEN] <= 3;
				i_mat_a[(ROW_SIZE*4) + (DATA_LEN*i) +: DATA_LEN] <= 4;
				i_mat_a[(ROW_SIZE*5) + (DATA_LEN*i) +: DATA_LEN] <= 5;
				i_mat_a[(ROW_SIZE*6) + (DATA_LEN*i) +: DATA_LEN] <= 6;
				i_mat_a[(ROW_SIZE*7) + (DATA_LEN*i) +: DATA_LEN] <= 7;
																   
				i_mat_b[(ROW_SIZE*0) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				i_mat_b[(ROW_SIZE*1) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				i_mat_b[(ROW_SIZE*2) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				i_mat_b[(ROW_SIZE*3) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				i_mat_b[(ROW_SIZE*4) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				i_mat_b[(ROW_SIZE*5) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				i_mat_b[(ROW_SIZE*6) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				i_mat_b[(ROW_SIZE*7) + (DATA_LEN*i) +: DATA_LEN] <= 1;
																	   
			end                                                        
			else if(mode == 32'd6) begin                                
																	   
				i_mat_a[(ROW_SIZE*0) + (DATA_LEN*i) +: DATA_LEN] <= 0;
				i_mat_a[(ROW_SIZE*1) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				i_mat_a[(ROW_SIZE*2) + (DATA_LEN*i) +: DATA_LEN] <= 2;
				i_mat_a[(ROW_SIZE*3) + (DATA_LEN*i) +: DATA_LEN] <= 3;
				i_mat_a[(ROW_SIZE*4) + (DATA_LEN*i) +: DATA_LEN] <= 4;
				i_mat_a[(ROW_SIZE*5) + (DATA_LEN*i) +: DATA_LEN] <= 5;
				i_mat_a[(ROW_SIZE*6) + (DATA_LEN*i) +: DATA_LEN] <= 6;
				i_mat_a[(ROW_SIZE*7) + (DATA_LEN*i) +: DATA_LEN] <= 7;
																   
				i_mat_b[(ROW_SIZE*0) + (DATA_LEN*i) +: DATA_LEN] <= 2;
				i_mat_b[(ROW_SIZE*1) + (DATA_LEN*i) +: DATA_LEN] <= 2;
				i_mat_b[(ROW_SIZE*2) + (DATA_LEN*i) +: DATA_LEN] <= 2;
				i_mat_b[(ROW_SIZE*3) + (DATA_LEN*i) +: DATA_LEN] <= 2;
				i_mat_b[(ROW_SIZE*4) + (DATA_LEN*i) +: DATA_LEN] <= 2;
				i_mat_b[(ROW_SIZE*5) + (DATA_LEN*i) +: DATA_LEN] <= 2;
				i_mat_b[(ROW_SIZE*6) + (DATA_LEN*i) +: DATA_LEN] <= 2;
				i_mat_b[(ROW_SIZE*7) + (DATA_LEN*i) +: DATA_LEN] <= 2;
																	   
			end                                                        
			else if(mode == 32'd7) begin                                                
																	   
				i_mat_a[(ROW_SIZE*0) + (DATA_LEN*i) +: DATA_LEN] <= 0;
				i_mat_a[(ROW_SIZE*1) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				i_mat_a[(ROW_SIZE*2) + (DATA_LEN*i) +: DATA_LEN] <= 2;
				i_mat_a[(ROW_SIZE*3) + (DATA_LEN*i) +: DATA_LEN] <= 3;
				i_mat_a[(ROW_SIZE*4) + (DATA_LEN*i) +: DATA_LEN] <= 4;
				i_mat_a[(ROW_SIZE*5) + (DATA_LEN*i) +: DATA_LEN] <= 5;
				i_mat_a[(ROW_SIZE*6) + (DATA_LEN*i) +: DATA_LEN] <= 6;
				i_mat_a[(ROW_SIZE*7) + (DATA_LEN*i) +: DATA_LEN] <= 7;
																   
				i_mat_b[(ROW_SIZE*0) + (DATA_LEN*i) +: DATA_LEN] <= 3;
				i_mat_b[(ROW_SIZE*1) + (DATA_LEN*i) +: DATA_LEN] <= 3;
				i_mat_b[(ROW_SIZE*2) + (DATA_LEN*i) +: DATA_LEN] <= 3;
				i_mat_b[(ROW_SIZE*3) + (DATA_LEN*i) +: DATA_LEN] <= 3;
				i_mat_b[(ROW_SIZE*4) + (DATA_LEN*i) +: DATA_LEN] <= 3;
				i_mat_b[(ROW_SIZE*5) + (DATA_LEN*i) +: DATA_LEN] <= 3;
				i_mat_b[(ROW_SIZE*6) + (DATA_LEN*i) +: DATA_LEN] <= 3;
				i_mat_b[(ROW_SIZE*7) + (DATA_LEN*i) +: DATA_LEN] <= 3;
				
			end
			else begin                        													   
				i_mat_a[(ROW_SIZE*0) + (DATA_LEN*i) +: DATA_LEN] <= 0;
				i_mat_a[(ROW_SIZE*1) + (DATA_LEN*i) +: DATA_LEN] <= 0;
				i_mat_a[(ROW_SIZE*2) + (DATA_LEN*i) +: DATA_LEN] <= 0;
				i_mat_a[(ROW_SIZE*3) + (DATA_LEN*i) +: DATA_LEN] <= 0;
				i_mat_a[(ROW_SIZE*4) + (DATA_LEN*i) +: DATA_LEN] <= 0;
				i_mat_a[(ROW_SIZE*5) + (DATA_LEN*i) +: DATA_LEN] <= 0;
				i_mat_a[(ROW_SIZE*6) + (DATA_LEN*i) +: DATA_LEN] <= 0;
				i_mat_a[(ROW_SIZE*7) + (DATA_LEN*i) +: DATA_LEN] <= 0;
																   
				i_mat_b[(ROW_SIZE*0) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				i_mat_b[(ROW_SIZE*1) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				i_mat_b[(ROW_SIZE*2) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				i_mat_b[(ROW_SIZE*3) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				i_mat_b[(ROW_SIZE*4) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				i_mat_b[(ROW_SIZE*5) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				i_mat_b[(ROW_SIZE*6) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				i_mat_b[(ROW_SIZE*7) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				
			end
		end
		
	end
	endgenerate
	
	
	
endmodule