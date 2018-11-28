//-----------------------------------------------------------------------------
//  (c) Copyright 2016 Xilinx, Inc. All rights reserved.
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

`timescale 1ps/1ps
`default_nettype none

module v_sdi_rx_vid_bridge_v2_0_0_12g_ce_gen #(
  parameter C_VID_DUTY_CYCLE = 1, // 0-full duty cycle, 1-half duty cycle, 3-quarter duty cycle
  parameter C_SDI_DUTY_CYCLE = 1  // 0-full duty cycle, 1-half duty cycle, 3-quarter duty cycle
) (
  input  wire  CLK_IN,
  input  wire  RST_IN,
  output wire  VID_CLKEN_OUT,
  output wire  SDI_CLKEN_OUT
);

  // Internal signals
  reg [1:0] clk_vid_clken_cnt = 'd0;
  reg [1:0] clk_sdi_clken_cnt = 'd0;
  reg       clk_vid_clken     = 'd0;
  reg       clk_sdi_clken     = 'd0;

  // Generate vid clken
  always @(posedge CLK_IN) begin
    if (RST_IN) begin
      clk_vid_clken_cnt <= 'd0;
    end
    else begin
      if (clk_vid_clken_cnt == C_VID_DUTY_CYCLE) begin
        clk_vid_clken_cnt <= 'd0;
        clk_vid_clken <= 1'b1;
      end
      else begin
        clk_vid_clken_cnt <= clk_vid_clken_cnt + 1'b1;
        clk_vid_clken <= 1'b0;
      end
    end
  end

  // Generate sdi clken
  always @(posedge CLK_IN) begin
    if (RST_IN) begin
      clk_sdi_clken_cnt <= 'd0;
    end
    else begin
      if (clk_sdi_clken_cnt == C_SDI_DUTY_CYCLE) begin
        clk_sdi_clken_cnt <= 'd0;
        clk_sdi_clken <= 1'b1;
      end
      else begin
        clk_sdi_clken_cnt <= clk_sdi_clken_cnt + 1'b1;
        clk_sdi_clken <= 1'b0;
      end
    end
  end

  // Output assignments
  assign VID_CLKEN_OUT = clk_vid_clken;
  assign SDI_CLKEN_OUT = clk_sdi_clken;

endmodule

`default_nettype wire
