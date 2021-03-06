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
This module calculates new values for the EDH flags to be inserted into the
next generated EDH packet.

The flags captured from the received EDH packet are combined with the error 
flags generated by other modules and by internal EDH flags generated by
comparing the received CRC checkwords with the CRC values calculated by the
edh_crc module. 

The new flag values are calculated as the edh_gen module generates a new EDH
packet. The edh_flags module supplies the EDH flags to the edh_gen module over
a flag bus. The edh_gen module requests which set of EDH flags (ap, ff, or 
anc) is supplied over the flag bus with the ap_flag_word, ff_flag_word, and
anc_flag_word signals. The three flag sets are also captured and remain valid
on the ap_flags, ff_flags, and anc_flags output ports through the following
field.

edh flag (error detected here)

The edh flag for the ap and ff flag sets is asserted when the received and
calculated CRC values do not match. The edh flag will not be asserted if 
either CRC value is not valid or if an error was detected with the received 
EDH packet. A packet error is considered to have occurred if the EDH packet is 
missing or if the EDH packet contained a format or parity error. The checksum 
of the EDH packet is not checked soon enough to allow its consideration in 
this flag calculation.

The edh flag for the anc flag set is supplied as an input (anc_edh_local) to
this module. This normally comes from the edh_rx module and is asserted if any
ANC packet in the previous field had a parity or checksum error.

eda flag (error detected already)

The eda flag of each of the three flag sets is asserted if either the eda or 
the edh flag from the received EDH packet is asserted.

ues flag (unknown error status)

The ues flag for the ap and ff flag set is asserted if the ues flag in the
received EDH packet is asserted, if an error is detected in the EDH packet, or
if the corresponding CRC valid bit is not asserted.

The ues flag for the anc flag set is asserted if the ues flag in the anc flag
set of the received EDH packet is asserted, if an error is detected in the
received EDH packet, or if the anc_ues_local input signal is asserted.

idh flag (internal error detected here)

The idh flag for each flag set is set if the corresponding input signal
(ap_idh_local, ff_idh_local, and anc_idh_local), is asserted.

ida flag (internal error detected already)

The ida flag for each flag set is set if the either the idh or ida flags from
the received EDH packet are set.

The module has an input signal called receive_mode. If this signal is not
asserted, then the way the flags are generated is modified. The module assumes
that no EDH packets are being received by the processor (for example, if this
module is at the head end of a video chain). This input effectively disables
received packet errors from causing any of the flags to be asserted.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_rx_v1_0_0_edh_flags (
    input  wire                 clk,                // clock input
    input  wire                 ce,                 // clock enable input
    input  wire                 rst,                // reset input
    input  wire                 receive_mode,       // asserted if receiver is active
    input  wire                 ap_flag_word,       // asserted to select AP flag word on flag_bus
    input  wire                 ff_flag_word,       // asserted to select FF flag word on flag_bus
    input  wire                 anc_flag_word,      // asserted to select ANC flag word on flag_bus
    input  wire                 edh_missing,        // EDH packet missing from data stream
    input  wire                 edh_parity_err,     // EDH packet parity error
    input  wire                 edh_format_err,     // EDH packet format error
    input  wire                 rx_ap_crc_valid,    // received AP CRC valid bit
    input  wire [15:0]          rx_ap_crc,          // received AP CRC
    input  wire                 rx_ff_crc_valid,    // received FF CRC valid bit
    input  wire [15:0]          rx_ff_crc,          // received FF CRC
    input  wire [4:0]           rx_ap_flags,        // received AP flags
    input  wire [4:0]           rx_ff_flags,        // received FF flags
    input  wire [4:0]           rx_anc_flags,       // received ANC flags
    input  wire                 anc_edh_local,      // local ANC EDH flag input
    input  wire                 anc_idh_local,      // local ANC IDH flag input
    input  wire                 anc_ues_local,      // local ANC UES flag input
    input  wire                 ap_idh_local,       // local AP IDH flag input
    input  wire                 ff_idh_local,       // local FF IDH flag input
    input  wire                 calc_ap_crc_valid,  // calculated AP CRC valid bit
    input  wire [15:0]          calc_ap_crc,        // calculated AP CRC
    input  wire                 calc_ff_crc_valid,  // calculated FF CRC valid bit
    input  wire [15:0]          calc_ff_crc,        // calculated FF CRC
    output wire [4:0]           flags,              // flag output bus
    output reg  [4:0]           ap_flags = 0,       // holds AP flags from last EDH packet sent
    output reg  [4:0]           ff_flags = 0,       // holds FF flags from last EDH packet sent
    output reg  [4:0]           anc_flags           // holds ANC flags from last EDH packet sent
);


