//This module defines the operations we can do on the whiteboard.
//It follows the same 25 MHz clock as the other modules and is sensitive to changes in the switches
//assigned to "move up", "move down", "move left", "move right", "draw/erase", "pause", and "clear".

//Bit toggles since the DE10-lite is active low
module Cursor(
	
	input wire clk,
	input wire move_up,
	input wire move_down,
	input wire move_left,
	input wire move_right,
	input wire is_running,
	input wire draw_or_erase,
	input wire clear,
	
	output reg [6:0] horizontal_cursor_position,
	output reg [5:0] vertical_cursor_position,
	output reg should_pixel_be_black_or_white,
	
	output wire [6:0] PauseStateDisplayOutput,
	output wire [6:0] DrawStateDisplayOutput
);


assign run_switch = is_running; 

wire move_up_active;
assign move_up_active = ~move_up;

wire move_down_active;
assign move_down_active = ~move_down;

wire move_left_active;
assign move_left_active = ~move_left;

wire move_right_active;
assign move_right_active = ~move_right;

//This movement counter allows the cursor to only move after a certain number of clock cycles have passed.
//By doing this, the cursor becomes much slower and is therefore easier to control. Without this "handicap", the cursor would blitz through the board.

reg [22:0] movement_counter;
wire can_cursor_move = (movement_counter == 23'd0);

initial 
	begin 
		horizontal_cursor_position = 7'd0;
		vertical_cursor_position = 6'd0;
		should_pixel_be_black_or_white = 1'b0;
		movement_counter = 23'd0;
end

//Sequential logic for updating the coordinates of the cursor based o which switches are active.
always @(posedge clk) begin
	if (clear) begin 
		horizontal_cursor_position <= 7'd0;
		vertical_cursor_position   <= 6'd0;
		should_pixel_be_black_or_white <= 1'b0;
		movement_counter <= 23'd0;
	end
	
	else begin
		movement_counter <= movement_counter + 23'd1;
		if (is_running && can_cursor_move) begin
			if (draw_or_erase) begin
				should_pixel_be_black_or_white <= 1'b1;
				if (move_up_active && vertical_cursor_position > 0) begin
					vertical_cursor_position <= vertical_cursor_position - 1;
				end
				if (move_down_active && vertical_cursor_position < 6'd59) begin
					vertical_cursor_position <= vertical_cursor_position + 1;
				end
				if (move_left_active && horizontal_cursor_position > 0) begin
					horizontal_cursor_position <= horizontal_cursor_position - 1;
				end
				if (move_right_active && horizontal_cursor_position < 7'd79) begin
					horizontal_cursor_position <= horizontal_cursor_position + 1;
				end			
			end
			else begin
				should_pixel_be_black_or_white <= 1'b0;
				if (move_up_active && vertical_cursor_position > 0) begin
					vertical_cursor_position <= vertical_cursor_position - 1;
				end
				if (move_down_active && vertical_cursor_position < 6'd59) begin
					vertical_cursor_position <= vertical_cursor_position + 1;
				end
				if (move_left_active && horizontal_cursor_position > 0) begin
					horizontal_cursor_position <= horizontal_cursor_position - 1;
				end
				if (move_right_active && horizontal_cursor_position < 7'd79) begin
					horizontal_cursor_position <= horizontal_cursor_position + 1;
				end	
			end
		end		
	end

end

//Code for mini seven segment display modules that define the letters "A" (Active) and "I" (Inactive) to show the user whether their board is paused, and "D" (Draw) and "E" (Erase) for the draw/erase states.
PauseStateDisplay PauseStateDisplayInstance(.x(~is_running), .segments(PauseStateDisplayOutput));
DrawStateDisplay DrawStateDisplayInstance(.x(~draw_or_erase), .segments(DrawStateDisplayOutput));

endmodule

	