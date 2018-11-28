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

module v_sdi_rx_vid_bridge_v2_0_0_12g_formatter (
  input  wire            CLK_IN,
  input  wire            RST_IN,
  input  wire            CLKEN_IN,
  // SDI Sub-Image Interface
  input  wire [20-1:0]   SDI_SUBIMG1_IN, // Even line, even pixel pair
  input  wire [20-1:0]   SDI_SUBIMG2_IN, // Even line, odd pixel pairs
  input  wire [20-1:0]   SDI_SUBIMG3_IN, // Odd line, even pixel pairs
  input  wire [20-1:0]   SDI_SUBIMG4_IN, // Odd line, odd pixel pairs
  input  wire            SDI_VALID_IN,
  input  wire            SDI_HBLANK_IN,
  input  wire            SDI_VBLANK_IN,
  input  wire [16-1:0]   SDI_HTOTAL_IN,
  input  wire            SDI_FLAG_IN,
  // Native Video Interface
  output wire [80-1:0]   VID_DATA_OUT,
  output wire            VID_VALID_OUT,
  output wire            VID_HBLANK_OUT,
  output wire            VID_VBLANK_OUT,
  // Error Flag
  output wire [4-1:0]    ERROR_OUT
);

  // Internal Variables
  reg             clk_sdi_first_sof;
  reg             clk_sdi_valid;
  reg             clk_sdi_hblank;
  reg  [3-1:0]    clk_sdi_vblank;
  reg  [20-1:0]   clk_sdi_subimg1;
  reg  [20-1:0]   clk_sdi_subimg2;
  reg  [20-1:0]   clk_sdi_subimg3;
  reg  [20-1:0]   clk_sdi_subimg4;
  wire            clk_sdi_sof;

  wire            clk_w_en_to_fifo;
  reg             clk_w_en_strobe_to_fifo; 

  wire [83-1:0]   clk_w_data_to_even_fifo;
  wire            clk_r_en_to_even_fifo;
  wire            clk_r_valid_from_even_fifo;
  wire [83-1:0]   clk_r_data_from_even_fifo;
  wire            clk_full_from_even_fifo;
  wire            clk_empty_from_even_fifo;
  wire            clk_underflow_from_even_fifo;
  wire            clk_overflow_from_even_fifo;

  wire [83-1:0]   clk_w_data_to_odd_fifo;
  wire            clk_r_en_to_odd_fifo;
  wire            clk_r_valid_from_odd_fifo;
  wire [83-1:0]   clk_r_data_from_odd_fifo;
  wire            clk_full_from_odd_fifo;
  wire            clk_empty_from_odd_fifo;
  wire            clk_underflow_from_odd_fifo;
  wire            clk_overflow_from_odd_fifo;

  reg             clk_read_start;
  reg             clk_read_even_line;
  reg  [16-1:0]   clk_htotal_cnt;

  reg  [80-1:0]   clk_vid_data;
  reg             clk_vid_valid;
  reg             clk_vid_hblank;
  reg             clk_vid_vblank;
  
  // Detect SOF
  // SOF occurs on falling edge of VID_VBLANK_OUT 
  assign clk_sdi_sof = (clk_sdi_vblank[0] & ~SDI_VBLANK_IN);

  // 2-Sample Interleave Sub-Division
  // Pack two samples from subimg1 and two from subimg2 to create even line
  // Pack two samples from subimg3 and two from subimg4 to create odd line
  assign clk_w_data_to_even_fifo = {clk_sdi_vblank, clk_sdi_hblank, clk_sdi_valid, SDI_SUBIMG2_IN, clk_sdi_subimg2, SDI_SUBIMG1_IN, clk_sdi_subimg1};
  assign clk_w_data_to_odd_fifo = {clk_sdi_vblank, clk_sdi_hblank, clk_sdi_valid, SDI_SUBIMG4_IN, clk_sdi_subimg4, SDI_SUBIMG3_IN, clk_sdi_subimg3};

  // Write enable
  assign clk_w_en_to_fifo = clk_w_en_strobe_to_fifo;

  // Read Enable Logic
  assign clk_r_en_to_even_fifo = clk_read_start & clk_read_even_line;
  assign clk_r_en_to_odd_fifo = clk_read_start & ~clk_read_even_line;

  // Delay timing signals
  always @(posedge CLK_IN) begin
    if (RST_IN) begin
      clk_sdi_hblank <= 'b0;
      clk_sdi_valid <= 'b0;
      clk_sdi_vblank <= 'b0;
    end
    else if (CLKEN_IN) begin
      clk_sdi_hblank <= SDI_HBLANK_IN;
      clk_sdi_valid <= SDI_VALID_IN;
      clk_sdi_vblank <= {clk_sdi_vblank[1:0],SDI_VBLANK_IN};
    end
  end

  // Delay subimages
  always @(posedge CLK_IN) begin
    if (RST_IN) begin
      clk_sdi_subimg1 <= 'b0;
      clk_sdi_subimg2 <= 'b0;
      clk_sdi_subimg3 <= 'b0;
      clk_sdi_subimg4 <= 'b0;
    end
    else if (CLKEN_IN) begin
      clk_sdi_subimg1 <= SDI_SUBIMG1_IN;
      clk_sdi_subimg2 <= SDI_SUBIMG2_IN;
      clk_sdi_subimg3 <= SDI_SUBIMG3_IN;
      clk_sdi_subimg4 <= SDI_SUBIMG4_IN;
    end
  end

  // Register First SOF/EOL
  // Protects against partial frames corrupting sub-images
  always @(posedge CLK_IN) begin
    if (RST_IN) 
      clk_sdi_first_sof <= 1'b0;
    else if (CLKEN_IN)
      clk_sdi_first_sof <= (clk_sdi_sof) ? 1'b1 : clk_sdi_first_sof;
  end

  // Write Logic for Even and Odd Line FIFO
  // Write to FIFO at 1/2 the clock rate
  // Only write into FIFO after first SOF is detected
  always @(posedge CLK_IN) begin
    if (RST_IN) begin
      clk_w_en_strobe_to_fifo <= 1'b0;
    end
    else if (CLKEN_IN) begin
      if (clk_sdi_sof | clk_sdi_first_sof) begin
        clk_w_en_strobe_to_fifo <= clk_w_en_strobe_to_fifo ^ 1'b1;
      end
    end
  end

  // Allow reading out of fifo after at least
  // half a line has been written.
  always @(posedge CLK_IN) begin
    if (RST_IN) begin
      clk_read_start <= 1'b0;
    end
    else if (CLKEN_IN) begin
      if (SDI_FLAG_IN & clk_sdi_first_sof)
        clk_read_start <= 1'b1;
    end
  end

  // Determine whether even or odd line
  // fifo should be read
  always @(posedge CLK_IN) begin
    if (RST_IN) begin
      clk_htotal_cnt <= 'd0;
      clk_read_even_line <= 1'b1;
    end
    else if (CLKEN_IN) begin
      if (clk_r_en_to_even_fifo | clk_r_en_to_odd_fifo) begin
        if (clk_htotal_cnt == (SDI_HTOTAL_IN  >> 1)) begin
          clk_read_even_line <= clk_read_even_line ^ 1'b1;
          clk_htotal_cnt <= 'd0;
        end
        else begin
          clk_htotal_cnt <= clk_htotal_cnt + 1'b1;
        end
      end
    end
  end

  // Even Line FIFO
  // Used to buffer subimage 1 and 2
  v_sdi_rx_vid_bridge_v2_0_0_12g_fifo #(
    .P_DATA_WIDTH(83),
    .P_ADDR_WIDTH(10)
  ) FIFO_EVEN_INST (
    .CLK_IN(CLK_IN),
    .RST_IN(RST_IN),
    // Write Interface
    .W_CLKEN_IN(CLKEN_IN),
    .W_EN_IN(clk_w_en_to_fifo),
    .W_DATA_IN(clk_w_data_to_even_fifo),
    // Read Interface
    .R_CLKEN_IN(CLKEN_IN),
    .R_EN_IN(clk_r_en_to_even_fifo),
    .R_VALID_OUT(clk_r_valid_from_even_fifo),
    .R_DATA_OUT(clk_r_data_from_even_fifo),
    // Flags
    .FULL_OUT(clk_full_from_even_fifo),
    .EMPTY_OUT(clk_empty_from_even_fifo),
    .UNDERFLOW_OUT(clk_underflow_from_even_fifo), 
    .OVERFLOW_OUT(clk_overflow_from_even_fifo)  
  );

  // Odd Line FIFO
  // Used to buffer subimage 3 and 4
  v_sdi_rx_vid_bridge_v2_0_0_12g_fifo #(
    .P_DATA_WIDTH(83),
    .P_ADDR_WIDTH(11)
  ) FIFO_ODD_INST (
    .CLK_IN(CLK_IN),
    .RST_IN(RST_IN),
    // Write Interface
    .W_CLKEN_IN(CLKEN_IN),
    .W_EN_IN(clk_w_en_to_fifo),
    .W_DATA_IN(clk_w_data_to_odd_fifo),
    // Read Interface
    .R_CLKEN_IN(CLKEN_IN),
    .R_EN_IN(clk_r_en_to_odd_fifo),
    .R_VALID_OUT(clk_r_valid_from_odd_fifo),
    .R_DATA_OUT(clk_r_data_from_odd_fifo),
    // Flags
    .FULL_OUT(clk_full_from_odd_fifo),
    .EMPTY_OUT(clk_empty_from_odd_fifo),
    .UNDERFLOW_OUT(clk_underflow_from_odd_fifo),
    .OVERFLOW_OUT(clk_overflow_from_odd_fifo) 
  );

  // Register outputs
  always @(posedge CLK_IN) begin
    if (RST_IN) begin
      clk_vid_data   <= 'b0;
      clk_vid_valid  <= 'b0;
      clk_vid_hblank <= 'b0;
      clk_vid_vblank <= 'b0;
    end
    else if (CLKEN_IN) begin
      clk_vid_data   <= (clk_r_valid_from_even_fifo) ? (clk_r_data_from_even_fifo[79:0]) : (clk_r_data_from_odd_fifo[79:0]);
      clk_vid_valid  <= (clk_r_valid_from_even_fifo) ? (clk_r_data_from_even_fifo[80])   : (clk_r_data_from_odd_fifo[80]);  
      clk_vid_hblank <= (clk_r_valid_from_even_fifo) ? (clk_r_data_from_even_fifo[81])   : (clk_r_data_from_odd_fifo[81]); 
      clk_vid_vblank <= (clk_r_valid_from_even_fifo) ? (clk_r_data_from_even_fifo[82])   : (clk_r_data_from_odd_fifo[82]);  
    end
  end

  // Output assignments
  assign VID_DATA_OUT = clk_vid_data;
  assign VID_VALID_OUT = clk_vid_valid;
  assign VID_HBLANK_OUT = clk_vid_hblank;
  assign VID_VBLANK_OUT = clk_vid_vblank;
  assign ERROR_OUT = {clk_underflow_from_odd_fifo, clk_underflow_from_even_fifo,
                      clk_overflow_from_odd_fifo, clk_overflow_from_even_fifo}; 

endmodule

`default_nettype wire
