`ifndef WIDTH_AD
`define WIDTH_AD   32 // address width
`endif
`ifndef WIDTH_DA
`define WIDTH_DA   32 // data width
`endif
`ifndef ADDR_LENGTH
`define ADDR_LENGTH 12
`endif

module fpga_soc
//-----------------------------------------------------------------
// Params
//-----------------------------------------------------------------
#(
     parameter CLK_FREQ         = 60000000
)
//-----------------------------------------------------------------
// Ports
//-----------------------------------------------------------------
(
    // Inputs
     input           clk_ftdi_i
    ,input           clk_sys_i
    //,input           clk_usb_i
    ,input           rst_i
    //,input           axi_awready_i
    //,input           axi_wready_i
    //,input           axi_bvalid_i
    //,input  [  1:0]  axi_bresp_i
    //,input  [  3:0]  axi_bid_i
    //,input           axi_arready_i
    //,input           axi_rvalid_i
    //,input  [ 31:0]  axi_rdata_i
    //,input  [  1:0]  axi_rresp_i
    //,input  [  3:0]  axi_rid_i
    //,input           axi_rlast_i
    ,input           ftdi_rxf_i
    ,input           ftdi_txe_i
    ,input  [ 31:0]  ftdi_data_in_i
    ,input  [  3:0]  ftdi_be_in_i
    ,input  [ 31:0]  gpio_inputs_i
    //,input  [  7:0]  utmi_data_out_i
    //,input  [  7:0]  utmi_data_in_i
    //,input           utmi_txvalid_i
    //,input           utmi_txready_i
    //,input           utmi_rxvalid_i
    //,input           utmi_rxactive_i
    //,input           utmi_rxerror_i
    //,input  [  1:0]  utmi_linestate_i

    ,input             dpti_clk_i
    ,input             dpti_rst_i
    ,input             dpti_rxf_i
    ,input             dpti_txe_i
    ,input  [7:0]      dpti_data_in_i
    ,input  [31:0]     dpti_gp_inputs_i

    // Outputs
    //,output          axi_awvalid_o
    //,output [ 31:0]  axi_awaddr_o
    //,output [  3:0]  axi_awid_o
    //,output [  7:0]  axi_awlen_o
    //,output [  1:0]  axi_awburst_o
    //,output          axi_wvalid_o
    //,output [ 31:0]  axi_wdata_o
    //,output [  3:0]  axi_wstrb_o
    //,output          axi_wlast_o
    //,output          axi_bready_o
    //,output          axi_arvalid_o
    //,output [ 31:0]  axi_araddr_o
    //,output [  3:0]  axi_arid_o
    //,output [  7:0]  axi_arlen_o
    //,output [  1:0]  axi_arburst_o
    //,output          axi_rready_o
    ,output          ftdi_wrn_o
    ,output          ftdi_rdn_o
    ,output          ftdi_oen_o
    ,output [ 31:0]  ftdi_data_out_o
    ,output [  3:0]  ftdi_be_out_o
    ,output [ 31:0]  gpio_outputs_o

    ,output           dpti_siwua_o
    ,output           dpti_wrn_o
    ,output           dpti_rdn_o
    ,output           dpti_oen_o
    ,output [7:0]     dpti_data_out_o
    ,output [31:0]    dpti_gp_outputs_o

    //,output [  1:0]  utmi_op_mode_o
    //,output [  1:0]  utmi_xcvrselect_o
    //,output          utmi_termselect_o
    //,output          utmi_dppulldown_o
    //,output          utmi_dmpulldown_o
);

wire           axi_sys_awvalid_w;
//wire           axi_arb_out_arvalid_w;
wire  [ 31:0]  axi_sys_araddr_w;
wire           axi_usb_rready_w;
wire           axi_cfg_wvalid_w;
wire           axi_dbg_ftdi_awready_w;
//wire           axi_arb_out_rready_w;
//wire  [  7:0]  axi_arb_out_arlen_w;
wire  [ 31:0]  axi_cfg_wdata_w;
//wire  [  3:0]  axi_arb_out_arid_w;
wire           axi_ftdi_rready_w;
wire           axi_ftdi_bvalid_w;
//wire  [  3:0]  axi_arb_out_bid_w;
wire  [  1:0]  axi_sys_awburst_w;
wire           axi_usb_arvalid_w;
wire  [ 31:0]  axi_usb_araddr_w;
wire  [  7:0]  axi_sys_arlen_w;
wire           axi_ftdi_rlast_w;
wire           axi_usb_awready_w;
//wire           axi_arb_out_wready_w;
wire  [  1:0]  axi_ftdi_rresp_w;
wire           axi_sys_arvalid_w;
wire           axi_dbg_ftdi_arready_w;
//wire           axi_arb_out_bready_w;
wire  [  7:0]  axi_sys_awlen_w;
wire  [  1:0]  axi_dbg_ftdi_awburst_w;
wire  [ 31:0]  axi_sys_awaddr_w;
wire  [  1:0]  axi_sys_arburst_w;
wire           axi_arb_out_wlast_w;
wire  [  3:0]  axi_usb_bid_w;
wire  [ 31:0]  axi_cfg_rdata_w;
wire  [  7:0]  axi_arb_out_awlen_w;
wire  [  3:0]  axi_cfg_wstrb_w;
wire           axi_dbg_ftdi_arvalid_w;
wire           axi_ftdi_wlast_w;
wire  [ 31:0]  axi_cfg_araddr_w;
wire           axi_ftdi_bready_w;
wire  [  1:0]  axi_arb_out_awburst_w;
wire           axi_usb_arready_w;
wire  [ 31:0]  axi_ftdi_rdata_w;
wire           axi_usb_awvalid_w;
wire  [  3:0]  axi_arb_out_rid_w;
wire  [  3:0]  axi_dbg_ftdi_awid_w;
wire  [  1:0]  axi_usb_rresp_w;
wire  [ 31:0]  axi_dbg_ftdi_wdata_w;
wire  [ 31:0]  axi_ftdi_awaddr_w;
wire  [  1:0]  axi_usb_bresp_w;
wire           axi_cfg_bready_w;
wire  [  3:0]  axi_sys_rid_w;
wire  [ 31:0]  axi_dbg_ftdi_awaddr_w;
wire  [  7:0]  axi_dbg_ftdi_awlen_w;
wire           axi_sys_rlast_w;
wire           axi_sys_wready_w;
wire  [  3:0]  axi_sys_arid_w;
wire  [  3:0]  axi_usb_awid_w;
wire           axi_ftdi_awready_w;
wire           axi_cfg_awvalid_w;
wire           axi_cfg_wready_w;
wire  [  1:0]  axi_dbg_ftdi_rresp_w;
wire           axi_sys_awready_w;
wire           axi_sys_bready_w;
wire  [ 31:0]  axi_arb_out_araddr_w;
wire           axi_sys_arready_w;
wire  [  3:0]  axi_dbg_ftdi_rid_w;
wire  [  1:0]  axi_ftdi_awburst_w;
wire           axi_usb_wlast_w;
wire           axi_ftdi_awvalid_w;
wire  [  3:0]  axi_dbg_ftdi_wstrb_w;
wire  [  7:0]  axi_ftdi_awlen_w;
wire  [  1:0]  axi_arb_out_rresp_w;
wire  [  1:0]  axi_usb_awburst_w;
wire  [  3:0]  axi_usb_rid_w;
wire           axi_arb_out_arready_w;
wire           axi_arb_out_rlast_w;
wire           axi_usb_bready_w;
wire           axi_dbg_ftdi_bvalid_w;
wire  [  3:0]  axi_usb_wstrb_w;
wire  [ 31:0]  axi_sys_rdata_w;
wire  [  1:0]  axi_dbg_ftdi_bresp_w;
wire           axi_arb_out_rvalid_w;
wire           axi_cfg_rready_w;
wire  [  7:0]  axi_usb_arlen_w;
wire  [ 31:0]  axi_cfg_awaddr_w;
wire           axi_sys_rvalid_w;
wire  [ 31:0]  axi_dbg_ftdi_araddr_w;
wire           axi_arb_out_awready_w;
wire           axi_dbg_ftdi_rready_w;
wire           axi_usb_bvalid_w;
wire           axi_cfg_arvalid_w;
wire           axi_dbg_ftdi_rvalid_w;
wire  [  3:0]  axi_arb_out_wstrb_w;
wire           axi_dbg_ftdi_wlast_w;
wire  [  3:0]  axi_sys_wstrb_w;
wire  [  1:0]  axi_sys_rresp_w;
wire  [  7:0]  axi_usb_awlen_w;
wire  [  1:0]  axi_sys_bresp_w;
wire  [  3:0]  axi_ftdi_bid_w;
wire  [  3:0]  axi_usb_arid_w;
wire  [  3:0]  axi_dbg_ftdi_bid_w;
wire  [  1:0]  axi_ftdi_bresp_w;
wire  [  3:0]  axi_dbg_ftdi_arid_w;
wire           axi_ftdi_arready_w;
wire           axi_arb_out_wvalid_w;
wire  [ 31:0]  axi_arb_out_wdata_w;
wire  [  1:0]  axi_arb_out_bresp_w;
wire           axi_ftdi_rvalid_w;
wire  [ 31:0]  axi_usb_rdata_w;
wire           axi_ftdi_wvalid_w;
wire  [  3:0]  axi_sys_awid_w;
wire  [ 31:0]  axi_ftdi_araddr_w;
wire  [ 31:0]  axi_ftdi_wdata_w;
wire  [  1:0]  axi_arb_out_arburst_w;
wire  [  1:0]  axi_ftdi_arburst_w;
wire  [  3:0]  axi_ftdi_rid_w;
wire           axi_ftdi_arvalid_w;
wire  [  1:0]  axi_dbg_ftdi_arburst_w;
wire           axi_cfg_bvalid_w;
wire  [ 31:0]  axi_usb_awaddr_w;
wire           axi_arb_out_bvalid_w;
wire  [  7:0]  axi_ftdi_arlen_w;
wire           axi_cfg_rvalid_w;
wire           axi_dbg_ftdi_wready_w;
wire           axi_dbg_ftdi_rlast_w;
wire           axi_cfg_arready_w;
wire           axi_sys_wlast_w;
wire           axi_arb_out_awvalid_w;
wire           axi_ftdi_wready_w;
wire           axi_sys_rready_w;
wire  [  7:0]  axi_dbg_ftdi_arlen_w;
wire           axi_dbg_ftdi_awvalid_w;
wire  [ 31:0]  axi_usb_wdata_w;
wire  [  3:0]  axi_arb_out_awid_w;
wire           axi_usb_wready_w;
wire           axi_sys_bvalid_w;
wire           axi_dbg_ftdi_wvalid_w;
wire           axi_dbg_ftdi_bready_w;
wire           axi_usb_rvalid_w;
wire  [  3:0]  axi_ftdi_arid_w;
wire  [ 31:0]  axi_arb_out_awaddr_w;
wire  [  1:0]  axi_usb_arburst_w;
wire  [ 31:0]  axi_arb_out_rdata_w;
wire           axi_usb_rlast_w;
wire  [  3:0]  axi_sys_bid_w;
wire  [ 31:0]  axi_sys_wdata_w;
wire  [  1:0]  axi_cfg_rresp_w;
wire           axi_sys_wvalid_w;
wire           axi_cfg_awready_w;
wire  [ 31:0]  axi_dbg_ftdi_rdata_w;
wire  [  3:0]  axi_ftdi_awid_w;
wire  [  1:0]  axi_cfg_bresp_w;
wire  [  3:0]  axi_ftdi_wstrb_w;
wire           axi_usb_wvalid_w;

   //---------------------------------------------------------
   localparam WIDTH_CID   = 0    // Channel ID width in bits; it should be 0 since no AXI matrix
            , WIDTH_ID    = 4    // ID width in bits
            , WIDTH_AD    =`WIDTH_AD    // address width
            , WIDTH_DA    =`WIDTH_DA    // data width
            , WIDTH_DS    =(WIDTH_DA/8)  // data strobe width
            , WIDTH_SID   =WIDTH_CID+WIDTH_ID // ID for slave
            , WIDTH_AWUSER=1  // Write-address user path
            , WIDTH_WUSER =1  // Write-data user path
            , WIDTH_BUSER =1  // Write-response user path
            , WIDTH_ARUSER=1  // read-address user path
            , WIDTH_RUSER =1; // read-data user path
   localparam ADDR_BASE0  =32'h0000_0000
            , ADDR_LENGTH0=`ADDR_LENGTH
            , ADDR_BASE1  =(ADDR_BASE0+(1<<ADDR_LENGTH0))
            , ADDR_LENGTH1=`ADDR_LENGTH;
   //---------------------------------------------------------

   wire  [WIDTH_CID-1:0]     MID        ;
   wire  [WIDTH_ID-1:0]      AWID       ;
   wire  [WIDTH_AD-1:0]      AWADDR     ;
   `ifdef AMBA_AXI4
   wire  [ 7:0]              AWLEN      ;
   wire                      AWLOCK     = 1'b0;
   `else
   wire  [ 3:0]              AWLEN      ;
   wire  [ 1:0]              AWLOCK     ;
   `endif
   wire  [ 2:0]              AWSIZE     = 3'd2;
   wire  [ 1:0]              AWBURST    ;
   `ifdef AMBA_AXI_CACHE
   wire  [ 3:0]              AWCACHE    ;
   `endif
   `ifdef AMBA_AXI_PROT
   wire  [ 2:0]              AWPROT     ;
   `endif
   wire                      AWVALID    ;
   wire                      AWREADY    ;
   `ifdef AMBA_AXI4
   wire  [ 3:0]              AWQOS      = 4'd0;
   wire  [ 3:0]              AWREGION   = 4'd0;
   `endif
   `ifdef AMBA_AXI_AWUSER
   wire  [WIDTH_AWUSER-1:0]  AWUSER     ;
   `endif
   wire  [WIDTH_ID-1:0]      WID        = 4'd0;
   wire  [WIDTH_DA-1:0]      WDATA      ;
   wire  [WIDTH_DS-1:0]      WSTRB      ;
   wire                      WLAST      ;
   wire                      WVALID     ;
   wire                      WREADY     ;
   `ifdef AMBA_AXI_WUSER
   wire  [WIDTH_WUSER-1:0]   WUSER      ;
   `endif
   wire  [WIDTH_ID-1:0]      BID        ;
   wire  [ 1:0]              BRESP      ;
   wire                      BVALID     ;
   wire                      BREADY     ;
   `ifdef AMBA_AXI_BUSER
   wire  [WIDTH_BUSER-1:0]   BUSER      ;
   `endif
   wire  [WIDTH_ID-1:0]      ARID       ;
   wire  [WIDTH_AD-1:0]      ARADDR     ;
   `ifdef AMBA_AXI4
   wire  [ 7:0]              ARLEN      ;
   wire                      ARLOCK     = 1'b0;
   `else
   wire  [ 3:0]              ARLEN      ;
   wire  [ 1:0]              ARLOCK     ;
   `endif
   wire  [ 2:0]              ARSIZE     = 3'd2;
   wire  [ 1:0]              ARBURST    ;
   `ifdef AMBA_AXI_CACHE
   wire  [ 3:0]              ARCACHE    ;
   `endif
   `ifdef AMBA_AXI_PROT
   wire  [ 2:0]              ARPROT     ;
   `endif
   wire                      ARVALID    ;
   wire                      ARREADY    ;
   `ifdef AMBA_AXI4
   wire  [ 3:0]              ARQOS      = 4'd0;
   wire  [ 3:0]              ARREGION   = 4'd0;
   `endif
   `ifdef AMBA_AXI_ARUSER
   wire  [WIDTH_ARUSER-1:0]  ARUSER     ;
   `endif
   wire  [WIDTH_ID-1:0]      RID        ;
   wire  [WIDTH_DA-1:0]      RDATA      ;
   wire  [ 1:0]              RRESP      ;
   wire                      RLAST      ;
   wire                      RVALID     ;
   wire                      RREADY     ;
   `ifdef AMBA_AXI_RUSER
   wire  [WIDTH_RUSER-1:0]   RUSER      ;
   `endif

   wire  ACLK = clk_sys_i;
   wire  ARESETn = ~rst_i;


//axi4_cdc
//u_cdc_usb_ddr
//(
//    // Inputs
//     .wr_clk_i(clk_usb_i)
//    ,.wr_rst_i(rst_i)
//    ,.inport_awvalid_i(axi_arb_out_awvalid_w)
//    ,.inport_awaddr_i(axi_arb_out_awaddr_w)
//    ,.inport_awid_i(axi_arb_out_awid_w)
//    ,.inport_awlen_i(axi_arb_out_awlen_w)
//    ,.inport_awburst_i(axi_arb_out_awburst_w)
//    ,.inport_wvalid_i(axi_arb_out_wvalid_w)
//    ,.inport_wdata_i(axi_arb_out_wdata_w)
//    ,.inport_wstrb_i(axi_arb_out_wstrb_w)
//    ,.inport_wlast_i(axi_arb_out_wlast_w)
//    ,.inport_bready_i(axi_arb_out_bready_w)
//    ,.inport_arvalid_i(axi_arb_out_arvalid_w)
//    ,.inport_araddr_i(axi_arb_out_araddr_w)
//    ,.inport_arid_i(axi_arb_out_arid_w)
//    ,.inport_arlen_i(axi_arb_out_arlen_w)
//    ,.inport_arburst_i(axi_arb_out_arburst_w)
//    ,.inport_rready_i(axi_arb_out_rready_w)
//    ,.rd_clk_i(clk_sys_i)
//    ,.rd_rst_i(rst_i)
//    ,.outport_awready_i(axi_awready_i)
//    ,.outport_wready_i(axi_wready_i)
//    ,.outport_bvalid_i(axi_bvalid_i)
//    ,.outport_bresp_i(axi_bresp_i)
//    ,.outport_bid_i(axi_bid_i)
//    ,.outport_arready_i(axi_arready_i)
//    ,.outport_rvalid_i(axi_rvalid_i)
//    ,.outport_rdata_i(axi_rdata_i)
//    ,.outport_rresp_i(axi_rresp_i)
//    ,.outport_rid_i(axi_rid_i)
//    ,.outport_rlast_i(axi_rlast_i)
//
//    // Outputs
//    ,.inport_awready_o(axi_arb_out_awready_w)
//    ,.inport_wready_o(axi_arb_out_wready_w)
//    ,.inport_bvalid_o(axi_arb_out_bvalid_w)
//    ,.inport_bresp_o(axi_arb_out_bresp_w)
//    ,.inport_bid_o(axi_arb_out_bid_w)
//    ,.inport_arready_o(axi_arb_out_arready_w)
//    ,.inport_rvalid_o(axi_arb_out_rvalid_w)
//    ,.inport_rdata_o(axi_arb_out_rdata_w)
//    ,.inport_rresp_o(axi_arb_out_rresp_w)
//    ,.inport_rid_o(axi_arb_out_rid_w)
//    ,.inport_rlast_o(axi_arb_out_rlast_w)
//    ,.outport_awvalid_o(axi_awvalid_o)
//    ,.outport_awaddr_o(axi_awaddr_o)
//    ,.outport_awid_o(axi_awid_o)
//    ,.outport_awlen_o(axi_awlen_o)
//    ,.outport_awburst_o(axi_awburst_o)
//    ,.outport_wvalid_o(axi_wvalid_o)
//    ,.outport_wdata_o(axi_wdata_o)
//    ,.outport_wstrb_o(axi_wstrb_o)
//    ,.outport_wlast_o(axi_wlast_o)
//    ,.outport_bready_o(axi_bready_o)
//    ,.outport_arvalid_o(axi_arvalid_o)
//    ,.outport_araddr_o(axi_araddr_o)
//    ,.outport_arid_o(axi_arid_o)
//    ,.outport_arlen_o(axi_arlen_o)
//    ,.outport_arburst_o(axi_arburst_o)
//    ,.outport_rready_o(axi_rready_o)
//);
//
//
//axi4_lite_tap
//u_dist
//(
//    // Inputs
//     .clk_i(clk_usb_i)
//    ,.rst_i(rst_i)
//    ,.inport_awvalid_i(axi_dbg_usb_awvalid_w)
//    ,.inport_awaddr_i(axi_dbg_usb_awaddr_w)
//    ,.inport_awid_i(axi_dbg_usb_awid_w)
//    ,.inport_awlen_i(axi_dbg_usb_awlen_w)
//    ,.inport_awburst_i(axi_dbg_usb_awburst_w)
//    ,.inport_wvalid_i(axi_dbg_usb_wvalid_w)
//    ,.inport_wdata_i(axi_dbg_usb_wdata_w)
//    ,.inport_wstrb_i(axi_dbg_usb_wstrb_w)
//    ,.inport_wlast_i(axi_dbg_usb_wlast_w)
//    ,.inport_bready_i(axi_dbg_usb_bready_w)
//    ,.inport_arvalid_i(axi_dbg_usb_arvalid_w)
//    ,.inport_araddr_i(axi_dbg_usb_araddr_w)
//    ,.inport_arid_i(axi_dbg_usb_arid_w)
//    ,.inport_arlen_i(axi_dbg_usb_arlen_w)
//    ,.inport_arburst_i(axi_dbg_usb_arburst_w)
//    ,.inport_rready_i(axi_dbg_usb_rready_w)
//    ,.outport_awready_i(axi_ftdi_awready_w)
//    ,.outport_wready_i(axi_ftdi_wready_w)
//    ,.outport_bvalid_i(axi_ftdi_bvalid_w)
//    ,.outport_bresp_i(axi_ftdi_bresp_w)
//    ,.outport_bid_i(axi_ftdi_bid_w)
//    ,.outport_arready_i(axi_ftdi_arready_w)
//    ,.outport_rvalid_i(axi_ftdi_rvalid_w)
//    ,.outport_rdata_i(axi_ftdi_rdata_w)
//    ,.outport_rresp_i(axi_ftdi_rresp_w)
//    ,.outport_rid_i(axi_ftdi_rid_w)
//    ,.outport_rlast_i(axi_ftdi_rlast_w)
//    ,.outport_peripheral0_awready_i(axi_cfg_awready_w)
//    ,.outport_peripheral0_wready_i(axi_cfg_wready_w)
//    ,.outport_peripheral0_bvalid_i(axi_cfg_bvalid_w)
//    ,.outport_peripheral0_bresp_i(axi_cfg_bresp_w)
//    ,.outport_peripheral0_arready_i(axi_cfg_arready_w)
//    ,.outport_peripheral0_rvalid_i(axi_cfg_rvalid_w)
//    ,.outport_peripheral0_rdata_i(axi_cfg_rdata_w)
//    ,.outport_peripheral0_rresp_i(axi_cfg_rresp_w)
//
//    // Outputs
//    ,.inport_awready_o(axi_dbg_usb_awready_w)
//    ,.inport_wready_o(axi_dbg_usb_wready_w)
//    ,.inport_bvalid_o(axi_dbg_usb_bvalid_w)
//    ,.inport_bresp_o(axi_dbg_usb_bresp_w)
//    ,.inport_bid_o(axi_dbg_usb_bid_w)
//    ,.inport_arready_o(axi_dbg_usb_arready_w)
//    ,.inport_rvalid_o(axi_dbg_usb_rvalid_w)
//    ,.inport_rdata_o(axi_dbg_usb_rdata_w)
//    ,.inport_rresp_o(axi_dbg_usb_rresp_w)
//    ,.inport_rid_o(axi_dbg_usb_rid_w)
//    ,.inport_rlast_o(axi_dbg_usb_rlast_w)
//    ,.outport_awvalid_o(axi_ftdi_awvalid_w)
//    ,.outport_awaddr_o(axi_ftdi_awaddr_w)
//    ,.outport_awid_o(axi_ftdi_awid_w)
//    ,.outport_awlen_o(axi_ftdi_awlen_w)
//    ,.outport_awburst_o(axi_ftdi_awburst_w)
//    ,.outport_wvalid_o(axi_ftdi_wvalid_w)
//    ,.outport_wdata_o(axi_ftdi_wdata_w)
//    ,.outport_wstrb_o(axi_ftdi_wstrb_w)
//    ,.outport_wlast_o(axi_ftdi_wlast_w)
//    ,.outport_bready_o(axi_ftdi_bready_w)
//    ,.outport_arvalid_o(axi_ftdi_arvalid_w)
//    ,.outport_araddr_o(axi_ftdi_araddr_w)
//    ,.outport_arid_o(axi_ftdi_arid_w)
//    ,.outport_arlen_o(axi_ftdi_arlen_w)
//    ,.outport_arburst_o(axi_ftdi_arburst_w)
//    ,.outport_rready_o(axi_ftdi_rready_w)
//    ,.outport_peripheral0_awvalid_o(axi_cfg_awvalid_w)
//    ,.outport_peripheral0_awaddr_o(axi_cfg_awaddr_w)
//    ,.outport_peripheral0_wvalid_o(axi_cfg_wvalid_w)
//    ,.outport_peripheral0_wdata_o(axi_cfg_wdata_w)
//    ,.outport_peripheral0_wstrb_o(axi_cfg_wstrb_w)
//    ,.outport_peripheral0_bready_o(axi_cfg_bready_w)
//    ,.outport_peripheral0_arvalid_o(axi_cfg_arvalid_w)
//    ,.outport_peripheral0_araddr_o(axi_cfg_araddr_w)
//    ,.outport_peripheral0_rready_o(axi_cfg_rready_w)
//);


// ft60x_axi
// #( .AXI_ID(0) )
// u_dbg
// (
//     // Inputs
//      .clk_i(clk_ftdi_i)
//     ,.rst_i(rst_i)
//     ,.ftdi_rxf_i(ftdi_rxf_i)
//     ,.ftdi_txe_i(ftdi_txe_i)
//     ,.ftdi_data_in_i(ftdi_data_in_i)
//     ,.ftdi_be_in_i(ftdi_be_in_i)
//     ,.outport_awready_i(axi_dbg_ftdi_awready_w)
//     ,.outport_wready_i(axi_dbg_ftdi_wready_w)
//     ,.outport_bvalid_i(axi_dbg_ftdi_bvalid_w)
//     ,.outport_bresp_i(axi_dbg_ftdi_bresp_w)
//     ,.outport_bid_i(axi_dbg_ftdi_bid_w)
//     ,.outport_arready_i(axi_dbg_ftdi_arready_w)
//     ,.outport_rvalid_i(axi_dbg_ftdi_rvalid_w)
//     ,.outport_rdata_i(axi_dbg_ftdi_rdata_w)
//     ,.outport_rresp_i(axi_dbg_ftdi_rresp_w)
//     ,.outport_rid_i(axi_dbg_ftdi_rid_w)
//     ,.outport_rlast_i(axi_dbg_ftdi_rlast_w)
//     ,.gpio_inputs_i(gpio_inputs_i)
// 
//     // Outputs
//     ,.ftdi_wrn_o(ftdi_wrn_o)
//     ,.ftdi_rdn_o(ftdi_rdn_o)
//     ,.ftdi_oen_o(ftdi_oen_o)
//     ,.ftdi_data_out_o(ftdi_data_out_o)
//     ,.ftdi_be_out_o(ftdi_be_out_o)
//     ,.outport_awvalid_o(axi_dbg_ftdi_awvalid_w)
//     ,.outport_awaddr_o(axi_dbg_ftdi_awaddr_w)
//     ,.outport_awid_o(axi_dbg_ftdi_awid_w)
//     ,.outport_awlen_o(axi_dbg_ftdi_awlen_w)
//     ,.outport_awburst_o(axi_dbg_ftdi_awburst_w)
//     ,.outport_wvalid_o(axi_dbg_ftdi_wvalid_w)
//     ,.outport_wdata_o(axi_dbg_ftdi_wdata_w)
//     ,.outport_wstrb_o(axi_dbg_ftdi_wstrb_w)
//     ,.outport_wlast_o(axi_dbg_ftdi_wlast_w)
//     ,.outport_bready_o(axi_dbg_ftdi_bready_w)
//     ,.outport_arvalid_o(axi_dbg_ftdi_arvalid_w)
//     ,.outport_araddr_o(axi_dbg_ftdi_araddr_w)
//     ,.outport_arid_o(axi_dbg_ftdi_arid_w)
//     ,.outport_arlen_o(axi_dbg_ftdi_arlen_w)
//     ,.outport_arburst_o(axi_dbg_ftdi_arburst_w)
//     ,.outport_rready_o(axi_dbg_ftdi_rready_w)
//     ,.gpio_outputs_o(gpio_outputs_o)
// );


ftdi_bridge u_ftdi_bridge (
    .clk_i            (dpti_clk_i)
    ,.rst_i           (dpti_rst_i)
    ,.ftdi_rxf_i      (dpti_rxf_i)
    ,.ftdi_txe_i      (dpti_txe_i)
    ,.ftdi_data_in_i  (dpti_data_in_i)

    ,.ftdi_siwua_o    (dpti_siwua_o)
    ,.ftdi_wrn_o      (dpti_wrn_o)
    ,.ftdi_rdn_o      (dpti_rdn_o)
    ,.ftdi_oen_o      (dpti_oen_o)
    ,.ftdi_data_out_o (dpti_data_out_o)

    ,.gp_inputs_i     (dpti_gp_inputs_i)
    ,.gp_outputs_o    (dpti_gp_outputs_o)

    ,.mem_awready_i(axi_dbg_ftdi_awready_w)
    ,.mem_wready_i(axi_dbg_ftdi_wready_w)
    ,.mem_bvalid_i(axi_dbg_ftdi_bvalid_w)
    ,.mem_bresp_i(axi_dbg_ftdi_bresp_w)
    ,.mem_bid_i(axi_dbg_ftdi_bid_w)
    ,.mem_arready_i(axi_dbg_ftdi_arready_w)
    ,.mem_rvalid_i(axi_dbg_ftdi_rvalid_w)
    ,.mem_rdata_i(axi_dbg_ftdi_rdata_w)
    ,.mem_rresp_i(axi_dbg_ftdi_rresp_w)
    ,.mem_rid_i(axi_dbg_ftdi_rid_w)
    ,.mem_rlast_i(axi_dbg_ftdi_rlast_w)

    // Outputs
    ,.mem_awvalid_o(axi_dbg_ftdi_awvalid_w)
    ,.mem_awaddr_o(axi_dbg_ftdi_awaddr_w)
    ,.mem_awid_o(axi_dbg_ftdi_awid_w)
    ,.mem_awlen_o(axi_dbg_ftdi_awlen_w)
    ,.mem_awburst_o(axi_dbg_ftdi_awburst_w)
    ,.mem_wvalid_o(axi_dbg_ftdi_wvalid_w)
    ,.mem_wdata_o(axi_dbg_ftdi_wdata_w)
    ,.mem_wstrb_o(axi_dbg_ftdi_wstrb_w)
    ,.mem_wlast_o(axi_dbg_ftdi_wlast_w)
    ,.mem_bready_o(axi_dbg_ftdi_bready_w)
    ,.mem_arvalid_o(axi_dbg_ftdi_arvalid_w)
    ,.mem_araddr_o(axi_dbg_ftdi_araddr_w)
    ,.mem_arid_o(axi_dbg_ftdi_arid_w)
    ,.mem_arlen_o(axi_dbg_ftdi_arlen_w)
    ,.mem_arburst_o(axi_dbg_ftdi_arburst_w)
    ,.mem_rready_o(axi_dbg_ftdi_rready_w)
);

//axi4_arb
//u_arb
//(
//    // Inputs
//     .clk_i(clk_usb_i)
//    ,.rst_i(rst_i)
//    ,.inport0_awvalid_i(axi_usb_awvalid_w)
//    ,.inport0_awaddr_i(axi_usb_awaddr_w)
//    ,.inport0_awid_i(axi_usb_awid_w)
//    ,.inport0_awlen_i(axi_usb_awlen_w)
//    ,.inport0_awburst_i(axi_usb_awburst_w)
//    ,.inport0_wvalid_i(axi_usb_wvalid_w)
//    ,.inport0_wdata_i(axi_usb_wdata_w)
//    ,.inport0_wstrb_i(axi_usb_wstrb_w)
//    ,.inport0_wlast_i(axi_usb_wlast_w)
//    ,.inport0_bready_i(axi_usb_bready_w)
//    ,.inport0_arvalid_i(axi_usb_arvalid_w)
//    ,.inport0_araddr_i(axi_usb_araddr_w)
//    ,.inport0_arid_i(axi_usb_arid_w)
//    ,.inport0_arlen_i(axi_usb_arlen_w)
//    ,.inport0_arburst_i(axi_usb_arburst_w)
//    ,.inport0_rready_i(axi_usb_rready_w)
//    ,.inport1_awvalid_i(axi_ftdi_awvalid_w)
//    ,.inport1_awaddr_i(axi_ftdi_awaddr_w)
//    ,.inport1_awid_i(axi_ftdi_awid_w)
//    ,.inport1_awlen_i(axi_ftdi_awlen_w)
//    ,.inport1_awburst_i(axi_ftdi_awburst_w)
//    ,.inport1_wvalid_i(axi_ftdi_wvalid_w)
//    ,.inport1_wdata_i(axi_ftdi_wdata_w)
//    ,.inport1_wstrb_i(axi_ftdi_wstrb_w)
//    ,.inport1_wlast_i(axi_ftdi_wlast_w)
//    ,.inport1_bready_i(axi_ftdi_bready_w)
//    ,.inport1_arvalid_i(axi_ftdi_arvalid_w)
//    ,.inport1_araddr_i(axi_ftdi_araddr_w)
//    ,.inport1_arid_i(axi_ftdi_arid_w)
//    ,.inport1_arlen_i(axi_ftdi_arlen_w)
//    ,.inport1_arburst_i(axi_ftdi_arburst_w)
//    ,.inport1_rready_i(axi_ftdi_rready_w)
//    ,.outport_awready_i(axi_arb_out_awready_w)
//    ,.outport_wready_i(axi_arb_out_wready_w)
//    ,.outport_bvalid_i(axi_arb_out_bvalid_w)
//    ,.outport_bresp_i(axi_arb_out_bresp_w)
//    ,.outport_bid_i(axi_arb_out_bid_w)
//    ,.outport_arready_i(axi_arb_out_arready_w)
//    ,.outport_rvalid_i(axi_arb_out_rvalid_w)
//    ,.outport_rdata_i(axi_arb_out_rdata_w)
//    ,.outport_rresp_i(axi_arb_out_rresp_w)
//    ,.outport_rid_i(axi_arb_out_rid_w)
//    ,.outport_rlast_i(axi_arb_out_rlast_w)
//
//    // Outputs
//    ,.inport0_awready_o(axi_usb_awready_w)
//    ,.inport0_wready_o(axi_usb_wready_w)
//    ,.inport0_bvalid_o(axi_usb_bvalid_w)
//    ,.inport0_bresp_o(axi_usb_bresp_w)
//    ,.inport0_bid_o(axi_usb_bid_w)
//    ,.inport0_arready_o(axi_usb_arready_w)
//    ,.inport0_rvalid_o(axi_usb_rvalid_w)
//    ,.inport0_rdata_o(axi_usb_rdata_w)
//    ,.inport0_rresp_o(axi_usb_rresp_w)
//    ,.inport0_rid_o(axi_usb_rid_w)
//    ,.inport0_rlast_o(axi_usb_rlast_w)
//    ,.inport1_awready_o(axi_ftdi_awready_w)
//    ,.inport1_wready_o(axi_ftdi_wready_w)
//    ,.inport1_bvalid_o(axi_ftdi_bvalid_w)
//    ,.inport1_bresp_o(axi_ftdi_bresp_w)
//    ,.inport1_bid_o(axi_ftdi_bid_w)
//    ,.inport1_arready_o(axi_ftdi_arready_w)
//    ,.inport1_rvalid_o(axi_ftdi_rvalid_w)
//    ,.inport1_rdata_o(axi_ftdi_rdata_w)
//    ,.inport1_rresp_o(axi_ftdi_rresp_w)
//    ,.inport1_rid_o(axi_ftdi_rid_w)
//    ,.inport1_rlast_o(axi_ftdi_rlast_w)
//    ,.outport_awvalid_o(axi_arb_out_awvalid_w)
//    ,.outport_awaddr_o(axi_arb_out_awaddr_w)
//    ,.outport_awid_o(axi_arb_out_awid_w)
//    ,.outport_awlen_o(axi_arb_out_awlen_w)
//    ,.outport_awburst_o(axi_arb_out_awburst_w)
//    ,.outport_wvalid_o(axi_arb_out_wvalid_w)
//    ,.outport_wdata_o(axi_arb_out_wdata_w)
//    ,.outport_wstrb_o(axi_arb_out_wstrb_w)
//    ,.outport_wlast_o(axi_arb_out_wlast_w)
//    ,.outport_bready_o(axi_arb_out_bready_w)
//    ,.outport_arvalid_o(axi_arb_out_arvalid_w)
//    ,.outport_araddr_o(axi_arb_out_araddr_w)
//    ,.outport_arid_o(axi_arb_out_arid_w)
//    ,.outport_arlen_o(axi_arb_out_arlen_w)
//    ,.outport_arburst_o(axi_arb_out_arburst_w)
//    ,.outport_rready_o(axi_arb_out_rready_w)
//);


axi4_cdc
u_cdc_ftdi_usb
(
    // Inputs
     .wr_clk_i(dpti_clk_i)
    ,.wr_rst_i(rst_i)
    ,.inport_awvalid_i(axi_dbg_ftdi_awvalid_w)
    ,.inport_awaddr_i(axi_dbg_ftdi_awaddr_w)
    ,.inport_awid_i(axi_dbg_ftdi_awid_w)
    ,.inport_awlen_i(axi_dbg_ftdi_awlen_w)
    ,.inport_awburst_i(axi_dbg_ftdi_awburst_w)
    ,.inport_wvalid_i(axi_dbg_ftdi_wvalid_w)
    ,.inport_wdata_i(axi_dbg_ftdi_wdata_w)
    ,.inport_wstrb_i(axi_dbg_ftdi_wstrb_w)
    ,.inport_wlast_i(axi_dbg_ftdi_wlast_w)
    ,.inport_bready_i(axi_dbg_ftdi_bready_w)
    ,.inport_arvalid_i(axi_dbg_ftdi_arvalid_w)
    ,.inport_araddr_i(axi_dbg_ftdi_araddr_w)
    ,.inport_arid_i(axi_dbg_ftdi_arid_w)
    ,.inport_arlen_i(axi_dbg_ftdi_arlen_w)
    ,.inport_arburst_i(axi_dbg_ftdi_arburst_w)
    ,.inport_rready_i(axi_dbg_ftdi_rready_w)
    ,.rd_clk_i(dpti_clk_i)
    ,.rd_rst_i(rst_i)

    // naming axi_sys
    //,.outport_awready_i(axi_sys_awready_w)
    //,.outport_wready_i(axi_sys_wready_w)
    //,.outport_bvalid_i(axi_sys_bvalid_w)
    //,.outport_bresp_i(axi_sys_bresp_w)
    //,.outport_bid_i(axi_sys_bid_w)
    //,.outport_arready_i(axi_sys_arready_w)
    //,.outport_rvalid_i(axi_sys_rvalid_w)
    //,.outport_rdata_i(axi_sys_rdata_w)
    //,.outport_rresp_i(axi_sys_rresp_w)
    //,.outport_rid_i(axi_sys_rid_w)
    //,.outport_rlast_i(axi_sys_rlast_w)

    ,.outport_awready_i(AWREADY)
    ,.outport_wready_i(WREADY)
    ,.outport_bvalid_i(BVALID)
    ,.outport_bresp_i(BRESP)
    ,.outport_bid_i(BID)
    ,.outport_arready_i(ARREADY)
    ,.outport_rvalid_i(RVALID)
    ,.outport_rdata_i(RDATA)
    ,.outport_rresp_i(RRESP)
    ,.outport_rid_i(RID)
    ,.outport_rlast_i(RLAST)

    // Outputs
    ,.inport_awready_o(axi_dbg_ftdi_awready_w)
    ,.inport_wready_o(axi_dbg_ftdi_wready_w)
    ,.inport_bvalid_o(axi_dbg_ftdi_bvalid_w)
    ,.inport_bresp_o(axi_dbg_ftdi_bresp_w)
    ,.inport_bid_o(axi_dbg_ftdi_bid_w)
    ,.inport_arready_o(axi_dbg_ftdi_arready_w)
    ,.inport_rvalid_o(axi_dbg_ftdi_rvalid_w)
    ,.inport_rdata_o(axi_dbg_ftdi_rdata_w)
    ,.inport_rresp_o(axi_dbg_ftdi_rresp_w)
    ,.inport_rid_o(axi_dbg_ftdi_rid_w)
    ,.inport_rlast_o(axi_dbg_ftdi_rlast_w)

    // naming axi_sys
    //,.outport_awvalid_o(axi_sys_awvalid_w)
    //,.outport_awaddr_o(axi_sys_awaddr_w)
    //,.outport_awid_o(axi_sys_awid_w)
    //,.outport_awlen_o(axi_sys_awlen_w)
    //,.outport_awburst_o(axi_sys_awburst_w)
    //,.outport_wvalid_o(axi_sys_wvalid_w)
    //,.outport_wdata_o(axi_sys_wdata_w)
    //,.outport_wstrb_o(axi_sys_wstrb_w)
    //,.outport_wlast_o(axi_sys_wlast_w)
    //,.outport_bready_o(axi_sys_bready_w)
    //,.outport_arvalid_o(axi_sys_arvalid_w)
    //,.outport_araddr_o(axi_sys_araddr_w)
    //,.outport_arid_o(axi_sys_arid_w)
    //,.outport_arlen_o(axi_sys_arlen_w)
    //,.outport_arburst_o(axi_sys_arburst_w)
    //,.outport_rready_o(axi_sys_rready_w)

    ,.outport_awvalid_o(AWVALID)
    ,.outport_awaddr_o(AWADDR)
    ,.outport_awid_o(AWID)
    ,.outport_awlen_o(AWLEN)
    ,.outport_awburst_o(AWBURST)
    ,.outport_wvalid_o(WVALID)
    ,.outport_wdata_o(WDATA)
    ,.outport_wstrb_o(WSTRB)
    ,.outport_wlast_o(WLAST)
    ,.outport_bready_o(BREADY)
    ,.outport_arvalid_o(ARVALID)
    ,.outport_araddr_o(ARADDR)
    ,.outport_arid_o(ARID)
    ,.outport_arlen_o(ARLEN)
    ,.outport_arburst_o(ARBURST)
    ,.outport_rready_o(RREADY)
);

//  wire CSYSREQ  = 1'b0;
//
//   //---------------------------------------------------------
//        mem_axi   #(.AXI_WIDTH_CID  (WIDTH_CID)// Channel ID width in bits
//                   ,.AXI_WIDTH_ID   (WIDTH_ID )// ID width in bits
//                   ,.AXI_WIDTH_AD   (WIDTH_AD )// address width
//                   ,.AXI_WIDTH_DA   (WIDTH_DA )// data width
//                   ,.AXI_WIDTH_DS   (WIDTH_DS )// data strobe width
//                   ,.ADDR_LENGTH(ADDR_LENGTH0) // effective addre bits
//                  )
//        u_mem_axi  (
//               .ARESETn  (ARESETn         )
//             , .ACLK     (ACLK            )
//             , .AWID     (AWID          )
//             , .AWADDR   (AWADDR        )
//             , .AWLEN    (AWLEN         )
//             , .AWLOCK   (AWLOCK        )
//             , .AWSIZE   (AWSIZE        )
//             , .AWBURST  (AWBURST       )
//   `ifdef AMBA_AXI_CACHE
//             , .AWCACHE  (AWCACHE       )
//   `endif
//   `ifdef AMBA_AXI_PROT
//             , .AWPROT   (AWPROT        )
//   `endif
//             , .AWVALID  (AWVALID       )
//             , .AWREADY  (AWREADY       )
//        `ifdef AMBA_AXI4
//             , .AWQOS    (AWQOS         )
//             , .AWREGION (AWREGION      )
//        `endif
//             , .WID      (WID           )
//             , .WDATA    (WDATA         )
//             , .WSTRB    (WSTRB         )
//             , .WLAST    (WLAST         )
//             , .WVALID   (WVALID        )
//             , .WREADY   (WREADY        )
//             , .BID      (BID           )
//             , .BRESP    (BRESP         )
//             , .BVALID   (BVALID        )
//             , .BREADY   (BREADY        )
//             , .ARID     (ARID          )
//             , .ARADDR   (ARADDR        )
//             , .ARLEN    (ARLEN         )
//             , .ARLOCK   (ARLOCK        )
//             , .ARSIZE   (ARSIZE        )
//             , .ARBURST  (ARBURST       )
//   `ifdef AMBA_AXI_CACHE
//             , .ARCACHE  (ARCACHE       )
//   `endif
//   `ifdef AMBA_AXI_PROT
//             , .ARPROT   (ARPROT        )
//   `endif
//             , .ARVALID  (ARVALID       )
//             , .ARREADY  (ARREADY       )
//        `ifdef AMBA_AXI4
//             , .ARQOS    (ARQOS         )
//             , .ARREGION (ARREGION      )
//        `endif
//             , .RID      (RID           )
//             , .RDATA    (RDATA         )
//             , .RRESP    (RRESP         )
//             , .RLAST    (RLAST         )
//             , .RVALID   (RVALID        )
//             , .RREADY   (RREADY        )
//             , .CSYSREQ  (CSYSREQ       )
//             , .CSYSACK  (CSYSACKmem    )
//             , .CACTIVE  (CACTIVEmem    )
//        );

