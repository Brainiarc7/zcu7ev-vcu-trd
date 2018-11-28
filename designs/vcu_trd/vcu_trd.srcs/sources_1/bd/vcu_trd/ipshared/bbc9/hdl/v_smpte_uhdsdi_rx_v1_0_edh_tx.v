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
This module generates a new EDH packet and inserts it into the output video
stream.

The module is controlled by a finite state machine. The FSM waits for the
edh_next signal to be asserted by the edh_loc module. This signal indicates
that the next word is beginning of the area where an EDH packet should be
inserted.

The FSM then generates all the words of the EDH packet, assembling the payload
of the packet from the CRC and error flag inputs. The three sets of error flags
enter the module sequentially on the flags_in port. The module generates three
outputs (ap_flag_word, ff_flag_word, and anc_flag_word) to indicate which flag
set it needs on the flags_in port.

The module generates an output signal, edh_packet, that is asserted during all
the entire time that a generated EDH packet is being inserted into the video
stream. This signal is used by various other modules to determine when an EDH
packet has been sent.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_rx_v1_0_0_edh_tx (
    // inputs
    input  wire                 clk,                // clock input
    input  wire                 ce,                 // clock enable
    input  wire                 rst,                // sync reset input
    input  wire [9:0]           vid_in,             // input video data
    input  wire                 edh_next,           // asserted when next word begins generated EDH packet
    input  wire                 edh_missing,        // received EDH packet is missing
    input  wire                 ap_crc_valid,       // active picture CRC valid
    input  wire [15:0]          ap_crc,             // active picture CRC
    input  wire                 ff_crc_valid,       // full field CRC valid
    input  wire [15:0]          ff_crc,             // full field CRC
    input  wire [4:0]           flags_in,           // bus that carries AP, FF, and ANC flags
    output reg                  ap_flag_word,       // asserted during AP flag word in EDH packet
    output reg                  ff_flag_word,       // asserted during FF flag word in EDH packet
    output reg                  anc_flag_word,      // asserted during ANC flag word in EDH packet
    output reg                  edh_packet = 1'b0,  // asserted during all words of EDH packet
    output wire [9:0]           edh_vid             // generated EDH packet data
);


//-----------------------------------------------------------------------------
// Parameter definitions
//      

//
// This group of parameters defines the fixed values of some of the words in
// the EDH packet.
//
localparam EDH_ADF1          = 10'h000;
localparam EDH_ADF2          = 10'h3ff;
localparam EDH_ADF3          = 10'h3ff;
localparam EDH_DID           = 10'h1f4;
localparam EDH_DBN           = 10'h200;
localparam EDH_DC            = 10'h110;
localparam EDH_RSVD          = 10'h200;

//
// This group of parameters defines the states of the EDH generator state
// machine.
//
localparam STATE_WIDTH   = 5;
localparam STATE_MSB     = STATE_WIDTH - 1;

localparam [STATE_WIDTH-1:0]
    S_WAIT   = 0,
    S_ADF1   = 1,
    S_ADF2   = 2,
    S_ADF3   = 3,
    S_DID    = 4,
    S_DBN    = 5,
    S_DC     = 6,
    S_AP1    = 7,
    S_AP2    = 8,
    S_AP3    = 9,
    S_FF1    = 10,
    S_FF2    = 11,
    S_FF3    = 12,
    S_ANCFLG = 13,
    S_APFLG  = 14,
    S_FFFLG  = 15,
    S_RSV1   = 16,
    S_RSV2   = 17,
    S_RSV3   = 18,
    S_RSV4   = 19,
    S_RSV5   = 20,
    S_RSV6   = 21,
    S_RSV7   = 22,
    S_CHK    = 23;

//-----------------------------------------------------------------------------
// Signal definitions
//
reg     [STATE_MSB:0]   current_state = S_WAIT;     // FSM current state register
reg     [STATE_MSB:0]   next_state;                 // FSM next state value
wire                    parity;                     // used to generate parity bit for EDH packet words
reg     [8:0]           checksum = 9'b0;            // used to calculated EDH packet CS word
reg                     clr_checksum;               // clears the checksum register
reg     [9:0]           vid;                        // internal version of edh_vid output port
reg                     end_packet;                 // FSM output that clears the edh_packet signal


//
// FSM: current_state register
//
// This code implements the current state register. It loads with the HSYNC1
// state on reset and the next_state value with each rising clock edge.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            current_state <= S_WAIT;
        else
            current_state <= next_state;
    end

