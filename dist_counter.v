/* Distance Counter */

`define IDLE 2'b00
`define MOVE 2'b01
`define WAIT 2'b11

module dist_counter(input clk,                      // Clock source (f = 100Hz)
                    input rst_n,                    // Reset (0 = reset)
                    input [1:0] state,              // Current state
                    output reg [15:0] dist,         // Distance (xx.xx)
                    output reg [15:0] dist_locked);
    reg [3:0] count;// Counter for distance timer (maximum 10)
    reg isLocked;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 0;
        end
        else begin
            if (state == `IDLE) begin
                count <= 0;
            end
            else if (state == `MOVE) begin
                if (count == 9) begin
                    count <= 0;
                end
                else begin
                    count <= count + 1;
                end
            end
            else        // state == `WAIT, do nothing
                ;
        end
    end
    
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dist = 0;
        end
        else begin
            if (state == `IDLE) begin
                if (!isLocked) begin
                    dist_locked = dist;
                    isLocked    = 1;
                end
                dist = 0;
            end
            else begin
                isLocked = 0;
                if (count == 9) begin
                    dist[3:0] = dist[3:0] + 1;
                end
                    if (dist[3:0] > 9) begin
                        dist[3:0] = dist[3:0] - 10;
                        dist[7:4] = dist [7:4] + 1;
                    end
                    else
                        ;
                
                if (dist[7:4] > 9) begin
                    dist[7:4]  = dist[7:4] - 10;
                    dist[11:8] = dist [11:8] + 1;
                end
                else
                    ;
                
                if (dist[11:8] > 9) begin
                    dist[11:8]  = dist[11:8] - 10;
                    dist[15:12] = dist [15:12] + 1;
                end
                else
                    ;
                
                if (dist[15:12] > 9) begin
                    dist[3:0]   = 9;
                    dist[7:4]   = 9;
                    dist[11:8]  = 9;
                    dist[15:12] = 9;
                end
                else
                    ;
            end
        end
    end
endmodule
