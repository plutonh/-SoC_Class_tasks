module ALU_4 (i_a, i_b, i_sel, i_Cin, o_Cout, o_G);

    input  [3:0] i_a, i_b;
    input  [2:0] i_sel;
    input        i_Cin;
    output [3:0] o_G;
    output       o_Cout;

    wire   [3:0] AU_out, LU_out;
    wire   [1:0] sel;
    wire         out;

    AU_4 A1 (i_a, i_b, i_Cin, sel[0], sel[1], AU_out, out);
    LU_4 L1 (i_a, i_b, sel[0], sel[1], LU_out);

    assign sel[0] = i_sel[0];
    assign sel[1] = i_sel[1];
    assign o_G = i_sel[2] ? LU_out : AU_out;
    assign o_Cout = i_sel[2] ? 1'b0 : out;

endmodule