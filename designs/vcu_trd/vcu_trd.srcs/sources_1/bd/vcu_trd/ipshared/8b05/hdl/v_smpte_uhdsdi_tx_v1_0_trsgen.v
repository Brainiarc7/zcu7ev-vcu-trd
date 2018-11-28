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

This module generates the EAV and SAV timing signals required at the input of 
the SDI transmitter module. Up to four video data streams may pass through the
module. These data streams are delayed by the appropriate amount to match the
latency of the TRS generation logic.
*/
`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_tx_v1_0_0_trsgen
(
    input  wire         clk,        // sample rate clock
    input  wire         ce,         // clock enable input
    input  wire         din_rdy,    // data ready
    input  wire [9:0]   video,      // connect to video data stream
    output wire         eav,        // 1 during XYZ word of EAV
    output wire         sav         // 1 during XYZ word of SAV     
);

// Internal signals
reg     [1:0]           ones_reg = 2'b00;
reg                     zeros_reg = 1'b0;
wire                    zeros_in;
reg                     trs = 1'b0;

always @ (posedge clk)
    if (ce & din_rdy)
        ones_reg <= {ones_reg[0], &video};

assign zeros_in = ~|video;

always @ (posedge clk)
    if (ce & din_rdy)
        zeros_reg <= zeros_in;

always @ (posedge clk)
    if (ce & din_rdy)
        trs <= ones_reg[1] & zeros_reg & zeros_in;

assign eav = trs & video[6];
assign sav = trs & ~video[6];

endmodule
