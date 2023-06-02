module M10K_16_256#(
	parameter DATA_LEN = 32,
	parameter M = 8,
	parameter N = 8,
	parameter ADDRESS_SIZE = 4
)( 
	output reg [(DATA_LEN*N)-1:0]  o_read_data,
	input 	   [(DATA_LEN*N)-1:0] i_write_data,
	input 						       i_clk,
   input 	   [ADDRESS_SIZE-1:0] i_read_address, 
	input 	   [ADDRESS_SIZE-1:0] i_write_address,
	input 						       i_wr_en
);
	 // force M10K ram style
	 // 256 words of 32 bits
    reg [(DATA_LEN*N)-1:0] mem_row [0:2*M-1]  /* synthesis ramstyle = M10K */;
	 
	 initial begin
				mem_row[ 0] = {(32'd7 + ( 0)*32'd8), (32'd6 + ( 0)*32'd8), (32'd5 + ( 0)*32'd8), (32'd4 + ( 0)*32'd8), (32'd3 + ( 0)*32'd8), (32'd2 + ( 0)*32'd8), (32'd1 + ( 0)*32'd8), (32'd0 + ( 0)*32'd8)};
				mem_row[ 1] = {(32'd7 + ( 1)*32'd8), (32'd6 + ( 1)*32'd8), (32'd5 + ( 1)*32'd8), (32'd4 + ( 1)*32'd8), (32'd3 + ( 1)*32'd8), (32'd2 + ( 1)*32'd8), (32'd1 + ( 1)*32'd8), (32'd0 + ( 1)*32'd8)};
				mem_row[ 2] = {(32'd7 + ( 2)*32'd8), (32'd6 + ( 2)*32'd8), (32'd5 + ( 2)*32'd8), (32'd4 + ( 2)*32'd8), (32'd3 + ( 2)*32'd8), (32'd2 + ( 2)*32'd8), (32'd1 + ( 2)*32'd8), (32'd0 + ( 2)*32'd8)};
				mem_row[ 3] = {(32'd7 + ( 3)*32'd8), (32'd6 + ( 3)*32'd8), (32'd5 + ( 3)*32'd8), (32'd4 + ( 3)*32'd8), (32'd3 + ( 3)*32'd8), (32'd2 + ( 3)*32'd8), (32'd1 + ( 3)*32'd8), (32'd0 + ( 3)*32'd8)};
				mem_row[ 4] = {(32'd7 + ( 4)*32'd8), (32'd6 + ( 4)*32'd8), (32'd5 + ( 4)*32'd8), (32'd4 + ( 4)*32'd8), (32'd3 + ( 4)*32'd8), (32'd2 + ( 4)*32'd8), (32'd1 + ( 4)*32'd8), (32'd0 + ( 4)*32'd8)};
				mem_row[ 5] = {(32'd7 + ( 5)*32'd8), (32'd6 + ( 5)*32'd8), (32'd5 + ( 5)*32'd8), (32'd4 + ( 5)*32'd8), (32'd3 + ( 5)*32'd8), (32'd2 + ( 5)*32'd8), (32'd1 + ( 5)*32'd8), (32'd0 + ( 5)*32'd8)};
				mem_row[ 6] = {(32'd7 + ( 6)*32'd8), (32'd6 + ( 6)*32'd8), (32'd5 + ( 6)*32'd8), (32'd4 + ( 6)*32'd8), (32'd3 + ( 6)*32'd8), (32'd2 + ( 6)*32'd8), (32'd1 + ( 6)*32'd8), (32'd0 + ( 6)*32'd8)};
				mem_row[ 7] = {(32'd7 + ( 7)*32'd8), (32'd6 + ( 7)*32'd8), (32'd5 + ( 7)*32'd8), (32'd4 + ( 7)*32'd8), (32'd3 + ( 7)*32'd8), (32'd2 + ( 7)*32'd8), (32'd1 + ( 7)*32'd8), (32'd0 + ( 7)*32'd8)};
				mem_row[ 8] = {(DATA_LEN*N)*{1'b0}};
				mem_row[ 9] = {(DATA_LEN*N)*{1'b0}};
				mem_row[10] = {(DATA_LEN*N)*{1'b0}};
				mem_row[11] = {(DATA_LEN*N)*{1'b0}};
				mem_row[12] = {(DATA_LEN*N)*{1'b0}};
				mem_row[13] = {(DATA_LEN*N)*{1'b0}};
				mem_row[14] = {(DATA_LEN*N)*{1'b0}};
				mem_row[15] = {(DATA_LEN*N)*{1'b0}};
	 end
		 
    always @ (posedge i_clk) begin
		
		if (i_wr_en) begin
			mem_row[i_write_address] <= i_write_data;
		end
		
		o_read_data <= mem_row[i_read_address];
		
    end
   
endmodule