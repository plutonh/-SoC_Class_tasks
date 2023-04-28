module decoder2to4(i_in, o_out);
    input [1:0] i_in;
    output reg [3:0] o_out;

    always @(i_in) begin
        case(i_in)
            2'b00 : o_out = 4'b0001;
            2'b01 : o_out = 4'b0010;
            2'b10 : o_out = 4'b0100;
            default : o_out = 4'b1000;
        endcase
    end
endmodule