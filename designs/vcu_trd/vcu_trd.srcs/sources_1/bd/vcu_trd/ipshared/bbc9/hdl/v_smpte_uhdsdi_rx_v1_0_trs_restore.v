// (c) Copyright 2014 - 2015 Xilinx, Inc. All rights reserved.
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

This module restores the LS 2 bits of 3FD and 002 values in the TRS and ADF
sequences to their full 3FF and 000 values. The trs input is delayed by the same
number of clock cycles as the data path, but is not modified in any other way.

--------------------------------------------------------------------------------
*/

`timescale 1ns / 1ns
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_rx_v1_0_0_trs_restore (
    input   wire        clk,            // input clock
    input   wire        ce,             // clock enable
    input   wire        trs_in,         // trs input signal 
    output  reg         trs_out,        // trs output signal
    input   wire [39:0] din,            // input value
    output  reg  [39:0] dout = 40'b0    // output register
);

reg [39:0]  in_reg = 40'b0;
reg         trs_reg = 1'b0;

function [9:0] restore10;
    input   [9:0] d;

    if (d[9:2] == 8'hff)
        restore10 = 10'h3FF;
    else if (d[9:2] == 8'h00)
        restore10 = 10'h000;
    else
        restore10 = d;
endfunction

always @ (posedge clk)
    if (ce)
    begin
        in_reg <= din;
        trs_reg <= trs_in;
    end

always @ (posedge clk)
    if (ce)
    begin
        dout[9:0]   <= restore10(in_reg[9:0]);
        dout[19:10] <= restore10(in_reg[19:10]);
        dout[29:20] <= restore10(in_reg[29:20]);
        dout[39:30] <= restore10(in_reg[39:30]);
        trs_out <= trs_reg;
    end

endmodule
