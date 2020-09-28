/* Decoder */
// Translate BCD code of price, time and distance into LED digit code

`define DIG_0       7'b0000001
`define DIG_1       7'b1001111
`define DIG_2       7'b0010010
`define DIG_3       7'b0000110
`define DIG_4       7'b1001100
`define DIG_5       7'b0100100
`define DIG_6       7'b0100000
`define DIG_7       7'b0001111
`define DIG_8       7'b0000000
`define DIG_9       7'b0000100
`define DIG_NONE    7'b1111111

module decoder(input [19:0] price,            // Price (20-digit)
               input [15:0] tm,               // Time (16-digit, mm:ss)
               input [15:0] dist,             // Distance (xx.xx km)
               output reg [31:0] digit_price,
               output reg [31:0] digit_tm,
               output reg [31:0] digit_dist);
    
    always @(price) begin
        case (price[19:16])
            0: digit_price[23:16] = {`DIG_0, 1'b1};
            1: digit_price[23:16] = {`DIG_1, 1'b1};
            2: digit_price[23:16] = {`DIG_2, 1'b1};
            3: digit_price[23:16] = {`DIG_3, 1'b1};
            4: digit_price[23:16] = {`DIG_4, 1'b1};
            5: digit_price[23:16] = {`DIG_5, 1'b1};
            6: digit_price[23:16] = {`DIG_6, 1'b1};
            7: digit_price[23:16] = {`DIG_7, 1'b1};
            8: digit_price[23:16] = {`DIG_8, 1'b1};
            9: digit_price[23:16] = {`DIG_9, 1'b1};
            default:;
        endcase
        
        case (price[15:12])
            0: digit_price[15:8] = {`DIG_0, 1'b0};
            1: digit_price[15:8] = {`DIG_1, 1'b0};
            2: digit_price[15:8] = {`DIG_2, 1'b0};
            3: digit_price[15:8] = {`DIG_3, 1'b0};
            4: digit_price[15:8] = {`DIG_4, 1'b0};
            5: digit_price[15:8] = {`DIG_5, 1'b0};
            6: digit_price[15:8] = {`DIG_6, 1'b0};
            7: digit_price[15:8] = {`DIG_7, 1'b0};
            8: digit_price[15:8] = {`DIG_8, 1'b0};
            9: digit_price[15:8] = {`DIG_9, 1'b0};
            default:;
        endcase
        
        case (price[11:8])
            0: digit_price[7:0] = {`DIG_0, 1'b1};
            1: digit_price[7:0] = {`DIG_1, 1'b1};
            2: digit_price[7:0] = {`DIG_2, 1'b1};
            3: digit_price[7:0] = {`DIG_3, 1'b1};
            4: digit_price[7:0] = {`DIG_4, 1'b1};
            5: digit_price[7:0] = {`DIG_5, 1'b1};
            6: digit_price[7:0] = {`DIG_6, 1'b1};
            7: digit_price[7:0] = {`DIG_7, 1'b1};
            8: digit_price[7:0] = {`DIG_8, 1'b1};
            9: digit_price[7:0] = {`DIG_9, 1'b1};
            default:;
        endcase
        digit_price[31:24] = {`DIG_NONE, 1'b1};      // Set first digit of price empty
    end
    
    always @(tm) begin
        case (tm[15:12])
            0: digit_tm[31:24] = {`DIG_0, 1'b1};
            1: digit_tm[31:24] = {`DIG_1, 1'b1};
            2: digit_tm[31:24] = {`DIG_2, 1'b1};
            3: digit_tm[31:24] = {`DIG_3, 1'b1};
            4: digit_tm[31:24] = {`DIG_4, 1'b1};
            5: digit_tm[31:24] = {`DIG_5, 1'b1};
            6: digit_tm[31:24] = {`DIG_6, 1'b1};
            7: digit_tm[31:24] = {`DIG_7, 1'b1};
            8: digit_tm[31:24] = {`DIG_8, 1'b1};
            9: digit_tm[31:24] = {`DIG_9, 1'b1};
            default:;
        endcase
        
        case (tm[11:8])
            0: digit_tm[23:16] = {`DIG_0, 1'b0};
            1: digit_tm[23:16] = {`DIG_1, 1'b0};
            2: digit_tm[23:16] = {`DIG_2, 1'b0};
            3: digit_tm[23:16] = {`DIG_3, 1'b0};
            4: digit_tm[23:16] = {`DIG_4, 1'b0};
            5: digit_tm[23:16] = {`DIG_5, 1'b0};
            6: digit_tm[23:16] = {`DIG_6, 1'b0};
            7: digit_tm[23:16] = {`DIG_7, 1'b0};
            8: digit_tm[23:16] = {`DIG_8, 1'b0};
            9: digit_tm[23:16] = {`DIG_9, 1'b0};
            default:;
        endcase
        
        case (tm[7:4])
            0: digit_tm[15:8] = {`DIG_0, 1'b1};
            1: digit_tm[15:8] = {`DIG_1, 1'b1};
            2: digit_tm[15:8] = {`DIG_2, 1'b1};
            3: digit_tm[15:8] = {`DIG_3, 1'b1};
            4: digit_tm[15:8] = {`DIG_4, 1'b1};
            5: digit_tm[15:8] = {`DIG_5, 1'b1};
            6: digit_tm[15:8] = {`DIG_6, 1'b1};
            7: digit_tm[15:8] = {`DIG_7, 1'b1};
            8: digit_tm[15:8] = {`DIG_8, 1'b1};
            9: digit_tm[15:8] = {`DIG_9, 1'b1};
            default:;
        endcase
        
        case (tm[3:0])
            0: digit_tm[7:0] = {`DIG_0, 1'b1};
            1: digit_tm[7:0] = {`DIG_1, 1'b1};
            2: digit_tm[7:0] = {`DIG_2, 1'b1};
            3: digit_tm[7:0] = {`DIG_3, 1'b1};
            4: digit_tm[7:0] = {`DIG_4, 1'b1};
            5: digit_tm[7:0] = {`DIG_5, 1'b1};
            6: digit_tm[7:0] = {`DIG_6, 1'b1};
            7: digit_tm[7:0] = {`DIG_7, 1'b1};
            8: digit_tm[7:0] = {`DIG_8, 1'b1};
            9: digit_tm[7:0] = {`DIG_9, 1'b1};
            default:;
        endcase
    end
    
    always @(dist) begin
        case (dist[15:12])
            0: digit_dist[31:24] = {`DIG_0, 1'b1};
            1: digit_dist[31:24] = {`DIG_1, 1'b1};
            2: digit_dist[31:24] = {`DIG_2, 1'b1};
            3: digit_dist[31:24] = {`DIG_3, 1'b1};
            4: digit_dist[31:24] = {`DIG_4, 1'b1};
            5: digit_dist[31:24] = {`DIG_5, 1'b1};
            6: digit_dist[31:24] = {`DIG_6, 1'b1};
            7: digit_dist[31:24] = {`DIG_7, 1'b1};
            8: digit_dist[31:24] = {`DIG_8, 1'b1};
            9: digit_dist[31:24] = {`DIG_9, 1'b1};
            default:;
        endcase
        
        case (dist[11:8])
            0: digit_dist[23:16] = {`DIG_0, 1'b0};
            1: digit_dist[23:16] = {`DIG_1, 1'b0};
            2: digit_dist[23:16] = {`DIG_2, 1'b0};
            3: digit_dist[23:16] = {`DIG_3, 1'b0};
            4: digit_dist[23:16] = {`DIG_4, 1'b0};
            5: digit_dist[23:16] = {`DIG_5, 1'b0};
            6: digit_dist[23:16] = {`DIG_6, 1'b0};
            7: digit_dist[23:16] = {`DIG_7, 1'b0};
            8: digit_dist[23:16] = {`DIG_8, 1'b0};
            9: digit_dist[23:16] = {`DIG_9, 1'b0};
            default:;
        endcase
        
        case (dist[7:4])
            0: digit_dist[15:8] = {`DIG_0, 1'b1};
            1: digit_dist[15:8] = {`DIG_1, 1'b1};
            2: digit_dist[15:8] = {`DIG_2, 1'b1};
            3: digit_dist[15:8] = {`DIG_3, 1'b1};
            4: digit_dist[15:8] = {`DIG_4, 1'b1};
            5: digit_dist[15:8] = {`DIG_5, 1'b1};
            6: digit_dist[15:8] = {`DIG_6, 1'b1};
            7: digit_dist[15:8] = {`DIG_7, 1'b1};
            8: digit_dist[15:8] = {`DIG_8, 1'b1};
            9: digit_dist[15:8] = {`DIG_9, 1'b1};
            default:;
        endcase
        
        case (dist[3:0])
            0: digit_dist[7:0] = {`DIG_0, 1'b1};
            1: digit_dist[7:0] = {`DIG_1, 1'b1};
            2: digit_dist[7:0] = {`DIG_2, 1'b1};
            3: digit_dist[7:0] = {`DIG_3, 1'b1};
            4: digit_dist[7:0] = {`DIG_4, 1'b1};
            5: digit_dist[7:0] = {`DIG_5, 1'b1};
            6: digit_dist[7:0] = {`DIG_6, 1'b1};
            7: digit_dist[7:0] = {`DIG_7, 1'b1};
            8: digit_dist[7:0] = {`DIG_8, 1'b1};
            9: digit_dist[7:0] = {`DIG_9, 1'b1};
            default:;
        endcase
    end
    
endmodule
