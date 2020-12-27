module top
(
      input         clk100_i

    , input         reset_i
//    , output        led0_r_o
//    , output        led0_g_o
//    , output        led0_b_o
//    , output        led1_r_o
//    , output        led1_g_o
//    , output        led1_b_o

//    // DDR3 SDRAM
//    , inout [15:0]  ddr3_dq
//    , inout [1:0]   ddr3_dqs_n
//    , inout [1:0]   ddr3_dqs_p
//    , output [14:0] ddr3_addr
//    , output [2:0]  ddr3_ba
//    , output        ddr3_ras_n
//    , output        ddr3_cas_n
//    , output        ddr3_we_n
//    , output        ddr3_reset_n
//    , output [0:0]  ddr3_ck_p
//    , output [0:0]  ddr3_ck_n
//    , output [0:0]  ddr3_cke
//    , output [1:0]  ddr3_dm
//    , output [0:0]  ddr3_odt

    // FTDI FT601
    , input         ftdi_clk
    , output        ftdi_rst
    , inout [31:0]  ftdi_data
    , inout [3:0]   ftdi_be
    , input         ftdi_rxf_n
    , input         ftdi_txe_n
    , output        ftdi_rd_n
    , output        ftdi_wr_n
    , output        ftdi_oe_n
    , output        ftdi_siwua

    // FTDI FT2232H
    , input prog_clko
    , inout [7:0] prog_d
    , input prog_rxen          
    , input prog_txen          
    , input  prog_spien
    , output prog_oen
    , output prog_rdn         
    , output prog_wrn         
    , output prog_siwun

    , output [1:0]  set_vadj
    , output        vadj_en
    , output [7:0]  led

//    // USB switch
//    , output        ulpi_sw_s
//    , output        ulpi_sw_oe_n
//
//    // ULPI0 Interface
//    , output        ulpi0_reset_o
//    , inout [7:0]   ulpi0_data_io
//    , output        ulpi0_stp_o
//    , input         ulpi0_nxt_i
//    , input         ulpi0_dir_i
//    , input         ulpi0_clk60_i
);

//-----------------------------------------------------------------
// Implementation
//-----------------------------------------------------------------
wire           clk0;
wire           clk1;
wire           clk_w;
wire           clk_sys_w;
wire           rst_sys_w;

wire           axi_rvalid_w;
wire           axi_wlast_w;
wire           axi_rlast_w;
wire  [  3:0]  axi_arid_w;
wire  [  1:0]  axi_rresp_w;
wire           axi_wvalid_w;
wire  [  7:0]  axi_awlen_w;
wire  [  1:0]  axi_awburst_w;
wire  [  1:0]  axi_bresp_w;
wire  [ 31:0]  axi_rdata_w;
wire           axi_arready_w;
wire           axi_awvalid_w;
wire  [ 31:0]  axi_araddr_w;
wire  [  1:0]  axi_arburst_w;
wire           axi_wready_w;
wire  [  7:0]  axi_arlen_w;
wire           axi_awready_w;
wire  [  3:0]  axi_bid_w;
wire  [  3:0]  axi_wstrb_w;
wire  [  3:0]  axi_awid_w;
wire           axi_rready_w;
wire  [  3:0]  axi_rid_w;
wire           axi_arvalid_w;
wire  [ 31:0]  axi_awaddr_w;
wire           axi_bvalid_w;
wire           axi_bready_w;
wire  [ 31:0]  axi_wdata_w;
wire           locked;

wire clk100_buffered_w;

wire rst_n = locked;
assign clk_sys_w = clk0; 

// Input buffering
BUFG IBUF_IN
(
    .I (clk100_i),
    .O (clk100_buffered_w)
);

artix7_pll
u_pll
(
    .clkref_i(clk100_buffered_w),
    .clkout0_o(clk0), // 100
    .clkout1_o(clk1), // 200
    .clkout2_o(clk_w), // 50
    .reset_i  (reset_i),
    .locked   (locked)
);


