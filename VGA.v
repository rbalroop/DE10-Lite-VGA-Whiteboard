module VGA(
 
	input wire clk, 
	input wire is_pixel_black_or_white,
	input wire [6:0] horizontal_coordinate_for_cursor,
	input wire [5:0] vertical_coordinate_for_cursor,
	output wire horizontal_sync, 
	output wire vertical_sync, 
	output wire [6:0] x_coordinate_for_cell,
	output wire [5:0] y_coordinate_for_cell,
	output [3:0] red, 
	output [3:0] green, 
	output [3:0] blue 

); 
//Counters for keeping track of the horizontal and vertical coordinates of the pixels the VGA module is displaying per clock cycle
//To make it easier for the program to load into the RAM of the board, pixels are mapped into cells that are 8 times larger than any given pixel. This way, the program code can compile much faster at the cost of appearing a bit more blocky. The normalized counters allow us to have a center "(0,0)" position in the visible portion of the blocky screen.
reg [9:0] horizontal_counter = 10'd0; 
reg [9:0] vertical_counter = 10'd0; 

reg [3:0] tempRed = 4'd0; 
reg [3:0] tempGreen = 4'd0; 
reg [3:0] tempBlue = 4'd0; 


wire [9:0] normalized_horizontal_counter = horizontal_counter - 10'd144;
wire [9:0] normalized_vertical_counter = vertical_counter - 10'd35;

//Coordinates shifted by three to reflect the 8 value mentioned above
assign x_coordinate_for_cell = normalized_horizontal_counter >> 3;
assign y_coordinate_for_cell = normalized_vertical_counter >> 3;

//Clock cycle sequential logic responsible for incrementing the horizontal and vertical pixel counters
//Additional logic is included for when we reach the end of a horizontal line of pixels. This is when we move to the next vertical row.
always @(posedge clk) begin 
	if (horizontal_counter < 10'd799) 
		horizontal_counter <= horizontal_counter + 10'd1; 
	else horizontal_counter <= 10'd0; 
end 

always @(posedge clk) begin 
	if (horizontal_counter == 10'd799) begin 
		if (vertical_counter < 10'd524) 
			vertical_counter <= vertical_counter + 10'd1; 
		else 
			vertical_counter <= 10'd0; 
	end 
end 

//Outputs of the module that are used by the VGA. The VGA display is grouped by pixels into several regions (visible region included) and the horizontal_sync and vertical_sync allow the VGA display to keep track of when a new vertical/horizontal line is reached.
assign horizontal_sync = (horizontal_counter >= 10'd0 && horizontal_counter < 10'd96) ? 1'b1:1'b0; 
assign vertical_sync = (vertical_counter >= 10'd0 && vertical_counter < 10'd2) ? 1'b1:1'b0;

assign red = tempRed;
assign green = tempGreen;
assign blue = tempBlue;

//More sequential logic. This block of code confirms that we're in the visible region and assigns the colour of the pixel accordingly.
//The colour is assigned by following the bit value of a is_black_or_white wire that tells the VGA display what to colour the pixel
always @(posedge clk) begin
	if (horizontal_counter >= 10'd144 && horizontal_counter <= 10'd783 && vertical_counter >= 10'd35 && vertical_counter <= 10'd514) begin
			if (horizontal_coordinate_for_cursor == x_coordinate_for_cell && vertical_coordinate_for_cursor == y_coordinate_for_cell) begin
				tempRed <= 4'h0;
				tempGreen <= 4'h0;
				tempBlue <= 4'hF;
			end
			else if (is_pixel_black_or_white == 1'b1) begin
				tempRed <= 4'h0;
				tempGreen <= 4'h0;
				tempBlue <= 4'h0;
			end
			else begin
				tempRed <= 4'hF;
				tempGreen <= 4'hF;
				tempBlue <= 4'hF;
			end
	end
	else 
		begin
			tempRed <= 4'h0;
			tempGreen <= 4'h0;
			tempBlue <= 4'h0;
		end
end
endmodule

