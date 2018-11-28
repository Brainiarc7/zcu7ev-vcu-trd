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
This module processes a received EDH packet. It examines the vcnt and hcnt
values from the video flywheel to determine when an EDH packet should occur. If
there is no EDH packet then, the missing EDH packet flag is asserted. If an EDH
packet occurs somewhere other than where it is expected, the misplaced EDH
packet flag is asserted.

When an EDH packet at the expected location if found, it is checked to make
sure all the words of the packet are correct, that the parity of the payload
data words are correct, and that the checksum for the packet is correct.

The active picture and full field CRCs and flags are extracted and stored in
registers.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_rx_v1_0_0_edh_rx (
    input  wire             clk,                    // clock input
    input  wire             ce,                     // clock enable
    input  wire             rst,                    // sync reset input
    input  wire             rx_edh_next,            // indicates the next word is the first word of a received EDH packet
    input  wire [9:0]       vid_in,                 // video data
    input  wire             edh_next,               // EDH packet begins on next sample
    input  wire             reg_flags,              // 1 = register flag words, 0 = feed vid_in through
    output reg              ap_crc_valid = 1'b0,    // valid bit for active picture CRC
    output wire [15:0]      ap_crc,                 // active picture CRC
    output reg              ff_crc_valid = 1'b0,    // valid bit for full field CRC
    output wire [15:0]      ff_crc,                 // full field CRC
    output reg              edh_missing = 1'b0,     // asserted when last expected EDH packet was missing
    output reg              edh_parity_err = 1'b0,  // asserted when a parity error occurs in EDH packet
    output reg              edh_chksum_err = 1'b0,  // asserted when a checksum error occurs in EDH packet
    output reg              edh_format_err = 1'b0,  // asserted when a format error is found in EDH packet
    output wire [4:0]       in_ap_flags,            // received AP flag word to edh_flags module
    output wire [4:0]       in_ff_flags,            // received FF flag word to edh_flags module
    output wire [4:0]       in_anc_flags,           // received ANC flag word to edh_flags module
    output wire [4:0]       rx_ap_flags,            // received & registered AP flags for external inspection
    output wire [4:0]       rx_ff_flags,            // received & registered FF flags for external inspection
    output wire [4:0]       rx_anc_flags            // received & registered ANC flags for external inspection
);


//-----------------------------------------------------------------------------
// Parameter definitions
//      

//
// This group of parameters defines the fixed values of some of the words in
// the EDH packet.
//
localparam EDH_DID           = 10'h1f4;
localparam EDH_DBN           = 10'h200;
localparam EDH_DC            = 10'h110;


//
// This group of parameters defines the states of the EDH processor state
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
    S_CHK    = 23,
    S_ERRM   = 24,  // Missing EDH packet
    S_ERRF   = 25,  // Format error in EDH packet
    S_ERRC   = 26;  // Checksum error in EDH packet

//-----------------------------------------------------------------------------
// Signal definitions
//
reg     [STATE_MSB:0]   current_state = S_WAIT;     // FSM current state
reg     [STATE_MSB:0]   next_state;                 // FSM next state
wire                    parity_err;                 // detects parity errors on EDH words
wire                    parity;                     // used to generate parity_err
reg     [8:0]           checksum = 9'b0;            // checksum for EDH packet
reg                     ld_ap1;                     // loads bits 5:0 of active picture crc
reg                     ld_ap2;                     // loads bits 11:6 of active picture crc
reg                     ld_ap3;                     // loads bits 15:12 of active picture crc
reg                     ld_ff1;                     // loads bits 5:0 of full field crc
reg                     ld_ff2;                     // loads bits 11:6 of full field crc
reg                     ld_ff3;                     // loads bits 15:12 of full field crc
reg                     ld_ap_flags;                // loads the rx_ap_flags register
reg                     ld_ff_flags;                // loads the rx_ff_flags register
reg                     ld_anc_flags;               // loads the rx_anc_flags register
reg                     clr_checksum;               // asserted to clear the checksum
reg                     clr_errors;                 // asserted to clear the EDH packet errs
reg     [15:0]          ap_crc_reg = 15'b0;         // active picture CRC register
reg     [15:0]          ff_crc_reg = 15'b0;         // full field CRC register                  
reg                     missing_err;                // asserted when EDH packet is missing
reg                     format_err;                 // asserted when format error in EDH packet is detected
reg                     check_parity;               // asserted when parity error in EDH packet is detected
reg                     checksum_err;               // asserted when checksum error in EDH packet is detected
reg                     rx_edh = 1'b0;              // asserted when current word is first word of received EDH
reg     [4:0]           rx_ap_flg_reg = 5'b0;       // holds the received AP flags
reg     [4:0]           rx_ff_flg_reg = 5'b0;       // holds the received FF flags
reg     [4:0]           rx_anc_flg_reg = 5'b0;      // holds the received ANC flags

