`timescale 1ns/1ns
module tb_multiplier_4bit_2stage;

    reg clk, rstn;
    reg [3:0] a, b;
    wire [7:0] c;

    integer I_in, O_out;

    multiplier_4bit_2stage u0 (.i_a(a), .i_b(b), .o_c(c), .i_clk(clk), .i_rstn(rstn));

    initial begin
        clk = 0;
        rstn = 1;
        a = 0;
        b = 0;

        I_in = $fopen("input.txt", "r");
        O_out = $fopen("output.txt", "w");
        $display("I_in=%d", I_in);
        $display("O_out=%d", O_out);
        #10 rstn = 0;
        #10 rstn = 1;
        while (!$feof(I_in)) begin
            @(posedge clk) begin
                $fscanf(I_in, "%d", a);
                $fscanf(I_in, "%d", b);
                $display("input %d %d", a, b);
            end
        end
        #80
        $fclose(I_in);
        $fclose(O_out);
        $stop;
    end

    always #5 clk = ~clk;

    always @(c) begin
        $fwrite(O_out, "%d\n", c);
        $display("output %d", c);
    end

endmodule