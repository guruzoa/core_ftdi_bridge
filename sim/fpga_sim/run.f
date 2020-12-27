// =================== XILINX FPGA =================
+incdir+${XILINX_VIVADO}/data/verilog/src
-y ${XILINX_VIVADO}/data/verilog/src/unisims
-y ${XILINX_VIVADO}/data/verilog/src/unimacro
-y ${XILINX_VIVADO}/data/verilog/src/retarget
${XILINX_VIVADO}/data/verilog/src/glbl.v

+libext+.v+.vlib

-v ../../design/verilog/cdc/axi_cdc_buffer_sim_netlist.v
-v ../../design/verilog/axi4_mem/axi4_mem_sim_netlist.v

// ===================== SIM DEFINE ==================
+incdir+../../design/verilog
        ./sim_define.v

// ===================== RTL =========================
//../../design/verilog/mem_axi_dpram_sync.v
//../../design/verilog/mem_axi.v

../../design/verilog/cdc/axi4_cdc.v

../../design/verilog/artix7_pll.v
../../design/verilog/axi4_arb.v

// FT601
// ../../design/verilog/ft60x_axi.v
// ../../design/verilog/ft60x_axi_retime.v
// ../../design/verilog/ft60x_fifo.v

// DPTI (FT2232H)
../../design/verilog/ftdi_bridge/ftdi_async.v
../../design/verilog/ftdi_bridge/ftdi_sync.v
../../design/verilog/ftdi_bridge/ftdi_bridge.v

../../design/verilog/fpga_soc.v
 
../../design/verilog/top.v

/////////////////////////////////////////////////////////

//../../model/afifo.v
../../model/ft245_model.v
../../bench/tb_top_dpti.v
