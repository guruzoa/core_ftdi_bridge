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

module tb_ft601();

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
wire [3:0] BE;
wire [31:0] DATA;

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
   //--------------------------------------------------------------
   wire  [WIDTH_CID-1:0]     MID        ;
   wire  [WIDTH_ID-1:0]      AWID       ;
   wire  [WIDTH_AD-1:0]      AWADDR     ;
   `ifdef AMBA_AXI4
   wire  [ 7:0]              AWLEN      ;
   wire                      AWLOCK     =1'b0;
   `else
   wire  [ 3:0]              AWLEN      ;
   wire  [ 1:0]              AWLOCK     ;
   `endif
   wire  [ 2:0]              AWSIZE     =3'd0;
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
   wire  [ 3:0]              AWQOS      =4'd0;
   wire  [ 3:0]              AWREGION   =4'd0;
   `endif
   `ifdef AMBA_AXI_AWUSER
   wire  [WIDTH_AWUSER-1:0]  AWUSER     ;
   `endif
   wire  [WIDTH_ID-1:0]      WID        =4'd0;
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
   wire                      ARLOCK     =1'b0;
   `else
   wire  [ 3:0]              ARLEN      ;
   wire  [ 1:0]              ARLOCK     ;
   `endif
   wire  [ 2:0]              ARSIZE     =3'd0;
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
   wire  [ 3:0]              ARQOS      =4'd0;
   wire  [ 3:0]              ARREGION   =4'd0;
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
   reg                       CSYSREQ    ;
   wire                      CSYSACKbfm ;
   wire                      CACTIVEbfm ;
   wire                      CSYSACKmem ;
   wire                      CACTIVEmem ;


//fifo_65536x32
//  u_fifo_65536x32(
//  .rst(reset),
//  .rd_data_count(),
//  .wr_data_count(),
//
//  //Write Port
//  .wr_clk (1'b0            ),
//  .din    (32'b0           ),
//  .wr_en  (1'b0            ),
//  .full   (full),
//  .almost_full(),
//
//  //Read Port
//  .rd_clk(ft601_clk),
//  .dout(fifo_rd_data[31:0]),
//  .rd_en(fifo_rd_en),
//  .empty(empty),
//  .almost_empty()
//  );


// afifo #(
//   .DSIZE(32),
//   .ASIZE(16)
// ) u_fifo_65536x32 (
//   .i_wclk     (1'b0),
//   .i_wrst_n   (~reset_n),
//   .i_wr       (1'b0),
//   .i_wdata    (32'd0),
//   .o_wfull    (),
//   .i_rclk     (ft601_clk),
//   .i_rrst_n   (~reset_n),
//   .i_rd       (fifo_rd_en),
//   .o_rdata    (fifo_rd_data),
//   .o_rempty   ()
// );
// 
// ft601_ctrl
//   u_ft601_ctrl(
// //  System Clock & Reset & Config
//   .reset_n(reset_n),
// 
// //  FT601 Control
//   .ft601_1packet_size (32'd1024),
// 
// //  FIFO Read Signals
//   .fifo_rd_start  (fifo_rd_start),
//   .fifo_rd_size   (32'd1024),
//   .fifo_rd_data   (fifo_rd_data),
//   .fifo_rd_en     (fifo_rd_en),
// 
// //  FT601 Control Signals
//   .ft601_clk(ft601_clk),
//   .TXE_N(TXE_N),
//   .RXF_N(RXF_N),
// 
//   .WR_N(WR_N),
//   .RD_N(RD_N),
//   .OE_N(OE_N),
//   .SIWU_N(SIWU_N),
// 
//   .BE(BE[3:0]),
//   .DATA(DATA[31:0]),
//   .error1(),
//   .error2(),
//   .error3(),
//   .error4()
//   );

