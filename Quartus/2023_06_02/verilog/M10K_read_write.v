`timescale 1ns / 1ns
module M10K_read_write#(
	parameter DATA_LEN = 32,
	parameter M = 8,
	parameter N = 8,
	parameter K = 8,
	parameter ROW_SIZE = (DATA_LEN*K),
	parameter MAT_SIZE = (DATA_LEN*K*M),
	
	parameter ADDRESS_SIZE = 4,
	parameter READ    = 3'b000,
	parameter WRITE   = 3'b001,
	parameter DONE    = 3'b010,
	parameter IDLE	  = 3'b111,

	parameter READ_READ0 = 4'd0,
	parameter READ_READ1 = 4'd1,
	parameter READ_READ2 = 4'd2,
	parameter READ_READ3 = 4'd3,
	parameter READ_READ4 = 4'd4,
	parameter READ_READ5 = 4'd5,
	parameter READ_READ6 = 4'd6,
	parameter READ_READ7 = 4'd7,
	parameter READ_WAIT  = 4'd8,
	parameter READ_DONE  = 4'd9,
	parameter READ_IDLE  = 4'd15,

	parameter WRITE_WRITE0 = 4'd0,
	parameter WRITE_WRITE1 = 4'd1,
	parameter WRITE_WRITE2 = 4'd2,
	parameter WRITE_WRITE3 = 4'd3,
	parameter WRITE_WRITE4 = 4'd4,
	parameter WRITE_WRITE5 = 4'd5,
	parameter WRITE_WRITE6 = 4'd6,
	parameter WRITE_WRITE7 = 4'd7,
    parameter WRITE_DONE   = 4'd8,
	parameter WRITE_IDLE   = 4'd15,
	
	parameter READ_ADDR_OFFSET = 0,
	parameter WRITE_ADDR_OFFSET = 8
)(
	input 					 		  i_clk,
	input 					 		  i_rstn,
	input							  i_start,
	///////////// read  //////////
	input   [DATA_LEN*N-1:0]	  	  i_read_data,
	output	 [ADDRESS_SIZE-1:0]	  	  o_address,
	output  						  o_wr_en,

	///////////// write //////////	
	output  [DATA_LEN*N-1:0]	  	  o_write_data,
	
	output  [2:0]					  o_state,
	output	[3:0]					  o_read_state,
	output	[3:0]					  o_write_state,
	output							  o_done

);
	reg  [2:0] state;     
	reg  [2:0] next_state; 
	
	wire  [3:0] read_state;
	wire  [3:0] write_state;
	
	assign o_read_state 	= read_state;
	assign o_write_state	= write_state;
	
	wire read_start  ;
	wire read_done   ;
	wire write_start ;
	wire write_done  ;
	wire read_reset  ;
	
	wire [(DATA_LEN*N*M)-1:0]  read_store;
	wire [(DATA_LEN)-1:0]      parse_read_store[0:K-1][0:N-1];
	
    wire [ADDRESS_SIZE-1:0] write_address;
    wire [ADDRESS_SIZE-1:0] read_address;
	

	wire write_en;
	
	always @(posedge i_clk, negedge i_rstn) begin
		if(!i_rstn) begin
			state <= IDLE;
		end
		else begin
			state <= next_state;
		end	
	end
	
	assign o_state = state;
	
	always @(*) begin
		case(state) 
			IDLE:           begin
					         	if( i_start  )  next_state = READ;
					         	else 	     	next_state = IDLE;
					        end
			READ:        begin
					            if(read_done )  next_state = WRITE;
					         	else 	     	next_state = READ;		
					        end			
			WRITE:        begin
					         	if(write_done)  next_state = DONE;
					         	else 	     	next_state = WRITE;
					        end
			DONE:           begin
					         					next_state = IDLE;
					        end 
		endcase      
	end
	
	assign read_start    = (state == IDLE   )   && (next_state     == READ);
	assign read_done     = (state == READ   )   && (read_state     == READ_DONE);
	assign write_start   = (state == READ   )   && (next_state     == WRITE);
	assign write_done    = (state == WRITE  )   && (write_state    == WRITE_DONE);
	assign read_reset    = (state == DONE   );
	assign o_done        = (state == DONE   );
	assign o_address     = (write_en == 1'b1) ? (write_address) : read_address;
	assign o_wr_en       = (write_en == 1'b1) ? write_en : 1'b0;
	
M10K_read_buffer #(.DATA_LEN(DATA_LEN), .ADDRESS_SIZE(ADDRESS_SIZE), .OFFSET(READ_ADDR_OFFSET)) r0
(
	.i_clk		   (i_clk ),
	.i_rstn  	   (i_rstn),
	.i_read_reset  (read_reset),
	.i_read_start  (read_start),
	.i_read_data   (i_read_data),
	
	.o_store_mat   (read_store),
	.o_read_addr   (read_address),
	.o_state       (read_state)
);

M10K_write #(.DATA_LEN(DATA_LEN), .ADDRESS_SIZE(ADDRESS_SIZE), .OFFSET(WRITE_ADDR_OFFSET)) w0
(
	.i_clk 		 	(i_clk ),
	.i_rstn 		(i_rstn),
	.i_write_start  (write_start),
	.i_in_mat 		(read_store),
	 
	.o_write_addr 	(write_address),
	.o_write_data 	(o_write_data),
	.o_write_start  (write_en),
	.o_state 		(write_state)
);


genvar i;
	generate
	for(i=0; i<K; i=i+1) begin: PARSE_READ_STORE
		assign parse_read_store[0][i] = read_store[((DATA_LEN*K)*0) + DATA_LEN*(i) +: DATA_LEN];
		assign parse_read_store[1][i] = read_store[((DATA_LEN*K)*1) + DATA_LEN*(i) +: DATA_LEN];
		assign parse_read_store[2][i] = read_store[((DATA_LEN*K)*2) + DATA_LEN*(i) +: DATA_LEN];
		assign parse_read_store[3][i] = read_store[((DATA_LEN*K)*3) + DATA_LEN*(i) +: DATA_LEN];
		assign parse_read_store[4][i] = read_store[((DATA_LEN*K)*4) + DATA_LEN*(i) +: DATA_LEN];
		assign parse_read_store[5][i] = read_store[((DATA_LEN*K)*5) + DATA_LEN*(i) +: DATA_LEN];
		assign parse_read_store[6][i] = read_store[((DATA_LEN*K)*6) + DATA_LEN*(i) +: DATA_LEN];
		assign parse_read_store[7][i] = read_store[((DATA_LEN*K)*7) + DATA_LEN*(i) +: DATA_LEN];
	end
	endgenerate

endmodule
