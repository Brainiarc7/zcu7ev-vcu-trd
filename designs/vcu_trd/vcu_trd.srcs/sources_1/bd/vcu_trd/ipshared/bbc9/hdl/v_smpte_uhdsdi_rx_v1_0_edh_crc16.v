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
This module does a 16-bit CRC calculation.

The calculation is a standard CRC16 calculation with a polynomial of x^16 + x^12
+ x^5 + 1. The function considers the LSB of the video data as the first bit
shifted into the CRC generator, although the implementation given here is a
fully parallel CRC, calculating all 16 CRC bits from the 10-bit video data in
one clock cycle.  

The assignment statements have all be optimized to use 4-input XOR gates
wherever possible to fit efficiently in the Xilinx FPGA architecture.

There are two input ports: c and d. The 16-bit c port must be connected to the
CRC "accumulation" register hold the last calculated CRC value. The 10-bit d
port is connected to the video stream.

The output port, crc, must be connected to the input of CRC "accumulation"
register.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_rx_v1_0_0_edh_crc16 (
    input  wire [15:0]      c,      // current CRC value
    input  wire [9:0]       d,      // input data word
    output wire [15:0]      crc     // new calculated CRC value
);

//-----------------------------------------------------------------------------
// Signal definitions
//
wire t1;  // intermediate product term used several times


assign t1 = d[4] ^ c[4] ^ d[0] ^ c[0];

assign crc[0]  = c[10] ^ crc[12];
assign crc[1]  = c[11] ^ d[0] ^ c[0] ^ crc[13];
assign crc[2]  = c[12] ^ d[1] ^ c[1] ^ crc[14];
assign crc[3]  = c[13] ^ d[2] ^ c[2] ^ crc[15];
assign crc[4]  = c[14] ^ d[3] ^ c[3];
assign crc[5]  = c[15] ^ t1;
assign crc[6]  = d[0] ^ c[0] ^ crc[11];
assign crc[7]  = d[1] ^ c[1] ^ crc[12];
assign crc[8]  = d[2] ^ c[2] ^ crc[13];
assign crc[9]  = d[3] ^ c[3] ^ crc[14];
assign crc[10] = t1 ^ crc[15];
assign crc[11] = d[5] ^ c[5] ^ d[1] ^ c[1];
assign crc[12] = d[6] ^ c[6] ^ d[2] ^ c[2];
assign crc[13] = d[7] ^ c[7] ^ d[3] ^ c[3];
assign crc[14] = d[8] ^ c[8] ^ t1;
assign crc[15] = d[9] ^ c[9] ^ crc[11];

endmodule
