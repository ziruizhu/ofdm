`timescale 1ns/1ps
module De_Mod (
    clk, reset, inx, iny, fft_en, en, out
);
    input clk;
    input reset;
    input signed [15:0] inx;
    input signed [15:0] iny;
    input fft_en;


    output en;
    output reg[1:0] out;

    reg esig;
    reg cnt;

    always @(posedge clk) begin
        if (reset) begin
            out <= 0;
            cnt <= 0;
            esig <= 0;
        end
        else if(fft_en)
        begin
            case (inx)
                16'b1: begin 
                    case (iny)
                        15'b1:  out <= 00;
                        -15'b1: out <= 11;
                        default: out <= 00;
                    endcase
                end
                -16'b1:begin
                    case (iny)
                        15'b1: out <= 01;
                        -15'b1:out <= 10;
                        default: out <= 00;
                    endcase
                end
            endcase
        end
    end
endmodule