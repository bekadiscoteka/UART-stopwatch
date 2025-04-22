//clk divider
//divider max 67_108_863
`ifndef CLK_DIV_26BIT
`define CLK_DIV_26BIT
module clk_div_26bit(
	output reg clk_out,
	input clk, reset,
	input [25:0] divider
);
	reg [25:0] counter;
	always @(posedge clk, posedge reset) begin
		if (reset) begin
			counter <= 0;
			clk_out <= 0;
		end
		else if (counter == divider) begin
			counter <= 0;
			clk_out <= 1;
		end
		else begin
		   	counter <= counter + 1;
			clk_out <= 0;	
		end
	end
endmodule
`endif
