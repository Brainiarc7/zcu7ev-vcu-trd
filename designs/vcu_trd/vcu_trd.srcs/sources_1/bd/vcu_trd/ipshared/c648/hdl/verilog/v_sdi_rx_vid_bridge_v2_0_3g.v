//-----------------------------------------------------------------------------
//  (c) Copyright 2013 Xilinx, Inc. All rights reserved.
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

Top level module for SDI RX to Video Bridge core.  It contains
instances of the lower-level modules and interconnections.
------------------------------------------------------------------------------
*/

`timescale 1ps/1ps

(* DowngradeIPIdentifiedWarnings="yes" *)
module v_sdi_rx_vid_bridge_v2_0_0_3g #(
  parameter C_PPC = 1
) (
  input         rx_usrclk,
  input         rst,
  input  [1:0]  rx_mode,          // SDI mode 
  input         rx_mode_locked,   // Flag indicating mode is locked
  input         rx_level_b,       // 3G level B flag
  input         rx_dout_rdy,      // clock enable for 3G level B
  input         rx_ce_sd,         // clock enable for SD-SDI
  input  [9:0]  rx_ds1a,          // SDI data stream 1a (c) 
  input  [9:0]  rx_ds2a,          // SDI data stream 2a (y)
  input  [9:0]  rx_ds1b,          // SDI data stream 1b for 3G level B only 
  input  [9:0]  rx_ds2b,          // SDI data stream 2b for 3G level B only 

  output [20*C_PPC-1:0] vid_data, // Data formatted for video output.
  output        vid_ce,           // clock enable for output video 
  output        vid_active_video, // timing signal: active video
  output        vid_hblank,       // timing signal: horizontal blank 
  output        vid_vblank,       // timing signal: vertical blank 
  output        vid_field_id      // timing signal: field_id 
);

wire          vid_ce_comb;      // selected clock enable for internal use
wire   [9:0]  d1a;              // SDI data after reformatting for mode.
wire   [2:0]  tim;              // SDI timing data matching d1a
wire          pre_act_vid;      // unblank signal to formatter
wire          vreg_sel;         // 1/2 input rate timing signal
wire   [9:0]  rx_ds1a_dec;      // SDI data stream 1a out ot trs_decode
wire   [9:0]  rx_ds2a_dec;      // SDI data stream 2a out ot trs_decode
wire   [9:0]  rx_ds1b_dec;      // SDI data stream 1b out ot trs_decode
wire   [9:0]  rx_ds2b_dec;      // SDI data stream 2b out ot trs_decode
wire          eav;              // Decoded EAV
wire          sav;              // Decoded SAV
wire          trs;              // Decoded TRS

wire          clk_vid_ce;
wire [19:0]   clk_vid_data;
wire          clk_vid_hblank;
wire          clk_vid_vblank;
wire          clk_vid_active_video;
wire          clk_vid_field_id;

v_sdi_rx_vid_bridge_v2_0_0_3g_trs_decode trs_decode 
(
  .clk(rx_usrclk),
  .rst(rst),
  .rx_ce_sd(rx_ce_sd),
  .rx_dout_rdy(rx_dout_rdy),
  .rx_mode(rx_mode),
  .rx_level_b(rx_level_b),
  .rx_ds1a_in(rx_ds1a),
  .rx_ds2a_in(rx_ds2a),
  .rx_ds1b_in(rx_ds1b),
  .rx_ds2b_in(rx_ds2b),
  .rx_ds1a_out(rx_ds1a_dec),
  .rx_ds2a_out(rx_ds2a_dec),
  .rx_ds1b_out(rx_ds1b_dec),
  .rx_ds2b_out(rx_ds2b_dec),
  .eav_out(eav),
  .sav_out(sav),
  .trs_out(trs)
);

v_sdi_rx_vid_bridge_v2_0_0_3g_ce_gen ce_gen 
(
  .clk(rx_usrclk),
  .rst(rst),
  .rx_mode(rx_mode),
  .rx_level_b(rx_level_b),
  .rx_dout_rdy(rx_dout_rdy),
  .rx_ce_sd(rx_ce_sd),
  .vreg_sel(vreg_sel),
  .vid_ce_comb(vid_ce_comb),
  .vid_ce(clk_vid_ce)
);

v_sdi_rx_vid_bridge_v2_0_0_3g_formatter formatter 
(
  .clk(rx_usrclk),
  .rst(rst),
  .rx_ce_sd(rx_ce_sd),
  .vid_ce_comb(vid_ce_comb),
  .vid_ce(clk_vid_ce),
  .rx_dout_rdy(rx_dout_rdy),
  .rx_mode(rx_mode),
  .rx_mode_locked(rx_mode_locked),
  .rx_level_b(rx_level_b),
  .rx_eav(eav),
  .rx_sav(sav),
  .rx_trs(trs),
  .rx_ds1a(rx_ds1a_dec),
  .rx_ds2a(rx_ds2a_dec),
  .rx_ds1b(rx_ds1b_dec),
  .rx_ds2b(rx_ds2b_dec),
  .pre_act_vid(pre_act_vid),
  .d1a(d1a),
  .tim(tim),
  .video_data(clk_vid_data),
  .vreg_sel(vreg_sel)
);

v_sdi_rx_vid_bridge_v2_0_0_3g_sync_extract sync_extract 
(
  .clk(rx_usrclk),
  .rst(rst),
  .rx_ce_sd(rx_ce_sd),
  .vid_ce_comb(vid_ce_comb ),
  .vid_ce(clk_vid_ce),
  .d1a(d1a),
  .tim(tim),
  .rx_mode(rx_mode),
  .rx_mode_locked(rx_mode_locked),
  .rx_level_b(rx_level_b),
  .pre_act_vid(pre_act_vid),
  .active_video(clk_vid_active_video),
  .hblank(clk_vid_hblank),
  .vblank(clk_vid_vblank),
  .field_id(clk_vid_field_id)
); 

v_sdi_rx_vid_bridge_v2_0_0_3g_converter #(
 .C_PPC(C_PPC) 
) converter (
  .clk(rx_usrclk),
  .rst(rst),
  .clken(clk_vid_ce),
  .vid_data_in(clk_vid_data),            
  .vid_active_video_in(clk_vid_active_video),    
  .vid_vblank_in(clk_vid_vblank),          
  .vid_hblank_in(clk_vid_hblank),          
  .vid_field_id_in(clk_vid_field_id),        
  .vid_data_out(vid_data),           
  .vid_active_video_out(vid_active_video),   
  .vid_vblank_out(vid_vblank),         
  .vid_hblank_out(vid_hblank),         
  .vid_field_id_out(vid_field_id),
  .vid_clken(vid_ce)               
);

endmodule
