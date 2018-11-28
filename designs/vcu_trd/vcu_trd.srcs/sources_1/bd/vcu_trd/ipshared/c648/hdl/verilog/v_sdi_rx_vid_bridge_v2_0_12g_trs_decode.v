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

module v_sdi_rx_vid_bridge_v2_0_0_12g_trs_decode (
  input  wire            CLK_IN,
  input  wire            CLKEN_IN,
  input  wire            RST_IN,
  // SDI Virtual Interface
  input  wire [10-1:0]   SDI_DS1_IN,
  input  wire [10-1:0]   SDI_DS2_IN,
  input  wire [10-1:0]   SDI_DS3_IN, 
  input  wire [10-1:0]   SDI_DS4_IN,
  input  wire [10-1:0]   SDI_DS5_IN,
  input  wire [10-1:0]   SDI_DS6_IN,
  input  wire [10-1:0]   SDI_DS7_IN,
  input  wire [10-1:0]   SDI_DS8_IN,
  // SDI Sub-Image Interface
  output wire [20-1:0]   SDI_SUBIMG1_OUT,  // Even line, even pixel pairs
  output wire [20-1:0]   SDI_SUBIMG2_OUT,  // Even line, odd pixel pairs
  output wire [20-1:0]   SDI_SUBIMG3_OUT,  // Odd line, even pixel pairs
  output wire [20-1:0]   SDI_SUBIMG4_OUT,  // Odd line, odd pixel pairs
  output wire            SDI_VALID_OUT,
  output wire            SDI_HBLANK_OUT,
  output wire            SDI_VBLANK_OUT,
  output wire [16-1:0]   SDI_HTOTAL_OUT,   // Htotal size
  output wire            SDI_FLAG_OUT      // Flag indicates half line
);

  localparam [4-1:0]
    C_START_W0   = 0, 
    C_START_W1   = 1, 
    C_START_W2   = 2, 
    C_START_XYZ  = 3;
  localparam [10-1:0]
    C_F0_SAV        = 10'h200,
    C_F0_EAV        = 10'h274,
    C_F0_SAV_VBLANK = 10'h2AC,
    C_F0_EAV_VBLANK = 10'h2D8;

  // Internal signals
  reg [20-1:0]   clk_sdi_subimg1_dly1;
  reg [20-1:0]   clk_sdi_subimg1_dly2;
  reg [20-1:0]   clk_sdi_subimg1_dly3;
  reg [20-1:0]   clk_sdi_subimg1_dly4;
  reg [20-1:0]   clk_sdi_subimg1_dly5;
  reg [20-1:0]   clk_sdi_subimg2_dly1;
  reg [20-1:0]   clk_sdi_subimg2_dly2;
  reg [20-1:0]   clk_sdi_subimg2_dly3;
  reg [20-1:0]   clk_sdi_subimg2_dly4;
  reg [20-1:0]   clk_sdi_subimg2_dly5;
  reg [20-1:0]   clk_sdi_subimg3_dly1;
  reg [20-1:0]   clk_sdi_subimg3_dly2;
  reg [20-1:0]   clk_sdi_subimg3_dly3;
  reg [20-1:0]   clk_sdi_subimg3_dly4;
  reg [20-1:0]   clk_sdi_subimg3_dly5;
  reg [20-1:0]   clk_sdi_subimg4_dly1;
  reg [20-1:0]   clk_sdi_subimg4_dly2;
  reg [20-1:0]   clk_sdi_subimg4_dly3;
  reg [20-1:0]   clk_sdi_subimg4_dly4;
  reg [20-1:0]   clk_sdi_subimg4_dly5;
  reg            clk_sdi_eav;
  reg            clk_sdi_sav;
  reg            clk_sdi_sav_dly1;
  reg            clk_sdi_sav_dly2;
  reg            clk_sdi_sav_dly3;
  reg            clk_sdi_sav_dly4;
  reg            clk_sdi_hblank;
  reg            clk_sdi_hblank_re;
  reg            clk_sdi_hblank_fe;
  reg            clk_sdi_vblank;
  reg            clk_sdi_vblank_dly1;
  reg [16-1:0]   clk_sdi_htotal_cnt;
  reg [16-1:0]   clk_sdi_htotal_size;
  reg            clk_sdi_htotal_lock;
  reg [2-1:0]    clk_state;
  reg [2-1:0]    clk_next;

  // Delay Sub-Image Data Streams
  always @(posedge CLK_IN) begin
    if (RST_IN) begin
      clk_sdi_subimg1_dly1  <= 'b0;  
      clk_sdi_subimg1_dly2  <= 'b0;
      clk_sdi_subimg1_dly3  <= 'b0;
      clk_sdi_subimg1_dly4  <= 'b0;
      clk_sdi_subimg2_dly1  <= 'b0;
      clk_sdi_subimg2_dly2  <= 'b0;
      clk_sdi_subimg2_dly3  <= 'b0;
      clk_sdi_subimg2_dly4  <= 'b0;
      clk_sdi_subimg3_dly1  <= 'b0;
      clk_sdi_subimg3_dly2  <= 'b0;
      clk_sdi_subimg3_dly3  <= 'b0;
      clk_sdi_subimg3_dly4  <= 'b0;
      clk_sdi_subimg4_dly1  <= 'b0;
      clk_sdi_subimg4_dly2  <= 'b0;
      clk_sdi_subimg4_dly3  <= 'b0;
      clk_sdi_subimg4_dly4  <= 'b0;
      clk_sdi_sav_dly1    <= 'b0;
      clk_sdi_sav_dly2    <= 'b0;
      clk_sdi_sav_dly3    <= 'b0;
      clk_sdi_sav_dly4    <= 'b0;
    end
    else if (CLKEN_IN) begin
      clk_sdi_subimg1_dly1  <= {SDI_DS2_IN,SDI_DS1_IN};
      clk_sdi_subimg1_dly2  <= clk_sdi_subimg1_dly1;
      clk_sdi_subimg1_dly3  <= clk_sdi_subimg1_dly2;
      clk_sdi_subimg1_dly4  <= clk_sdi_subimg1_dly3;
      clk_sdi_subimg2_dly1  <= {SDI_DS4_IN,SDI_DS3_IN};
      clk_sdi_subimg2_dly2  <= clk_sdi_subimg2_dly1;
      clk_sdi_subimg2_dly3  <= clk_sdi_subimg2_dly2;
      clk_sdi_subimg2_dly4  <= clk_sdi_subimg2_dly3;
      clk_sdi_subimg3_dly1  <= {SDI_DS6_IN,SDI_DS5_IN};
      clk_sdi_subimg3_dly2  <= clk_sdi_subimg3_dly1;
      clk_sdi_subimg3_dly3  <= clk_sdi_subimg3_dly2;
      clk_sdi_subimg3_dly4  <= clk_sdi_subimg3_dly3;
      clk_sdi_subimg4_dly1  <= {SDI_DS8_IN,SDI_DS7_IN};
      clk_sdi_subimg4_dly2  <= clk_sdi_subimg4_dly1;
      clk_sdi_subimg4_dly3  <= clk_sdi_subimg4_dly2;
      clk_sdi_subimg4_dly4  <= clk_sdi_subimg4_dly3;
      clk_sdi_sav_dly1    <= clk_sdi_sav;
      clk_sdi_sav_dly2    <= clk_sdi_sav_dly1;
      clk_sdi_sav_dly3    <= clk_sdi_sav_dly2;
      clk_sdi_sav_dly4    <= clk_sdi_sav_dly3;
    end
  end

  // Final Output Delay
  always @(posedge CLK_IN) begin
    if (RST_IN) begin
      clk_sdi_subimg1_dly5 <= 'b0;    
      clk_sdi_subimg2_dly5 <= 'b0;    
      clk_sdi_subimg3_dly5 <= 'b0;    
      clk_sdi_subimg4_dly5 <= 'b0;    
      clk_sdi_vblank_dly1 <= 'b0;
    end 
    else if (CLKEN_IN) begin
      clk_sdi_subimg1_dly5  <= clk_sdi_subimg1_dly4;
      clk_sdi_subimg2_dly5  <= clk_sdi_subimg2_dly4;
      clk_sdi_subimg3_dly5  <= clk_sdi_subimg3_dly4;
      clk_sdi_subimg4_dly5  <= clk_sdi_subimg4_dly4;
      clk_sdi_vblank_dly1 <= clk_sdi_vblank;
    end
  end

  // Next State
  // Pattern Detection
  always @(*) begin
    case (clk_state)
      C_START_W0:
        clk_next = (CLKEN_IN & SDI_DS1_IN == 10'h3FF) ? (C_START_W1) : (C_START_W0);
      C_START_W1:
        clk_next = (CLKEN_IN & SDI_DS1_IN == 10'h000) ? (C_START_W2)  : ((CLKEN_IN & SDI_DS1_IN == 10'h3FF) ? (C_START_W1) : (C_START_W0));
      C_START_W2:
        clk_next = (CLKEN_IN & SDI_DS1_IN == 10'h000) ? (C_START_XYZ) : ((CLKEN_IN & SDI_DS1_IN == 10'h3FF) ? (C_START_W1) : (C_START_W0));
      C_START_XYZ:
        clk_next = (CLKEN_IN) ? C_START_W0 : C_START_XYZ;
      default:
        clk_next = C_START_W0;
    endcase 
  end

  // Current State
  always @(posedge CLK_IN) begin
    if (RST_IN) 
      clk_state <= C_START_W0;
    else if (CLKEN_IN)
      clk_state <= clk_next;
  end

  // EAV/SAV Detection
  // Using the first virtual stream (DS1) as the reference 
  always @(posedge CLK_IN) begin
    if (RST_IN) begin
      clk_sdi_sav <= 1'b0;
      clk_sdi_eav <= 1'b0;
      clk_sdi_vblank <= 1'b0;
    end
    else if (CLKEN_IN) begin
      if (clk_state == C_START_XYZ) begin
        case (SDI_DS1_IN) 
          C_F0_SAV: begin
            clk_sdi_sav <= 1'b1;
          end
          C_F0_EAV: begin
            clk_sdi_eav <= 1'b1;
            clk_sdi_vblank <= 1'b0;
          end
          C_F0_SAV_VBLANK: begin
            clk_sdi_sav <= 1'b1;
          end
          C_F0_EAV_VBLANK: begin
            clk_sdi_eav <= 1'b1;
            clk_sdi_vblank <= 1'b1;
          end
          default: begin
            clk_sdi_eav <= 1'b0;
            clk_sdi_sav <= 1'b0;
          end
        endcase
      end
      else begin
        clk_sdi_eav <= 1'b0;
        clk_sdi_sav <= 1'b0;
      end 
    end
  end

  // Generate Native Video Timing
  always @(posedge CLK_IN) begin
    if (RST_IN) begin
      clk_sdi_hblank <= 1'b0;
    end
    else if (CLKEN_IN) begin
      clk_sdi_hblank_re <= 1'b0;
      clk_sdi_hblank_fe <= 1'b0;

      if (clk_sdi_eav) begin
        clk_sdi_hblank <= 1'b1;
        clk_sdi_hblank_re <= 1'b1;
      end
      else if (clk_sdi_sav_dly4) begin
        clk_sdi_hblank <= 1'b0;
        clk_sdi_hblank_fe <= 1'b1;
      end
    end
  end

  // Timing detection
  always @(posedge CLK_IN) begin
    if (RST_IN) begin
      clk_sdi_htotal_cnt   <= 'd0;
      clk_sdi_htotal_size  <= 'd0;
      clk_sdi_htotal_lock         <= 'd0;
    end
    else if (CLKEN_IN) begin
      // Htotal
      if (clk_sdi_hblank_re) begin
        clk_sdi_htotal_cnt <= 'd0;
        clk_sdi_htotal_size <= clk_sdi_htotal_cnt;

        if (clk_sdi_htotal_size == clk_sdi_htotal_cnt)
          clk_sdi_htotal_lock <= 1'b1;
      end
      else begin
        clk_sdi_htotal_cnt <= clk_sdi_htotal_cnt + 1'b1;
      end
    end
  end

  // TODO: Check that TRS symbols in virtural streams are in sync

  // Output assignments
  assign SDI_SUBIMG1_OUT      = clk_sdi_subimg1_dly5;
  assign SDI_SUBIMG2_OUT      = clk_sdi_subimg2_dly5;
  assign SDI_SUBIMG3_OUT      = clk_sdi_subimg3_dly5;
  assign SDI_SUBIMG4_OUT      = clk_sdi_subimg4_dly5;
  assign SDI_HBLANK_OUT       = clk_sdi_hblank;
  assign SDI_VBLANK_OUT       = clk_sdi_vblank_dly1;
  assign SDI_VALID_OUT        = ~SDI_HBLANK_OUT & ~SDI_VBLANK_OUT;
  assign SDI_HTOTAL_OUT       = clk_sdi_htotal_size;
  assign SDI_FLAG_OUT         = clk_sdi_htotal_lock & (clk_sdi_htotal_cnt == (clk_sdi_htotal_size >> 1));

endmodule

`default_nettype wire
