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

This module decodes EAV and SAV from the incoming Video Data.
It delays the video to by synchronous with EAV and SAV.
------------------------------------------------------------------------------
*/

`timescale 1ps/1ps

(* DowngradeIPIdentifiedWarnings="yes" *)
module v_sdi_rx_vid_bridge_v2_0_0_3g_trs_decode              
 (
  input             clk,
  input             rst,
  input             rx_ce_sd,        // clock enable for SD-SDI
  input             rx_dout_rdy,     // clock enable for 3G level B
  input      [1:0]  rx_mode,         // SDI mode from sync extractor
  input             rx_level_b,      // 3G level B flag
  input      [9:0]  rx_ds1a_in,      // SDI data stream 1a  
  input      [9:0]  rx_ds2a_in,      // SDI data stream 2a 
  input      [9:0]  rx_ds1b_in,      // SDI data stream 1b for 3G level B only 
  input      [9:0]  rx_ds2b_in,      // SDI data stream 2b for 3G level B only 
  
  output reg [9:0]  rx_ds1a_out,      // SDI data stream 1a  
  output reg [9:0]  rx_ds2a_out,      // SDI data stream 2a 
  output reg [9:0]  rx_ds1b_out,      // SDI data stream 1b for 3G level B only 
  output reg [9:0]  rx_ds2b_out,      // SDI data stream 2b for 3G level B only 
  output reg        eav_out,          // decoded End Active Video flag
  output reg        sav_out,          // decoded Start Active Video flag
  output reg        trs_out           // decoded Timing Reference Symbol flag  
);
  
reg      [9:0]    rx_ds1a_1;
reg      [9:0]    rx_ds2a_1;
reg      [9:0]    rx_ds1b_1;
reg      [9:0]    rx_ds2b_1;
reg      [9:0]    rx_ds1a_2;
reg      [9:0]    rx_ds2a_2;
reg      [9:0]    rx_ds1b_2;
reg      [9:0]    rx_ds2b_2;
reg      [9:0]    rx_ds1a_3;
reg      [9:0]    rx_ds2a_3;
reg      [9:0]    rx_ds1b_3;
reg      [9:0]    rx_ds2b_3;
reg      [2:0]    state;
reg      [2:0]    next_state;
reg               clock_enable;
reg               eav_2;
reg               sav_2;
reg               trs_2;
reg               eav_3;
reg               sav_3;
reg               trs_3;

//
// Select the proper clock enable
//
always @ (rx_mode or rx_level_b or rx_ce_sd or rx_dout_rdy) begin
  case (rx_mode)
    0:                // HD-SDI
      clock_enable = 1;
    1:           // SD-SDI
      clock_enable = rx_ce_sd;
    2:           // 3G-SDI
      if (rx_level_b)
      clock_enable = rx_dout_rdy;
    else
      clock_enable = 1;
    default:
      clock_enable = 1;
  endcase
end

//
// data delays
//
always @(posedge clk) begin
  if (clock_enable) begin
    rx_ds1a_1 <= rx_ds1a_in;
    rx_ds2a_1 <= rx_ds2a_in;
    rx_ds1b_1 <= rx_ds1b_in;
    rx_ds2b_1 <= rx_ds2b_in;
    rx_ds1a_2 <= rx_ds1a_1;
    rx_ds2a_2 <= rx_ds2a_1;
    rx_ds1b_2 <= rx_ds1b_1;
    rx_ds2b_2 <= rx_ds2b_1;
    rx_ds1a_3 <= rx_ds1a_2;
    rx_ds2a_3 <= rx_ds2a_2;
    rx_ds1b_3 <= rx_ds1b_2;
    rx_ds2b_3 <= rx_ds2b_2;
    rx_ds1a_out <= rx_ds1a_3;
    rx_ds2a_out <= rx_ds2a_3;
    rx_ds1b_out <= rx_ds1b_3;
    rx_ds2b_out <= rx_ds2b_3;
  end
end

//
// TRS logic and state machine
//

// Next  State Logic
always @ (rst or state or rx_ds1a_1) begin
   case (state)
     0: begin
       if (rx_ds1a_1 == 10'h3FF)
         next_state = 1;
       else
         next_state = 0;
     end
     1: begin
       if (rx_ds1a_1 == 10'h000)
         next_state = 2;
       else if(rx_ds1a_1 == 10'h3FF)
         next_state = 1;
       else
         next_state = 0;
     end
     2: begin
       if (rx_ds1a_1 == 10'h000)
         next_state = 3;
       else if(rx_ds1a_1 == 10'h3FF)
         next_state = 1;
       else
         next_state = 0;
     end
     3: begin
       next_state = 4;
     end
     4: begin
       next_state = 0;
     end
     default: begin
        next_state = 0;
     end
   endcase
end 


//  Output assignments
always @(posedge clk)
  if (rst) begin
    eav_2 <= 0;
    sav_2 <= 0;
    trs_2 <= 0;
    state <=0;
  end
  else if (clock_enable) begin
    state <= next_state;
    case (next_state)
      2: begin
        trs_2 <= 0;
        sav_2 <= 0;
        eav_2 <= 0;
      end
      3: begin
        trs_2 <= 1;
        sav_2 <= 0;
        eav_2 <= 0;
      end  
      4: begin
        trs_2 <= 1;
        if (rx_ds1a_1[6])begin
          eav_2 <= 1;
          sav_2 <= 0;
        end
        else begin
          eav_2 <= 0;
          sav_2 <= 1;
        end  
      end
      default: begin
        trs_2 <= 0;
        sav_2 <= 0;
        eav_2 <= 0;
      end
    endcase 

    trs_3 <= trs_2;
    sav_3 <= sav_2;
    eav_3 <= eav_2;
    trs_out <= (next_state == 3) | trs_2| trs_3; 
    sav_out <= sav_3;
    eav_out <= eav_3;
end


endmodule
