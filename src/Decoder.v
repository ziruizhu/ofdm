`timescale 1ns/1ps
module Decoder (clk, reset, in, en, out);
    input clk;
    input reset;
    input in;
    input en;
    output reg [3:0] out;


    reg [2:0] in_count;
    reg [7:0] matrix[0:2];
    reg [7:0] in_data;
    reg [2:0] e;

    reg sig;

    integer i,j;


    always @(posedge clk) begin
        if (reset)
        begin
            matrix[0] <= 8'b00111010;
            matrix[1] <= 8'b01001110;
            matrix[2] <= 8'b10011100;
            sig <= 0;
            e <= 0;
            in_count <= 0;
        end
    end

    always @(posedge clk) begin
        if (!sig && en)
        begin
            if (in_count < 3'b111)
            begin
                in_data <= {in, in_data[7:1]};
                in_count <= in_count + 1;
            end
            else if (in_count == 3'b111)
            begin
                sig <= 1;
                in_count <= 0;
            end
        end
    end

    always @(posedge clk) begin
        if (sig)
        begin
            for (i = 0;i<3 ;i=i+1 ) begin
                for (j = 0;j < 8 ;j=j+1 ) begin
                    e[i] = e[i] + matrix[i][j]*in_data[j];
                end
            end
        end

        case (e)
            3'b000: out <= {in_data[1], in_data[2], in_data[3], in_data[4]};
            3'b110: out <= {~in_data[1], in_data[2], in_data[3], in_data[4]};
            3'b011: out <= {in_data[1], ~in_data[2], in_data[3], in_data[4]};
            3'b011: out <= {in_data[1], in_data[2], ~in_data[3], in_data[4]};
            3'b011: out <= {in_data[1], in_data[2], in_data[3], ~in_data[4]};
            default: out <= 4'b0000;
        endcase
    end
    
endmodule