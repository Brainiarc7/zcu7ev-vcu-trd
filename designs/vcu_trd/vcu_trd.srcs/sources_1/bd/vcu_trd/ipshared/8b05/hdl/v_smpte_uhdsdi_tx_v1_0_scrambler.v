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

This module performs the SMPTE scrambling and NRZ-to-NRZI conversion algorithms
on 10-bit video words. It is designed to support both SDI (SMPTE 259M) and
HD-SDI (SMPTE 292M) standards.

When scrambling HD-SDI video, two of these modules can be used to encode the
two video channels Y and C. Each module would run at the word rate (74.25 MHz)
and accept one video in and generate one scrambled data word out per clock cycle.
It is also possible to use just one of these modules to scramble both data
channels by running the module a 2X the video rate.

When encoding SD-SDI video, one module is used and data is scramble one word
per clock cycle.

The module has two clock cycles of latency. It accepts one 10-bit word every
clock cycle and also produces 10-bits of scrambled data every clock cycle.

One clock cycle is used to scramble the data using the SMPTE X^9 + X^4 + 1
polynomial. During the second clock cycles, the scrambled data is converted to
NRZI data using the X + 1 polynomial.

Both the scrambling and NRZ-to-NRZI conversion have separate enable inputs. The
scram input enables scrambling when High. The nrzi input enables NRZ-to-NRZI
conversion when high.

The p_scram input vector provides 9 bits of data that was scrambled by the
during the previous clock cycle or by the other channel's scrambler module.  
When implementing a HD-SDI scrambler, the p_scram input of the C scrambler 
module  must be connected to the i_scram_q output of the Y module and the 
p_scram input  of the Y scrambler module must be connected to the i_scram 
output of the C  module. For SD-SDI or for HD-SDI when running this module at 2X
the HD-SDI word rate, the p_scram input must be connected to the i_scram_q
output of this same  module.

The p_nrzi input provides one bit of data that was converted to NRZI by the
companion hdsdi_scram_lower module. When implementing a HD-SDI scrambler, the 
p_nrzi input of the C scrambler module must be connected to the q[9] bit from 
the Y module and the p_nrzi input of the Y scrambler module must be connected to
the i_nrzi output of the C module. For SD-SDI or for HD-SDI when running this
module at 2X the HD-SDI word rate, the p_nrzi input must be connected to the 
q[9] output bit of this same module.

--------------------------------------------------------------------------------
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_tx_v1_0_0_scrambler (
    input  wire         clk,        // input clock (bit-rate)
    input  wire         ce,         // clock enable
    input  wire         nrzi,       // enables NRZ-to-NRZI conversion when high
    input  wire         scram,      // enables SDI scrambler when high
    input  wire [9:0]   d,          // input data
    input  wire [8:0]   p_scram,    // previously scrambled data input 
    input  wire         p_nrzi,     // MSB of previously converted NRZI word
    output wire [9:0]   q,          // output data
    output wire [8:0]   i_scram,    // intermediate scrambled data output
    output wire [8:0]   i_scram_q,  // registered intermediate scrambled data output
    output wire         i_nrzi      // intermediate nrzi data output
);

//
// Signal definitions
//
reg     [9:0]       scram_reg = 0;  // pipeline delay register
reg     [9:0]       out_reg = 0;    // output register
wire    [13:0]      scram_in;       // input to the scrambler
reg     [9:0]       scram_temp;     // intermediate output of the scrambler
wire    [9:0]       scram_out;      // output of the scrambler
wire    [9:0]       nrzi_out;       // output of NRZ-to-NRZI converter
reg     [9:0]       nrzi_temp;      // intermediate output of the NRZ-to-NRZI converter
integer             i, j;           // for loop variables

//
// Scrambler
//
// This block of logic implements the SDI scrambler algorithm. The scrambler
// uses the 10 incoming bits from the input port and a 14-bit vector called 
// scram_in. scram_in is made up of 9 bits that were scrambled in the previous 
// clock cycle (p_scram) and the 5 LS scrambled bits that have been generated 
// during the current clock cycle. The results of the scrambler are assigned to 
// scram_temp.
//
// A MUX will output either the value of scram_temp or the d input word
// depending on the scram enable input. The output of the MUX is stored in the
// scram_reg.
//
assign scram_in = {scram_temp[4:0], p_scram[8:0]};

always @ (*)
    for (i = 0; i < 10; i = i + 1)
        scram_temp[i] <= d[i] ^ scram_in[i] ^ scram_in[i + 4];

assign scram_out = scram ? scram_temp : d;

always @ (posedge clk)
    if (ce)
        scram_reg <= scram_out;

//
// NRZ-to-NRZI converter
//
// This block of logic implements the NRZ-to-NRZI conversion. It operates on the
// 10 bits coming from the scram_reg and the MSB from the output of the NRZ-to
// NRZI conversion done on the previous word (p_nrzi).. A MUX bypasses the 
// conversion process if the nrzi input is low.
//
always @ (*)
    begin
        nrzi_temp[0] <= p_nrzi ^ scram_reg[0];
        for (j = 1; j < 10; j = j + 1)
            nrzi_temp[j] <= nrzi_out[j - 1] ^ scram_reg[j];
    end

assign nrzi_out = nrzi ? nrzi_temp : scram_reg;

//
// out_reg: Output register
//
always @ (posedge clk)
    if (ce)
        out_reg <= nrzi_out;

//
// output assignments
//
assign q = out_reg;
assign i_scram = scram_temp[9:1];
assign i_scram_q = scram_reg[9:1];
assign i_nrzi = nrzi_temp[9];

endmodule
