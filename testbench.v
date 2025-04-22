`timescale 1ns / 1ns 
`include "uart_stopwatch.v"
`include "uart.v"
module genclk(output reg clk);
	initial begin
		clk=0;
		forever #10 clk = ~clk;
	end
endmodule
`timescale 1ns / 1ns
module stimulus;
	wire clk, do_read, status_ready0, status_ready1;
	wire [3:0] d2;
	genclk inst(clk);
	reg [7:0] signal;
	reg reset, do_write;

	uart uart_inst(
		.clk(clk),
		.reset(reset),
		.tx(tx),
		.data_in(signal),
		.rx(rx),
		.wr_data(do_write),
		.rd_data(do_read),
		.ready(status_ready1)
	);	

	uart_stopwatch sw(
		.clk(clk),
		.reset(reset),
		.rx(tx),
		.tx(rx),
		.status_ready(status_ready0)
	);
	
		
	initial begin
		reset = 1;
		@(posedge clk);
		reset = 0;
		@(posedge clk);
		do_write = 1;
		signal = 8'd52;
		@(posedge clk);
		do_write = 0;
		$display("waiting for status ready");
		wait(status_ready0);
		$display("success");
		signal = 8'd103;
		do_write = 1;
		@(posedge clk);
		do_write = 0;
		wait(sw.go);
		@(posedge clk)
		$display("gone");
		signal = 8'd112;  
		do_write=1;
		@(posedge clk);
		do_write=0;
		wait(sw.pause);
		@(posedge clk);
		$display("%t, paused, %d.%d%d", $time, sw.d2, sw.d1, sw.d0);
		signal = 8'd114;  
		do_write=1;
		@(posedge clk);
		do_write=0;
		wait(sw.receive);
		$display("start to receive");
		wait(sw.send.done_tick);
		$display("%t send 2 PC done success", $time);
		wait(sw.uart_inst.tx_empty);
		$finish;
	end

endmodule
