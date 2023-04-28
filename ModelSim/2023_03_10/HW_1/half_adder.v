module half_adder(i_x, i_y, o_s, o_c);

    input i_x, i_y;
    output o_s, o_c;
    xor (o_s, i_x, i_y);
    and (o_c, i_x, i_y);
    
endmodule