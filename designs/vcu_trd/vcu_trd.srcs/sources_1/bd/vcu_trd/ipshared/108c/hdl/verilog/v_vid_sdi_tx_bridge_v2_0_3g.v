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

This is the top level module for the Video to SDI TX bridge.  It contains 
only instances of the lower level modules.
------------------------------------------------------------------------------
*/

`timescale 1ps/1ps

(* DowngradeIPIdentifiedWarnings="yes" *)
module v_vid_sdi_tx_bridge_v2_0_0_3g #(
  parameter C_PPC = 1,
  parameter C_SIM_MODE = 0
) (
  input		          tx_usrclk,
  input             rst,
  input [1:0]       tx_mode,             // sdi mode
  input             tx_level_b,			     // 3G-SDI level b flag

  // Video Inputs
  input [20*C_PPC-1:0] vid_data,		     // parallel video data.  2 components, 10 bits
  input             vid_active_video,    // active video control signal
  input             vid_vblank,		       // vertical blank
  input             vid_hblank,		       // horizontal blank
  input             vid_field_id,        // field_id bit

  // SDI Outputs
  output [9:0]      tx_video_a_y,        // SDI data stream c with TRS and line #s
  output [9:0]      tx_video_a_c,        // SDI data stream y with TRS and line #s
  output [9:0]      tx_video_b_y,        // SDI data stream Bc with TRS and line #s
  output [9:0]      tx_video_b_c,        // SDI data stream By with TRS and line #s
  output [10:0]     tx_line,
  output            tx_eav,
  output            tx_sav,
  output            tx_trs,
  // Video format 
  // 00 - 4:2:2
  // 01 - 4:2:0
  // 10 - Reserved
  // 11 - Reserved
  input  wire [1:0]    vid_frmt,
  
  // Clock Enable Outputs
  output            tx_ce_sd,
  output            vid_ce,			   // video side clock enable
  output            tx_din_rdy           
);

  wire              y_mux_sel;
  wire [9:0]        tx_ds1a;
  wire [9:0]        tx_ds2a;
  wire [9:0]        tx_ds1b;
  wire [9:0]        tx_ds2b;
  wire [3:0]        lev_b_tim; 
  wire              output_ce;
  wire              vid_clken_from_gen;

  wire [19:0]       vid_data_from_converter;
  wire              vid_active_from_converter;
  wire              vid_vblank_from_converter;
  wire              vid_hblank_from_converter;
  wire              vid_field_from_converter;
  wire              vid_clken_from_converter;

  assign vid_ce = vid_clken_from_converter;

  v_vid_sdi_tx_bridge_v2_0_0_3g_converter #(
   .C_PPC(C_PPC) 
  ) converter (
    .clk(tx_usrclk),
    .rst(rst),
    .clken(vid_clken_from_gen),
    .vid_data_in(vid_data),	  	   
    .vid_active_video_in(vid_active_video),
    .vid_vblank_in(vid_vblank),		      
    .vid_hblank_in(vid_hblank),		     
    .vid_field_id_in(vid_field_id),    
    .vid_data_out(vid_data_from_converter),		        
    .vid_active_video_out(vid_active_from_converter),   
    .vid_vblank_out(vid_vblank_from_converter),		      
    .vid_hblank_out(vid_hblank_from_converter),		      
    .vid_field_id_out(vid_field_from_converter),       
    .vid_clken(vid_clken_from_converter)               
  );

  v_vid_sdi_tx_bridge_v2_0_0_3g_formatter formatter (
    .clk(tx_usrclk),
    .rst(rst),
    .vid_ce(vid_clken_from_gen),
    .tx_ce_sd(tx_ce_sd),
	  .output_ce(output_ce),
	  .tx_mode(tx_mode),
    .tx_level_b(tx_level_b),
    .tx_din_rdy(tx_din_rdy),
    .video_data(vid_data_from_converter),
    .active_video(vid_active_from_converter),
    .vblank(vid_vblank_from_converter),
    .hblank(vid_hblank_from_converter),
	  .field_id(vid_field_from_converter),
    .tx_ds1a(tx_ds1a),
    .tx_ds2a(tx_ds2a),
    .tx_ds1b(tx_ds1b),
    .tx_ds2b(tx_ds2b),
    .vid_frmt(vid_frmt),
	  .lev_b_tim(lev_b_tim)
  );

  v_vid_sdi_tx_bridge_v2_0_0_3g_embeddder #(
  .C_SIM_MODE(C_SIM_MODE)
  ) embedder (
    .clk(tx_usrclk),
    .rst(rst),
    .output_ce(output_ce),
    .tx_mode(tx_mode),
	  .tx_level_b(tx_level_b),
    .vblank(vid_vblank),
    .hblank(vid_hblank),
    .field_id(vid_field_id),
    .tx_ds1a(tx_ds1a),
    .tx_ds2a(tx_ds2a),
    .tx_ds1b(tx_ds1b),
    .tx_ds2b(tx_ds2b),
	  .lev_b_tim(lev_b_tim),
    .tx_video_a_y(tx_video_a_y),
    .tx_video_a_c(tx_video_a_c),
    .tx_video_b_y(tx_video_b_y),
    .tx_video_b_c(tx_video_b_c),
	.tx_line(tx_line),
    .eav(tx_eav),
    .sav(tx_sav),
    .trs(tx_trs)
  );

  v_vid_sdi_tx_bridge_v2_0_0_3g_ce_gen ce_gen (
	  .clk(tx_usrclk),
	  .rst(rst),
	  .tx_mode(tx_mode),
	  .tx_level_b(tx_level_b),
	  .y_mux_sel(y_mux_sel),
	  .tx_ce_sd(tx_ce_sd),
	  .vid_ce(vid_clken_from_gen),
	  .tx_din_rdy(tx_din_rdy),
	  .output_ce(output_ce)
  );

endmodule
