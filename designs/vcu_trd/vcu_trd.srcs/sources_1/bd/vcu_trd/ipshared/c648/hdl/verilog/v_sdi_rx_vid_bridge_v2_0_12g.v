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
// Module Description:
// 
// This bridge converts 6G/12G-SDI virtual data streams
// to native video according to SMPTE ST 2082-1. It supports
// YUV 4:2:2 10 bits-per-componet. The 10-bit data streams
// are converted to 4 sub-images. The timing is extracted 
// based on the timing (TRS) words. The inverse of the 2-sample
// interleave sub-division method is used to convert the 
// sub-images back to the native video format.
//
//----------------------------------------------------------

`timescale 1ps/1ps
`default_nettype none

module v_sdi_rx_vid_bridge_v2_0_0_12g #(
  parameter C_PPC = 4,            // Pixels-per-clock can be 1, 2, or 4
  parameter C_VID_DUTY_CYCLE = 1, // 0-full duty cycle, 1-half duty cycle, 3-quarter duty cycle
  parameter C_SDI_DUTY_CYCLE = 1  // 0-full duty cycle, 1-half duty cycle, 3-quarter duty cycle
) (
  input  wire                CLK_IN,          // Clock
  input  wire                RST_IN,          // Reset, active high
  // SDI Virtual Interface
  input  wire [10-1:0]       SDI_DS1_IN,      // SDI data stream 1 
  input  wire [10-1:0]       SDI_DS2_IN,      // SDI data stream 2 
  input  wire [10-1:0]       SDI_DS3_IN,      // SDI data stream 3 
  input  wire [10-1:0]       SDI_DS4_IN,      // SDI data stream 4 
  input  wire [10-1:0]       SDI_DS5_IN,      // SDI data stream 5
  input  wire [10-1:0]       SDI_DS6_IN,      // SDI data stream 6
  input  wire [10-1:0]       SDI_DS7_IN,      // SDI data stream 7
  input  wire [10-1:0]       SDI_DS8_IN,      // SDI data stream 8
  input  wire                SDI_CE_IN,       // SDI clock enable
  // Native Video Interface
  output wire [C_PPC*20-1:0] VID_DATA_OUT,    // Native video data
  output wire                VID_VALID_OUT,   // Native video active video
  output wire                VID_HBLANK_OUT,  // Native video horizontal blank
  output wire                VID_VBLANK_OUT,  // Native video vertical blank
  output wire                VID_FIELD_ID,    // Native video field-id, always low
  output wire                VID_CE_OUT,      // Native video clock enable
  // Error Flag
  output wire                ERROR_OUT        // Error
);

  // Internal signals
  wire            vid_clken;
  wire            sdi_clken;

  wire [20-1:0]   sdi_subimg1_from_detector; 
  wire [20-1:0]   sdi_subimg2_from_detector;
  wire [20-1:0]   sdi_subimg3_from_detector;
  wire [20-1:0]   sdi_subimg4_from_detector;
  wire            sdi_valid_from_detector;
  wire            sdi_hblank_from_detector;
  wire            sdi_vblank_from_detector;
  wire [16-1:0]   sdi_htotal_from_detector;
  wire            sdi_flag_from_detector;

  wire [80-1:0]   vid_data_from_formatter;
  wire            vid_valid_from_formatter;
  wire            vid_hblank_from_formatter;
  wire            vid_vblank_from_formatter;
  wire [4-1:0]    error_from_formatter;

  v_sdi_rx_vid_bridge_v2_0_0_12g_ce_gen #(
    .C_VID_DUTY_CYCLE(C_VID_DUTY_CYCLE),
    .C_SDI_DUTY_CYCLE(C_SDI_DUTY_CYCLE) 
  ) CLKEN_INST (
    .CLK_IN(CLK_IN),
    .RST_IN(RST_IN),
    .VID_CLKEN_OUT(vid_clken),
    .SDI_CLKEN_OUT(sdi_clken)
  );

  // Instantiate Timing Detector
  v_sdi_rx_vid_bridge_v2_0_0_12g_trs_decode TIMING_DETECTOR_INST 
  (
    .CLK_IN(CLK_IN),
    .CLKEN_IN(SDI_CE_IN),
    .RST_IN(RST_IN),
    // SDI Virtual Interface
    .SDI_DS1_IN(SDI_DS1_IN),
    .SDI_DS2_IN(SDI_DS2_IN),
    .SDI_DS3_IN(SDI_DS3_IN), 
    .SDI_DS4_IN(SDI_DS4_IN),
    .SDI_DS5_IN(SDI_DS5_IN),
    .SDI_DS6_IN(SDI_DS6_IN),
    .SDI_DS7_IN(SDI_DS7_IN),
    .SDI_DS8_IN(SDI_DS8_IN),
    // SDI Sub-Image Interface
    .SDI_SUBIMG1_OUT(sdi_subimg1_from_detector),
    .SDI_SUBIMG2_OUT(sdi_subimg2_from_detector),
    .SDI_SUBIMG3_OUT(sdi_subimg3_from_detector),
    .SDI_SUBIMG4_OUT(sdi_subimg4_from_detector),
    .SDI_VALID_OUT(sdi_valid_from_detector),
    .SDI_HBLANK_OUT(sdi_hblank_from_detector),
    .SDI_VBLANK_OUT(sdi_vblank_from_detector),
    .SDI_HTOTAL_OUT(sdi_htotal_from_detector),
    .SDI_FLAG_OUT(sdi_flag_from_detector)
  );

  v_sdi_rx_vid_bridge_v2_0_0_12g_formatter SUBIMAGE_FORMATTER_INST 
  (
    .CLK_IN(CLK_IN),
    .RST_IN(RST_IN),
    .CLKEN_IN(SDI_CE_IN),
    // SDI Sub-Image Interface
    .SDI_SUBIMG1_IN(sdi_subimg1_from_detector),
    .SDI_SUBIMG2_IN(sdi_subimg2_from_detector),
    .SDI_SUBIMG3_IN(sdi_subimg3_from_detector),
    .SDI_SUBIMG4_IN(sdi_subimg4_from_detector),
    .SDI_VALID_IN(sdi_valid_from_detector),
    .SDI_HBLANK_IN(sdi_hblank_from_detector),
    .SDI_VBLANK_IN(sdi_vblank_from_detector),
    .SDI_HTOTAL_IN(sdi_htotal_from_detector),
    .SDI_FLAG_IN(sdi_flag_from_detector),
    // Native Video Interface
    .VID_DATA_OUT(vid_data_from_formatter),
    .VID_VALID_OUT(vid_valid_from_formatter),
    .VID_HBLANK_OUT(vid_hblank_from_formatter),
    .VID_VBLANK_OUT(vid_vblank_from_formatter),
    // Error Flag
    .ERROR_OUT(error_from_formatter)
  );

  v_sdi_rx_vid_bridge_v2_0_0_12g_converter #(
    .C_PPC(C_PPC)
  ) CONVERTER_INST (
    .CLK_IN(CLK_IN),
    .CLKEN_IN(vid_clken),
    .RST_IN(RST_IN),
    // Native Video Interface Inputs
    .VID_DATA_IN(vid_data_from_formatter),
    .VID_VALID_IN(vid_valid_from_formatter),
    .VID_HBLANK_IN(vid_hblank_from_formatter),
    .VID_VBLANK_IN(vid_vblank_from_formatter),
    // Native Video Interface Outputs
    .VID_DATA_OUT(VID_DATA_OUT),
    .VID_VALID_OUT(VID_VALID_OUT),
    .VID_HBLANK_OUT(VID_HBLANK_OUT),
    .VID_VBLANK_OUT(VID_VBLANK_OUT)
  );

  // Output assignments
  assign VID_FIELD_ID = 1'b0;
  assign VID_CE_OUT = vid_clken;
  assign ERROR_OUT = error_from_formatter;

endmodule

`default_nettype wire
