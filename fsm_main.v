/* Finite State Machine */

`define IDLE 2'b00
`define MOVE 2'b01
`define WAIT 2'b11

module fsm_main(input clk,               // Clock source (f = 1kHz)
                input rst_n,             // Reset (0 = reset)
                input key_1,             // Status of carriage (1 = occupied, 0 = vacant)
                input key_2,             // Sign of driving status (1 = moving, 0 = waiting)
                output reg [1:0] state); // Current State (sequential logic)
    reg [1:0] next_state; // Next State (combinational logic)
    wire [2:0] keys;      // Combination of keys
    assign keys = {key_1, key_2};
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state = `IDLE;
        else
            state = next_state;
    end
    
    always @(keys) begin
        case (state)
            `IDLE: begin
                if (key_1 && key_2)
                    next_state = `MOVE;
                else if (key_1 && !key_2)
                    next_state = `WAIT;
                else
                    next_state = `IDLE;
            end
            `MOVE: begin
                if (!key_1)
                    next_state = `IDLE;
                else if (!key_2)
                    next_state = `WAIT;
                else
                    next_state = `MOVE;
            end
            `WAIT: begin
                if (!key_1)
                    next_state = `IDLE;
                else if (key_2)
                    next_state = `MOVE;
                else
                    next_state = `WAIT;
            end
            default:;
        endcase
    end
endmodule
