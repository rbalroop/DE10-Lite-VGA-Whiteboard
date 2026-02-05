module DrawStateDisplay(x,segments);
	input x;
	output [6:0] segments;
	
	assign segments[0] = 1'b0;
	assign segments[1] = x;
	assign segments[2] = x;
	assign segments[3] = 1'b0;
	assign segments[4] = 1'b0;
	assign segments[5] = 1'b0;
	assign segments[6] = ~x;

endmodule