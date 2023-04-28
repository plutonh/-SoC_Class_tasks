module mux2to1_4bit(i_a, i_b, i_sel, o_out);
    input [3:0] i_a, i_b;
    input i_sel;
    output [3:0] o_out;
    
    mux2to1 m1(i_a[0], i_b[0], i_sel, o_out[0]);
    mux2to1 m2(i_a[1], i_b[1], i_sel, o_out[1]);
    mux2to1 m3(i_a[2], i_b[2], i_sel, o_out[2]);
    mux2to1 m4(i_a[3], i_b[3], i_sel, o_out[3]);
endmodule