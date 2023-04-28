`timescale 1ns/1ns
module tb_mux2to1_4bit;

reg [3:0] i_a, i_b;
reg i_sel;
wire [3:0] o_out;

mux2to1_4bit m1(i_a, i_b, i_sel, o_out);

initial begin
    i_a = 4'b0000; i_b = 4'b0000; i_sel = 1'b0;
    #100 
    i_a = 4'b1111; i_b = 4'b0000; i_sel = 1'b1;
    #100
    i_a = 4'b0000; i_b = 4'b1111; i_sel = 1'b1;
end

endmodule