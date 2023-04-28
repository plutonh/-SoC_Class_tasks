module shift_reg  ( input i_clk,
                    input i_rstn,
                    input i_in,
                    output reg [7:0] o_out);

    // genvar i;

    // always @(posedge i_clk or negedge i_rstn) begin
    //     if(!i_rstn) begin
    //         o_out <= 8'b0;
    //     end
    //     else begin
    //         o_out[0] <= i_in;
    //     end
    // end

    // generate
    //     for(i=0; i<7; i=i+1) begin
    //         always @(posedge i_clk or negedge i_rstn) begin
    //             if(!i_rstn) begin
    //                 o_out <= 8'b0;
    //             end
    //             else begin
    //                 o_out[i+1] <= o_out[i];
    //             end
    //         end
    //     end
    // endgenerate

    always @(posedge i_clk, negedge i_rstn) begin
        if(!i_rstn) begin
            o_out <= 8'b0;
        end
        else begin
            if(i_in == 1'b1) begin
                o_out[0] <= i_in;
            end 
            else begin
                o_out <= {o_out[6:0], 1'b0};
            end
        end
    end

endmodule