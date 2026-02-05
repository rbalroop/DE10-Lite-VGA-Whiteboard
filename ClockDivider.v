//Simple module for slowing the clock from 50MHz to 25MHz for the VGA
module ClockDivider(
    input  wire cin,        // 50 MHz
    output reg  cout = 1'b0 // 25 MHz
);
    always @(posedge cin) begin
        cout <= ~cout;
    end
endmodule
