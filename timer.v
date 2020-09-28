/* Timer */

`define IDLE 2'b00
`define MOVE 2'b01
`define WAIT 2'b11

module timer(input clk,                    // Clock source (f = 100Hz)
             input rst_n,                  // Reset (0 = reset)
             input [1:0] state,            // Current state
             output reg [15:0] tm,         // Time (m-m-s-s)
             output reg [15:0] tm_locked);
    reg [3:0] count;        // Counter for timer (maximum 10)
    reg isLocked;
    
    // always @(posedge clk or negedge rst_n) begin
    //     if (!rst_n) begin
    //         count <= 0;
    //     end
    //     else begin
    //         if (state == `IDLE) begin
    //             count <= 0;
    //         end
    //         else if (state == `WAIT) begin
    //             if (count == 1) begin
    //                 count <= 0;
    //             end
    //             else begin
    //                 count <= count + 1;
    //             end
    //         end
    //         else        // state == `MOVE, do nothong
    //             ;
    //     end
    // end
    
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tm = 0;
        end
        else begin
            if (state == `IDLE) begin
                if (!isLocked) begin
                    tm_locked = tm;
                    isLocked  = 1;
                end
                tm = 0;
            end
            else begin
                isLocked = 0;
                // if (count == 9) begin
                if (state == `WAIT) begin
                    tm[3:0] = tm[3:0] + 1;
                end
                else
                    ;
                
                if (tm[3:0] > 9) begin
                    tm[3:0] = tm[3:0] - 10;
                    tm[7:4] = tm [7:4] + 1;
                end
                else
                    ;
                
                if (tm[7:4] > 5) begin
                    tm[7:4]  = tm[7:4] - 6;
                    tm[11:8] = tm [11:8] + 1;
                end
                else
                    ;
                
                if (tm[11:8] > 9) begin
                    tm[11:8]  = tm[11:8] - 10;
                    tm[15:12] = tm [15:12] + 1;
                end
                else
                    ;
                
                if (tm[15:12] > 5) begin
                    tm[3:0]   = 9;
                    tm[7:4]   = 5;
                    tm[11:8]  = 9;
                    tm[15:12] = 5;
                end
                else
                    ;
                    // end
                    // else
                    // ;
            end
        end
    end
endmodule
