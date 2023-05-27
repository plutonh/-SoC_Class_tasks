module and_operation (a, b, o);

    input [3:0] a, b;
    output [3:0] o [0:3];

    genvar i, j;
    generate
        for(i=0; i<4; i=i+1) begin
            for(j=0; j<4; j=j+1) begin
                assign o[i][j] = a[j] & b[i];
            end
        end
    endgenerate

endmodule

// module and_operation (a, b, o);

//     input [3:0] a, b;
//     output [3:0] o;

//     assign o[0] = a[0] & b;
//     assign o[1] = a[1] & b;
//     assign o[2] = a[2] & b;
//     assign o[3] = a[3] & b;

// endmodule