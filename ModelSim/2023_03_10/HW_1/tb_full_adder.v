`timescale 1ns/1ns
module tb_full_adder;
    reg i_x, i_y, i_cin;
    wire o_s, o_cout;

    full_adder f1(i_x, i_y, i_cin, o_s, o_cout);

    initial begin
        i_x = 1'b0; i_y = 1'b0; i_cin = 1'b0; #50
        i_x = 1'b0; i_y = 1'b0; i_cin = 1'b1; #50
        i_x = 1'b0; i_y = 1'b1; i_cin = 1'b0; #50
        i_x = 1'b0; i_y = 1'b1; i_cin = 1'b1; #50
        i_x = 1'b1; i_y = 1'b0; i_cin = 1'b0; #50
        i_x = 1'b1; i_y = 1'b0; i_cin = 1'b1; #50
        i_x = 1'b1; i_y = 1'b1; i_cin = 1'b0; #50
        i_x = 1'b1; i_y = 1'b1; i_cin = 1'b1;
    end

endmodule