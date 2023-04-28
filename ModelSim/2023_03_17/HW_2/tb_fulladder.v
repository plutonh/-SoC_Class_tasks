module tb_fulladder_4bit();
reg [3:0] A,B;
wire Cout;
wire [3:0] S;
integer k;

fulladder_4bit U0(A,B,Cout,S);

initial begin
    forever
    for(k=0;k<16;k=k+1) begin
        B=k;
        A=k/2;
        #50;
    end
end
endmodule