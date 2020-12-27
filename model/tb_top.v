`timescale 1ns/1ps
module tb_top();

reg reset;
wire reset_n;

wire [7:0] led;

wire ft601_clk;
wire TXE_N;
wire RXF_N;
wire WR_N;
wire RD_N;
wire OE_N;
wire SIWU_N;
wire [3:0] BE;
wire [31:0] DATA;

reg clk_90;

always begin
  clk_90 = 1'b0;
  forever begin
  #(11.111/2); clk_90 = ~clk_90;
  end
end

wire [31:0] mipi_wr_data;
wire mipi_wr_en;
wire ft601_req;
wire ft601_ack;


mipi_model
  u_mipi_model(
  .clk(clk_90),
  .reset_n(reset_n),

  .mipi_wr_data(mipi_wr_data[31:0]),
  .mipi_wr_en(mipi_wr_en),

  .ft601_req(ft601_req),
  .ft601_ack(ft601_ack)
  );

sd_top
	u_sd_top(
	.reset_n      (reset_n),

	//MIPI SIDE
	.mipi_clk     (clk_90),
	.mipi_wr_data (mipi_wr_data[31:0]),
	.mipi_wr_en   (mipi_wr_en),

	.ft601_req    (ft601_req),
	.ft601_ack    (ft601_ack),

	//FT601 SIDE
	.ft601_clk    (ft601_clk),
	.FT_RSTn      (),
	.TXE_N        (TXE_N),
	.RXF_N        (RXF_N),
	.WR_N         (WR_N),
	.RD_N         (RD_N),
	.OE_N         (OE_N),
	.SIWU_N       (SIWU_N),
	.BE           (BE[3:0]),	//4bit
	.DATA         (DATA[31:0]),	//32bit

	//MISC
	.sw           (4'b0000),	//4bits
	.led          ()			//4bits
	);

ft601_model
	u_ft601_model(
	.ft601_clk(ft601_clk),
	.reset_n(reset_n),

	.TXE_N(TXE_N),
	.RXF_N(RXF_N),

	.WR_N(WR_N),
	.RD_N(RD_N),
	.OE_N(OE_N),
	.SIWU_N(SIWU_N),

	.BE(BE[3:0]),
	.DATA(DATA[31:0])
	);

initial begin
	reset = 1'b0; reset = 1'b0;
	#44;
	reset = 1'b1;
	#55;
	reset = 1'b0;
	#330;
	reset = 1'b1;
	#10;
	reset = 1'b0;
	#400_000;
	$finish;
end

assign reset_n = ~reset;


//initial begin
//  $fsdbDumpfile("./fsdb/tb.fsdb");
//  $fsdbDumpvars(0);
//end 




endmodule 
