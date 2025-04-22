`ifndef BCD_COUNTER
`define BCD_COUNTER
`include "clk_div_26bit.v"
`include "bcd2sseg_active_low.v"
//expects 50MHz clk
//counts in seconds
module bcd_counter(
	output [7:0]	sseg5, 
					sseg4, 
					sseg3, 
					sseg2, 
					sseg1, 
					sseg0,

	output reg [3:0]	bcd5,
					bcd4,
					bcd3,
					bcd2,
					bcd1,
					bcd0,
	output done_tick, 
	input start, reset, clk_50MHz
);
	parameter CLK_DIVIDE=0;
	bcd2sseg_active_low convert(
		.bcd5(bcd5),
		.bcd4(bcd4),
		.bcd3(bcd3),
		.bcd2(bcd2),
		.bcd1(bcd1),
		.bcd0(bcd0),
		.sseg5(sseg5[6:0]),
		.sseg4(sseg4[6:0]),
		.sseg3(sseg3[6:0]),
		.sseg2(sseg2[6:0]),
		.sseg1(sseg1[6:0]),
		.sseg0(sseg0[6:0])
	);
	assign 
	{sseg5[7], sseg4[7], sseg2[7], sseg1[7], sseg0[7]} = ~6'd0;
	assign sseg3[7] = 0;

	assign done_tick = {bcd5, bcd4, bcd3, bcd2, bcd1, bcd0} == 24'h999999;

	clk_div_26bit clk_div(
		.clk_out(clk_1Hz),
		.clk(clk_50MHz),
		.reset(reset),
		.divider(CLK_DIVIDE)
	);
		
	always @(posedge clk_50MHz, posedge reset) begin
		if (reset) begin
			bcd5 <= 9;
			bcd4 <= 9;
			bcd3 <= 0;
			bcd2 <= 0;
			bcd1 <= 0;
			bcd0 <= 0;
		end
		else if (start && !done_tick && clk_1Hz) begin
			if (bcd0 == 9) begin
				bcd0 <= 0;
				if (bcd1 == 9) begin
					bcd1 <= 0;
					if (bcd2 == 9) begin
						bcd2 <= 0;
						if (bcd3 == 9) begin
							bcd3 <= 0;
							if (bcd4 == 9) begin
								bcd4 <= 0;
								if (bcd5 == 9) bcd5 <= 0;
								else bcd5 <= bcd5 + 1;
							end
							else begin
								bcd4 <= bcd4 + 1;
								bcd5 <= bcd5;
							end
						end
						else begin
							bcd3 <= bcd3 + 1;
							bcd4 <= bcd4;
							bcd5 <= bcd5;
						end
					end
					else begin
						bcd2 <= bcd2 + 1;
						bcd3 <= bcd3;
						bcd4 <= bcd4;
						bcd5 <= bcd5;	
					end
				end
				else begin
					bcd1 <= bcd1 + 1;
					bcd2 <= bcd2;
					bcd3 <= bcd3;
					bcd4 <= bcd4;
					bcd5 <= bcd5;
				end
			end
			else begin
				bcd0 <= bcd0 + 1;
				bcd1 <= bcd1;	
				bcd2 <= bcd2;
				bcd3 <= bcd3;
				bcd4 <= bcd4;
				bcd5 <= bcd5;	
			end
		end
	end
endmodule
`endif
