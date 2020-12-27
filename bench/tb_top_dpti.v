`timescale 1ns/1ps

`ifndef WIDTH_AD
`define WIDTH_AD   32 // address width
`endif
`ifndef WIDTH_DA
`define WIDTH_DA   32 // data width
`endif
`ifndef ADDR_LENGTH
`define ADDR_LENGTH 12
`endif

module tb_top_dpti();

reg reset_n;
reg fifo_rd_start;

wire [13:0] fifo_rd_addr;
wire [31:0] fifo_rd_data;

wire ft601_clk;
wire TXE_N;
wire RXF_N;
wire WR_N;
wire RD_N;
wire OE_N;
wire SIWU_N;
wire [7:0] DATA;

wire error1;
wire error2;
wire error3;
wire error4;

wire fifo_rd_en;

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
   reg                      ARESETn;
   wire                     ACLK   ;
//   //--------------------------------------------------------------
//   wire  [WIDTH_CID-1:0]     MID        ;
//   wire  [WIDTH_ID-1:0]      AWID       ;
//   wire  [WIDTH_AD-1:0]      AWADDR     ;
//   `ifdef AMBA_AXI4
//   wire  [ 7:0]              AWLEN      ;
//   wire                      AWLOCK     =1'b0;
//   `else
//   wire  [ 3:0]              AWLEN      ;
//   wire  [ 1:0]              AWLOCK     ;
//   `endif
//   wire  [ 2:0]              AWSIZE     =3'd0;
//   wire  [ 1:0]              AWBURST    ;
//   `ifdef AMBA_AXI_CACHE
//   wire  [ 3:0]              AWCACHE    ;
//   `endif
//   `ifdef AMBA_AXI_PROT
//   wire  [ 2:0]              AWPROT     ;
//   `endif
//   wire                      AWVALID    ;
//   wire                      AWREADY    ;
//   `ifdef AMBA_AXI4
//   wire  [ 3:0]              AWQOS      =4'd0;
//   wire  [ 3:0]              AWREGION   =4'd0;
//   `endif
//   `ifdef AMBA_AXI_AWUSER
//   wire  [WIDTH_AWUSER-1:0]  AWUSER     ;
//   `endif
//   wire  [WIDTH_ID-1:0]      WID        =4'd0;
//   wire  [WIDTH_DA-1:0]      WDATA      ;
//   wire  [WIDTH_DS-1:0]      WSTRB      ;
//   wire                      WLAST      ;
//   wire                      WVALID     ;
//   wire                      WREADY     ;
//   `ifdef AMBA_AXI_WUSER
//   wire  [WIDTH_WUSER-1:0]   WUSER      ;
//   `endif
//   wire  [WIDTH_ID-1:0]      BID        ;
//   wire  [ 1:0]              BRESP      ;
//   wire                      BVALID     ;
//   wire                      BREADY     ;
//   `ifdef AMBA_AXI_BUSER
//   wire  [WIDTH_BUSER-1:0]   BUSER      ;
//   `endif
//   wire  [WIDTH_ID-1:0]      ARID       ;
//   wire  [WIDTH_AD-1:0]      ARADDR     ;
//   `ifdef AMBA_AXI4
//   wire  [ 7:0]              ARLEN      ;
//   wire                      ARLOCK     =1'b0;
//   `else
//   wire  [ 3:0]              ARLEN      ;
//   wire  [ 1:0]              ARLOCK     ;
//   `endif
//   wire  [ 2:0]              ARSIZE     =3'd0;
//   wire  [ 1:0]              ARBURST    ;
//   `ifdef AMBA_AXI_CACHE
//   wire  [ 3:0]              ARCACHE    ;
//   `endif
//   `ifdef AMBA_AXI_PROT
//   wire  [ 2:0]              ARPROT     ;
//   `endif
//   wire                      ARVALID    ;
//   wire                      ARREADY    ;
//   `ifdef AMBA_AXI4
//   wire  [ 3:0]              ARQOS      =4'd0;
//   wire  [ 3:0]              ARREGION   =4'd0;
//   `endif
//   `ifdef AMBA_AXI_ARUSER
//   wire  [WIDTH_ARUSER-1:0]  ARUSER     ;
//   `endif
//   wire  [WIDTH_ID-1:0]      RID        ;
//   wire  [WIDTH_DA-1:0]      RDATA      ;
//   wire  [ 1:0]              RRESP      ;
//   wire                      RLAST      ;
//   wire                      RVALID     ;
//   wire                      RREADY     ;
//   `ifdef AMBA_AXI_RUSER
//   wire  [WIDTH_RUSER-1:0]   RUSER      ;
//   `endif
   reg                       CSYSREQ    ;
   wire                      CSYSACKbfm ;
   wire                      CACTIVEbfm ;
   wire                      CSYSACKmem ;
   wire                      CACTIVEmem ;


ft245_model
  u_ft245_model(
    .ft_clk(ft_clk),
    .reset_n(ARESETn),
  
    .TXE_N(TXE_N),
    .RXF_N(RXF_N),
  
    .WR_N(WR_N),
    .RD_N(RD_N),
    .OE_N(OE_N),
    .SIWU_N(SIWU_N),
  
    .DATA(DATA)
  );

  //always #5 ACLK = ~ACLK;
  assign ACLK = ~ft_clk;

  top dut (
    .clk100_i      (ACLK),
    .reset_i       (~ARESETn),

    .ftdi_clk      (1'b0),
    .ftdi_rst      (),
    .ftdi_data     (),
    .ftdi_be       (),
    .ftdi_rxf_n    (),
    .ftdi_txe_n    (),
    .ftdi_rd_n     (),
    .ftdi_wr_n     (),
    .ftdi_oe_n     (),
    .ftdi_siwua    (),

    .prog_clko      (ft_clk),
    .prog_d         (DATA),
    .prog_rxen      (RXF_N),
    .prog_txen      (TXE_N),    
    .prog_spien     (1'b0),

    .prog_oen       (OE_N),
    .prog_rdn       (RD_N),
    .prog_wrn       (WR_N),  
    .prog_siwun     (SIWU_N)
  );

  initial
  begin
    ARESETn = 0;
    CSYSREQ = 1;
    repeat (2) @ (posedge ACLK);
    ARESETn = 1;
    repeat (2) @ (posedge ACLK);

    #100_000;  

    $finish;
  end

  initial
  begin
    $fsdbDumpfile("./test.fsdb");
    $fsdbDumpvars(0);
  end

endmodule 
