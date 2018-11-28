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
This module examines the input video stream for TRS symbols and ancillary data
packets. It does some decoding of the TRS symbols and ANC packets to generate
a variety of outputs.

This input video stream is passed through a four register pipeline, delaying the
video by four clock cycles. This allows the pipeline to contain the entire TRS
symbol or the ancillary data flag plus DID word to allow them to be decoded
before the video emerges from the module.

This module has the following inputs:

clk: clock input

ce: clock enable

rst: synchronous reset input

vid_in: input video stream port

This module generates the following outputs:

vid_out: This is the output video stream. It is identical to the input video
stream, but delayed by four clock cycles.

rx_trs: This output is asserted only when the first word of a TRS symbol is
present on vid_out.

rx_eav: This output is asserted only when the first word of an EAV symbol is
present on vid_out.

rx_sav: This output is asserted only when the first word of an SAV symbol is
present on vid_out.

rx_f: This is the field indicator bit F latched from the XYZ word of the last
received TRS symbol.

rx_v: This is the vertical blanking interval bit V latched from the XYZ word of
the last received TRS symbol.

rx_h: This is the horizontal blanking interval bit H latched from the XYZ word
of the last received TRS symbol.

rx_xyz: This outpuot is asserted when the XYZ word of a TRS symbol is present on
vid_out.

rx_xyz_err: This output is asserted when the received XYZ word contains an
error. It is only asserted when the XYZ word appears on vid_out. This signal is
only valid for the 4:2:2 video standards.

rx_xyz_err_4444: This output is asserted when the received XYZ word contains an
error. It is only asserted when the XYZ word appears on vid_out. This signals is
only valid for the 4:4:4:4 video standards.

rx_anc: This output is asserted when the first word of an ANC packet (the first
word of the ancillary data flag) is present on vid_out.

rx_edh: This output is asserted when the first word of an EDH packet (the first
word of the ancillary data flag) is present on vid_out.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_rx_v1_0_0_edh_trs_detect (
    input  wire             clk,            // clock input
    input  wire             ce,             // clock enable
    input  wire             rst,            // sync reset input
    input  wire [9:0]       vid_in,         // video input

    // outputs
    output wire [9:0]       vid_out,        // delayed and clipped video output
    output wire             rx_trs,         // asserted during first word of TRS symbol
    output wire             rx_eav,         // asserted during first word of an EAV symbol
    output wire             rx_sav,         // asserted during first word of an SAV symbol
    output wire             rx_f,           // field bit from last received TRS symbol
    output wire             rx_v,           // vertical blanking interval bit from last TRS symbol
    output wire             rx_h,           // horizontal blanking interval bit from last TRS symbol
    output wire             rx_xyz,         // asserted during TRS XYZ word
    output wire             rx_xyz_err,     // XYZ error flag for non-4444 standards
    output wire             rx_xyz_err_4444,// XYZ error flag for 4444 standards
    output wire             rx_anc,         // asserted during first word of ADF
    output wire             rx_edh          // asserted during first word of ADF if it is an EDH packet
);

         
//-----------------------------------------------------------------------------
// Signal definitions
//

