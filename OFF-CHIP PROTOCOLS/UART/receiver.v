module receive(
    input clk,
    input rst,
    input rx_d_in,
    input baud_tick_rx,
    output reg error,
    output reg [7:0] d_out_rx
);

reg [1:0] present, next;
reg [9:0] temp_rx;
reg p_bit;
integer rx_count;

    parameter IDLE = 0, 
                    RECEIVE = 1,
                    PARITY = 2;

always @(posedge clk or negedge rst) begin
    if (!rst)
        present <= IDLE;
    else
        present <= next;
end

always @(*) begin
    case (present)
        IDLE: begin
            error = 1'b0;
            next = IDLE;
        end 

        RECEIVE: begin
            if (rx_count == 0) 
                next = PARITY;
            else
                next = RECEIVE;
        end

        PARITY: begin
            p_bit = ^temp_rx[9:2];
            if (p_bit == 0) begin
                d_out_rx = temp_rx[9:2];
                next = IDLE;
            end else begin
                error = 1'b1;
                next = IDLE;
            end
        end 
    endcase
end

always @(posedge baud_tick_rx or negedge rst) begin
    if (!rst) begin
        rx_count <= 10;
        present <= IDLE;
    end 
    else begin
        case (present)
            IDLE: begin
                if (!rx_d_in) begin
                    rx_count <= 9;
                    present <= RECEIVE;
                end
            end

            RECEIVE: begin
                temp_rx[rx_count] <= rx_d_in;
                if (rx_count == 0)
                    present <= PARITY;
                else
                    rx_count <= rx_count - 1;
            end

            PARITY: begin
                present <= IDLE;
            end
        endcase
    end
end

endmodule
