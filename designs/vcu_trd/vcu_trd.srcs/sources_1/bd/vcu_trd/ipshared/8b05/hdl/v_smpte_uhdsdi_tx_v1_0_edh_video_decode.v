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
This module instances and interconnects the three modules that make up the
digital video decoder: the TRS Detector, the Automatic Video Standard Detector,
and the Video Flywheel.

Together, these three modules will examine a video stream and determine the
format of the video from one of the six supported video standards. The flywheel
then synchronizes to the video stream to provide horizontal and vertical
counts so other modules can determine the location of data that occurs in
regular fixed locations, like the EDH packets. The flywheel will also 
regenerate TRS symbols and insert them into the video stream so that the video
contains valid TRS symbols even if the input video is noisy or stops 
altogether.

This module has the following inputs:

clk: clock input

ce: clock enable

rst: synchronous reset input

vid_in: input video stream

reacquire: forces the autodetect unit to reacquire the video standard

en_sync_switch: enables support for synchronous video switching

en_trs_blank: enable TRS blanking

The module has the following outputs:

std: 3-bit video standard code from the autodetect module

std_locked: asserted when std is valid

trs: asserted during the four words when vid_out contains the TRS symbol words

vid_out: output video stream

field: indicates the current video field

v_blank: vertical blanking interval indicator

h_blank: horizontal blanking interval indicator

horz_count: the horizontal position of the word present on vid_out

vert_count: the vertical position of the word present on vid_out

sync_switch: asserted during the synchronous switching interval

locked: asserted when the flywheel is synchronized with the input video stream

eav_next: asserted the clock cycle before the first word of an EAV appears on
vid_out

sav_next: asserted the clock sycle before the first word of an SAV appears on 
vid_out

xyz_word: asserted when vid_out contains the XYZ word of a TRS symbol

anc_next: asserted the clock cycle before the first word of the ADF of an ANC
packet appears on vid_out

edh_next: asserted the clock cycle before the first word of the ADF of an EDH
packet appears on vid_out
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_tx_v1_0_0_edh_video_decode #(
    parameter HCNT_WIDTH = 12,                      // number of bits in horizontal sample counter
    parameter VCNT_WIDTH = 10)                      // number of bits in vertical line counter
(
    input  wire                     clk,            // clock input
    input  wire                     ce,             // clock enable
    input  wire                     rst,            // sync reset input
    input  wire [9:0]               vid_in,         // input video
    input  wire                     reacquire,      // forces autodetect to reacquire the video standard
    input  wire                     en_sync_switch, // enables synchronous switching
    input  wire                     en_trs_blank,   // enables TRS blanking when asserted
    output wire [2:0]               std,            // video standard code
    output wire                     std_locked,     // autodetect ciruit is locked when this output is asserted
    output wire                     trs,            // asserted during flywheel generated TRS symbol
    output wire [9:0]               vid_out,        // TRS symbol data
    output wire                     field,          // field indicator
    output wire                     v_blank,        // vertical blanking bit
    output wire                     h_blank,        // horizontal blanking bit
    output wire [HCNT_WIDTH-1:0]    horz_count,     // current horizontal count
    output wire [VCNT_WIDTH-1:0]    vert_count,     // current vertical count
    output wire                     sync_switch,    // asserted on lines where synchronous switching is allowed
    output wire                     locked,         // asserted when flywheel is synchronized to video
    output wire                     eav_next,       // next word is first word of EAV
    output wire                     sav_next,       // next word is first word of SAV
    output wire                     xyz_word,       // current word is the XYZ word of a TRS
    output wire                     anc_next,       // next word is first word of a received ANC
    output wire                     edh_next        // next word is first word of a received EDH
);

localparam HCNT_MSB      = HCNT_WIDTH - 1;       // MS bit # of hcnt
localparam VCNT_MSB      = VCNT_WIDTH - 1;       // MS bit # of vcnt

//-----------------------------------------------------------------------------
// Signal definitions
//
wire                    td_xyz_err;         // trs_detect rx_xyz_err output
wire                    td_xyz_err_4444;    // trs_detect rx_xyz_err_4444 output
wire    [9:0]           td_vid;             // video stream from trs_detect
wire                    td_trs;             // trs_detect rx_trs output
wire                    td_xyz;             // trs_detect rx_xyz output
wire                    td_f;               // trs_detect rx_f output
wire                    td_v;               // trs_detect rx_v output
wire                    td_h;               // trs_detect rx_h output
wire                    td_anc;             // trs_detect rx_anc output
wire                    td_edh;             // trs_detect rx_edh output
wire                    td_eav;             // trs_detect rx_eav output
wire                    ad_s4444;           // autodetect s4444 output
wire                    ad_xyz_err;         // autodetect xyz_err output

//
// Instantiate the TRS detector module
//
v_smpte_uhdsdi_tx_v1_0_0_edh_trs_detect TD (
    .clk                (clk),
    .ce                 (ce),
    .rst                (rst),
    .vid_in             (vid_in),
    .vid_out            (td_vid),
    .rx_trs             (td_trs),
    .rx_eav             (td_eav),
    .rx_sav             (),
    .rx_f               (td_f),
    .rx_v               (td_v),
    .rx_h               (td_h),
    .rx_xyz             (td_xyz),
    .rx_xyz_err         (td_xyz_err),
    .rx_xyz_err_4444    (td_xyz_err_4444),
    .rx_anc             (td_anc),
    .rx_edh             (td_edh)
);

//
// Instantiate the video standard autodetect module
//
v_smpte_uhdsdi_tx_v1_0_0_edh_autodetect #(
    .HCNT_WIDTH      (HCNT_WIDTH))
AD (
    .clk                (clk),
    .ce                 (ce),
    .rst                (rst),
    .reacquire          (reacquire),
    .vid_in             (td_vid),
    .rx_trs             (td_trs),
    .rx_xyz             (td_xyz),
    .rx_xyz_err         (td_xyz_err),
    .rx_xyz_err_4444    (td_xyz_err_4444),
    .vid_std            (std),
    .locked             (std_locked),
    .xyz_err            (ad_xyz_err),
    .s4444              (ad_s4444)
);


//
// Instantiate the flywheel module
//
v_smpte_uhdsdi_tx_v1_0_0_edh_flywheel #(
    .VCNT_WIDTH     (VCNT_WIDTH),
    .HCNT_WIDTH     (HCNT_WIDTH))
FLY (
    .clk            (clk),
    .ce             (ce),
    .rst            (rst),
    .rx_xyz_in      (td_xyz),
    .rx_trs_in      (td_trs),
    .rx_eav_first_in(td_eav),
    .rx_f_in        (td_f),
    .rx_v_in        (td_v),
    .rx_h_in        (td_h),
    .std_locked     (std_locked),
    .std_in         (std),
    .rx_xyz_err_in  (ad_xyz_err),
    .rx_vid_in      (td_vid),
    .rx_s4444_in    (ad_s4444),
    .rx_anc_in      (td_anc),
    .rx_edh_in      (td_edh),
    .en_sync_switch (en_sync_switch),
    .en_trs_blank   (en_trs_blank),
    .trs            (trs),
    .vid_out        (vid_out),
    .field          (field),
    .v_blank        (v_blank),
    .h_blank        (h_blank),
    .horz_count     (horz_count),
    .vert_count     (vert_count),
    .sync_switch    (sync_switch),
    .locked         (locked),
    .eav_next       (eav_next),
    .sav_next       (sav_next),
    .xyz_word       (xyz_word),
    .anc_next       (anc_next),
    .edh_next       (edh_next)
);

endmodule
