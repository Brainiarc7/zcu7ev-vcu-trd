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
This module calculates the active picture and full-frame CRC values. The ITU-R
BT.1304 and SMPTE RP 165-1994 standards define how the two CRC values are to be
calculated.

The module uses the vertical line count (vcnt) input, the field bit (f), the
horizontal blanking interval bit (h), and the eav_next, sav_next, and xyz_word
inputs to determine which samples to include in the two CRC calculations.

The calculation is a standard CRC16 calculation with a polynomial of x^16 + x^12
+ x^5 + 1. The function considers the LSB of the video data as the first bit
shifted into the CRC generator, although the implementation given here is a
fully parallel CRC, calculating all 16 CRC bits from the 10-bit video data in
one clock cycle.  The CRC calculation is done is the edh_crc16 module. It is 
instanced twice, once for the full-frame calculation and once for the active-
picture calculation.    

For each CRC calculation, a valid bit is also generated. After reset the valid
bits will be negated until the locked input from the video decoder is asserted.
The valid bits remain asserted even if locked is negated. However, the valid
bits will be negated for one filed if the locked signal rises during a CRC
calculation, indicating that the video decoder has re-synchronized.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_tx_v1_0_0_edh_crc #(
    parameter VCNT_WIDTH    = 10)
(
    input  wire                     clk,            // clock input
    input  wire                     ce,             // clock enable
    input  wire                     rst,            // sync reset input
    input  wire                     f,              // field bit
    input  wire                     h,              // horizontal blanking bit
    input  wire                     eav_next,       // asserted when next sample begins EAV symbol
    input  wire                     xyz_word,       // asserted when current word is the XYZ word of a TRS
    input  wire [9:0]               vid_in,         // video data
    input  wire [VCNT_WIDTH-1:0]    vcnt,           // vertical line count
    input  wire [2:0]               std,            // indicates the video standard
    input  wire                     locked,         // asserted when flywheel is locked
    output wire [15:0]              ap_crc,         // calculated active picture CRC
    output wire                     ap_crc_valid,   // asserted when CRC is valid
    output wire [15:0]              ff_crc,         // calculated full-frame CRC
    output wire                     ff_crc_valid    // asserted when CRC is valid
);


//-----------------------------------------------------------------------------
// Parameter definitions
//
localparam VCNT_MSB      = VCNT_WIDTH - 1;       // MS bit # of vcnt

//
// This group of parameters defines the encoding for the video standards output
// code.
//
localparam [2:0]
    NTSC_422        = 3'b000,
    NTSC_INVALID    = 3'b001,
    NTSC_422_WIDE   = 3'b010,
    NTSC_4444       = 3'b011,
    PAL_422         = 3'b100,
    PAL_INVALID     = 3'b101,
    PAL_422_WIDE    = 3'b110,
    PAL_4444        = 3'b111;

//
// This group of parameters defines the line numbers that begin and end the
// two CRC intervals. Values are given for both fields and for both NTSC and
// PAL.
//
localparam NTSC_FLD1_AP_FIRST    =  21;
localparam NTSC_FLD1_AP_LAST     = 262;
localparam NTSC_FLD1_FF_FIRST    =  12;
localparam NTSC_FLD1_FF_LAST     = 271;
    
localparam NTSC_FLD2_AP_FIRST    = 284;
localparam NTSC_FLD2_AP_LAST     = 525;
localparam NTSC_FLD2_FF_FIRST    = 275;
localparam NTSC_FLD2_FF_LAST     =   8;

localparam PAL_FLD1_AP_FIRST     =  24;
localparam PAL_FLD1_AP_LAST      = 310;
localparam PAL_FLD1_FF_FIRST     =   8;
localparam PAL_FLD1_FF_LAST      = 317;

localparam PAL_FLD2_AP_FIRST     = 336;
localparam PAL_FLD2_AP_LAST      = 622;
localparam PAL_FLD2_FF_FIRST     = 321;
localparam PAL_FLD2_FF_LAST      =   4;
    
