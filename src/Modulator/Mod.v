`timescale 1ns/1ps
module Mod (
    clk, reset, in, en, outx, outy
);
    input clk;
    input reset;
    input in;

    output reg en;
    output reg signed [15:0] outx;
    output reg signed [15:0] outy;

    reg [1:0] in_data;
    reg [1:0] mod_data;
    reg esig;
    reg cnt;

    always @(negedge clk) begin
        if(reset) begin
            in_data <= 0;
            cnt <= 0;
            esig <= 0;
            mod_data <= 0;
        end
        else 
        begin
            if(cnt == 1'b1)
            begin
                in_data <= {in_data[0], in};
                cnt <= 0;
                esig <= 1;
            end
            else
            begin
                en <= 0;
                esig <= 0;
                in_data <= {in_data[0], in};
                cnt <= 1;
            end
        end
    end

    always @(*) begin
        if(esig)
        begin
            case (in_data)
                2'b00: begin outx <= 1'b1; outy <= 1; end
                2'b01: begin outx <= -1'b1; outy <= 1; end
                2'b10: begin outx <= -1'b1; outy <= -1'b1; end
                2'b11: begin outx <= 1'b1; outy <= -1'b1; end
                default: begin outx <= 0; outy <= 0; end
            endcase
            en <= 1;
        end
    end
endmodule