//
// delay flip-flop for rx_edh_next
//
// The resulting signal, rx_edh, is asserted during the first word of a
// received EDH packet.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            rx_edh <= 1'b0;
        else
            rx_edh <= rx_edh_next;
    end

//
// FSM: current_state register
//
// This code implements the current state register. 
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
                
        S_ADF1:     if (rx_edh)
                        next_state = S_ADF2;
                    else
                        next_state = S_ERRM;

        S_ADF2:     next_state = S_ADF3;

        S_ADF3:     next_state = S_DID;

        S_DID:      next_state = S_DBN;

        S_DBN:      if (vid_in[9:2] == (EDH_DBN >> 2))
                        next_state = S_DC;
                    else
                        next_state = S_ERRF;

        S_DC:       if (vid_in[9:2] == (EDH_DC >> 2))
                        next_state = S_AP1;
                    else
                        next_state = S_ERRF;

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

        S_CHK:      if (checksum == vid_in[8:0] && checksum[8] == ~vid_in[9])
                        next_state = S_WAIT;
                    else
                        next_state = S_ERRC;

        S_ERRM:     next_state = S_WAIT;

        S_ERRF:     next_state = S_WAIT;

        S_ERRC:     next_state = S_WAIT;

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
    ld_ap1          = 1'b0;
    ld_ap2          = 1'b0;
    ld_ap3          = 1'b0;
    ld_ff1          = 1'b0;
    ld_ff2          = 1'b0;
    ld_ff3          = 1'b0;
    ld_ap_flags     = 1'b0;
    ld_ff_flags     = 1'b0;
    ld_anc_flags    = 1'b0;
    clr_checksum    = 1'b0;
    clr_errors      = 1'b0;
    missing_err     = 1'b0;
    format_err      = 1'b0;
    check_parity    = 1'b0;
    checksum_err    = 1'b0;
                        
    case(current_state)     
        S_ADF1:     clr_errors = 1'b1;

        S_ADF3:     clr_checksum = 1'b1;

        S_AP1:      begin
                        ld_ap1 = 1'b1;
                        check_parity = 1'b1;
                    end

        S_AP2:      begin
                        ld_ap2 = 1'b1;
                        check_parity = 1'b1;
                    end

        S_AP3:      begin
                        ld_ap3 = 1'b1;
                        check_parity = 1'b1;
                    end

        S_FF1:      begin
                        ld_ff1 = 1'b1;
                        check_parity = 1'b1;
                    end

        S_FF2:      begin
                        ld_ff2 = 1'b1;
                        check_parity = 1'b1;
                    end

        S_FF3:      begin
                        ld_ff3 = 1'b1;
                        check_parity = 1'b1;
                    end

        S_ANCFLG:   begin
                        ld_anc_flags = 1'b1;
                        check_parity = 1'b1;
                    end

        S_APFLG:    begin
                        ld_ap_flags = 1'b1;
                        check_parity = 1'b1;
                    end

        S_FFFLG:    begin
                        ld_ff_flags = 1'b1;
                        check_parity = 1'b1;
                    end

        S_ERRM:     missing_err = 1'b1;

        S_ERRF:     format_err = 1'b1;

        S_ERRC:     checksum_err = 1'b1;

    endcase
end

