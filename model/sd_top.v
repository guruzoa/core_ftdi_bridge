`timescale 1ns/100ps
//	================================
//	Created by : Sangdon Kim (2016. 11. 2)
//	Modified by : 
//	Description : 
//	Revision History : 
//	================================

module sd_top(
	input reset,
	
	//FT601 SIDE
	input ft601_clk,
	output FT_RSTn,

	input TXE_N,		//245 Sync FIFO : Transmit FIFO Empty output signal. It indicates there is a minimum of 1 byte of space available to write.
	input RXF_N,		//245 Sync FIFO : Receive FIFO Full output signal. It indicates there is a minimum of 1byte of data available to read.
	
	output WR_N,		//245 Sync FIFO : Write Enable
	output RD_N,		//245 Sync FIFO : Read Enable
	output OE_N,		//245 Sync FIFO : Data Output Enable
	output SIWU_N,		//Reserved. Assert -> High
	
	inout [3:0] BE,		//Byte Enable
	inout [31:0] DATA,	//Data
	
	//MISC
	input  [3:0] sw,
	output [3:0] led,
	output tp21,
	output tp22

);

wire reset_n = ~reset;

//	FT601 Bist Logic
wire ft601_bist_en;

reg [27:0] cnt_byte_clk;
reg [27:0] cnt_ft601_clk;

wire error1;
wire error2;
wire error3;
wire error4;

(* mark_debug = 1 *) wire fifo_rd_start;
(* mark_debug = 1 *) wire [31:0] fifo_rd_data;
(* mark_debug = 1 *) wire fifo_rd_en;
(* mark_debug = 1 *) wire [31:0] fifo_wr_data;
(* mark_debug = 1 *) wire fifo_wr_en;
(* mark_debug = 1 *) wire ft601_clk_locked;

(* mark_debug = 1 *) wire [15:0] rd_data_count;
(* mark_debug = 1 *) wire [15:0] wr_data_count;
(* mark_debug = 1 *) wire full;
(* mark_debug = 1 *) wire empty;
(* mark_debug = 1 *) wire almost_full;
(* mark_debug = 1 *) wire fifo_almost_full;

//	====================
//	Structural Coding
//	====================
assign FT_RSTn = 1'b1;      //Do not reset
assign tp21 = ft601_clk;
//Clock Heart Beat

always @ (posedge ft601_clk, negedge reset_n)
    if(~reset_n)
        cnt_ft601_clk <= 28'b0;
    else
        cnt_ft601_clk <= cnt_ft601_clk + 1'b1;

assign led[0] = cnt_ft601_clk[27];

ft601_bist
	u_ft601_bist(
	.clk(ft601_clk),	//Available when the FT601 is activated...!
	.reset_n(reset_n),
	.bist_en(1'b0),	//btn_r : test purpose
	.bist_en_inf(1'b0),
	.ft601_wr_start(ft601_bist_en)
	);

fifo_65536x32
	u_fifo_65536x32(
	.rst(reset),
	.rd_data_count(rd_data_count[11:0]),
	.wr_data_count(wr_data_count[11:0]),

	//Write Port
	.wr_clk (ft601_clk),
	.din    (fifo_wr_data[31:0]),
	.wr_en  (fifo_wr_en),
	.full   (full),
	.almost_full(almost_full),

	//Read Port
	.rd_clk(ft601_clk),
	.dout(fifo_rd_data[31:0]),
	.rd_en(fifo_rd_en),
	.empty(empty),
	.almost_empty()
	);

//assign fifo_almost_full = almost_full;    //almost_full signal has only 1 write margin.. 
assign fifo_almost_full = (rd_data_count[11:0] >= 12'd4000) ? 1'b1 : 1'b0; 

ft601_ctrl
	u_ft601_ctrl(
//	System Clock & Reset & Config
	.reset_n(reset_n),
    .en(sw[0]),
    
//  FT601 Transmission Environment
    .ft601_1packet_size(32'd1024),

//	FIFO Read Signals
	.fifo_rd_start  (fifo_almost_full | ft601_bist_en), //Do not
	.fifo_rd_size   ({20'b0, rd_data_count[11:0]}),   //It requires byte offset (size * 4 byte will be transmitted to the external FT601)
	.fifo_rd_data   (fifo_rd_data),
	.fifo_rd_en     (fifo_rd_en),
	
	.fifo_wr_data   (fifo_wr_data),
	.fifo_wr_en     (fifo_wr_en),

//	FT601 Control Signals
	.ft601_clk(ft601_clk),
	.TXE_N(TXE_N),
	.RXF_N(RXF_N),

	.WR_N(WR_N),
	.RD_N(RD_N),
	.OE_N(OE_N),
	.SIWU_N(SIWU_N),

	.BE(BE[3:0]),
	.DATA(DATA[31:0]),
	.error1(error1),
	.error2(error2),
	.error3(error3),
	.error4(error4)
	);
	
assign led[2] = error3;
assign led[3] = full;

endmodule 

// vim:ts=2:et:sts=2:sw=2
