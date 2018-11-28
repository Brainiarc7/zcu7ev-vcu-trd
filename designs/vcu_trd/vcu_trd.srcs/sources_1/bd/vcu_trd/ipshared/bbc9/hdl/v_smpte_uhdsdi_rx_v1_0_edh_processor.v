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
This module instances and interconnects the various modules that make up the
error detection and handling (EDH) packet processor. This processor includes
an ANC packet checksum checker, but does not include any ANC packet mux or
demux functions.

EDH packets for digital component video are defined by the standards 
ITU-R BT.1304 and SMPTE RP 165-1994. The documents define a standard method
of generating and inserting checkwords into the video stream. These checkwords
are not used for error correction. They are used to determine if the video
data is being corrupted somewhere in the chain of video equipment processing
the data. The nature of the EDH packets allows the malfunctioning piece of
equipment to be quickly located.

Two checkwords are defined, one for the field of active picture (AP) video data
words and the other for the full field (FF) of video data. Three sets of flags
are defined to feed forward information regarding detected errors. One of flags
is associated with the AP checkword, one set with the FF checkword. The third
set of flags identify errors detected in the ancillary data checksums within
the field. Implementation of this third set is optional in the standards.

The two checkwords and three sets of flags for each field are combined into an
ancillary data packet, commonly called the EDH packet. The EDH packet occurs
at a fixed location, always immediately before the SAV symbol on the line before
the synchronous switching line. The synchronous switching lines for NTSC are
lines 10 and 273. For 625-line PAL they are lines 6 and 319.

Three sets of error flags outputs are provided. One set consists of the 12
error flags received in the last EDH packet in the input video stream. The
second set consists of the twelve flags sent in the last EDH packet in the
output video stream. A third set contains error flags related to the processing
of the received EDH packet such as packet_missing errors.

*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_rx_v1_0_0_edh_processor #(
    parameter ERROR_COUNT_WIDTH = 24,   // # of bits in errored fields counter
    parameter HCNT_WIDTH        = 12,   // # of bits in horizontal word counter
    parameter VCNT_WIDTH        = 10,   // # of bits in vertical line counter
    parameter FLAGS_WIDTH       = 16)   // # of bits in error flag enable field
(
    input  wire                         clk,                // clock input
    input  wire                         ce,                 // clock enable
    input  wire                         rst,                // sync reset input
    input  wire [9:0]                   vid_in,             // input video
    input  wire                         reacquire,          // forces autodetect to reacquire the video standard
    input  wire                         en_sync_switch,     // enables synchronous switching
    input  wire                         en_trs_blank,       // enables TRS blanking when asserted
    input  wire                         anc_idh_local,      // ANC IDH flag input
    input  wire                         anc_ues_local,      // ANC UES flag input
    input  wire                         ap_idh_local,       // AP IDH flag input
    input  wire                         ff_idh_local,       // FF IDH flag input
    input  wire [FLAGS_WIDTH-1:0]       errcnt_flg_en,      // selects which error flags increment the error counter
    input  wire                         clr_errcnt,         // clears the error counter
    input  wire                         receive_mode,       // 1 enables receiver, 0 for generate only
    output reg [9:0]                    vid_out = 10'b0,    // output video stream with EDH packets inserted
    output reg [2:0]                    std = 3'b0,         // video standard code
    output reg                          std_locked = 1'b0,  // video standard detector is locked
    output reg                          trs = 1'b0,         // asserted during flywheel generated TRS symbol
    output reg                          field = 1'b0,       // field indicator
    output reg                          v_blank = 1'b0,     // vertical blanking indicator
    output reg                          h_blank = 1'b0,     // horizontal blanking indicator
    output reg [HCNT_WIDTH-1:0]         horz_count = 0,     // horizontal position
    output reg [VCNT_WIDTH-1:0]         vert_count = 0,     // vertical position
    output reg                          sync_switch = 1'b0, // asserted on lines where synchronous switching is allowed
    output reg                          locked = 1'b0,      // asserted when flywheel is synchronized to video
    output reg                          eav_next = 1'b0,    // next word is first word of EAV
    output reg                          sav_next = 1'b0,    // next word is first word of SAV
    output reg                          xyz_word = 1'b0,    // current word is the XYZ word of a TRS
    output reg                          anc_next = 1'b0,    // next word is first word of a received ANC packet
    output reg                          edh_next = 1'b0,    // next word is first word of a received EDH packet
    output wire [4:0]                   rx_ap_flags,        // received AP error flags from last EDH packet
    output wire [4:0]                   rx_ff_flags,        // received FF error flags from last EDH packet
    output wire [4:0]                   rx_anc_flags,       // received ANC error flags from last EDH packet
    output wire [4:0]                   ap_flags,           // AP error flags from last field
    output wire [4:0]                   ff_flags,           // FF error flags from last field
    output wire [4:0]                   anc_flags,          // ANC error flags from last field
    output wire [3:0]                   packet_flags,       // error flags related to the received packet processing
    output wire [ERROR_COUNT_WIDTH-1:0] errcnt,             // errored fields counter
    output reg                          edh_packet = 1'b0   // asserted during all words of a generated EDH packet
);

