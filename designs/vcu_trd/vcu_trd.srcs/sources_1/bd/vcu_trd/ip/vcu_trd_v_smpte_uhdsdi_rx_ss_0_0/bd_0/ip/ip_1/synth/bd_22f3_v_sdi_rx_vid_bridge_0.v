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


// IP VLNV: xilinx.com:ip:v_sdi_rx_vid_bridge:2.0
// IP Revision: 0

(* X_CORE_INFO = "v_sdi_rx_vid_bridge_v2_0_0,Vivado 2018.2" *)
(* CHECK_LICENSE_TYPE = "bd_22f3_v_sdi_rx_vid_bridge_0,v_sdi_rx_vid_bridge_v2_0_0,{}" *)
(* CORE_GENERATION_INFO = "bd_22f3_v_sdi_rx_vid_bridge_0,v_sdi_rx_vid_bridge_v2_0_0,{x_ipProduct=Vivado 2018.2,x_ipVendor=xilinx.com,x_ipLibrary=ip,x_ipName=v_sdi_rx_vid_bridge,x_ipVersion=2.0,x_ipCoreRevision=0,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,C_PIXELS_PER_CLOCK=2,C_INCLUDE_3G_SDI_BRIDGE=true,C_INCLUDE_12G_SDI_BRIDGE=true}" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module bd_22f3_v_sdi_rx_vid_bridge_0 (
  clk,
  rst,
  sdi_rx_bridge_ctrl,
  sdi_rx_bridge_sts,
  rx_ds1,
  rx_ds2,
  rx_ds3,
  rx_ds4,
  rx_ds5,
  rx_ds6,
  rx_ds7,
  rx_ds8,
  rx_ce,
  rx_level_b,
  rx_mode,
  rx_mode_locked,
  vid_data,
  vid_active_video,
  vid_vblank,
  vid_hblank,
  vid_field_id,
  vid_ce
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME VID_CLK, ASSOCIATED_BUSIF VID_IO_OUT:SDI_DS_IN, ASSOCIATED_RESET rst, FREQ_HZ 99999000, PHASE 0.0, CLK_DOMAIN vcu_trd_clk_wiz_1_clk_out1" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 VID_CLK CLK" *)
input wire clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME VID_RST, POLARITY ACTIVE_HIGH" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 VID_RST RST" *)
input wire rst;
input wire [31 : 0] sdi_rx_bridge_ctrl;
output wire [31 : 0] sdi_rx_bridge_sts;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_IN DS1" *)
input wire [9 : 0] rx_ds1;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_IN DS2" *)
input wire [9 : 0] rx_ds2;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_IN DS3" *)
input wire [9 : 0] rx_ds3;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_IN DS4" *)
input wire [9 : 0] rx_ds4;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_IN DS5" *)
input wire [9 : 0] rx_ds5;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_IN DS6" *)
input wire [9 : 0] rx_ds6;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_IN DS7" *)
input wire [9 : 0] rx_ds7;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_IN DS8" *)
input wire [9 : 0] rx_ds8;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_IN RX_CE_OUT" *)
input wire rx_ce;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_IN LEVEL_B_3G" *)
input wire rx_level_b;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_IN SDI_MODE" *)
input wire [2 : 0] rx_mode;
(* X_INTERFACE_INFO = "xilinx.com:interface:sdi_native:2.0 SDI_DS_IN RX_MODE_LOCKED" *)
input wire rx_mode_locked;
(* X_INTERFACE_INFO = "xilinx.com:interface:vid_io:1.0 VID_IO_OUT DATA" *)
output wire [59 : 0] vid_data;
(* X_INTERFACE_INFO = "xilinx.com:interface:vid_io:1.0 VID_IO_OUT ACTIVE_VIDEO" *)
output wire vid_active_video;
(* X_INTERFACE_INFO = "xilinx.com:interface:vid_io:1.0 VID_IO_OUT VBLANK" *)
output wire vid_vblank;
(* X_INTERFACE_INFO = "xilinx.com:interface:vid_io:1.0 VID_IO_OUT HBLANK" *)
output wire vid_hblank;
(* X_INTERFACE_INFO = "xilinx.com:interface:vid_io:1.0 VID_IO_OUT FIELD" *)
output wire vid_field_id;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME VID_CE, POLARITY ACTIVE_LOW" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clockenable:1.0 VID_CE CE" *)
output wire vid_ce;

  v_sdi_rx_vid_bridge_v2_0_0 #(
    .C_PIXELS_PER_CLOCK(2),
    .C_INCLUDE_3G_SDI_BRIDGE(1'B1),
    .C_INCLUDE_12G_SDI_BRIDGE(1'B1)
  ) inst (
    .clk(clk),
    .rst(rst),
    .sdi_rx_bridge_ctrl(sdi_rx_bridge_ctrl),
    .sdi_rx_bridge_sts(sdi_rx_bridge_sts),
    .rx_ds1(rx_ds1),
    .rx_ds2(rx_ds2),
    .rx_ds3(rx_ds3),
    .rx_ds4(rx_ds4),
    .rx_ds5(rx_ds5),
    .rx_ds6(rx_ds6),
    .rx_ds7(rx_ds7),
    .rx_ds8(rx_ds8),
    .rx_ce(rx_ce),
    .rx_level_b(rx_level_b),
    .rx_mode(rx_mode),
    .rx_mode_locked(rx_mode_locked),
    .vid_data(vid_data),
    .vid_active_video(vid_active_video),
    .vid_vblank(vid_vblank),
    .vid_hblank(vid_hblank),
    .vid_field_id(vid_field_id),
    .vid_ce(vid_ce)
  );
endmodule