reg     [9:0]   in_reg = 0;                     // input register
reg     [9:0]   pipe1_vid = 0;                  // first pipeline register
reg             pipe1_ones = 1'b0;              // asserted if pipe1_vid[9:2] is all 1s
reg             pipe1_zeros = 1'b0;             // asserted if pipe1_vid[9:2] is all 0s
reg     [9:0]   pipe2_vid = 0;                  // second pipeline register
reg             pipe2_ones = 1'b0;              // asserted if pipe2_vid[9:2] is all 1s 
reg             pipe2_zeros = 1'b0;             // asserted if pipe2_vid[9:2] is all 0s
reg     [9:0]   out_reg_vid = 0;                // output register - video stream
reg             out_reg_anc = 1'b0;             // output register - rx_anc signal
reg             out_reg_edh = 1'b0;             // output register - rx_edh signal
reg             out_reg_trs = 1'b0;             // output register - rx_trs signal
reg             out_reg_eav = 1'b0;             // output register - rx_eav signal
reg             out_reg_sav = 1'b0;             // output register - rx_sav signal
reg             out_reg_xyz = 1'b0;             // output register - rx_xyz signal
reg             out_reg_xyz_err = 1'b0;         // output register - rx_xyz_err signal
reg             out_reg_xyz_err_4444 = 1'b0;    // output register - rx_xyz_err_4444 signal
reg             out_reg_f = 1'b0;               // output register - rx_f signal
reg             out_reg_v = 1'b0;               // output register - rx_v signal
reg             out_reg_h = 1'b0;               // output register - rx_h signal
wire            xyz;                            // XYZ detect input to out_reg
wire            xyz_err;                        // XYZ error detect input to out_reg
wire            xyz_err_4444;                   // XYZ 4444 error detect input to out_reg
wire            anc;                            // anc input to out_reg
wire            trs;                            // trs input to out_reg
wire            eav;                            // eav input to out_reg
wire            sav;                            // sav input to out_reg
wire            edh_in;                         // asserted when in_reg = 0x1f4 (EDH DID)
wire            all_ones_in;                    // asserted when in_reg is all ones
wire            all_zeros_in;                   // asserted when in_reg is all zeros
reg     [1:0]   trs_delay = 2'b00;              // delay register used to assert xyz signal
wire            f;                              // internal version of rx_f
wire            v;                              // internal version of rx_v
wire            h;                              // internal version of rx_h

//
// in_reg
//
// The input register loads the value on the vid_in port.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            in_reg <= 0;
        else
            in_reg <= vid_in;
    end


//
// all ones and all zeros detectors
//
// This logic determines if the input video word is all ones or all zeros. To
// provide compatibility with 8-bit video equipment, the LS two bits are
// ignored.  
// 
assign all_ones_in = &in_reg[9:2];
assign all_zeros_in = ~|in_reg[9:2];


