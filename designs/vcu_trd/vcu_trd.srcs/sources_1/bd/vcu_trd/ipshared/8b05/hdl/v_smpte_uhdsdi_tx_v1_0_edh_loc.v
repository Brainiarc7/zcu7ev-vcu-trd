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
This module examines the vcnt and hcnt values to determine when it is time for
an EDH packet to appear in the video stream. The signal edh_next is asserted
during the sample before the first location of the first ADF word of the
EDH packet.

The output of this module is used to determine if EDH packets are missing from
the input video stream and to determine when to insert EDH packets into the
output video stream.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_tx_v1_0_0_edh_loc #(
    parameter HCNT_WIDTH = 12,  // # of bits in horizontal sample counter
    parameter VCNT_WIDTH = 10)  // # of bits in vertical line counter
(
    input  wire                     clk,            // clock input
    input  wire                     ce,             // clock enable
    input  wire                     rst,            // sync reset input
    input  wire                     f,              // field bit
    input  wire [VCNT_WIDTH-1:0]    vcnt,           // vertical line count
    input  wire [HCNT_WIDTH-1:0]    hcnt,           // horizontal sample count
    input  wire [2:0]               std,            // indicates the video standard
    output reg                      edh_next = 1'b0 // EDH packet should begin on next sample
);


//-----------------------------------------------------------------------------
// Parameter definitions
//
localparam HCNT_MSB      = HCNT_WIDTH - 1;       // MS bit # of hcnt
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
// This group of parameters defines the line numbers where the EDH packet is
// located.
//
localparam NTSC_FLD1_EDH_LINE = 272;
localparam NTSC_FLD2_EDH_LINE =   9;
localparam PAL_FLD1_EDH_LINE  = 318;
localparam PAL_FLD2_EDH_LINE  =   5;
         
//
// This group of parameters defines the word count two words before the
// start of the EDH packet for each different supported video standard. First,
// the position of the SAV is defined, then the EDH packet position is defined
// relative to the SAV. A point two words counts before the start of the EDH
// packet is used because the edh_next must be asserted the count before the
// EDH plus there is one cycle of clock latency.
//

localparam SAV_NTSC_422      = 1712;
localparam SAV_NTSC_422_WIDE = 2284;
localparam SAV_NTSC_4444     = 3428;
localparam SAV_PAL_422       = 1724;
localparam SAV_PAL_422_WIDE  = 2300;
localparam SAV_PAL_4444      = 3452;

localparam EDH_PACKET_LENGTH = 23;

localparam EDH_NTSC_422      = SAV_NTSC_422 - EDH_PACKET_LENGTH - 2;
localparam EDH_NTSC_422_WIDE = SAV_NTSC_422_WIDE - EDH_PACKET_LENGTH - 2;
localparam EDH_NTSC_4444     = SAV_NTSC_4444 - EDH_PACKET_LENGTH - 2;
localparam EDH_PAL_422       = SAV_PAL_422 - EDH_PACKET_LENGTH - 2;
localparam EDH_PAL_422_WIDE  = SAV_PAL_422_WIDE - EDH_PACKET_LENGTH - 2;
localparam EDH_PAL_4444      = SAV_PAL_4444 - EDH_PACKET_LENGTH - 2;
        
//-----------------------------------------------------------------------------
// Signal definitions
//
wire                    ntsc;           // 1 = NTSC, 0 = PAL
reg     [VCNT_MSB:0]    edh_line_num;   // EDH occurs on this line number
wire                    edh_line;       // asserted when vcnt == edh_line_num
reg     [HCNT_MSB:0]    edh_hcnt;       // EDH begins sample after this value
wire                    edh_next_d;     // asserted when next sample begins EDH

//
// EDH vertical position detector
// 
// The following code determines when the current video line number (vcnt)
// matches the line where the next EDH packet location occurs. The line numbers
// for the EDH packets are different for NTSC and PAL video standards. Also,
// there is one EDH per field, so the field bit (f) is used to determine the
// line number of the next EDH packet.
//
assign ntsc = (std == NTSC_422) || (std == NTSC_INVALID) ||
              (std == NTSC_422_WIDE) || (std == NTSC_4444);

always @ (*)
    if (ntsc)
        begin
            if (~f)
                edh_line_num = NTSC_FLD2_EDH_LINE;
            else
                edh_line_num = NTSC_FLD1_EDH_LINE;
        end
    else
        begin
            if (~f)
                edh_line_num = PAL_FLD2_EDH_LINE;
            else
                edh_line_num = PAL_FLD1_EDH_LINE;
        end
            
assign edh_line = vcnt == edh_line_num;

//
// EDH horizontal position detector
//
// This code matches the current horizontal count (hcnt) with the word count
// of the next EDH location. The location of the EDH packet is immediately 
// before the SAV. edh_next_d is asserted when both the vcnt and hcnt match
// the EDH packet location.
//
always @ (*)
    case(std)
        NTSC_422:       edh_hcnt = EDH_NTSC_422;
        NTSC_422_WIDE:  edh_hcnt = EDH_NTSC_422_WIDE;
        NTSC_4444:      edh_hcnt = EDH_NTSC_4444;
        PAL_422:        edh_hcnt = EDH_PAL_422;
        PAL_422_WIDE:   edh_hcnt = EDH_PAL_422_WIDE;
        PAL_4444:       edh_hcnt = EDH_PAL_4444;
        default:        edh_hcnt = EDH_NTSC_422;
    endcase

assign edh_next_d = edh_line & (edh_hcnt == hcnt);

//
// output register
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            edh_next <= 1'b0;
        else
            edh_next <= edh_next_d;
    end
                    
endmodule