//-----------------------------------------------------------------------------
// Parameter definitions
//

//
// This group of parameters defines the bit widths of various fields in the
// module. 
//
localparam HCNT_MSB      = HCNT_WIDTH - 1;       // MS bit # of hcnt
localparam VCNT_MSB      = VCNT_WIDTH - 1;       // MS bit # of vcnt
localparam ERRFLD_MSB    = ERROR_COUNT_WIDTH - 1;// MS bit of errcnt
localparam FLAGS_MSB     = FLAGS_WIDTH - 1;      // MS bit of flag enable field

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

//-----------------------------------------------------------------------------
// Signal definitions
//
wire    [2:0]           dec_std;            // video_decode std output
wire                    dec_std_locked;     // video_decode std locked output
wire    [9:0]           dec_vid;            // video_decode video output
wire                    dec_trs;            // video_decode trs output
wire                    dec_f;              // video_decode field output
wire                    dec_v;              // video_decode v_blank output
wire                    dec_h;              // video_decode h_blank output
wire    [HCNT_MSB:0]    dec_hcnt;           // video_decode horz_count output
wire    [VCNT_MSB:0]    dec_vcnt;           // video_decode vert_count output
wire                    dec_sync_switch;    // video_decode sync_switch output
wire                    dec_locked;         // video_decode locked output
wire                    dec_eav_next;       // video_decode eav_next output
wire                    dec_sav_next;       // video_decode sav_next output
wire                    dec_xyz_word;       // video_decode xyz_word output
wire                    dec_anc_next;       // video_decode anc_next output
wire                    dec_edh_next;       // video_decode edh_next output
wire    [15:0]          ap_crc;             // calculated active pic CRC
wire                    ap_crc_valid;       // calculated active pic CRC valid signal
wire    [15:0]          ff_crc;             // calculated full field CRC
wire                    ff_crc_valid;       // calculated full field CRC valid signal
wire                    edh_missing;        // EDH packet missing error flag
wire                    edh_parity_err;     // EDH packet parity error flag
wire                    edh_chksum_err;     // EDH packet checksum error flag
wire                    edh_format_err;     // EDH packet format error flag
wire                    tx_edh_next;        // generated EDH packet begins on next word
wire    [4:0]           flag_bus;           // flag bus between EDH_FLAGS and EDH_TX
wire                    ap_flag_word;       // selects AP flags for flag bus
wire                    ff_flag_word;       // selects FF flags for flag bus
wire                    anc_flag_word;      // selects ANC flags for flag bus
wire                    rx_ap_crc_valid;    // received active pic CRC valid signal
wire    [15:0]          rx_ap_crc;          // received active pic CRC
wire                    rx_ff_crc_valid;    // received full field CRC valid signal
wire    [15:0]          rx_ff_crc;          // received full field CRC
wire    [4:0]           in_ap_flags;        // received active pic flags to edh_flags
wire    [4:0]           in_ff_flags;        // received full field flags to edh_flags
wire    [4:0]           in_anc_flags;       // received ANC flags to edh_flags
reg                     errcnt_en = 1'b0;   // enables error counter
wire                    anc_edh_local;      // ANC EDH signal
wire    [9:0]           tx_vid_out;         // video out of edh_tx
wire                    tx_edh_packet;      // asserted when edh packet is to be generated


//
// Video decoder module
//
v_smpte_uhdsdi_rx_v1_0_0_edh_video_decode #(
    .VCNT_WIDTH     (VCNT_WIDTH),
    .HCNT_WIDTH     (HCNT_WIDTH))
DEC (
    .clk            (clk),
    .ce             (ce),
    .rst            (rst),
    .vid_in         (vid_in),
    .reacquire      (reacquire),
    .en_sync_switch (en_sync_switch),
    .en_trs_blank   (en_trs_blank),
    .std            (dec_std),
    .std_locked     (dec_std_locked),
    .trs            (dec_trs),
    .vid_out        (dec_vid),
    .field          (dec_f),
    .v_blank        (dec_v),
    .h_blank        (dec_h),
    .horz_count     (dec_hcnt),
    .vert_count     (dec_vcnt),
    .sync_switch    (dec_sync_switch),
    .locked         (dec_locked),
    .eav_next       (dec_eav_next),
    .sav_next       (dec_sav_next),
    .xyz_word       (dec_xyz_word),
    .anc_next       (dec_anc_next),
    .edh_next       (dec_edh_next)
);

