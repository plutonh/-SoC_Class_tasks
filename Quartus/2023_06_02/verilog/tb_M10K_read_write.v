`timescale 1ns/1ns
module tb_M10K_read_write;

	parameter DATA_LEN = 32;
	parameter M = 8;
	parameter N = 8;
	parameter K = 8;
	parameter CLK_CYCLE = 10;
	parameter ADDRESS_SIZE = 4;
	
	reg								  i_clk;
	reg								  i_rstn;
	reg								  i_start;
	
	///////////// read  //////////
	wire    [DATA_LEN*N-1:0]	  	  i_read_data;
	wire	[ADDRESS_SIZE-1:0]	  	  o_address;
	wire  						      o_wr_en;

	///////////// writeb//////////	
	wire  [DATA_LEN*N-1:0]	  		  o_write_data;
	wire   [2:0]					  o_state;
	wire							  o_done;
	
	

	wire [(DATA_LEN*N*2*M)-1:0] 	  mem;
	wire [(DATA_LEN)-1:0] 		  	  parse_mem [0:2*M-1][0:N-1];

	genvar j;
	generate
		for(j=0; j<N; j=j+1) begin: PARSE_MEM
			assign parse_mem[ 0][j] = mem[(DATA_LEN*N* 0) + (DATA_LEN*j) +: (DATA_LEN)];
			assign parse_mem[ 1][j] = mem[(DATA_LEN*N* 1) + (DATA_LEN*j) +: (DATA_LEN)];
			assign parse_mem[ 2][j] = mem[(DATA_LEN*N* 2) + (DATA_LEN*j) +: (DATA_LEN)];
			assign parse_mem[ 3][j] = mem[(DATA_LEN*N* 3) + (DATA_LEN*j) +: (DATA_LEN)];
			assign parse_mem[ 4][j] = mem[(DATA_LEN*N* 4) + (DATA_LEN*j) +: (DATA_LEN)];
			assign parse_mem[ 5][j] = mem[(DATA_LEN*N* 5) + (DATA_LEN*j) +: (DATA_LEN)];
			assign parse_mem[ 6][j] = mem[(DATA_LEN*N* 6) + (DATA_LEN*j) +: (DATA_LEN)];
			assign parse_mem[ 7][j] = mem[(DATA_LEN*N* 7) + (DATA_LEN*j) +: (DATA_LEN)];
			assign parse_mem[ 8][j] = mem[(DATA_LEN*N* 8) + (DATA_LEN*j) +: (DATA_LEN)];
			assign parse_mem[ 9][j] = mem[(DATA_LEN*N* 9) + (DATA_LEN*j) +: (DATA_LEN)];
			assign parse_mem[10][j] = mem[(DATA_LEN*N*10) + (DATA_LEN*j) +: (DATA_LEN)];
			assign parse_mem[11][j] = mem[(DATA_LEN*N*11) + (DATA_LEN*j) +: (DATA_LEN)];
			assign parse_mem[12][j] = mem[(DATA_LEN*N*12) + (DATA_LEN*j) +: (DATA_LEN)];
			assign parse_mem[13][j] = mem[(DATA_LEN*N*13) + (DATA_LEN*j) +: (DATA_LEN)];
			assign parse_mem[14][j] = mem[(DATA_LEN*N*14) + (DATA_LEN*j) +: (DATA_LEN)];
			assign parse_mem[15][j] = mem[(DATA_LEN*N*15) + (DATA_LEN*j) +: (DATA_LEN)];
		end
	endgenerate

	 initial begin
	 	i_clk = 1'b0; 
	 	i_rstn = 1'b0; 
		i_start = 1'b0;

	 	#10
	 	i_rstn = 1'b1;
	 	#10
		i_start = 1'b1;
		
		#10
		i_start = 1'b0;
		#500
		i_start = 1'b1;
		
		#10
		i_start = 1'b0;
		
		#1000
		$stop;
	 end	

	always #(CLK_CYCLE/2) i_clk = ~i_clk;

	M10K_read_write u0
	(
		.i_clk				(i_clk		   ),
		.i_rstn             (i_rstn        ),
		.i_start            (i_start       ),
		.i_read_data        (i_read_data ),
		.o_address          (o_address   ),
		.o_wr_en            (o_wr_en     ),
		.o_write_data       (o_write_data),
		.o_state			(o_state       ),
		.o_done             (o_done        )
	);
	
	M10K_16_256_test  MEM( 
		.i_clk				(i_clk		   ),
		.i_rstn             (i_rstn        ),
		.i_twice			(o_done		   ),
		.o_read_data    	(i_read_data),
		.i_write_data   	(o_write_data),
		.i_address      	(o_address),
		.i_wr_en        	(o_wr_en),
		.o_mem      		(mem)
	);
	
endmodule

module M10K_16_256_test#(
	parameter DATA_LEN = 32,
	parameter M = 8,
	parameter N = 8,
	parameter ADDRESS_SIZE = 4
)( 
	input 						  i_clk,
	input 						  i_rstn,
	input						  i_twice,
    output reg [(DATA_LEN*N)-1:0] o_read_data,
    input 	   [(DATA_LEN*N)-1:0] i_write_data,
    input 	   [ADDRESS_SIZE-1:0] i_address,
	input 						  i_wr_en,
	output [(DATA_LEN*N*M*2)-1:0] o_mem
);
	 // force M10K ram style
	 // 256 words of 32 bits
    reg [(DATA_LEN*N)-1:0] mem_row [0:2*M-1]  /* synthesis ramstyle = "no_rw_check, M10K" */;
	
	assign o_mem = {mem_row[15], mem_row[14], mem_row[13], mem_row[12], mem_row[11], mem_row[10], mem_row[9], mem_row[8], mem_row[7], mem_row[6], mem_row[5], mem_row[4], mem_row[3], mem_row[2], mem_row[1], mem_row[0]};
		 
    always @ (posedge i_clk, negedge i_rstn) begin
		if(!i_rstn) begin
		
				mem_row[ 0] <= {(32'd7 + ( 0)*32'd8), (32'd6 + ( 0)*32'd8), (32'd5 + ( 0)*32'd8), (32'd4 + ( 0)*32'd8), (32'd3 + ( 0)*32'd8), (32'd2 + ( 0)*32'd8), (32'd1 + ( 0)*32'd8), (32'd0 + ( 0)*32'd8)};
				mem_row[ 1] <= {(32'd7 + ( 1)*32'd8), (32'd6 + ( 1)*32'd8), (32'd5 + ( 1)*32'd8), (32'd4 + ( 1)*32'd8), (32'd3 + ( 1)*32'd8), (32'd2 + ( 1)*32'd8), (32'd1 + ( 1)*32'd8), (32'd0 + ( 1)*32'd8)};
				mem_row[ 2] <= {(32'd7 + ( 2)*32'd8), (32'd6 + ( 2)*32'd8), (32'd5 + ( 2)*32'd8), (32'd4 + ( 2)*32'd8), (32'd3 + ( 2)*32'd8), (32'd2 + ( 2)*32'd8), (32'd1 + ( 2)*32'd8), (32'd0 + ( 2)*32'd8)};
				mem_row[ 3] <= {(32'd7 + ( 3)*32'd8), (32'd6 + ( 3)*32'd8), (32'd5 + ( 3)*32'd8), (32'd4 + ( 3)*32'd8), (32'd3 + ( 3)*32'd8), (32'd2 + ( 3)*32'd8), (32'd1 + ( 3)*32'd8), (32'd0 + ( 3)*32'd8)};
				mem_row[ 4] <= {(32'd7 + ( 4)*32'd8), (32'd6 + ( 4)*32'd8), (32'd5 + ( 4)*32'd8), (32'd4 + ( 4)*32'd8), (32'd3 + ( 4)*32'd8), (32'd2 + ( 4)*32'd8), (32'd1 + ( 4)*32'd8), (32'd0 + ( 4)*32'd8)};
				mem_row[ 5] <= {(32'd7 + ( 5)*32'd8), (32'd6 + ( 5)*32'd8), (32'd5 + ( 5)*32'd8), (32'd4 + ( 5)*32'd8), (32'd3 + ( 5)*32'd8), (32'd2 + ( 5)*32'd8), (32'd1 + ( 5)*32'd8), (32'd0 + ( 5)*32'd8)};
				mem_row[ 6] <= {(32'd7 + ( 6)*32'd8), (32'd6 + ( 6)*32'd8), (32'd5 + ( 6)*32'd8), (32'd4 + ( 6)*32'd8), (32'd3 + ( 6)*32'd8), (32'd2 + ( 6)*32'd8), (32'd1 + ( 6)*32'd8), (32'd0 + ( 6)*32'd8)};
				mem_row[ 7] <= {(32'd7 + ( 7)*32'd8), (32'd6 + ( 7)*32'd8), (32'd5 + ( 7)*32'd8), (32'd4 + ( 7)*32'd8), (32'd3 + ( 7)*32'd8), (32'd2 + ( 7)*32'd8), (32'd1 + ( 7)*32'd8), (32'd0 + ( 7)*32'd8)};
				mem_row[ 8] <= {(DATA_LEN*N)*{1'b0}};
				mem_row[ 9] <= {(DATA_LEN*N)*{1'b0}};
				mem_row[10] <= {(DATA_LEN*N)*{1'b0}};
				mem_row[11] <= {(DATA_LEN*N)*{1'b0}};
				mem_row[12] <= {(DATA_LEN*N)*{1'b0}};
				mem_row[13] <= {(DATA_LEN*N)*{1'b0}};
				mem_row[14] <= {(DATA_LEN*N)*{1'b0}};
				mem_row[15] <= {(DATA_LEN*N)*{1'b0}};

		end
		else begin
			if(i_twice) begin
				mem_row[ 0] <= mem_row[ 0] << 2;
				mem_row[ 1] <= mem_row[ 1] << 2;
				mem_row[ 2] <= mem_row[ 2] << 2;
				mem_row[ 3] <= mem_row[ 3] << 2;
			    mem_row[ 4] <= mem_row[ 4] << 2;
			    mem_row[ 5] <= mem_row[ 5] << 2;
			    mem_row[ 6] <= mem_row[ 6] << 2;
			    mem_row[ 7] <= mem_row[ 7] << 2;
			    mem_row[ 8] <= mem_row[ 8] ;
			    mem_row[ 9] <= mem_row[ 9] ;
			    mem_row[10] <= mem_row[10] ;
			    mem_row[11] <= mem_row[11] ;
			    mem_row[12] <= mem_row[12] ;
			    mem_row[13] <= mem_row[13] ;
			    mem_row[14] <= mem_row[14] ;
			    mem_row[15] <= mem_row[15] ;
			end
			else if (i_wr_en) begin
				mem_row[i_address] <= i_write_data;
			end
			else begin
				o_read_data <= mem_row[i_address];
			end
		end
    end
endmodule