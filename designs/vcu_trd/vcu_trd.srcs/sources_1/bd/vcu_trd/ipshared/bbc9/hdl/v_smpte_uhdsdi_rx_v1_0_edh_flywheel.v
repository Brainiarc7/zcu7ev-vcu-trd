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
This module implements a video flywheel. Video flywheels are used to add
immunity to noise introduced into a video stream.

The flywheel synchronizes to the incoming video by examining the TRS symbols. It
then maintains internal horizontal and vertical counters to keep track of the
current position. The flywheel generates its own TRS symbols and compares them
to the incoming video. If the position or contents of the TRS symbols in the
incoming video doesn't match the flywheel's generated TRS symbols for a certain
period of time, the flywheel will resynchronize to the incoming video.

This module has the following inputs:

clk: clock input

ce: clock enable input

rst: synchronous reset input

rx_xyz_in: Asserted when rx_vid_in contains the XYZ word of a TRS symbol.

rx_trs_in: Asserted when rx_vid_in contains the first word of a TRS symbol.

rx_eav_first_in: Asserted when rx_vid_in contains the first word of an EAV.

rx_f_in: This is the latched F bit from the trs_detect module

rx_h_in: This is the latched H bit from the trs_detect module.

std_locked: When this signal is asserted the std_in code is assumed to be valid.

std_in: A three bit code indicating the video standard of the input video 
stream.

rx_xyz_err_in: This input indicates an error in the XYZ word. It is only
considered to be valid when rx_xyz_in is asserted.

rx_vid_in: This is the input port for the input video stream.

rx_s4444_in: This input is the S bit from the XYZ word of a 4:4:4:4 video 
stream.

rx_anc_in:  Asserted when rx_vid_in contains the first word of an ANC packet.

rx_edh_in: Asserted when rx_vid_in contains the first word of an EDH packet.

en_sync_switch: When this input is asserted, the flywheel will allow
synchronous switching.

en_trs_blank: When this input is asserted, the TRS blanking feature is enabled.
When this is enabled, TRS symbols from the input video stream are replaced with
black level video values if that TRS symbol does not occur when the flywheel
expects a TRS to occur.

This module has the following outputs:

trs: Asserted during all four words of a TRS symbol.

vid_out: This is the output video port.

field: This is the field indicator bit.

v_blank: Vertical blanking interval indicator.

h_blank: Horizontal blanking interval indicator.

horz_count: Current horizontal position of the video stream.

vert_count: Current vertical position of the video stream.

sync_switch: Asserted on lines when synchronous switching is allowed. This 
output should be used to disable TRS filtering in the framer of an SDI receiver
during the synchronous switching lines.

locked: This output is asserted when the flywheel is locked to the incoming
video stream.

eav_next: This output is asserted the clock cycle before the first word of an
EAV appears on vid_out.

sav_next: This output is asserted the clock cycle before the first word of an
SAV appears on vid_out.

xyz_word: This output is asserted clock cycle when vid_out contains the XYZ
word of a TRS symbol.

anc_next: This output is asserted the clock cycle before the first word of an
ancillary data packet appears on vid_out.

edh_next: This output is asserted the clock cycle before the first word of an
EDH packet appears on vid_out.

*/

