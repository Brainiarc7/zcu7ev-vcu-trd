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

module v_vid_sdi_tx_bridge_v2_0_0_12g_embedder #(
  parameter C_SIM_MODE = 0
) (
  input  wire            CLK_IN,
  input  wire            CLKEN_IN,
  input  wire            RST_IN,
  // SDI Sub-Image Interface
  input  wire            SDI_VBLANK_IN,
  input  wire            SDI_HBLANK_IN,
  input  wire            SDI_VALID_IN,
  input  wire [20-1:0]   SDI_SUBIMG1_IN,    // Subimage 1 
  input  wire [20-1:0]   SDI_SUBIMG2_IN,    // Subimage 2 
  input  wire [20-1:0]   SDI_SUBIMG3_IN,    // Subimage 3 
  input  wire [20-1:0]   SDI_SUBIMG4_IN,    // Subimage 4 
  // SDI Virtual Interface
  output wire [10-1:0]   SDI_DS1_OUT,       // SDI data stream 1 - Y
  output wire [10-1:0]   SDI_DS2_OUT,       // SDI data stream 2 - Cb/Cr
  output wire [10-1:0]   SDI_DS3_OUT,       // SDI data stream 3 - Y
  output wire [10-1:0]   SDI_DS4_OUT,       // SDI data stream 4 - Cb/Cr
  output wire [10-1:0]   SDI_DS5_OUT,       // SDI data stream 5 - Y
  output wire [10-1:0]   SDI_DS6_OUT,       // SDI data stream 6 - Cb/Cr
  output wire [10-1:0]   SDI_DS7_OUT,       // SDI data stream 7 - Y
  output wire [10-1:0]   SDI_DS8_OUT,       // SDI data stream 8 - Cb/Cr
  output wire [11-1:0]   SDI_DSX_LINE_OUT   // SDI data stream line number
);

  // Parameters
  localparam [4-1:0]
    C_IDLE   = 0,
    C_EAV_W0 = 1, 
    C_EAV_W1 = 2, 
    C_EAV_W2 = 3,
    C_EAV_W3 = 4,
    C_LN_W0  = 5,
    C_LN_W1  = 6,
    C_CRC_W0 = 7,
    C_CRC_W1 = 8,
    C_HBLANK  = 9, 
    C_SAV_W0 = 10,
    C_SAV_W1 = 11,
    C_SAV_W2 = 12,
    C_SAV_W3 = 13,
    C_VBLANK = 14,
    C_ACTIVE = 15;
  localparam [11-1:0]
    C_START_LINE_0 = 1122,
    C_END_LINE_0   = 1125;

  localparam [11-1:0]
    C_START_LINE_1 = 27,
    C_END_LINE_1   = 30;
 
  // Internal signals
  reg  [5*20-1:0] clk_sdi_subimg1;
  reg  [5*20-1:0] clk_sdi_subimg2;
  reg  [5*20-1:0] clk_sdi_subimg3;
  reg  [5*20-1:0] clk_sdi_subimg4;
  reg  [5-1:0]    clk_sdi_vblank;
  reg  [5-1:0]    clk_sdi_hblank;
  wire            clk_sdi_vblank_re;
  wire            clk_sdi_hblank_re;
  reg             clk_sdi_first_frame;

  reg  [4-1:0]    clk_state;
  reg  [4-1:0]    clk_next;
  reg  [10-1:0]   clk_xyz;

  reg  [10-1:0]   clk_sdi_ds1;       
  reg  [10-1:0]   clk_sdi_ds2;      
  reg  [10-1:0]   clk_sdi_ds3;       
  reg  [10-1:0]   clk_sdi_ds4;     
  reg  [10-1:0]   clk_sdi_ds5;       
  reg  [10-1:0]   clk_sdi_ds6;     
  reg  [10-1:0]   clk_sdi_ds7;       
  reg  [10-1:0]   clk_sdi_ds8;    
  reg  [11-1:0]   clk_sdi_dsx_line;

  reg  [10-1:0]   clk_sdi_ds1_from_mux;       
  reg  [10-1:0]   clk_sdi_ds2_from_mux;      
  reg  [10-1:0]   clk_sdi_ds3_from_mux;       
  reg  [10-1:0]   clk_sdi_ds4_from_mux;     
  reg  [10-1:0]   clk_sdi_ds5_from_mux;       
  reg  [10-1:0]   clk_sdi_ds6_from_mux;     
  reg  [10-1:0]   clk_sdi_ds7_from_mux;       
  reg  [10-1:0]   clk_sdi_ds8_from_mux;    
  reg  [11-1:0]   clk_sdi_dsx_line_dly;

  // Internal assignments
  assign clk_sdi_vblank_re = ~clk_sdi_vblank[0] & SDI_VBLANK_IN;
  assign clk_sdi_hblank_re = ~clk_sdi_hblank[4] & clk_sdi_hblank[3];

  // Delay inputs
  always @(posedge CLK_IN) begin
    if (RST_IN) begin
      clk_sdi_vblank  <= 'd0;
      clk_sdi_hblank  <= 'd0;
      clk_sdi_subimg1 <= 'd0;
      clk_sdi_subimg2 <= 'd0;
      clk_sdi_subimg3 <= 'd0;
      clk_sdi_subimg4 <= 'd0;
    end 
    else if (CLKEN_IN) begin
      clk_sdi_vblank  <= {clk_sdi_vblank[3:0], SDI_VBLANK_IN};
      clk_sdi_hblank  <= {clk_sdi_hblank[3:0], SDI_HBLANK_IN};
      clk_sdi_subimg1 <= {clk_sdi_subimg1[4*20-1:0], SDI_SUBIMG1_IN};
      clk_sdi_subimg2 <= {clk_sdi_subimg2[4*20-1:0], SDI_SUBIMG2_IN};
      clk_sdi_subimg3 <= {clk_sdi_subimg3[4*20-1:0], SDI_SUBIMG3_IN};
      clk_sdi_subimg4 <= {clk_sdi_subimg4[4*20-1:0], SDI_SUBIMG4_IN};
    end
  end

  // Line Count
  // - Initialize to zero
  // - Synchronize to rising edge of VBLANK then free-run
