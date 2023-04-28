module tb_practice();

    reg [1:0] x, y;
    reg a, b;

    initial begin
        assign a = 1'b1;
        assign b = 1'b1;
        #3
        assign a = 1'b0;
        assign b = 1'b1;
    end

    initial begin
        #5 x = a + b;
    end

    initial begin
        y = #5 a + b;
    end

endmodule