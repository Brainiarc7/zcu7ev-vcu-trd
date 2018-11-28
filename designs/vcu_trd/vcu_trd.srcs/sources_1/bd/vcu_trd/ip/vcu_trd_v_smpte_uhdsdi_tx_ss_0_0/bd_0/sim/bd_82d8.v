//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Command: generate_target bd_82d8.bd
//Design : bd_82d8
//Purpose: IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "bd_82d8,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=bd_82d8,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=6,numReposBlks=6,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=SBD,synth_mode=Global}" *) (* HW_HANDOFF = "vcu_trd_v_smpte_uhdsdi_tx_ss_0_0.hwdef" *) 
module bd_82d8
   (M_AXIS_CTRL_SB_TX_tdata,
    M_AXIS_CTRL_SB_TX_tready,
    M_AXIS_CTRL_SB_TX_tvalid,
    M_AXIS_TX_tdata,
    M_AXIS_TX_tready,
    M_AXIS_TX_tuser,
    M_AXIS_TX_tvalid,
    S_AXIS_STS_SB_TX_tdata,
    S_AXIS_STS_SB_TX_tready,
    S_AXIS_STS_SB_TX_tvalid,
    S_AXI_CTRL_araddr,
    S_AXI_CTRL_arprot,
    S_AXI_CTRL_arready,
    S_AXI_CTRL_arvalid,
    S_AXI_CTRL_awaddr,
    S_AXI_CTRL_awprot,
    S_AXI_CTRL_awready,
    S_AXI_CTRL_awvalid,
    S_AXI_CTRL_bready,
    S_AXI_CTRL_bresp,
    S_AXI_CTRL_bvalid,
    S_AXI_CTRL_rdata,
    S_AXI_CTRL_rready,
    S_AXI_CTRL_rresp,
    S_AXI_CTRL_rvalid,
    S_AXI_CTRL_wdata,
    S_AXI_CTRL_wready,
    S_AXI_CTRL_wstrb,
    S_AXI_CTRL_wvalid,
    VIDEO_IN_tdata,
    VIDEO_IN_tlast,
    VIDEO_IN_tready,
    VIDEO_IN_tuser,
    VIDEO_IN_tvalid,
    fid,
    s_axi_aclk,
    s_axi_arstn,
    sdi_tx_clk,
    sdi_tx_irq,
    sdi_tx_rst,
    video_in_arstn,
    video_in_clk,
    vtc_irq);
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_CTRL_SB_TX TDATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXIS_CTRL_SB_TX, CLK_DOMAIN vcu_trd_clk_wiz_1_clk_out1, FREQ_HZ 99999000, HAS_TKEEP 0, HAS_TLAST 0, HAS_TREADY 1, HAS_TSTRB 0, LAYERED_METADATA undef, PHASE 0.0, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0" *) output [31:0]M_AXIS_CTRL_SB_TX_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_CTRL_SB_TX TREADY" *) input M_AXIS_CTRL_SB_TX_tready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_CTRL_SB_TX TVALID" *) output M_AXIS_CTRL_SB_TX_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_TX TDATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXIS_TX, CLK_DOMAIN vcu_trd_clk_wiz_1_clk_out1, FREQ_HZ 99999000, HAS_TKEEP 0, HAS_TLAST 0, HAS_TREADY 1, HAS_TSTRB 0, LAYERED_METADATA undef, PHASE 0.0, TDATA_NUM_BYTES 5, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 32" *) output [39:0]M_AXIS_TX_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_TX TREADY" *) input M_AXIS_TX_tready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_TX TUSER" *) output [31:0]M_AXIS_TX_tuser;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_TX TVALID" *) output M_AXIS_TX_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_STS_SB_TX TDATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXIS_STS_SB_TX, CLK_DOMAIN vcu_trd_clk_wiz_1_clk_out1, FREQ_HZ 99999000, HAS_TKEEP 0, HAS_TLAST 0, HAS_TREADY 1, HAS_TSTRB 0, LAYERED_METADATA undef, PHASE 0.0, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0" *) input [31:0]S_AXIS_STS_SB_TX_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_STS_SB_TX TREADY" *) output S_AXIS_STS_SB_TX_tready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_STS_SB_TX TVALID" *) input S_AXIS_STS_SB_TX_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL ARADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXI_CTRL, ADDR_WIDTH 17, ARUSER_WIDTH 0, AWUSER_WIDTH 0, BUSER_WIDTH 0, CLK_DOMAIN vcu_trd_zynq_ultra_ps_e_0_1_pl_clk0, DATA_WIDTH 32, FREQ_HZ 99999000, HAS_BRESP 1, HAS_BURST 0, HAS_CACHE 0, HAS_LOCK 0, HAS_PROT 1, HAS_QOS 0, HAS_REGION 0, HAS_RRESP 1, HAS_WSTRB 1, ID_WIDTH 0, MAX_BURST_LENGTH 1, NUM_READ_OUTSTANDING 2, NUM_READ_THREADS 1, NUM_WRITE_OUTSTANDING 2, NUM_WRITE_THREADS 1, PHASE 0.000, PROTOCOL AXI4LITE, READ_WRITE_MODE READ_WRITE, RUSER_BITS_PER_BYTE 0, RUSER_WIDTH 0, SUPPORTS_NARROW_BURST 0, WUSER_BITS_PER_BYTE 0, WUSER_WIDTH 0" *) input [16:0]S_AXI_CTRL_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL ARPROT" *) input [2:0]S_AXI_CTRL_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL ARREADY" *) output [0:0]S_AXI_CTRL_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL ARVALID" *) input [0:0]S_AXI_CTRL_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL AWADDR" *) input [16:0]S_AXI_CTRL_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL AWPROT" *) input [2:0]S_AXI_CTRL_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL AWREADY" *) output [0:0]S_AXI_CTRL_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL AWVALID" *) input [0:0]S_AXI_CTRL_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL BREADY" *) input [0:0]S_AXI_CTRL_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL BRESP" *) output [1:0]S_AXI_CTRL_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL BVALID" *) output [0:0]S_AXI_CTRL_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL RDATA" *) output [31:0]S_AXI_CTRL_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL RREADY" *) input [0:0]S_AXI_CTRL_rready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL RRESP" *) output [1:0]S_AXI_CTRL_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL RVALID" *) output [0:0]S_AXI_CTRL_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL WDATA" *) input [31:0]S_AXI_CTRL_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL WREADY" *) output [0:0]S_AXI_CTRL_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL WSTRB" *) input [3:0]S_AXI_CTRL_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL WVALID" *) input [0:0]S_AXI_CTRL_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 VIDEO_IN TDATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME VIDEO_IN, CLK_DOMAIN vcu_trd_clk_wiz_1_clk_out1, FREQ_HZ 99999000, HAS_TKEEP 0, HAS_TLAST 1, HAS_TREADY 1, HAS_TSTRB 0, LAYERED_METADATA undef, PHASE 0.0, TDATA_NUM_BYTES 8, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 1" *) input [63:0]VIDEO_IN_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 VIDEO_IN TLAST" *) input VIDEO_IN_tlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 VIDEO_IN TREADY" *) output VIDEO_IN_tready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 VIDEO_IN TUSER" *) input VIDEO_IN_tuser;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 VIDEO_IN TVALID" *) input VIDEO_IN_tvalid;
  input fid;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.S_AXI_ACLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.S_AXI_ACLK, ASSOCIATED_BUSIF S_AXI_CTRL, ASSOCIATED_CLKEN s_axi_aclken, ASSOCIATED_RESET s_axi_arstn, CLK_DOMAIN vcu_trd_zynq_ultra_ps_e_0_1_pl_clk0, FREQ_HZ 99999000, PHASE 0.000" *) input s_axi_aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.S_AXI_ARSTN RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.S_AXI_ARSTN, POLARITY ACTIVE_LOW, TYPE INTERCONNECT" *) input s_axi_arstn;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.SDI_TX_CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.SDI_TX_CLK, ASSOCIATED_BUSIF M_AXIS_CTRL_SB_TX:M_AXIS_TX:S_AXIS_STS_SB_TX, ASSOCIATED_CLKEN clken, ASSOCIATED_RESET sdi_tx_rst, CLK_DOMAIN vcu_trd_clk_wiz_1_clk_out1, FREQ_HZ 99999000, PHASE 0.0" *) input sdi_tx_clk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 INTR.SDI_TX_IRQ INTERRUPT" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME INTR.SDI_TX_IRQ, PortWidth 1, SENSITIVITY LEVEL_HIGH" *) output sdi_tx_irq;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.SDI_TX_RST RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.SDI_TX_RST, POLARITY ACTIVE_HIGH" *) input sdi_tx_rst;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.VIDEO_IN_ARSTN RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.VIDEO_IN_ARSTN, POLARITY ACTIVE_LOW" *) input video_in_arstn;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.VIDEO_IN_CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.VIDEO_IN_CLK, ASSOCIATED_BUSIF VIDEO_IN, ASSOCIATED_RESET video_in_arstn, CLK_DOMAIN vcu_trd_clk_wiz_1_clk_out1, FREQ_HZ 99999000, PHASE 0.0" *) input video_in_clk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 INTR.VTC_IRQ INTERRUPT" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME INTR.VTC_IRQ, PortWidth 1, SENSITIVITY LEVEL_HIGH" *) output vtc_irq;

  wire [31:0]S_AXIS_STS_SB_TX_1_TDATA;
  wire S_AXIS_STS_SB_TX_1_TREADY;
  wire S_AXIS_STS_SB_TX_1_TVALID;
  wire [16:0]S_AXI_CTRL_1_ARADDR;
  wire [2:0]S_AXI_CTRL_1_ARPROT;
  wire [0:0]S_AXI_CTRL_1_ARREADY;
  wire [0:0]S_AXI_CTRL_1_ARVALID;
  wire [16:0]S_AXI_CTRL_1_AWADDR;
  wire [2:0]S_AXI_CTRL_1_AWPROT;
  wire [0:0]S_AXI_CTRL_1_AWREADY;
  wire [0:0]S_AXI_CTRL_1_AWVALID;
  wire [0:0]S_AXI_CTRL_1_BREADY;
  wire [1:0]S_AXI_CTRL_1_BRESP;
  wire [0:0]S_AXI_CTRL_1_BVALID;
  wire [31:0]S_AXI_CTRL_1_RDATA;
  wire [0:0]S_AXI_CTRL_1_RREADY;
  wire [1:0]S_AXI_CTRL_1_RRESP;
  wire [0:0]S_AXI_CTRL_1_RVALID;
  wire [31:0]S_AXI_CTRL_1_WDATA;
  wire [0:0]S_AXI_CTRL_1_WREADY;
  wire [3:0]S_AXI_CTRL_1_WSTRB;
  wire [0:0]S_AXI_CTRL_1_WVALID;
  wire [63:0]VIDEO_IN_1_TDATA;
  wire VIDEO_IN_1_TLAST;
  wire VIDEO_IN_1_TREADY;
  wire VIDEO_IN_1_TUSER;
  wire VIDEO_IN_1_TVALID;
  wire [16:0]axi_crossbar_M00_AXI_ARADDR;
  wire axi_crossbar_M00_AXI_ARREADY;
  wire [0:0]axi_crossbar_M00_AXI_ARVALID;
  wire [16:0]axi_crossbar_M00_AXI_AWADDR;
  wire axi_crossbar_M00_AXI_AWREADY;
  wire [0:0]axi_crossbar_M00_AXI_AWVALID;
  wire [0:0]axi_crossbar_M00_AXI_BREADY;
  wire [1:0]axi_crossbar_M00_AXI_BRESP;
  wire axi_crossbar_M00_AXI_BVALID;
  wire [31:0]axi_crossbar_M00_AXI_RDATA;
  wire [0:0]axi_crossbar_M00_AXI_RREADY;
  wire [1:0]axi_crossbar_M00_AXI_RRESP;
  wire axi_crossbar_M00_AXI_RVALID;
  wire [31:0]axi_crossbar_M00_AXI_WDATA;
  wire axi_crossbar_M00_AXI_WREADY;
  wire [3:0]axi_crossbar_M00_AXI_WSTRB;
  wire [0:0]axi_crossbar_M00_AXI_WVALID;
  wire [33:17]axi_crossbar_M01_AXI_ARADDR;
  wire [5:3]axi_crossbar_M01_AXI_ARPROT;
  wire axi_crossbar_M01_AXI_ARREADY;
  wire [1:1]axi_crossbar_M01_AXI_ARVALID;
  wire [33:17]axi_crossbar_M01_AXI_AWADDR;
  wire [5:3]axi_crossbar_M01_AXI_AWPROT;
  wire axi_crossbar_M01_AXI_AWREADY;
  wire [1:1]axi_crossbar_M01_AXI_AWVALID;
  wire [1:1]axi_crossbar_M01_AXI_BREADY;
  wire [1:0]axi_crossbar_M01_AXI_BRESP;
  wire axi_crossbar_M01_AXI_BVALID;
  wire [31:0]axi_crossbar_M01_AXI_RDATA;
  wire [1:1]axi_crossbar_M01_AXI_RREADY;
  wire [1:0]axi_crossbar_M01_AXI_RRESP;
  wire axi_crossbar_M01_AXI_RVALID;
  wire [63:32]axi_crossbar_M01_AXI_WDATA;
  wire axi_crossbar_M01_AXI_WREADY;
  wire [7:4]axi_crossbar_M01_AXI_WSTRB;
  wire [1:1]axi_crossbar_M01_AXI_WVALID;
  wire [0:0]const_1_dout;
  wire fid_1;
  wire s_axi_aclk_1;
  wire s_axi_arstn_1;
  wire sdi_tx_clk_1;
  wire sdi_tx_rst_1;
  wire v_axi4s_vid_out_locked;
  wire v_axi4s_vid_out_overflow;
  wire [31:0]v_axi4s_vid_out_status;
  wire v_axi4s_vid_out_underflow;
  wire v_axi4s_vid_out_vid_io_out_ACTIVE_VIDEO;
  wire [59:0]v_axi4s_vid_out_vid_io_out_DATA;
  wire v_axi4s_vid_out_vid_io_out_FIELD;
  wire v_axi4s_vid_out_vid_io_out_HBLANK;
  wire v_axi4s_vid_out_vid_io_out_VBLANK;
  wire v_axi4s_vid_out_vtg_ce;
  wire [31:0]v_smpte_uhdsdi_tx_M_AXIS_CTRL_SB_TX_TDATA;
  wire v_smpte_uhdsdi_tx_M_AXIS_CTRL_SB_TX_TREADY;
  wire v_smpte_uhdsdi_tx_M_AXIS_CTRL_SB_TX_TVALID;
  wire [39:0]v_smpte_uhdsdi_tx_M_AXIS_TX_TDATA;
  wire v_smpte_uhdsdi_tx_M_AXIS_TX_TREADY;
  wire [31:0]v_smpte_uhdsdi_tx_M_AXIS_TX_TUSER;
  wire v_smpte_uhdsdi_tx_M_AXIS_TX_TVALID;
  wire v_smpte_uhdsdi_tx_axi4s_vid_out_axis_rstn;
  wire v_smpte_uhdsdi_tx_axi4s_vid_out_vid_rst;
  wire v_smpte_uhdsdi_tx_interrupt;
  wire [31:0]v_smpte_uhdsdi_tx_sdi_tx_bridge_ctrl;
  wire v_tc_irq;
  wire v_tc_vtiming_out_ACTIVE_VIDEO;
  wire v_tc_vtiming_out_FIELD;
  wire v_tc_vtiming_out_HBLANK;
  wire v_tc_vtiming_out_HSYNC;
  wire v_tc_vtiming_out_VBLANK;
  wire v_tc_vtiming_out_VSYNC;
  wire [9:0]v_vid_sdi_tx_bridge_SDI_DS_OUT_DS1;
  wire [9:0]v_vid_sdi_tx_bridge_SDI_DS_OUT_DS2;
  wire [9:0]v_vid_sdi_tx_bridge_SDI_DS_OUT_DS3;
  wire [9:0]v_vid_sdi_tx_bridge_SDI_DS_OUT_DS4;
  wire [9:0]v_vid_sdi_tx_bridge_SDI_DS_OUT_DS5;
  wire [9:0]v_vid_sdi_tx_bridge_SDI_DS_OUT_DS6;
  wire [9:0]v_vid_sdi_tx_bridge_SDI_DS_OUT_DS7;
  wire [9:0]v_vid_sdi_tx_bridge_SDI_DS_OUT_DS8;
  wire [10:0]v_vid_sdi_tx_bridge_SDI_DS_OUT_LN_NUM_1;
  wire [10:0]v_vid_sdi_tx_bridge_SDI_DS_OUT_LN_NUM_2;
  wire [10:0]v_vid_sdi_tx_bridge_SDI_DS_OUT_LN_NUM_3;
  wire [10:0]v_vid_sdi_tx_bridge_SDI_DS_OUT_LN_NUM_4;
  wire v_vid_sdi_tx_bridge_SDI_DS_OUT_TX_CE;
  wire v_vid_sdi_tx_bridge_SDI_DS_OUT_TX_SD_CE;
  wire [31:0]v_vid_sdi_tx_bridge_sdi_tx_bridge_sts;
  wire v_vid_sdi_tx_bridge_vid_ce;
  wire video_in_arstn_1;
  wire video_in_clk_1;
  wire [5:0]NLW_axi_crossbar_m_axi_arprot_UNCONNECTED;
  wire [5:0]NLW_axi_crossbar_m_axi_awprot_UNCONNECTED;

  assign M_AXIS_CTRL_SB_TX_tdata[31:0] = v_smpte_uhdsdi_tx_M_AXIS_CTRL_SB_TX_TDATA;
  assign M_AXIS_CTRL_SB_TX_tvalid = v_smpte_uhdsdi_tx_M_AXIS_CTRL_SB_TX_TVALID;
  assign M_AXIS_TX_tdata[39:0] = v_smpte_uhdsdi_tx_M_AXIS_TX_TDATA;
  assign M_AXIS_TX_tuser[31:0] = v_smpte_uhdsdi_tx_M_AXIS_TX_TUSER;
  assign M_AXIS_TX_tvalid = v_smpte_uhdsdi_tx_M_AXIS_TX_TVALID;
  assign S_AXIS_STS_SB_TX_1_TDATA = S_AXIS_STS_SB_TX_tdata[31:0];
  assign S_AXIS_STS_SB_TX_1_TVALID = S_AXIS_STS_SB_TX_tvalid;
  assign S_AXIS_STS_SB_TX_tready = S_AXIS_STS_SB_TX_1_TREADY;
  assign S_AXI_CTRL_1_ARADDR = S_AXI_CTRL_araddr[16:0];
  assign S_AXI_CTRL_1_ARPROT = S_AXI_CTRL_arprot[2:0];
  assign S_AXI_CTRL_1_ARVALID = S_AXI_CTRL_arvalid[0];
  assign S_AXI_CTRL_1_AWADDR = S_AXI_CTRL_awaddr[16:0];
  assign S_AXI_CTRL_1_AWPROT = S_AXI_CTRL_awprot[2:0];
  assign S_AXI_CTRL_1_AWVALID = S_AXI_CTRL_awvalid[0];
  assign S_AXI_CTRL_1_BREADY = S_AXI_CTRL_bready[0];
  assign S_AXI_CTRL_1_RREADY = S_AXI_CTRL_rready[0];
  assign S_AXI_CTRL_1_WDATA = S_AXI_CTRL_wdata[31:0];
  assign S_AXI_CTRL_1_WSTRB = S_AXI_CTRL_wstrb[3:0];
  assign S_AXI_CTRL_1_WVALID = S_AXI_CTRL_wvalid[0];
  assign S_AXI_CTRL_arready[0] = S_AXI_CTRL_1_ARREADY;
  assign S_AXI_CTRL_awready[0] = S_AXI_CTRL_1_AWREADY;
  assign S_AXI_CTRL_bresp[1:0] = S_AXI_CTRL_1_BRESP;
  assign S_AXI_CTRL_bvalid[0] = S_AXI_CTRL_1_BVALID;
  assign S_AXI_CTRL_rdata[31:0] = S_AXI_CTRL_1_RDATA;
  assign S_AXI_CTRL_rresp[1:0] = S_AXI_CTRL_1_RRESP;
  assign S_AXI_CTRL_rvalid[0] = S_AXI_CTRL_1_RVALID;
  assign S_AXI_CTRL_wready[0] = S_AXI_CTRL_1_WREADY;
  assign VIDEO_IN_1_TDATA = VIDEO_IN_tdata[63:0];
  assign VIDEO_IN_1_TLAST = VIDEO_IN_tlast;
  assign VIDEO_IN_1_TUSER = VIDEO_IN_tuser;
  assign VIDEO_IN_1_TVALID = VIDEO_IN_tvalid;
  assign VIDEO_IN_tready = VIDEO_IN_1_TREADY;
  assign fid_1 = fid;
  assign s_axi_aclk_1 = s_axi_aclk;
  assign s_axi_arstn_1 = s_axi_arstn;
  assign sdi_tx_clk_1 = sdi_tx_clk;
  assign sdi_tx_irq = v_smpte_uhdsdi_tx_interrupt;
  assign sdi_tx_rst_1 = sdi_tx_rst;
  assign v_smpte_uhdsdi_tx_M_AXIS_CTRL_SB_TX_TREADY = M_AXIS_CTRL_SB_TX_tready;
  assign v_smpte_uhdsdi_tx_M_AXIS_TX_TREADY = M_AXIS_TX_tready;
  assign video_in_arstn_1 = video_in_arstn;
  assign video_in_clk_1 = video_in_clk;
  assign vtc_irq = v_tc_irq;
  bd_82d8_axi_crossbar_0 axi_crossbar
       (.aclk(s_axi_aclk_1),
        .aresetn(s_axi_arstn_1),
        .m_axi_araddr({axi_crossbar_M01_AXI_ARADDR,axi_crossbar_M00_AXI_ARADDR}),
        .m_axi_arprot({axi_crossbar_M01_AXI_ARPROT,NLW_axi_crossbar_m_axi_arprot_UNCONNECTED[2:0]}),
        .m_axi_arready({axi_crossbar_M01_AXI_ARREADY,axi_crossbar_M00_AXI_ARREADY}),
        .m_axi_arvalid({axi_crossbar_M01_AXI_ARVALID,axi_crossbar_M00_AXI_ARVALID}),
        .m_axi_awaddr({axi_crossbar_M01_AXI_AWADDR,axi_crossbar_M00_AXI_AWADDR}),
        .m_axi_awprot({axi_crossbar_M01_AXI_AWPROT,NLW_axi_crossbar_m_axi_awprot_UNCONNECTED[2:0]}),
        .m_axi_awready({axi_crossbar_M01_AXI_AWREADY,axi_crossbar_M00_AXI_AWREADY}),
        .m_axi_awvalid({axi_crossbar_M01_AXI_AWVALID,axi_crossbar_M00_AXI_AWVALID}),
        .m_axi_bready({axi_crossbar_M01_AXI_BREADY,axi_crossbar_M00_AXI_BREADY}),
        .m_axi_bresp({axi_crossbar_M01_AXI_BRESP,axi_crossbar_M00_AXI_BRESP}),
        .m_axi_bvalid({axi_crossbar_M01_AXI_BVALID,axi_crossbar_M00_AXI_BVALID}),
        .m_axi_rdata({axi_crossbar_M01_AXI_RDATA,axi_crossbar_M00_AXI_RDATA}),
        .m_axi_rready({axi_crossbar_M01_AXI_RREADY,axi_crossbar_M00_AXI_RREADY}),
        .m_axi_rresp({axi_crossbar_M01_AXI_RRESP,axi_crossbar_M00_AXI_RRESP}),
        .m_axi_rvalid({axi_crossbar_M01_AXI_RVALID,axi_crossbar_M00_AXI_RVALID}),
        .m_axi_wdata({axi_crossbar_M01_AXI_WDATA,axi_crossbar_M00_AXI_WDATA}),
        .m_axi_wready({axi_crossbar_M01_AXI_WREADY,axi_crossbar_M00_AXI_WREADY}),
        .m_axi_wstrb({axi_crossbar_M01_AXI_WSTRB,axi_crossbar_M00_AXI_WSTRB}),
        .m_axi_wvalid({axi_crossbar_M01_AXI_WVALID,axi_crossbar_M00_AXI_WVALID}),
        .s_axi_araddr(S_AXI_CTRL_1_ARADDR),
        .s_axi_arprot(S_AXI_CTRL_1_ARPROT),
        .s_axi_arready(S_AXI_CTRL_1_ARREADY),
        .s_axi_arvalid(S_AXI_CTRL_1_ARVALID),
        .s_axi_awaddr(S_AXI_CTRL_1_AWADDR),
        .s_axi_awprot(S_AXI_CTRL_1_AWPROT),
        .s_axi_awready(S_AXI_CTRL_1_AWREADY),
        .s_axi_awvalid(S_AXI_CTRL_1_AWVALID),
        .s_axi_bready(S_AXI_CTRL_1_BREADY),
        .s_axi_bresp(S_AXI_CTRL_1_BRESP),
        .s_axi_bvalid(S_AXI_CTRL_1_BVALID),
        .s_axi_rdata(S_AXI_CTRL_1_RDATA),
        .s_axi_rready(S_AXI_CTRL_1_RREADY),
        .s_axi_rresp(S_AXI_CTRL_1_RRESP),
        .s_axi_rvalid(S_AXI_CTRL_1_RVALID),
        .s_axi_wdata(S_AXI_CTRL_1_WDATA),
        .s_axi_wready(S_AXI_CTRL_1_WREADY),
        .s_axi_wstrb(S_AXI_CTRL_1_WSTRB),
        .s_axi_wvalid(S_AXI_CTRL_1_WVALID));
  bd_82d8_const_1_0 const_1
       (.dout(const_1_dout));
  bd_82d8_v_axi4s_vid_out_0 v_axi4s_vid_out
       (.aclk(video_in_clk_1),
        .aclken(1'b1),
        .aresetn(v_smpte_uhdsdi_tx_axi4s_vid_out_axis_rstn),
        .fid(fid_1),
        .locked(v_axi4s_vid_out_locked),
        .overflow(v_axi4s_vid_out_overflow),
        .s_axis_video_tdata(VIDEO_IN_1_TDATA),
        .s_axis_video_tlast(VIDEO_IN_1_TLAST),
        .s_axis_video_tready(VIDEO_IN_1_TREADY),
        .s_axis_video_tuser(VIDEO_IN_1_TUSER),
        .s_axis_video_tvalid(VIDEO_IN_1_TVALID),
        .status(v_axi4s_vid_out_status),
        .underflow(v_axi4s_vid_out_underflow),
        .vid_active_video(v_axi4s_vid_out_vid_io_out_ACTIVE_VIDEO),
        .vid_data(v_axi4s_vid_out_vid_io_out_DATA),
        .vid_field_id(v_axi4s_vid_out_vid_io_out_FIELD),
        .vid_hblank(v_axi4s_vid_out_vid_io_out_HBLANK),
        .vid_io_out_ce(v_vid_sdi_tx_bridge_vid_ce),
        .vid_io_out_clk(sdi_tx_clk_1),
        .vid_io_out_reset(v_smpte_uhdsdi_tx_axi4s_vid_out_vid_rst),
        .vid_vblank(v_axi4s_vid_out_vid_io_out_VBLANK),
        .vtg_active_video(v_tc_vtiming_out_ACTIVE_VIDEO),
        .vtg_ce(v_axi4s_vid_out_vtg_ce),
        .vtg_field_id(v_tc_vtiming_out_FIELD),
        .vtg_hblank(v_tc_vtiming_out_HBLANK),
        .vtg_hsync(v_tc_vtiming_out_HSYNC),
        .vtg_vblank(v_tc_vtiming_out_VBLANK),
        .vtg_vsync(v_tc_vtiming_out_VSYNC));
  bd_82d8_v_smpte_uhdsdi_tx_0 v_smpte_uhdsdi_tx
       (.axi4s_vid_out_axis_rstn(v_smpte_uhdsdi_tx_axi4s_vid_out_axis_rstn),
        .axi4s_vid_out_locked(v_axi4s_vid_out_locked),
        .axi4s_vid_out_overflow(v_axi4s_vid_out_overflow),
        .axi4s_vid_out_status(v_axi4s_vid_out_status),
        .axi4s_vid_out_underflow(v_axi4s_vid_out_underflow),
        .axi4s_vid_out_vid_rst(v_smpte_uhdsdi_tx_axi4s_vid_out_vid_rst),
        .axis_clk(video_in_clk_1),
        .axis_rstn(video_in_arstn_1),
        .interrupt(v_smpte_uhdsdi_tx_interrupt),
        .m_axis_ctrl_sb_tx_tdata(v_smpte_uhdsdi_tx_M_AXIS_CTRL_SB_TX_TDATA),
        .m_axis_ctrl_sb_tx_tready(v_smpte_uhdsdi_tx_M_AXIS_CTRL_SB_TX_TREADY),
        .m_axis_ctrl_sb_tx_tvalid(v_smpte_uhdsdi_tx_M_AXIS_CTRL_SB_TX_TVALID),
        .m_axis_tx_tdata(v_smpte_uhdsdi_tx_M_AXIS_TX_TDATA),
        .m_axis_tx_tready(v_smpte_uhdsdi_tx_M_AXIS_TX_TREADY),
        .m_axis_tx_tuser(v_smpte_uhdsdi_tx_M_AXIS_TX_TUSER),
        .m_axis_tx_tvalid(v_smpte_uhdsdi_tx_M_AXIS_TX_TVALID),
        .s_axi_aclk(s_axi_aclk_1),
        .s_axi_araddr(axi_crossbar_M01_AXI_ARADDR[25:17]),
        .s_axi_aresetn(s_axi_arstn_1),
        .s_axi_arprot(axi_crossbar_M01_AXI_ARPROT),
        .s_axi_arready(axi_crossbar_M01_AXI_ARREADY),
        .s_axi_arvalid(axi_crossbar_M01_AXI_ARVALID),
        .s_axi_awaddr(axi_crossbar_M01_AXI_AWADDR[25:17]),
        .s_axi_awprot(axi_crossbar_M01_AXI_AWPROT),
        .s_axi_awready(axi_crossbar_M01_AXI_AWREADY),
        .s_axi_awvalid(axi_crossbar_M01_AXI_AWVALID),
        .s_axi_bready(axi_crossbar_M01_AXI_BREADY),
        .s_axi_bresp(axi_crossbar_M01_AXI_BRESP),
        .s_axi_bvalid(axi_crossbar_M01_AXI_BVALID),
        .s_axi_rdata(axi_crossbar_M01_AXI_RDATA),
        .s_axi_rready(axi_crossbar_M01_AXI_RREADY),
        .s_axi_rresp(axi_crossbar_M01_AXI_RRESP),
        .s_axi_rvalid(axi_crossbar_M01_AXI_RVALID),
        .s_axi_wdata(axi_crossbar_M01_AXI_WDATA),
        .s_axi_wready(axi_crossbar_M01_AXI_WREADY),
        .s_axi_wstrb(axi_crossbar_M01_AXI_WSTRB),
        .s_axi_wvalid(axi_crossbar_M01_AXI_WVALID),
        .s_axis_sts_sb_tx_tdata(S_AXIS_STS_SB_TX_1_TDATA),
        .s_axis_sts_sb_tx_tready(S_AXIS_STS_SB_TX_1_TREADY),
        .s_axis_sts_sb_tx_tvalid(S_AXIS_STS_SB_TX_1_TVALID),
        .sdi_tx_bridge_ctrl(v_smpte_uhdsdi_tx_sdi_tx_bridge_ctrl),
        .sdi_tx_bridge_sts(v_vid_sdi_tx_bridge_sdi_tx_bridge_sts),
        .tx_ce(v_vid_sdi_tx_bridge_SDI_DS_OUT_TX_CE),
        .tx_clk(sdi_tx_clk_1),
        .tx_ds1_in(v_vid_sdi_tx_bridge_SDI_DS_OUT_DS1),
        .tx_ds2_in(v_vid_sdi_tx_bridge_SDI_DS_OUT_DS2),
        .tx_ds3_in(v_vid_sdi_tx_bridge_SDI_DS_OUT_DS3),
        .tx_ds4_in(v_vid_sdi_tx_bridge_SDI_DS_OUT_DS4),
        .tx_ds5_in(v_vid_sdi_tx_bridge_SDI_DS_OUT_DS5),
        .tx_ds6_in(v_vid_sdi_tx_bridge_SDI_DS_OUT_DS6),
        .tx_ds7_in(v_vid_sdi_tx_bridge_SDI_DS_OUT_DS7),
        .tx_ds8_in(v_vid_sdi_tx_bridge_SDI_DS_OUT_DS8),
        .tx_line_ch0(v_vid_sdi_tx_bridge_SDI_DS_OUT_LN_NUM_1),
        .tx_line_ch1(v_vid_sdi_tx_bridge_SDI_DS_OUT_LN_NUM_2),
        .tx_line_ch2(v_vid_sdi_tx_bridge_SDI_DS_OUT_LN_NUM_3),
        .tx_line_ch3(v_vid_sdi_tx_bridge_SDI_DS_OUT_LN_NUM_4),
        .tx_rst(sdi_tx_rst_1),
        .tx_sd_ce(v_vid_sdi_tx_bridge_SDI_DS_OUT_TX_SD_CE));
  bd_82d8_v_tc_0 v_tc
       (.active_video_out(v_tc_vtiming_out_ACTIVE_VIDEO),
        .clk(sdi_tx_clk_1),
        .clken(1'b1),
        .field_id_out(v_tc_vtiming_out_FIELD),
        .fsync_in(1'b0),
        .gen_clken(v_axi4s_vid_out_vtg_ce),
        .hblank_out(v_tc_vtiming_out_HBLANK),
        .hsync_out(v_tc_vtiming_out_HSYNC),
        .irq(v_tc_irq),
        .resetn(const_1_dout),
        .s_axi_aclk(s_axi_aclk_1),
        .s_axi_aclken(1'b1),
        .s_axi_araddr(axi_crossbar_M00_AXI_ARADDR[8:0]),
        .s_axi_aresetn(s_axi_arstn_1),
        .s_axi_arready(axi_crossbar_M00_AXI_ARREADY),
        .s_axi_arvalid(axi_crossbar_M00_AXI_ARVALID),
        .s_axi_awaddr(axi_crossbar_M00_AXI_AWADDR[8:0]),
        .s_axi_awready(axi_crossbar_M00_AXI_AWREADY),
        .s_axi_awvalid(axi_crossbar_M00_AXI_AWVALID),
        .s_axi_bready(axi_crossbar_M00_AXI_BREADY),
        .s_axi_bresp(axi_crossbar_M00_AXI_BRESP),
        .s_axi_bvalid(axi_crossbar_M00_AXI_BVALID),
        .s_axi_rdata(axi_crossbar_M00_AXI_RDATA),
        .s_axi_rready(axi_crossbar_M00_AXI_RREADY),
        .s_axi_rresp(axi_crossbar_M00_AXI_RRESP),
        .s_axi_rvalid(axi_crossbar_M00_AXI_RVALID),
        .s_axi_wdata(axi_crossbar_M00_AXI_WDATA),
        .s_axi_wready(axi_crossbar_M00_AXI_WREADY),
        .s_axi_wstrb(axi_crossbar_M00_AXI_WSTRB),
        .s_axi_wvalid(axi_crossbar_M00_AXI_WVALID),
        .vblank_out(v_tc_vtiming_out_VBLANK),
        .vsync_out(v_tc_vtiming_out_VSYNC));
  bd_82d8_v_vid_sdi_tx_bridge_0 v_vid_sdi_tx_bridge
       (.clk(sdi_tx_clk_1),
        .rst(sdi_tx_rst_1),
        .sdi_tx_bridge_ctrl(v_smpte_uhdsdi_tx_sdi_tx_bridge_ctrl),
        .sdi_tx_bridge_sts(v_vid_sdi_tx_bridge_sdi_tx_bridge_sts),
        .tx_ce(v_vid_sdi_tx_bridge_SDI_DS_OUT_TX_CE),
        .tx_ds1(v_vid_sdi_tx_bridge_SDI_DS_OUT_DS1),
        .tx_ds2(v_vid_sdi_tx_bridge_SDI_DS_OUT_DS2),
        .tx_ds3(v_vid_sdi_tx_bridge_SDI_DS_OUT_DS3),
        .tx_ds4(v_vid_sdi_tx_bridge_SDI_DS_OUT_DS4),
        .tx_ds5(v_vid_sdi_tx_bridge_SDI_DS_OUT_DS5),
        .tx_ds6(v_vid_sdi_tx_bridge_SDI_DS_OUT_DS6),
        .tx_ds7(v_vid_sdi_tx_bridge_SDI_DS_OUT_DS7),
        .tx_ds8(v_vid_sdi_tx_bridge_SDI_DS_OUT_DS8),
        .tx_line1(v_vid_sdi_tx_bridge_SDI_DS_OUT_LN_NUM_1),
        .tx_line2(v_vid_sdi_tx_bridge_SDI_DS_OUT_LN_NUM_2),
        .tx_line3(v_vid_sdi_tx_bridge_SDI_DS_OUT_LN_NUM_3),
        .tx_line4(v_vid_sdi_tx_bridge_SDI_DS_OUT_LN_NUM_4),
        .tx_sd_ce(v_vid_sdi_tx_bridge_SDI_DS_OUT_TX_SD_CE),
        .vid_active_video(v_axi4s_vid_out_vid_io_out_ACTIVE_VIDEO),
        .vid_ce(v_vid_sdi_tx_bridge_vid_ce),
        .vid_data(v_axi4s_vid_out_vid_io_out_DATA),
        .vid_field_id(v_axi4s_vid_out_vid_io_out_FIELD),
        .vid_hblank(v_axi4s_vid_out_vid_io_out_HBLANK),
        .vid_vblank(v_axi4s_vid_out_vid_io_out_VBLANK));
endmodule