//-----------------------------------------------------------------------------
// Parameter definitions
//
// This set of parameters defines the bit positions of the five flags in each
// flag set.
//
localparam  EDH_BIT = 0;
localparam  EDA_BIT = 1;
localparam  IDH_BIT = 2;
localparam  IDA_BIT = 3;
localparam  UES_BIT = 4;

//-----------------------------------------------------------------------------
// Signal definitions
//
wire        ap_edh;     // internally generated ap_edh flag
wire        ap_ues;     // internally generated ap_ues flag
wire        ff_edh;     // internally generated ff_edh flag
wire        ff_ues;     // internally generated ff_uew flag
wire        packet_err; // asserted on a received EDH packet error

//
// EDH packet error detection
//
assign packet_err = (edh_missing | edh_parity_err | edh_format_err) & receive_mode;

//
// AP flag generation
//
assign ap_edh = ~packet_err & calc_ap_crc_valid & rx_ap_crc_valid & 
                (calc_ap_crc != rx_ap_crc);
assign ap_ues = ~rx_ap_crc_valid & receive_mode;

//
// FF flag generation
//
assign ff_edh = ~packet_err & calc_ff_crc_valid & rx_ff_crc_valid & 
                (calc_ff_crc != rx_ff_crc);
assign ff_ues = ~rx_ff_crc_valid & receive_mode;

//
// flags bus generation
//
assign flags[EDH_BIT] = (ap_flag_word & ap_edh) |
                        (ff_flag_word & ff_edh) |
                        (anc_flag_word & anc_edh_local);

assign flags[EDA_BIT] = ~packet_err & (
                        (ap_flag_word & (rx_ap_flags[EDH_BIT] | rx_ap_flags[EDA_BIT])) |
                        (ff_flag_word & (rx_ff_flags[EDH_BIT] | rx_ff_flags[EDA_BIT])) |
                        (anc_flag_word & (rx_anc_flags[EDH_BIT] | rx_anc_flags[EDA_BIT])));
                        

assign flags[IDH_BIT] = (ap_flag_word & ap_idh_local) |
                        (ff_flag_word & ff_idh_local) |
                        (anc_flag_word & anc_idh_local);

assign flags[IDA_BIT] = ~packet_err & ( 
                        (ap_flag_word & (rx_ap_flags[IDH_BIT] | rx_ap_flags[IDA_BIT])) |
                        (ff_flag_word & (rx_ff_flags[IDH_BIT] | rx_ff_flags[IDA_BIT])) |
                        (anc_flag_word & (rx_anc_flags[IDH_BIT] | rx_anc_flags[IDA_BIT])));
  
assign flags[UES_BIT] = packet_err |
                        (ap_flag_word & (ap_ues | (receive_mode & rx_ap_flags[UES_BIT]))) | 
                        (ff_flag_word & (ff_ues | (receive_mode & rx_ff_flags[UES_BIT]))) |
                        (anc_flag_word & (anc_ues_local | (receive_mode & rx_anc_flags[UES_BIT])));

//
// flag registers
//
// These register capture the three flag sets as the EDH packet is being
// generated and retain the error flag values until the next EDH packet is
// generated. This allows the error flag values to be observed by some other
// module or processor.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            ap_flags <= 0;
        else if (ap_flag_word)
            ap_flags <= flags;
    end

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            ff_flags <= 0;
        else if (ff_flag_word)
            ff_flags <= flags;
    end

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            anc_flags <= 0;
        else if (anc_flag_word)
            anc_flags <= flags;
    end

endmodule
