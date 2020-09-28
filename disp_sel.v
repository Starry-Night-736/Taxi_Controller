/* Display Selector */
// Allocate info to diplay on LED digits

`define IDLE 2'b00
`define MOVE 2'b01
`define WAIT 2'b11

`define DIG_C 7'b0110001
`define DIG_D 7'b0000001
`define DIG_E 7'b0110000
`define DIG_I 7'b1001111
`define DIG_M 7'b0001001        // Substitute
`define DIG_P 7'b0011000
`define DIG_R 7'b0001000
`define DIG_S 7'b0100100
`define DIG_T 7'b0001111        // Substitute

`define ONES_8  8'b11111111
`define ONES_16 16'b1111111111111111
`define ONES_24 24'b111111111111111111111111
`define ONES_32 32'b11111111111111111111111111111111


module disp_sel(input clk,                  // Clock source (f = 5Hz)
                input rst_n,                // Reset (0 = reset)
                input [1:0] state,          // Current state
                input key_3,
                input key_4,
                input [31:0] digit_price,
                input [31:0] digit_tm,
                input [31:0] digit_dist,
                input [31:0] diglock_price,
                input [31:0] diglock_tm,
                input [31:0] diglock_dist,
                output wire [31:0] digit);
    wire [1:0] src;
    reg [31:0] digit_d; // Dynamic digits
    reg [31:0] digit_s; // Static digits
    reg [5:0] count;    // Counter for dynamic digits (maximum 57)
    
    
    assign src   = {key_4, key_3};
    assign digit = (state == `IDLE)?digit_d:digit_s;
    
    always @(state or rst_n or src) begin
        if (!rst_n) begin
            digit_s = `ONES_32;
        end
        else begin
            if (state == `IDLE) begin       // Lock info
                // diglock_price = digit_price;
                // diglock_tm    = digit_tm;
                // diglock_dist  = digit_dist;
                ;
            end
            else begin
                // diglock_price = `ONES_32;
                // diglock_tm    = `ONES_32;
                // diglock_dist  = `ONES_32;
                
                case (src)
                    2'b00: digit_s = `ONES_32;
                    2'b01: digit_s = digit_price;
                    2'b10: digit_s = digit_tm;
                    2'b11: digit_s = digit_dist;
                    default:;
                endcase
            end
        end
    end
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            digit_d <= `ONES_32;
        end
        else begin
            if (state == `IDLE) begin
                case (count)
                    0, 9: digit_d               <= `ONES_32;
                    10, 14, 15, 16, 21: digit_d <= `ONES_32;
                    22, 30, 34, 35, 36: digit_d <= `ONES_32;
                    40, 48, 52, 53, 54: digit_d <= `ONES_32;
                    
                    1: digit_d <= {`ONES_24, `DIG_P, 1'b1};
                    2: digit_d <= {`ONES_16, `DIG_P, 1'b1, `DIG_R, 1'b1};
                    3: digit_d <= {`ONES_8, `DIG_P, 1'b1, `DIG_R, 1'b1, `DIG_I, 1'b1};
                    4: digit_d <= {`DIG_P, 1'b1, `DIG_R, 1'b1, `DIG_I, 1'b1, `DIG_C, 1'b1};
                    5: digit_d <= {`DIG_R, 1'b1, `DIG_I, 1'b1, `DIG_C, 1'b1, `DIG_E, 1'b1};
                    6: digit_d <= {`DIG_I, 1'b1, `DIG_C, 1'b1, `DIG_E, 1'b1, `ONES_8};
                    7: digit_d <= {`DIG_C, 1'b1, `DIG_E, 1'b1, `ONES_16};
                    8: digit_d <= {`DIG_E, 1'b1, `ONES_24};
                    
                    11, 12, 13, 17, 18, 19: digit_d <= diglock_price;
                    
                    23: digit_d <= {`ONES_24, `DIG_T, 1'b1};
                    24: digit_d <= {`ONES_16, `DIG_T, 1'b1, `DIG_I, 1'b1};
                    25: digit_d <= {`ONES_8, `DIG_T, 1'b1, `DIG_I, 1'b1, `DIG_M, 1'b1};
                    26: digit_d <= {`DIG_T, 1'b1, `DIG_I, 1'b1, `DIG_M, 1'b1, `DIG_E, 1'b1};
                    27: digit_d <= {`DIG_I, 1'b1, `DIG_M, 1'b1, `DIG_E, 1'b1, `ONES_8};
                    28: digit_d <= {`DIG_M, 1'b1, `DIG_E, 1'b1, `ONES_16};
                    29: digit_d <= {`DIG_E, 1'b1, `ONES_24};
                    
                    31, 32, 33, 37, 38, 39: digit_d <= diglock_tm;
                    
                    41: digit_d <= {`ONES_24, `DIG_D, 1'b1};
                    42: digit_d <= {`ONES_16, `DIG_D, 1'b1, `DIG_I, 1'b1};
                    43: digit_d <= {`ONES_8, `DIG_D, 1'b1, `DIG_I, 1'b1, `DIG_S, 1'b1};
                    44: digit_d <= {`DIG_S, 1'b1, `DIG_I, 1'b1, `DIG_S, 1'b1, `DIG_T, 1'b1};
                    45: digit_d <= {`DIG_I, 1'b1, `DIG_S, 1'b1, `DIG_T, 1'b1, `ONES_8};
                    46: digit_d <= {`DIG_S, 1'b1, `DIG_T, 1'b1, `ONES_16};
                    47: digit_d <= {`DIG_T, 1'b1, `ONES_24};
                    
                    49, 50, 51, 55, 56, 57: digit_d <= diglock_dist;
                    
                    default: digit_d <= `ONES_32;
                endcase
                if (count < 58)
                    count <= count + 1;
                else
                    ;
            end
            else count = 0;
        end
    end
    
endmodule