`timescale 1ns / 1ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_rx_v1_0_0_edh_flywheel #(
    parameter HCNT_WIDTH = 12,
    parameter VCNT_WIDTH = 10)
(
    input  wire                 clk,                // clock input
    input  wire                 ce,                 // clock enable
    input  wire                 rst,                // sync reset input
    input  wire                 rx_xyz_in,          // input asserted during the XYZ word of a TRS symbol
    input  wire                 rx_trs_in,          // input asserted during first word of received TRS symbol
    input  wire                 rx_eav_first_in,    // input asserted during first word of received EAV symbol
    input  wire                 rx_f_in,            // decoded F bit from received video
    input  wire                 rx_v_in,            // decoded V bit from received video
    input  wire                 rx_h_in,            // decoded H bit from received video
    input  wire                 std_locked,         // asserted by the autodetect unit when locked to video std
    input  wire [2:0]           std_in,             // input code for the current video standard
    input  wire                 rx_xyz_err_in,      // input asserted on parity error in XYZ word
    input  wire [9:0]           rx_vid_in,          // input video word
    input  wire                 rx_s4444_in,        // S bit for 4444 video
    input  wire                 rx_anc_in,          // asserted on first word of received ANC
    input  wire                 rx_edh_in,          // asserted on first word of received EDH
    input  wire                 en_sync_switch,     // enables synchronous switching when asserted
    input  wire                 en_trs_blank,       // enables TRS blanking when asserted
    output reg                  trs = 1'b0,         // asserted during TRS symbol
    output reg [9:0]            vid_out = 0,        // video stream out
    output reg                  field = 1'b0,       // field indicator
    output reg                  v_blank = 1'b0,     // vertical blanking bit
    output reg                  h_blank = 1'b0,     // horizontal blanking bit
    output reg [HCNT_WIDTH-1:0] horz_count = 0,     // current horizontal count
    output reg [VCNT_WIDTH-1:0] vert_count = 0,     // current vertical count
    output reg                  sync_switch = 1'b0, // asserted on lines where synchronous switching is allowed
    output reg                  locked = 1'b0,      // asserted when flywheel is synchronized to video
    output reg                  eav_next = 1'b0,    // next word is first word of EAV
    output reg                  sav_next = 1'b0,    // next word is first word of SAV
    output reg                  xyz_word = 1'b0,    // current word is the XYZ word of a TRS
    output wire                 anc_next,           // next word is first word of a received ANC
    output wire                 edh_next            // next word is first word of a received EDH
);


//-----------------------------------------------------------------------------
// Parameter definitions
//
parameter HCNT_MSB      = HCNT_WIDTH - 1;       // MS bit # of hcnt
parameter VCNT_MSB      = VCNT_WIDTH - 1;       // MS bit # of vcnt


//
// This group of parameters defines the encoding for the video standards output
// code.
//
parameter [2:0]
    NTSC_422        = 3'b000,
    NTSC_INVALID    = 3'b001,
    NTSC_422_WIDE   = 3'b010,
    NTSC_4444       = 3'b011,
    PAL_422         = 3'b100,
    PAL_INVALID     = 3'b101,
    PAL_422_WIDE    = 3'b110,
    PAL_4444        = 3'b111;


//
// This group of parameters defines the component video values that will be
// used to blank TRS symbols when TRS blanking.
//
parameter YCBCR_4444_BLANK_Y    = 10'h040;
parameter YCBCR_4444_BLANK_CB   = 10'h200;
parameter YCBCR_4444_BLANK_CR   = 10'h200;
parameter YCBCR_4444_BLANK_A    = 10'h040;

parameter RGB_4444_BLANK_R      = 10'h040;
parameter RGB_4444_BLANK_G      = 10'h040;
parameter RGB_4444_BLANK_B      = 10'h040;
parameter RGB_4444_BLANK_A      = 10'h040;

parameter YCBCR_422_BLANK_Y     = 10'h040;
parameter YCBCR_422_BLANK_C     = 10'h200;
         
//-----------------------------------------------------------------------------
// Signal definitions
//
reg                     rx_xyz = 1'b0;          // input register for rx_xyz_in
reg                     rx_trs = 1'b0;          // input register for rx_trs_in
reg                     rx_eav_first = 1'b0;    // input register for rx_eav_first_in
reg                     rx_xyz_err = 1'b0;      // input register for rx_xyz_err_in
reg                     rx_s4444 = 1'b0;        // input register for rx_s4444_in
reg     [9:0]           rx_vid = 1'b0;          // input register for rx_vid_in
reg                     rx_f = 1'b0;            // input register for rx_f_in
reg                     rx_v = 1'b0;            // input register for rx_v
reg                     rx_h = 1'b0;            // input register for rx_h_in
reg                     rx_anc = 1'b0;          // input register for rx_anc_in
reg                     rx_edh = 1'b0;          // input register for rx_edh_in
wire    [HCNT_MSB:0]    hcnt;                   // horizontal counter
wire    [VCNT_MSB:0]    vcnt;                   // vertical counter
wire                    fly_eav_next;           // EAV symbol starts on next count
wire                    fly_sav_next;           // SAV symbol starts on next count
wire    [1:0]           trs_word;               // counts length of TRS symbol
wire                    fly_trs;                // asserted during all words of flywheel TRS
wire                    trs_d;                  // input to trs output flip-flop
wire                    v_blank_d;              // input to v_blank output flip-flop
wire                    h_blank_d;              // input to h_blank output flip-flop
wire                    fly_eav;                // asserted on XYZ word of flywheel generated EAV
wire                    fly_sav;                // asserted on XYZ word of flywheel generated SAV
wire                    rx_eav;                 // asserted on XYZ word of received EAV
wire                    rx_sav;                 // asserted on XYZ word of received SAV
wire                    f;                      // field bit
wire                    v;                      // vertical blanking bit
wire                    h;                      // horizontal blanking bit
reg     [9:0]           xyz;                    // flywheel generated TRS XYZ word
wire                    new_rx_field;           // asserted when received field changes
wire                    ld_vcnt;                // loads vcnt
wire                    inc_vcnt;               // forces vertical counter to increment
wire                    clr_hcnt;               // reloads hcnt 
wire                    resync_hcnt;            // resynchronized hcnt during sync switch
wire                    ld_f;                   // loads field bit
wire                    inc_f;                  // toggles field bit
reg                     ntsc;                   // 1 = NTSC, 0 = PAL
wire                    lock;                   // internal version of locked output
reg     [2:0]           std = NTSC_422;         // register for the std_in inputs
wire                    ld_std;                 // loads the std register
wire                    switch_interval;        // asserted from SAV to EAV of switch line
wire                    sw_int;                 // qualified version of switch_interval
reg     [9:0]           fly_vid;                // flywheel video
wire                    clr_switch;             // clears the switch_interval signal
reg     [2:0]           rx_trs_delay = 3'b0;    // used to generate rx_trs_all4
wire                    rx_trs_all4;            // extended rx_trs, asserted for all 4 words
wire                    rx_field;               // the F bit from the received XYZ word
wire                    use_rx;                 // use decoded RX video info when asserted
wire                    use_fly;                // use flywheel generated video when asserted
wire                    sloppy_v;               // when asserted, V bit is ignored in XYZ comparisons
wire                    xyz_word_d;             // used to create the xyz output
wire                    is_ntsc;
wire                    is_422;

//
// input register for signals from trs_detect
//
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
        begin
            rx_xyz <= 0;
            rx_trs <= 0;
            rx_eav_first <= 0;
            rx_xyz_err <= 0;
            rx_s4444 <= 0;
            rx_vid <= 0;
            rx_f <= 0;
            rx_v <= 0;
            rx_h <= 0;
            rx_anc <= 0;
            rx_edh <= 0;
        end
        else
        begin
            rx_xyz <= rx_xyz_in;
            rx_trs <= rx_trs_in;
            rx_eav_first <= rx_eav_first_in;
            rx_xyz_err <= rx_xyz_err_in;
            rx_s4444 <= rx_s4444_in;
            rx_vid <= rx_vid_in;
            rx_f <= rx_f_in;
            rx_v <= rx_v_in;
            rx_h <= rx_h_in;
            rx_anc <= rx_anc_in;
            rx_edh <= rx_edh_in;
        end
    end


// 
// fly_horz instantiation
//
// The fly_horz module contains the horizontal functions of the flywheel. It
// generates the horizontal count and the H bit.It also generates several
// TRS related signals indicating when a TRS is to be generated by the flywheel
// and what type of TRS is to be generated.
//
v_smpte_uhdsdi_rx_v1_0_0_edh_fly_horz #(
    .HCNT_WIDTH         (HCNT_WIDTH))
horz (
    .clk                (clk),
    .rst                (rst),
    .ce                 (ce),
    .clr_hcnt           (clr_hcnt),
    .resync_hcnt        (resync_hcnt),
    .std                (std),
    .hcnt               (hcnt),
    .eav_next           (fly_eav_next),
    .sav_next           (fly_sav_next),
    .h                  (h),
    .trs_word           (trs_word),
    .fly_trs            (fly_trs),
    .fly_eav            (fly_eav),
    .fly_sav            (fly_sav)
);

//
// fly_vert instantiation
//
// The fly_vert module contains the vertical functions of the flywheel. It
// generates the vertical line count and the V bit. It generates the inc_f
// signal indicating when it is time to advance to the next field. It also
// generates the switch_interval signal indicating when the current line is
// a line when switching between two synchronous video sources is permitted.
//
v_smpte_uhdsdi_rx_v1_0_0_edh_fly_vert #(
    .VCNT_WIDTH         (VCNT_WIDTH))
vert (
    .clk                (clk),
    .rst                (rst),
    .ce                 (ce),
    .ntsc               (ntsc),
    .ld_vcnt            (ld_vcnt),
    .fsm_inc_vcnt       (inc_vcnt),
    .eav_next           (fly_eav_next),
    .clr_switch         (clr_switch),
    .rx_f               (rx_f),
    .f                  (f),
    .fly_sav            (fly_sav),
    .fly_eav            (fly_eav),
    .rx_eav_first       (rx_eav_first),
    .lock               (lock),
    .vcnt               (vcnt),
    .v                  (v),
    .sloppy_v           (sloppy_v),
    .inc_f              (inc_f),
    .switch_interval    (switch_interval)
);

assign sw_int = switch_interval & en_sync_switch;

//
// fly_fsm instantiation
//
// The fly_fsm module contains the finite state machine that controls the
// operation of the flywheel.
//
v_smpte_uhdsdi_rx_v1_0_0_edh_fly_fsm fsm (
    .clk                (clk),
    .ce                 (ce),
    .rst                (rst),
    .vid_f              (rx_vid[8]),
    .vid_v              (rx_vid[7]),
    .vid_h              (rx_vid[6]),
    .rx_xyz             (rx_xyz),
    .fly_eav            (fly_eav),
    .fly_sav            (fly_sav),
    .fly_eav_next       (fly_eav_next),
    .fly_sav_next       (fly_sav_next),
    .rx_eav             (rx_eav),
    .rx_sav             (rx_sav),
    .rx_eav_first       (rx_eav_first),
    .new_rx_field       (new_rx_field),
    .xyz_err            (rx_xyz_err),
    .std_locked         (std_locked),
    .switch_interval    (sw_int),
    .xyz_f              (xyz[8]),
    .xyz_v              (xyz[7]),
    .xyz_h              (xyz[6]),
    .sloppy_v           (sloppy_v),
    .lock               (lock),
    .ld_vcnt            (ld_vcnt),
    .inc_vcnt           (inc_vcnt),
    .clr_hcnt           (clr_hcnt),
    .resync_hcnt        (resync_hcnt),
    .ld_std             (ld_std),
    .ld_f               (ld_f),
    .clr_switch         (clr_switch)
);

//
// fly_field instantiation
//
// The fly_field module contains the field related functions of the flywheel.
// It generates the F bit and also contains a logic to determine when the
// received field changes.
//
v_smpte_uhdsdi_rx_v1_0_0_edh_fly_field fld (
    .clk                (clk),
    .rst                (rst),
    .ce                 (ce),
    .ld_f               (ld_f),
    .inc_f              (inc_f),
    .eav_next           (fly_eav_next),
    .rx_field           (rx_field),
    .rx_xyz             (rx_xyz),
    .f                  (f),
    .new_rx_field       (new_rx_field)
);

assign rx_field = rx_vid[8];

//
// rx_eav and rx_sav
//
// This code decodes the H bit from the received video to generate the rx_eav
// and rx_sav signals. These two signals are asserted during the XYZ word only
// of a received TRS symbol to indicate whether a SAV or an EAV symbol has
// been received.
//
assign rx_eav = rx_xyz & rx_vid[6];
assign rx_sav = rx_xyz & ~rx_vid[6];

//
// rx_trs_delay and rx_trs_all4 generation
//
// The trs_detect module only asserts the rx_trs signal during the first
// word of a received TRS symbol. This code stretches that signal so that
// it is asserted for all four words of the TRS symbol. The extended signal
// is called rx_trs_all4.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            rx_trs_delay <= 0;
        else
            rx_trs_delay <= {rx_trs_delay[1:0], rx_trs};
    end

assign rx_trs_all4 = |{rx_trs_delay,rx_trs};
        

//
// std register
//
// This register holds the current video standard code being used by the
// flywheel. It loads from the std inputs whenever the state machine begins
// the synchronization process.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            std <= NTSC_422;
        else if (ld_std)
            std <= std_in;
    end

//
// ntsc
//
// This signal is asserted when the code in the std register indicates a
// NTSC standard and is negated for PAL standards.
//
assign is_ntsc = std == NTSC_422 || std == NTSC_INVALID || std == NTSC_422_WIDE || std == NTSC_4444;

always @ (*)
    if (is_ntsc)
        ntsc = 1'b1;
    else
        ntsc = 1'b0;

//
// xyz generator
//
// This logic generates the TRS XYZ word. The XYZ word is constructed
// differently for the 4:4:4:4 standards than for the 4:2:2 standards.
//
assign is_422 = std == NTSC_422 || std == NTSC_422_WIDE || std == PAL_422  || std == PAL_422_WIDE;

always @ (*)
begin
    xyz[9] <= 1'b1;
    xyz[8] <= f;
    xyz[7] <= v;
    xyz[6] <= h;
    xyz[0] <= 1'b0;

    if (std == NTSC_4444 || std == PAL_4444)
        begin
            xyz[5] <= rx_s4444;
            xyz[4] <= f ^ v ^ h;
            xyz[3] <= f ^ v ^ rx_s4444;
            xyz[2] <= v ^ h ^ rx_s4444;
            xyz[1] <= f ^ h ^ rx_s4444;
        end
    else if (is_422)
        begin
            xyz[5] <= v ^ h;
            xyz[4] <= f ^ h;
            xyz[3] <= f ^ v;
            xyz[2] <= f ^ v ^ h;
            xyz[1] <= 1'b0;
        end
    else
        xyz <= 0;
end

//
// fly_vid generator
//
// This code generates the flywheel TRS symbol. The first three words of the
// TRS symbol are 0x3ff, 0x000, 0x000. The fourth word is the XYZ word. If
// a TRS symbol is not begin generated, the fly_vid value is assigned to
// the blank level value appropriate to the component being generated.
//
always @ (*)
    if (trs_d)
        case(trs_word)
            2'b00: fly_vid <= 10'h3ff;
            2'b01: fly_vid <= 10'h000;
            2'b10: fly_vid <= 10'h000;
            2'b11: fly_vid <= xyz;
        endcase
    else if (std == NTSC_4444 || std == PAL_4444)
        begin
            if (rx_s4444)
                case (hcnt[1:0])
                    2'b00: fly_vid <= YCBCR_4444_BLANK_CB;
                    2'b01: fly_vid <= YCBCR_4444_BLANK_Y;
                    2'b10: fly_vid <= YCBCR_4444_BLANK_CR;
                    2'b11: fly_vid <= YCBCR_4444_BLANK_A;
                endcase
            else
                case (hcnt[1:0])
                    2'b00: fly_vid <= RGB_4444_BLANK_B;
                    2'b01: fly_vid <= RGB_4444_BLANK_G;
                    2'b10: fly_vid <= RGB_4444_BLANK_R;
                    2'b11: fly_vid <= RGB_4444_BLANK_A;
                endcase
        end
    else
        begin
            if (hcnt[0])
                fly_vid <= YCBCR_422_BLANK_Y;
            else
                fly_vid <= YCBCR_422_BLANK_C;
        end 

//
// output register
//
// This is the output register for all the flywheel's output signals. The
// signals that can be derived internally or from the received video (trs,
// vid_out, and h_blank) use the use_rx signal to determine whether the flywheel
// generated signals or the signals decoded from the received video should be 
// used. The v_blank and field outputs are not affected by use_rx.
//
// Normally the output video stream (vid_out) is equal to the input video
// stream (vid_in). However, when the flywheel generates a TRS symbol, this
// internally generated TRS symbol is output instead of the input video
// stream. If the input video stream contains a TRS that does not line up
// with the flywheel's TRS symbol, then the TRS symbol in the input video
// stream is blanked by the flywheel. However, on the synchronous switching
// lines, the SAV symbol in the input video stream is always output and the 
// flywheel's SAV symbol is suppressed.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
        begin
            trs <= 1'b0;
            field <= 1'b0;
            v_blank <= 1'b0;
            h_blank <= 1'b0;
            horz_count <= 0;
            vert_count <= 1;
            locked <= 0;
            sync_switch <= 0;
            vid_out <= 0;
            eav_next <= 0;
            sav_next <= 0;
            xyz_word <= 0;
        end
        else
        begin
            trs <= trs_d;
            field <= f;
            v_blank <= v_blank_d;
            h_blank <= h_blank_d;
            horz_count <= hcnt;
            vert_count <= vcnt;
            locked <= lock;
            sync_switch <= sw_int;
            vid_out <= use_fly ? fly_vid : rx_vid;
            eav_next <= fly_eav_next;
            sav_next <= fly_sav_next;
            xyz_word <= xyz_word_d;
        end
    end

assign use_rx = lock & (sw_int | sloppy_v);
assign use_fly = (trs_d & ~use_rx) | ((~trs_d & rx_trs_all4) & en_trs_blank);
assign trs_d = use_rx ? rx_trs_all4 : fly_trs;
assign h_blank_d = use_rx ? (rx_h | rx_trs_all4) : (h | trs_d);
assign v_blank_d = use_rx ? rx_v : v;
assign xyz_word_d = trs_d & trs_word[1] & trs_word[0];
assign anc_next = rx_anc;
assign edh_next = rx_edh;
     
endmodule
