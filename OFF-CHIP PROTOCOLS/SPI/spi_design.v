
/*module spi(input clk,reset,chip_sel,output reg master_data_out);
  reg[7:0]master_memory;
  reg[3:0]counter;
  reg master_in;
  wire master_wire;
  
  parameter IDLE=1'b0;
            TRANSMIT=1'b1;
  reg state,next_state;
  always @(posedge clk or posedge reset)begin
    if(reset==0)begin
      state<=IDLE;
      next_state<=0;
      master_memory<=0;
    end
    else
      state<=next_state;
  end
  always@(posedge clk)begin
    case(state)
      IDLE:begin
        if(chip_sel==0)begin
          next_state<=TRANSMIT;
          counter<=4'd8;
        end
        else
          next_state<=IDLE;
      end
      TRANSMIT:begin
        master_data_out<=master_memory[7];
        master_memory<={master_memory[6:0],master_in};
        counter<=counter-1;
        if(counter==0)begin
          counter<=4'd8;
          next_state<=IDLE;
        end
        else begin
          counter<=counter-1;
          next_state<=TRANSMIT;
        end
      end
    endcase
  end
  
  spi_sl uut1(.clk(clk),reset(reset),.slave_in(master_data_out),.chip_sel(chip_sel),slave_data_out(master_wire));
  
  
  assign master_in=(chip_sel==0)?master_wire:1'b0;
endmodule



//slave
module spi_slave(input clk,reset,slave_in,chip_sel,output reg slave_data_out);
  reg[7:0]slave_memory;
  reg[3:0]counter;
  parameter IDLE=1'b0;
  			TRANSMIT=1'b1;
  reg state,next_state;
  always @(posedge clk)begin
    if(reset==0)begin
      state<=IDLE;
      slave_memory<=8'b01011010;
      counter<=0;
      slave_data_out<=0;
    end
    else
      state<=next_state;
  end
  always@(posedge clk)begin
    case(state)
      IDLE:begin
        if(chip_sel==0)begin
          next_state<=TRANSMIT;
          counter<=4'd9;
        end
        else
          next_state<=IDLE;
      end
      TRANSMIT:begin
        slave_data_out<=slave_memory[7];
        slave_memory<={slave_memory[6:0],slave_in};
        if(counter==0)
          next_state<=IDLE;
        else begin
          next_state<=TRANSMIT;
          counter<=counter-1;
        end
      end
    endcase
  end
endmodule
*/
      module spi(input clk, reset, chip_sel, output reg master_data_out);
  reg [7:0] master_memory = 8'b10101010; 
  reg [3:0] counter;
  reg master_in;
  wire master_wire;

  parameter IDLE = 1'b0, TRANSMIT = 1'b1;
  reg state, next_state;


  spi_slave uut1(.clk(clk),.reset(reset),.slave_in(master_data_out),.chip_sel(chip_sel),.slave_data_out(master_wire));

 
  always @(posedge clk or posedge reset) begin
    if (reset)
      state <= IDLE;
    else
      state <= next_state;
  end


  always @(*) begin
    case (state)
      IDLE: begin
        if (chip_sel == 0)
          next_state = TRANSMIT;
        else
          next_state = IDLE;
      end
      TRANSMIT: begin
        if (counter == 0)
          next_state = IDLE;
        else
          next_state = TRANSMIT;
      end
      default: next_state = IDLE;
    endcase
  end

 
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      counter <= 4'd8;
      master_memory <= 8'b10101010;
      master_data_out <= 0;
    end else begin
      case (state)
        IDLE: begin
          counter <= 4'd8;
        end
        TRANSMIT: begin
          master_data_out <= master_memory[7];
          master_memory <= {master_memory[6:0], master_in};
          counter <= counter - 1;
        end
      endcase
    end
  end

  assign master_in = (chip_sel == 0) ? master_wire : 1'b0;
endmodule


//slave
module spi_slave(input clk, reset, slave_in, chip_sel, output reg slave_data_out);
  reg [7:0] slave_memory = 8'b01011010;
  reg [3:0] counter;

  parameter IDLE = 1'b0, TRANSMIT = 1'b1;
  reg state, next_state;

  always @(posedge clk or posedge reset) begin
    if (reset)
      state <= IDLE;
    else
      state <= next_state;
  end

  always @(*) begin
    case (state)
      IDLE: begin
        if (chip_sel == 0)
          next_state = TRANSMIT;
        else
          next_state = IDLE;
      end
      TRANSMIT: begin
        if (counter == 0)
          next_state = IDLE;
        else
          next_state = TRANSMIT;
      end
      default: next_state = IDLE;
    endcase
  end

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      counter <= 4'd8;
      slave_memory <= 8'b01011010;
      slave_data_out <= 0;
    end else begin
      case (state)
        IDLE: begin
          counter <= 4'd8;
        end
        TRANSMIT: begin
          slave_data_out <= slave_memory[7];
          slave_memory <= {slave_memory[6:0], slave_in};
          counter <= counter - 1;
        end
      endcase
    end
  end
endmodule

