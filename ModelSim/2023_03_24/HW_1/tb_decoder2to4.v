module tb_decoder2to4();
    reg [1:0] in;
    wire [3:0] out;
    decoder2to4 u0 (.i_in(in), .o_out(out));
    initial begin
        in = 2'b00;
        #50
        in = 2'b01;
        #50
        in = 2'b10;
        #50
        in = 2'b11;
        #50
        $stop;
    end
endmodule
