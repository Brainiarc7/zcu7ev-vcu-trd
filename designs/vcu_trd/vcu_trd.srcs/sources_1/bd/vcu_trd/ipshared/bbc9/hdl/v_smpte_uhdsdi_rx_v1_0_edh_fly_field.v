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
Module description:

This module implements the field related functions for the video flywheel.
There are two main field related functions included in this module. The first
is the F bit. This bit indicates the field that is currently active. The other
function is the received field transition detector. This function determines
when the received video transition from one field to the next.

The inputs to this module are:

clk: clock input

rst: synchronous reset input

ce: clock enable

ld_f: When this input is asserted, the F flip-flop is loaded with the 
current field value.

inc_f: When this input is asserted the F flip-flop is toggled.

eav_next: Must be asserted the clock cycle before the first word of an EAV 
symbol is processed by the flywheel.

rx_field: This is the F bit from the XYZ word of the input video stream. This
input is only valied when rx_xyz is asserted.

rx_xyz: Asserted when the flywheel is processing the XYZ word of a TRS symbol.

The outputs of this module are:

f: Current field bit

new_rx_field: Asserted for when a field transition is detected. This signal
will be asserted for the entire duration of the first line of a new field.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_rx_v1_0_0_edh_fly_field (
    input  wire             clk,            // clock input
    input  wire             rst,            // sync reset input
    input  wire             ce,             // clock enable
    input  wire             ld_f,           // loads the F bit
    input  wire             inc_f,          // toggles the F bit
    input  wire             eav_next,       // asserted when next word is first word of EAV
    input  wire             rx_field,       // F bit from received XYZ word
    input  wire             rx_xyz,         // asserted during XYZ word of received TRS symbol
    output reg              f = 1'b0,       // field bit
    output wire             new_rx_field    // asserted when received field changes
);

//-----------------------------------------------------------------------------
// Signal definitions
//

reg rx_f_now = 1'b0;    // holds F bit from most recent XYZ word
reg rx_f_prev = 1'b0;   // holds F bit from previous XYZ word

//
// field bit
//                                  
// The field bit keep track of the current field (even or odd). It loads from
// the rx_f_now value when ld_f is asserted during the time the flywheel is
// synchronizing with the incoming video. Otherwise, it toggles at the
// beginning of each field.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            f <= 1'b0;
        else
        begin
            if (ld_f) 
                f <= rx_f_now;
            else if (eav_next & inc_f)
                f <= ~f;
        end
    end
                    

//
// received video new field detection
//
// The rx_f_now register holds the field value for the current field.
// The rx_f_prev register holds the field value from the previous field. If
// there is a difference between these two registers, the new_rx_field signal
// is asserted. This informs the FSM that the received video has transitioned
// from one field to the next.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
        begin
            rx_f_now  <= 1'b0;
            rx_f_prev <= 1'b0;
        end
        else if (rx_xyz)
        begin
            rx_f_now  <= rx_field;
            rx_f_prev <= rx_f_now;
        end
    end

assign new_rx_field = rx_f_now ^ rx_f_prev;

endmodule
