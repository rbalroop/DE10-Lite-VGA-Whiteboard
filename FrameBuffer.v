//This is the module where RAM "slots" are generated. 
module FrameBuffer(

	input wire clk,
	input wire [6:0] x_coordinate_of_pixel_to_write,
	input wire [5:0] y_coordinate_of_pixel_to_write,
	input wire [6:0] x_coordinate_of_pixel_to_read,
	input wire [5:0] y_coordinate_of_pixel_to_read,
	
	input wire should_cursor_pixel_be_black_or_white,
	input wire clear,
	output reg is_vga_pixel_black_or_white
	
);

//This module stores 2D compressed version of the array of pixels displayed on the VGA.
//When the VGA needs to determine what colour a pixel will be, it pulls that information from here.

reg frame_buffer_memory [0:59][0:79];
	
integer row_index;
integer column_index;

//Initial building of the array and setting all cells to be "white" as interpreted by the VGA
//For each clock cycle, the coordinates of the cursor and VGA pixels are checked.
initial begin
	for (row_index = 0; row_index <= 59; row_index = row_index + 1)
		for (column_index = 0; column_index <= 79; column_index = column_index + 1)
			frame_buffer_memory[row_index][column_index] = 1'b0;
end
	
//The coordinates from the VGA are interpreted as pixels to read and the coordinates of the cursor are interpreted as pixels to write. By keeping track of the position of the cursor, we know the latest group of pixels to have
//their colours turned white or block. In addition, as the VGA is generating the display, the coordinates of the pixel to be display next are interpreted by the frame buffer as pixels to read.
//If we clear the board, all cells are set to 0, which is interpreted by the VGA as white pixels across the entire screen.

always @(posedge clk) 
begin
	if (clear)
		begin
			for (row_index = 0; row_index <= 59; row_index = row_index + 1)
				for (column_index = 0; column_index <= 79; column_index = column_index + 1)
					frame_buffer_memory[row_index][column_index] <= 1'b0;
			is_vga_pixel_black_or_white <= 1'b0;
		end
	else 
		begin
			if (x_coordinate_of_pixel_to_write <= 79 && y_coordinate_of_pixel_to_write <= 59) 
				begin
					frame_buffer_memory[y_coordinate_of_pixel_to_write][x_coordinate_of_pixel_to_write] <= should_cursor_pixel_be_black_or_white;
				end
			if (x_coordinate_of_pixel_to_read <= 79 && y_coordinate_of_pixel_to_read <= 59) 
				begin
					is_vga_pixel_black_or_white <= frame_buffer_memory[y_coordinate_of_pixel_to_read][x_coordinate_of_pixel_to_read];
				end 
			else 
				begin
					is_vga_pixel_black_or_white <= 1'b0;
				end
		end
end
	 
	
endmodule
