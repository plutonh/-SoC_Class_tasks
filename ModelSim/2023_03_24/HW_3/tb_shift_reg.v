module tb_shift_reg();
    reg clk, rstn, in;
    wire [7:0] out;

    shift_reg u0   (.i_clk(clk),
                    .i_rstn(rstn),
                    .i_in(in),
                    .o_out(out));
    
    always #25 clk = ~clk;

    initial begin 
        clk = 1;
        rstn = 0;
        in = 1'b0;
        #25
        rstn = 1;
        #25
        in = 1'b1;
        #50
        in = 1'b0;
        #50
        #400
        $stop;
    end
endmodule