module comp_2in(i_a, i_b, o_a_gt_b, o_a_eq_b, o_a_lt_b);
    input [3:0] i_a, i_b;
    output o_a_gt_b, o_a_eq_b, o_a_lt_b;

    assign o_a_gt_b = (i_a > i_b) ? 1 : 0;
    assign o_a_eq_b = (i_a == i_b) ? 1 : 0;
    assign o_a_lt_b = (i_a < i_b) ? 1 : 0;
endmodule