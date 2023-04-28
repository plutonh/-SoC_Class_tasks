module case_test (in,  out);

    input [3:0] in;
    output reg [1:0] out;

    always @(in) begin
        casez(in)
            4'b000?: out = 2'b00;
            4'b001x: out = 2'b01;
            4'b01zx: out = 2'b10;
            default: out = 2'b11;
        endcase
    end

endmodule