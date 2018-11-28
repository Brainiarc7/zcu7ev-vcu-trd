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

This module implements the various multiplexing modes for the SDI transmitter.
Five different multiplexing patterns are supported. The pattern used is selected
by the pattern input port.

Pattern 000: SD-SDI, HD-SDI, and 3G-SDI level A
Pattern 001: 3G-SDI level B 
Pattern 010: 6G-SDI SL mode 1, 6G-SDI QL mode 1, 12G-SDI SL mode 1 & 2, 12G-SDI DL mode 2 & 3
Pattern 011: 6G-SDI SL modes 2 & 3, 6G-SDI DL modes 1 & 2, 6G-SDI QL modes 2 & 3
Pattern 100: 12G-SDI DL mode 1

Pattern 000 requires ce to be asserted all of the time. ds1 passes straight through
to output bits [19:10] and ds2 passes through to output bits [9:0].

Pattern 001 requires ce to be asserted with a 50% duty cycle. When ce is low,
{ds2, ds4} is output. When ce is high, {ds1, ds3} is output.

Pattern 010 requires ce to be asserted with a 50% duty cycle. When ce is low,
{ds2, ds6, ds4, ds8} is output. When ce is high, {ds1, ds5, ds3, ds7} is output.

Pattern 011 requires ce to be asserted all of the time. The output is
{ds1, ds3, ds2, ds4}.

Pattern 100 requires ce to be asserted 25% of the time. After the rising edge
of the clock in which ce is asserted, the output will be {ds4, ds12, ds8, ds16}.
The next clock cycle the output will be {ds2, ds10, ds6, ds14}. The next clock
cycle the output will be {ds3, ds11, ds7, ds15}. And in the fourth and final
clock cycle, the output is {ds1, ds9, ds5, ds13}.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_tx_v1_0_0_mux #(
    parameter C_LINE_RATE = 0
    )
(
input   wire        clk,        // input clock
input   wire        ce,         // input register load signal
input   wire [2:0]  pattern,    // select the multiplex pattern
input   wire [9:0]  ds1,
input   wire [9:0]  ds2,
input   wire [9:0]  ds3,
input   wire [9:0]  ds4,
input   wire [9:0]  ds5,
input   wire [9:0]  ds6,
input   wire [9:0]  ds7,
input   wire [9:0]  ds8,
input   wire [9:0]  ds9,
input   wire [9:0]  ds10,
input   wire [9:0]  ds11,
input   wire [9:0]  ds12,
input   wire [9:0]  ds13,
input   wire [9:0]  ds14,
input   wire [9:0]  ds15,
input   wire [9:0]  ds16,
output  reg  [39:0] dout = 40'b0

);

//
// Signal definitions
//
reg     [2:0]       pat_reg = 3'b000;
reg     [3:0]       seqnce = 4'b0000;
reg     [39:0]      mux_out;

always @ (posedge clk)
    if (ce)
        pat_reg <= pattern;

//
// Generate the mux control pattern based on the pat_reg value and the assertion
// of ce.
//
generate 
    if(C_LINE_RATE == 0)
    begin
     always @ (posedge clk)
         if (pat_reg == 3'b000 || pat_reg == 3'b011)
             seqnce <= 4'b1111;
         else if ((pat_reg == 3'b001 || pat_reg == 3'b010) & ce)
             seqnce <= 4'b0101;
         else if ((pat_reg == 3'b100) & ce)
             seqnce <= 4'b0001;
         else
             seqnce <= {seqnce[2:0], seqnce[3]};
     
     //
     // Mux logic
     //
     always @ (*)
         case(pat_reg)
             3'b001:     mux_out = seqnce[1] ? {20'b0, ds1, ds3} : {20'b0, ds2, ds4};
             3'b010:     mux_out = seqnce[3] ? {ds1, ds5, ds3, ds7} : {ds2, ds6, ds4, ds8};
             3'b011:     mux_out = {ds1, ds3, ds2, ds4};
             3'b100:     mux_out = seqnce[0] ? {ds4, ds12, ds8, ds16} : 
                                   seqnce[1] ? {ds2, ds10, ds6, ds14} :
                                   seqnce[2] ? {ds3, ds11, ds7, ds15} :
                                                 {ds1, ds9,  ds5, ds13};
             default:    mux_out = {20'b0, ds1, ds2};
         endcase
    end
    else
    begin
     always @ (posedge clk)
         if (~pat_reg[0])
             seqnce <= 4'b1111;
         else if (pat_reg[0] & ce)
             seqnce <= 4'b0101;
         else
             seqnce <= {seqnce[2:0], seqnce[3]};
     
     //
     // Mux logic
     //
     always @ (*)
         case(pat_reg)
             3'b001:     mux_out = seqnce[1] ? {20'b0, ds1, ds3} : {20'b0, ds2, ds4};
             default:    mux_out = {20'b0, ds1, ds2};
         endcase
    end
endgenerate
//
// Output register
//
always @ (posedge clk)
    dout <= mux_out;

endmodule
