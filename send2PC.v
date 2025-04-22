`ifndef SEND2PC
	`define SEND2PC
	module send2PC(
		output reg [7:0] asciiSequence,
		output reg write, done_tick,
		input [3:0] d3, d2, d1, d0,
		input send,
		input clk, reset
	);
		localparam	IDLE=0,
					NL=1,
					DOT=2,
					D1=3,
					D2=4,
					D3=5;
		reg [2:0] state;
		always @(posedge clk, posedge reset) begin
			if (reset) begin
			   	asciiSequence <= 0;
				state <= IDLE;
				write <= 0;
				done_tick <= 0;
			end
			else begin
				case (state)
					IDLE: begin
						if (send) begin
							state <= D3;
							write <= 1;
							asciiSequence <= d3+8'd48;
						end
						else begin
							asciiSequence <= 0;
							write <= 0;
						end
					end			
					D3: begin
						asciiSequence <= 8'd46;
						state <= DOT;
					end
					DOT: begin
						asciiSequence <= 8'd48 + d2;
						state <= D2;
					end
					D2: begin
						asciiSequence <= d1 + 8'd48;
						state <= D1;
					end
					D1: begin
						asciiSequence <= d0 + 8'd48;
						state <= NL;
					end
					NL: begin
						asciiSequence <= 8'd10;
						state <= IDLE;
						done_tick <= 1;
					end
				endcase	
			end
		end
	endmodule
`endif