//
// edh_crc module
//
// This module computes the CRC values for the incoming video stream, vid_in.
// Also, the module generates valid signals for both CRC values based on the
// locked signal. If locked rises during a field, the CRC is considered to be
// invalid.
v_smpte_uhdsdi_rx_v1_0_0_edh_crc #(
    .VCNT_WIDTH     (VCNT_WIDTH))
EDH_CRC (
    .clk            (clk),
    .ce             (ce),
    .rst            (rst),
    .f              (dec_f),
    .h              (dec_h),
    .eav_next       (dec_eav_next),
    .xyz_word       (dec_xyz_word),
    .vid_in         (dec_vid),
    .vcnt           (dec_vcnt),
    .std            (dec_std),
    .locked         (dec_locked),
    .ap_crc         (ap_crc),
    .ap_crc_valid   (ap_crc_valid),
    .ff_crc         (ff_crc),
    .ff_crc_valid   (ff_crc_valid)
);

//
// edh_rx module
//
// This module processes EDH packets found in the incoming video stream. The
// CRC words and valid flags are captured from the packet. Various error flags
// related to errors found in the packet are generated.
//
v_smpte_uhdsdi_rx_v1_0_0_edh_rx EDH_RX (
    .clk            (clk),
    .ce             (ce),
    .rst            (rst),
    .rx_edh_next    (dec_edh_next),
    .vid_in         (dec_vid),
    .edh_next       (tx_edh_next),
    .reg_flags      (1'b0),
    .ap_crc_valid   (rx_ap_crc_valid),
    .ap_crc         (rx_ap_crc),
    .ff_crc_valid   (rx_ff_crc_valid),
    .ff_crc         (rx_ff_crc),
    .edh_missing    (edh_missing),
    .edh_parity_err (edh_parity_err),
    .edh_chksum_err (edh_chksum_err),
    .edh_format_err (edh_format_err),
    .in_ap_flags    (in_ap_flags),
    .in_ff_flags    (in_ff_flags),
    .in_anc_flags   (in_anc_flags),
    .rx_ap_flags    (rx_ap_flags),
    .rx_ff_flags    (rx_ff_flags),
    .rx_anc_flags   (rx_anc_flags)
);

//
// edh_loc module
//
// This module locates the beginning of an EDH packet in the incoming video
// stream. It asserts the tx_edh_next siganl the sample before the EDH packet
// begins on vid_in.
//
v_smpte_uhdsdi_rx_v1_0_0_edh_loc #(
    .HCNT_WIDTH     (HCNT_WIDTH),
    .VCNT_WIDTH     (VCNT_WIDTH))
EDH_LOC (
    .clk            (clk),
    .ce             (ce),
    .rst            (rst),
    .f              (dec_f),
    .vcnt           (dec_vcnt),
    .hcnt           (dec_hcnt),
    .std            (dec_std),
    .edh_next       (tx_edh_next)
);

//
// anc_rx module
//
// This module calculates checksums for every ANC packet in the input video
// stream and compares the calculated checksums against the CS word of each
// packet. It also checks the parity bits of all parity protected words in the
// ANC packets. An error in any ANC packet will assert the anc_edh_local signal.
// This output will remain asserted until after the next EDH packet is sent in
// the output video stream.
//
v_smpte_uhdsdi_rx_v1_0_0_edh_anc_rx ANC_RC (
    .clk            (clk),
    .ce             (ce),
    .rst            (rst),
    .locked         (dec_locked),
    .rx_anc_next    (dec_anc_next),
    .rx_edh_next    (dec_edh_next),
    .edh_packet     (tx_edh_packet),
    .vid_in         (dec_vid),
    .anc_edh_local  (anc_edh_local)
);

//
// edh_tx module
//
// This module generates a new EDH packet based on the calculated CRC words
// and the incoming and local flags.
//
v_smpte_uhdsdi_rx_v1_0_0_edh_tx EDH_TX (
    .clk            (clk),
    .ce             (ce),
    .rst            (rst),
    .vid_in         (dec_vid),
    .edh_next       (tx_edh_next),
    .edh_missing    (edh_missing),
    .ap_crc_valid   (ap_crc_valid),
    .ap_crc         (ap_crc),
    .ff_crc_valid   (ff_crc_valid),
    .ff_crc         (ff_crc),
    .flags_in       (flag_bus),
    .ap_flag_word   (ap_flag_word),
    .ff_flag_word   (ff_flag_word),
    .anc_flag_word  (anc_flag_word),
    .edh_packet     (tx_edh_packet),
    .edh_vid        (tx_vid_out)
);