//
// parity error detection
//
// This code calculates the parity of bits 7:0 of the video word. The calculated
// parity bit is compared to bit 8 and the complement of bit 9 to determine if
// a parity error has occured. If a parity error is detected, the parity_err
// signal is asserted. Parity is only valid on the payload portion of the
// EDH packet (user data words).
//
assign parity = vid_in[7] ^ vid_in[6] ^ vid_in[5] ^ vid_in[4] ^
                vid_in[3] ^ vid_in[2] ^ vid_in[1] ^ vid_in[0];

assign parity_err = (parity ^ vid_in[8]) | (parity ^ ~vid_in[9]);


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
            checksum <= checksum + vid_in[8:0];
    end


//
// Active-picture CRC and valid bit register
//
// This code captures the AP CRC word and valid bit. The CRC word is carried
// in three different words in the EDH packet and is assembled into a complete
// 16-bit checkword plus a valid bit by this logic.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
        begin
            ap_crc_valid <= 1'b0;
            ap_crc_reg <= 0;
        end
        else
        begin
            if (ld_ap1)
                ap_crc_reg <= {ap_crc_reg[15:6], vid_in[7:2]};
            else if (ld_ap2)
                ap_crc_reg <= {ap_crc_reg[15:12], vid_in[7:2], ap_crc_reg[5:0]};
            else if (ld_ap3)
            begin
                ap_crc_reg <= {vid_in[5:2], ap_crc_reg[11:0]};
                ap_crc_valid <= vid_in[7];
            end
        end
    end

//
// Full-field CRC and valid bit register
//
// This code captures the FF CRC word and valid bit. The CRC word is carried
// in three different words in the EDH packet and is assembled into a complete
// 16-bit checkword plus a valid bit by this logic.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
        begin
            ff_crc_valid <= 1'b0;
            ff_crc_reg <= 0;
        end
        else
        begin
            if (ld_ff1)
                ff_crc_reg <= {ff_crc_reg[15:6], vid_in[7:2]};
            else if (ld_ff2)
                ff_crc_reg <= {ff_crc_reg[15:12], vid_in[7:2], ff_crc_reg[5:0]};
            else if (ld_ff3)
            begin
                ff_crc_reg <= {vid_in[5:2], ff_crc_reg[11:0]};
                ff_crc_valid <= vid_in[7];
            end
        end
    end

//
// EDH packet error flags
//
// This code implements registers for each of the four different EDH packet
// error flags. These flags are captured as an EDH packet is received and
// remain asserted until the start of the next EDH packet.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst | clr_errors)
        begin
            edh_missing <= 1'b0;
            edh_parity_err <= 1'b0;
            edh_chksum_err <= 1'b0;
            edh_format_err <= 1'b0;
        end
        else 
        begin
            if (missing_err)
                edh_missing <= 1'b1;
            if (format_err)
                edh_format_err <= 1'b1;
            if (checksum_err)
                edh_chksum_err <= 1'b1;
            if (check_parity & parity_err)
                edh_parity_err <= 1'b1;
        end
    end


//
// received flags registers
//
// These registers capture the three sets of error status flags (ap, ff, and
// anc) from the received EDH packet. These flags remain in the registers 
// until overwritten by the next EDH packet.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            rx_ap_flg_reg <= 0;
        else if (ld_ap_flags)
            rx_ap_flg_reg <= vid_in[6:2];
    end

assign in_ap_flags = reg_flags ? rx_ap_flg_reg : vid_in[6:2];

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            rx_ff_flg_reg <= 0;
        else if (ld_ff_flags)
            rx_ff_flg_reg <= vid_in[6:2];
    end

assign in_ff_flags = reg_flags ? rx_ff_flg_reg : vid_in[6:2];

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            rx_anc_flg_reg <= 0;
        else if (ld_anc_flags)
            rx_anc_flg_reg <= vid_in[6:2];
    end
                            
assign in_anc_flags = reg_flags ? rx_anc_flg_reg : vid_in[6:2];

//
// outputs assignments
//
assign ap_crc = ap_crc_reg;
assign ff_crc = ff_crc_reg;
    
assign rx_ap_flags = rx_ap_flg_reg;
assign rx_ff_flags = rx_ff_flg_reg;
assign rx_anc_flags = rx_anc_flg_reg;
                    
endmodule
