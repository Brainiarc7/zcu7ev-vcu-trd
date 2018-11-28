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

This module calculates the CRC value for a line and compares it to the received
CRC value. The module does this for both the Y and C channels. If a CRC error
is detected, the corresponding CRC error output is asserted high. This output
remains asserted for one video line time, until the next CRC check is made.

The module also captures the line number values for the two channels and 
outputs them. The line number values are valid for the entire line time. 

--------------------------------------------------------------------------------
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_rx_v1_0_0_crc (
    input  wire         clk,                // receiver clock
    input  wire         rst,                // reset signal
    input  wire         ce,                 // clock enable input
    input  wire [9:0]   c_video,            // C channel video input port
    input  wire [9:0]   y_video,            // Y channel video input port
    input  wire         trs,                // TRS signal asserted during all 4 words of TRS
    output reg          c_crc_err = 1'b0,   // C channel CRC error detected
    output reg          y_crc_err = 1'b0,   // Y channel CRC error detected
    output reg  [10:0]  c_line_num = 0,     // C channel received line number
    output reg  [10:0]  y_line_num = 0      // Y channel received line number
);

// Internal wires
reg     [17:0]      c_rx_crc = 0;
reg     [17:0]      y_rx_crc = 0;
wire    [17:0]      c_calc_crc;
wire    [17:0]      y_calc_crc;
reg     [7:0]       trslncrc = 0;
reg                 crc_clr = 0;
reg                 crc_en = 0;
reg     [6:0]       c_line_num_int = 0;
reg     [6:0]       y_line_num_int = 0;

//
// CRC generator modules
//
v_smpte_uhdsdi_rx_v1_0_0_crc2 crc_C (
    .clk            (clk),
    .ce             (ce),
    .en             (crc_en),
    .rst            (rst),
    .clr            (crc_clr),
    .d              (c_video),
    .crc_out        (c_calc_crc)
);

v_smpte_uhdsdi_rx_v1_0_0_crc2 crc_Y (
    .clk            (clk),
    .ce             (ce),
    .en             (crc_en),
    .rst            (rst),
    .clr            (crc_clr),
    .d              (y_video),
    .crc_out        (y_calc_crc)
);


//
// trslncrc generator
//
// This code generates timing signals indicating where the CRC and LN words
// are located in the EAV symbol.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            trslncrc <= 0;
        else
        begin
            if (trs & ~trslncrc[0] & ~trslncrc[1] & ~trslncrc[2])
                trslncrc[0] <= 1'b1;
            else
                trslncrc[0] <= 1'b0;
            trslncrc[7:1] <= {trslncrc[6:3], trslncrc[2] & y_video[6], trslncrc[1:0]};
        end
    end

//
// crc_clr signal
//
// The crc_clr signal controls when the CRC generator's accumulation register
// gets reset to begin calculating the CRC for a new line.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            crc_clr <= 1'b0;
        else if (trslncrc[2] & ~y_video[6])
            crc_clr <= 1'b1;
        else
            crc_clr <= 1'b0;
    end
        
//
// crc_en signal
//
// The crc_en signal controls which words are included in the CRC calculation.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            crc_en <= 1'b0;
        else if (trslncrc[2] & ~y_video[6])
            crc_en <= 1'b1;
        else if (trslncrc[4])
            crc_en <= 1'b0;
    end
        
//
// received CRC registers
//
// These registers hold the received CRC words from the input video stream.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
        begin
            c_rx_crc <= 0;
            y_rx_crc <= 0;
        end
        else if (trslncrc[5])
        begin
            c_rx_crc[8:0] <= c_video[8:0];
            y_rx_crc[8:0] <= y_video[8:0];
        end
        else if (trslncrc[6])
        begin
            c_rx_crc[17:9] <= c_video[8:0];
            y_rx_crc[17:9] <= y_video[8:0];
        end
    end

//
// CRC comparators
//
// Compare the received CRC values against the calculated CRCs.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
        begin
            c_crc_err <= 1'b0;
            y_crc_err <= 1'b0;
        end
        else if (trslncrc[7])
        begin
            if (c_rx_crc == c_calc_crc)
                c_crc_err <= 1'b0;
            else
                c_crc_err <= 1'b1;

            if (y_rx_crc == y_calc_crc)
                y_crc_err <= 1'b0;
            else
                y_crc_err <= 1'b1;
        end
        else
        begin
            c_crc_err <= 1'b0;
            y_crc_err <= 1'b0;
        end
    end

//
// line number registers
//
// These registers hold the line number values from the input video stream.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
        begin
            c_line_num_int <= 0;
            y_line_num_int <= 0;
            c_line_num <= 0;
            y_line_num <= 0;
        end
        else if (trslncrc[3])
        begin
            c_line_num_int <= c_video[8:2];
            y_line_num_int <= y_video[8:2];
        end
        else if (trslncrc[4])
        begin
            c_line_num <= {c_video[5:2], c_line_num_int};
            y_line_num <= {y_video[5:2], y_line_num_int};
        end
    end

endmodule
