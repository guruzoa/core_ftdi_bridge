`timescale 1ns/100ps
//	============================
//	Created by : Sangdon Kim (2016. 11. 2)
//	Modified by : 
//	Description : 
//	Revision History : 
//	============================
module ft601_ctrl(
//	System Clock & Reset & Config
	input reset_n,
(* mark_debug = 1 *)	input en,

//	FT601 Transmission Environment
	input [31:0] ft601_1packet_size,	//It means, Internal fifo size of the FT601 IC, or 1 transmission packet size... (NOTE : size * 4 byte is transmitted to the external FT601)

//	FIFO Read Signals
(* mark_debug = 1 *)	input        fifo_rd_start,	//Start Signal... 1 PULSE 
(* mark_debug = 1 *)	input [31:0]  fifo_rd_size,	//It means, the size of data in the FPGA FIFO... (NOTE : size * 4 byte is transmitted to the external FT601)
(* mark_debug = 1 *)	input [31:0] fifo_rd_data,
(* mark_debug = 1 *)	output       fifo_rd_en,

(* mark_debug = 1 *) 	output reg [31:0] fifo_wr_data,
(* mark_debug = 1 *) 	output reg        fifo_wr_en,
 
//	FT601 Control Signals
	input ft601_clk,
(* mark_debug = 1 *) 	input TXE_N,
(* mark_debug = 1 *) 	input RXF_N,

(* mark_debug = 1 *) 	output reg WR_N,
 	output RD_N,
 	output OE_N,
 	output SIWU_N,
	
(* mark_debug = 1 *)  	inout [3:0]  BE,
(* mark_debug = 1 *)  	inout [31:0] DATA,
	
(* mark_debug = 1 *) 	output reg error1,	//It means, FT601 Write Start but TX Channel 0 is not valid -> FT601 is not available now.
(* mark_debug = 1 *) 	output reg error2,	//It menas, TXE_N is not busy after the command is asserted -> FT601 is hang or no response
(* mark_debug = 1 *) 	output reg error3,	//It menas, RXF_N is not active after bus turn-around phase -> FT601 FIFO is Full
(* mark_debug = 1 *) 	output reg error4	//It means, FT601 receives 1KB (or 4KB) of data & State is not full. There are more space to available.
);
//	===========================
//	Declaration of parameters...
//	===========================
parameter idle				= 4'b0000;
parameter write_command			= 4'b0001;
parameter write_bta_front		= 4'b0010;	//Write Bus Turn-around
parameter write_data			= 4'b0011;
parameter write_data_complete1		= 4'b0100;
parameter write_data_complete2		= 4'b0101;
parameter write_bta_back		= 4'b0110;
parameter ft601_state_check		= 4'b0111;

parameter read_command			= 4'b1000;
parameter read_bta_1			= 4'b1001;
parameter read_bta_2			= 4'b1010;
parameter read_data			= 4'b1011;

//	===========================
//	Declaration of Reg, Wires...
//	===========================
wire clk;

(* mark_debug = 1 *)  reg [3:0] state;
 reg [3:0] next_state;

(* mark_debug = 1 *)  reg be_dir;
(* mark_debug = 1 *)  reg [3:0] be_reg;
	
(* mark_debug = 1 *)  reg data_dir_0;
(* mark_debug = 1 *)  reg data_dir_1;
(* mark_debug = 1 *)  reg data_dir_2;
(* mark_debug = 1 *)  reg data_dir_3;

(* mark_debug = 1 *)reg [7:0] data_reg_0;
(* mark_debug = 1 *)reg [7:0] data_reg_1;
(* mark_debug = 1 *)reg [7:0] data_reg_2;
(* mark_debug = 1 *)reg [7:0] data_reg_3;


(* mark_debug = 1 *) reg packet_complete;
(* mark_debug = 1 *) reg [31:0] fifo_rd_cnt;
(* mark_debug = 1 *) reg fifo_data_valid;

(* mark_debug = 1 *) reg [31:0] ft601_1packet_size_reg;
(* mark_debug = 1 *) reg [31:0] fifo_rd_size_reg;
(* mark_debug = 1 *) wire ft601_busy;

reg RXF_N_reg;
(* mark_debug = 1 *) wire RXF_N_rising;

assign clk = ft601_clk;

assign RD_N = 1'b1;	//Does not use in FT600 Mode
assign OE_N = 1'b1;	//Does not use in FT600 Mode
assign SIWU_N = 1'b1;	//Reserved. Assert HIGH in normal operation

//	===========================
//	Structural Coding
//	===========================

always @ (posedge clk, negedge reset_n)
	if(~reset_n)
		ft601_1packet_size_reg <= 32'b0;
	else if(fifo_rd_start & ~ft601_busy)			//Busy state adding : 2016.12.13
		ft601_1packet_size_reg <= ft601_1packet_size;

always @ (posedge clk, negedge reset_n)
begin
	if(~reset_n)
	  fifo_rd_size_reg <= 32'b0;
	else if (fifo_rd_start & ~ft601_busy) begin		//Busy state adding : 2016.12.13
	  fifo_rd_size_reg <= fifo_rd_size;
	end
  	else if (packet_complete == 1'b1)
	  if(fifo_rd_size_reg <= ft601_1packet_size_reg)
		  fifo_rd_size_reg <= 32'b0;
	  else
		  fifo_rd_size_reg <= fifo_rd_size_reg - ft601_1packet_size_reg;
end

always @ (*)
	if(~reset_n)
		packet_complete = 1'b0;
	else
		if((fifo_rd_cnt == fifo_rd_size_reg) || (fifo_rd_cnt == ft601_1packet_size_reg))
			packet_complete = 1'b1;
		else
			packet_complete = 1'b0;

assign ft601_busy = (fifo_rd_size_reg == 32'b0) ? 1'b0 : 1'b1;	//Busy state adding : 2016.12.13

//  State Machine
always @ (posedge clk, negedge reset_n)
	if(~reset_n)
		state <= idle;
	else
		state <= next_state;

always @ (*)
	if(~reset_n)
		next_state <= idle;
	else
		case(state)
		idle : 
//			if((fifo_rd_start == 1'b1) && (DATA[8] == 1'b0))	//Write Start when the TX Channel 0 is available
//				next_state <= write_command;
			if((fifo_rd_size_reg[31:0] != 32'd0) && (DATA[8] == 1'b0))
				next_state <= write_command;
			else if((fifo_rd_size_reg[31:0] == 32'b0) && (DATA[12] == 1'b0) && (en == 1'b1))	//Read Start when the no write state and RX Channel 0 is available
				next_state <= read_command;
			else
				next_state <= state;

		write_command	: next_state <= write_bta_front;

		write_bta_front	: next_state <= write_data;

		write_data : 
			if(packet_complete == 1'b1)
				next_state <= write_data_complete1;
			else
				next_state <= state;

		write_data_complete1 : next_state <= write_bta_back;

		write_bta_back : next_state <= ft601_state_check;

		ft601_state_check : next_state <= idle;

		read_command : next_state <= read_bta_1;
		read_bta_1 : next_state <= read_bta_2;
		read_bta_2 : next_state <= read_data;
		read_data : 
			if(RXF_N_rising)
				next_state <= idle;
			else
				next_state <= state;
		default : next_state <= idle;
		endcase

//	===========================
//	Read data from the FIFO
//	===========================
	//It suppose that 1 latency clock for an read operation
always @ (posedge clk, negedge reset_n)
	if(~reset_n)
		fifo_rd_cnt <= 32'b0;
	else if((fifo_rd_cnt == fifo_rd_size_reg) || (fifo_rd_cnt == ft601_1packet_size_reg))
	    fifo_rd_cnt <= 32'b0;
	else if((state == write_data) || (state == write_bta_front) || (state == write_command))
		fifo_rd_cnt <= fifo_rd_cnt + 1'd1;

assign fifo_rd_en = |(fifo_rd_cnt);

always @ (posedge clk, negedge reset_n)
	if(~reset_n)
	  fifo_data_valid <= 1'b0;
	else if(fifo_rd_en == 1'b1)
	  fifo_data_valid <= 1'b1;
	else
	  fifo_data_valid <= 1'b0;

//	===========================
//	Read data from the FT601
//	===========================
always @ (posedge clk)
	RXF_N_reg <= RXF_N;

assign RXF_N_rising = RXF_N & ~RXF_N_reg;

always @ (posedge clk, negedge reset_n)
	if(~reset_n)
		fifo_wr_en <= 1'b0;
	else if((state == read_data) && (RXF_N == 1'b0) && (|(BE[3:0])))
		fifo_wr_en <= 1'b1;
	else
		fifo_wr_en <= 1'b0;

always @ (posedge clk, negedge reset_n)
	if(~reset_n)
		fifo_wr_data[7:0] <= 8'b0;
	else if((state == read_data) && (RXF_N == 1'b0) && (BE[0] == 1'b1))
		fifo_wr_data[7:0] <= DATA[7:0];

always @ (posedge clk, negedge reset_n)
	if(~reset_n)
		fifo_wr_data[15:8] <= 8'b0;
	else if((state == read_data) && (RXF_N == 1'b0) && (BE[1] == 1'b1))
		fifo_wr_data[15:8] <= DATA[15:8];


always @ (posedge clk, negedge reset_n)
	if(~reset_n)
		fifo_wr_data[23:16] <= 8'b0;
	else if((state == read_data) && (RXF_N == 1'b0) && (BE[2] == 1'b1))
		fifo_wr_data[23:16] <= DATA[23:16];


always @ (posedge clk, negedge reset_n)
	if(~reset_n)
		fifo_wr_data[31:24] <= 8'b0;
	else if((state == read_data) && (RXF_N == 1'b0) && (BE[3] == 1'b1))
		fifo_wr_data[31:24] <= DATA[31:24];

//	===========================
//	Output Signals...
//	===========================
always @ (posedge clk, negedge reset_n)
	if(~reset_n)
		WR_N <= 1'b1;
	else if(state == write_bta_back)	//Write operation finish
		WR_N <= 1'b1;
	else if((state == read_data) && (RXF_N_rising == 1'b1))	//Read operation finish
		WR_N <= 1'b1;
	else if(state == write_command)
		WR_N <= 1'b0;
	else if(state == read_command)
		WR_N <= 1'b0;

assign BE[3:0] = be_dir ? be_reg[3:0] : 4'bzzzz;

always @ (posedge clk, negedge reset_n)
	if(~reset_n)
		be_dir <= 1'b1;	//Output when idle state
	else
		case(state)
		write_command : be_dir <= 1'b1;
		read_bta_2 : be_dir <= 1'b0;
		read_data : if(RXF_N_rising == 1'b1)
				be_dir <= 1'b1;			
		default : ;	//Keep the previous value
		endcase

always @ (posedge clk, negedge reset_n)
	if(~reset_n)
		be_reg <= 4'b1111;
	else
		case(state)
		idle : be_reg <= 4'b1111;
		write_command : be_reg <= 4'b0001;	//Write command
		write_data : be_reg <= 4'b1111;
		read_command : be_reg <= 4'b0000;	//Read command
		default : ;	//Keep the previous value
		endcase

assign DATA[7 :0 ] = data_dir_0 ? data_reg_0[7:0] : 8'bzzzz_zzzz;
assign DATA[15:8 ] = data_dir_1 ? data_reg_1[7:0] : 8'bzzzz_zzzz;
assign DATA[23:16] = data_dir_2 ? data_reg_2[7:0] : 8'bzzzz_zzzz;
assign DATA[31:24] = data_dir_3 ? data_reg_3[7:0] : 8'bzzzz_zzzz;

always @ (posedge clk, negedge reset_n)
	if(~reset_n)
	begin
		data_dir_0 <= 1'b1;
		data_dir_1 <= 1'b0;	//Monitoring the status of FT601
		data_dir_2 <= 1'b1;
		data_dir_3 <= 1'b1;
	end
	else
		case(state)
		idle : begin
			data_dir_0 <= 1'b1;
			data_dir_1 <= 1'b0;	//Monitoring the status of FT601
			data_dir_2 <= 1'b1;
			data_dir_3 <= 1'b1;
		end
		write_data : begin
			data_dir_0 <= 1'b1;
			data_dir_1 <= 1'b1;
			data_dir_2 <= 1'b1;
			data_dir_3 <= 1'b1;
		end
		write_bta_back : begin	//Input mode because the next state is "Write Bus Turn-around".
			data_dir_0 <= 1'b1;
			data_dir_1 <= 1'b0;	//Monitoring the status of FT601
			data_dir_2 <= 1'b1;
			data_dir_3 <= 1'b1;
		end
		read_bta_2 : begin
			data_dir_0 <= 1'b0;
			data_dir_1 <= 1'b0;
			data_dir_2 <= 1'b0;
			data_dir_3 <= 1'b0;
		end
		read_data : 
			if(RXF_N_rising == 1'b1)
			begin
				data_dir_0 <= 1'b1;
				data_dir_1 <= 1'b0;	//Monitoring the status of FT601
				data_dir_2 <= 1'b1;
				data_dir_3 <= 1'b1;
			end
		default : ;	//Keep the previous value
		endcase

always @ (posedge clk, negedge reset_n)
	if(~reset_n) begin
		data_reg_0 <= 8'b1111_1111;
		data_reg_1 <= 8'b1111_1111;	//Don't care....
		data_reg_2 <= 8'b1111_1111;
		data_reg_3 <= 8'b1111_1111;
	end
	else
		case(state)
		idle : begin
			data_reg_0 <= 8'b1111_1111;
			data_reg_1 <= 8'b1111_1111;	//Don't care....
			data_reg_2 <= 8'b1111_1111;
			data_reg_3 <= 8'b1111_1111;
		end
		write_command : begin
			data_reg_0 <= 8'b0000_0001;	//Write Channel 1
			data_reg_1 <= 8'b1111_1111;	//Don't care....
			data_reg_2 <= 8'b1111_1111;
			data_reg_3 <= 8'b1111_1111;
		end
		write_data : begin
			data_reg_0 <= fifo_rd_data[7 :0 ];
			data_reg_1 <= fifo_rd_data[15:8 ];
			data_reg_2 <= fifo_rd_data[23:16];
			data_reg_3 <= fifo_rd_data[31:24];
		end
		write_data_complete1 : begin		//Because of the Output F/F stage...
			data_reg_0 <= fifo_rd_data[7 :0 ];
			data_reg_1 <= fifo_rd_data[15:8 ];
			data_reg_2 <= fifo_rd_data[23:16];
			data_reg_3 <= fifo_rd_data[31:24];
		end
		write_bta_back	: begin
			data_reg_0 <= 8'b1111_1111;
			data_reg_1 <= 8'b1111_1111;	//Don't care....
			data_reg_2 <= 8'b1111_1111;
			data_reg_3 <= 8'b1111_1111;
		end
		read_command : begin 
			data_reg_0 <= 8'b0000_0001;	//Read Channel 1
			data_reg_1 <= 8'b1111_1111;	//Don't care....
			data_reg_2 <= 8'b1111_1111;
			data_reg_3 <= 8'b1111_1111;
		end

		default : ;	//Keep the previous value
		endcase

always @ (posedge clk, negedge reset_n)
	if(~reset_n)
		error1 <= 1'b0;
	else if((fifo_rd_start == 1'b1) && (DATA[8] != 1'b0))
		error1 <= 1'b1;

always @ (posedge clk, negedge reset_n)
	if(~reset_n)
		error2 <= 1'b0;
	else if((state == write_data) && (TXE_N != 1'b1))	//TXE_N is goes to high when WR_N is asserted, but command has 1 clock delay because of F/F
		error2 <= 1'b1;

always @ (posedge clk, negedge reset_n)
	if(~reset_n)
		error3 <= 1'b0;
	else if((data_dir_1 == 1'b1) && (be_dir == 1'b1) && (RXF_N != 1'b0))	//Output mode, but RXF_N is not active -> FT601 FIFO is Full
		error3 <= 1'b1;

always @ (posedge clk, negedge reset_n)
	if(~reset_n)
		error4 <= 1'b0;
	else if((state == ft601_state_check) && (RXF_N != 1'b1))
		error4 <= 1'b1;
		

endmodule 
