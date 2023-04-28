module full_adder(i_x, i_y, i_cin, o_s, o_cout);
    input i_x, i_y, i_cin;
    output o_s, o_cout;
    wire s, c1, c2;

    assign s = i_x ^ i_y;
    assign c1 = i_x & i_y;
    assign o_s = i_cin ^ s;
    assign c2 = s & i_cin;
    assign o_cout = c1 | c2;
endmodule