/*module uart(	input rstt,
		input 	clk,
		input 	ready,
		input 	[7:0] tx_d_in,
		input 	baud_tick_tx,
		input 	p_sel,
		output 	reg tx_d_out;
		);

reg [10:0] transmit_data;
reg [10:0] temp_data;
reg p_bit;
reg [3:0] tx_count;
reg [2:0] present, next;

	parameter [2:0] IDLE = 0,
			RECEIVE_BIT = 1,
	       		PARITY = 2,
			COUNT = 3,
			DATA_FRAME = 4;
	

always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		present <= IDLE;
		tx_d_out <= 1;
		tx_count <= 10;

	end
	else
		present <= next;
end

always@(*)
begin
	case(present)
		
		IDLE : begin
					next = !rst ? IDLE : RECEIVE_BIT;
					tx_count = 10;
					end
		RECEIVE_BIT :begin
				       	temp_data = tx_d_in;
					next = PARITY;
					end
		PARITY : begin
					case(p_sel)
						1'b0 : p_bit = !(^temp_data);
						1'b1 : p_bit = ^temp_data;
					endcase
					next = COUNT;
					end
		COUNT : 	begin
					transmit_data = {1'b0, tx_d_in, p_bit, 1'b1};
					next = ready ? DATA_FRAME : COUNT;

					end
		DATA_FRAME : begin
					
				if(tx_count >= 0 && tx_count <= 10)
					if(baud_tick_tx)
					begin
						tx_d_out = transmit_data[tx_count];
						tx_count = tx_count - 1;
		
					end
					else
						next = DATA_FRAME;

				else
					begin
						next = IDLE;
						
					end
		end
		default: next = IDLE;
	endcase
end				
endmodule*/

module uart(
    input rst,
    input clk,
    input ready,
    input [7:0] tx_d_in,
    input baud_tick_tx,
    input p_sel,
    output reg tx_d_out
);

    reg [10:0] transmit_data;
    reg [7:0] temp_data;
    reg p_bit;
    reg [3:0] tx_count;
    reg [2:0] present, next;

    parameter [2:0]
        IDLE = 0,
        RECEIVE_BIT = 1,
        PARITY = 2,
        COUNT = 3,
        DATA_FRAME = 4;

    // Sequential FSM state update
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            present <= IDLE;
        end else begin
            present <= next;
        end
    end

   
    always @(*) begin
        case (present)
            IDLE:        next = ready ? RECEIVE_BIT : IDLE;
            RECEIVE_BIT: next = PARITY;
            PARITY:      next = COUNT;
            COUNT:       next = ready ? DATA_FRAME : COUNT;
            DATA_FRAME:  next = (tx_count == 0) ? IDLE : DATA_FRAME;
            default:     next = IDLE;
        endcase
    end

   
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            tx_d_out <= 1;
            tx_count <= 0;
            
        end else begin
            case (present)
                RECEIVE_BIT: begin
                    temp_data <= tx_d_in;
                end
                PARITY: begin
                    if (p_sel == 0)
                        p_bit <= ~(^temp_data); 
                    else
                        p_bit <= ^temp_data;     
                end
                COUNT: begin
                    transmit_data <= {1'b1, p_bit, temp_data, 1'b0};                     tx_count <= 10;
                end
                DATA_FRAME: begin
                    if (baud_tick_tx) begin
                        tx_d_out <= transmit_data[0];
                        transmit_data <= transmit_data >> 1;
                        if (tx_count > 0)
                            tx_count <= tx_count - 1;
                    end
                end
                default: begin
                    tx_d_out <= 1;
                end
            endcase
        end
    end

endmodule

