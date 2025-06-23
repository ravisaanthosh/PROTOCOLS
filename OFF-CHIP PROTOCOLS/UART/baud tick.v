module baud(
input clk,  
input rst, //reset
input [1:0]baud_select, //selecting the baud
output from_tx,from_rx);

reg baud_tick_rx,baud_tick_tx;

integer baud_partition_tx = 0;
integer baud_partition_rx = 0;
integer baud_count_tx = 0;
integer baud_count_rx = 0;
	
parameter
baud_standard_9600 = 2'b00,
baud_standard_19200 = 2'b01,
baud_standard_460800 = 2'b10,
baud_standard_1500000 = 2'b11;

			
always@(*)
begin
case(baud_select)
2'b00 : baud_partition_tx =14'd10416;
2'b01 : baud_partition_tx = 13'd5208;
2'b10 : baud_partition_tx = 8'd217;
2'b11 : baud_partition_tx =  7'd66;
endcase
end
always@(*)
begin
case(baud_select)
2'b00 : baud_partition_rx =14'd10416;
2'b01 : baud_partition_rx = 13'd5208;
2'b10 : baud_partition_rx = 8'd217;
2'b11 : baud_partition_rx = 7'd66;
endcase
end

always@(posedge clk, negedge rst)
begin
if(!rst)
begin
baud_tick_tx <= 0;
baud_count_tx <= 0;
end 
else if (baud_count_tx == baud_partition_tx)
begin
baud_count_tx <=0;
baud_tick_tx<= ~baud_tick_tx;
end 
else
baud_count_tx <=baud_count_tx+1'b1;		  
end 
always@(posedge clk, negedge rst)
begin
if(!rst)
begin
baud_tick_rx <= 0;
baud_count_rx <= 0;
end 
else if (baud_count_rx  == baud_partition_rx)
begin
baud_count_rx <=0;
baud_tick_rx<= ~ baud_tick_rx;
end 
else
baud_count_rx <=baud_count_rx +1'b1;		  
end 
 assign from_tx = baud_tick_tx;
 assign from_rx = baud_tick_rx;
	
endmodule
