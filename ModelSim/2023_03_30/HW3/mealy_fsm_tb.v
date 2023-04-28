module mealy_fsm_tb();

    reg clk, reset_n, i_din_bit;
    wire o_dout_bit;

    // Initialization of Reset
    initial begin   
        reset_n = 1;
        # 15 reset_n = 0;
        # 25 reset_n = 1;
    end

    // Clock Genaration - 1
    always #10 clk = ~clk;
    initial begin
        clk = 0;
    end

    // // Clock Genaration - 2
    // initial begin
    //     clk = 0;
    //     forever begin
    //         #10 clk = ~clk;
    //     end
    // end

    // // Clock Genaration - 3
    // always begin
    //     #10 clk = 1;
    //     #10 clk = 0;
    // end

    // Input Stimulus
    initial begin
        i_din_bit = 0;
        #30 i_din_bit = 0;
        #20 i_din_bit = 1;
        #20 i_din_bit = 1;
        #30 i_din_bit = 0; // change 20 -> 30
        #20 i_din_bit = 0;
        #20 i_din_bit = 1;
        #20 i_din_bit = 1;
        #20 i_din_bit = 1;
        #20 i_din_bit = 0;
        #20 i_din_bit = 1;
        #20 i_din_bit = 1;
        #20 i_din_bit = 0;
        #20 i_din_bit = 1;
        #100 $stop;
    end

    mealy_fsm u_mealy_fsm(  .clk(clk), 
                            .rst(reset_n), 
                            .din_bit(i_din_bit), 
                            .dout_bit(o_dout_bit));

endmodule