////-----------------------------------------------------------------
//// DDR
////-----------------------------------------------------------------
//usb2sniffer_ddr u_ddr
//(
//    // Inputs
//     .clk100_i(clk100_buffered_w)
//    ,.clk200_i(clk1)
//    ,.inport_awvalid_i(axi_awvalid_w)
//    ,.inport_awaddr_i(axi_awaddr_w)
//    ,.inport_awid_i(axi_awid_w)
//    ,.inport_awlen_i(axi_awlen_w)
//    ,.inport_awburst_i(axi_awburst_w)
//    ,.inport_wvalid_i(axi_wvalid_w)
//    ,.inport_wdata_i(axi_wdata_w)
//    ,.inport_wstrb_i(axi_wstrb_w)
//    ,.inport_wlast_i(axi_wlast_w)
//    ,.inport_bready_i(axi_bready_w)
//    ,.inport_arvalid_i(axi_arvalid_w)
//    ,.inport_araddr_i(axi_araddr_w)
//    ,.inport_arid_i(axi_arid_w)
//    ,.inport_arlen_i(axi_arlen_w)
//    ,.inport_arburst_i(axi_arburst_w)
//    ,.inport_rready_i(axi_rready_w)
//
//    // Outputs
//    ,.clk_out_o(clk_sys_w)
//    ,.rst_out_o(rst_sys_w)
//    ,.inport_awready_o(axi_awready_w)
//    ,.inport_wready_o(axi_wready_w)
//    ,.inport_bvalid_o(axi_bvalid_w)
//    ,.inport_bresp_o(axi_bresp_w)
//    ,.inport_bid_o(axi_bid_w)
//    ,.inport_arready_o(axi_arready_w)
//    ,.inport_rvalid_o(axi_rvalid_w)
//    ,.inport_rdata_o(axi_rdata_w)
//    ,.inport_rresp_o(axi_rresp_w)
//    ,.inport_rid_o(axi_rid_w)
//    ,.inport_rlast_o(axi_rlast_w)
//    ,.ddr_ck_p_o(ddr3_ck_p)
//    ,.ddr_ck_n_o(ddr3_ck_n)
//    ,.ddr_cke_o(ddr3_cke)
//    ,.ddr_reset_n_o(ddr3_reset_n)
//    ,.ddr_ras_n_o(ddr3_ras_n)
//    ,.ddr_cas_n_o(ddr3_cas_n)
//    ,.ddr_we_n_o(ddr3_we_n)
//    ,.ddr_ba_o(ddr3_ba)
//    ,.ddr_addr_o(ddr3_addr)
//    ,.ddr_odt_o(ddr3_odt)
//    ,.ddr_dm_o(ddr3_dm)
//    ,.ddr_dqs_p_io(ddr3_dqs_p)
//    ,.ddr_dqs_n_io(ddr3_dqs_n)
//    ,.ddr_data_io(ddr3_dq)
//);

wire [31:0] ftdi_data_in_w;
wire [31:0] ftdi_data_out_w;
wire [3:0]  ftdi_be_in_w;
wire [3:0]  ftdi_be_out_w;

wire [31:0] gpio_out_w;
wire        rst_i = ~rst_n;

wire [7:0] dpti_data_in;
wire [7:0] dpti_data_out;

wire       dpti_oen;

wire [31:0] dpti_gp_out_w;

