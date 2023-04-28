module mealy_fsm (clk, rst, din_bit,, dout_bit);

    input  clk, rst, din_bit;
    output dout_bit;

    reg [2:0] state, next;

    parameter start = 3'b000, st1 = 3'b001, st2 = 3'b010, st3 = 3'b011, st4 = 3'b100;

    always @(posedge clk or negedge rst) begin
    // state register block
        if(!rst) state <= start;
        else     state <= next;
    end

    always @(state or din_bit) begin
    // next state logic block
        case(state)
            start: if      (din_bit == 0) next <= st1;
                   else                   next <= start;
            st1:   if      (din_bit == 0) next <= st1;
                   else if (din_bit == 1) next <= st2;
                   else                   next <= start;
            st2:   if      (din_bit == 0) next <= st1;
                   else if (din_bit == 1) next <= st3;
                   else                   next <= start;
            st3:   if      (din_bit == 0) next <= st4;
                   else                   next <= start;
            st4:   if      (din_bit == 0) next <= st1;
                   else if (din_bit == 1) next <= st2;
                   else                   next <= start;
            default:                      next <= start;
        endcase             
    end

    //output logic block
    assign dout_bit = (state == st3 && din_bit == 0) ? 1 : 0;

endmodule