
module tb;

reg rst,clk,ready,p_sel;
reg [7:0] uart_data_tx_in;
reg [1:0]baud_sel;
wire error;
wire [7:0]uart_data_rx_out;
wire test;

top uut1(rst,clk,ready,p_sel,baud_sel,uart_data_tx_in,error,uart_data_rx_out,test);


initial begin
	clk = 0;
	forever #10 clk = ~ clk;
end 

initial
begin 
	rst = 0;
	#30;
	rst =1;
	baud_sel = 2'b11;
	uart_data_tx_in = 16'hAA;

	p_sel = 0;
	ready = 1;
end


initial begin
$dumpfile("uard.vcd");
$dumpvars;
#50000000;
$finish;
end
endmodule
