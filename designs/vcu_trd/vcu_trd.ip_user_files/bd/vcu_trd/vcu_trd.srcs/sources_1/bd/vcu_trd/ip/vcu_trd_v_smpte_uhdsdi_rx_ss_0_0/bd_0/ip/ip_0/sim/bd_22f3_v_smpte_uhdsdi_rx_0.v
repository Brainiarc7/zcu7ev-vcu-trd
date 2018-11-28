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


// IP VLNV: xilinx.com:ip:v_smpte_uhdsdi_rx:1.0
// IP Revision: 0

`timescale 1ns/1ps

(* DowngradeIPIdentifiedWarnings = "yes" *)
module bd_22f3_v_smpte_uhdsdi_rx_0 (
  rx_clk,
  axis_clk,
  rx_rst,
  axis_rstn,
  rx_mode_locked,
  rx_mode,
  rx_mode_hd,
  rx_mode_sd,
  rx_mode_3g,
  rx_mode_6g,
  rx_mode_12g,
  rx_level_b_3g,
  rx_ce_out,
  rx_active_streams,
  rx_eav,
  rx_sav,
  rx_trs,
  rx_t_locked,
  rx_t_family,
  rx_t_rate,
  rx_t_scan,
  rx_ln_ds1,
  rx_ln_ds2,
  rx_ln_ds3,
  rx_ln_ds4,
  rx_ln_ds5,
  rx_ln_ds6,
  rx_ln_ds7,
  rx_ln_ds8,
  rx_ds1,
  rx_ds2,
  rx_ds3,
  rx_ds4,
  rx_ds5,
  rx_ds6,
  rx_ds7,
  rx_ds8,
  s_axis_rx_tready,
  s_axis_rx_tvalid,
  s_axis_rx_tdata,
  s_axis_rx_tuser,
  m_axis_ctrl_sb_rx_tready,
  m_axis_ctrl_sb_rx_tvalid,
  m_axis_ctrl_sb_rx_tdata,
  s_axis_sts_sb_rx_tready,
  s_axis_sts_sb_rx_tvalid,
  s_axis_sts_sb_rx_tdata,
  sdi_rx_bridge_ctrl,
  vid_in_axi4s_vid_rst,
  vid_in_axi4s_vid_rstn,
  vid_in_axi4s_axis_rstn,
  vid_in_axi4s_axis_enable,
  sdi_rx_bridge_sts,
  vid_in_axi4s_overflow,
  vid_in_axi4s_underflow,
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
  interrupt,
  rx_mode_locked_sts,
  rx_mode_sts,
  rx_mode_hd_sts,
  rx_mode_sd_sts,
  rx_mode_3g_sts,
  rx_mode_6g_sts,
  rx_mode_12g_sts,
  rx_level_b_3g_sts,
  rx_ce_out_sts,
  rx_active_streams_sts,
  rx_eav_sts,
  rx_sav_sts,
  rx_trs_sts
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME rx_clk, ASSOCIATED_BUSIF S_AXIS_RX:M_AXIS_CTRL_SB_RX:S_AXIS_STS_SB_RX:SDI_DS_OUT:ST352_DATA_OUT:SDI_TS_DET_OUT, ASSOCIATED_RESET rx_rst:vid_in_axi4s_vid_rst:vid_in_axi4s_vid_rstn, FREQ_HZ 99999000, PHASE 0.0, CLK_DOMAIN vcu_trd_clk_wiz_1_clk_out1" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 rx_clk CLK" *)
input wire rx_clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME axis_clk, ASSOCIATED_RESET axis_rstn:vid_in_axi4s_axis_rstn, FREQ_HZ 99999000, PHASE 0.0, CLK_DOMAIN vcu_trd_clk_wiz_1_clk_out1" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 axis_clk CLK" *)
input wire axis_clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME rx_rst, POLARITY ACTIVE_HIGH" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rx_rst RST" *)
input wire rx_rst;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME axis_rstn, POLARITY ACTIVE_LOW" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 axis_rstn RST" *)
input wire axis_rstn;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT RX_MODE_LOCKED" *)
output wire rx_mode_locked;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT SDI_MODE" *)
output wire [2 : 0] rx_mode;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT RX_MODE_HD" *)
output wire rx_mode_hd;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT RX_MODE_SD" *)
output wire rx_mode_sd;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT RX_MODE_3G" *)
output wire rx_mode_3g;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT RX_MODE_6G" *)
output wire rx_mode_6g;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT RX_MODE_12G" *)
output wire rx_mode_12g;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT LEVEL_B_3G" *)
output wire rx_level_b_3g;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT RX_CE_OUT" *)
output wire [0 : 0] rx_ce_out;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT RX_ACTIVE_STREAMS" *)
output wire [2 : 0] rx_active_streams;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT RX_EAV" *)
output wire rx_eav;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT RX_SAV" *)
output wire rx_sav;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT RX_TRS" *)
output wire rx_trs;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_TS_DET_OUT RX_T_LOCKED" *)
output wire rx_t_locked;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_TS_DET_OUT RX_T_FAMILY" *)
output wire [3 : 0] rx_t_family;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_TS_DET_OUT RX_T_RATE" *)
output wire [3 : 0] rx_t_rate;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_TS_DET_OUT RX_T_SCAN" *)
output wire rx_t_scan;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT LN_NUM_1" *)
output wire [10 : 0] rx_ln_ds1;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT LN_NUM_2" *)
output wire [10 : 0] rx_ln_ds2;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT LN_NUM_3" *)
output wire [10 : 0] rx_ln_ds3;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT LN_NUM_4" *)
output wire [10 : 0] rx_ln_ds4;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT LN_NUM_5" *)
output wire [10 : 0] rx_ln_ds5;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT LN_NUM_6" *)
output wire [10 : 0] rx_ln_ds6;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT LN_NUM_7" *)
output wire [10 : 0] rx_ln_ds7;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT LN_NUM_8" *)
output wire [10 : 0] rx_ln_ds8;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT DS1" *)
output wire [9 : 0] rx_ds1;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT DS2" *)
output wire [9 : 0] rx_ds2;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT DS3" *)
output wire [9 : 0] rx_ds3;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT DS4" *)
output wire [9 : 0] rx_ds4;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT DS5" *)
output wire [9 : 0] rx_ds5;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT DS6" *)
output wire [9 : 0] rx_ds6;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT DS7" *)
output wire [9 : 0] rx_ds7;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT DS8" *)
output wire [9 : 0] rx_ds8;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_RX TREADY" *)
output wire s_axis_rx_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_RX TVALID" *)
input wire s_axis_rx_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_RX TDATA" *)
input wire [39 : 0] s_axis_rx_tdata;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXIS_RX, TDATA_NUM_BYTES 5, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 32, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 99999000, PHASE 0.0, CLK_DOMAIN vcu_trd_clk_wiz_1_clk_out1, LAYERED_METADATA undef" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_RX TUSER" *)
input wire [31 : 0] s_axis_rx_tuser;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_CTRL_SB_RX TREADY" *)
input wire m_axis_ctrl_sb_rx_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_CTRL_SB_RX TVALID" *)
output wire m_axis_ctrl_sb_rx_tvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXIS_CTRL_SB_RX, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 99999000, PHASE 0.0, CLK_DOMAIN vcu_trd_clk_wiz_1_clk_out1, LAYERED_METADATA undef" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_CTRL_SB_RX TDATA" *)
output wire [31 : 0] m_axis_ctrl_sb_rx_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_STS_SB_RX TREADY" *)
output wire s_axis_sts_sb_rx_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_STS_SB_RX TVALID" *)
input wire s_axis_sts_sb_rx_tvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXIS_STS_SB_RX, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 99999000, PHASE 0.0, CLK_DOMAIN vcu_trd_clk_wiz_1_clk_out1, LAYERED_METADATA undef" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_STS_SB_RX TDATA" *)
input wire [31 : 0] s_axis_sts_sb_rx_tdata;
output wire [31 : 0] sdi_rx_bridge_ctrl;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME vid_in_axi4s_vid_rst, POLARITY ACTIVE_HIGH" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 vid_in_axi4s_vid_rst RST" *)
output wire vid_in_axi4s_vid_rst;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME vid_in_axi4s_vid_rstn, POLARITY ACTIVE_LOW" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 vid_in_axi4s_vid_rstn RST" *)
output wire vid_in_axi4s_vid_rstn;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME vid_in_axi4s_axis_rstn, POLARITY ACTIVE_LOW" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 vid_in_axi4s_axis_rstn RST" *)
output wire vid_in_axi4s_axis_rstn;
output wire vid_in_axi4s_axis_enable;
input wire [31 : 0] sdi_rx_bridge_sts;
input wire vid_in_axi4s_overflow;
input wire vid_in_axi4s_underflow;
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
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXI_CTRL, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 99999000, ID_WIDTH 0, ADDR_WIDTH 9, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 1, PHASE 0.000, CLK_DOMAIN vcu_trd_zynq_ultra_ps_e_0_1_pl_clk0, NUM_READ_THREADS 1\
, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL RREADY" *)
input wire s_axi_rready;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME interrupt, SENSITIVITY LEVEL_HIGH, PortWidth 1" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 interrupt INTERRUPT" *)
output wire interrupt;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_STS_OUT RX_MODE_LOCKED" *)
output wire rx_mode_locked_sts;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_STS_OUT SDI_MODE" *)
output wire [2 : 0] rx_mode_sts;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_STS_OUT RX_MODE_HD" *)
output wire rx_mode_hd_sts;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_STS_OUT RX_MODE_SD" *)
output wire rx_mode_sd_sts;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_STS_OUT RX_MODE_3G" *)
output wire rx_mode_3g_sts;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_STS_OUT RX_MODE_6G" *)
output wire rx_mode_6g_sts;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_STS_OUT RX_MODE_12G" *)
output wire rx_mode_12g_sts;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_STS_OUT LEVEL_B_3G" *)
output wire rx_level_b_3g_sts;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_STS_OUT RX_CE_OUT" *)
output wire [0 : 0] rx_ce_out_sts;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_STS_OUT RX_ACTIVE_STREAMS" *)
output wire [2 : 0] rx_active_streams_sts;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_STS_OUT RX_EAV" *)
output wire rx_eav_sts;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_STS_OUT RX_SAV" *)
output wire rx_sav_sts;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_STS_OUT RX_TRS" *)
output wire rx_trs_sts;

  v_smpte_uhdsdi_rx_v1_0_0 #(
    .C_AXI4LITE_ENABLE(1),
    .C_ADV_FEATURE(0),
    .C_INCLUDE_VID_OVER_AXI(1),
    .C_INCLUDE_SDI_BRIDGE(1),
    .C_INCLUDE_RX_EDH_PROCESSOR(1),
    .C_NUM_RX_CE(1),
    .C_RX_TDATA_WIDTH(40),
    .C_RX_TUSER_WIDTH(32),
    .C_AXI_DATA_WIDTH(32),
    .C_AXI_ADDR_WIDTH(9),
    .C_NUM_SYNC_REGS(3),
    .C_EDH_ERR_WIDTH(16),
    .C_ERRCNT_WIDTH(4),
    .C_MAX_ERRS_LOCKED(15),
    .C_MAX_ERRS_UNLOCKED(15)
  ) inst (
    .rx_clk(rx_clk),
    .axis_clk(axis_clk),
    .rx_rst(rx_rst),
    .axis_rstn(axis_rstn),
    .sdi_rx_ctrl(64'B0),
    .rx_mode_locked(rx_mode_locked),
    .rx_mode(rx_mode),
    .rx_mode_hd(rx_mode_hd),
    .rx_mode_sd(rx_mode_sd),
    .rx_mode_3g(rx_mode_3g),
    .rx_mode_6g(rx_mode_6g),
    .rx_mode_12g(rx_mode_12g),
    .rx_level_b_3g(rx_level_b_3g),
    .rx_ce_out(rx_ce_out),
    .rx_active_streams(rx_active_streams),
    .rx_eav(rx_eav),
    .rx_sav(rx_sav),
    .rx_trs(rx_trs),
    .rx_t_locked(rx_t_locked),
    .rx_t_family(rx_t_family),
    .rx_t_rate(rx_t_rate),
    .rx_t_scan(rx_t_scan),
    .rx_ln_ds1(rx_ln_ds1),
    .rx_ln_ds2(rx_ln_ds2),
    .rx_ln_ds3(rx_ln_ds3),
    .rx_ln_ds4(rx_ln_ds4),
    .rx_ln_ds5(rx_ln_ds5),
    .rx_ln_ds6(rx_ln_ds6),
    .rx_ln_ds7(rx_ln_ds7),
    .rx_ln_ds8(rx_ln_ds8),
    .rx_ln_ds9(),
    .rx_ln_ds10(),
    .rx_ln_ds11(),
    .rx_ln_ds12(),
    .rx_ln_ds13(),
    .rx_ln_ds14(),
    .rx_ln_ds15(),
    .rx_ln_ds16(),
    .rx_st352_0(),
    .rx_st352_0_valid(),
    .rx_st352_1(),
    .rx_st352_1_valid(),
    .rx_st352_2(),
    .rx_st352_2_valid(),
    .rx_st352_3(),
    .rx_st352_3_valid(),
    .rx_st352_4(),
    .rx_st352_4_valid(),
    .rx_st352_5(),
    .rx_st352_5_valid(),
    .rx_st352_6(),
    .rx_st352_6_valid(),
    .rx_st352_7(),
    .rx_st352_7_valid(),
    .rx_ds1(rx_ds1),
    .rx_ds2(rx_ds2),
    .rx_ds3(rx_ds3),
    .rx_ds4(rx_ds4),
    .rx_ds5(rx_ds5),
    .rx_ds6(rx_ds6),
    .rx_ds7(rx_ds7),
    .rx_ds8(rx_ds8),
    .rx_ds9(),
    .rx_ds10(),
    .rx_ds11(),
    .rx_ds12(),
    .rx_ds13(),
    .rx_ds14(),
    .rx_ds15(),
    .rx_ds16(),
    .s_axis_rx_tready(s_axis_rx_tready),
    .s_axis_rx_tvalid(s_axis_rx_tvalid),
    .s_axis_rx_tdata(s_axis_rx_tdata),
    .s_axis_rx_tuser(s_axis_rx_tuser),
    .m_axis_ctrl_sb_rx_tready(m_axis_ctrl_sb_rx_tready),
    .m_axis_ctrl_sb_rx_tvalid(m_axis_ctrl_sb_rx_tvalid),
    .m_axis_ctrl_sb_rx_tdata(m_axis_ctrl_sb_rx_tdata),
    .s_axis_sts_sb_rx_tready(s_axis_sts_sb_rx_tready),
    .s_axis_sts_sb_rx_tvalid(s_axis_sts_sb_rx_tvalid),
    .s_axis_sts_sb_rx_tdata(s_axis_sts_sb_rx_tdata),
    .sdi_rx_err(),
    .sdi_rx_edh_out(),
    .sdi_rx_bridge_ctrl(sdi_rx_bridge_ctrl),
    .vid_in_axi4s_vid_rst(vid_in_axi4s_vid_rst),
    .vid_in_axi4s_vid_rstn(vid_in_axi4s_vid_rstn),
    .vid_in_axi4s_axis_rstn(vid_in_axi4s_axis_rstn),
    .vid_in_axi4s_axis_enable(vid_in_axi4s_axis_enable),
    .sdi_rx_bridge_sts(sdi_rx_bridge_sts),
    .vid_in_axi4s_overflow(vid_in_axi4s_overflow),
    .vid_in_axi4s_underflow(vid_in_axi4s_underflow),
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
    .interrupt(interrupt),
    .sdi_rx_anc_ctrl_out(),
    .rx_ds1_anc(),
    .rx_ds2_anc(),
    .rx_ds3_anc(),
    .rx_ds4_anc(),
    .rx_ds5_anc(),
    .rx_ds6_anc(),
    .rx_ds7_anc(),
    .rx_ds8_anc(),
    .rx_ds9_anc(),
    .rx_ds10_anc(),
    .rx_ds11_anc(),
    .rx_ds12_anc(),
    .rx_ds13_anc(),
    .rx_ds14_anc(),
    .rx_ds15_anc(),
    .rx_ds16_anc(),
    .rx_mode_locked_sts(rx_mode_locked_sts),
    .rx_mode_sts(rx_mode_sts),
    .rx_mode_hd_sts(rx_mode_hd_sts),
    .rx_mode_sd_sts(rx_mode_sd_sts),
    .rx_mode_3g_sts(rx_mode_3g_sts),
    .rx_mode_6g_sts(rx_mode_6g_sts),
    .rx_mode_12g_sts(rx_mode_12g_sts),
    .rx_level_b_3g_sts(rx_level_b_3g_sts),
    .rx_ce_out_sts(rx_ce_out_sts),
    .rx_active_streams_sts(rx_active_streams_sts),
    .rx_eav_sts(rx_eav_sts),
    .rx_sav_sts(rx_sav_sts),
    .rx_trs_sts(rx_trs_sts)
  );
endmodule
