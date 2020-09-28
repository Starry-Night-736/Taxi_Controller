/* Flash Lights */

`define IDLE 2'b00
`define MOVE 2'b01
`define WAIT 2'b11

module flash(input clk,          // Clock source (f = 2Hz)
             input [1:0] state,  // Current state (flag of flash)
             output wire [7:0] LED_Y,  // Flash light for mode MOVE
             output wire [7:0] LED_R); // Flash light for mode WAIT
    reg [2:0] count_move;   // Counter of flash events (MOVE mode) (maximum 3'b110 = 6)
    reg [2:0] count_wait;   // Counter of flash events (MOVE mode) (maximum 3'b110 = 6)
    
    assign LED_Y = (state == `MOVE && count_move < 3'b110)?{8{clk}}:8'b00000000;
    assign LED_R = (state == `WAIT && count_wait < 3'b110)?{8{clk}}:8'b00000000;
    
    always @(posedge clk) begin
        case (state)
            `MOVE: begin
                count_wait <= 3'b000;
                if (count_move < 3'b110) begin
                    count_move <= count_move + 1'b1;
                end
                else;
            end
            `WAIT: begin
                count_move <= 3'b000;
                if (count_wait < 3'b110) begin
                    count_wait <= count_wait + 1'b1;
                end
                else;
            end
            default: begin
                count_move <= 3'b000;
                count_wait <= 3'b000;
            end
        endcase
    end
    
endmodule