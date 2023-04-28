module Shift  ( input i_clk,
                    input i_rstn,
                    input i_in,
                    output reg [7:0] o_out);
						  
//	 wire [7:0] buff;
//
//    genvar i, j;
//
//    always @(posedge i_clk or negedge i_rstn) begin
//        if(!i_rstn) begin
//            o_out <= 8'b0;
//        end
//        else begin
//            o_out <= buff;
//        end
//    end
//
//    generate
//	     j=0;
//        for(i=0; i<7; i=i+1) begin: loop
//            if(i==0) begin
//				   assign buff[0] = i_in;
//				end
//				else begin
//				   if(i==j) begin
//						assign buff[i] = 1'b1;
//					end
//					else begin
//						assign buff[i] = 1'b0;
//					end
//				end
//				j=j+1;
//        end
//    endgenerate

    genvar i;

    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            o_out <= 8'b0;
        end
        else begin
            o_out[0] <= i_in;
        end
    end

    generate
        for(i=0; i<7; i=i+1) begin: loop
            always @(posedge i_clk or negedge i_rstn) begin
                if(!i_rstn) begin
                    o_out <= 8'b0;
                end
                else begin
                    o_out[i+1] <= o_out[i];
                end
            end
        end
    endgenerate
	 
endmodule