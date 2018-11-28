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

This module implements the SDI TX data formatting operations for a Y/C data
stream pair. The funtions it implements are ST 352 PID packet generation & 
insertion, line number insertion, and CRC generation and insertion.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_tx_v1_0_0_channel (
    input  wire             clk,                // txusrclk
    input  wire             ce,                 // clock enable
    input  wire             rst,                // sync reset input
    input  wire             sd_mode,            // 1 in SD-SDI mode, 0 in other modes
    input  wire             insert_crc,         // 1 = insert CRC for HD and 3G
    input  wire             insert_ln,          // 1 = insert LN for HD and 3G
    input  wire             insert_st352,       // 1 = insert st352 PID packets
    input  wire             overwrite_st352,    // 1= overwrite existing ST 352 packets
    input  wire [10:0]      line,               // current line number
    input  wire [10:0]      st352_line_f1,      // line number in field 1 to insert ST 352
    input  wire [10:0]      st352_line_f2,      // line number in field 2 to insert ST 352
    input  wire             st352_f2_en,        // 1 = insert packets on st352_line_f2 line
    input  wire [31:0]      st352_data,         // {byte4, byte3, byte2, byte1} 
    input  wire [9:0]       ds1_in,             // data stream 1 (Y) in
    input  wire [9:0]       ds2_in,             // data stream 2 (C) in -- not used in SD-SDI mode
    output wire [9:0]       ds1_st352_out,      // data stream 1 after ST352 insertion
    output wire [9:0]       ds2_st352_out,      // data stream 2 after ST352 insertion
    input  wire [9:0]       ds1_anc_in,         // data stream 1 after ANC insertion input
    input  wire [9:0]       ds2_anc_in,         // data stream 2 after ANC section input
    input  wire             use_anc_in,         // use the ds[1/2]_anc_in ports
    output reg  [9:0]       ds1_out = 10'b0,    // data stream 1 (Y) out
    output reg  [9:0]       ds2_out = 10'b0     // data stream 2 (C) out
);

//
// Internal signals
//
reg  [9:0]      ds1_anc = 10'b0;
reg  [9:0]      ds2_anc = 10'b0;
wire            eav;
wire            sav;
reg  [3:0]      eav_dly = 4'b0000;          // generates timing signals based on EAV
wire [9:0]      ds1_ln_out;
wire [9:0]      ds2_ln_out;
reg             crc_en = 1'b0;              // CRC control signal
reg             clr_crc = 1'b0;             // CRC control signal
wire [17:0]     ds1_crc;
wire [17:0]     ds2_crc;
wire [9:0]      ds1_crc_out;
wire [9:0]      ds2_crc_out;

//
// ST352 Payload ID packet insertion
//
v_smpte_uhdsdi_tx_v1_0_0_st352_pid_insert ST352 (
    .clk        (clk),
    .ce         (ce),
    .rst        (rst),
    .hd_sd      (sd_mode),
    .level_b    (1'b0),
    .enable     (insert_st352),
    .overwrite  (overwrite_st352),
    .line       (line),
    .line_a     (st352_line_f1),
    .line_b     (st352_line_f2),
    .line_b_en  (st352_f2_en),
    .byte1      (st352_data[7:0]),
    .byte2      (st352_data[15:8]),
    .byte3      (st352_data[23:16]),
    .byte4      (st352_data[31:24]),
    .y_in       (ds1_in),
    .c_in       (ds2_in),
    .y_out      (ds1_st352_out),
    .c_out      (ds2_st352_out),
    .eav_out    (),
    .sav_out    ());

//
// These muxes either pass the output of the st352pid_insert module on to the
// rest of the channel (when use_anc_in = 0) or pass the dsx_anc_in streams to
// the reset of the channel (when use_anc_in = 1).
//
always @ (posedge clk)
    if (ce)
    begin
        ds1_anc <= use_anc_in ? ds1_anc_in : ds1_st352_out;
        ds2_anc <= use_anc_in ? ds2_anc_in : ds2_st352_out;
    end

//
// Generate EAV and SAV timing signals from input data
//
v_smpte_uhdsdi_tx_v1_0_0_trsgen TRS (
    .clk        (clk),
    .ce         (ce),
    .din_rdy    (1'b1),
    .video      (ds1_anc),
    .eav        (eav),
    .sav        (sav));

//
// EAV delay register
//
// Generates timing control signals for line number insertion and CRC generation
// and insertion.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst) 
            eav_dly <= 0;
        else if (ce)
            eav_dly <= {eav_dly[2:0], eav};
    end

//
// Line number formatting and insertion modules
//
v_smpte_uhdsdi_tx_v1_0_0_insert_ln INSLN (
    .insert_ln  (insert_ln),
    .ln_word0   (eav_dly[0]),
    .ln_word1   (eav_dly[1]),
    .c_in       (ds2_anc),
    .y_in       (ds1_anc),
    .ln         (line),
    .c_out      (ds2_ln_out),
    .y_out      (ds1_ln_out));
        
//
// Generate timing control signals for the CRC calculators.
//
// The crc_en signal determines which words are included into the CRC 
// calculation. All words that enter the hdsdi_crc module when crc_en is high
// are included in the calculation. To meet the HD-SDI spec, the CRC calculation
// must being with the first word after the SAV and end after the second line
// number word after the EAV.
//
// The clr_crc signal clears the internal registers of the hdsdi_crc modules to
// cause a new CRC calculation to begin. The crc_en signal is asserted during
// the XYZ word of the SAV since the next word after the SAV XYZ word is the
// first word to be included into the new CRC calculation.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            crc_en <= 1'b0;
        else if (ce)
            begin
                if (sav)
                    crc_en <= 1'b1;
                else if (eav_dly[1])
                    crc_en <= 1'b0;
            end
    end

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            clr_crc <= 1'b0;
        else if (ce)
            clr_crc <= sav;
    end

//
// Instantiate the CRC generators
//
v_smpte_uhdsdi_tx_v1_0_0_crc2 CRC1 (
    .clk        (clk),
    .ce         (ce),
    .en         (crc_en),
    .rst        (rst),
    .clr        (clr_crc),
    .d          (ds1_ln_out),
    .crc_out    (ds1_crc)
);

v_smpte_uhdsdi_tx_v1_0_0_crc2 CRC2 (
    .clk        (clk),
    .ce         (ce),
    .en         (crc_en),
    .rst        (rst),
    .clr        (clr_crc),
    .d          (ds2_ln_out),
    .crc_out    (ds2_crc)
);

//
// Insert the CRC values into the data streams. The CRC values are inserted
// after the line number words after the EAV.
//
v_smpte_uhdsdi_tx_v1_0_0_insert_crc INSCRC (
    .insert_crc (insert_crc),
    .crc_word0  (eav_dly[2]),
    .crc_word1  (eav_dly[3]),
    .y_in       (ds1_ln_out),
    .c_in       (ds2_ln_out),
    .y_crc      (ds1_crc),
    .c_crc      (ds2_crc),
    .y_out      (ds1_crc_out),
    .c_out      (ds2_crc_out));

always @ (posedge clk)
    if (ce)
    begin
        ds1_out <= ds1_crc_out;
        ds2_out <= ds2_crc_out;
    end

endmodule