ft601_model
  u_ft601_model(
    .ft601_clk(ft601_clk),
    .reset_n(ARESETn),
  
    .TXE_N(TXE_N),
    .RXF_N(RXF_N),
  
    .WR_N(WR_N),
    .RD_N(RD_N),
    .OE_N(OE_N),
    .SIWU_N(SIWU_N),
  
    .BE(BE[3:0]),
    .DATA(DATA[31:0])
  );

  ft60x_axi u_ft60x_axi (
       .clk_i                  (ft601_clk)
      ,.rst_i                  (~ARESETn)
      ,.ftdi_rxf_i             (RXF_N)
      ,.ftdi_txe_i             (TXE_N)
      ,.ftdi_data_in_i         (DATA)
      ,.ftdi_be_in_i           (BE)

      ,.outport_awready_i      (AWREADY)
      ,.outport_wready_i       (WREADY)
      ,.outport_bvalid_i       (BVALID)
      ,.outport_bresp_i        (BRESP)
      ,.outport_bid_i          (BID)

      ,.outport_arready_i      (ARREADY)

      ,.outport_rvalid_i       (RVALID)
      ,.outport_rdata_i        (RDATA)
      ,.outport_rresp_i        (RRESP)
      ,.outport_rid_i          (RID)
      ,.outport_rlast_i        (RLAST)

      ,.gpio_inputs_i          (32'hdeadbeaf)

      ,.ftdi_wrn_o             (WR_N)
      ,.ftdi_rdn_o             (RD_N)
      ,.ftdi_oen_o             (OE_N)
      ,.ftdi_data_out_o        ()
      ,.ftdi_be_out_o          ()

      ,.outport_awvalid_o      (AWVALID)
      ,.outport_awaddr_o       (AWADDR)
      ,.outport_awid_o         (AWID)
      ,.outport_awlen_o        (AWLEN)
      ,.outport_awburst_o      (AWBURST)

      ,.outport_wvalid_o       (WVALID)
      ,.outport_wdata_o        (WDATA)
      ,.outport_wstrb_o        (WSTRB)
      ,.outport_wlast_o        (WLAST)

      ,.outport_bready_o       (BREADY)

      ,.outport_arvalid_o      (ARVALID)
      ,.outport_araddr_o       (ARADDR)
      ,.outport_arid_o         (ARID)
      ,.outport_arlen_o        (ARLEN)
      ,.outport_arburst_o      (ARBURST)

      ,.outport_rready_o       (RREADY)
      ,.gpio_outputs_o         ()
  );

  //assign DATA = ftdi_be_out_o ? ftdi_data_out_o : 32'dz;

   //---------------------------------------------------------
        mem_axi   #(.AXI_WIDTH_CID  (WIDTH_CID)// Channel ID width in bits
                   ,.AXI_WIDTH_ID   (WIDTH_ID )// ID width in bits
                   ,.AXI_WIDTH_AD   (WIDTH_AD )// address width
                   ,.AXI_WIDTH_DA   (WIDTH_DA )// data width
                   ,.AXI_WIDTH_DS   (WIDTH_DS )// data strobe width
                   ,.ADDR_LENGTH(ADDR_LENGTH0) // effective addre bits
                  )
        u_mem_axi  (
               .ARESETn  (ARESETn         )
             , .ACLK     (ACLK            )
             , .AWID     (AWID          )
             , .AWADDR   (AWADDR        )
             , .AWLEN    (AWLEN         )
             , .AWLOCK   (AWLOCK        )
             , .AWSIZE   (AWSIZE        )
             , .AWBURST  (AWBURST       )
   `ifdef AMBA_AXI_CACHE
             , .AWCACHE  (AWCACHE       )
   `endif
   `ifdef AMBA_AXI_PROT
             , .AWPROT   (AWPROT        )
   `endif
             , .AWVALID  (AWVALID       )
             , .AWREADY  (AWREADY       )
        `ifdef AMBA_AXI4
             , .AWQOS    (AWQOS         )
             , .AWREGION (AWREGION      )
        `endif
             , .WID      (WID           )
             , .WDATA    (WDATA         )
             , .WSTRB    (WSTRB         )
             , .WLAST    (WLAST         )
             , .WVALID   (WVALID        )
             , .WREADY   (WREADY        )
             , .BID      (BID           )
             , .BRESP    (BRESP         )
             , .BVALID   (BVALID        )
             , .BREADY   (BREADY        )
             , .ARID     (ARID          )
             , .ARADDR   (ARADDR        )
             , .ARLEN    (ARLEN         )
             , .ARLOCK   (ARLOCK        )
             , .ARSIZE   (ARSIZE        )
             , .ARBURST  (ARBURST       )
   `ifdef AMBA_AXI_CACHE
             , .ARCACHE  (ARCACHE       )
   `endif
   `ifdef AMBA_AXI_PROT
             , .ARPROT   (ARPROT        )
   `endif
             , .ARVALID  (ARVALID       )
             , .ARREADY  (ARREADY       )
        `ifdef AMBA_AXI4
             , .ARQOS    (ARQOS         )
             , .ARREGION (ARREGION      )
        `endif
             , .RID      (RID           )
             , .RDATA    (RDATA         )
             , .RRESP    (RRESP         )
             , .RLAST    (RLAST         )
             , .RVALID   (RVALID        )
             , .RREADY   (RREADY        )
             , .CSYSREQ  (CSYSREQ       )
             , .CSYSACK  (CSYSACKmem    )
             , .CACTIVE  (CACTIVEmem    )
        );

  //always #5 ACLK = ~ACLK;
  assign ACLK = ft601_clk;

  initial
  begin
    ARESETn = 0;
    CSYSREQ = 1;
    repeat (2) @ (posedge ACLK);
    ARESETn = 1;
    repeat (2) @ (posedge ACLK);

    #100000;  

    $finish;
  end

  initial
  begin
    $fsdbDumpfile("./test.fsdb");
    $fsdbDumpvars(0);
  end

endmodule 
