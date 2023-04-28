module MUX_4x1(b, s0, s1, out);

	input  b;
    input  s0, s1;
	output out;

	assign out = s1 ? (s0 ? 1'b1 : ~b) : (s0 ? b : 1'b0);

endmodule