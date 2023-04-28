module tb_comp_2in();
    reg [3:0] a, b;
    wire a_gt_b, a_eq_b, a_lt_b;

    comp_2in u0(.i_a(a), .i_b(b), 
                .o_a_gt_b(a_gt_b),
                .o_a_eq_b(a_eq_b),
                .o_a_lt_b(a_lt_b));
                
    initial begin
        a = 4'd3;
        b = 4'd2;
        #50
        a = 4'd2;
        b = 4'd2;
        #50
        a = 4'd1;
        b = 4'd2;
        #50
        $stop;
    end
endmodule