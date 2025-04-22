`ifndef UART_STOPWATCH
`define UART_STOPWATCH
`include "uart.v"
`include "fall_edge_detector.v"
`include "bin2bcd.v"
`include "bcd2sseg_active_low.v"
`include "encode_ascii.v"
`include "send2PC.v"
`include "stopwatch.v"
module uart_stopwatch 
	#(
		parameter WIDTH=8,
				SB=1,
					
				S=16,
				BAUND_RATE=9600, // initial baund rate, optional

				FIFO_DEPTH=8
	)
	(
		output [7:0] sseg3, sseg2, sseg1, sseg0,
		output status_ready,
		output reg receive_reg,
		output tx,	//when 1, baund is detected and ready 
								// to communicate
		input reset, clk, rx
		//write, get active-low buttons
);

	localparam SB_TICK=SB*S;
	wire do_write, go, pause, receive, clear_tick;
	wire [7:0] ascii, seq;
	wire [3:0] d3, d2, d1, d0;
	wire rx_full, rx_empty;	
	wire do_read = ~rx_empty;
	uart #(
		.SB_TICK(SB_TICK),
		.FIFO_DEPTH(FIFO_DEPTH),
		.BAUND_RATE(BAUND_RATE),
		.S(S),
		.WIDTH(WIDTH)
	)
	uart_inst(
		.clk(clk),
		.reset(reset),
		.data_out(ascii),
		.rx_full(rx_full),
		.rx_empty(rx_empty),
		.tx(tx),
		.data_in(seq),
		.rx(rx),
		.wr_data(do_write),
		.rd_data(do_read),
		.ready(status_ready)
	);	
	
	encode_ascii encoder(
		.ascii((ascii & {8{~rx_empty}})),
		.go(go),
		.pause(pause),
		//.reverse(reverse),
		.receive(receive),
		.clear(clear_tick)
	);

	stopwatch sw(
		.go(go),
		.pause(pause),
		//.reverse(reverse),
		.d3(d3),
		.d2(d2),
		.d1(d1),
		.d0(d0),
		.clear_tick(clear_tick),
		.sseg0(sseg0),
		.sseg1(sseg1),
		.sseg2(sseg2),
		.sseg3(sseg3),
		.clk(clk),
		.reset(reset)
	);	
	
	send2PC send(
		.d3(d3),
		.d2(d2),
		.d1(d1),
		.d0(d0),
		.send(receive),
		.asciiSequence(seq),
		.write(do_write),
		.clk(clk),
		.reset(reset)
	);


endmodule

`endif
