module Whiteboard(
	input wire CLOCK_50, input wire move_up, input wire move_down, input wire move_left, input  wire move_right, input wire is_running,        
   input wire draw_or_erase, input wire clear, output wire VGA_HS, output wire VGA_VS, output wire [3:0]  VGA_R, output wire [3:0] VGA_G,
   output wire [3:0] VGA_B, output wire [6:0] PauseStateDisplayOutput, output wire [6:0] DrawStateDisplayOutput);

//This is the top level module that puts all the other modules together. 
//After dividing the built-in 50MHz clock and initializing the (initially white) 2D array of cells, the framebuffer is constantly updating itself based on the position of the cursor and informing the VGA module of the colour of the pixels it is generating.
	
	wire clk;
	ClockDivider ClockDividerInstance(CLOCK_50, clk);
	
   wire [6:0] vga_cell_x;  
   wire [5:0] vga_cell_y;   

   wire [6:0] cursor_x;     
   wire [5:0] cursor_y;     

	wire pixel_from_framebuffer;   
   wire pixel_from_cursor;        
    
   VGA VGAInstance(.clk(clk), .is_pixel_black_or_white (pixel_from_framebuffer), .horizontal_coordinate_for_cursor(cursor_x), .vertical_coordinate_for_cursor(cursor_y),
	.horizontal_sync(VGA_HS), .vertical_sync(VGA_VS), .x_coordinate_for_cell(vga_cell_x), .y_coordinate_for_cell(vga_cell_y), .red(VGA_R), .green(VGA_G), .blue(VGA_B));

   Cursor CursorInstance(.clk(clk), .move_up(move_up), .move_down(move_down), .move_left(move_left), .move_right(move_right), 
	.is_running(is_running), .draw_or_erase(draw_or_erase), .clear(clear), .horizontal_cursor_position(cursor_x), .vertical_cursor_position(cursor_y), 
	.should_pixel_be_black_or_white(pixel_from_cursor), .PauseStateDisplayOutput(PauseStateDisplayOutput), .DrawStateDisplayOutput(DrawStateDisplayOutput));

   FrameBuffer FrameBufferInstance(.clk(clk), .x_coordinate_of_pixel_to_write(cursor_x), .y_coordinate_of_pixel_to_write(cursor_y),
	 .x_coordinate_of_pixel_to_read(vga_cell_x), .y_coordinate_of_pixel_to_read(vga_cell_y), .should_cursor_pixel_be_black_or_white (pixel_from_cursor), 
	 .clear(clear), .is_vga_pixel_black_or_white(pixel_from_framebuffer));

endmodule