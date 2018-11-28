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
Module Description:

This module does an 18-bit CRC calculation.

The calculation is the SDI CRC18 calculation with a polynomial of 
x^18 + x^5 + x^4 + 1. The function considers the LSB of the video data as the 
first bit shifted into the CRC generator, although the implementation given here
is a fully parallel CRC, calculating all 18 CRC bits from the 10-bit video data
in one clock cycle.  

The clr input must be asserted coincident with the first input data word of
a new CRC calculation. The clr input forces the old CRC value stored in the
module's crc_reg to be discarded and a new calculation begins as if the old CRC
value had been cleared to zero.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_rx_v1_0_0_crc2 (
    input  wire         clk,    // clock input
    input  wire         ce,     // clock enable
    input  wire         en,     // 1 = enable CRC calculation
    input  wire         rst,    // sync reset input
    input  wire         clr,    // forces the old CRC value to zero to start new calculation
    input  wire [9:0]   d,      // input data word
    output wire [17:0]  crc_out // new calculated CRC value
);

//-----------------------------------------------------------------------------
// Signal definitions
//
wire                    x10;
wire                    x9;
wire                    x8;
wire                    x7;
wire                    x6;
wire                    x5;
wire                    x4;
wire                    x3;
wire                    x2;
wire                    x1;
wire    [17:0]          newcrc;     // input to CRC register            
wire    [17:0]          crc;        // output of crc_reg, unless clr is asserted
reg     [17:0]          crc_reg = 0;// internal CRC register


//
// The previous CRC value is represented by the variable crc. This value is
// combined with the new data word to form the new CRC value. Normally, crc is
// equal to the contents of the crc_reg. However, if the clr input is asserted,
// the crc value is cleared to all zeros.
//
assign crc = clr ? 0 : crc_reg;

//
// The x variables are intermediate terms used in the new CRC calculation.
//                             
assign x10 = d[9] ^ crc[9];
assign x9  = d[8] ^ crc[8];
assign x8  = d[7] ^ crc[7];
assign x7  = d[6] ^ crc[6];
assign x6  = d[5] ^ crc[5];
assign x5  = d[4] ^ crc[4];
assign x4  = d[3] ^ crc[3];
assign x3  = d[2] ^ crc[2];
assign x2  = d[1] ^ crc[1];
assign x1  = d[0] ^ crc[0];

//
// These assignments generate the new CRC value.
//
assign newcrc[0]  = crc[10];
assign newcrc[1]  = crc[11];
assign newcrc[2]  = crc[12];
assign newcrc[3]  = x1  ^ crc[13];
assign newcrc[4]  = x2  ^ x1 ^ crc[14];
assign newcrc[5]  = x3  ^ x2 ^ crc[15];
assign newcrc[6]  = x4  ^ x3 ^ crc[16];
assign newcrc[7]  = x5  ^ x4 ^ crc[17];
assign newcrc[8]  = x6  ^ x5 ^ x1;
assign newcrc[9]  = x7  ^ x6 ^ x2;
assign newcrc[10] = x8  ^ x7 ^ x3;
assign newcrc[11] = x9  ^ x8 ^ x4;
assign newcrc[12] = x10 ^ x9 ^ x5;
assign newcrc[13] = x10 ^ x6;
assign newcrc[14] = x7;
assign newcrc[15] = x8;
assign newcrc[16] = x9;
assign newcrc[17] = x10;

//
// This is the crc_reg. On each clock cycle when ce is asserted, it loads the
// newcrc value. The module's crc_out vector is always assigned to the contents
// of the crc_reg.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            crc_reg <= 0;
        else if (en)
            crc_reg <= newcrc;
    end

assign crc_out = crc_reg;

endmodule
