module tb_half_adder;
    reg i_x, i_y;
    wire o_s, o_c;

    half_adder u0(.i_x(i_x),
                  .i_y(i_y),
                  .o_s(o_s),
                  .o_c(o_c));

    initial begin
      i_x = 1'b0;
      i_y = 1'b0;
      #10
      i_x = 1'b0;
      i_y = 1'b1;
      #10
      i_x = 1'b1;
      i_y = 1'b1;
      #10
      $stop;
    end

endmodule