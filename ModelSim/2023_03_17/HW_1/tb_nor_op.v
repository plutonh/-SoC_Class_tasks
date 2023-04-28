module tb_nor_op();

reg [3:0] a,b;
wire [3:0] y;

initial begin
    a = 4'b0000;
    b = 4'b0000;
    #10 a= 4'b1100;
    #10 b= 4'b1010;
end

nor_4bit dut(.a(a), .b(b), .out(y));

endmodule