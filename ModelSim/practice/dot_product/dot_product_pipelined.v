module dot_product_pipelined (i_a, i_b, i_c, i_d, i_e, i_f, i_g, i_h, o_out, i_clk, i_rstn);

    input [3:0] i_a, i_b, i_c, i_d, i_e, i_f, i_g, i_h;
    input i_clk, i_rstn;
    output reg [9:0] o_out;
    reg [3:0] a, b, c, d, e, f, g, h;
    reg [7:0] mul_a, mul_b, mul_c, mul_d;
    reg [8:0] add_a, add_b;

    always @(posedge i_clk, negedge i_rstn) begin
        if(!i_rstn) begin
            a <= 4'd0; b <= 4'd0; c <= 4'd0; d <= 4'd0; 
            e <= 4'd0; f <= 4'd0; g <= 4'd0; h <= 4'd0;
        end
        else begin
            a <= i_a; b <= i_b; c <= i_c; d <= i_d; 
            e <= i_e; f <= i_f; g <= i_g; h <= i_h;
        end
    end

    always @(posedge i_clk, negedge i_rstn) begin
        if(!i_rstn) begin
            mul_a <= 8'd0;
            mul_b <= 8'd0;
            mul_c <= 8'd0;
            mul_d <= 8'd0;
        end
        else begin
            mul_a <= a*e;
            mul_b <= b*f;
            mul_c <= c*g;
            mul_d <= d*h;
        end
    end

    always @(posedge i_clk, negedge i_rstn) begin
        if(!i_rstn) begin
            add_a <= 9'd0; add_b <= 9'd0;
        end
        else begin
            add_a <= mul_a + mul_b;
            add_b <= mul_c + mul_d;
        end
    end

    always @(posedge i_clk, negedge i_rstn) begin
        if(!i_rstn) begin
            o_out <= 10'd0;
        end
        else begin
            o_out <= add_a + add_b;
        end
    end
    
endmodule