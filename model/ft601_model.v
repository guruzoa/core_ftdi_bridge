`timescale 1ns/1ps

`define FT601_CLK_DELAY  3
`define FT601_CLK_PERIOD 10

module ft601_model(
	output reg ft601_clk,
	input reset_n,

	output reg TXE_N,
	output reg RXF_N,

	input WR_N,
	input RD_N,
	input OE_N,
	input SIWU_N,
	
	inout [3:0]  BE,
	inout [31:0] DATA
);

reg [11:0] fifo_cnt;

reg be_dir;
reg [3:0] be_reg;

reg data_dir_0;
reg data_dir_1;
reg data_dir_2;
reg data_dir_3;

reg [7:0] data_reg_0;
reg [7:0] data_reg_1;
reg [7:0] data_reg_2;
reg [7:0] data_reg_3;

always begin
	ft601_clk = 1'b0;
	#`FT601_CLK_DELAY;
	forever begin
	#(`FT601_CLK_PERIOD/2); ft601_clk = ~ft601_clk;
	end
end

always @ (posedge ft601_clk, negedge reset_n)
	if(~reset_n)
		TXE_N <= 1'b1;	//FIFO idle (Available)
  //else begin
  //  if (fifo_cnt >= 12'd10 && fifo_cnt <= 12'd2000) begin
  //    TXE_N <= 1'b0;
  //  end
  //  else begin
  //    TXE_N <= 1'b1;
  //  end
  //end

always @ (posedge ft601_clk, negedge reset_n)
	if(~reset_n)
		RXF_N <= 1'b1;	//
  else begin
    if (fifo_cnt >= 12'd10 && fifo_cnt <= 12'd2000) begin
      RXF_N <= 1'b0;
    end
    else begin
      RXF_N <= 1'b1;
    end
  end

	//else if(WR_N == 1'b1)
	//	RXF_N <= 1'b1;	//End of the command... It assume that the size of the FIFO is infinite.
	//else if(fifo_cnt >= 12'd4092)
	//	RXF_N <= 1'b1;	//FIFO Full...
	//else if((WR_N == 1'b0) && (TXE_N == 1'b1))
	//	RXF_N <= 1'b0;	//when accept an command, and after the bus turn-around stage (same with TXE_N == 1)

always @ (posedge ft601_clk, negedge reset_n)
begin
	if(~reset_n)
		fifo_cnt <= 12'b0;
  else begin
		fifo_cnt <= fifo_cnt + 12'd1;
  end
end

assign BE[3:0] = be_dir ? 4'b1111 : 4'bzzzz;

reg [31:0] data_reg;

assign DATA[ 7: 0] = BE[0] ? data_reg[07:00] : 8'bzzzz_zzzz;
assign DATA[15: 8] = BE[1] ? data_reg[15:08] : 8'bzzzz_zzzz;
assign DATA[23:16] = BE[2] ? data_reg[23:16] : 8'bzzzz_zzzz;
assign DATA[31:24] = BE[3] ? data_reg[31:24] : 8'bzzzz_zzzz;

always @ (posedge ft601_clk, negedge reset_n)
	if(~reset_n)
		be_dir <= 1'b0;
  else begin
    if (!OE_N) begin
      be_dir <= 1'b1;
    end
    else begin
      be_dir <= 1'b0;
    end
  end

always @ (posedge ft601_clk, negedge reset_n)
	if(~reset_n)
	begin
		data_reg <= 32'h0000_0000;
	end
  else begin
    if (!OE_N) begin
		  data_reg <= {24'd0, 8'h41};
    end
    else begin
		  data_reg <= 32'h0000_0000;
    end

  end

endmodule 
