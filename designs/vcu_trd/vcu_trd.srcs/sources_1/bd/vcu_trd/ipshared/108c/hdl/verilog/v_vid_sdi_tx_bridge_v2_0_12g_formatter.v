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

module v_vid_sdi_tx_bridge_v2_0_0_12g_formatter (
  input  wire          CLK_IN,
  input  wire          RST_IN,
  // Native Video Interface
  input  wire          VID_CLKEN_IN,
  input  wire [80-1:0] VID_DATA_IN,
  input  wire          VID_VALID_IN,
  input  wire          VID_HBLANK_IN,
  input  wire          VID_VBLANK_IN,
  // SDI Sub-Image Interface
  input  wire          SDI_CLKEN_IN,
  output wire          SDI_VALID_OUT,
  output wire          SDI_HBLANK_OUT,
  output wire          SDI_VBLANK_OUT,
  output wire [20-1:0] SDI_SUBIMG1_OUT,
  output wire [20-1:0] SDI_SUBIMG2_OUT,
  output wire [20-1:0] SDI_SUBIMG3_OUT,
  output wire [20-1:0] SDI_SUBIMG4_OUT,
  // Video format 
  // 00 - 4:2:2
  // 01 - 4:2:0
  // 10 - Reserved
  // 11 - Reserved
  input  wire [1:0]    vid_frmt,
  // Error Flag
  output wire [4-1:0]  ERROR_OUT
);

  // Internal signals
  reg  [80-1:0]         clk_vid_data;
  reg                   clk_vid_valid;
  reg                   clk_vid_hblank;
  reg                   clk_vid_vblank;

  reg                   clk_vid_first_sof = 1'b0;
  reg                   clk_vid_first_vblank = 1'b0;
  reg                   clk_vid_line_even = 1'b0;
  wire                  clk_vid_sol;
  wire                  clk_vid_eol;
  wire                  clk_vid_vblank_fe;

  reg                   clk_w_en_to_even_fifo;
  reg  [80-1:0]         clk_w_data_to_even_fifo;
  wire                  clk_r_valid_from_even_fifo;
  wire [80-1:0]         clk_r_data_from_even_fifo;
  wire                  clk_full_from_even_fifo;
  wire                  clk_empty_from_even_fifo;
  wire                  clk_underflow_from_even_fifo;
  wire                  clk_overflow_from_even_fifo;

  reg                   clk_w_en_to_odd_fifo;
  reg  [80+3-1:0]       clk_w_data_to_odd_fifo;
  wire                  clk_r_valid_from_odd_fifo;
  wire [80+3-1:0]       clk_r_data_from_odd_fifo;
  wire                  clk_full_from_odd_fifo;
  wire                  clk_empty_from_odd_fifo;
  wire                  clk_underflow_from_odd_fifo;
  wire                  clk_overflow_from_odd_fifo;

  wire                  clk_r_en_to_fifo; // Even and Odd FIFOs are always read in parallel
  reg                   clk_r_en_strobe_to_fifo; // Used to reduce read rate out of FIFOs by 1/2 in order to serialize two sub-image samples simultaneously read out of the even and odd line FIFOs

  reg                   clk_sdi_vblank;
  reg                   clk_sdi_hblank;
  reg                   clk_sdi_valid;
  reg [2*10-1:0]        clk_sdi_subimg1;
  reg [2*10-1:0]        clk_sdi_subimg2;
  reg [2*10-1:0]        clk_sdi_subimg3;
  reg [2*10-1:0]        clk_sdi_subimg4;

  // Detect SOF and EOL
  // - SOF occurs on falling edge of VID_VBLANK_IN 
  // - EOL occurs on falling edge of VID_VALID_IN and rising edge of VID_HBLANK_IN
  assign clk_vid_sol = (~clk_vid_valid & VID_VALID_IN) | (clk_vid_hblank & ~VID_HBLANK_IN);
  assign clk_vid_eol = (clk_vid_valid & ~VID_VALID_IN) | (~clk_vid_hblank & VID_HBLANK_IN); 
  assign clk_vid_vblank_fe = (clk_vid_vblank & ~VID_VBLANK_IN);

  assign clk_r_en_to_fifo = clk_r_en_strobe_to_fifo;

  // Register video input signals
  always @(posedge CLK_IN) begin
    if(RST_IN) begin
      clk_vid_data <= 'd0;
      clk_vid_valid <= 1'b0;
      clk_vid_hblank <= 1'b0;
      clk_vid_vblank <= 1'b0;
    end
    else if(VID_CLKEN_IN) begin
      clk_vid_data <= VID_DATA_IN;
      clk_vid_valid <= VID_VALID_IN;
      clk_vid_hblank <= VID_HBLANK_IN;
      clk_vid_vblank <= VID_VBLANK_IN;
    end
  end

  // Register first SOF
  always @(posedge CLK_IN) begin
    if (RST_IN) begin
      clk_vid_first_vblank <= 1'b0;
      clk_vid_first_sof <= 1'b0;
    end
    else if (VID_CLKEN_IN) begin
      if (clk_vid_vblank_fe)
        clk_vid_first_vblank <= 1'b1;
      if (clk_vid_first_vblank & clk_vid_sol)
        clk_vid_first_sof <= 1'b1;
    end
  end
 
  // Determine even or odd line
  // - Used to control write enable into even/odd FIFO
  always @(posedge CLK_IN) begin
    if (RST_IN) begin
      clk_vid_line_even <= 1'b1; 
    end
    else if (VID_CLKEN_IN) begin
      if(clk_vid_first_sof & clk_vid_sol) begin
        clk_vid_line_even <= ~clk_vid_line_even;
      end
    end
  end

  // Write Logic for Even Line FIFO
  // - Only write into FIFO when first SOF is detected and line is even
  always @(posedge CLK_IN) begin
    if (RST_IN) begin
      clk_w_en_to_even_fifo <= 1'b0;
    end
    else if (VID_CLKEN_IN) begin
      if (clk_vid_first_sof & clk_vid_line_even)
        clk_w_en_to_even_fifo <= 1'b1;
      else
        clk_w_en_to_even_fifo <= 1'b0;
    end
  end

  // Write Logic for Odd Line FIFO
  // - Only write into FIFO when first SOF is detected and line is odd
  always @(posedge CLK_IN) begin
    if (RST_IN) begin
      clk_w_en_to_odd_fifo <= 1'b0;
    end
    else if (VID_CLKEN_IN) begin
      if (clk_vid_first_sof & ~clk_vid_line_even)
        clk_w_en_to_odd_fifo <= 1'b1;
      else
        clk_w_en_to_odd_fifo <= 1'b0;
    end
  end

  // Write fifo data
  always @(posedge CLK_IN) begin
    if (RST_IN) begin
      clk_w_data_to_even_fifo <= 'd0;
      clk_w_data_to_odd_fifo  <= 'd0;
    end
    else if (VID_CLKEN_IN) begin
      clk_w_data_to_even_fifo <= clk_vid_data;
      clk_w_data_to_odd_fifo <= {clk_vid_vblank, clk_vid_hblank, clk_vid_valid, clk_vid_data};
    end
  end

  // Read Logic for Even and Odd Line FIFO
  // - Read out of FIFO at 1/2 of the write rate
  // - Normally both FIFOs should go EMPTY_OUT simultaneously at the end of every odd line
  always @(posedge CLK_IN) begin
    if (RST_IN) begin
      clk_r_en_strobe_to_fifo <= 1'b0;
    end
    else if (SDI_CLKEN_IN) begin
      clk_r_en_strobe_to_fifo <= (~clk_empty_from_odd_fifo | clk_r_en_strobe_to_fifo) ? (clk_r_en_strobe_to_fifo ^ 1'b1) : clk_r_en_strobe_to_fifo;
    end
  end

  // Instantiate Even Line FIFO
  // - Worst case FIFO depth of 2048 
  // - Add some additional padding words to the FIFO to ensure it does not
  //   overflow due to delays
  // - Reference ST2080-10, figure 3
  v_vid_sdi_tx_bridge_v2_0_0_12g_fifo #(
    .P_DATA_WIDTH(80),
    .P_ADDR_WIDTH(11)
  ) FIFO_EVEN_INST (
    .CLK_IN(CLK_IN),
    .RST_IN(RST_IN),
    // Write Interface
    .W_CLKEN_IN(VID_CLKEN_IN),
    .W_EN_IN(clk_w_en_to_even_fifo),
    .W_DATA_IN(clk_w_data_to_even_fifo),
    // Read Interface
    .R_CLKEN_IN(SDI_CLKEN_IN),
    .R_EN_IN(clk_r_en_to_fifo),
    .R_VALID_OUT(clk_r_valid_from_even_fifo),
    .R_DATA_OUT(clk_r_data_from_even_fifo),
    // Flags
    .FULL_OUT(clk_full_from_even_fifo),
    .EMPTY_OUT(clk_empty_from_even_fifo),
    .UNDERFLOW_OUT(clk_underflow_from_even_fifo), 
    .OVERFLOW_OUT(clk_overflow_from_even_fifo) 
  );

  // Instantiate Odd Line FIFO
  // - This FIFO needs to be half the even line fifo plus some padding
  // - Samples are read at half the rate it is being written
  // - Timing information is embedded into write data to be recovered after reading
  v_vid_sdi_tx_bridge_v2_0_0_12g_fifo #(
    .P_DATA_WIDTH(80+3),
    .P_ADDR_WIDTH(10)
  ) FIFO_ODD_INST (
    .CLK_IN(CLK_IN),
    .RST_IN(RST_IN),
    // Write Interface
    .W_CLKEN_IN(VID_CLKEN_IN),
    .W_EN_IN(clk_w_en_to_odd_fifo),
    .W_DATA_IN(clk_w_data_to_odd_fifo),
    // Read Interface
    .R_CLKEN_IN(SDI_CLKEN_IN),
    .R_EN_IN(clk_r_en_to_fifo),
    .R_VALID_OUT(clk_r_valid_from_odd_fifo),
    .R_DATA_OUT(clk_r_data_from_odd_fifo),
    // Flags
    .FULL_OUT(clk_full_from_odd_fifo),
    .EMPTY_OUT(clk_empty_from_odd_fifo),
    .UNDERFLOW_OUT(clk_underflow_from_odd_fifo),
    .OVERFLOW_OUT(clk_overflow_from_odd_fifo) 
  );

  // Recover timing
  always @(posedge CLK_IN) begin
    if (RST_IN) begin
      clk_sdi_valid   <= 'b0;
      clk_sdi_hblank  <= 'b0;
      clk_sdi_vblank  <= 'b0;
    end
    else if (SDI_CLKEN_IN) begin
      clk_sdi_valid  <= clk_r_data_from_odd_fifo[79+1];
      clk_sdi_hblank <= clk_r_data_from_odd_fifo[79+2];
      clk_sdi_vblank <= clk_r_data_from_odd_fifo[79+3];
    end
  end

  // Create Sub-Images
  // - Remap sample pairs from even/odd line buffers
  always @(posedge CLK_IN) begin
    if (RST_IN) begin
      clk_sdi_subimg1 <= 'd0;
      clk_sdi_subimg2 <= 'd0;
      clk_sdi_subimg3 <= 'd0;
      clk_sdi_subimg4 <= 'd0;
    end
    else if (SDI_CLKEN_IN) begin
      if (clk_r_valid_from_odd_fifo) begin
        clk_sdi_subimg1 <= clk_r_data_from_even_fifo[0    +: 2*10];
        clk_sdi_subimg2 <= clk_r_data_from_even_fifo[4*10 +: 2*10];
        clk_sdi_subimg3 <= clk_r_data_from_odd_fifo[0    +: 2*10];
        clk_sdi_subimg4 <= clk_r_data_from_odd_fifo[4*10 +: 2*10];
      end
      else if (~clk_r_valid_from_odd_fifo) begin
        clk_sdi_subimg1 <= clk_r_data_from_even_fifo[2*10 +: 2*10];
        clk_sdi_subimg2 <= clk_r_data_from_even_fifo[6*10 +: 2*10];
        clk_sdi_subimg3 <= clk_r_data_from_odd_fifo[2*10 +: 2*10];
        clk_sdi_subimg4 <= clk_r_data_from_odd_fifo[6*10 +: 2*10];
      end
    end
  end

  // Output assignments
  assign SDI_VALID_OUT   = clk_sdi_valid;
  assign SDI_VBLANK_OUT  = clk_sdi_vblank;
  assign SDI_HBLANK_OUT  = clk_sdi_hblank;
  assign SDI_SUBIMG1_OUT = clk_sdi_subimg1; 
  assign SDI_SUBIMG2_OUT = clk_sdi_subimg2;
  assign SDI_SUBIMG3_OUT = (vid_frmt == 2'b01) ? {10'h200,clk_sdi_subimg3[9:0]} : clk_sdi_subimg3;
  assign SDI_SUBIMG4_OUT = (vid_frmt == 2'b01) ? {10'h200,clk_sdi_subimg4[9:0]} : clk_sdi_subimg4;
  assign ERROR_OUT       = {clk_underflow_from_odd_fifo, clk_underflow_from_even_fifo,
                            clk_overflow_from_odd_fifo, clk_overflow_from_even_fifo};

endmodule

`default_nettype wire
