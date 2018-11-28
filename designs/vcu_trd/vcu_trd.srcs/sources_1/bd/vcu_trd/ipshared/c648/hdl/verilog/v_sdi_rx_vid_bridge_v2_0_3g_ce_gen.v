//-----------------------------------------------------------------------------
//  (c) Copyright 2013 Xilinx, Inc. All rights reserved.
//
//  This file contains confidential and proprietary information
//  of Xilinx, Inc. and is protected under U.S. and
//  international copyright and other intellectual property
//  laws.
//
//  DISCLAIMER
//  This disclaimer is not a license and does not grant any
//  rights to the materials distributed herewith. Except as
//  otherwise provided in a valid license issued to you by
//  Xilinx, and to the maximum extent permitted by applicable
//  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
//  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
//  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
//  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
//  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
//  (2) Xilinx shall not be liable (whether in contract or tort,
//  including negligence, or under any other theory of
//  liability) for any loss or damage of any kind or nature
//  related to, arising under or in connection with these
//  materials, including for any direct, or any indirect,
//  special, incidental, or consequential loss or damage
//  (including loss of data, profits, goodwill, or any type of
//  loss or damage suffered as a result of any action brought
//  by a third party) even if such damage or loss was
//  reasonably foreseeable or Xilinx had been advised of the
//  possibility of the same.
//
//  CRITICAL APPLICATIONS
//  Xilinx products are not designed or intended to be fail-
//  safe, or for use in any application requiring fail-safe
//  performance, such as life-support or safety devices or
//  systems, Class III medical devices, nuclear facilities,
//  applications related to the deployment of airbags, or any
//  other applications that could lead to death, personal
//  injury, or severe property or environmental damage
//  (individually and collectively, "Critical
//  Applications"). Customer assumes the sole risk and
//  liability of any use of Xilinx products in Critical
//  Applications, subject only to applicable laws and
//  regulations governing limitations on product liability.
//
//  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
//  PART OF THIS FILE AT ALL TIMES. 
//
//----------------------------------------------------------
/*
Module Description:

This module selects the video clock enable based on the rx_mode.
  For SD-SDI:          rx_ce_sd
  For 3G-SDI Level B:  rx_dout_rdy
  For all other mode:  always High

For timing purposes, the selected clock enable is registered for output from
the core.  
Both the combinatorial and registered versions are required internally. 
When data is transfered from the combinatorial CE domain to the registered CE
domain, a "stutter step" state may occur.  This is accounted for in the modules
where it occurs.
------------------------------------------------------------------------------
*/

`timescale 1ps/1ps

(* DowngradeIPIdentifiedWarnings="yes" *)
module v_sdi_rx_vid_bridge_v2_0_0_3g_ce_gen
(
  input             clk,
  input             rst,
  input       [1:0] rx_mode,   // SDI mode 
  input      rx_level_b,   // 3G level B flag
  input             rx_dout_rdy,  // clock enable for 3G level B
  input             rx_ce_sd,   // clock enable for SD-SDI
  input             vreg_sel,   //  1/2 input rate timing signal


  output reg        vid_ce_comb,  // selected clock enable for internal use
  output reg        vid_ce    // clock enable for output video 
);

always @(rx_mode or rx_level_b or rx_ce_sd or rx_dout_rdy or vreg_sel)   begin
  case (rx_mode) 
    0:                       // HD
      vid_ce_comb = 1;
    1:                       // SD
      vid_ce_comb = rx_ce_sd & vreg_sel;
    2:                       // 3G
      vid_ce_comb = 1;
    3:                      // Invalid
     vid_ce_comb = 1;
    default:
     vid_ce_comb = 1;
  endcase
end 

always @(posedge clk) begin
  vid_ce <= vid_ce_comb;
end
     
endmodule
