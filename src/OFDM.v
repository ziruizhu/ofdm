module OFDM (
    input clk,
    input reset,
    input x_in,
    output [3:0] x_out
);


reg clk_half;

always@(negedge clk or posedge reset)
begin
	 if(reset)
	   begin
		  clk_half <= 1;
		end
	 else
		  clk_half <= ~clk_half;			
end


wire encoder_out;
wire encoder_esig;

Encoder encoder1(
    .clk(clk),
    .reset(reset),
    .in(x_in),
    .out(encoder_out),
    .esig(encoder_esig)
);

wire mod_en;
wire signed [15:0] mod_outx;
wire signed [15:0] mod_outy;

Mod mod1(
    .clk(clk),
    .reset(reset),
    .en(mod_en),
    .in(encoder_out),
    .outx(mod_outx),
    .outy(mod_outy)
);


wire ifft_en;
wire signed [15:0] ifft_out_re;
wire signed [15:0] ifft_out_im;

reg always_en;
always@(posedge clk)
begin
     if(reset)
       begin
          always_en <= 0;
        end
end

always @(*) begin
    if (mod_en == 1'b1)
    begin
        always_en <= 1'b1;
    end
end

IFFT64 ifft1(
    .clock(clk_half),
    .reset(reset),
    .di_en(always_en),
    .di_re(mod_outx),
    .di_im(mod_outy),
    .do_en(ifft_en),
    .do_re(ifft_out_re),
    .do_im(ifft_out_im)
);

// wire [15:0] cp_out_re,cp_out_im;
// wire cp_en;
// CP_test CP_test1(
//     .sysclk(clk),
//     .RST_I(reset),
//     .DAT1_I_r(ifft_out_re),
//     .DAT1_I_i(ifft_out_im),
//     .ACK_I(ifft_en),
//     .DAT2_O_r(cp_out_re),
//     .DAT2_O_i(cp_out_im),
//     .ACK_O(cp_en)
// );


// wire fft_en;
// wire [15:0] fft_out_re, fft_out_im;

// FFT64 fft1(
//     .clock(clk),
//     .reset(reset),
//     .di_en(cp_en),
//     .di_re(cp_out_re),
//     .di_im(cp_out_im),
//     .do_en(fft_en),
//     .do_re(fft_out_re),
//     .do_im(fft_out_im)
// );

wire fft_en;
wire [15:0] fft_out_re, fft_out_im;

FFT64 fft1(
    .clock(clk),
    .reset(reset),
    .di_en(ifft_en),
    .di_re(ifft_out_re),
    .di_im(ifft_out_im),
    .do_en(fft_en),
    .do_re(fft_out_re),
    .do_im(fft_out_im)
);



wire demod_en;
wire [1:0] demod_out;
De_Mod deMod1(
    .clk(clk),
    .reset(reset),
    .fft_en(fft_en),
    .inx(fft_out_re),
    .iny(fft_out_im),
    .out(demod_out),
    .en(en)
);




Decoder decoder1(
    .clk(clk),
    .reset(reset),
    .in(demod_out),
    .out(x_out)
);



endmodule
