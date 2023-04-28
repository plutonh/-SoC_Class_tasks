module ALU_4_tb;
    reg [2:0] S; //Select Signals
    reg Cin; //Carry In
    reg [3:0] A; //ALU input A
    reg [3:0] B; //ALU input B
    wire [3:0] G; //G
    wire Cout; //Carry Out

    ALU_4 u_ALU_4(  .i_a(A), 
                    .i_b(B), 
                    .i_sel(S), 
                    .i_Cin(Cin), 
                    .o_Cout(Cout), 
                    .o_G(G));

    initial begin
        A = 4'b1111;
        B = 4'b0001;
        S = 3'b000; Cin = 0;
        #100
        S = 3'b000; Cin = 1;
        #100
        S = 3'b001; Cin = 0;
        #100
        S = 3'b001; Cin = 1;
        #100
        S = 3'b010; Cin = 0;
        #100
        S = 3'b010; Cin = 1;
        #100
        S = 3'b011; Cin = 0;
        #100
        S = 3'b011; Cin = 1;
        #100
        S = 3'b100; Cin = 0;
        #100
        S = 3'b100; Cin = 1;
        #100
        S = 3'b101; Cin = 0;
        #100
        S = 3'b101; Cin = 1;
        #100
        S = 3'b110; Cin = 0;
        #100
        S = 3'b110; Cin = 1;
        #100
        S = 3'b111; Cin = 0;
        #100
        S = 3'b111; Cin = 1;
        #100
        $stop;
    end
endmodule