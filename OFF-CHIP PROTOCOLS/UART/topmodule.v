/*	module top(
	input rst,clk,top_ready,p_sel,
	input [1:0]baud_sel,
	input [7:0]uart_data_tx_in,
	output error,
	output [7:0]uart_data_rx_out,
	output test
	);
	wire from_tx, from_rx;
	wire out;
		baud baud_gen(	.clk(clk),
						.reset(rst),
						.baud_select(baud_select),
						.from_tx(from_tx), 
						.from_rx(from_rx)
							    );
	
		uart_tx uartt(			.rst(rst),
		         			.clk(clk),
		         			.ready(ready),
		         			.tx_d_in(tx_d_in),
		         			.baud_tick_tx(from_tx),
		         			.p_sel(p_sel),
		         			.tx_d_out(out)
		                         );

		receive uartr(			.clk(clk),
				  		.rst(rst),
				  		.rx_d_in(rx_d_in),
				  		.rx_d_in(out),
				  		.baud_tick_rx(from_rx),
				  		.error(error)
				                );


		assign test = from_tx;
	endmodule */

module top(
    input rst,
    input clk,
    input top_ready,
    input p_sel,
    input [1:0] baud_sel,
    input [7:0] uart_data_tx_in,
    output error,
    output [7:0] uart_data_rx_out,
    output test
);

    wire from_tx, from_rx;
    wire tx_out;

    // Baud rate generator instance
    baud baud_gen (
        .clk(clk),
        .rst(rst),
        .baud_select(baud_sel),
        .from_tx(from_tx),
        .from_rx(from_rx)
    );

    // UART Transmitter instance
    uart uartx (
        .rst(rst),
        .clk(clk),
        .ready(top_ready),
        .tx_d_in(uart_data_tx_in),
        .baud_tick_tx(from_tx),
        .p_sel(p_sel),
        .tx_d_out(tx_out)
    );

    // UART Receiver instance
    receive uartr (
        .clk(clk),
        .rst(rst),
        .rx_d_in(tx_out),
        .baud_tick_rx(from_rx),
        .error(error),
        .d_out_rx(uart_data_rx_out)
    );

    assign test = from_tx;

endmodule

