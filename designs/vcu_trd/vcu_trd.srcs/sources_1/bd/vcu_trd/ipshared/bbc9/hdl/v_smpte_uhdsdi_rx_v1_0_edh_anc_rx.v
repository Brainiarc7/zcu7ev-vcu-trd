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
This module checks the parity bits and checksums of all ANC packets (except EDH
packets) on the video stream.. If any errors are detected in ANC packets during
a field, the module will assert the anc_edh_local signal. This signal is used 
by the edh_gen module to assert the edh flag in the ANC flag set of the next 
EDH packet it generates. The anc_edh_local signal remains asserted until the
EDH packet has been sent (as indicated the edh_packet input being asserted then
negated).

The module will not do any checking after reset until the video decoder's locked
signal is asserted for the first time.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_rx_v1_0_0_edh_anc_rx (
    input  wire         clk,                    // clock input
    input  wire         ce,                     // clock enable
    input  wire         rst,                    // sync reset input
    input  wire         locked,                 // video decoder locked signal
    input  wire         rx_anc_next,            // indicates the next word is the first word of a received ANC packet
    input  wire         rx_edh_next,            // indicates the next word is the first word of a received EDH packet
    input  wire         edh_packet,             // indicates an EDH packet is being generated
    input  wire [9:0]   vid_in,                 // video data
    output reg          anc_edh_local = 1'b0    // ANC edh flag
);


//-----------------------------------------------------------------------------
// Parameter definitions
//      

//
// This group of parameters defines the states of the EDH processor state
// machine.
//
localparam STATE_WIDTH   = 4;
localparam STATE_MSB     = STATE_WIDTH - 1;

localparam [STATE_WIDTH-1:0]
    S_WAIT   = 0,
    S_ADF1   = 1,
    S_ADF2   = 2,
    S_ADF3   = 3,
    S_DID    = 4,
    S_DBN    = 5,
    S_DC     = 6,
    S_UDW    = 7,
    S_CHK    = 8,
    S_EDH1   = 9,
    S_EDH2   = 10,
    S_EDH3   = 11;

//-----------------------------------------------------------------------------
// Signal definitions
//
reg     [STATE_MSB:0]   current_state = S_WAIT; // FSM current state
reg     [STATE_MSB:0]   next_state;             // FSM next state
wire                    parity;                 // used to generate parity_err signal
wire                    parity_err;             // asserted on parity error
reg                     check_parity;           // asserted when parity should be checked
reg     [8:0]           checksum = 9'b0;        // checksum generator for ANC packet
reg                     clr_checksum;           // asserted to clear the checksum
reg                     check_checksum;         // asserted when checksum is to be tested
reg                     clr_edh_flag;           // asserted to clear the edh flag
reg                     checksum_err;           // asserted when checksum error in EDH packet is detected
reg     [7:0]           udw_cntr = 8'b0;        // user data word counter
reg                     udwcntr_eq_0;           // asserted when output of UDW in MUX is zero
wire    [7:0]           udw_mux;                // UDW counter input MUX
reg                     ld_udw_cntr;            // loads the UDW counter when asserted
reg                     enable = 1'b0;          // generated from locked input

//
// enable signal
//
// This signal enables checking of the parity and checksum. It is negated on
// reset and remains negated until locked is asserted for the first time.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            enable <= 1'b0;
        else if (locked)
            enable <= 1'b1;
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
        S_WAIT:     if (~enable)
                        next_state = S_WAIT;
                    else if (rx_anc_next & ~rx_edh_next)
                        next_state = S_ADF1;
                    else if (edh_packet)
                        next_state = S_EDH1;
                    else
                        next_state = S_WAIT;
                
        S_ADF1:     next_state = S_ADF2;

        S_ADF2:     next_state = S_ADF3;

        S_ADF3:     next_state = S_DID;

        S_DID:      if (parity_err)
                        next_state = S_WAIT;
                    else
                        next_state = S_DBN;

        S_DBN:      if (parity_err)
                        next_state = S_WAIT;
                    else
                        next_state = S_DC;

        S_DC:       if (parity_err)
                        next_state = S_WAIT;
                    else if (udwcntr_eq_0)
                        next_state = S_CHK;
                    else
                        next_state = S_UDW;

        S_UDW:      if (udwcntr_eq_0)
                        next_state = S_CHK;
                    else
                        next_state = S_UDW;

        S_CHK:      next_state = S_WAIT;

        S_EDH1:     if (~edh_packet)
                        next_state = S_EDH1;
                    else
                        next_state = S_EDH2;

        S_EDH2:     if (edh_packet)
                        next_state = S_EDH2;
                    else
                        next_state = S_EDH3;

        S_EDH3:     next_state = S_WAIT;

        default:    next_state = S_WAIT;

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
    // default to the values given here.
    clr_checksum    = 1'b0;
    clr_edh_flag    = 1'b0;
    check_parity    = 1'b0;
    ld_udw_cntr     = 1'b0;
    check_checksum  = 1'b0;
                            
    case(current_state)     
        S_EDH3:     clr_edh_flag = 1'b1;

        S_ADF3:     clr_checksum = 1'b1;

        S_DID:      check_parity = 1'b1;

        S_DBN:      check_parity = 1'b1;

        S_DC:       begin
                        ld_udw_cntr = 1'b1;
                        check_parity = 1'b1;
                    end

        S_CHK:      check_checksum = 1'b1;

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
// checksum tester
//
// This logic asserts the checksum_err signal if the calculated and received
// checksum are not the same.
//
always @ (*)
    if (checksum == vid_in[8:0] && checksum[8] == ~vid_in[9])
        checksum_err = 1'b0;
    else
        checksum_err = 1'b1;

//
// UDW counter, input MUX, and comparator
//
// The UDW counter is designed to count the number of user data words in the
// ANC packet so that the FSM knows when the payload portion of the ANC
// packet is over.
//
// The ld_udw_cntr signal controls a MUX. When this signal is asserted, the
// MUX outputs the vid_in data word. Otherwise, the MUX outputs the contents of
// the UDW counter. The output of the MUX is decremented by one and loaded into
// the UDW counter. The output of the MUX is also tested to see if it equals
// zero and the udwcntr_eq_0 signal is asserted if so.
//
assign udw_mux = ld_udw_cntr ? vid_in[7:0] : udw_cntr;

always @ (*)
    if (udw_mux == 8'b00000000)
        udwcntr_eq_0 = 1'b1;
    else
        udwcntr_eq_0 = 1'b0;
        
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            udw_cntr <= 0;
        else
            udw_cntr <= udw_mux - 1;
    end
        
//
// anc_edh_local flag
//
// This flag is reset whenever an EDH packet is generated. The flag is set
// if a parity error or checksum error is detected during a field.
//
always @ (posedge clk)
    if (ce)
        begin
            if (rst | clr_edh_flag)
                anc_edh_local <= 1'b0;
            else if (parity_err & check_parity)
                anc_edh_local <= 1'b1;
            else if (checksum_err & check_checksum)
                anc_edh_local <= 1'b1;
        end
                            
endmodule
