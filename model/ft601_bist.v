`timescale 1ns/1ps
module ft601_bist(
	input clk,
	input reset_n,
	input bist_en,     //BIST Enable -> 4KB Data Transmission
	input bist_en_inf, //BIST Enable Infinitly
	output ft601_wr_start
);

reg bist_en_d1;
reg bist_en_d2; 

always @ (posedge clk)
	bist_en_d1 <= bist_en;

always @ (posedge clk)
	bist_en_d2 <= bist_en_d1;

assign ft601_wr_start = (bist_en_d1 & ~bist_en_d2) | bist_en_inf ;

endmodule 
