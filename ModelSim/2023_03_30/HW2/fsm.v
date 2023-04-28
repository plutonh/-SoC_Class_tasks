module fsm (clk, rst, bypass, out);

    input clk, rst, bypass;
    output reg [1:0] out;
    parameter ST0 = 2'b00, ST1 = 2'b01, ST2 = 2'b10, ST3 = 2'b11;

    reg [1:0] state, next;

    always @(posedge clk or negedge rst) begin
    // state register block
        if(!rst) state <= ST0;
        else     state <= next;
    end

    always @(state or bypass) begin 
    // next state logic block
        next = 2'bx;
        case(state)
            ST0:            next = ST1;
            ST1: if(bypass) next = ST3;
                 else       next = ST2;
            ST2:            next = ST3;
            ST3:            next = ST0;
        endcase
    end

    always @(posedge clk or negedge rst) begin 
    // output logic block
        if(!rst) begin
            out <= 2'b00;
        end
        else begin
            case(next)
                ST0: out <= 2'b00;
                ST1: out <= 2'b01;
                ST2: out <= 2'b10;
                ST3: out <= 2'b11;
            endcase
        end
    end
endmodule