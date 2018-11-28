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
This module keeps a running count of the number of video fields that contain
an EDH error. By default, the counter is a 24-bit counter, but the counter
width can be modified by changing the ERROR_COUNT_WIDTH parameter.

A 16-bit wide error flag input vector, flags, allows up to sixteen different 
error flags to be monitored by the error counter. Each of the 16 error flags
has an associated flag_enable signal. If a flag_enable signal is low, the
corresponding error flag is ignored by the counter. If any enabled error flag
is asserted at the next EDH packet (edh_next asserted), the error counter is
incremented. There is no latching mechanism on the error flags -- they must
remain asserted until edh_next is asserted in order to increment the counter.

The error counter will saturate and will not roll over when it reaches the
maximum count. The counter is cleared on reset and when clr_errcnt is asserted.

A count enable input, count_en, is also provided to enable and disable the
error counter. This can be used to disable the counter when the video decoder
is not synchronized to the video stream. 
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_tx_v1_0_0_edh_errcnt #(
    parameter ERROR_COUNT_WIDTH = 24,
    parameter FLAGS_WIDTH       = 16)
(
    input  wire                         clk,            // clock input
    input  wire                         ce,             // clock enable
    input  wire                         rst,            // sync reset input
    input  wire                         clr_errcnt,     // clears the error counter
    input  wire                         count_en,       // enables error counter when high
    input  wire [FLAGS_WIDTH-1:0]       flag_enables,   // specifies which error flags cause the counter to increment
    input  wire [FLAGS_WIDTH-1:0]       flags,          // error flag inputs
    input  wire                         edh_next,       // counter increments on edh_next asserted
    output wire [ERROR_COUNT_WIDTH-1:0] errcnt          // error counter
);


//-----------------------------------------------------------------------------
// Parameter definitions
//

parameter ERRFLD_MSB    = ERROR_COUNT_WIDTH - 1;     // MS bit # of error counter
parameter FLAGS_MSB     = FLAGS_WIDTH - 1;      // MS bit # of error flag field
    
//-----------------------------------------------------------------------------
// Signal definitions
//
wire    [FLAGS_MSB:0]   enabled_flags;  // error flags after ANDing with enables
wire                    err_in_field;   // OR of all enabled error flags
wire                    errcnt_tc;      // asserted when errcnt reaches terminal count
wire    [ERRFLD_MSB:0]  next_count;     // current error count + 1
reg     [ERRFLD_MSB:0]  cntr = 0;       // actual error counter

//
// flag enabling logic
//
assign enabled_flags = flags & flag_enables;
assign err_in_field = |enabled_flags;

//
// error counter
//
assign next_count = cntr + 1;
assign errcnt_tc = next_count == 0;
    
always @ (posedge clk)
    if (ce)
        begin
            if (rst | clr_errcnt)
                cntr <= 0;
            else if (edh_next & ~errcnt_tc & err_in_field & count_en)
                cntr <= next_count;
        end
        
//
// output assignment
//
assign errcnt = cntr;
             
endmodule
