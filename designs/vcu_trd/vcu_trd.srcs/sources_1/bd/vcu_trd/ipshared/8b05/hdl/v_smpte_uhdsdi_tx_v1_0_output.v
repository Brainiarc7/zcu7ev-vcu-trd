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

This is the output module for the SDI transmitter. It contains the multiplexer,
the scrambler, and the SD-SDI bit replicator.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_tx_v1_0_0_output #(
    parameter C_LINE_RATE = 0
    )
(
    input  wire             clk,                // 74.25 MHz (HD) or 148.5 MHz (SD/3G)
    input  wire             ce,                 // data stream mux clock enable
    input  wire             sd_ce,              // SD-SDI clock enable, must be High in all other modes
    input  wire             rst,                // sync reset input
    input  wire [2:0]       mode,               // data path mode: 00 = HD or 3GA, 01 = SD, 10 = 3GB
    input  wire [2:0]       mux_pattern,        // specifies the multiplex interleave pattern
    input  wire [9:0]       ds1,                // SD Y/C input, HD Y input, 3G Y input, dual link A_Y input
    input  wire             insert_sync_bit,    // 1 enables the 6G/12G sync bit insertion function
    input  wire [9:0]       ds2,                // C
    input  wire [9:0]       ds3,                // Y
    input  wire [9:0]       ds4,                // C
    input  wire [9:0]       ds5,                // Y
    input  wire [9:0]       ds6,                // C
    input  wire [9:0]       ds7,                // Y
    input  wire [9:0]       ds8,                // C
    input  wire [9:0]       ds9,                // Y
    input  wire [9:0]       ds10,               // C
    input  wire [9:0]       ds11,               // Y
    input  wire [9:0]       ds12,               // C
    input  wire [9:0]       ds13,               // Y
    input  wire [9:0]       ds14,               // C
    input  wire [9:0]       ds15,               // Y
    input  wire [9:0]       ds16,               // C
    input  wire             sd_bitrep_bypass,   // 1 bypasses the SD-SDI 11X bit replicator
    output wire [39:0]      txdata,             // output data stream
    output wire             ce_align_err);      // 1 if ce 5/6/5/6 cadence is broken


//
// Internal signals
//
wire [39:0]     mux_out;
wire [39:0]     sync_insert_out;
wire [39:0]     sync_insert_mux;
wire [39:0]     scram_out;
wire [19:0]     sd_bit_rep_out;             // output of SD 11X bit replicate
reg  [39:0]     txdata_reg = 40'b0;
wire            align_err;
wire            mode_SD;

//
// SDI data stream MUX
//
v_smpte_uhdsdi_tx_v1_0_0_mux #(
    .C_LINE_RATE (C_LINE_RATE)
    )
DSMUX (
    .clk        (clk),
    .ce         (ce),
    .pattern    (mux_pattern),
    .ds1        (ds1),
    .ds2        (ds2),
    .ds3        (ds3),
    .ds4        (ds4),
    .ds5        (ds5),
    .ds6        (ds6),
    .ds7        (ds7),
    .ds8        (ds8),
    .ds9        (ds9),
    .ds10       (ds10),
    .ds11       (ds11),
    .ds12       (ds12),
    .ds13       (ds13),
    .ds14       (ds14),
    .ds15       (ds15),
    .ds16       (ds16),
    .dout       (mux_out));


//
// This is the syncbit insertion module that replaces 3FF words with 3FD and
// 000 words with 002. This only operates in 6G and 12G modes.
//
generate 
    if(C_LINE_RATE == 0)
    begin
v_smpte_uhdsdi_tx_v1_0_0_syncbit_insert SBINS (
    .clk        (clk),
    .enable     (insert_sync_bit),
    .din        (mux_out),
    .dout       (sync_insert_out));

assign sync_insert_mux = (mode[2] & insert_sync_bit) ? sync_insert_out : mux_out;
    end
    else
    begin
        assign sync_insert_mux = mux_out;
    end
endgenerate

//
// SDI scrambler
//
v_smpte_uhdsdi_tx_v1_0_0_encoder #(
    .C_LINE_RATE (C_LINE_RATE)
    )
SCRAM (
    .clk        (clk),
    .ce         (sd_ce),
    .mode       (mode),
    .nrzi       (1'b1),
    .scram      (1'b1),
    .d          (sync_insert_mux),
    .q          (scram_out)); 

//
// SD-SDI 11X bit replicater
//
v_smpte_uhdsdi_tx_v1_0_0_bitrep_20b BITREP (
    .clk        (clk),
    .rst        (rst),
    .ce         (sd_ce),
    .d          (scram_out[19:10]),
    .q          (sd_bit_rep_out),
    .align_err  (align_err));

assign mode_SD = mode == 3'b001;
assign ce_align_err = align_err & mode_SD;

//
// Output register
//
always @ (posedge clk)
    if (mode_SD & ~sd_bitrep_bypass)
        txdata_reg <= sd_bit_rep_out;
    else
        txdata_reg <= scram_out;

assign txdata = txdata_reg;

endmodule
