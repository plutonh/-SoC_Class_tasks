module full_adder(i_x, i_y, i_cin, o_s, o_cout);

    input i_x, i_y, i_cin;
    output o_s, o_cout;
    wire s, c1, c2;
    half_adder h1(.i_x(i_x), .i_y(i_y), .o_s(s), .o_c(c1));
    half_adder h2(.i_x(i_cin), .i_y(s), .o_s(o_s), .o_c(c2));

    assign o_cout = c1 | c2;
    
endmodule