module PauseStateDisplay(x,segments);
	input x;
	output [6:0] segments;
	
	assign segments[0] = x;
	assign segments[1] = 1'b0;
	assign segments[2] = 1'b0;
	assign segments[3] = 1'b1;
	assign segments[4] = x;
	assign segments[5] = x;
	assign segments[6] = x;

endmodule