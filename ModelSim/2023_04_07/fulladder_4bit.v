module fulladder_4bit (A, B, Cout, S);
    input [3:0] A, B;
    output Cout;
    output [3:0] S;

    wire [2:0] line;

    full_adder F1(A[0], B[0], 1'b0, S[0], line[0]);
    full_adder F2(A[1], B[1], line[0], S[1], line[1]);
    full_adder F3(A[2], B[2], line[1], S[2], line[2]);
    full_adder F4(A[3], B[3], line[2], S[3], Cout);
    
endmodule