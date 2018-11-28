//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Command: generate_target bd_22f3.bd
//Design : bd_22f3
//Purpose: IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "bd_22f3,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=bd_22f3,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=3,numReposBlks=3,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=SBD,synth_mode=Global}" *) (* HW_HANDOFF = "vcu_trd_v_smpte_uhdsdi_rx_ss_0_0.hwdef" *) 
module bd_22f3
   (M_AXIS_CTRL_SB_RX_tdata,
    M_AXIS_CTRL_SB_RX_tready,
    M_AXIS_CTRL_SB_RX_tvalid,
    SDI_TS_DET_OUT_rx_t_family,
    SDI_TS_DET_OUT_rx_t_locked,
    SDI_TS_DET_OUT_rx_t_rate,
    SDI_TS_DET_OUT_rx_t_scan,
    S_AXIS_RX_tdata,
    S_AXIS_RX_tready,
    S_AXIS_RX_tuser,
    S_AXIS_RX_tvalid,
    S_AXIS_STS_SB_RX_tdata,
    S_AXIS_STS_SB_RX_tready,
    S_AXIS_STS_SB_RX_tvalid,
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
    VIDEO_OUT_tdata,
    VIDEO_OUT_tlast,
    VIDEO_OUT_tready,
    VIDEO_OUT_tuser,
    VIDEO_OUT_tvalid,
    fid,
    s_axi_aclk,
    s_axi_arstn,
    sdi_rx_clk,
    sdi_rx_irq,
    sdi_rx_rst,
    video_out_arstn,
    video_out_clk);
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_CTRL_SB_RX TDATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXIS_CTRL_SB_RX, CLK_DOMAIN vcu_trd_clk_wiz_1_clk_out1, FREQ_HZ 99999000, HAS_TKEEP 0, HAS_TLAST 0, HAS_TREADY 1, HAS_TSTRB 0, LAYERED_METADATA undef, PHASE 0.0, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0" *) output [31:0]M_AXIS_CTRL_SB_RX_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_CTRL_SB_RX TREADY" *) input M_AXIS_CTRL_SB_RX_tready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_CTRL_SB_RX TVALID" *) output M_AXIS_CTRL_SB_RX_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_TS_DET_OUT RX_T_FAMILY" *) output [3:0]SDI_TS_DET_OUT_rx_t_family;
  (* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_TS_DET_OUT RX_T_LOCKED" *) output SDI_TS_DET_OUT_rx_t_locked;
  (* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_TS_DET_OUT RX_T_RATE" *) output [3:0]SDI_TS_DET_OUT_rx_t_rate;
  (* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_TS_DET_OUT RX_T_SCAN" *) output SDI_TS_DET_OUT_rx_t_scan;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_RX TDATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXIS_RX, CLK_DOMAIN vcu_trd_clk_wiz_1_clk_out1, FREQ_HZ 99999000, HAS_TKEEP 0, HAS_TLAST 0, HAS_TREADY 1, HAS_TSTRB 0, LAYERED_METADATA undef, PHASE 0.0, TDATA_NUM_BYTES 5, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 32" *) input [39:0]S_AXIS_RX_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_RX TREADY" *) output S_AXIS_RX_tready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_RX TUSER" *) input [31:0]S_AXIS_RX_tuser;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_RX TVALID" *) input S_AXIS_RX_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_STS_SB_RX TDATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXIS_STS_SB_RX, CLK_DOMAIN vcu_trd_clk_wiz_1_clk_out1, FREQ_HZ 99999000, HAS_TKEEP 0, HAS_TLAST 0, HAS_TREADY 1, HAS_TSTRB 0, LAYERED_METADATA undef, PHASE 0.0, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0" *) input [31:0]S_AXIS_STS_SB_RX_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_STS_SB_RX TREADY" *) output S_AXIS_STS_SB_RX_tready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_STS_SB_RX TVALID" *) input S_AXIS_STS_SB_RX_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL ARADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXI_CTRL, ADDR_WIDTH 16, ARUSER_WIDTH 0, AWUSER_WIDTH 0, BUSER_WIDTH 0, CLK_DOMAIN vcu_trd_zynq_ultra_ps_e_0_1_pl_clk0, DATA_WIDTH 32, FREQ_HZ 99999000, HAS_BRESP 1, HAS_BURST 0, HAS_CACHE 0, HAS_LOCK 0, HAS_PROT 1, HAS_QOS 0, HAS_REGION 0, HAS_RRESP 1, HAS_WSTRB 1, ID_WIDTH 0, MAX_BURST_LENGTH 1, NUM_READ_OUTSTANDING 2, NUM_READ_THREADS 1, NUM_WRITE_OUTSTANDING 2, NUM_WRITE_THREADS 1, PHASE 0.000, PROTOCOL AXI4LITE, READ_WRITE_MODE READ_WRITE, RUSER_BITS_PER_BYTE 0, RUSER_WIDTH 0, SUPPORTS_NARROW_BURST 0, WUSER_BITS_PER_BYTE 0, WUSER_WIDTH 0" *) input [8:0]S_AXI_CTRL_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL ARPROT" *) input [2:0]S_AXI_CTRL_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL ARREADY" *) output S_AXI_CTRL_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL ARVALID" *) input S_AXI_CTRL_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL AWADDR" *) input [8:0]S_AXI_CTRL_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL AWPROT" *) input [2:0]S_AXI_CTRL_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL AWREADY" *) output S_AXI_CTRL_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL AWVALID" *) input S_AXI_CTRL_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL BREADY" *) input S_AXI_CTRL_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL BRESP" *) output [1:0]S_AXI_CTRL_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL BVALID" *) output S_AXI_CTRL_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL RDATA" *) output [31:0]S_AXI_CTRL_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL RREADY" *) input S_AXI_CTRL_rready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL RRESP" *) output [1:0]S_AXI_CTRL_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL RVALID" *) output S_AXI_CTRL_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL WDATA" *) input [31:0]S_AXI_CTRL_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL WREADY" *) output S_AXI_CTRL_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL WSTRB" *) input [3:0]S_AXI_CTRL_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL WVALID" *) input S_AXI_CTRL_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 VIDEO_OUT TDATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME VIDEO_OUT, CLK_DOMAIN vcu_trd_clk_wiz_1_clk_out1, FREQ_HZ 99999000, HAS_TKEEP 0, HAS_TLAST 1, HAS_TREADY 1, HAS_TSTRB 0, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {TDATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value xilinx.com:video:G_B_R_444:1.0} bitwidth {attribs {resolve_type automatic dependency {} format long minimum {} maximum {}} value 30} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} array_type {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value rows} size {attribs {resolve_type generated dependency active_rows format long minimum {} maximum {}} value 1} stride {attribs {resolve_type generated dependency active_rows_stride format long minimum {} maximum {}} value 32} datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type automatic dependency {} format long minimum {} maximum {}} value 30} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} array_type {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value cols} size {attribs {resolve_type generated dependency active_cols format long minimum {} maximum {}} value 1} stride {attribs {resolve_type generated dependency active_cols_stride format long minimum {} maximum {}} value 32} datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type automatic dependency {} format long minimum {} maximum {}} value 30} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} struct {field_G {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value G} enabled {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value true} datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type generated dependency video_data_width format long minimum {} maximum {}} value 10} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} integer {signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value true}}}} field_B {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value B} enabled {attribs {resolve_type generated dependency video_comp1_enabled format bool minimum {} maximum {}} value true} datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type generated dependency video_data_width format long minimum {} maximum {}} value 10} bitoffset {attribs {resolve_type generated dependency video_comp1_offset format long minimum {} maximum {}} value 10} integer {signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value true}}}} field_R {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value R} enabled {attribs {resolve_type generated dependency video_comp2_enabled format bool minimum {} maximum {}} value true} datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type generated dependency video_data_width format long minimum {} maximum {}} value 10} bitoffset {attribs {resolve_type generated dependency video_comp2_offset format long minimum {} maximum {}} value 20} integer {signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value true}}}}}}}}}}} TDATA_WIDTH 32}, PHASE 0.0, TDATA_NUM_BYTES 8, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 1" *) output [63:0]VIDEO_OUT_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 VIDEO_OUT TLAST" *) output VIDEO_OUT_tlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 VIDEO_OUT TREADY" *) input VIDEO_OUT_tready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 VIDEO_OUT TUSER" *) output VIDEO_OUT_tuser;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 VIDEO_OUT TVALID" *) output VIDEO_OUT_tvalid;
  output fid;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.S_AXI_ACLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.S_AXI_ACLK, ASSOCIATED_BUSIF S_AXI_CTRL, ASSOCIATED_RESET s_axi_arstn, CLK_DOMAIN vcu_trd_zynq_ultra_ps_e_0_1_pl_clk0, FREQ_HZ 99999000, PHASE 0.000" *) input s_axi_aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.S_AXI_ARSTN RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.S_AXI_ARSTN, POLARITY ACTIVE_LOW" *) input s_axi_arstn;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.SDI_RX_CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.SDI_RX_CLK, ASSOCIATED_BUSIF M_AXIS_CTRL_SB_RX:SDI_TS_DET_OUT:S_AXIS_RX:S_AXIS_STS_SB_RX, ASSOCIATED_RESET sdi_rx_rst, CLK_DOMAIN vcu_trd_clk_wiz_1_clk_out1, FREQ_HZ 99999000, PHASE 0.0" *) input sdi_rx_clk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 INTR.SDI_RX_IRQ INTERRUPT" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME INTR.SDI_RX_IRQ, PortWidth 1, SENSITIVITY LEVEL_HIGH" *) output sdi_rx_irq;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.SDI_RX_RST RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.SDI_RX_RST, POLARITY ACTIVE_HIGH" *) input sdi_rx_rst;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.VIDEO_OUT_ARSTN RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.VIDEO_OUT_ARSTN, POLARITY ACTIVE_LOW" *) input video_out_arstn;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.VIDEO_OUT_CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.VIDEO_OUT_CLK, ASSOCIATED_BUSIF VIDEO_OUT, ASSOCIATED_RESET video_out_arstn, CLK_DOMAIN vcu_trd_clk_wiz_1_clk_out1, FREQ_HZ 99999000, PHASE 0.0" *) input video_out_clk;

  wire [39:0]S_AXIS_RX_1_TDATA;
  wire S_AXIS_RX_1_TREADY;
  wire [31:0]S_AXIS_RX_1_TUSER;
  wire S_AXIS_RX_1_TVALID;
  wire [31:0]S_AXIS_STS_SB_RX_1_TDATA;
  wire S_AXIS_STS_SB_RX_1_TREADY;
  wire S_AXIS_STS_SB_RX_1_TVALID;
  wire [8:0]S_AXI_CTRL_1_ARADDR;
  wire [2:0]S_AXI_CTRL_1_ARPROT;
  wire S_AXI_CTRL_1_ARREADY;
  wire S_AXI_CTRL_1_ARVALID;
  wire [8:0]S_AXI_CTRL_1_AWADDR;
  wire [2:0]S_AXI_CTRL_1_AWPROT;
  wire S_AXI_CTRL_1_AWREADY;
  wire S_AXI_CTRL_1_AWVALID;
  wire S_AXI_CTRL_1_BREADY;
  wire [1:0]S_AXI_CTRL_1_BRESP;
  wire S_AXI_CTRL_1_BVALID;
  wire [31:0]S_AXI_CTRL_1_RDATA;
  wire S_AXI_CTRL_1_RREADY;
  wire [1:0]S_AXI_CTRL_1_RRESP;
  wire S_AXI_CTRL_1_RVALID;
  wire [31:0]S_AXI_CTRL_1_WDATA;
  wire S_AXI_CTRL_1_WREADY;
  wire [3:0]S_AXI_CTRL_1_WSTRB;
  wire S_AXI_CTRL_1_WVALID;
  wire s_axi_aclk_1;
  wire s_axi_arstn_1;
  wire sdi_rx_clk_1;
  wire sdi_rx_rst_1;
  wire v_sdi_rx_vid_bridge_VID_IO_OUT_ACTIVE_VIDEO;
  wire [59:0]v_sdi_rx_vid_bridge_VID_IO_OUT_DATA;
  wire v_sdi_rx_vid_bridge_VID_IO_OUT_FIELD;
  wire v_sdi_rx_vid_bridge_VID_IO_OUT_HBLANK;
  wire v_sdi_rx_vid_bridge_VID_IO_OUT_VBLANK;
  wire [31:0]v_sdi_rx_vid_bridge_sdi_rx_bridge_sts;
  wire v_sdi_rx_vid_bridge_vid_ce;
  wire [31:0]v_smpte_uhdsdi_rx_M_AXIS_CTRL_SB_RX_TDATA;
  wire v_smpte_uhdsdi_rx_M_AXIS_CTRL_SB_RX_TREADY;
  wire v_smpte_uhdsdi_rx_M_AXIS_CTRL_SB_RX_TVALID;
  wire [9:0]v_smpte_uhdsdi_rx_SDI_DS_OUT_DS1;
  wire [9:0]v_smpte_uhdsdi_rx_SDI_DS_OUT_DS2;
  wire [9:0]v_smpte_uhdsdi_rx_SDI_DS_OUT_DS3;
  wire [9:0]v_smpte_uhdsdi_rx_SDI_DS_OUT_DS4;
  wire [9:0]v_smpte_uhdsdi_rx_SDI_DS_OUT_DS5;
  wire [9:0]v_smpte_uhdsdi_rx_SDI_DS_OUT_DS6;
  wire [9:0]v_smpte_uhdsdi_rx_SDI_DS_OUT_DS7;
  wire [9:0]v_smpte_uhdsdi_rx_SDI_DS_OUT_DS8;
  wire v_smpte_uhdsdi_rx_SDI_DS_OUT_LEVEL_B_3G;
  wire [0:0]v_smpte_uhdsdi_rx_SDI_DS_OUT_RX_CE_OUT;
  wire v_smpte_uhdsdi_rx_SDI_DS_OUT_RX_MODE_LOCKED;
  wire [2:0]v_smpte_uhdsdi_rx_SDI_DS_OUT_SDI_MODE;
  wire [3:0]v_smpte_uhdsdi_rx_SDI_TS_DET_OUT_RX_T_FAMILY;
  wire v_smpte_uhdsdi_rx_SDI_TS_DET_OUT_RX_T_LOCKED;
  wire [3:0]v_smpte_uhdsdi_rx_SDI_TS_DET_OUT_RX_T_RATE;
  wire v_smpte_uhdsdi_rx_SDI_TS_DET_OUT_RX_T_SCAN;
  wire v_smpte_uhdsdi_rx_interrupt;
  wire [31:0]v_smpte_uhdsdi_rx_sdi_rx_bridge_ctrl;
  wire v_smpte_uhdsdi_rx_vid_in_axi4s_axis_enable;
  wire v_smpte_uhdsdi_rx_vid_in_axi4s_axis_rstn;
  wire v_smpte_uhdsdi_rx_vid_in_axi4s_vid_rst;
  wire v_vid_in_axi4s_fid;
  wire v_vid_in_axi4s_overflow;
  wire v_vid_in_axi4s_underflow;
  wire [63:0]v_vid_in_axi4s_video_out_TDATA;
  wire v_vid_in_axi4s_video_out_TLAST;
  wire v_vid_in_axi4s_video_out_TREADY;
  wire v_vid_in_axi4s_video_out_TUSER;
  wire v_vid_in_axi4s_video_out_TVALID;
  wire video_out_arstn_1;
  wire video_out_clk_1;

  assign M_AXIS_CTRL_SB_RX_tdata[31:0] = v_smpte_uhdsdi_rx_M_AXIS_CTRL_SB_RX_TDATA;
  assign M_AXIS_CTRL_SB_RX_tvalid = v_smpte_uhdsdi_rx_M_AXIS_CTRL_SB_RX_TVALID;
  assign SDI_TS_DET_OUT_rx_t_family[3:0] = v_smpte_uhdsdi_rx_SDI_TS_DET_OUT_RX_T_FAMILY;
  assign SDI_TS_DET_OUT_rx_t_locked = v_smpte_uhdsdi_rx_SDI_TS_DET_OUT_RX_T_LOCKED;
  assign SDI_TS_DET_OUT_rx_t_rate[3:0] = v_smpte_uhdsdi_rx_SDI_TS_DET_OUT_RX_T_RATE;
  assign SDI_TS_DET_OUT_rx_t_scan = v_smpte_uhdsdi_rx_SDI_TS_DET_OUT_RX_T_SCAN;
  assign S_AXIS_RX_1_TDATA = S_AXIS_RX_tdata[39:0];
  assign S_AXIS_RX_1_TUSER = S_AXIS_RX_tuser[31:0];
  assign S_AXIS_RX_1_TVALID = S_AXIS_RX_tvalid;
  assign S_AXIS_RX_tready = S_AXIS_RX_1_TREADY;
  assign S_AXIS_STS_SB_RX_1_TDATA = S_AXIS_STS_SB_RX_tdata[31:0];
  assign S_AXIS_STS_SB_RX_1_TVALID = S_AXIS_STS_SB_RX_tvalid;
  assign S_AXIS_STS_SB_RX_tready = S_AXIS_STS_SB_RX_1_TREADY;
  assign S_AXI_CTRL_1_ARADDR = S_AXI_CTRL_araddr[8:0];
  assign S_AXI_CTRL_1_ARPROT = S_AXI_CTRL_arprot[2:0];
  assign S_AXI_CTRL_1_ARVALID = S_AXI_CTRL_arvalid;
  assign S_AXI_CTRL_1_AWADDR = S_AXI_CTRL_awaddr[8:0];
  assign S_AXI_CTRL_1_AWPROT = S_AXI_CTRL_awprot[2:0];
  assign S_AXI_CTRL_1_AWVALID = S_AXI_CTRL_awvalid;
  assign S_AXI_CTRL_1_BREADY = S_AXI_CTRL_bready;
  assign S_AXI_CTRL_1_RREADY = S_AXI_CTRL_rready;
  assign S_AXI_CTRL_1_WDATA = S_AXI_CTRL_wdata[31:0];
  assign S_AXI_CTRL_1_WSTRB = S_AXI_CTRL_wstrb[3:0];
  assign S_AXI_CTRL_1_WVALID = S_AXI_CTRL_wvalid;
  assign S_AXI_CTRL_arready = S_AXI_CTRL_1_ARREADY;
  assign S_AXI_CTRL_awready = S_AXI_CTRL_1_AWREADY;
  assign S_AXI_CTRL_bresp[1:0] = S_AXI_CTRL_1_BRESP;
  assign S_AXI_CTRL_bvalid = S_AXI_CTRL_1_BVALID;
  assign S_AXI_CTRL_rdata[31:0] = S_AXI_CTRL_1_RDATA;
  assign S_AXI_CTRL_rresp[1:0] = S_AXI_CTRL_1_RRESP;
  assign S_AXI_CTRL_rvalid = S_AXI_CTRL_1_RVALID;
  assign S_AXI_CTRL_wready = S_AXI_CTRL_1_WREADY;
  assign VIDEO_OUT_tdata[63:0] = v_vid_in_axi4s_video_out_TDATA;
  assign VIDEO_OUT_tlast = v_vid_in_axi4s_video_out_TLAST;
  assign VIDEO_OUT_tuser = v_vid_in_axi4s_video_out_TUSER;
  assign VIDEO_OUT_tvalid = v_vid_in_axi4s_video_out_TVALID;
  assign fid = v_vid_in_axi4s_fid;
  assign s_axi_aclk_1 = s_axi_aclk;
  assign s_axi_arstn_1 = s_axi_arstn;
  assign sdi_rx_clk_1 = sdi_rx_clk;
  assign sdi_rx_irq = v_smpte_uhdsdi_rx_interrupt;
  assign sdi_rx_rst_1 = sdi_rx_rst;
  assign v_smpte_uhdsdi_rx_M_AXIS_CTRL_SB_RX_TREADY = M_AXIS_CTRL_SB_RX_tready;
  assign v_vid_in_axi4s_video_out_TREADY = VIDEO_OUT_tready;
  assign video_out_arstn_1 = video_out_arstn;
  assign video_out_clk_1 = video_out_clk;
  bd_22f3_v_sdi_rx_vid_bridge_0 v_sdi_rx_vid_bridge
       (.clk(sdi_rx_clk_1),
        .rst(sdi_rx_rst_1),
        .rx_ce(v_smpte_uhdsdi_rx_SDI_DS_OUT_RX_CE_OUT),
        .rx_ds1(v_smpte_uhdsdi_rx_SDI_DS_OUT_DS1),
        .rx_ds2(v_smpte_uhdsdi_rx_SDI_DS_OUT_DS2),
        .rx_ds3(v_smpte_uhdsdi_rx_SDI_DS_OUT_DS3),
        .rx_ds4(v_smpte_uhdsdi_rx_SDI_DS_OUT_DS4),
        .rx_ds5(v_smpte_uhdsdi_rx_SDI_DS_OUT_DS5),
        .rx_ds6(v_smpte_uhdsdi_rx_SDI_DS_OUT_DS6),
        .rx_ds7(v_smpte_uhdsdi_rx_SDI_DS_OUT_DS7),
        .rx_ds8(v_smpte_uhdsdi_rx_SDI_DS_OUT_DS8),
        .rx_level_b(v_smpte_uhdsdi_rx_SDI_DS_OUT_LEVEL_B_3G),
        .rx_mode(v_smpte_uhdsdi_rx_SDI_DS_OUT_SDI_MODE),
        .rx_mode_locked(v_smpte_uhdsdi_rx_SDI_DS_OUT_RX_MODE_LOCKED),
        .sdi_rx_bridge_ctrl(v_smpte_uhdsdi_rx_sdi_rx_bridge_ctrl),
        .sdi_rx_bridge_sts(v_sdi_rx_vid_bridge_sdi_rx_bridge_sts),
        .vid_active_video(v_sdi_rx_vid_bridge_VID_IO_OUT_ACTIVE_VIDEO),
        .vid_ce(v_sdi_rx_vid_bridge_vid_ce),
        .vid_data(v_sdi_rx_vid_bridge_VID_IO_OUT_DATA),
        .vid_field_id(v_sdi_rx_vid_bridge_VID_IO_OUT_FIELD),
        .vid_hblank(v_sdi_rx_vid_bridge_VID_IO_OUT_HBLANK),
        .vid_vblank(v_sdi_rx_vid_bridge_VID_IO_OUT_VBLANK));
  bd_22f3_v_smpte_uhdsdi_rx_0 v_smpte_uhdsdi_rx
       (.axis_clk(video_out_clk_1),
        .axis_rstn(video_out_arstn_1),
        .interrupt(v_smpte_uhdsdi_rx_interrupt),
        .m_axis_ctrl_sb_rx_tdata(v_smpte_uhdsdi_rx_M_AXIS_CTRL_SB_RX_TDATA),
        .m_axis_ctrl_sb_rx_tready(v_smpte_uhdsdi_rx_M_AXIS_CTRL_SB_RX_TREADY),
        .m_axis_ctrl_sb_rx_tvalid(v_smpte_uhdsdi_rx_M_AXIS_CTRL_SB_RX_TVALID),
        .rx_ce_out(v_smpte_uhdsdi_rx_SDI_DS_OUT_RX_CE_OUT),
        .rx_clk(sdi_rx_clk_1),
        .rx_ds1(v_smpte_uhdsdi_rx_SDI_DS_OUT_DS1),
        .rx_ds2(v_smpte_uhdsdi_rx_SDI_DS_OUT_DS2),
        .rx_ds3(v_smpte_uhdsdi_rx_SDI_DS_OUT_DS3),
        .rx_ds4(v_smpte_uhdsdi_rx_SDI_DS_OUT_DS4),
        .rx_ds5(v_smpte_uhdsdi_rx_SDI_DS_OUT_DS5),
        .rx_ds6(v_smpte_uhdsdi_rx_SDI_DS_OUT_DS6),
        .rx_ds7(v_smpte_uhdsdi_rx_SDI_DS_OUT_DS7),
        .rx_ds8(v_smpte_uhdsdi_rx_SDI_DS_OUT_DS8),
        .rx_level_b_3g(v_smpte_uhdsdi_rx_SDI_DS_OUT_LEVEL_B_3G),
        .rx_mode(v_smpte_uhdsdi_rx_SDI_DS_OUT_SDI_MODE),
        .rx_mode_locked(v_smpte_uhdsdi_rx_SDI_DS_OUT_RX_MODE_LOCKED),
        .rx_rst(sdi_rx_rst_1),
        .rx_t_family(v_smpte_uhdsdi_rx_SDI_TS_DET_OUT_RX_T_FAMILY),
        .rx_t_locked(v_smpte_uhdsdi_rx_SDI_TS_DET_OUT_RX_T_LOCKED),
        .rx_t_rate(v_smpte_uhdsdi_rx_SDI_TS_DET_OUT_RX_T_RATE),
        .rx_t_scan(v_smpte_uhdsdi_rx_SDI_TS_DET_OUT_RX_T_SCAN),
        .s_axi_aclk(s_axi_aclk_1),
        .s_axi_araddr(S_AXI_CTRL_1_ARADDR),
        .s_axi_aresetn(s_axi_arstn_1),
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
        .s_axi_wvalid(S_AXI_CTRL_1_WVALID),
        .s_axis_rx_tdata(S_AXIS_RX_1_TDATA),
        .s_axis_rx_tready(S_AXIS_RX_1_TREADY),
        .s_axis_rx_tuser(S_AXIS_RX_1_TUSER),
        .s_axis_rx_tvalid(S_AXIS_RX_1_TVALID),
        .s_axis_sts_sb_rx_tdata(S_AXIS_STS_SB_RX_1_TDATA),
        .s_axis_sts_sb_rx_tready(S_AXIS_STS_SB_RX_1_TREADY),
        .s_axis_sts_sb_rx_tvalid(S_AXIS_STS_SB_RX_1_TVALID),
        .sdi_rx_bridge_ctrl(v_smpte_uhdsdi_rx_sdi_rx_bridge_ctrl),
        .sdi_rx_bridge_sts(v_sdi_rx_vid_bridge_sdi_rx_bridge_sts),
        .vid_in_axi4s_axis_enable(v_smpte_uhdsdi_rx_vid_in_axi4s_axis_enable),
        .vid_in_axi4s_axis_rstn(v_smpte_uhdsdi_rx_vid_in_axi4s_axis_rstn),
        .vid_in_axi4s_overflow(v_vid_in_axi4s_overflow),
        .vid_in_axi4s_underflow(v_vid_in_axi4s_underflow),
        .vid_in_axi4s_vid_rst(v_smpte_uhdsdi_rx_vid_in_axi4s_vid_rst));
  bd_22f3_v_vid_in_axi4s_0 v_vid_in_axi4s
       (.aclk(video_out_clk_1),
        .aclken(1'b1),
        .aresetn(v_smpte_uhdsdi_rx_vid_in_axi4s_axis_rstn),
        .axis_enable(v_smpte_uhdsdi_rx_vid_in_axi4s_axis_enable),
        .fid(v_vid_in_axi4s_fid),
        .m_axis_video_tdata(v_vid_in_axi4s_video_out_TDATA),
        .m_axis_video_tlast(v_vid_in_axi4s_video_out_TLAST),
        .m_axis_video_tready(v_vid_in_axi4s_video_out_TREADY),
        .m_axis_video_tuser(v_vid_in_axi4s_video_out_TUSER),
        .m_axis_video_tvalid(v_vid_in_axi4s_video_out_TVALID),
        .overflow(v_vid_in_axi4s_overflow),
        .underflow(v_vid_in_axi4s_underflow),
        .vid_active_video(v_sdi_rx_vid_bridge_VID_IO_OUT_ACTIVE_VIDEO),
        .vid_data(v_sdi_rx_vid_bridge_VID_IO_OUT_DATA),
        .vid_field_id(v_sdi_rx_vid_bridge_VID_IO_OUT_FIELD),
        .vid_hblank(v_sdi_rx_vid_bridge_VID_IO_OUT_HBLANK),
        .vid_hsync(1'b0),
        .vid_io_in_ce(v_sdi_rx_vid_bridge_vid_ce),
        .vid_io_in_clk(sdi_rx_clk_1),
        .vid_io_in_reset(v_smpte_uhdsdi_rx_vid_in_axi4s_vid_rst),
        .vid_vblank(v_sdi_rx_vid_bridge_VID_IO_OUT_VBLANK),
        .vid_vsync(1'b0));
endmodule