//-----------------------------------------------------------------
// SoC
//-----------------------------------------------------------------
fpga_soc
u_top
(
    // FT601X
    .clk_sys_i(clk_sys_w)
    ,.rst_i(rst_i)

    ,.clk_ftdi_i(ftdi_clk)
    ,.ftdi_rxf_i(ftdi_rxf_n)
    ,.ftdi_txe_i(ftdi_txe_n)
    ,.ftdi_data_in_i(ftdi_data_in_w)
    ,.ftdi_be_in_i(ftdi_be_in_w)
    ,.ftdi_wrn_o(ftdi_wr_n)
    ,.ftdi_rdn_o(ftdi_rd_n)
    ,.ftdi_oen_o(ftdi_oe_n)
    ,.ftdi_data_out_o(ftdi_data_out_w)
    ,.ftdi_be_out_o(ftdi_be_out_w)

    ,.gpio_inputs_i(32'hdeadbeaf)
    ,.gpio_outputs_o(gpio_out_w)

    // FT2232H
    ,.dpti_clk_i (prog_clko)
    ,.dpti_rst_i (rst_i)
    ,.dpti_rxf_i (prog_rxen)
    ,.dpti_txe_i (prog_txen)
    ,.dpti_data_in_i (dpti_data_in)
    ,.dpti_gp_inputs_i (32'hfacebeef)
    ,.dpti_siwua_o (prog_siwun)
    ,.dpti_wrn_o (prog_wrn)
    ,.dpti_rdn_o (prog_rdn)
    ,.dpti_oen_o (dpti_oen)
    ,.dpti_data_out_o (dpti_data_out)
    ,.dpti_gp_outputs_o (dpti_gp_out_w)

    //// DDR AXI
    //,.axi_awvalid_o(axi_awvalid_w)
    //,.axi_awaddr_o(axi_awaddr_w)
    //,.axi_awid_o(axi_awid_w)
    //,.axi_awlen_o(axi_awlen_w)
    //,.axi_awburst_o(axi_awburst_w)
    //,.axi_wvalid_o(axi_wvalid_w)
    //,.axi_wdata_o(axi_wdata_w)
    //,.axi_wstrb_o(axi_wstrb_w)
    //,.axi_wlast_o(axi_wlast_w)
    //,.axi_bready_o(axi_bready_w)
    //,.axi_arvalid_o(axi_arvalid_w)
    //,.axi_araddr_o(axi_araddr_w)
    //,.axi_arid_o(axi_arid_w)
    //,.axi_arlen_o(axi_arlen_w)
    //,.axi_arburst_o(axi_arburst_w)
    //,.axi_rready_o(axi_rready_w)    
    //,.axi_awready_i(axi_awready_w)
    //,.axi_wready_i(axi_wready_w)
    //,.axi_bvalid_i(axi_bvalid_w)
    //,.axi_bresp_i(axi_bresp_w)
    //,.axi_bid_i(axi_bid_w)
    //,.axi_arready_i(axi_arready_w)
    //,.axi_rvalid_i(axi_rvalid_w)
    //,.axi_rdata_i(axi_rdata_w)
    //,.axi_rresp_i(axi_rresp_w)
    //,.axi_rid_i(axi_rid_w)
    //,.axi_rlast_i(axi_rlast_w)

    //// UTMI
    //,.utmi_data_out_i(utmi_data_out_w)
    //,.utmi_data_in_i(utmi_data_in_w)
    //,.utmi_txvalid_i(utmi_txvalid_w)
    //,.utmi_txready_i(utmi_txready_w)
    //,.utmi_rxvalid_i(utmi_rxvalid_w)
    //,.utmi_rxactive_i(utmi_rxactive_w)
    //,.utmi_rxerror_i(utmi_rxerror_w)
    //,.utmi_linestate_i(utmi_linestate_w)
    //,.utmi_op_mode_o(utmi_op_mode_w)
    //,.utmi_xcvrselect_o(utmi_xcvrselect_w)
    //,.utmi_termselect_o(utmi_termselect_w)
    //,.utmi_dppulldown_o(utmi_dppulldown_w)
    //,.utmi_dmpulldown_o(utmi_dmpulldown_w)
);

// FT601X
assign ftdi_rst       = ~rst_i;
assign ftdi_siwua     = 1'b1;

assign ftdi_data_in_w = ftdi_data;
assign ftdi_data      = ftdi_oe_n ? ftdi_data_out_w : 32'hZZZZZZZZ;

assign ftdi_be_in_w   = ftdi_be;
assign ftdi_be        = ftdi_oe_n ? ftdi_be_out_w : 4'hZ;


// DPTI
assign prog_d         = dpti_oen ? dpti_data_out : 8'hZZ;
assign dpti_data_in   = prog_d;

assign prog_oen       = dpti_oen;

///////////////////////////////////////////
// assign led = ~gpio_out_w[7:0];
assign led = ~dpti_gp_out_w[7:0];

assign set_vadj = 2'b10;
assign vadj_en  = 1'b1;

endmodule