axi4_mem axi4_mem (
  .rsta_busy(),          // output wire rsta_busy
  .rstb_busy(),          // output wire rstb_busy
  .s_aclk(dpti_clk_i),                // input wire s_aclk
  .s_aresetn(ARESETn),          // input wire s_aresetn
  .s_axi_awid(AWID),        // input wire [3 : 0] s_axi_awid
  .s_axi_awaddr(AWADDR),    // input wire [31 : 0] s_axi_awaddr
  .s_axi_awlen(AWLEN),      // input wire [7 : 0] s_axi_awlen
  .s_axi_awsize(AWSIZE),    // input wire [2 : 0] s_axi_awsize
  .s_axi_awburst(AWBURST),  // input wire [1 : 0] s_axi_awburst
  .s_axi_awvalid(AWVALID),  // input wire s_axi_awvalid
  .s_axi_awready(AWREADY),  // output wire s_axi_awready
  .s_axi_wdata(WDATA),      // input wire [31 : 0] s_axi_wdata
  .s_axi_wstrb(WSTRB),      // input wire [3 : 0] s_axi_wstrb
  .s_axi_wlast(WLAST),      // input wire s_axi_wlast
  .s_axi_wvalid(WVALID),    // input wire s_axi_wvalid
  .s_axi_wready(WREADY),    // output wire s_axi_wready
  .s_axi_bid(BID),          // output wire [3 : 0] s_axi_bid
  .s_axi_bresp(BRESP),      // output wire [1 : 0] s_axi_bresp
  .s_axi_bvalid(BVALID),    // output wire s_axi_bvalid
  .s_axi_bready(BREADY),    // input wire s_axi_bready
  .s_axi_arid(ARID),        // input wire [3 : 0] s_axi_arid
  .s_axi_araddr(ARADDR),    // input wire [31 : 0] s_axi_araddr
  .s_axi_arlen(ARLEN),      // input wire [7 : 0] s_axi_arlen
  .s_axi_arsize(ARSIZE),    // input wire [2 : 0] s_axi_arsize
  .s_axi_arburst(ARBURST),  // input wire [1 : 0] s_axi_arburst
  .s_axi_arvalid(ARVALID),  // input wire s_axi_arvalid
  .s_axi_arready(ARREADY),  // output wire s_axi_arready
  .s_axi_rid(RID),          // output wire [3 : 0] s_axi_rid
  .s_axi_rdata(RDATA),      // output wire [31 : 0] s_axi_rdata
  .s_axi_rresp(RRESP),      // output wire [1 : 0] s_axi_rresp
  .s_axi_rlast(RLAST),      // output wire s_axi_rlast
  .s_axi_rvalid(RVALID),    // output wire s_axi_rvalid
  .s_axi_rready(RREADY)    // input wire s_axi_rready
);

endmodule