//
// edh_flags module
//
// This module creates the error flags that are included in the new
// EDH packet created by the GEN module. It also captures those flags until the
// next EDH packet and provides them as outputs.
//
v_smpte_uhdsdi_rx_v1_0_0_edh_flags EDH_FLAGS (
    .clk                (clk),
    .ce                 (ce),
    .rst                (rst),
    .receive_mode       (receive_mode),
    .ap_flag_word       (ap_flag_word),
    .ff_flag_word       (ff_flag_word),
    .anc_flag_word      (anc_flag_word),
    .edh_missing        (edh_missing),
    .edh_parity_err     (edh_parity_err),
    .edh_format_err     (edh_format_err),
    .rx_ap_crc_valid    (rx_ap_crc_valid),
    .rx_ap_crc          (rx_ap_crc),
    .rx_ff_crc_valid    (rx_ff_crc_valid),
    .rx_ff_crc          (rx_ff_crc),
    .rx_ap_flags        (in_ap_flags),
    .rx_ff_flags        (in_ff_flags),
    .rx_anc_flags       (in_anc_flags),
    .anc_edh_local      (anc_edh_local),
    .anc_idh_local      (anc_idh_local),
    .anc_ues_local      (anc_ues_local),
    .ap_idh_local       (ap_idh_local),
    .ff_idh_local       (ff_idh_local),
    .calc_ap_crc_valid  (ap_crc_valid),
    .calc_ap_crc        (ap_crc),
    .calc_ff_crc_valid  (ff_crc_valid),
    .calc_ff_crc        (ff_crc),
    .flags              (flag_bus),
    .ap_flags           (ap_flags),
    .ff_flags           (ff_flags),
    .anc_flags          (anc_flags)
);

//
// edh_errcnt module
//
// This counter increments once for every field that contains an enabled error.
// The error counter is disabled until after the video decoder is locked to the
// video stream for the first time and the first EDH packet has been received.
//
v_smpte_uhdsdi_rx_v1_0_0_edh_errcnt # (
    .ERROR_COUNT_WIDTH  (ERROR_COUNT_WIDTH),
    .FLAGS_WIDTH        (FLAGS_WIDTH))
EDH_ERRCNT (
    .clk                (clk),
    .ce                 (ce),
    .rst                (rst),
    .clr_errcnt         (clr_errcnt),
    .count_en           (errcnt_en),
    .flag_enables       (errcnt_flg_en),
    .flags              ({edh_chksum_err, ap_flags, ff_flags, anc_flags}),
    .edh_next           (tx_edh_next),
    .errcnt             (errcnt)
);

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            errcnt_en <= 1'b0;
        else if (locked & dec_edh_next)
            errcnt_en <= 1'b1;
    end

//
// packet_flags
//
// This statement combines the four EDH packet flags into a vector.
//
assign packet_flags = {edh_format_err, edh_chksum_err, edh_parity_err, edh_missing};

//
// output registers
//
// This code implements an output register for the video path and all video
// timing signals.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
        begin
            vid_out <= 0;
            std <= 0;
            std_locked <= 0;
            trs <= 0;
            field <= 0;
            v_blank <= 0;
            h_blank <= 0;
            horz_count <= 0;
            vert_count <= 0;
            sync_switch <= 0;
            locked <= 0;
            eav_next <= 0;
            sav_next <= 0;
            xyz_word <= 0;
            anc_next <= 0;
            edh_next <= 0;
            edh_packet <= 0;
        end
        else
        begin
            vid_out <= tx_vid_out;
            std <= dec_std;
            std_locked <= dec_std_locked;
            trs <= dec_trs;
            field <= dec_f;
            v_blank <= dec_v;
            h_blank <= dec_h;
            horz_count <= dec_hcnt;
            vert_count <= dec_vcnt;
            sync_switch <= dec_sync_switch;
            locked <= dec_locked;
            eav_next <= dec_eav_next;
            sav_next <= dec_sav_next;
            xyz_word <= dec_xyz_word;
            anc_next <= dec_anc_next;
            edh_next <= dec_edh_next;
            edh_packet <= tx_edh_packet;
        end
    end

endmodule
