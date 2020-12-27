`timescale 1ns/1ps

`define FT601_CLK_DELAY  3
`define FT601_CLK_PERIOD 10

module ft245_model(
	output reg ft_clk,
	input reset_n,

	output reg TXE_N,
	output reg RXF_N,

	input WR_N,
	input RD_N,
	input OE_N,
	input SIWU_N,
	
	inout [7:0] DATA
);

reg [11:0] fifo_cnt;

reg be_dir;
reg [3:0] be_reg;

reg data_dir_0;

reg [7:0] data_reg_0;

always begin
	ft_clk = 1'b0;
	#`FT601_CLK_DELAY;
	forever begin
	#(`FT601_CLK_PERIOD/2); ft_clk = ~ft_clk;
	end
end

always @ (posedge ft_clk, negedge reset_n)
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

always @ (posedge ft_clk, negedge reset_n)
	if(~reset_n)
		RXF_N <= 1'b1;	//
  else begin
    if (fifo_cnt >= 12'd500 && fifo_cnt <= 12'd2000) begin
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

always @ (posedge ft_clk, negedge reset_n)
begin
	if(~reset_n)
		fifo_cnt <= 12'b0;
  else begin
		fifo_cnt <= fifo_cnt + 12'd1;
  end
end

reg [7:0] data_reg;

assign DATA[ 7: 0] = be_dir ? data_reg[07:00] : 8'bzzzz_zzzz;

always @ (posedge ft_clk, negedge reset_n)
	if(~reset_n)
		be_dir <= 1'b0;
  else begin
    if (!OE_N && (fifo_cnt >= 502 && fifo_cnt <= 507)) begin
      be_dir <= 1'b1;
    end
    else begin
      be_dir <= 1'b0;
    end
  end

always @ (posedge ft_clk, negedge reset_n)
	if(~reset_n)
	begin
		data_reg <= 8'h00;
	end
  else begin
    if (!OE_N && (fifo_cnt == 502)) begin
		  data_reg <= 8'h02;
    end
    else if (!OE_N && (fifo_cnt == 503)) begin
		  data_reg <= 8'h04;
    end
    else if (!OE_N && (fifo_cnt == 504)) begin
		  data_reg <= 8'h00;
    end
    else if (!OE_N && (fifo_cnt == 505)) begin
		  data_reg <= 8'h00;
    end
    else if (!OE_N && (fifo_cnt == 506)) begin
		  data_reg <= 8'h00;
    end
    else if (!OE_N && (fifo_cnt == 507)) begin
		  data_reg <= 8'h00;
    end
    else begin
		  data_reg <= 8'h00;
    end
  end

endmodule 