//
// DID detector decoder
//
// The edh_in signal is asserted if the in_reg contains a value of 0x1f4.
// This is the value of the DID word for an EDH packet. 
//
assign edh_in    = (vid_in == 10'h1f4);

//
// pipe1
//
// The pipe1 register holds the inut video and the outputs of the all zeros
// and all ones detectors.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
        begin
            pipe1_vid   <= 0;
            pipe1_ones  <= 1'b0;
            pipe1_zeros <= 1'b0;
        end
        else
        begin
            pipe1_vid   <= in_reg;
            pipe1_ones  <= all_ones_in;
            pipe1_zeros <= all_zeros_in;
        end
    end


//
// pipe2_reg
//
// The pipe2 register delays the contents of the pipe1 register for one more
// clock cycle.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
        begin
            pipe2_vid   <= 0;
            pipe2_ones  <= 1'b0;
            pipe2_zeros <= 1'b0;
        end
        else
        begin
            pipe2_vid   <= pipe1_vid;
            pipe2_ones  <= pipe1_ones;
            pipe2_zeros <= pipe1_zeros;
        end
    end


//
// TRS & ANC detector
//
// The trs signal when the sequence 3ff, 000, 000 is stored in the pipe2, pipe1,
// and in_reg registers, respectively. The anc signal is asserted when these
// same registers hold the sequence 000, 3ff, 3ff.
//
assign trs = all_zeros_in & pipe1_zeros & pipe2_ones;
assign anc = all_ones_in & pipe1_ones & pipe2_zeros;
assign eav = trs & vid_in[6];
assign sav = trs & ~vid_in[6];

//
// f, v, and h flag generation
//
assign f = trs ? vid_in[8] : out_reg_f;
assign v = trs ? vid_in[7] : out_reg_v;
assign h = trs ? vid_in[6] : out_reg_h;

//
// XYZ and XYZ error logic
//
// The xyz signal is asserted when the pipe2 register holds the XYZ word of a
// TRS symbol. The xyz_err signal is asserted if an error is detected in the
// format of the XYZ word stored in pipe2. This signal is not valid for the
// 4444 component digital video formats. The xyz_err_4444 signal is asserted
// for XYZ word format errors.
//
assign xyz = trs_delay[1];

assign xyz_err = 
    xyz & 
    ((pipe2_vid[5] ^ pipe2_vid[7] ^ pipe2_vid[6]) |                 // P3 = V ^ H
     (pipe2_vid[4] ^ pipe2_vid[8] ^ pipe2_vid[6]) |                 // P2 = F ^ H
     (pipe2_vid[3] ^ pipe2_vid[8] ^ pipe2_vid[7]) |                 // P1 = F ^ V
     (pipe2_vid[2] ^ pipe2_vid[8] ^ pipe2_vid[7] ^ pipe2_vid[6]) |  // P0 = F ^ V ^ H
     ~pipe2_vid[9]);

assign xyz_err_4444 = 
    xyz &
    ((pipe2_vid[4] ^ pipe2_vid[8] ^ pipe2_vid[7] ^ pipe2_vid[6]) |  // P4 = F ^ V ^ H
     (pipe2_vid[3] ^ pipe2_vid[8] ^ pipe2_vid[7] ^ pipe2_vid[5]) |  // P3 = F ^ V ^ S
     (pipe2_vid[2] ^ pipe2_vid[7] ^ pipe2_vid[6] ^ pipe2_vid[5]) |  // P2 = V ^ H ^ S
     (pipe2_vid[1] ^ pipe2_vid[8] ^ pipe2_vid[6] ^ pipe2_vid[5]) |  // P1 = F ^ H ^ S
     ~pipe2_vid[9]);

//
// output reg
//
// The output register holds the the output video data and various flags.
// 
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
        begin
            out_reg_vid <= 0;
            out_reg_trs <= 1'b0;
            out_reg_eav <= 1'b0;
            out_reg_sav <= 1'b0;
            out_reg_anc <= 1'b0;
            out_reg_edh <= 1'b0;
            out_reg_xyz <= 1'b0;
            out_reg_xyz_err <= 1'b0;
            out_reg_xyz_err_4444 <= 1'b0;
            out_reg_f <= 0;
            out_reg_v <= 0;
            out_reg_h <= 0;
        end
        else
        begin
            out_reg_vid <= pipe2_vid;
            out_reg_trs <= trs;
            out_reg_eav <= eav;
            out_reg_sav <= sav;
            out_reg_anc <= anc;
            out_reg_edh <= anc & edh_in;
            out_reg_xyz <= xyz;
            out_reg_xyz_err <= xyz_err;
            out_reg_xyz_err_4444 <= xyz_err_4444;
            out_reg_f <= f;
            out_reg_v <= v;
            out_reg_h <= h;
        end
    end

//
// trs_delay register
//
// Used to assert the xyz signal when pipe2 contains the XYZ word of a TRS
// symbol.
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            trs_delay <= 2'b00;
        else
            trs_delay <= {trs_delay[0], out_reg_trs};
    end

//
// assign the outputs
//
assign vid_out = out_reg_vid;
assign rx_trs = out_reg_trs;
assign rx_eav = out_reg_eav;
assign rx_sav = out_reg_sav;
assign rx_anc = out_reg_anc;
assign rx_xyz = out_reg_xyz;
assign rx_xyz_err = out_reg_xyz_err;
assign rx_xyz_err_4444 = out_reg_xyz_err_4444;
assign rx_edh = out_reg_edh;
assign rx_f = out_reg_f;
assign rx_v = out_reg_v;
assign rx_h = out_reg_h;
            
endmodule
