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


// IP VLNV: xilinx.com:ip:v_vid_sdi_tx_bridge:2.0
// IP Revision: 0

(* X_CORE_INFO = "v_vid_sdi_tx_bridge_v2_0_0,Vivado 2018.2" *)
(* CHECK_LICENSE_TYPE = "bd_82d8_v_vid_sdi_tx_bridge_0,v_vid_sdi_tx_bridge_v2_0_0,{}" *)
(* CORE_GENERATION_INFO = "bd_82d8_v_vid_sdi_tx_bridge_0,v_vid_sdi_tx_bridge_v2_0_0,{x_ipProduct=Vivado 2018.2,x_ipVendor=xilinx.com,x_ipLibrary=ip,x_ipName=v_vid_sdi_tx_bridge,x_ipVersion=2.0,x_ipCoreRevision=0,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,C_PIXELS_PER_CLOCK=2,C_INCLUDE_3G_SDI_BRIDGE=true,C_INCLUDE_12G_SDI_BRIDGE=true,C_ADV_FEATURE=0,C_SIM_MODE=0}" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module bd_82d8_v_vid_sdi_tx_bridge_0 (
  clk,
  rst,
  sdi_tx_bridge_ctrl,
  sdi_tx_bridge_sts,
  vid_data,
  vid_active_video,
  vid_vblank,
  vid_hblank,
  vid_field_id,
  vid_ce,
  tx_ds1,
  tx_ds2,
  tx_ds3,
  tx_ds4,
  tx_ds5,
  tx_ds6,
  tx_ds7,
  tx_ds8,
  tx_line1,
  tx_line2,
  tx_line3,
  tx_line4,
  tx_sd_ce,
  tx_ce
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME VID_CLK, ASSOCIATED_BUSIF VID_IO_IN:SDI_DS_OUT, ASSOCIATED_RESET rst, FREQ_HZ 99999000, PHASE 0.0, CLK_DOMAIN vcu_trd_clk_wiz_1_clk_out1" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 VID_CLK CLK" *)
input wire clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME VID_RST, POLARITY ACTIVE_HIGH" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 VID_RST RST" *)
input wire rst;
input wire [31 : 0] sdi_tx_bridge_ctrl;
output wire [31 : 0] sdi_tx_bridge_sts;
(* X_INTERFACE_INFO = "xilinx.com:interface:vid_io:1.0 VID_IO_IN DATA" *)
input wire [59 : 0] vid_data;
(* X_INTERFACE_INFO = "xilinx.com:interface:vid_io:1.0 VID_IO_IN ACTIVE_VIDEO" *)
input wire vid_active_video;
(* X_INTERFACE_INFO = "xilinx.com:interface:vid_io:1.0 VID_IO_IN VBLANK" *)
input wire vid_vblank;
(* X_INTERFACE_INFO = "xilinx.com:interface:vid_io:1.0 VID_IO_IN HBLANK" *)
input wire vid_hblank;
(* X_INTERFACE_INFO = "xilinx.com:interface:vid_io:1.0 VID_IO_IN FIELD" *)
input wire vid_field_id;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME VID_CE, POLARITY ACTIVE_LOW" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clockenable:1.0 VID_CE CE" *)
output wire vid_ce;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT DS1" *)
output wire [9 : 0] tx_ds1;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT DS2" *)
output wire [9 : 0] tx_ds2;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT DS3" *)
output wire [9 : 0] tx_ds3;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT DS4" *)
output wire [9 : 0] tx_ds4;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT DS5" *)
output wire [9 : 0] tx_ds5;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT DS6" *)
output wire [9 : 0] tx_ds6;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT DS7" *)
output wire [9 : 0] tx_ds7;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT DS8" *)
output wire [9 : 0] tx_ds8;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT LN_NUM_1" *)
output wire [10 : 0] tx_line1;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT LN_NUM_2" *)
output wire [10 : 0] tx_line2;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT LN_NUM_3" *)
output wire [10 : 0] tx_line3;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT LN_NUM_4" *)
output wire [10 : 0] tx_line4;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT TX_SD_CE" *)
output wire tx_sd_ce;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_OUT TX_CE" *)
output wire tx_ce;

  v_vid_sdi_tx_bridge_v2_0_0 #(
    .C_PIXELS_PER_CLOCK(2),
    .C_INCLUDE_3G_SDI_BRIDGE(1'B1),
    .C_INCLUDE_12G_SDI_BRIDGE(1'B1),
    .C_ADV_FEATURE(0),
    .C_SIM_MODE(0)
  ) inst (
    .clk(clk),
    .rst(rst),
    .sdi_tx_bridge_ctrl(sdi_tx_bridge_ctrl),
    .sdi_tx_bridge_sts(sdi_tx_bridge_sts),
    .vid_data(vid_data),
    .vid_active_video(vid_active_video),
    .vid_vblank(vid_vblank),
    .vid_hblank(vid_hblank),
    .vid_field_id(vid_field_id),
    .vid_ce(vid_ce),
    .tx_ds1(tx_ds1),
    .tx_ds2(tx_ds2),
    .tx_ds3(tx_ds3),
    .tx_ds4(tx_ds4),
    .tx_ds5(tx_ds5),
    .tx_ds6(tx_ds6),
    .tx_ds7(tx_ds7),
    .tx_ds8(tx_ds8),
    .tx_line1_anc(),
    .tx_line2_anc(),
    .tx_line3_anc(),
    .tx_line4_anc(),
    .tx_line1(tx_line1),
    .tx_line2(tx_line2),
    .tx_line3(tx_line3),
    .tx_line4(tx_line4),
    .tx_sd_ce(tx_sd_ce),
    .tx_ce(tx_ce)
  );
endmodule
