module multiplier_4bit_2stage(i_a, i_b, o_c, i_clk, i_rstn);

    input  [3:0] i_a,i_b;
    input        i_clk, i_rstn;

    output [7:0] o_c;

    wire   [3:0] line   [0:3];
    wire   [3:0] add_out[0:1];
    wire   [1:0] c_out;

    reg    [9:0] pipe_1;
    reg    [3:0] pipe_2;

    always @(posedge i_clk, negedge i_rstn) begin
        if(!i_rstn) begin
            pipe_1 <= 10'b0;
            pipe_2 <= 4'b0;
        end
        else begin
            pipe_1[0] <= line[0][0];
            pipe_1[1] <= add_out[0][0];
            pipe_1[5:2] <= line[2];
            pipe_1[8:6] <= add_out[0][3:1];
            pipe_1[9] <= c_out[0];
            pipe_2 <= line[3];
        end
    end

    and_operation A0 (i_a, i_b, line);

    fulladder_4bit F0 (line[1], {1'b0, line[0][3:1]}, c_out[0], add_out[0]);
    fulladder_4bit F1 (pipe_1[5:2], pipe_1[9:6], c_out[1], add_out[1]);
    fulladder_4bit F2 (pipe_2, {c_out[1], add_out[1][3:1]}, o_c[7], o_c[6:3]);

    assign o_c[1:0] = pipe_1[1:0];
    assign o_c[2]   = add_out[1][0];

endmodule

// module multiplier_4bit_2stage(i_a, i_b, o_c, i_clk, i_rstn);

//     input [3:0] i_a,i_b;
//     input i_clk, i_rstn;

//     output [7:0] o_c;

//     wire [3:0] line_1, line_2, line_3, line_4;
//     wire [3:0] add_out_1, add_out_2;
//     wire [1:0] c_out;

//     reg [9:0] pipe_1;
//     reg [3:0] pipe_2;

//     always @(posedge i_clk, negedge i_rstn) begin
//         if(!i_rstn) begin
//             pipe_1 <= 10'b0;
//             pipe_2 <= 4'b0;
//         end
//         else begin
//             pipe_1[0] <= line_1[0];
//             pipe_1[1] <= add_out_1[0];
//             pipe_1[5:2] <= line_3;
//             pipe_1[8:6] <= add_out_1[3:1];
//             pipe_1[9] <= c_out[0];

//             pipe_2 <= line_4;
//         end
//     end

//     and_operation A1 (i_a, i_b[0], line_1);
//     and_operation A2 (i_a, i_b[1], line_2);
//     and_operation A3 (i_a, i_b[2], line_3);
//     and_operation A4 (i_a, i_b[3], line_4);

//     fulladder_4bit F0 (line_2, {1'b0, line_1[3:1]}, c_out[0], add_out_1);
//     fulladder_4bit F1 (pipe_1[5:2], pipe_1[9:6], c_out[1], add_out_2);
//     fulladder_4bit F2 (pipe_2, {c_out[1], add_out_2[3:1]}, o_c[7], o_c[6:3]);

//     assign o_c[0] = pipe_1[0];
//     assign o_c[1] = pipe_1[1];
//     assign o_c[2] = add_out_2[0];

// endmodule