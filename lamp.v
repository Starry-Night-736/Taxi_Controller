/* Lamp */

`define IDLE 2'b00
`define MOVE 2'b01
`define WAIT 2'b11

module lamp(input clk,                // Clock source (f = 1Hz)
            input [1:0] state,        // Current state
            output wire [7:0] LED_G); // Green LEDs
    reg [3:0] count = 0;
    
    assign LED_G[0] = (state == `MOVE && count == 0)?1:0;
    assign LED_G[1] = (state == `MOVE && count == 1)?1:0;
    assign LED_G[2] = (state == `MOVE && count == 2)?1:0;
    assign LED_G[3] = (state == `MOVE && count == 3)?1:0;
    assign LED_G[4] = (state == `MOVE && count == 4)?1:0;
    assign LED_G[5] = (state == `MOVE && count == 5)?1:0;
    assign LED_G[6] = (state == `MOVE && count == 6)?1:0;
    assign LED_G[7] = (state == `MOVE && count == 7)?1:0;
    
    always @(posedge clk) begin
        if (state == `MOVE) begin
            if (count == 7)
                count <= 0;
            else
                count <= count + 1;
        end
        else
            count <= 0;
    end
endmodule
