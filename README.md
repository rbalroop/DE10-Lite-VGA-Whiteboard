# DE10-Lite-VGA-Whiteboard
Verilog FPGA project for a VGA-connected DE10-Lite. Allows you to draw, erase, and clear drawings on a blank white canvas using solely the switches of the FPGA.

This project is a collection of several modules, including VGA, FrameBuﬀer, Cursor, and ClockDivider modules. In addition, it includes two small seven-
segment display modules and a top-level Whiteboard module for putting all the other modules together.

The whiteboard refreshes 25,000,000 times per second using a 50 MHz clock divider with the pixels being generated in the VGA module, line-
by-line. Each pixel’s colour (black or white) is determined by a compressed 2D array stored in memory and generated in the FrameBuﬀer module. The VGA
module maps each pixel to a cell in that 2D array, and assigns its colour based on the colour of that cell. In addition, the module is sensitive to a “clear”
switch which resets the entire FrameBuﬀer 2D array to white cells.

On the same clock cycle, the Cursor module’s input is also active and its outputs are fed to the FrameBuﬀer. Switches on the DE10-Lite designate
directions the cursor can move, as well as whether pixels traversed by the cursor should be coloured black (draw) or white (erase). The module is also
sensitive to a “pause” switch. When this switch is active, the cursor’s position refrains from updating itself each clock cycle until it is deactivated.

For each clock cycle, the cursor’s position is fed to the FrameBuﬀer so its array can update the state of the cells (black or white) that the cursor traversed
during the rising clock edge.
