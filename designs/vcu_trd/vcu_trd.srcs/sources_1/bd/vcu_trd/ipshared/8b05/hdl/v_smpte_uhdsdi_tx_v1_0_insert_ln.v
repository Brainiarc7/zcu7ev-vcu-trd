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
This module formats the 11-bit line number value into two 10-bit words and 
inserts them into their proper places immediately after the EAV word. The
insert_ln input can disable the insertion of line numbers. The same line
number value is inserted into both video channels. 

In the SMPTE SDI standards, the 11-bit line numbers must be formatted into two
10-bit words with the format of each word as follows:

        b9    b8    b7    b6    b5    b4    b3    b2    b1    b0
     +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
LN0: | ~ln6| ln6 | ln5 | ln4 | ln3 | ln2 | ln1 | ln0 |  0  |  0  |
     +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
LN1: |  1  |  0  |  0  |  0  | ln10| ln9 | ln8 | ln7 |  0  |  0  |
     +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
      

This module is purely combinatorial and has no clocked registers.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_tx_v1_0_0_insert_ln (
input  wire             insert_ln,      // enables insertion of line numbers when high
input  wire             ln_word0,       // asserted during first word of line number
input  wire             ln_word1,       // asserted during second word of line number
input  wire [9:0]       c_in,           // C channel video input
input  wire [9:0]       y_in,           // Y channel video input
input  wire [10:0]      ln,             // 11-bit line number input
output reg  [9:0]       c_out,          // C channel video output
output reg  [9:0]       y_out           // Y channel video output
);

always @ (*)
    if (insert_ln & ln_word0)
        c_out = {~ln[6], ln[6:0], 2'b00};
    else if (insert_ln & ln_word1)
        c_out = {4'b1000, ln[10:7], 2'b00};
    else
        c_out = c_in;

always @ (*)
    if (insert_ln & ln_word0)
        y_out = {~ln[6], ln[6:0], 2'b00};
    else if (insert_ln & ln_word1)
        y_out = {4'b1000, ln[10:7], 2'b00};
    else
        y_out = y_in;

endmodule

