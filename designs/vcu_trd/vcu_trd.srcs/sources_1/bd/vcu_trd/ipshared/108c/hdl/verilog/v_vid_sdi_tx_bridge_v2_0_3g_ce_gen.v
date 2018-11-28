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
//  This module generates clock enables for the video cores and the SDI TX
//
//-----------------------------------------------------------------------------

`timescale 1ps/1ps


`timescale 1 ps	/ 1ps

(* DowngradeIPIdentifiedWarnings="yes" *)
module v_vid_sdi_tx_bridge_v2_0_0_3g_ce_gen(
  input		          clk,
  input             rst,
  input     [1:0]   tx_mode,
  input          	  tx_level_b,

  output reg        y_mux_sel,
  output reg        tx_ce_sd,
  output reg        vid_ce,
  output reg        tx_din_rdy,
  output reg        output_ce           
);

reg        [3:0]  clock_count_sd;
reg               sd_ce;
reg               lev_b_ce;
reg               t_ff;
reg               vid_ce_comb;

///////////////////////////////////////
// video ce  select
///////////////////////////////////////
always @ (tx_mode or t_ff or sd_ce) begin
  case (tx_mode)
  2'b00:          //HD
    vid_ce_comb = 1;
  2'b01:		  //SD
    vid_ce_comb = sd_ce && t_ff;
  2'b10:   //3G
    vid_ce_comb = 1;
  2'b11:		  //Invalid
    vid_ce_comb = 1;
  default:
    vid_ce_comb = 1;
  endcase
end  

//////////////////////////////////////
// SD Clock Enable Generator
//////////////////////////////////////
always @ (posedge clk) begin
  if (rst) begin
    clock_count_sd <= 0;
    sd_ce <= 1;
    t_ff <= 0;
  end
  else begin
    if (clock_count_sd == 10)
      clock_count_sd <= 0;
    else
      clock_count_sd <= clock_count_sd +1;
   
    if (clock_count_sd == 0 || clock_count_sd ==5)
      sd_ce <= 1;
    else
      sd_ce <= 0;
  
    if (sd_ce) 
      t_ff <= !t_ff;
  end
end

//////////////////////////////////////
// 3G-Level B Clock Enable Generator
//////////////////////////////////////
always @(posedge clk) begin
  if (rst) 
    lev_b_ce <= 1;
  else 
    lev_b_ce <= !lev_b_ce;
end

//////////////////////////////////////
// output registers
//////////////////////////////////////
always @(posedge clk) begin
  if (rst) begin
    y_mux_sel  <= 0;
    tx_ce_sd   <= 1;
    vid_ce     <= 1'b1;
    tx_din_rdy <= 1;
    output_ce  <= 1;
  end
  else  begin
    y_mux_sel  <= t_ff;

    if (tx_mode == 1)
      tx_ce_sd   <= sd_ce;
    else
      tx_ce_sd   <= 1;

    if (tx_mode == 2  && tx_level_b )
      tx_din_rdy <=	lev_b_ce;
    else
      tx_din_rdy <= 1;

    vid_ce <= vid_ce_comb;

    if (tx_mode == 2  && tx_level_b )
      output_ce <= lev_b_ce;
    else if (tx_mode == 1)
      output_ce <= sd_ce;
    else
      output_ce <= 1;
  end
end

endmodule
