module if_test (a, b, t, sel, z);

	input a, b, t, sel;
	output z;
	
	assign z = sel ? a+t : b+t;
	
//	always @(*) begin
//		if(sel) begin
//			z = a+t;
//		end
//		else begin
//			z = b+t;
//		end
//	end

//    input a, b, c, d;
//    input [3:0] sel;
//    output reg out;

//    always @(a or b or c or d or e or sel) begin
//        z = e;
//        if(sel[0]) z = a;
//        if(sel[1]) z = b;
//        if(sel[2]) z = c;
//        if(sel[3]) z = d;
//    end
	 
//	 always @(sel or a or b or c or d) begin
//		case(sel)
//			2'b00: out = a;
//			2'b01: out = b;
//			2'b10: out = c;
//			default: out = d;
//		endcase
//	 end
	 
//	 assign out = (sel==2'b00) ? a : (sel==2'b01) ? b : (sel==2'b10) ? c : d;
	 
//	 always @(sel or a or b or c or d) begin
//		if(sel == 2'b00) out = a;
//		else if(sel == 2'b01) out = b;
//		else if(sel == 2'b10) out = c;
//		else out = d;
//	 end
	
//    always @(a or b or c or d or e or sel) begin
//        z = e;
//        if(sel[0]) z = a;
//        else if(sel[1]) z = b;
//        else if(sel[2]) z = c;
//        else if(sel[3]) z = d;
//    end
//


//	input [0:159] image;
//	output [7:0] image_wire;
//	reg [7:0] image_copy [0:3][0:4];
//	
//	genvar i, j;
//	generate
//		for(i=0; i<4; i=i+1) begin: loop1
//			for(j=0; j<5;j =j+1) begin: loop2
//				always @(image[i*8*5+j*8 +: 8]) begin
//					image_copy[i][j] <= image[i*8*5+j*8 +: 8];
//				end
//			end
//		end
//	endgenerate
//	
//	assign image_wire = image_copy[0][0] * image_copy[0][1];

endmodule