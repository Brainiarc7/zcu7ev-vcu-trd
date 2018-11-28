// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
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
// 
//------------------------------------------------------------------------------
/*
Module Description:

This module implements the SDI TX data path.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_tx_v1_0_0_tx #(
    parameter INCLUDE_TX_EDH_PROCESSOR = 1, 
	parameter C_LINE_RATE              = 0			
    ) 
(
    input  wire             clk,                // txusrclk
    input  wire             ce,                 // clock enable
    input  wire             sd_ce,              // SD-SDI clock enable, must be High in all other modes
    input  wire             edh_ce,             // EDH clock enable, recommended Low in all modes except SD-SDI
    input  wire             rst,                // sync reset input
    input  wire [2:0]       mode,               // SDI mode
    input  wire             insert_crc,         // 1 = insert CRC for HD and 3G
    input  wire             insert_ln,          // 1 = insert LN for HD and 3G
    input  wire             insert_st352,       // 1 = insert st352 PID packets
    input  wire             overwrite_st352,    // 1 = overwrite existing ST 352 packets
    input  wire             insert_edh,         // 1 = generate & insert EDH packets in SD-SDI mode
    input  wire [2:0]       mux_pattern,        // specifies the multiplex interleave pattern of data streams
    input  wire             insert_sync_bit,    // 1 enables sync bit insertion
    input  wire             sd_bitrep_bypass,   // 1 bypasses the SD-SDI 11X bit replicator
    input  wire [10:0]      line_ch0,           // current line number for channel 0
    input  wire [10:0]      line_ch1,           // current line number for channel 1
    input  wire [10:0]      line_ch2,           // current line number for channel 2
    input  wire [10:0]      line_ch3,           // current line number for channel 3
    input  wire [10:0]      line_ch4,           // current line number for channel 4
    input  wire [10:0]      line_ch5,           // current line number for channel 5
    input  wire [10:0]      line_ch6,           // current line number for channel 6
    input  wire [10:0]      line_ch7,           // current line number for channel 7
    input  wire [10:0]      st352_line_f1,      // line number in field 1 to insert ST 352
    input  wire [10:0]      st352_line_f2,      // line number in field 2 to insert ST 352
    input  wire             st352_f2_en,        // 1 = insert packets on st352_line_f2 line
    input  wire [31:0]      st352_data_ch0,     // ST352 data bytes for channel 0 {byte4, byte3, byte2, byte1} 
    input  wire [31:0]      st352_data_ch1,     // ST352 data bytes for channel 1 {byte4, byte3, byte2, byte1} 
    input  wire [31:0]      st352_data_ch2,     // ST352 data bytes for channel 2 {byte4, byte3, byte2, byte1} 
    input  wire [31:0]      st352_data_ch3,     // ST352 data bytes for channel 3 {byte4, byte3, byte2, byte1} 
    input  wire [31:0]      st352_data_ch4,     // ST352 data bytes for channel 4 {byte4, byte3, byte2, byte1} 
    input  wire [31:0]      st352_data_ch5,     // ST352 data bytes for channel 5 {byte4, byte3, byte2, byte1} 
    input  wire [31:0]      st352_data_ch6,     // ST352 data bytes for channel 6 {byte4, byte3, byte2, byte1} 
    input  wire [31:0]      st352_data_ch7,     // ST352 data bytes for channel 7 {byte4, byte3, byte2, byte1} 
    input  wire [9:0]       ds1_in,             // data stream 1 (Y) in
    input  wire [9:0]       ds2_in,             // data stream 2 (C) in -- not used in SD-SDI mode
    input  wire [9:0]       ds3_in,             // data stream 3 (Y) in
    input  wire [9:0]       ds4_in,             // data stream 4 (C) in
    input  wire [9:0]       ds5_in,             // data stream 5 (Y) in
    input  wire [9:0]       ds6_in,             // data stream 6 (C) in
    input  wire [9:0]       ds7_in,             // data stream 7 (Y) in
    input  wire [9:0]       ds8_in,             // data stream 8 (C) in
    input  wire [9:0]       ds9_in,             // data stream 9 (Y) in
    input  wire [9:0]       ds10_in,            // data stream 10 (C) in
    input  wire [9:0]       ds11_in,            // data stream 11 (Y) in
    input  wire [9:0]       ds12_in,            // data stream 12 (C) in
    input  wire [9:0]       ds13_in,            // data stream 13 (Y) in
    input  wire [9:0]       ds14_in,            // data stream 14 (C) in
    input  wire [9:0]       ds15_in,            // data stream 15 (Y) in
    input  wire [9:0]       ds16_in,            // data stream 16 (C) in
    output wire [9:0]       ds1_st352_out,      // data stream 1 after ST352 insertion
    output wire [9:0]       ds2_st352_out,      // data stream 2 after ST352 insertion
    output wire [9:0]       ds3_st352_out,      // data stream 3 after ST352 insertion
    output wire [9:0]       ds4_st352_out,      // data stream 4 after ST352 insertion
    output wire [9:0]       ds5_st352_out,      // data stream 5 after ST352 insertion
    output wire [9:0]       ds6_st352_out,      // data stream 6 after ST352 insertion
    output wire [9:0]       ds7_st352_out,      // data stream 7 after ST352 insertion
    output wire [9:0]       ds8_st352_out,      // data stream 8 after ST352 insertion
    output wire [9:0]       ds9_st352_out,      // data stream 9 after ST352 insertion
    output wire [9:0]       ds10_st352_out,     // data stream 10 after ST352 insertion
    output wire [9:0]       ds11_st352_out,     // data stream 11 after ST352 insertion
    output wire [9:0]       ds12_st352_out,     // data stream 12 after ST352 insertion
    output wire [9:0]       ds13_st352_out,     // data stream 13 after ST352 insertion
    output wire [9:0]       ds14_st352_out,     // data stream 14 after ST352 insertion
    output wire [9:0]       ds15_st352_out,     // data stream 15 after ST352 insertion
    output wire [9:0]       ds16_st352_out,     // data stream 16 after ST352 insertion
    input  wire [9:0]       ds1_anc_in,         // data stream 1 after ANC insertion input
    input  wire [9:0]       ds2_anc_in,         // data stream 2 after ANC insertion input
    input  wire [9:0]       ds3_anc_in,         // data stream 3 after ANC section input
    input  wire [9:0]       ds4_anc_in,         // data stream 4 after ANC section input
    input  wire [9:0]       ds5_anc_in,         // data stream 5 after ANC section input
    input  wire [9:0]       ds6_anc_in,         // data stream 6 after ANC section input
    input  wire [9:0]       ds7_anc_in,         // data stream 7 after ANC section input
    input  wire [9:0]       ds8_anc_in,         // data stream 8 after ANC section input
    input  wire [9:0]       ds9_anc_in,         // data stream 9 after ANC section input
    input  wire [9:0]       ds10_anc_in,        // data stream 10 after ANC section input
    input  wire [9:0]       ds11_anc_in,        // data stream 11 after ANC section input
    input  wire [9:0]       ds12_anc_in,        // data stream 12 after ANC section input
    input  wire [9:0]       ds13_anc_in,        // data stream 13 after ANC section input
    input  wire [9:0]       ds14_anc_in,        // data stream 14 after ANC section input
    input  wire [9:0]       ds15_anc_in,        // data stream 15 after ANC section input
    input  wire [9:0]       ds16_anc_in,        // data stream 16 after ANC section input
    input  wire             use_anc_in,         // use the dsX_anc_in ports
    output wire [39:0]      txdata,             // output data stream to GT TXDATA port
    output wire             ce_align_err        // 1 if ce 5/6/5/6 cadence is broken in SD-SDI mode
);

//
// Internal signals
//
reg             sd_mode = 1'b0;
wire [9:0]      ds1_ch_out;
wire [9:0]      ds2_ch_out;
wire [9:0]      ds3_ch_out;
wire [9:0]      ds4_ch_out;
wire [9:0]      ds5_ch_out;
wire [9:0]      ds6_ch_out;
wire [9:0]      ds7_ch_out;
wire [9:0]      ds8_ch_out;
wire [9:0]      ds9_ch_out;
wire [9:0]      ds10_ch_out;
wire [9:0]      ds11_ch_out;
wire [9:0]      ds12_ch_out;
wire [9:0]      ds13_ch_out;
wire [9:0]      ds14_ch_out;
wire [9:0]      ds15_ch_out;
wire [9:0]      ds16_ch_out;
wire [9:0]      edh_mux;
wire [9:0]      edh_out;
wire [9:0]      ch1_in_mux;
wire [10:0]     ch1_line_mux;
reg             mode_3ga = 1'b0;
wire [9:0]      ds2_ch_out_int;
wire [9:0]      ds2_st352_out_int;

always @ (posedge clk)
    if (ce)
        sd_mode <= mode == 3'b001;

always @ (posedge clk)
    if (ce)
        mode_3ga <= (mode == 3'b010) && (mux_pattern == 3'b000);

//
// UHD-SDI TX channels
//
v_smpte_uhdsdi_tx_v1_0_0_channel CH0 (
    .clk            (clk),
    .ce             (ce & sd_ce),
    .rst            (rst),
    .sd_mode        (sd_mode),
    .insert_crc     (insert_crc & ~sd_mode),
    .insert_ln      (insert_ln & ~sd_mode),
    .insert_st352   (insert_st352),
    .overwrite_st352(overwrite_st352),
    .line           (line_ch0),
    .st352_line_f1  (st352_line_f1),
    .st352_line_f2  (st352_line_f2),
    .st352_f2_en    (st352_f2_en),
    .st352_data     (st352_data_ch0),
    .ds1_in         (ds1_in),
    .ds2_in         (ds2_in),
    .ds1_st352_out  (ds1_st352_out),
    .ds2_st352_out  (ds2_st352_out_int),
    .ds1_anc_in     (ds1_anc_in),
    .ds2_anc_in     (ds2_anc_in),
    .use_anc_in     (use_anc_in),
    .ds1_out        (ds1_ch_out),
    .ds2_out        (ds2_ch_out_int));

//
// These muxes are used to route ds2 through the CH1 TX channel in 3G-SDI level A
// mode because ST352 packets need to be inserted into both ds1 and ds2 in 3G-SDI
// level A mode only.
//
assign ch1_in_mux = mode_3ga ? ds2_in : ds3_in;
assign ds2_ch_out = (mode_3ga & ~use_anc_in) ? ds3_ch_out : ds2_ch_out_int;
assign ds2_st352_out = mode_3ga ? ds3_st352_out : ds2_st352_out_int;
assign ch1_line_mux = mode_3ga ? line_ch0 : line_ch1;

v_smpte_uhdsdi_tx_v1_0_0_channel CH1 (
    .clk            (clk),
    .ce             (ce),
    .rst            (rst),
    .sd_mode        (sd_mode),
    .insert_crc     (insert_crc & ~sd_mode),
    .insert_ln      (insert_ln & ~sd_mode),
    .insert_st352   (insert_st352),
    .overwrite_st352(overwrite_st352),
    .line           (ch1_line_mux),
    .st352_line_f1  (st352_line_f1),
    .st352_line_f2  (st352_line_f2),
    .st352_f2_en    (st352_f2_en),
    .st352_data     (st352_data_ch1),
    .ds1_in         (ch1_in_mux),
    .ds2_in         (ds4_in),
    .ds1_st352_out  (ds3_st352_out),
    .ds2_st352_out  (ds4_st352_out),
    .ds1_anc_in     (ds3_anc_in),
    .ds2_anc_in     (ds4_anc_in),
    .use_anc_in     (use_anc_in),
    .ds1_out        (ds3_ch_out),
    .ds2_out        (ds4_ch_out));

generate
    if (C_LINE_RATE == 0)
    begin : SDI_ONLY_3G
v_smpte_uhdsdi_tx_v1_0_0_channel CH2 (
    .clk            (clk),
    .ce             (ce),
    .rst            (rst),
    .sd_mode        (sd_mode),
    .insert_crc     (insert_crc & ~sd_mode),
    .insert_ln      (insert_ln & ~sd_mode),
    .insert_st352   (insert_st352),
    .overwrite_st352(overwrite_st352),
    .line           (line_ch2),
    .st352_line_f1  (st352_line_f1),
    .st352_line_f2  (st352_line_f2),
    .st352_f2_en    (st352_f2_en),
    .st352_data     (st352_data_ch2),
    .ds1_in         (ds5_in),
    .ds2_in         (ds6_in),
    .ds1_st352_out  (ds5_st352_out),
    .ds2_st352_out  (ds6_st352_out),
    .ds1_anc_in     (ds5_anc_in),
    .ds2_anc_in     (ds6_anc_in),
    .use_anc_in     (use_anc_in),
    .ds1_out        (ds5_ch_out),
    .ds2_out        (ds6_ch_out));

v_smpte_uhdsdi_tx_v1_0_0_channel CH3 (
    .clk            (clk),
    .ce             (ce),
    .rst            (rst),
    .sd_mode        (sd_mode),
    .insert_crc     (insert_crc & ~sd_mode),
    .insert_ln      (insert_ln & ~sd_mode),
    .insert_st352   (insert_st352),
    .overwrite_st352(overwrite_st352),
    .line           (line_ch3),
    .st352_line_f1  (st352_line_f1),
    .st352_line_f2  (st352_line_f2),
    .st352_f2_en    (st352_f2_en),
    .st352_data     (st352_data_ch3),
    .ds1_in         (ds7_in),
    .ds2_in         (ds8_in),
    .ds1_st352_out  (ds7_st352_out),
    .ds2_st352_out  (ds8_st352_out),
    .ds1_anc_in     (ds7_anc_in),
    .ds2_anc_in     (ds8_anc_in),
    .use_anc_in     (use_anc_in),
    .ds1_out        (ds7_ch_out),
    .ds2_out        (ds8_ch_out));


v_smpte_uhdsdi_tx_v1_0_0_channel CH4 (
    .clk            (clk),
    .ce             (ce),
    .rst            (rst),
    .sd_mode        (sd_mode),
    .insert_crc     (insert_crc & ~sd_mode),
    .insert_ln      (insert_ln & ~sd_mode),
    .insert_st352   (insert_st352),
    .overwrite_st352(overwrite_st352),
    .line           (line_ch4),
    .st352_line_f1  (st352_line_f1),
    .st352_line_f2  (st352_line_f2),
    .st352_f2_en    (st352_f2_en),
    .st352_data     (st352_data_ch4),
    .ds1_in         (ds9_in),
    .ds2_in         (ds10_in),
    .ds1_st352_out  (ds9_st352_out),
    .ds2_st352_out  (ds10_st352_out),
    .ds1_anc_in     (ds9_anc_in),
    .ds2_anc_in     (ds10_anc_in),
    .use_anc_in     (use_anc_in),
    .ds1_out        (ds9_ch_out),
    .ds2_out        (ds10_ch_out));

v_smpte_uhdsdi_tx_v1_0_0_channel CH5 (
    .clk            (clk),
    .ce             (ce),
    .rst            (rst),
    .sd_mode        (sd_mode),
    .insert_crc     (insert_crc & ~sd_mode),
    .insert_ln      (insert_ln & ~sd_mode),
    .insert_st352   (insert_st352),
    .overwrite_st352(overwrite_st352),
    .line           (line_ch5),
    .st352_line_f1  (st352_line_f1),
    .st352_line_f2  (st352_line_f2),
    .st352_f2_en    (st352_f2_en),
    .st352_data     (st352_data_ch5),
    .ds1_in         (ds11_in),
    .ds2_in         (ds12_in),
    .ds1_st352_out  (ds11_st352_out),
    .ds2_st352_out  (ds12_st352_out),
    .ds1_anc_in     (ds11_anc_in),
    .ds2_anc_in     (ds12_anc_in),
    .use_anc_in     (use_anc_in),
    .ds1_out        (ds11_ch_out),
    .ds2_out        (ds12_ch_out));

v_smpte_uhdsdi_tx_v1_0_0_channel CH6 (
    .clk            (clk),
    .ce             (ce),
    .rst            (rst),
    .sd_mode        (sd_mode),
    .insert_crc     (insert_crc & ~sd_mode),
    .insert_ln      (insert_ln & ~sd_mode),
    .insert_st352   (insert_st352),
    .overwrite_st352(overwrite_st352),
    .line           (line_ch6),
    .st352_line_f1  (st352_line_f1),
    .st352_line_f2  (st352_line_f2),
    .st352_f2_en    (st352_f2_en),
    .st352_data     (st352_data_ch6),
    .ds1_in         (ds13_in),
    .ds2_in         (ds14_in),
    .ds1_st352_out  (ds13_st352_out),
    .ds2_st352_out  (ds14_st352_out),
    .ds1_anc_in     (ds13_anc_in),
    .ds2_anc_in     (ds14_anc_in),
    .use_anc_in     (use_anc_in),
    .ds1_out        (ds13_ch_out),
    .ds2_out        (ds14_ch_out));

v_smpte_uhdsdi_tx_v1_0_0_channel CH7 (
    .clk            (clk),
    .ce             (ce),
    .rst            (rst),
    .sd_mode        (sd_mode),
    .insert_crc     (insert_crc & ~sd_mode),
    .insert_ln      (insert_ln & ~sd_mode),
    .insert_st352   (insert_st352),
    .overwrite_st352(overwrite_st352),
    .line           (line_ch7),
    .st352_line_f1  (st352_line_f1),
    .st352_line_f2  (st352_line_f2),
    .st352_f2_en    (st352_f2_en),
    .st352_data     (st352_data_ch7),
    .ds1_in         (ds15_in),
    .ds2_in         (ds16_in),
    .ds1_st352_out  (ds15_st352_out),
    .ds2_st352_out  (ds16_st352_out),
    .ds1_anc_in     (ds15_anc_in),
    .ds2_anc_in     (ds16_anc_in),
    .use_anc_in     (use_anc_in),
    .ds1_out        (ds15_ch_out),
    .ds2_out        (ds16_ch_out));
  end
  else
  begin
      assign ds5_st352_out   =  10'd0; 
      assign ds6_st352_out   =  10'd0; 
      assign ds7_st352_out   =  10'd0; 
      assign ds8_st352_out   =  10'd0; 
      assign ds9_st352_out   =  10'd0; 
      assign ds10_st352_out  =  10'd0; 
      assign ds11_st352_out  =  10'd0; 
      assign ds12_st352_out  =  10'd0; 
      assign ds13_st352_out  =  10'd0; 
      assign ds14_st352_out  =  10'd0; 
      assign ds15_st352_out  =  10'd0;

      assign ds5_ch_out      =  10'd0;
      assign ds6_ch_out      =  10'd0;
      assign ds7_ch_out      =  10'd0;
      assign ds8_ch_out      =  10'd0;
      assign ds9_ch_out      =  10'd0;
      assign ds10_ch_out     =  10'd0;
      assign ds11_ch_out     =  10'd0;
      assign ds12_ch_out     =  10'd0;
      assign ds13_ch_out     =  10'd0;
      assign ds14_ch_out     =  10'd0;
      assign ds15_ch_out     =  10'd0;
  end
endgenerate

//
// SD-SDI EDH processor
//
generate
    if (INCLUDE_TX_EDH_PROCESSOR == 1)
    begin : INCLUDE_EDH
       v_smpte_uhdsdi_tx_v1_0_0_edh_processor TXEDH (
         .clk             (clk),
         .ce              (edh_ce),
         .rst             (rst),
         .vid_in          (ds1_ch_out),
         .reacquire       (1'b0),
         .en_sync_switch  (1'b0),
         .en_trs_blank    (1'b0),
         .anc_idh_local   (1'b0),
         .anc_ues_local   (1'b0),
         .ap_idh_local    (1'b0),
         .ff_idh_local    (1'b0),
         .errcnt_flg_en   (16'b0),
         .clr_errcnt      (1'b0),
         .receive_mode    (1'b0),
     
         .vid_out         (edh_out),
         .std             (),
         .std_locked      (),
         .trs             (),
         .field           (),
         .v_blank         (),
         .h_blank         (),
         .horz_count      (),
         .vert_count      (),
         .sync_switch     (),
         .locked          (),
         .eav_next        (),
         .sav_next        (),
         .xyz_word        (),
         .anc_next        (),
         .edh_next        (),
         .rx_ap_flags     (),
         .rx_ff_flags     (),
         .rx_anc_flags    (),
         .ap_flags        (),
         .ff_flags        (),
         .anc_flags       (),
         .packet_flags    (),
         .errcnt          (),
         .edh_packet      ());
         // This mux bypasses the EDH processor if insert_edh is 0.
         assign edh_mux = (sd_mode & insert_edh) ? edh_out : ds1_ch_out;
    end
    else
    begin : NO_EDH
        assign edh_out = 0;
        assign edh_mux = ds1_ch_out;
    end
endgenerate

//
// SDI TX output module
//
v_smpte_uhdsdi_tx_v1_0_0_output #(
    .C_LINE_RATE (C_LINE_RATE)
    )
    TXOUT  (
    .clk                (clk),
    .ce                 (ce),
    .sd_ce              (sd_ce),
    .rst                (rst),
    .mode               (mode),
    .mux_pattern        (mux_pattern),
    .insert_sync_bit    (insert_sync_bit),
    .ds1                (edh_mux),
    .ds2                (ds2_ch_out),
    .ds3                (ds3_ch_out),
    .ds4                (ds4_ch_out),
    .ds5                (ds5_ch_out),
    .ds6                (ds6_ch_out),
    .ds7                (ds7_ch_out),
    .ds8                (ds8_ch_out),
    .ds9                (ds9_ch_out),
    .ds10               (ds10_ch_out),
    .ds11               (ds11_ch_out),
    .ds12               (ds12_ch_out),
    .ds13               (ds13_ch_out),
    .ds14               (ds14_ch_out),
    .ds15               (ds15_ch_out),
    .ds16               (ds16_ch_out),
    .sd_bitrep_bypass   (sd_bitrep_bypass),
    .txdata             (txdata),
    .ce_align_err       (ce_align_err));

endmodule
