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
This formats the 18-bit CRC values for each channel into two 10-bit video words
and inserts them into the appropriate places immediately after the line number
words in the EAV.

An 18-bit CRC value is formatted into two 10-bit words that are inserted after
the EAV and line number words. The format of the CRC words is shown below:
 
         b9     b8     b7     b6     b5     b4     b3     b2     b1     b0
      +------+------+------+------+------+------+------+------+------+------+
CRC0: |~crc8 | crc8 | crc7 | crc6 | crc5 | crc4 | crc3 | crc2 | crc1 | crc0 |
      +------+------+------+------+------+------+------+------+------+------+
CRC1: |~crc17| crc16| crc15| crc14| crc13| crc12| crc11| crc10| crc9 | crc8 |
      +------+------+------+------+------+------+------+------+------+------+

This module is purely combinatorial and contains no clocked registers.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_tx_v1_0_0_insert_crc (
    input  wire         insert_crc, // CRC values will be inserted when this input is high
    input  wire         crc_word0,  // input asserted during time for first CRC word in EAV 
    input  wire         crc_word1,  // input asserted during time for second CRC word in EAV
    input  wire [9:0]   c_in,       // C channel video input
    input  wire [9:0]   y_in,       // Y channel video input
    input  wire [17:0]  c_crc,      // C channel CRC value input
    input  wire [17:0]  y_crc,      // Y channel CRC value input
    output reg  [9:0]   c_out,      // C channel video output
    output reg  [9:0]   y_out       // Y channel video output
);

always @ (*)
    if (insert_crc & crc_word0)
        c_out = {~c_crc[8], c_crc[8:0]};
    else if (insert_crc & crc_word1)
        c_out = {~c_crc[17], c_crc[17:9]};
    else
        c_out = c_in;

always @ (*)
    if (insert_crc & crc_word0)
        y_out = {~y_crc[8], y_crc[8:0]};
    else if (insert_crc & crc_word1)
        y_out = {~y_crc[17], y_crc[17:9]};
    else
        y_out = y_in;

endmodule
