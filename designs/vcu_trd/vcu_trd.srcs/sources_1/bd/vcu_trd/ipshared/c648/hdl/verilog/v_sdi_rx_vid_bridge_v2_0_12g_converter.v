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

module v_sdi_rx_vid_bridge_v2_0_0_12g_converter #(
  parameter C_PPC = 4   // Pixels-per-clock: 1,2,4
) (
  input  wire                CLK_IN,
  input  wire                CLKEN_IN,
  input  wire                RST_IN,
  // Native Video Interface Inputs
  input  wire [80-1:0]       VID_DATA_IN,
  input  wire                VID_VALID_IN,
  input  wire                VID_HBLANK_IN,
  input  wire                VID_VBLANK_IN,
  // Native Video Interface Outputs
  output wire [20*C_PPC-1:0] VID_DATA_OUT,
  output wire                VID_VALID_OUT,
  output wire                VID_HBLANK_OUT,
  output wire                VID_VBLANK_OUT
);

  // Internal signals
  reg  [20*C_PPC-1:0]   clk_vid_data;
  reg                   clk_vid_valid;
  reg                   clk_vid_hblank;
  reg                   clk_vid_vblank;
  reg  [1:0]            clk_vid_strobe;

  reg                   clk_vid_first_sof;
  reg                   clk_vid_vblank_bp;
  wire                  clk_vid_vblank_fe;
  wire                  clk_vid_sol;
  wire                  clk_vid_sof;

  assign clk_vid_sol = (~clk_vid_valid & VID_VALID_IN) | (clk_vid_hblank & ~VID_HBLANK_IN);
  assign clk_vid_vblank_fe = (clk_vid_vblank & ~VID_VBLANK_IN);
  assign clk_vid_sof = clk_vid_vblank_bp & clk_vid_sol;

  // Register first SOF
  always @(posedge CLK_IN) begin
    if (RST_IN) begin
      clk_vid_vblank_bp <= 1'b0;
      clk_vid_first_sof <= 1'b0;
    end
    else if (CLKEN_IN) begin
      if (clk_vid_vblank_fe)
        clk_vid_vblank_bp <= 1'b1;
      else if (clk_vid_sol)
        clk_vid_vblank_bp <= 1'b0;

      if (clk_vid_sof)
        clk_vid_first_sof <= 1'b1;
    end
  end

  // Pixel rate down conversion 
  // Convert from 4 to 1/2/4 PPC
  // Mux select the output
  always @(posedge CLK_IN) begin
    if(RST_IN) begin
      clk_vid_data <= 'd0;
    end
    else if (CLKEN_IN) begin
      case (C_PPC) 
        4: clk_vid_data <= (VID_VALID_IN) ? VID_DATA_IN : 'd0;
        2: clk_vid_data <= (VID_VALID_IN) ? VID_DATA_IN[clk_vid_strobe*40 +: 40] : 'd0;
        1: clk_vid_data <= (VID_VALID_IN) ? VID_DATA_IN[clk_vid_strobe*20 +: 20] : 'd0;
      endcase
    end
  end

  // Register timing signals to video data
  always @(posedge CLK_IN) begin
    if (RST_IN) begin
      clk_vid_valid  <= 1'b0;
      clk_vid_hblank <= 1'b0;
      clk_vid_vblank <= 1'b0;
    end
    else if (CLKEN_IN) begin
      clk_vid_valid  <= VID_VALID_IN;
      clk_vid_hblank <= VID_HBLANK_IN;
      clk_vid_vblank <= VID_VBLANK_IN;
    end
  end

  // Generate strobe
  always @(posedge CLK_IN) begin
    if (RST_IN) begin
      clk_vid_strobe <= 'd0;
    end
    else if (CLKEN_IN) begin
      if (clk_vid_sof | clk_vid_first_sof) begin
        case (C_PPC)
          4: clk_vid_strobe <= 'b11;
          2: clk_vid_strobe <= clk_vid_strobe ^ 2'b01;
          1: clk_vid_strobe <= clk_vid_strobe + 1'b1;
        endcase
      end
    end
  end

  // Output assignments
  assign VID_DATA_OUT     = (clk_vid_first_sof) ? clk_vid_data   : 'd0;
  assign VID_VALID_OUT    = (clk_vid_first_sof) ? clk_vid_valid  : 'd0;
  assign VID_HBLANK_OUT   = (clk_vid_first_sof) ? clk_vid_hblank : 'd0;
  assign VID_VBLANK_OUT   = (clk_vid_first_sof) ? clk_vid_vblank : 'd0;

endmodule

`default_nettype wire
