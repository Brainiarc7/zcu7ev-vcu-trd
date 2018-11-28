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

This module creates explicit video timing signals from the timing symbols
embedded in SDI.
------------------------------------------------------------------------------
*/

`timescale 1ps/1ps


(* DowngradeIPIdentifiedWarnings="yes" *)
module v_sdi_rx_vid_bridge_v2_0_0_3g_sync_extract              
 (
  input             clk,
  input             rst,
  input             rx_ce_sd,       // clock enable for SD-SDI
  input             vid_ce_comb,
  input             vid_ce,
  input      [9:0]  d1a,            // SDI data after reformatting for mode
  input      [2:0]  tim,
  input      [1:0]  rx_mode,        // SDI mode from sync extractor
  input             rx_mode_locked, // Flag indicating mode is locked
  input             rx_level_b,     // 3G level B flag
  
  output reg        pre_act_vid,    // unblank signal to formatter
  output reg        active_video,   // timing signal: active video
  output reg        hblank,         // timing signal: horizontal blank 
  output reg        vblank,         // timing signal: vertical blank 
  output reg        field_id        // timing signal: field_id 
);

wire hblank_set;
reg  hblank_reset;
wire vblank_set;
wire vblank_reset;
wire field_id_set;
wire field_id_reset;
wire act_vid_set;
wire act_vid_reset;
wire eav;
wire sav;
wire trs;
wire xyz;
wire h_bit;
wire v_bit;
wire f_bit;
wire ce_toggles = (rx_mode == 1) | (rx_mode == 2 & rx_level_b); 
reg  [2:0]   tim_1;
reg  [9:0]   d1a_1;
wire         hblank_rst;
reg          hblank_rst_1;
reg          hblank_rst_2;
reg          hblank_rst_3;
reg        pre_hblank;
reg      pre_vblank;
reg      pre_field_id;

assign eav =   ce_toggles?  tim_1[2]: tim[2];
assign sav =   ce_toggles?  tim_1[1]: tim[1];
assign trs =   ce_toggles?  tim_1[0]: tim[0];
assign xyz =   eav | sav;
assign h_bit = ce_toggles?  d1a_1[6]: d1a[6];
assign v_bit = ce_toggles?  d1a_1[7]: d1a[7];
assign f_bit = ce_toggles?  d1a_1[8]: d1a[8]; 
 
//XYZ_Detect
assign hblank_set    = xyz &  h_bit & !hblank;
//XYZ_Translate
assign hblank_rst  = xyz & !h_bit &  hblank;
assign vblank_set    = xyz &  v_bit & !vblank;
assign vblank_reset  = xyz & !v_bit &  vblank;
assign field_id_set  = xyz &  f_bit & !field_id;
assign field_id_reset  = xyz & !f_bit & field_id; 
assign act_vid_set   = hblank_reset & !vblank; //end blank
assign act_vid_reset = hblank_set;    // start blank

always @(posedge clk) begin
  if (rst) begin
    tim_1 <= 0;
    d1a_1 <= 0;
  end
  else if (rx_mode !=1 || rx_ce_sd) begin
    tim_1 <= tim;
    d1a_1 <= d1a;
  end 
end

always @(posedge clk) begin  // delay hblank_reset
  if (rx_mode !=1 || rx_ce_sd) begin
    hblank_rst_1 <= hblank_rst;
    hblank_rst_2 <= hblank_rst_1;
    hblank_rst_3 <= hblank_rst_2;
    hblank_reset <= hblank_rst_3;
  end
end
     
always @(posedge clk) begin
  if (rst) begin
    pre_act_vid      <= 0;
    pre_hblank       <= 0;
    pre_vblank       <= 0;
    pre_field_id     <= 0;
  end
  else begin
    if (rx_mode_locked && (rx_mode !=1 || rx_ce_sd)) begin

      if (act_vid_reset)  
        pre_act_vid <= 0;
    else if (act_vid_set)
      pre_act_vid <= 1;

      if (hblank_reset)
        pre_hblank <= 0;
    else if (hblank_set)
      pre_hblank <= 1;
      
    if (vblank_reset)
      pre_vblank <= 0;
    else if (vblank_set)
      pre_vblank <= 1;

      if (field_id_reset)
        pre_field_id <= 0;
    else if (field_id_set)
      pre_field_id <= 1;

    end 
  end
end

always @ (posedge clk) begin
  if (rst) begin
    active_video <= 0;
    hblank       <= 0;
    vblank       <= 0;
    field_id     <= 0;
  end
  else if (rx_mode !=1 || vid_ce) begin
    active_video <= pre_act_vid;
    hblank       <= pre_hblank;
    vblank       <= pre_vblank;
    field_id     <= pre_field_id;
  end
end

endmodule
