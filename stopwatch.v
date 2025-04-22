`ifndef STOPWATCH
	`define STOPWATCH
	`include "bcd_counter.v"
	module stopwatch(
		output [3:0] d3, d2, d1, d0,
		output [7:0] sseg3, sseg2, sseg1, sseg0,
		input	go,
				//reverse,
				pause,
				receive,
				clear_tick,
		input clk, reset
	);
		reg start;
		bcd_counter #(.CLK_DIVIDE(49_999)) count(
			.start(start),
			.clk_50MHz(clk),
			.reset(reset),
			.bcd3(d3),
			.bcd2(d2),
			.bcd1(d1),
			.bcd0(d0),
			.clear_tick(clear_tick),
			.sseg3(sseg3),
			.sseg2(sseg2),
			.sseg1(sseg1),
			.sseg0(sseg0)
		);	

		always @(posedge clk, posedge reset) begin
			if (reset) start <= 0;
			else if (go) start <= 1;
			else if (pause | receive) start <= 0;
		end
		
	endmodule
`endif