//-----------------------------------------------------------------------------
// Signal defintions
//
wire                    ntsc;                   // 1 = NTSC, 0 = PAL
reg     [15:0]          ap_crc_reg = 16'b0;     // active picture CRC register
reg     [15:0]          ff_crc_reg = 16'b0;     // full field cRC register
wire    [15:0]          ap_crc16;               // active picture CRC calc output
wire    [15:0]          ff_crc16;               // full field CRC calc output
reg                     ap_region = 1'b0;       // asserted during active picture CRC interval
reg                     ff_region = 1'b0;       // asserted during full field CRC interval
reg     [VCNT_MSB:0]    ap_start_line;          // active picture interval start line
reg     [VCNT_MSB:0]    ap_end_line;            // active picture interval end line
reg     [VCNT_MSB:0]    ff_start_line;          // full field interval start line
reg     [VCNT_MSB:0]    ff_end_line;            // full field interval end line
wire                    ap_start;               // result of comparing ap_start_line with vcnt
wire                    ap_end;                 // result of comparing ap_end_line with vcnt
wire                    ff_start;               // result of comparing ff_start_line with vcnt
wire                    ff_end;                 // result of comparing ff_end_line with vcnt
wire                    sav;                    // asserted during XYZ word of SAV symbol
wire                    eav;                    // asserted during XYZ word of EAV symbol
wire                    ap_crc_clr;             // clears the active picture CRC register
wire                    ff_crc_clr;             // clears the full field CRC register
reg     [9:0]           clipped_vid;            // output of video clipper function
reg                     ap_valid = 1'b0;        // ap_crc_valid internal signal
reg                     ff_valid = 1'b0;        // ff_crc_valid internal signal
reg                     prev_locked = 1'b0;     // locked input signal delayed once clock
wire                    locked_rise;            // asserted on rising edge of locked

//
// video clipper
//
// The SMPTE and ITU specifications require that the video data values used
// by the CRC calculation have the 2 LSBs both be ones if the 8 MSBs are all
// ones.
//
always @ (*)
    begin
        clipped_vid[9:2] = vid_in[9:2];
        if (&vid_in[9:2])
            clipped_vid[1:0] = 2'b11;
        else
            clipped_vid[1:0] = vid_in[1:0];
    end

//
// decoding
//
// These assignments generate the ntsc, eav, and sav signals.
//
assign ntsc = (std == NTSC_422) || (std == NTSC_INVALID) ||
              (std == NTSC_422_WIDE) || (std == NTSC_4444);
assign sav = ~vid_in[6] & xyz_word;
assign eav = vid_in[6] & xyz_word;

//
// ap_region and ff_region generation
// 
// This code determines when the current video signal is within the active
// picture and full field CRC regions. Note that since the F bit changes before
// the end of the EDH full-field time period, the ff_end_line value is set
// to the opposite field value in the assignments below. That is, if F is low,
// normally indicating Field 1, the ff_end_line is assigned to xxx_FLD2_FF_LAST,
// not xxx_FLD1_FF_LAST as might be expected.
//

// This section looks up the starting and ending line numbers of the two CRC
// regions based on the current field and video standard.
always @ (*)
    if (ntsc)
        begin
            if (~f)
                begin
                    ap_start_line = NTSC_FLD1_AP_FIRST;
                    ap_end_line =   NTSC_FLD1_AP_LAST;
                    ff_start_line = NTSC_FLD1_FF_FIRST;
                    ff_end_line =   NTSC_FLD2_FF_LAST;
                end
            else
                begin
                    ap_start_line = NTSC_FLD2_AP_FIRST;
                    ap_end_line =   NTSC_FLD2_AP_LAST;
                    ff_start_line = NTSC_FLD2_FF_FIRST;
                    ff_end_line =   NTSC_FLD1_FF_LAST;
                end
        end
    else
        begin
            if (~f)
                begin
                    ap_start_line = PAL_FLD1_AP_FIRST;
                    ap_end_line =   PAL_FLD1_AP_LAST;
                    ff_start_line = PAL_FLD1_FF_FIRST;
                    ff_end_line =   PAL_FLD2_FF_LAST;
                end
            else
                begin
                    ap_start_line = PAL_FLD2_AP_FIRST;
                    ap_end_line =   PAL_FLD2_AP_LAST;
                    ff_start_line = PAL_FLD2_FF_FIRST;
                    ff_end_line =   PAL_FLD1_FF_LAST;
                end
        end

