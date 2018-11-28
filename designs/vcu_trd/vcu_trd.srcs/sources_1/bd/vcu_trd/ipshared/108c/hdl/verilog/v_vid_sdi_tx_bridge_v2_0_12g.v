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
// This bridge converts native video to 6G/12G-SDI virtual
// data streams according to SMPTE ST 2082-1. It supports
// YUV 4:2:2 10 bits-per-componet. The source image is 
// converted to four sub-images using the 2-sample
// interleave sub-division method. Each of the sub-images
// is divided into two 10-bit data streams. The first data
// stream is the luma component and the second data stream
// is the chorma component. Each data stream includes sync
// and timing (TRS) words.
// 
//----------------------------------------------------------

`timescale 1ps/1ps
`default_nettype none

module v_vid_sdi_tx_bridge_v2_0_0_12g #(
  parameter C_PPC = 4,                         // Pixels-per-clock: 1,2,4
  parameter C_VID_DUTY_CYCLE = 1,              // 0-full duty cycle, 1-half duty cycle, 3-quarter duty cycle
  parameter C_SDI_DUTY_CYCLE = 1,              // 0-full duty cycle, 1-half duty cycle, 3-quarter duty cycle
  parameter C_SIM_MODE = 0
) (
  input  wire                CLK_IN,           // Clock
  input  wire                RST_IN,           // Reset, active high
  // Native Video Interface
  input  wire [C_PPC*20-1:0] VID_DATA_IN,      // Native video data
  input  wire                VID_VALID_IN,     // Native video data enable
  input  wire                VID_HBLANK_IN,    // Native video horizontal blank
  input  wire                VID_VBLANK_IN,    // Native video vertical blank
  output wire                VID_CE_OUT,       // Native clock enable
  // SDI Virtual Interface
  output wire [10-1:0]       SDI_DS1_OUT,      // SDI data stream 1
  output wire [10-1:0]       SDI_DS2_OUT,      // SDI data stream 2
  output wire [10-1:0]       SDI_DS3_OUT,      // SDI data stream 3
  output wire [10-1:0]       SDI_DS4_OUT,      // SDI data stream 4
  output wire [10-1:0]       SDI_DS5_OUT,      // SDI data stream 5
  output wire [10-1:0]       SDI_DS6_OUT,      // SDI data stream 6
  output wire [10-1:0]       SDI_DS7_OUT,      // SDI data stream 7
  output wire [10-1:0]       SDI_DS8_OUT,      // SDI data stream 8
  output wire [11-1:0]       SDI_DSX_LINE_OUT, // SDI line number
  output wire                SDI_CE_OUT,       // SDI clock enable
  // Video format 
  // 00 - 4:2:2
  // 01 - 4:2:0
  // 10 - Reserved
  // 11 - Reserved
  input  wire [1:0]    vid_frmt,
  // Error Flag
  output wire [4-1:0]        ERROR_OUT         // Error
);

  // Internal signals
  wire          vid_clken;
  wire          sdi_clken;

  wire [80-1:0] vid_data_from_converter;
  wire          vid_valid_from_converter;
  wire          vid_hblank_from_converter;
  wire          vid_vblank_from_converter;
  wire          vid_strobe_from_converter;

  wire [80-1:0] vid_data_from_clamp;
  wire          vid_valid_from_clamp;
  wire          vid_hblank_from_clamp;
  wire          vid_vblank_from_clamp;

  wire          sdi_valid_from_formatter;
  wire          sdi_vblank_from_formatter;
  wire          sdi_hblank_from_formatter;
  wire [20-1:0] sdi_subimg1_from_formatter;
  wire [20-1:0] sdi_subimg2_from_formatter;
  wire [20-1:0] sdi_subimg3_from_formatter;
  wire [20-1:0] sdi_subimg4_from_formatter;
  wire [4-1:0]  error_from_formatter;

  v_vid_sdi_tx_bridge_v2_0_0_12g_ce_gen #(
    .C_VID_DUTY_CYCLE(C_VID_DUTY_CYCLE),
    .C_SDI_DUTY_CYCLE(C_SDI_DUTY_CYCLE) 
  ) CLKEN_INST (
    .CLK_IN(CLK_IN),
    .RST_IN(RST_IN),
    .VID_CLKEN_OUT(vid_clken),
    .SDI_CLKEN_OUT(sdi_clken)
  );

  v_vid_sdi_tx_bridge_v2_0_0_12g_converter #(
    .C_PPC(C_PPC)
  ) CONVERTER_INST (
    .CLK_IN(CLK_IN),
    .CLKEN_IN(vid_clken),
    .RST_IN(RST_IN),
    // Native Video Interface Inputs
    .VID_DATA_IN(VID_DATA_IN),
    .VID_VALID_IN(VID_VALID_IN),
    .VID_HBLANK_IN(VID_HBLANK_IN),
    .VID_VBLANK_IN(VID_VBLANK_IN),
    // Native Video Interface Outputs
    .VID_DATA_OUT(vid_data_from_converter),
    .VID_VALID_OUT(vid_valid_from_converter),
    .VID_HBLANK_OUT(vid_hblank_from_converter),
    .VID_VBLANK_OUT(vid_vblank_from_converter),
    .VID_STROBE_OUT(vid_strobe_from_converter)
  );

  v_vid_sdi_tx_bridge_v2_0_0_12g_clamp CLAMP_INST (
    .CLK_IN(CLK_IN),
    .CLKEN_IN(vid_strobe_from_converter),
    .RST_IN(RST_IN),
    // Native Video Interface Inputs
    .VID_DATA_IN(vid_data_from_converter),
    .VID_VALID_IN(vid_valid_from_converter),
    .VID_HBLANK_IN(vid_hblank_from_converter),
    .VID_VBLANK_IN(vid_vblank_from_converter),
    // Native Video Interface Outputs
    .VID_DATA_OUT(vid_data_from_clamp),
    .VID_VALID_OUT(vid_valid_from_clamp),
    .VID_HBLANK_OUT(vid_hblank_from_clamp),
    .VID_VBLANK_OUT(vid_vblank_from_clamp)
  );

  // Instantiate Sub-Image Formatter
  v_vid_sdi_tx_bridge_v2_0_0_12g_formatter SUBIMAGE_FORMATTER_INST 
  (
    .CLK_IN(CLK_IN),
    .RST_IN(RST_IN),
    // Native Video Interface
    .VID_CLKEN_IN(vid_strobe_from_converter),
    .VID_DATA_IN(vid_data_from_clamp),
    .VID_VALID_IN(vid_valid_from_clamp),
    .VID_HBLANK_IN(vid_hblank_from_clamp),
    .VID_VBLANK_IN(vid_vblank_from_clamp),
    // SDI Sub-Image Interface
    .SDI_CLKEN_IN(sdi_clken),
    .SDI_VBLANK_OUT(sdi_vblank_from_formatter),
    .SDI_HBLANK_OUT(sdi_hblank_from_formatter),
    .SDI_VALID_OUT(sdi_valid_from_formatter),
    .SDI_SUBIMG1_OUT(sdi_subimg1_from_formatter),
    .SDI_SUBIMG2_OUT(sdi_subimg2_from_formatter),
    .SDI_SUBIMG3_OUT(sdi_subimg3_from_formatter),
    .SDI_SUBIMG4_OUT(sdi_subimg4_from_formatter),
    .vid_frmt(vid_frmt),
    // Error Flag
    .ERROR_OUT(error_from_formatter)
  );

  // Instantiate Embedder
  v_vid_sdi_tx_bridge_v2_0_0_12g_embedder #(
  .C_SIM_MODE(C_SIM_MODE)
  ) EMBEDDER_INST (
    .CLK_IN(CLK_IN),
    .CLKEN_IN(sdi_clken),
    .RST_IN(RST_IN),
    // SDI Sub-Image Interface
    .SDI_VBLANK_IN(sdi_vblank_from_formatter),
    .SDI_HBLANK_IN(sdi_hblank_from_formatter),
    .SDI_VALID_IN(sdi_valid_from_formatter),
    .SDI_SUBIMG1_IN(sdi_subimg1_from_formatter),
    .SDI_SUBIMG2_IN(sdi_subimg2_from_formatter),
    .SDI_SUBIMG3_IN(sdi_subimg3_from_formatter),
    .SDI_SUBIMG4_IN(sdi_subimg4_from_formatter),
    // SDI Virtual Interface
    .SDI_DS1_OUT(SDI_DS1_OUT),  // Sub-Image-1 Y
    .SDI_DS2_OUT(SDI_DS2_OUT),  // Sub-Image-1 Cb/Cr
    .SDI_DS3_OUT(SDI_DS3_OUT),  // Sub-Image-2 Y
    .SDI_DS4_OUT(SDI_DS4_OUT),  // Sub-Image-2 Cb/Cr
    .SDI_DS5_OUT(SDI_DS5_OUT),  // Sub-Image-3 Y
    .SDI_DS6_OUT(SDI_DS6_OUT),  // Sub-Image-3 Cb/Cr
    .SDI_DS7_OUT(SDI_DS7_OUT),  // Sub-Image-4 Y
    .SDI_DS8_OUT(SDI_DS8_OUT),  // Sub-Image-4 Cb/Cr
    .SDI_DSX_LINE_OUT(SDI_DSX_LINE_OUT)  // EAV Line Count
  );

  // Output assignments
  assign VID_CE_OUT = vid_clken;
  assign SDI_CE_OUT = sdi_clken;
  assign ERROR_OUT = error_from_formatter;

endmodule

`default_nettype wire
