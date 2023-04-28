module mux2to1(i_a, i_b, i_sel, o_out);
    input i_a, i_b, i_sel;
    output o_out;
    wire out1, out2;
    wire nsel;
    
    not(nsel, i_sel);
    and(out1, i_a, nsel);
    and(out2, i_b, i_sel);
    or(o_out, out1, out2);
endmodule