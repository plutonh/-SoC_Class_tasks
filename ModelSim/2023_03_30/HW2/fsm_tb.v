module fsm_tb ();
    reg clk, reset_n, i_bypass;
    wire [1:0] o_out;
    always #10 clk = ~clk; // 10ps

    initial begin
        clk = 0;
        reset_n = 1;
        i_bypass = 0;
        #15 reset_n = 0;
        #25 reset_n = 1;
        #100 i_bypass = 1;
        #100 i_bypass = 0;
        $stop;
    end

    fsm u_fsm( .clk(clk), 
               .rst(reset_n),
               .bypass(i_bypass),
               .out(o_out));
endmodule