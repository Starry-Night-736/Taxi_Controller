/*  Price-meter */

`define IDLE 2'b00
`define MOVE 2'b01
`define WAIT 2'b11

`define ONE 4'b0001
`define TWO 4'b0010
`define FOUR 4'b0100
`define NINE 4'b1001
`define TEN 4'b1010

module pricemeter(input clk,                       // Clock source (f = 10Hz)
                  input rst_n,                     // Reset (0 = reset)
                  input [1:0] state,               // Current state (flag of pricing)
                  output reg [19:0] price,         // Price (20-digit, each 4 digits represent a decimal number)
                  output reg [19:0] price_locked);
    reg isLocked;
    reg charging;
    
    // Parameters
    parameter max_dist  = 9;
    parameter max_time  = 599;
    parameter max_start = 2999;
    
    // Counters
    reg [9:0] count_dist;    // Counter of distance pricing timer (maximum 4'b1010 = 10)
    reg [9:0] count_time;    // Counter of time pricing timer (maximum 10'b1001011000 = 600)
    
    // Signs
    reg [11:0] count_start;   // Counter of distance pricing timer, measuring starting price (maximum 9'b100101100 = 300)
    // Flag signal of charging extra distance price
    reg is_initialized;      // Sign of initialization
    
    // Wires
    wire en_dist;            // Enable of distance pricing
    wire en_time;            // Enable of time pricing
    assign en_dist = (state == `MOVE)?1:0;
    assign en_time = (state == `WAIT)?1:0;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all counters
            count_dist <= 0;
            count_time <= 0;
        end
        else begin
            if (en_dist) begin
                if (count_start == max_start) begin
                    count_start <= 0;
                    charging    <= 1;
                end
                else begin
                    if (!charging) begin
                        count_start <= count_start + 1;
                    end
                    else
                        ;
                end
                
                if (count_dist == max_dist)      // Reached maximum
                    count_dist <= 0;
                else
                    count_dist <= count_dist + 1;
            end
            else if (state == `IDLE)
                charging <= 0;
            else
                ;
            
            if (en_time) begin
                if (count_time == max_time)      // Reached maximum
                    count_time <= 0;
                else
                    count_time <= count_time + 1;
            end
            else
                ;       // void
        end
    end
    
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            price = 0;
        end
        else begin
            if (state == `IDLE) begin
                is_initialized = 0;
                if (!isLocked) begin
                    price_locked = price;
                    isLocked     = 1;
                end
                price = 0;
            end
            else begin
                isLocked = 0;
                if (!is_initialized) begin
                    price[15:12]   = `NINE;
                    is_initialized = 1;
                end
            end
            
            if (charging) begin
                if (count_dist == max_dist) begin      // Distance unit reached
                    price[3:0] = price[3:0] + `FOUR;
                    price[7:4] = price[7:4] + `TWO;
                end
                else
                    ;
            end
            else
                ;
            
            if (count_time == max_time) begin      // Time unit reached
                price[15:12] = price[15:12] + `ONE;
            end
            else
                ;
            
            // Carry bits
            if (price[3:0] > `NINE) begin
                price[3:0] = price[3:0] - `TEN;
                price[7:4] = price[7:4] + `ONE;
            end
            else
                ;
            
            if (price[7:4] > `NINE) begin
                price[7:4]  = price[7:4] - `TEN;
                price[11:8] = price[11:8] + `ONE;
            end
            else
                ;
            
            if (price[11:8] > `NINE) begin
                price[11:8]  = price[11:8] - `TEN;
                price[15:12] = price[15:12] + `ONE;
            end
            else
                ;
            
            if (price[15:12] > `NINE) begin
                price[15:12] = price[15:12] - `TEN;
                price[19:16] = price[19:16] + `ONE;
                if (price[19:16] > `NINE) begin
                    price[11:8]  = `NINE;
                    price[15:12] = `NINE;
                    price[19:16] = `NINE;
                end
                else
                    ;
            end
            else
                ;
        end
    end
    
endmodule
