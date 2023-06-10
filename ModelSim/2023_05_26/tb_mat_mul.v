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
			// else begin                        													   
			// 	i_mat_a[(ROW_SIZE*0) + (DATA_LEN*i) +: DATA_LEN] <= 0;
			// 	i_mat_a[(ROW_SIZE*1) + (DATA_LEN*i) +: DATA_LEN] <= 0;
			// 	i_mat_a[(ROW_SIZE*2) + (DATA_LEN*i) +: DATA_LEN] <= 0;
			// 	i_mat_a[(ROW_SIZE*3) + (DATA_LEN*i) +: DATA_LEN] <= 0;
			// 	i_mat_a[(ROW_SIZE*4) + (DATA_LEN*i) +: DATA_LEN] <= 0;
			// 	i_mat_a[(ROW_SIZE*5) + (DATA_LEN*i) +: DATA_LEN] <= 0;
			// 	i_mat_a[(ROW_SIZE*6) + (DATA_LEN*i) +: DATA_LEN] <= 0;
			// 	i_mat_a[(ROW_SIZE*7) + (DATA_LEN*i) +: DATA_LEN] <= 0;
																   
			// 	i_mat_b[(ROW_SIZE*0) + (DATA_LEN*i) +: DATA_LEN] <= 1;
			// 	i_mat_b[(ROW_SIZE*1) + (DATA_LEN*i) +: DATA_LEN] <= 1;
			// 	i_mat_b[(ROW_SIZE*2) + (DATA_LEN*i) +: DATA_LEN] <= 1;
			// 	i_mat_b[(ROW_SIZE*3) + (DATA_LEN*i) +: DATA_LEN] <= 1;
			// 	i_mat_b[(ROW_SIZE*4) + (DATA_LEN*i) +: DATA_LEN] <= 1;
			// 	i_mat_b[(ROW_SIZE*5) + (DATA_LEN*i) +: DATA_LEN] <= 1;
			// 	i_mat_b[(ROW_SIZE*6) + (DATA_LEN*i) +: DATA_LEN] <= 1;
			// 	i_mat_b[(ROW_SIZE*7) + (DATA_LEN*i) +: DATA_LEN] <= 1;
				
			// end
		end
		
	end
	endgenerate

	always @(*) begin
		if((mode == 32'd8)) begin
			i_mat_a[(ROW_SIZE*0) + (DATA_LEN*0) +: DATA_LEN] <= 0;
			i_mat_a[(ROW_SIZE*0) + (DATA_LEN*1) +: DATA_LEN] <= 1;
			i_mat_a[(ROW_SIZE*0) + (DATA_LEN*2) +: DATA_LEN] <= 2;
			i_mat_a[(ROW_SIZE*0) + (DATA_LEN*3) +: DATA_LEN] <= 3;
			i_mat_a[(ROW_SIZE*0) + (DATA_LEN*4) +: DATA_LEN] <= 4;
			i_mat_a[(ROW_SIZE*0) + (DATA_LEN*5) +: DATA_LEN] <= 5;
			i_mat_a[(ROW_SIZE*0) + (DATA_LEN*6) +: DATA_LEN] <= 6;
			i_mat_a[(ROW_SIZE*0) + (DATA_LEN*7) +: DATA_LEN] <= 7;

			i_mat_a[(ROW_SIZE*1) + (DATA_LEN*0) +: DATA_LEN] <= 8;
			i_mat_a[(ROW_SIZE*1) + (DATA_LEN*1) +: DATA_LEN] <= 9;
			i_mat_a[(ROW_SIZE*1) + (DATA_LEN*2) +: DATA_LEN] <= 10;
			i_mat_a[(ROW_SIZE*1) + (DATA_LEN*3) +: DATA_LEN] <= 11;
			i_mat_a[(ROW_SIZE*1) + (DATA_LEN*4) +: DATA_LEN] <= 12;
			i_mat_a[(ROW_SIZE*1) + (DATA_LEN*5) +: DATA_LEN] <= 13;
			i_mat_a[(ROW_SIZE*1) + (DATA_LEN*6) +: DATA_LEN] <= 14;
			i_mat_a[(ROW_SIZE*1) + (DATA_LEN*7) +: DATA_LEN] <= 15;

			i_mat_a[(ROW_SIZE*2) + (DATA_LEN*0) +: DATA_LEN] <= 16;
			i_mat_a[(ROW_SIZE*2) + (DATA_LEN*1) +: DATA_LEN] <= 17;
			i_mat_a[(ROW_SIZE*2) + (DATA_LEN*2) +: DATA_LEN] <= 18;
			i_mat_a[(ROW_SIZE*2) + (DATA_LEN*3) +: DATA_LEN] <= 19;
			i_mat_a[(ROW_SIZE*2) + (DATA_LEN*4) +: DATA_LEN] <= 20;
			i_mat_a[(ROW_SIZE*2) + (DATA_LEN*5) +: DATA_LEN] <= 21;
			i_mat_a[(ROW_SIZE*2) + (DATA_LEN*6) +: DATA_LEN] <= 22;
			i_mat_a[(ROW_SIZE*2) + (DATA_LEN*7) +: DATA_LEN] <= 23;

			i_mat_a[(ROW_SIZE*3) + (DATA_LEN*0) +: DATA_LEN] <= 24;
			i_mat_a[(ROW_SIZE*3) + (DATA_LEN*1) +: DATA_LEN] <= 25;
			i_mat_a[(ROW_SIZE*3) + (DATA_LEN*2) +: DATA_LEN] <= 26;
			i_mat_a[(ROW_SIZE*3) + (DATA_LEN*3) +: DATA_LEN] <= 27;
			i_mat_a[(ROW_SIZE*3) + (DATA_LEN*4) +: DATA_LEN] <= 28;
			i_mat_a[(ROW_SIZE*3) + (DATA_LEN*5) +: DATA_LEN] <= 29;
			i_mat_a[(ROW_SIZE*3) + (DATA_LEN*6) +: DATA_LEN] <= 30;
			i_mat_a[(ROW_SIZE*3) + (DATA_LEN*7) +: DATA_LEN] <= 31;

			i_mat_a[(ROW_SIZE*4) + (DATA_LEN*0) +: DATA_LEN] <= 32;
			i_mat_a[(ROW_SIZE*4) + (DATA_LEN*1) +: DATA_LEN] <= 33;
			i_mat_a[(ROW_SIZE*4) + (DATA_LEN*2) +: DATA_LEN] <= 34;
			i_mat_a[(ROW_SIZE*4) + (DATA_LEN*3) +: DATA_LEN] <= 35;
			i_mat_a[(ROW_SIZE*4) + (DATA_LEN*4) +: DATA_LEN] <= 36;
			i_mat_a[(ROW_SIZE*4) + (DATA_LEN*5) +: DATA_LEN] <= 37;
			i_mat_a[(ROW_SIZE*4) + (DATA_LEN*6) +: DATA_LEN] <= 38;
			i_mat_a[(ROW_SIZE*4) + (DATA_LEN*7) +: DATA_LEN] <= 39;

			i_mat_a[(ROW_SIZE*5) + (DATA_LEN*0) +: DATA_LEN] <= 40;
			i_mat_a[(ROW_SIZE*5) + (DATA_LEN*1) +: DATA_LEN] <= 41;
			i_mat_a[(ROW_SIZE*5) + (DATA_LEN*2) +: DATA_LEN] <= 42;
			i_mat_a[(ROW_SIZE*5) + (DATA_LEN*3) +: DATA_LEN] <= 43;
			i_mat_a[(ROW_SIZE*5) + (DATA_LEN*4) +: DATA_LEN] <= 44;
			i_mat_a[(ROW_SIZE*5) + (DATA_LEN*5) +: DATA_LEN] <= 45;
			i_mat_a[(ROW_SIZE*5) + (DATA_LEN*6) +: DATA_LEN] <= 46;
			i_mat_a[(ROW_SIZE*5) + (DATA_LEN*7) +: DATA_LEN] <= 47;

			i_mat_a[(ROW_SIZE*6) + (DATA_LEN*0) +: DATA_LEN] <= 48;
			i_mat_a[(ROW_SIZE*6) + (DATA_LEN*1) +: DATA_LEN] <= 49;
			i_mat_a[(ROW_SIZE*6) + (DATA_LEN*2) +: DATA_LEN] <= 50;
			i_mat_a[(ROW_SIZE*6) + (DATA_LEN*3) +: DATA_LEN] <= 51;
			i_mat_a[(ROW_SIZE*6) + (DATA_LEN*4) +: DATA_LEN] <= 52;
			i_mat_a[(ROW_SIZE*6) + (DATA_LEN*5) +: DATA_LEN] <= 53;
			i_mat_a[(ROW_SIZE*6) + (DATA_LEN*6) +: DATA_LEN] <= 54;
			i_mat_a[(ROW_SIZE*6) + (DATA_LEN*7) +: DATA_LEN] <= 55;

			i_mat_a[(ROW_SIZE*7) + (DATA_LEN*0) +: DATA_LEN] <= 56;
			i_mat_a[(ROW_SIZE*7) + (DATA_LEN*1) +: DATA_LEN] <= 57;
			i_mat_a[(ROW_SIZE*7) + (DATA_LEN*2) +: DATA_LEN] <= 58;
			i_mat_a[(ROW_SIZE*7) + (DATA_LEN*3) +: DATA_LEN] <= 59;
			i_mat_a[(ROW_SIZE*7) + (DATA_LEN*4) +: DATA_LEN] <= 60;
			i_mat_a[(ROW_SIZE*7) + (DATA_LEN*5) +: DATA_LEN] <= 61;
			i_mat_a[(ROW_SIZE*7) + (DATA_LEN*6) +: DATA_LEN] <= 62;
			i_mat_a[(ROW_SIZE*7) + (DATA_LEN*7) +: DATA_LEN] <= 63;


			i_mat_b[(ROW_SIZE*0) + (DATA_LEN*0) +: DATA_LEN] <= 0;
			i_mat_b[(ROW_SIZE*0) + (DATA_LEN*1) +: DATA_LEN] <= 2;
			i_mat_b[(ROW_SIZE*0) + (DATA_LEN*2) +: DATA_LEN] <= 4;
			i_mat_b[(ROW_SIZE*0) + (DATA_LEN*3) +: DATA_LEN] <= 6;
			i_mat_b[(ROW_SIZE*0) + (DATA_LEN*4) +: DATA_LEN] <= 8;
			i_mat_b[(ROW_SIZE*0) + (DATA_LEN*5) +: DATA_LEN] <= 10;
			i_mat_b[(ROW_SIZE*0) + (DATA_LEN*6) +: DATA_LEN] <= 12;
			i_mat_b[(ROW_SIZE*0) + (DATA_LEN*7) +: DATA_LEN] <= 14;

			i_mat_b[(ROW_SIZE*1) + (DATA_LEN*0) +: DATA_LEN] <= 16;
			i_mat_b[(ROW_SIZE*1) + (DATA_LEN*1) +: DATA_LEN] <= 18;
			i_mat_b[(ROW_SIZE*1) + (DATA_LEN*2) +: DATA_LEN] <= 20;
			i_mat_b[(ROW_SIZE*1) + (DATA_LEN*3) +: DATA_LEN] <= 22;
			i_mat_b[(ROW_SIZE*1) + (DATA_LEN*4) +: DATA_LEN] <= 24;
			i_mat_b[(ROW_SIZE*1) + (DATA_LEN*5) +: DATA_LEN] <= 26;
			i_mat_b[(ROW_SIZE*1) + (DATA_LEN*6) +: DATA_LEN] <= 28;
			i_mat_b[(ROW_SIZE*1) + (DATA_LEN*7) +: DATA_LEN] <= 30;

			i_mat_b[(ROW_SIZE*2) + (DATA_LEN*0) +: DATA_LEN] <= 32;
			i_mat_b[(ROW_SIZE*2) + (DATA_LEN*1) +: DATA_LEN] <= 34;
			i_mat_b[(ROW_SIZE*2) + (DATA_LEN*2) +: DATA_LEN] <= 36;
			i_mat_b[(ROW_SIZE*2) + (DATA_LEN*3) +: DATA_LEN] <= 38;
			i_mat_b[(ROW_SIZE*2) + (DATA_LEN*4) +: DATA_LEN] <= 40;
			i_mat_b[(ROW_SIZE*2) + (DATA_LEN*5) +: DATA_LEN] <= 42;
			i_mat_b[(ROW_SIZE*2) + (DATA_LEN*6) +: DATA_LEN] <= 44;
			i_mat_b[(ROW_SIZE*2) + (DATA_LEN*7) +: DATA_LEN] <= 46;

			i_mat_b[(ROW_SIZE*3) + (DATA_LEN*0) +: DATA_LEN] <= 48;
			i_mat_b[(ROW_SIZE*3) + (DATA_LEN*1) +: DATA_LEN] <= 50;
			i_mat_b[(ROW_SIZE*3) + (DATA_LEN*2) +: DATA_LEN] <= 52;
			i_mat_b[(ROW_SIZE*3) + (DATA_LEN*3) +: DATA_LEN] <= 54;
			i_mat_b[(ROW_SIZE*3) + (DATA_LEN*4) +: DATA_LEN] <= 56;
			i_mat_b[(ROW_SIZE*3) + (DATA_LEN*5) +: DATA_LEN] <= 58;
			i_mat_b[(ROW_SIZE*3) + (DATA_LEN*6) +: DATA_LEN] <= 60;
			i_mat_b[(ROW_SIZE*3) + (DATA_LEN*7) +: DATA_LEN] <= 62;

			i_mat_b[(ROW_SIZE*4) + (DATA_LEN*0) +: DATA_LEN] <= 64;
			i_mat_b[(ROW_SIZE*4) + (DATA_LEN*1) +: DATA_LEN] <= 66;
			i_mat_b[(ROW_SIZE*4) + (DATA_LEN*2) +: DATA_LEN] <= 68;
			i_mat_b[(ROW_SIZE*4) + (DATA_LEN*3) +: DATA_LEN] <= 70;
			i_mat_b[(ROW_SIZE*4) + (DATA_LEN*4) +: DATA_LEN] <= 72;
			i_mat_b[(ROW_SIZE*4) + (DATA_LEN*5) +: DATA_LEN] <= 74;
			i_mat_b[(ROW_SIZE*4) + (DATA_LEN*6) +: DATA_LEN] <= 76;
			i_mat_b[(ROW_SIZE*4) + (DATA_LEN*7) +: DATA_LEN] <= 78;

			i_mat_b[(ROW_SIZE*5) + (DATA_LEN*0) +: DATA_LEN] <= 80;
			i_mat_b[(ROW_SIZE*5) + (DATA_LEN*1) +: DATA_LEN] <= 82;
			i_mat_b[(ROW_SIZE*5) + (DATA_LEN*2) +: DATA_LEN] <= 84;
			i_mat_b[(ROW_SIZE*5) + (DATA_LEN*3) +: DATA_LEN] <= 86;
			i_mat_b[(ROW_SIZE*5) + (DATA_LEN*4) +: DATA_LEN] <= 88;
			i_mat_b[(ROW_SIZE*5) + (DATA_LEN*5) +: DATA_LEN] <= 90;
			i_mat_b[(ROW_SIZE*5) + (DATA_LEN*6) +: DATA_LEN] <= 92;
			i_mat_b[(ROW_SIZE*5) + (DATA_LEN*7) +: DATA_LEN] <= 94;

			i_mat_b[(ROW_SIZE*6) + (DATA_LEN*0) +: DATA_LEN] <= 96;
			i_mat_b[(ROW_SIZE*6) + (DATA_LEN*1) +: DATA_LEN] <= 98;
			i_mat_b[(ROW_SIZE*6) + (DATA_LEN*2) +: DATA_LEN] <= 100;
			i_mat_b[(ROW_SIZE*6) + (DATA_LEN*3) +: DATA_LEN] <= 102;
			i_mat_b[(ROW_SIZE*6) + (DATA_LEN*4) +: DATA_LEN] <= 104;
			i_mat_b[(ROW_SIZE*6) + (DATA_LEN*5) +: DATA_LEN] <= 106;
			i_mat_b[(ROW_SIZE*6) + (DATA_LEN*6) +: DATA_LEN] <= 108;
			i_mat_b[(ROW_SIZE*6) + (DATA_LEN*7) +: DATA_LEN] <= 110;

			i_mat_b[(ROW_SIZE*7) + (DATA_LEN*0) +: DATA_LEN] <= 112;
			i_mat_b[(ROW_SIZE*7) + (DATA_LEN*1) +: DATA_LEN] <= 114;
			i_mat_b[(ROW_SIZE*7) + (DATA_LEN*2) +: DATA_LEN] <= 116;
			i_mat_b[(ROW_SIZE*7) + (DATA_LEN*3) +: DATA_LEN] <= 118;
			i_mat_b[(ROW_SIZE*7) + (DATA_LEN*4) +: DATA_LEN] <= 120;
			i_mat_b[(ROW_SIZE*7) + (DATA_LEN*5) +: DATA_LEN] <= 122;
			i_mat_b[(ROW_SIZE*7) + (DATA_LEN*6) +: DATA_LEN] <= 124;
			i_mat_b[(ROW_SIZE*7) + (DATA_LEN*7) +: DATA_LEN] <= 126;
																
		end
	end
	
endmodule