`ifndef ENCODE_CTRL
	`define ENCODE_CTRL
	module encode_ascii(
		output reg	go,
					pause,
					//reverse,
					receive,
					clear,
		input [7:0] ascii
	);
		always @* begin
			go = 0;
			pause = 0;
			//reverse = 0;
			receive = 0;
			clear = 0;
			case (ascii) 
				8'd103, 8'd71: go = 1;
				8'd112, 8'd80: pause = 1;
				//117, 85: reverse = 1;
				8'd114, 8'd82: receive = 1;
				8'd67, 8'd99: clear = 1;
				default: begin
					go=0;
					pause=0;
					receive=0;
					clear=0;
				end
			endcase
		end	
	endmodule
`endif