generate
if (C_SIM_MODE == 0) begin: line_count_sim_0
  always @(posedge CLK_IN) begin
    if (RST_IN) begin
      clk_sdi_dsx_line <= 11'h000;
      clk_sdi_first_frame <= 1'b0;
    end
    else if (CLKEN_IN) begin
      if (clk_sdi_vblank_re) begin
        clk_sdi_dsx_line <= C_START_LINE_0-1;
      end
      else if ((clk_next == C_EAV_W0) && (clk_sdi_dsx_line == C_END_LINE_0)) begin
        clk_sdi_dsx_line <= 11'h001;
      end
      else if (clk_next == C_EAV_W0 && (clk_sdi_dsx_line != 11'h000)) begin
        clk_sdi_dsx_line <= clk_sdi_dsx_line + 1'b1;
        clk_sdi_first_frame <= 1'b1;
      end
    end
  end
end
endgenerate
	// for simulation purpose on small frame with total lines == 30
generate
if (C_SIM_MODE == 1) begin: line_count_sim_1
  always @(posedge CLK_IN) begin
    if (RST_IN) begin
      clk_sdi_dsx_line <= 11'h000;
      clk_sdi_first_frame <= 1'b0;
    end
    else if (CLKEN_IN) begin
      if (clk_sdi_vblank_re) begin
        clk_sdi_dsx_line <= C_START_LINE_1-1;
      end
      else if ((clk_next == C_EAV_W0) && (clk_sdi_dsx_line == C_END_LINE_1)) begin
        clk_sdi_dsx_line <= 11'h001;
      end
      else if (clk_next == C_EAV_W0 && (clk_sdi_dsx_line != 11'h000)) begin
        clk_sdi_dsx_line <= clk_sdi_dsx_line + 1'b1;
        clk_sdi_first_frame <= 1'b1;
      end
    end
  end
end
endgenerate

  // Generate SAV/EAV XYZ
  // - For 6G/12G SDI Field ID is always Zero
  always @(*) begin
    clk_xyz = 10'h000;
    case ({clk_sdi_vblank[0],clk_state})
      {1'b0,C_SAV_W3}: clk_xyz = 10'h200; // F0 SAV
      {1'b0,C_EAV_W3}: clk_xyz = 10'h274; // F0 EAV
      {1'b1,C_SAV_W3}: clk_xyz = 10'h2AC; // F0 SAV+VBLANK
      {1'b1,C_EAV_W3}: clk_xyz = 10'h2D8; // F0 EAV+VBLANK
    endcase
  end

  // FSM Next State Logic
  // - Input based on rising/falling edge of HBLANK 
  always @(*) begin
    case (clk_state)
      C_IDLE:
        clk_next = (clk_sdi_hblank_re) ? C_EAV_W0 : C_IDLE;
      C_EAV_W0:
        clk_next = C_EAV_W1;
      C_EAV_W1:
        clk_next = C_EAV_W2;
      C_EAV_W2:
        clk_next = C_EAV_W3;
      C_EAV_W3:
        clk_next = C_LN_W0;
      C_LN_W0:
        clk_next = C_LN_W1;
      C_LN_W1:
        clk_next = C_CRC_W0;
      C_CRC_W0:
        clk_next = C_CRC_W1;
      C_CRC_W1:
        clk_next = C_HBLANK;
      C_HBLANK: 
        clk_next = ({clk_sdi_hblank[0],SDI_HBLANK_IN} == 2'b10) ? C_SAV_W0 : C_HBLANK;
      C_SAV_W0: 
        clk_next = C_SAV_W1;
      C_SAV_W1:
        clk_next = C_SAV_W2;
      C_SAV_W2:
        clk_next = C_SAV_W3;
      C_SAV_W3:
        clk_next = (clk_sdi_vblank[4]) ? C_VBLANK : C_ACTIVE;
      C_VBLANK:
        clk_next = (clk_sdi_hblank_re) ? C_EAV_W0 : C_VBLANK;
      C_ACTIVE:
        clk_next = (clk_sdi_hblank_re) ? C_EAV_W0 : C_ACTIVE;
      default:
        clk_next = C_IDLE;
    endcase 
  end

  // FSM Current State
  always @(posedge CLK_IN) begin
    if (RST_IN) 
      clk_state <= C_IDLE;
    else if (CLKEN_IN)
      clk_state <= clk_next;
  end

  // FSM Output Logic
  // - Multiplex EAV, Line, CRC, Blanking/HANC, SAV, or Sub-Images
  always @(*) begin
    case (clk_state)
      C_IDLE: begin
        clk_sdi_ds1 = 10'h004;
        clk_sdi_ds2 = 10'h004;
        clk_sdi_ds3 = 10'h004;
        clk_sdi_ds4 = 10'h004;
        clk_sdi_ds5 = 10'h004;
        clk_sdi_ds6 = 10'h004;
        clk_sdi_ds7 = 10'h004;
        clk_sdi_ds8 = 10'h004;
      end
      C_EAV_W0: begin
        clk_sdi_ds1 = 10'h3FF;
        clk_sdi_ds2 = 10'h3FF;
        clk_sdi_ds3 = 10'h3FF;
        clk_sdi_ds4 = 10'h3FF;
        clk_sdi_ds5 = 10'h3FF;
        clk_sdi_ds6 = 10'h3FF;
        clk_sdi_ds7 = 10'h3FF;
        clk_sdi_ds8 = 10'h3FF;
      end
      C_EAV_W1: begin
        clk_sdi_ds1 = 10'h000;
        clk_sdi_ds2 = 10'h000;
        clk_sdi_ds3 = 10'h000;
        clk_sdi_ds4 = 10'h000;
        clk_sdi_ds5 = 10'h000;
        clk_sdi_ds6 = 10'h000;
        clk_sdi_ds7 = 10'h000;
        clk_sdi_ds8 = 10'h000;
      end
      C_EAV_W2: begin
        clk_sdi_ds1 = 10'h000;
        clk_sdi_ds2 = 10'h000;
        clk_sdi_ds3 = 10'h000;
        clk_sdi_ds4 = 10'h000;
        clk_sdi_ds5 = 10'h000;
        clk_sdi_ds6 = 10'h000;
        clk_sdi_ds7 = 10'h000;
        clk_sdi_ds8 = 10'h000;
      end
      C_EAV_W3: begin 
        clk_sdi_ds1 = clk_xyz;
        clk_sdi_ds2 = clk_xyz;
        clk_sdi_ds3 = clk_xyz;
        clk_sdi_ds4 = clk_xyz;
        clk_sdi_ds5 = clk_xyz;
        clk_sdi_ds6 = clk_xyz;
        clk_sdi_ds7 = clk_xyz;
        clk_sdi_ds8 = clk_xyz;
      end
      C_LN_W0: begin 
        clk_sdi_ds1 = {~clk_sdi_dsx_line[6],clk_sdi_dsx_line[6:0],2'b00};
        clk_sdi_ds2 = {~clk_sdi_dsx_line[6],clk_sdi_dsx_line[6:0],2'b00};
        clk_sdi_ds3 = {~clk_sdi_dsx_line[6],clk_sdi_dsx_line[6:0],2'b00};
        clk_sdi_ds4 = {~clk_sdi_dsx_line[6],clk_sdi_dsx_line[6:0],2'b00};
        clk_sdi_ds5 = {~clk_sdi_dsx_line[6],clk_sdi_dsx_line[6:0],2'b00};
        clk_sdi_ds6 = {~clk_sdi_dsx_line[6],clk_sdi_dsx_line[6:0],2'b00};
        clk_sdi_ds7 = {~clk_sdi_dsx_line[6],clk_sdi_dsx_line[6:0],2'b00};
        clk_sdi_ds8 = {~clk_sdi_dsx_line[6],clk_sdi_dsx_line[6:0],2'b00};
      end
      C_LN_W1: begin 
        clk_sdi_ds1 = {4'b1000,clk_sdi_dsx_line[10:7],2'b00};
        clk_sdi_ds2 = {4'b1000,clk_sdi_dsx_line[10:7],2'b00};
        clk_sdi_ds3 = {4'b1000,clk_sdi_dsx_line[10:7],2'b00};
        clk_sdi_ds4 = {4'b1000,clk_sdi_dsx_line[10:7],2'b00};
        clk_sdi_ds5 = {4'b1000,clk_sdi_dsx_line[10:7],2'b00};
        clk_sdi_ds6 = {4'b1000,clk_sdi_dsx_line[10:7],2'b00};
        clk_sdi_ds7 = {4'b1000,clk_sdi_dsx_line[10:7],2'b00};
        clk_sdi_ds8 = {4'b1000,clk_sdi_dsx_line[10:7],2'b00};
      end
      C_CRC_W0: begin 
        clk_sdi_ds1 = 10'h004;
        clk_sdi_ds2 = 10'h004;
        clk_sdi_ds3 = 10'h004;
        clk_sdi_ds4 = 10'h004;
        clk_sdi_ds5 = 10'h004;
        clk_sdi_ds6 = 10'h004;
        clk_sdi_ds7 = 10'h004;
        clk_sdi_ds8 = 10'h004;
      end
      C_CRC_W1: begin 
        clk_sdi_ds1 = 10'h004;
        clk_sdi_ds2 = 10'h004;
        clk_sdi_ds3 = 10'h004;
        clk_sdi_ds4 = 10'h004;
        clk_sdi_ds5 = 10'h004;
        clk_sdi_ds6 = 10'h004;
        clk_sdi_ds7 = 10'h004;
        clk_sdi_ds8 = 10'h004;
      end
      C_HBLANK: begin
        clk_sdi_ds1 = 10'h004;
        clk_sdi_ds2 = 10'h004;
        clk_sdi_ds3 = 10'h004;
        clk_sdi_ds4 = 10'h004;
        clk_sdi_ds5 = 10'h004;
        clk_sdi_ds6 = 10'h004;
        clk_sdi_ds7 = 10'h004;
        clk_sdi_ds8 = 10'h004;
      end
      C_SAV_W0: begin 
        clk_sdi_ds1 = 10'h3FF;
        clk_sdi_ds2 = 10'h3FF;
        clk_sdi_ds3 = 10'h3FF;
        clk_sdi_ds4 = 10'h3FF;
        clk_sdi_ds5 = 10'h3FF;
        clk_sdi_ds6 = 10'h3FF;
        clk_sdi_ds7 = 10'h3FF;
        clk_sdi_ds8 = 10'h3FF;
      end
      C_SAV_W1: begin 
        clk_sdi_ds1 = 10'h000;
        clk_sdi_ds2 = 10'h000;
        clk_sdi_ds3 = 10'h000;
        clk_sdi_ds4 = 10'h000;
        clk_sdi_ds5 = 10'h000;
        clk_sdi_ds6 = 10'h000;
        clk_sdi_ds7 = 10'h000;
        clk_sdi_ds8 = 10'h000;
      end
      C_SAV_W2: begin 
        clk_sdi_ds1 = 10'h000;
        clk_sdi_ds2 = 10'h000;
        clk_sdi_ds3 = 10'h000;
        clk_sdi_ds4 = 10'h000;
        clk_sdi_ds5 = 10'h000;
        clk_sdi_ds6 = 10'h000;
        clk_sdi_ds7 = 10'h000;
        clk_sdi_ds8 = 10'h000;
      end
      C_SAV_W3: begin 
        clk_sdi_ds1 = clk_xyz;
        clk_sdi_ds2 = clk_xyz;
        clk_sdi_ds3 = clk_xyz;
        clk_sdi_ds4 = clk_xyz;
        clk_sdi_ds5 = clk_xyz;
        clk_sdi_ds6 = clk_xyz;
        clk_sdi_ds7 = clk_xyz;
        clk_sdi_ds8 = clk_xyz;
      end
      C_VBLANK: begin
        clk_sdi_ds1 = 10'h004;
        clk_sdi_ds2 = 10'h004;
        clk_sdi_ds3 = 10'h004;
        clk_sdi_ds4 = 10'h004;
        clk_sdi_ds5 = 10'h004;
        clk_sdi_ds6 = 10'h004;
        clk_sdi_ds7 = 10'h004;
        clk_sdi_ds8 = 10'h004;
      end
      C_ACTIVE: begin
        {clk_sdi_ds2, clk_sdi_ds1} = clk_sdi_subimg1[5*20-1:4*20];
        {clk_sdi_ds4, clk_sdi_ds3} = clk_sdi_subimg2[5*20-1:4*20];
        {clk_sdi_ds6, clk_sdi_ds5} = clk_sdi_subimg3[5*20-1:4*20];
        {clk_sdi_ds8, clk_sdi_ds7} = clk_sdi_subimg4[5*20-1:4*20];
      end
      default: begin
        clk_sdi_ds1 = 10'h000;
        clk_sdi_ds2 = 10'h000;
        clk_sdi_ds3 = 10'h000;
        clk_sdi_ds4 = 10'h000;
        clk_sdi_ds5 = 10'h000;
        clk_sdi_ds6 = 10'h000;
        clk_sdi_ds7 = 10'h000;
        clk_sdi_ds8 = 10'h000;
      end
    endcase
  end

  // Register Virtual Interface Outputs
  always @(posedge CLK_IN) begin
    if(RST_IN) begin
      clk_sdi_ds1_from_mux <= 10'h000;
      clk_sdi_ds2_from_mux <= 10'h000;
      clk_sdi_ds3_from_mux <= 10'h000;
      clk_sdi_ds4_from_mux <= 10'h000;
      clk_sdi_ds5_from_mux <= 10'h000;
      clk_sdi_ds6_from_mux <= 10'h000;
      clk_sdi_ds7_from_mux <= 10'h000;
      clk_sdi_ds8_from_mux <= 10'h000;
      clk_sdi_dsx_line_dly <= 1'b0;
    end
    else if (CLKEN_IN) begin
      if(clk_sdi_first_frame) begin
        clk_sdi_ds1_from_mux <= clk_sdi_ds1;
        clk_sdi_ds2_from_mux <= clk_sdi_ds2;
        clk_sdi_ds3_from_mux <= clk_sdi_ds3;
        clk_sdi_ds4_from_mux <= clk_sdi_ds4;
        clk_sdi_ds5_from_mux <= clk_sdi_ds5;
        clk_sdi_ds6_from_mux <= clk_sdi_ds6;
        clk_sdi_ds7_from_mux <= clk_sdi_ds7;
        clk_sdi_ds8_from_mux <= clk_sdi_ds8;
        clk_sdi_dsx_line_dly <= clk_sdi_dsx_line;
      end
    end
  end

  // Output assignments
  assign SDI_DS1_OUT = clk_sdi_ds1_from_mux;
  assign SDI_DS2_OUT = clk_sdi_ds2_from_mux;
  assign SDI_DS3_OUT = clk_sdi_ds3_from_mux;
  assign SDI_DS4_OUT = clk_sdi_ds4_from_mux;
  assign SDI_DS5_OUT = clk_sdi_ds5_from_mux;
  assign SDI_DS6_OUT = clk_sdi_ds6_from_mux;
  assign SDI_DS7_OUT = clk_sdi_ds7_from_mux;
  assign SDI_DS8_OUT = clk_sdi_ds8_from_mux;
  assign SDI_DSX_LINE_OUT = clk_sdi_dsx_line_dly;

endmodule

`default_nettype wire
