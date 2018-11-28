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

This module implements the sync bit insertion algorithm required for 6G-SDI and
12G-SDI. Except for a core 3FF 000 000 sequence, all instances of 3FF are
replaced with 3FD and 000 replaced with 002.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_tx_v1_0_0_syncbit_insert (
    input   wire        clk,        // input clock
    input   wire        enable,     // 1 enables the sync bit insert function
    input   wire [39:0] din,
    output  reg  [39:0] dout = 40'b0
);

//
// Signal definitions
//
reg     [39:0]      pipe0 = 40'b0;
reg     [39:0]      pipe1 = 40'b0;
reg     [39:0]      pipe2 = 40'b0;
reg                 all_ones = 1'b0;
wire                all_zeros;
reg                 core_trs_1s = 1'b0;
reg                 core_trs_0s = 1'b0;
wire                enable3;
wire                enable2;
wire                enable1;
wire    [39:0]      replace_out;
reg                 en_reg = 1'b0;

function   [9:0] replace;
    input  [9:0] din;
    input        enable;
begin
    if (enable)
    begin
        if (din == 10'h3ff)
            replace = 10'h3fd;
        else if (din == 10'h000)
            replace = 10'h002;
        else
            replace = din;
    end else
        replace = din;
end
endfunction

assign all_zeros = ~|pipe0;
assign enable3 = en_reg & ~core_trs_1s;
assign enable2 = en_reg;
assign enable1 = en_reg & ~core_trs_0s;
assign replace_out = {replace(pipe2[39:30], enable3), replace(pipe2[29:20], enable2), 
                      replace(pipe2[19:10], enable1), replace(pipe2[9:0], enable1)};

always @ (posedge clk)
begin
    en_reg <= enable;
    pipe0 <= din;
    pipe1 <= pipe0;
    pipe2 <= pipe1;
    all_ones <= &pipe0;
    core_trs_1s <= all_ones & all_zeros;
    core_trs_0s <= core_trs_1s;
    dout <= replace_out;
end

endmodule
