`timescale 1ns/1ps
module tb_case_test;

    reg [3:0] in;
    wire [1:0] out;

    case_test u0(in, out);

    initial begin
        in = 4'b0000; #20
        in = 4'b0001; #20
        in = 4'b0010; #20
        in = 4'b0011; #20
        in = 4'b0100; #20
        in = 4'b0101; #20
        in = 4'b0110; #20
        in = 4'b0111; #20
        in = 4'b1000; #20
        in = 4'b1001; #20
        in = 4'b1010; #20
        in = 4'b1011; #20
        in = 4'b1100; #20
        in = 4'b1101; #20
        in = 4'b1110; #20
        in = 4'b1111; #20
        $stop;
    end

endmodule