// These four statements compare the current vcnt value to the starting and
// ending line numbers of the two CRC regions.          
assign ap_start = vcnt == ap_start_line;
assign ap_end =   vcnt == ap_end_line;
assign ff_start = vcnt == ff_start_line;
assign ff_end =   vcnt == ff_end_line;

// This code block generates the ap_region signal indicating when the current
// position is in the active-picture CRC region.
assign ap_crc_clr = ap_start & xyz_word & sav;

always @ (posedge clk)
    if (ce)
        begin
            if (rst)
                ap_region <= 1'b0;
            else if (ap_crc_clr)
                ap_region <= 1'b1;
            else if (ap_end & eav_next)
                ap_region <= 1'b0;
        end


// This code block generates teh ff_region signal indicating when the current
// position is in the full-field CRC region.
assign ff_crc_clr = ff_start & xyz_word & eav;

always @ (posedge clk)
    if (ce)
        begin
            if (rst)
                ff_region <= 1'b0;
            else if (ff_crc_clr)
                ff_region <= 1'b1;
            else if (ff_end & eav_next)
                ff_region <= 1'b0;
        end

//
// Valid bit generation
//
// This code generates the two CRC valid bits.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            prev_locked <= 1'b0;
        else
            prev_locked <= locked;
    end

assign locked_rise = ~prev_locked & locked;

always @ (posedge clk)
    if (ce)
        begin
            if (rst | locked_rise)
                ap_valid <= 1'b0;
            else if (locked & ap_crc_clr)
                ap_valid <= 1'b1;
        end

always @ (posedge clk)
    if (ce)
        begin
            if (rst | locked_rise)
                ff_valid <= 1'b0;
            else if (locked & ff_crc_clr)
                ff_valid <= 1'b1;
        end

//
// CRC calculations and registers
//
// Each CRC is calculated separately by an edh_crc16 module. Associted with
// each is a register. The register acts as an accumulation register and is
// fed back into the edh_crc16 module to be combined with the next video
// word. Enable logic for the registers determines which words are accumulated
// into the CRC value by controlling the load enables to the two registers.
//

// Active-picture CRC calculator
v_smpte_uhdsdi_tx_v1_0_0_edh_crc16 apcrc16 (
    .c      (ap_crc_reg),
    .d      (clipped_vid),
    .crc    (ap_crc16)
);

// Active-picture CRC register
always @ (posedge clk)
    if (ce)
        begin
            if (rst | ap_crc_clr)
                ap_crc_reg <= 0;
            else if (ap_region & ~h)
                ap_crc_reg <= ap_crc16;
        end
        
// Full-field CRC calculator
v_smpte_uhdsdi_tx_v1_0_0_edh_crc16 ffcrc16 (
    .c      (ff_crc_reg),
    .d      (clipped_vid),
    .crc    (ff_crc16)
);

// Full-field CRC register
always @ (posedge clk)
    if (ce)
        begin
            if (rst | ff_crc_clr)
                ff_crc_reg <= 0;
            else if (ff_region)
                ff_crc_reg <= ff_crc16;
        end
        
//
// Output assignments
//
assign ap_crc = ap_crc_reg;
assign ap_crc_valid = ap_valid;
assign ff_crc = ff_crc_reg;
assign ff_crc_valid = ff_valid;
                        
endmodule
