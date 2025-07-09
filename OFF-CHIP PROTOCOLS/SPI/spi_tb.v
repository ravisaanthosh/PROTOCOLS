module tb_spi;
  reg clk;
  reg reset;
  reg chip_sel;
  wire master_data_out;

  spi uut (.clk(clk),.reset(reset),.chip_sel(chip_sel),.master_data_out(master_data_out));

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    $dumpfile("spi.vcd");
    $dumpvars(0, tb_spi);
  end

  initial begin
    reset = 1; chip_sel = 1; #15;
    reset = 0; #15;
    reset = 1; #20;
    chip_sel = 0; #200;
    chip_sel = 1; #20;
    $finish;
  end
endmodule
