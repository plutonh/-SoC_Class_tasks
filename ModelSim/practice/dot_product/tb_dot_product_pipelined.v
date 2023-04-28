`timescale 1ns/1ns
module tb_dot_product_pipelined;
    reg        clk, rstn;
    reg  [3:0] a, b, c, d, e, f, g, h; 
    wire [9:0] out;
    reg  [3:0] input_mem[0:3][0:7]; // input memory
    reg  [9:0] output_mem[0:3];     // output memory

    // file operators and for Loop counter
    integer I_in; integer O_out;
    integer i; integer j;

    dot_product_pipelined u0(.i_a(a), .i_b(b), .i_c(c), .i_d(d), .i_e(e), .i_f(f), .i_g(g), .i_h(h), .o_out(out), .i_clk(clk), .i_rstn(rstn));

    initial begin
        I_in = $fopen("input_vec.dat", "r");   // open input file
        O_out = $fopen("output_vec.dat", "w"); // open output file
        $readmemh("input_vec.dat", input_mem); // read input file
    end

    initial begin
        clk = 0;
        rstn = 1;
        a = 0; b = 0; c = 0; d = 0; e = 0; f = 0; g = 0; h = 0;
        i = 0; j = 0;
        #10 rstn = 0;
        #10 rstn = 1;

        for(i=0; i < 4; ) begin
            @(posedge clk)
            begin
                a = input_mem[i][0];
                b = input_mem[i][1];
                c = input_mem[i][2]; 
                d = input_mem[i][3];
                e = input_mem[i][4];
                f = input_mem[i][5]; 
                g = input_mem[i][6];
                h = input_mem[1][7];
                $display("input %d %d %d %d %d %d %d %d", a, b, c, d, e, f, g, h);
                i=i+1;
            end
        end

        #80
        $writememh("output_vec.dat", output_mem);
        $fclose(I_in);
        $fclose(O_out);
        $stop;
    end
        
    always #5 clk = ~clk;
        
    always @(out) begin
        $display("output %d", out);
        output_mem[j] = out;
        j = j+1;
    end

endmodule