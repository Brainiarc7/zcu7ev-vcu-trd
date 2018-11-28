// (c) Copyright 1995-2018 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:ip:v_smpte_uhdsdi_tx:1.0
// IP Revision: 0

(* X_CORE_INFO = "v_smpte_uhdsdi_tx_v1_0_0,Vivado 2018.2" *)
(* CHECK_LICENSE_TYPE = "bd_82d8_v_smpte_uhdsdi_tx_0,v_smpte_uhdsdi_tx_v1_0_0,{}" *)
(* CORE_GENERATION_INFO = "bd_82d8_v_smpte_uhdsdi_tx_0,v_smpte_uhdsdi_tx_v1_0_0,{x_ipProduct=Vivado 2018.2,x_ipVendor=xilinx.com,x_ipLibrary=ip,x_ipName=v_smpte_uhdsdi_tx,x_ipVersion=1.0,x_ipCoreRevision=0,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,C_AXI4LITE_ENABLE=1,C_ADV_FEATURE=0,C_INCLUDE_VID_OVER_AXI=1,C_INCLUDE_SDI_BRIDGE=1,C_INCLUDE_TX_EDH_PROCESSOR=1,C_TX_TDATA_WIDTH=40,C_TX_TUSER_WIDTH=32,C_NUM_SYNC_REGS=3,C_LINE_RATE=12G_SDI_8DS,C_AXI_DATA_WIDTH=32,C_AXI_ADDR_WIDTH=9}" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module bd_82d8_v_smpte_uhdsdi_tx_0 (
  tx_clk,
  axis_clk,
  tx_rst,
  axis_rstn,
  tx_ce,
  tx_sd_ce,
  tx_line_ch0,
  tx_line_ch1,
  tx_line_ch2,
  tx_line_ch3,
  tx_ds1_in,
  tx_ds2_in,
  tx_ds3_in,
  tx_ds4_in,
  tx_ds5_in,
  tx_ds6_in,
  tx_ds7_in,
  tx_ds8_in,
  m_axis_tx_tready,
  m_axis_tx_tvalid,
  m_axis_tx_tdata,
  m_axis_tx_tuser,
  m_axis_ctrl_sb_tx_tready,
  m_axis_ctrl_sb_tx_tvalid,
  m_axis_ctrl_sb_tx_tdata,
  s_axis_sts_sb_tx_tready,
  s_axis_sts_sb_tx_tvalid,
  s_axis_sts_sb_tx_tdata,
  sdi_tx_bridge_ctrl,
  sdi_tx_bridge_sts,
  axi4s_vid_out_locked,
  axi4s_vid_out_overflow,
  axi4s_vid_out_underflow,
  axi4s_vid_out_status,
  axi4s_vid_out_vid_rst,
  axi4s_vid_out_vid_rstn,
  axi4s_vid_out_axis_rstn,
  s_axi_aclk,
  s_axi_aresetn,
  s_axi_awaddr,
  s_axi_awprot,
  s_axi_awvalid,
  s_axi_awready,
  s_axi_wdata,
  s_axi_wstrb,
  s_axi_wvalid,
  s_axi_wready,
  s_axi_bresp,
  s_axi_bvalid,
  s_axi_bready,
  s_axi_araddr,
  s_axi_arprot,
  s_axi_arvalid,
  s_axi_arready,
  s_axi_rdata,
  s_axi_rresp,
  s_axi_rvalid,
  s_axi_rready,
  interrupt
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME tx_clk, ASSOCIATED_BUSIF SDI_DS_IN:M_AXIS_TX:M_AXIS_CTRL_SB_TX:S_AXIS_STS_SB_TX:ST352_DATA_IN:SDI_TX_ANC_DS_IN:SDI_TX_ANC_DS_OUT, ASSOCIATED_RESET tx_rst:axi4s_vid_out_vid_rst:axi4s_vid_out_vid_rstn, FREQ_HZ 99999000, PHASE 0.0, CLK_DOMAIN vcu_trd_clk_wiz_1_clk_out1" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 tx_clk CLK" *)
input wire tx_clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME axis_clk, ASSOCIATED_RESET axis_rstn, FREQ_HZ 99999000, PHASE 0.0, CLK_DOMAIN vcu_trd_clk_wiz_1_clk_out1" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 axis_clk CLK" *)
input wire axis_clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME tx_rst, POLARITY ACTIVE_HIGH" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 tx_rst RST" *)
input wire tx_rst;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME axis_rstn, POLARITY ACTIVE_LOW" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 axis_rstn RST" *)
input wire axis_rstn;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_IN TX_CE" *)
input wire tx_ce;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_IN TX_SD_CE" *)
input wire tx_sd_ce;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_IN LN_NUM_1" *)
input wire [10 : 0] tx_line_ch0;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_IN LN_NUM_2" *)
input wire [10 : 0] tx_line_ch1;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_IN LN_NUM_3" *)
input wire [10 : 0] tx_line_ch2;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_IN LN_NUM_4" *)
input wire [10 : 0] tx_line_ch3;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_IN DS1" *)
input wire [9 : 0] tx_ds1_in;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_IN DS2" *)
input wire [9 : 0] tx_ds2_in;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_IN DS3" *)
input wire [9 : 0] tx_ds3_in;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_IN DS4" *)
input wire [9 : 0] tx_ds4_in;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_IN DS5" *)
input wire [9 : 0] tx_ds5_in;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_IN DS6" *)
input wire [9 : 0] tx_ds6_in;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_IN DS7" *)
input wire [9 : 0] tx_ds7_in;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_IN DS8" *)
input wire [9 : 0] tx_ds8_in;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_TX TREADY" *)
input wire m_axis_tx_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_TX TVALID" *)
output wire m_axis_tx_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_TX TDATA" *)
output wire [39 : 0] m_axis_tx_tdata;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXIS_TX, TDATA_NUM_BYTES 5, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 32, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 99999000, PHASE 0.0, CLK_DOMAIN vcu_trd_clk_wiz_1_clk_out1, LAYERED_METADATA undef" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_TX TUSER" *)
output wire [31 : 0] m_axis_tx_tuser;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_CTRL_SB_TX TREADY" *)
input wire m_axis_ctrl_sb_tx_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_CTRL_SB_TX TVALID" *)
output wire m_axis_ctrl_sb_tx_tvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXIS_CTRL_SB_TX, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 99999000, PHASE 0.0, CLK_DOMAIN vcu_trd_clk_wiz_1_clk_out1, LAYERED_METADATA undef" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_CTRL_SB_TX TDATA" *)
output wire [31 : 0] m_axis_ctrl_sb_tx_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_STS_SB_TX TREADY" *)
output wire s_axis_sts_sb_tx_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_STS_SB_TX TVALID" *)
input wire s_axis_sts_sb_tx_tvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXIS_STS_SB_TX, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 99999000, PHASE 0.0, CLK_DOMAIN vcu_trd_clk_wiz_1_clk_out1, LAYERED_METADATA undef" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_STS_SB_TX TDATA" *)
input wire [31 : 0] s_axis_sts_sb_tx_tdata;
output wire [31 : 0] sdi_tx_bridge_ctrl;
input wire [31 : 0] sdi_tx_bridge_sts;
input wire axi4s_vid_out_locked;
input wire axi4s_vid_out_overflow;
input wire axi4s_vid_out_underflow;
input wire [31 : 0] axi4s_vid_out_status;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME axi4s_vid_out_vid_rst, POLARITY ACTIVE_HIGH" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 axi4s_vid_out_vid_rst RST" *)
output wire axi4s_vid_out_vid_rst;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME axi4s_vid_out_vid_rstn, POLARITY ACTIVE_LOW" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 axi4s_vid_out_vid_rstn RST" *)
output wire axi4s_vid_out_vid_rstn;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME axi4s_vid_out_axis_rstn, POLARITY ACTIVE_LOW" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 axi4s_vid_out_axis_rstn RST" *)
output wire axi4s_vid_out_axis_rstn;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axi_aclk, ASSOCIATED_BUSIF S_AXI_CTRL, ASSOCIATED_RESET s_axi_aresetn, FREQ_HZ 99999000, PHASE 0.000, CLK_DOMAIN vcu_trd_zynq_ultra_ps_e_0_1_pl_clk0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 s_axi_aclk CLK" *)
input wire s_axi_aclk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axi_aresetn, POLARITY ACTIVE_LOW" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 s_axi_aresetn RST" *)
input wire s_axi_aresetn;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL AWADDR" *)
input wire [8 : 0] s_axi_awaddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL AWPROT" *)
input wire [2 : 0] s_axi_awprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL AWVALID" *)
input wire s_axi_awvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL AWREADY" *)
output wire s_axi_awready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL WDATA" *)
input wire [31 : 0] s_axi_wdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL WSTRB" *)
input wire [3 : 0] s_axi_wstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL WVALID" *)
input wire s_axi_wvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL WREADY" *)
output wire s_axi_wready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL BRESP" *)
output wire [1 : 0] s_axi_bresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL BVALID" *)
output wire s_axi_bvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL BREADY" *)
input wire s_axi_bready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL ARADDR" *)
input wire [8 : 0] s_axi_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL ARPROT" *)
input wire [2 : 0] s_axi_arprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL ARVALID" *)
input wire s_axi_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL ARREADY" *)
output wire s_axi_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL RDATA" *)
output wire [31 : 0] s_axi_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL RRESP" *)
output wire [1 : 0] s_axi_rresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL RVALID" *)
output wire s_axi_rvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXI_CTRL, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 99999000, ID_WIDTH 0, ADDR_WIDTH 9, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.000, CLK_DOMAIN vcu_trd_zynq_ultra_ps_e_0_1_pl_clk0, NUM_READ_THREADS 1\
, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL RREADY" *)
input wire s_axi_rready;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME interrupt, SENSITIVITY LEVEL_HIGH, PortWidth 1" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 interrupt INTERRUPT" *)
output wire interrupt;

  v_smpte_uhdsdi_tx_v1_0_0 #(
    .C_AXI4LITE_ENABLE(1),
    .C_ADV_FEATURE(0),
    .C_INCLUDE_VID_OVER_AXI(1),
    .C_INCLUDE_SDI_BRIDGE(1),
    .C_INCLUDE_TX_EDH_PROCESSOR(1),
    .C_TX_TDATA_WIDTH(40),
    .C_TX_TUSER_WIDTH(32),
    .C_NUM_SYNC_REGS(3),
    .C_LINE_RATE("12G_SDI_8DS"),
    .C_AXI_DATA_WIDTH(32),
    .C_AXI_ADDR_WIDTH(9)
  ) inst (
    .tx_clk(tx_clk),
    .axis_clk(axis_clk),
    .tx_rst(tx_rst),
    .axis_rstn(axis_rstn),
    .sdi_tx_ctrl(32'B0),
    .tx_ce(tx_ce),
    .tx_sd_ce(tx_sd_ce),
    .tx_line_ch0(tx_line_ch0),
    .tx_line_ch1(tx_line_ch1),
    .tx_line_ch2(tx_line_ch2),
    .tx_line_ch3(tx_line_ch3),
    .tx_line_ch4(11'B0),
    .tx_line_ch5(11'B0),
    .tx_line_ch6(11'B0),
    .tx_line_ch7(11'B0),
    .tx_st352_line_f1(11'B0),
    .tx_st352_line_f2(11'B0),
    .tx_st352_data_ch0(32'B0),
    .tx_st352_data_ch1(32'B0),
    .tx_st352_data_ch2(32'B0),
    .tx_st352_data_ch3(32'B0),
    .tx_st352_data_ch4(32'B0),
    .tx_st352_data_ch5(32'B0),
    .tx_st352_data_ch6(32'B0),
    .tx_st352_data_ch7(32'B0),
    .tx_ds1_in(tx_ds1_in),
    .tx_ds2_in(tx_ds2_in),
    .tx_ds3_in(tx_ds3_in),
    .tx_ds4_in(tx_ds4_in),
    .tx_ds5_in(tx_ds5_in),
    .tx_ds6_in(tx_ds6_in),
    .tx_ds7_in(tx_ds7_in),
    .tx_ds8_in(tx_ds8_in),
    .tx_ds9_in(10'B0),
    .tx_ds10_in(10'B0),
    .tx_ds11_in(10'B0),
    .tx_ds12_in(10'B0),
    .tx_ds13_in(10'B0),
    .tx_ds14_in(10'B0),
    .tx_ds15_in(10'B0),
    .tx_ds16_in(10'B0),
    .tx_ds1_st352_out(),
    .tx_ds2_st352_out(),
    .tx_ds3_st352_out(),
    .tx_ds4_st352_out(),
    .tx_ds5_st352_out(),
    .tx_ds6_st352_out(),
    .tx_ds7_st352_out(),
    .tx_ds8_st352_out(),
    .tx_ds9_st352_out(),
    .tx_ds10_st352_out(),
    .tx_ds11_st352_out(),
    .tx_ds12_st352_out(),
    .tx_ds13_st352_out(),
    .tx_ds14_st352_out(),
    .tx_ds15_st352_out(),
    .tx_ds16_st352_out(),
    .tx_ds1_anc_in(10'B0),
    .tx_ds2_anc_in(10'B0),
    .tx_ds3_anc_in(10'B0),
    .tx_ds4_anc_in(10'B0),
    .tx_ds5_anc_in(10'B0),
    .tx_ds6_anc_in(10'B0),
    .tx_ds7_anc_in(10'B0),
    .tx_ds8_anc_in(10'B0),
    .tx_ds9_anc_in(10'B0),
    .tx_ds10_anc_in(10'B0),
    .tx_ds11_anc_in(10'B0),
    .tx_ds12_anc_in(10'B0),
    .tx_ds13_anc_in(10'B0),
    .tx_ds14_anc_in(10'B0),
    .tx_ds15_anc_in(10'B0),
    .tx_ds16_anc_in(10'B0),
    .sdi_tx_err(),
    .sdi_tx_anc_ctrl_out(),
    .m_axis_tx_tready(m_axis_tx_tready),
    .m_axis_tx_tvalid(m_axis_tx_tvalid),
    .m_axis_tx_tdata(m_axis_tx_tdata),
    .m_axis_tx_tuser(m_axis_tx_tuser),
    .m_axis_ctrl_sb_tx_tready(m_axis_ctrl_sb_tx_tready),
    .m_axis_ctrl_sb_tx_tvalid(m_axis_ctrl_sb_tx_tvalid),
    .m_axis_ctrl_sb_tx_tdata(m_axis_ctrl_sb_tx_tdata),
    .s_axis_sts_sb_tx_tready(s_axis_sts_sb_tx_tready),
    .s_axis_sts_sb_tx_tvalid(s_axis_sts_sb_tx_tvalid),
    .s_axis_sts_sb_tx_tdata(s_axis_sts_sb_tx_tdata),
    .sdi_tx_bridge_ctrl(sdi_tx_bridge_ctrl),
    .sdi_tx_bridge_sts(sdi_tx_bridge_sts),
    .axi4s_vid_out_locked(axi4s_vid_out_locked),
    .axi4s_vid_out_overflow(axi4s_vid_out_overflow),
    .axi4s_vid_out_underflow(axi4s_vid_out_underflow),
    .axi4s_vid_out_status(axi4s_vid_out_status),
    .axi4s_vid_out_vid_rst(axi4s_vid_out_vid_rst),
    .axi4s_vid_out_vid_rstn(axi4s_vid_out_vid_rstn),
    .axi4s_vid_out_axis_rstn(axi4s_vid_out_axis_rstn),
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),
    .s_axi_awaddr(s_axi_awaddr),
    .s_axi_awprot(s_axi_awprot),
    .s_axi_awvalid(s_axi_awvalid),
    .s_axi_awready(s_axi_awready),
    .s_axi_wdata(s_axi_wdata),
    .s_axi_wstrb(s_axi_wstrb),
    .s_axi_wvalid(s_axi_wvalid),
    .s_axi_wready(s_axi_wready),
    .s_axi_bresp(s_axi_bresp),
    .s_axi_bvalid(s_axi_bvalid),
    .s_axi_bready(s_axi_bready),
    .s_axi_araddr(s_axi_araddr),
    .s_axi_arprot(s_axi_arprot),
    .s_axi_arvalid(s_axi_arvalid),
    .s_axi_arready(s_axi_arready),
    .s_axi_rdata(s_axi_rdata),
    .s_axi_rresp(s_axi_rresp),
    .s_axi_rvalid(s_axi_rvalid),
    .s_axi_rready(s_axi_rready),
    .interrupt(interrupt)
  );
endmodule
