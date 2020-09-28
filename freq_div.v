/* Frequency Divider */
/* Adjustable Multiples */

module freq_div(input clk,           // Original clock source (f)
                output reg clk_div); // Divided clock source (f_1 = f / multiple)
    parameter half_multiple = 6;    // Multiple
    reg [11:0] count        = 0;    // Counter
    
    always @(posedge clk) begin
        if (count == half_multiple - 1) begin
            clk_div <= clk_div ^ 1;
            count   <= 0;
        end
        else begin
            count <= count + 1;
        end
    end
endmodule
