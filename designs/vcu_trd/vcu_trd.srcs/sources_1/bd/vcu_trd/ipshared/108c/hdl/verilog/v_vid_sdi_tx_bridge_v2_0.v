//-----------------------------------------------------------------------------
//  (c) Copyright 2016 Xilinx, Inc. All rights reserved.
//
//  This file contains confidential and proprietary information
//  of Xilinx, Inc. and is protected under U.S. and
//  international copyright and other intellectual property
//  laws.
//
//  DISCLAIMER
//  This disclaimer is not a license and does not grant any
//  rights to the materials distributed herewith. Except as
//  otherwise provided in a valid license issued to you by
//  Xilinx, and to the maximum extent permitted by applicable
//  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
//  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
//  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
//  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
//  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
//  (2) Xilinx shall not be liable (whether in contract or tort,
//  including negligence, or under any other theory of
//  liability) for any loss or damage of any kind or nature
//  related to, arising under or in connection with these
//  materials, including for any direct, or any indirect,
//  special, incidental, or consequential loss or damage
//  (including loss of data, profits, goodwill, or any type of
//  loss or damage suffered as a result of any action brought
//  by a third party) even if such damage or loss was
//  reasonably foreseeable or Xilinx had been advised of the
//  possibility of the same.
//
//  CRITICAL APPLICATIONS
//  Xilinx products are not designed or intended to be fail-
//  safe, or for use in any application requiring fail-safe
//  performance, such as life-support or safety devices or
//  systems, Class III medical devices, nuclear facilities,
//  applications related to the deployment of airbags, or any
//  other applications that could lead to death, personal
//  injury, or severe property or environmental damage
//  (individually and collectively, "Critical
//  Applications"). Customer assumes the sole risk and
//  liability of any use of Xilinx products in Critical
//  Applications, subject only to applicable laws and
//  regulations governing limitations on product liability.
//
//  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
//  PART OF THIS FILE AT ALL TIMES. 
//
//----------------------------------------------------------
/*
Module Description:
------------------------------------------------------------------------------
*/

