// share
//module compare_share(v, w, x, z, k);
//
//	input [2:0] k, v, w;
//	input x;
//	output reg [3:0] z;
//	reg [3:0] y;
//	
//	always @(x or k or v or w) begin
//		if(x)
//			y = k+w;
//		else
//			y = k+v;
//	end
//	
//	always @(y or x or v or w) begin
//		if(x)
//			z = y+w;
//		else
//			z = y+v;
//	end
//	
//endmodule

// noshare
//module compare_share(v, w, x, z, k);
//
//	input [2:0] k, v, w;
//	input x;
//	output [3:0] z;
//	wire [3:0] y;
//	
//	assign y = x ? k+w : k+v;
//	assign z = x ? y+w : y+v;
//	
//endmodule

module compare_share(a, b, t, sel, z);
	input a, b, t, sel;
	output reg z;
	
//	assign z = sel ? a+t: b+t;
	
	always @(a or b or t or sel) begin
		if(sel)
			z = a+t;
		else
			z = b+t;
	end

endmodule