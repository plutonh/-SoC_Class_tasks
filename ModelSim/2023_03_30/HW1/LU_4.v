module LU_4 (i_a, i_b, sel_0, sel_1, LU_out);

    input  [3:0] i_a, i_b;
    input        sel_0, sel_1;
    output [3:0] LU_out;

    wire   [1:0] sel;

    assign sel[0] = sel_0;
    assign sel[1] = sel_1;
    assign LU_out = sel[1] ? (sel[0] ? ~i_a : i_a ^ i_b) : (sel[0] ? i_a | i_b : i_a & i_b);

endmodule