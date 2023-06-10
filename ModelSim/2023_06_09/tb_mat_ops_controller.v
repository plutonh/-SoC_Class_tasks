`timescale 1ns/1ns
module tb_mat_ops_controller;

	parameter DATA_LEN = 32;
	parameter M = 8;
	parameter N = 8;
	parameter K = 8;
	parameter CLK_CYCLE = 10;
	parameter ADDRESS_SIZE = 4;
	
	reg i_clk;
	reg i_rstn;
	
	reg   [DATA_LEN*N-1:0]	  	  	  i_read_data_A;
	wire   [ADDRESS_SIZE-1:0]	  	  o_address_A;
	wire  						        o_wr_en_A;
	
	///////////// read b //////////
	reg   [DATA_LEN*N-1:0]	  	     i_read_data_B;
	wire	 [ADDRESS_SIZE-1:0]	  	  o_address_B;
	wire  						        o_wr_en_B;

	///////////// write b//////////	
	wire  [DATA_LEN*N-1:0]	  	     o_write_data_B, o_write_data_A;
	
	wire  [2:0]					        o_state;
	wire	[3:0]					        o_read_state;
	wire	[3:0]					        o_mat_mul_state;
	wire	[3:0]					        o_write_state;
	wire							        o_done;

	wire [DATA_LEN-1:0]	parse_read_data_A [N-1:0];
	wire [DATA_LEN-1:0]	parse_read_data_B [M-1:0];
	wire [DATA_LEN-1:0]	parse_write_data_A [N-1:0];
	wire [DATA_LEN-1:0]	parse_write_data_B [M-1:0];

genvar i;
generate
	for(i=0; i<K; i=i+1) begin: PARSE_DATA
		assign parse_read_data_A[i] = i_read_data_A[(DATA_LEN)*(i) +: (DATA_LEN)];
		assign parse_read_data_B[i] = i_read_data_B[(DATA_LEN)*(i) +: (DATA_LEN)];
		assign parse_write_data_A[i] = o_write_data_A[(DATA_LEN)*(i) +: (DATA_LEN)];
		assign parse_write_data_B[i] = o_write_data_B[(DATA_LEN)*(i) +: (DATA_LEN)];
	end
endgenerate

	 initial begin
	 	i_clk = 1'b0; 
	 	i_rstn = 1'b0; 

	 	#10
	 	i_rstn = 1'b1;
	 	#5
		i_read_data_A = 256'hx00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000;
		i_read_data_B = 256'hx00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000;
	 	#10
		i_read_data_A = 256'hx00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000001;
		i_read_data_B = 256'hx00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000;
		
		#10
		#11
		i_read_data_A = 256'hx00000007_00000006_00000005_00000004_00000003_00000002_00000001_00000000;
		i_read_data_B = 256'hx0000000e_0000000c_0000000a_00000008_00000006_00000004_00000002_00000000;
		#10
		i_read_data_A = 256'hx0000000f_0000000e_0000000d_0000000c_0000000b_0000000a_00000009_00000008;
		i_read_data_B = 256'hx0000001e_0000001c_0000001a_00000018_00000016_00000014_00000012_00000010;
		#10
		i_read_data_A = 256'hx00000017_00000016_00000015_00000014_00000013_00000012_00000011_00000010;
		i_read_data_B = 256'hx0000002e_0000002c_0000002a_00000028_00000026_00000024_00000022_00000020;
		#10
		i_read_data_A = 256'hx0000001f_0000001e_0000001d_0000001c_0000001b_0000001a_00000019_00000018;
		i_read_data_B = 256'hx0000003e_0000003c_0000003a_00000038_00000036_00000034_00000032_00000030;
		#10
		i_read_data_A = 256'hx00000027_00000026_00000025_00000024_00000023_00000022_00000021_00000020;
		i_read_data_B = 256'hx0000004e_0000004c_0000004a_00000048_00000046_00000044_00000042_00000040;
		#10
		i_read_data_A = 256'hx0000002f_0000002e_0000002d_0000002c_0000002b_0000002a_00000029_00000028;
		i_read_data_B = 256'hx0000005e_0000005c_0000005a_00000058_00000056_00000054_00000052_00000050;
		#10
		i_read_data_A = 256'hx00000037_00000036_00000035_00000034_00000033_00000032_00000031_00000030;
		i_read_data_B = 256'hx0000006e_0000006c_0000006a_00000068_00000066_00000064_00000062_00000060;
		#10
		i_read_data_A = 256'hx0000003f_0000003e_0000003d_0000003c_0000003b_0000003a_00000039_00000038;
		i_read_data_B = 256'hx0000007e_0000007c_0000007a_00000078_00000076_00000074_00000072_00000070;
	 	#10
		//i_read_data_A = 256'hx00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000001;
		
		#1000
		$stop;
	 end	

	always #(CLK_CYCLE/2) i_clk = ~i_clk;

	mat_ops_controller u0(
		.i_clk		       (i_clk),		
		.i_rstn		    (i_rstn),
		.i_read_data_A   (i_read_data_A),
		.o_address_A     ( o_address_A),
		.o_wr_en_A       ( o_wr_en_A),
		.o_write_data_A  (o_write_data_A),			  
		.i_read_data_B   ( i_read_data_B),
		.o_address_B     ( o_address_B),
		.o_wr_en_B       ( o_wr_en_B),					  
		.o_write_data_B  ( o_write_data_B),					 
		.o_state         ( o_state),
		.o_read_state    ( o_read_state),
		.o_mat_mul_state (o_mat_mul_state ),
		.o_write_state   (o_write_state ),
		.o_done          ( o_done)
	);
	
	// M10K_16_256_test  MEM( 
	// 	.i_clk				(i_clk		   ),
	// 	.i_rstn             (i_rstn        ),
	// 	.i_twice			(o_done		   ),
	// 	.o_read_data    	(i_read_data),
	// 	.i_write_data   	(o_write_data),
	// 	.i_address      	(o_address),
	// 	.i_wr_en        	(o_wr_en),
	// 	.o_mem      		(mem)
	// );
	
endmodule

// module M10K_16_256_test#(
// 	parameter DATA_LEN = 32,
// 	parameter M = 8,
// 	parameter N = 8,
// 	parameter ADDRESS_SIZE = 4
// )( 
// 	input 						  i_clk,
// 	input 						  i_rstn,
// 	input						  i_twice,
//     output reg [(DATA_LEN*N)-1:0] o_read_data,
//     input 	   [(DATA_LEN*N)-1:0] i_write_data,
//     input 	   [ADDRESS_SIZE-1:0] i_address,
// 	input 						  i_wr_en,
// 	output [(DATA_LEN*N*M*2)-1:0] o_mem
// );
// 	 // force M10K ram style
// 	 // 256 words of 32 bits
//     reg [(DATA_LEN*N)-1:0] mem_row [0:2*M-1]  /* synthesis ramstyle = "no_rw_check, M10K" */;
	
// 	assign o_mem = {mem_row[15], mem_row[14], mem_row[13], mem_row[12], mem_row[11], mem_row[10], mem_row[9], mem_row[8], mem_row[7], mem_row[6], mem_row[5], mem_row[4], mem_row[3], mem_row[2], mem_row[1], mem_row[0]};
		 
//     always @ (posedge i_clk, negedge i_rstn) begin
// 		if(!i_rstn) begin
		
// 				mem_row[ 0] <= {(32'd7 + ( 0)*32'd8), (32'd6 + ( 0)*32'd8), (32'd5 + ( 0)*32'd8), (32'd4 + ( 0)*32'd8), (32'd3 + ( 0)*32'd8), (32'd2 + ( 0)*32'd8), (32'd1 + ( 0)*32'd8), (32'd0 + ( 0)*32'd8)};
// 				mem_row[ 1] <= {(32'd7 + ( 1)*32'd8), (32'd6 + ( 1)*32'd8), (32'd5 + ( 1)*32'd8), (32'd4 + ( 1)*32'd8), (32'd3 + ( 1)*32'd8), (32'd2 + ( 1)*32'd8), (32'd1 + ( 1)*32'd8), (32'd0 + ( 1)*32'd8)};
// 				mem_row[ 2] <= {(32'd7 + ( 2)*32'd8), (32'd6 + ( 2)*32'd8), (32'd5 + ( 2)*32'd8), (32'd4 + ( 2)*32'd8), (32'd3 + ( 2)*32'd8), (32'd2 + ( 2)*32'd8), (32'd1 + ( 2)*32'd8), (32'd0 + ( 2)*32'd8)};
// 				mem_row[ 3] <= {(32'd7 + ( 3)*32'd8), (32'd6 + ( 3)*32'd8), (32'd5 + ( 3)*32'd8), (32'd4 + ( 3)*32'd8), (32'd3 + ( 3)*32'd8), (32'd2 + ( 3)*32'd8), (32'd1 + ( 3)*32'd8), (32'd0 + ( 3)*32'd8)};
// 				mem_row[ 4] <= {(32'd7 + ( 4)*32'd8), (32'd6 + ( 4)*32'd8), (32'd5 + ( 4)*32'd8), (32'd4 + ( 4)*32'd8), (32'd3 + ( 4)*32'd8), (32'd2 + ( 4)*32'd8), (32'd1 + ( 4)*32'd8), (32'd0 + ( 4)*32'd8)};
// 				mem_row[ 5] <= {(32'd7 + ( 5)*32'd8), (32'd6 + ( 5)*32'd8), (32'd5 + ( 5)*32'd8), (32'd4 + ( 5)*32'd8), (32'd3 + ( 5)*32'd8), (32'd2 + ( 5)*32'd8), (32'd1 + ( 5)*32'd8), (32'd0 + ( 5)*32'd8)};
// 				mem_row[ 6] <= {(32'd7 + ( 6)*32'd8), (32'd6 + ( 6)*32'd8), (32'd5 + ( 6)*32'd8), (32'd4 + ( 6)*32'd8), (32'd3 + ( 6)*32'd8), (32'd2 + ( 6)*32'd8), (32'd1 + ( 6)*32'd8), (32'd0 + ( 6)*32'd8)};
// 				mem_row[ 7] <= {(32'd7 + ( 7)*32'd8), (32'd6 + ( 7)*32'd8), (32'd5 + ( 7)*32'd8), (32'd4 + ( 7)*32'd8), (32'd3 + ( 7)*32'd8), (32'd2 + ( 7)*32'd8), (32'd1 + ( 7)*32'd8), (32'd0 + ( 7)*32'd8)};
// 				mem_row[ 8] <= {(DATA_LEN*N)*{1'b0}};
// 				mem_row[ 9] <= {(DATA_LEN*N)*{1'b0}};
// 				mem_row[10] <= {(DATA_LEN*N)*{1'b0}};
// 				mem_row[11] <= {(DATA_LEN*N)*{1'b0}};
// 				mem_row[12] <= {(DATA_LEN*N)*{1'b0}};
// 				mem_row[13] <= {(DATA_LEN*N)*{1'b0}};
// 				mem_row[14] <= {(DATA_LEN*N)*{1'b0}};
// 				mem_row[15] <= {(DATA_LEN*N)*{1'b0}};

// 		end
// 		else begin
// 			if(i_twice) begin
// 				mem_row[ 0] <= mem_row[ 0] << 2;
// 				mem_row[ 1] <= mem_row[ 1] << 2;
// 				mem_row[ 2] <= mem_row[ 2] << 2;
// 				mem_row[ 3] <= mem_row[ 3] << 2;
// 			    mem_row[ 4] <= mem_row[ 4] << 2;
// 			    mem_row[ 5] <= mem_row[ 5] << 2;
// 			    mem_row[ 6] <= mem_row[ 6] << 2;
// 			    mem_row[ 7] <= mem_row[ 7] << 2;
// 			    mem_row[ 8] <= mem_row[ 8] ;
// 			    mem_row[ 9] <= mem_row[ 9] ;
// 			    mem_row[10] <= mem_row[10] ;
// 			    mem_row[11] <= mem_row[11] ;
// 			    mem_row[12] <= mem_row[12] ;
// 			    mem_row[13] <= mem_row[13] ;
// 			    mem_row[14] <= mem_row[14] ;
// 			    mem_row[15] <= mem_row[15] ;
// 			end
// 			else if (i_wr_en) begin
// 				mem_row[i_address] <= i_write_data;
// 			end
// 			else begin
// 				o_read_data <= mem_row[i_address];
// 			end
// 		end
//     end
// endmodule