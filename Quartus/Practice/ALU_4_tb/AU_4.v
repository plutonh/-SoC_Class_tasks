module AU_4 (i_a, i_b, i_Cin, sel_0, sel_1, AU_out, o_Cout);

    input  [3:0] i_a, i_b;
    input        i_Cin, sel_0, sel_1;
    output [3:0] AU_out;
    output       o_Cout;

    wire   [3:0] line_1;
    wire   [2:0] line_2;

    MUX_4x1 M1 (i_b[0], sel_0, sel_1, line_1[0]);
    MUX_4x1 M2 (i_b[1], sel_0, sel_1, line_1[1]);
    MUX_4x1 M3 (i_b[2], sel_0, sel_1, line_1[2]);
    MUX_4x1 M4 (i_b[3], sel_0, sel_1, line_1[3]);

    full_adder F1 (i_a[0], line_1[0], i_Cin,     AU_out[0], line_2[0]);
    full_adder F2 (i_a[1], line_1[1], line_2[0], AU_out[1], line_2[1]);
    full_adder F3 (i_a[2], line_1[2], line_2[1], AU_out[2], line_2[2]);
    full_adder F4 (i_a[3], line_1[3], line_2[2], AU_out[3], o_Cout   );

endmodule