//
// FSM: next_state logic
//
// This case statement generates the next_state value for the FSM based on
// the current_state and the various FSM inputs.
//
always @ (*)
    case(current_state)
        S_WAIT:     if (edh_next)
                        next_state = S_ADF1;
                    else
                        next_state = S_WAIT;
                
        S_ADF1:     next_state = S_ADF2;

        S_ADF2:     next_state = S_ADF3;

        S_ADF3:     next_state = S_DID;

        S_DID:      next_state = S_DBN;

        S_DBN:      next_state = S_DC;

        S_DC:       next_state = S_AP1;

        S_AP1:      next_state = S_AP2;

        S_AP2:      next_state = S_AP3;

        S_AP3:      next_state = S_FF1;

        S_FF1:      next_state = S_FF2;

        S_FF2:      next_state = S_FF3;

        S_FF3:      next_state = S_ANCFLG;

        S_ANCFLG:   next_state = S_APFLG;

        S_APFLG:    next_state = S_FFFLG;
                    
        S_FFFLG:    next_state = S_RSV1;

        S_RSV1:     next_state = S_RSV2;

        S_RSV2:     next_state = S_RSV3;

        S_RSV3:     next_state = S_RSV4;

        S_RSV4:     next_state = S_RSV5;

        S_RSV5:     next_state = S_RSV6;

        S_RSV6:     next_state = S_RSV7;

        S_RSV7:     next_state = S_CHK;

        S_CHK:      next_state = S_WAIT;

        default: next_state = S_WAIT;

    endcase
        
//
// FSM: outputs
//
// This block decodes the current state to generate the various outputs of the
// FSM.
//
always @ (*)
begin
    // Unless specifically assigned in the case statement, all FSM outputs
    // default to the values below.
    vid             = vid_in;
    clr_checksum    = 1'b0;
    end_packet      = 1'b0;
    ap_flag_word    = 1'b0;
    ff_flag_word    = 1'b0;
    anc_flag_word   = 1'b0;
                                
    case(current_state)     
        S_ADF1:     vid = EDH_ADF1;

        S_ADF2:     vid = EDH_ADF2;

        S_ADF3:     begin
                        vid = EDH_ADF3;
                        clr_checksum = 1'b1;
                    end

        S_DID:      vid = EDH_DID;

        S_DBN:      vid = EDH_DBN;

        S_DC:       vid = EDH_DC;

        S_AP1:      vid = {~parity, parity, ap_crc[5:0], 2'b00};

        S_AP2:      vid = {~parity, parity, ap_crc[11:6], 2'b00};

        S_AP3:      vid = {~parity, parity, ap_crc_valid, 1'b0, 
                            ap_crc[15:12], 2'b00};

        S_FF1:      vid = {~parity, parity, ff_crc[5:0], 2'b00};

        S_FF2:      vid = {~parity, parity, ff_crc[11:6], 2'b00};

        S_FF3:      vid = {~parity, parity, ff_crc_valid, 1'b0, 
                            ff_crc[15:12], 2'b00};

        S_ANCFLG:   begin
                        vid = {~parity, parity, 1'b0, flags_in, 2'b00};
                        anc_flag_word = 1'b1;
                    end

        S_APFLG:    begin
                        vid = {~parity, parity, 1'b0, flags_in, 2'b00};
                        ap_flag_word = 1'b1;
                    end

        S_FFFLG:    begin
                        vid = {~parity, parity, 1'b0, flags_in, 2'b00};
                        ff_flag_word = 1'b1;
                    end

        S_RSV1:     vid = EDH_RSVD;

        S_RSV2:     vid = EDH_RSVD;

        S_RSV3:     vid = EDH_RSVD;

        S_RSV4:     vid = EDH_RSVD;

        S_RSV5:     vid = EDH_RSVD;

        S_RSV6:     vid = EDH_RSVD;

        S_RSV7:     vid = EDH_RSVD;

        S_CHK:      begin
                        vid = {~checksum[8], checksum};
                        end_packet = 1'b1;
                    end
    endcase
end

//
// parity bit generation
//
// This code calculates the parity of bits 7:0 of the video word. The parity
// bit is inserted into bit 8 of parity protected words of the EDH packet. The
// complement of the parity bit is inserted into bit 9 of those same words.
//
assign parity = vid[7] ^ vid[6] ^ vid[5] ^ vid[4] ^
                vid[3] ^ vid[2] ^ vid[1] ^ vid[0];


//
// checksum calculator
//
// This code generates a checksum for the EDH packet. The checksum is cleared
// to zero prior to beginning the checksum calculation by the FSM asserting the
// clr_checksum signal. The vid_in word is added to the current checksum when
// the FSM asserts the do_checksum signal. The checksum is a 9-bit value and
// is computed by summing all but the MSB of the vid_in word with the current
// checksum value and ignoring any carry bits.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst | clr_checksum)
            checksum <= 0;
        else 
            checksum <= checksum + vid[8:0];
    end

//
// edh_packet signal
//
// The edh_packet signal becomes asserted at the beginning of an EDH packet
// and remains asserted through the last word of the EDH packet.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            edh_packet <= 1'b0;
        else
        begin
            if (edh_next)
                edh_packet <= 1'b1;
            else if (end_packet)
                edh_packet <= 1'b0;
        end
    end

//
// output assignments
//
assign edh_vid = vid;

endmodule