`timescale 1ps/1ps
(* DowngradeIPIdentifiedWarnings="yes" *)

module v_vid_sdi_tx_bridge_v2_0_0 #(
  parameter C_PIXELS_PER_CLOCK = 2,
  parameter C_INCLUDE_3G_SDI_BRIDGE = 1,
  parameter C_INCLUDE_12G_SDI_BRIDGE = 1,
  parameter C_ADV_FEATURE = 0,
  parameter C_SIM_MODE = 0
) (
  input  wire              clk,
  input  wire              rst,
  //control interface
  input  wire [31:0]       sdi_tx_bridge_ctrl,
  output reg [31:0]        sdi_tx_bridge_sts,
  // Native Interface: 
  input  wire [3*10*C_PIXELS_PER_CLOCK-1:0]
                           vid_data,		     
  input  wire              vid_active_video,    
  input  wire              vid_vblank,		    
  input  wire              vid_hblank,		    
  input  wire              vid_field_id,
  output wire              vid_ce,
  // SDI Interface
  output wire [9:0]        tx_ds1,
  output wire [9:0]        tx_ds2,
  output wire [9:0]        tx_ds3,
  output wire [9:0]        tx_ds4,
  output wire [9:0]        tx_ds5,
  output wire [9:0]        tx_ds6,
  output wire [9:0]        tx_ds7,
  output wire [9:0]        tx_ds8,

  output wire [10:0]       tx_line1_anc,
  output wire [10:0]       tx_line2_anc,
  output wire [10:0]       tx_line3_anc,
  output wire [10:0]       tx_line4_anc,

  output wire [10:0]       tx_line1,
  output wire [10:0]       tx_line2,
  output wire [10:0]       tx_line3,
  output wire [10:0]       tx_line4,
  output wire              tx_sd_ce,
  output wire              tx_ce
);

// Internal signals
wire [9:0]  sdi_ds1_from_3gsdi_bridge;
wire [9:0]  sdi_ds2_from_3gsdi_bridge;
wire [9:0]  sdi_ds3_from_3gsdi_bridge;
wire [9:0]  sdi_ds4_from_3gsdi_bridge;
wire        sdi_ce_sd_from_3gsdi_bridge; // SD SDI clock enable
wire        sdi_ce_from_3gsdi_bridge; // HD/3GA/3GB SDI clock enable
wire        vid_ce_from_3gsdi_bridge;

wire [9:0]  sdi_ds1_from_12gsdi_bridge;
wire [9:0]  sdi_ds2_from_12gsdi_bridge;
wire [9:0]  sdi_ds3_from_12gsdi_bridge;
wire [9:0]  sdi_ds4_from_12gsdi_bridge;
wire [9:0]  sdi_ds5_from_12gsdi_bridge;
wire [9:0]  sdi_ds6_from_12gsdi_bridge;
wire [9:0]  sdi_ds7_from_12gsdi_bridge;
wire [9:0]  sdi_ds8_from_12gsdi_bridge;
wire [10:0] sdi_line_from_12gsdi_bridge;
wire        sdi_ce_from_12gsdi_bridge; // 6G/12G SDI clock enable
wire        vid_ce_from_12gsdi_bridge;
wire [3:0]  error_from_uhd_sdi_bridge;

reg ctrl_run;
reg [2:0] ctrl_mode;

reg         sdi_bridge_select;     
reg  [1:0]  sdi_3g_bridge_mode;
reg         sdi_3g_bridge_levelb;

reg  [1:0]  vid_frmt = 2'b00;

wire [10:0] tx_line; 
wire [10:0] tx_line_3g; 

assign tx_line1 = tx_line;
assign tx_line2 = tx_line;
assign tx_line3 = tx_line;
assign tx_line4 = tx_line;

generate if (C_ADV_FEATURE == 1) begin : gen_tx_ls_anc
  assign tx_line1_anc = tx_line;
  assign tx_line2_anc = tx_line;
  assign tx_line3_anc = tx_line;
  assign tx_line4_anc = tx_line;
end
endgenerate

always @(posedge clk) begin
  //sdi_tx_bridge_ctrl decoding
  ctrl_run  <= sdi_tx_bridge_ctrl[0];
  ctrl_mode <= sdi_tx_bridge_ctrl[6:4];
  vid_frmt  <= sdi_tx_bridge_ctrl[8:7];

  //sdi_tx_bridge_sts assign 
  sdi_tx_bridge_sts[0] <= sdi_bridge_select;
  sdi_tx_bridge_sts[3:1] <= 0;
  sdi_tx_bridge_sts[5:4] <= sdi_3g_bridge_mode;
  sdi_tx_bridge_sts[6] <= sdi_3g_bridge_levelb;
  sdi_tx_bridge_sts[31:7] <= 0;
end

// Mode selection
always @(*) begin
  sdi_bridge_select    = 0;
  sdi_3g_bridge_mode   = 0;
  sdi_3g_bridge_levelb = 0;

  case (ctrl_mode) 
  // HD
  0: begin
    sdi_bridge_select    = 0;
    sdi_3g_bridge_mode   = 0;
  end
  // SD
  1: begin
    sdi_bridge_select    = 0;
    sdi_3g_bridge_mode   = 1;
  end
  // 3G Level A
  2: begin
    sdi_bridge_select    = 0;
    sdi_3g_bridge_mode   = 2;
  end
  // 3G Level B
  3: begin
    sdi_bridge_select    = 0;
    sdi_3g_bridge_mode   = 2;
    sdi_3g_bridge_levelb = 1;
  end
  // 6G/12G (8 Streams)
  default: begin
    sdi_bridge_select  = 1;
  end
  endcase
end

generate if (C_INCLUDE_3G_SDI_BRIDGE) begin : generate_3g_sdi_bridge
// Instantiate SD/HD/3G SDI TX Bridge
v_vid_sdi_tx_bridge_v2_0_0_3g #(
  .C_PPC(C_PIXELS_PER_CLOCK),
  .C_SIM_MODE(C_SIM_MODE)
) SDI_3G_TX_BRIDGE_INST (
  .tx_usrclk(clk),
  .rst(rst | ~ctrl_run),
  .tx_mode(sdi_3g_bridge_mode),
  .tx_level_b(sdi_3g_bridge_levelb),

  .vid_data(vid_data[2*10*C_PIXELS_PER_CLOCK-1:0]),
  .vid_active_video(vid_active_video),
  .vid_vblank(vid_vblank),
  .vid_hblank(vid_hblank),
  .vid_field_id(vid_field_id),
  .vid_ce(vid_ce_from_3gsdi_bridge),

  .tx_video_a_y(sdi_ds1_from_3gsdi_bridge),
  .tx_video_a_c(sdi_ds2_from_3gsdi_bridge),
  .tx_video_b_y(sdi_ds3_from_3gsdi_bridge),
  .tx_video_b_c(sdi_ds4_from_3gsdi_bridge),
  .tx_line(tx_line_3g),
  .tx_eav(),
  .tx_sav(),
  .tx_trs(),
  .tx_ce_sd(sdi_ce_sd_from_3gsdi_bridge),
  .vid_frmt(vid_frmt),
  .tx_din_rdy(sdi_ce_from_3gsdi_bridge)
);
end endgenerate

generate if (C_INCLUDE_12G_SDI_BRIDGE) begin : generate_12g_sdi_bridge
// Instantiate 6G/12G SDI TX Bridge
v_vid_sdi_tx_bridge_v2_0_0_12g #(
  .C_PPC(C_PIXELS_PER_CLOCK),
  .C_VID_DUTY_CYCLE(C_PIXELS_PER_CLOCK/2 - 1),
  .C_SDI_DUTY_CYCLE(1),
  .C_SIM_MODE(C_SIM_MODE)
) SDI_12G_TX_BRIDGE_INST (
  .CLK_IN(clk),
  .RST_IN(rst | ~ctrl_run),

  .VID_DATA_IN(vid_data[2*10*C_PIXELS_PER_CLOCK-1:0]),
  .VID_VALID_IN(vid_active_video),
  .VID_HBLANK_IN(vid_hblank),
  .VID_VBLANK_IN(vid_vblank),
  .VID_CE_OUT(vid_ce_from_12gsdi_bridge),

  .SDI_DS1_OUT(sdi_ds1_from_12gsdi_bridge),
  .SDI_DS2_OUT(sdi_ds2_from_12gsdi_bridge),
  .SDI_DS3_OUT(sdi_ds3_from_12gsdi_bridge),
  .SDI_DS4_OUT(sdi_ds4_from_12gsdi_bridge),
  .SDI_DS5_OUT(sdi_ds5_from_12gsdi_bridge),
  .SDI_DS6_OUT(sdi_ds6_from_12gsdi_bridge),
  .SDI_DS7_OUT(sdi_ds7_from_12gsdi_bridge),
  .SDI_DS8_OUT(sdi_ds8_from_12gsdi_bridge),
  .SDI_DSX_LINE_OUT(sdi_line_from_12gsdi_bridge),
  .SDI_CE_OUT(sdi_ce_from_12gsdi_bridge),
  .vid_frmt(vid_frmt),

  .ERROR_OUT(error_from_uhd_sdi_bridge) 
);
end endgenerate

// Output assignments
assign vid_ce   = (sdi_bridge_select) ? vid_ce_from_12gsdi_bridge  : vid_ce_from_3gsdi_bridge; 
assign tx_ce    = (sdi_bridge_select) ? sdi_ce_from_12gsdi_bridge  : sdi_ce_from_3gsdi_bridge; 
assign tx_sd_ce = (sdi_bridge_select) ? 1'b1                       : sdi_ce_sd_from_3gsdi_bridge; 
assign tx_ds1   = (sdi_bridge_select) ? sdi_ds1_from_12gsdi_bridge : sdi_ds1_from_3gsdi_bridge;
assign tx_ds2   = (sdi_bridge_select) ? sdi_ds2_from_12gsdi_bridge : sdi_ds2_from_3gsdi_bridge;
assign tx_ds3   = (sdi_bridge_select) ? sdi_ds3_from_12gsdi_bridge : sdi_ds3_from_3gsdi_bridge;
assign tx_ds4   = (sdi_bridge_select) ? sdi_ds4_from_12gsdi_bridge : sdi_ds4_from_3gsdi_bridge;
assign tx_ds5   = sdi_ds5_from_12gsdi_bridge;
assign tx_ds6   = sdi_ds6_from_12gsdi_bridge;
assign tx_ds7   = sdi_ds7_from_12gsdi_bridge;
assign tx_ds8   = sdi_ds8_from_12gsdi_bridge;
assign tx_line  = (sdi_bridge_select) ? sdi_line_from_12gsdi_bridge : tx_line_3g;

endmodule
