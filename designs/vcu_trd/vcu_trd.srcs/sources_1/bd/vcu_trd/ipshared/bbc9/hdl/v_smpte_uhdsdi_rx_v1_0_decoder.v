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
//------------------------------------------------------------------------------
/*
Module Description:

This is a multi-rate SDI decoder supporting all SDI rates from SD to 12G.

In SDI the serial bit stream is encoded in two ways. First, a generator 
polynomial of x^9 + x^4 + 1 is used to generate a scrambled NRZ bit sequence. 
Next, a generator polynomial of x + 1 is used to produce the final polarity free
NRZI sequence which is transmitted over the physical layer.

The decoder module described in this file sits at the receiving end of the
SDI link and reverses the two encoding steps to extract the original data. 
First, the x + 1 generator polynomial is used to convert the bit stream from 
NRZI to NRZ. Next, the x^9 + x^4 + 1 generator polynomial is used to descramble 
the data.

This decoder supports 10-bit mode for SD-SDI, 20-bit mode for HD-SDI and 3G-SDI,
and 40-bit mode for 6G-SDI and 12G-SDI. When running in 3G-SDI and HD-SDI modes,
20 bits are decoded every clock cycle. When running in 6G-SDI and 12G-SDI modes,
40 bits are decoded every clock cycle. When running in SD-SDI mode, the 10-bit 
SD-SDI data must be placed on the bits [19:10] of the d port and ten bits are 
decoded every clock cycle. 

The module does accept a width parameter, but this can only be set to 20 or 40.
This parameter specifies the maximum width of the decoder data path. The active
width of the decoder is dynamically set based on the mode port. If the WIDTH
parameter is set to 20, the decoder cannot support 6G-SDI and 12G-SDI modes.

--------------------------------------------------------------------------------
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_rx_v1_0_0_decoder #(
    parameter WIDTH = 40)               // Bit width of the decoder path, set to 20 or 40
(
    input  wire                 clk,    // word-rate clock
    input  wire                 ce,     // clock enable
    input  wire [2:0]           mode,   // 000=HD, 001=SD, 010=3G, 100=6G, 101 or 110=12G
    input  wire [WIDTH-1:0]     din,    // input data (SD on bits [19:10])
    output wire [WIDTH-1:0]     dout    // output data (SD on bits [19:10])
);

//
// Signal defintions
//
reg     [2:0]       mode_reg = 3'b000;  // SDI mode input register
wire                b10;                // 1 when running in 10 bit mode
wire                b40;                // 1 when running in 40 bit mode
reg     [WIDTH-1:0] din_reg = 0;        // input data register
reg                 prev_msb = 1'b0;    // previous msb of input vector stored for use with next input vector
wire    [WIDTH-1:0] nrz;                // output of the NRZI-to-NRZ converter
wire    [WIDTH-1:0] nrz_in;             // input to NRZI-to-NRZ converter
reg     [8:0]       prev_nrz = 9'b0;    // holds 9 MSBs from NRZI-to-NRZ for use in next clock cycle
wire    [WIDTH+8:0] desc_wide;          // concat of two input words used by descrambler
reg     [WIDTH-1:0] out_reg = 0;        // output register
integer             i;                  // for loop variable


//
// input registers
//
always @ (posedge clk)
    if (ce)
    begin
        mode_reg <= mode;
        din_reg <= din;
    end

generate 
if (WIDTH == 40)
begin
assign b40 = mode_reg == 3'b100 || mode_reg == 3'b101 || mode == 3'b110;
end
endgenerate
assign b10 = mode_reg == 3'b001;

//
// prev_msb register
//
// This register holds the MSB of the previous clock period's din_reg so
// that a it is available to be XORed to the LSB of the next input word.
// 
generate
if(WIDTH == 40)
begin
always @ (posedge clk)
    if (ce)
    begin
        if (b40)
            prev_msb <= din_reg[WIDTH-1];
        else
            prev_msb <= din_reg[19];
    end
end
else
begin
always @ (posedge clk)
    if (ce)
    begin
        prev_msb <= din_reg[19];
    end
end
endgenerate

//
// NRZI-to-NRZ converter
//
// This function XORs each bit with the bit that preceded it in the serial
// bitstream. 
//
assign nrz_in = {din_reg[WIDTH-2:10], b10 ? prev_msb : din_reg[9], din_reg[8:0], prev_msb};
assign nrz = din_reg ^ nrz_in;

//
// prev_nrz input register of the descrambler
//
// This register is a pipeline delay register which loads from the output of the
// NRZI-to-NRZ converter. It only holds the nine active MSBs from the converter
// which get combined with bits coming from the converter on the next clock 
// cycle to form the input vector to the descrambler.
//

generate
if(WIDTH == 40)
begin
always @ (posedge clk)
    if (ce)
        prev_nrz <= b40 ? nrz[WIDTH-1:WIDTH-9] : nrz[19:11];
end
else
begin
always @ (posedge clk)
    if (ce)
        prev_nrz <= nrz[19:11];
end
endgenerate

//
// The desc_wide vector is the input to the descrambler below. It is the output
// of the NRZI-to-NRZ conversion concatenated with the prev_nrz value. The
// prev_nrz value is inserted into bits 9:1 in SD-SDI mode.
//
assign desc_wide = {nrz[WIDTH-1:10], b10 ? prev_nrz : nrz[9:1], nrz[0], prev_nrz};

// 
// Descrambler
//
// A for loop is used to generate the HD-SDI x^9 + x^4 + 1 polynomial for 
// each of the output bits using the desc_wide input vector that is made up of 
// the contents of the prev_nrz register and the output of the NRZI-to-NRZ 
// converter.
//
always @ (posedge clk)
    if (ce)
        for (i = 0; i < WIDTH; i = i + 1)
            out_reg[i] <= desc_wide[i] ^ desc_wide[i + 4] ^ desc_wide[i + 9];

assign dout = out_reg;

endmodule
