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


// IP VLNV: xilinx.com:ip:v_smpte_uhdsdi_tx_ss:2.0
// IP Revision: 1

`timescale 1ns/1ps

(* DowngradeIPIdentifiedWarnings = "yes" *)
module vcu_trd_v_smpte_uhdsdi_tx_ss_0_0 (
  sdi_tx_clk,
  sdi_tx_rst,
  video_in_clk,
  video_in_arstn,
  fid,
  vtc_irq,
  sdi_tx_irq,
  s_axi_aclk,
  s_axi_arstn,
  S_AXIS_STS_SB_TX_tdata,
  S_AXIS_STS_SB_TX_tready,
  S_AXIS_STS_SB_TX_tvalid,
  M_AXIS_TX_tdata,
  M_AXIS_TX_tready,
  M_AXIS_TX_tuser,
  M_AXIS_TX_tvalid,
  M_AXIS_CTRL_SB_TX_tdata,
  M_AXIS_CTRL_SB_TX_tready,
  M_AXIS_CTRL_SB_TX_tvalid,
  VIDEO_IN_tdata,
  VIDEO_IN_tlast,
  VIDEO_IN_tready,
  VIDEO_IN_tuser,
  VIDEO_IN_tvalid,
  S_AXI_CTRL_awaddr,
  S_AXI_CTRL_awprot,
  S_AXI_CTRL_awvalid,
  S_AXI_CTRL_awready,
  S_AXI_CTRL_wdata,
  S_AXI_CTRL_wstrb,
  S_AXI_CTRL_wvalid,
  S_AXI_CTRL_wready,
  S_AXI_CTRL_bresp,
  S_AXI_CTRL_bvalid,
  S_AXI_CTRL_bready,
  S_AXI_CTRL_araddr,
  S_AXI_CTRL_arprot,
  S_AXI_CTRL_arvalid,
  S_AXI_CTRL_arready,
  S_AXI_CTRL_rdata,
  S_AXI_CTRL_rresp,
  S_AXI_CTRL_rvalid,
  S_AXI_CTRL_rready
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.sdi_tx_clk, FREQ_HZ 99999000, PHASE 0.0, CLK_DOMAIN vcu_trd_clk_wiz_1_clk_out1, ASSOCIATED_BUSIF M_AXIS_CTRL_SB_TX:M_AXIS_TX:S_AXIS_STS_SB_TX, ASSOCIATED_RESET sdi_tx_rst, ASSOCIATED_CLKEN clken" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.sdi_tx_clk CLK" *)
input wire sdi_tx_clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.sdi_tx_rst, POLARITY ACTIVE_HIGH" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.sdi_tx_rst RST" *)
input wire sdi_tx_rst;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.video_in_clk, FREQ_HZ 99999000, PHASE 0.0, CLK_DOMAIN vcu_trd_clk_wiz_1_clk_out1, ASSOCIATED_BUSIF VIDEO_IN, ASSOCIATED_RESET video_in_arstn" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.video_in_clk CLK" *)
input wire video_in_clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.video_in_arstn, POLARITY ACTIVE_LOW" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.video_in_arstn RST" *)
input wire video_in_arstn;
input wire fid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME INTR.vtc_irq, SENSITIVITY LEVEL_HIGH, PortWidth 1" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 INTR.vtc_irq INTERRUPT" *)
output wire vtc_irq;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME INTR.sdi_tx_irq, SENSITIVITY LEVEL_HIGH, PortWidth 1" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 INTR.sdi_tx_irq INTERRUPT" *)
output wire sdi_tx_irq;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.s_axi_aclk, FREQ_HZ 99999000, PHASE 0.000, CLK_DOMAIN vcu_trd_zynq_ultra_ps_e_0_1_pl_clk0, ASSOCIATED_BUSIF S_AXI_CTRL, ASSOCIATED_RESET s_axi_arstn, ASSOCIATED_CLKEN s_axi_aclken" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.s_axi_aclk CLK" *)
input wire s_axi_aclk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.s_axi_arstn, POLARITY ACTIVE_LOW, TYPE INTERCONNECT" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.s_axi_arstn RST" *)
input wire s_axi_arstn;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_STS_SB_TX TDATA" *)
input wire [31 : 0] S_AXIS_STS_SB_TX_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_STS_SB_TX TREADY" *)
output wire S_AXIS_STS_SB_TX_tready;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXIS_STS_SB_TX, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 99999000, PHASE 0.0, CLK_DOMAIN vcu_trd_clk_wiz_1_clk_out1, LAYERED_METADATA undef" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_STS_SB_TX TVALID" *)
input wire S_AXIS_STS_SB_TX_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_TX TDATA" *)
output wire [39 : 0] M_AXIS_TX_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_TX TREADY" *)
input wire M_AXIS_TX_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_TX TUSER" *)
output wire [31 : 0] M_AXIS_TX_tuser;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXIS_TX, TDATA_NUM_BYTES 5, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 32, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 99999000, PHASE 0.0, CLK_DOMAIN vcu_trd_clk_wiz_1_clk_out1, LAYERED_METADATA undef" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_TX TVALID" *)
output wire M_AXIS_TX_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_CTRL_SB_TX TDATA" *)
output wire [31 : 0] M_AXIS_CTRL_SB_TX_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_CTRL_SB_TX TREADY" *)
input wire M_AXIS_CTRL_SB_TX_tready;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXIS_CTRL_SB_TX, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 99999000, PHASE 0.0, CLK_DOMAIN vcu_trd_clk_wiz_1_clk_out1, LAYERED_METADATA undef" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_CTRL_SB_TX TVALID" *)
output wire M_AXIS_CTRL_SB_TX_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 VIDEO_IN TDATA" *)
input wire [63 : 0] VIDEO_IN_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 VIDEO_IN TLAST" *)
input wire VIDEO_IN_tlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 VIDEO_IN TREADY" *)
output wire VIDEO_IN_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 VIDEO_IN TUSER" *)
input wire VIDEO_IN_tuser;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME VIDEO_IN, TDATA_NUM_BYTES 8, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 1, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 99999000, PHASE 0.0, CLK_DOMAIN vcu_trd_clk_wiz_1_clk_out1, LAYERED_METADATA undef" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 VIDEO_IN TVALID" *)
input wire VIDEO_IN_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL AWADDR" *)
input wire [16 : 0] S_AXI_CTRL_awaddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL AWPROT" *)
input wire [2 : 0] S_AXI_CTRL_awprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL AWVALID" *)
input wire [0 : 0] S_AXI_CTRL_awvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL AWREADY" *)
output wire [0 : 0] S_AXI_CTRL_awready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL WDATA" *)
input wire [31 : 0] S_AXI_CTRL_wdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL WSTRB" *)
input wire [3 : 0] S_AXI_CTRL_wstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL WVALID" *)
input wire [0 : 0] S_AXI_CTRL_wvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL WREADY" *)
output wire [0 : 0] S_AXI_CTRL_wready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL BRESP" *)
output wire [1 : 0] S_AXI_CTRL_bresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL BVALID" *)
output wire [0 : 0] S_AXI_CTRL_bvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL BREADY" *)
input wire [0 : 0] S_AXI_CTRL_bready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL ARADDR" *)
input wire [16 : 0] S_AXI_CTRL_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL ARPROT" *)
input wire [2 : 0] S_AXI_CTRL_arprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL ARVALID" *)
input wire [0 : 0] S_AXI_CTRL_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL ARREADY" *)
output wire [0 : 0] S_AXI_CTRL_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL RDATA" *)
output wire [31 : 0] S_AXI_CTRL_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL RRESP" *)
output wire [1 : 0] S_AXI_CTRL_rresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL RVALID" *)
output wire [0 : 0] S_AXI_CTRL_rvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXI_CTRL, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 99999000, ID_WIDTH 0, ADDR_WIDTH 17, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 1, PHASE 0.000, CLK_DOMAIN vcu_trd_zynq_ultra_ps_e_0_1_pl_clk0, NUM_READ_THREADS \
1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CTRL RREADY" *)
input wire [0 : 0] S_AXI_CTRL_rready;

  bd_82d8 inst (
    .sdi_tx_clk(sdi_tx_clk),
    .sdi_tx_rst(sdi_tx_rst),
    .video_in_clk(video_in_clk),
    .video_in_arstn(video_in_arstn),
    .fid(fid),
    .vtc_irq(vtc_irq),
    .sdi_tx_irq(sdi_tx_irq),
    .s_axi_aclk(s_axi_aclk),
    .s_axi_arstn(s_axi_arstn),
    .S_AXIS_STS_SB_TX_tdata(S_AXIS_STS_SB_TX_tdata),
    .S_AXIS_STS_SB_TX_tready(S_AXIS_STS_SB_TX_tready),
    .S_AXIS_STS_SB_TX_tvalid(S_AXIS_STS_SB_TX_tvalid),
    .M_AXIS_TX_tdata(M_AXIS_TX_tdata),
    .M_AXIS_TX_tready(M_AXIS_TX_tready),
    .M_AXIS_TX_tuser(M_AXIS_TX_tuser),
    .M_AXIS_TX_tvalid(M_AXIS_TX_tvalid),
    .M_AXIS_CTRL_SB_TX_tdata(M_AXIS_CTRL_SB_TX_tdata),
    .M_AXIS_CTRL_SB_TX_tready(M_AXIS_CTRL_SB_TX_tready),
    .M_AXIS_CTRL_SB_TX_tvalid(M_AXIS_CTRL_SB_TX_tvalid),
    .VIDEO_IN_tdata(VIDEO_IN_tdata),
    .VIDEO_IN_tlast(VIDEO_IN_tlast),
    .VIDEO_IN_tready(VIDEO_IN_tready),
    .VIDEO_IN_tuser(VIDEO_IN_tuser),
    .VIDEO_IN_tvalid(VIDEO_IN_tvalid),
    .S_AXI_CTRL_awaddr(S_AXI_CTRL_awaddr),
    .S_AXI_CTRL_awprot(S_AXI_CTRL_awprot),
    .S_AXI_CTRL_awvalid(S_AXI_CTRL_awvalid),
    .S_AXI_CTRL_awready(S_AXI_CTRL_awready),
    .S_AXI_CTRL_wdata(S_AXI_CTRL_wdata),
    .S_AXI_CTRL_wstrb(S_AXI_CTRL_wstrb),
    .S_AXI_CTRL_wvalid(S_AXI_CTRL_wvalid),
    .S_AXI_CTRL_wready(S_AXI_CTRL_wready),
    .S_AXI_CTRL_bresp(S_AXI_CTRL_bresp),
    .S_AXI_CTRL_bvalid(S_AXI_CTRL_bvalid),
    .S_AXI_CTRL_bready(S_AXI_CTRL_bready),
    .S_AXI_CTRL_araddr(S_AXI_CTRL_araddr),
    .S_AXI_CTRL_arprot(S_AXI_CTRL_arprot),
    .S_AXI_CTRL_arvalid(S_AXI_CTRL_arvalid),
    .S_AXI_CTRL_arready(S_AXI_CTRL_arready),
    .S_AXI_CTRL_rdata(S_AXI_CTRL_rdata),
    .S_AXI_CTRL_rresp(S_AXI_CTRL_rresp),
    .S_AXI_CTRL_rvalid(S_AXI_CTRL_rvalid),
    .S_AXI_CTRL_rready(S_AXI_CTRL_rready)
  );
endmodule
