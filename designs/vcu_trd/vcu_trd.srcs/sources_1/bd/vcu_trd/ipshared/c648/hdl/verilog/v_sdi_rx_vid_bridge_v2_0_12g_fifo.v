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

module v_sdi_rx_vid_bridge_v2_0_0_12g_fifo #(
  parameter P_DATA_WIDTH  = 8,
  parameter P_ADDR_WIDTH  = 3
) (
  input wire                         CLK_IN,
  input wire                         RST_IN,
  // Write Interface
  input  wire                        W_CLKEN_IN,
  input  wire                        W_EN_IN,
  input  wire [P_DATA_WIDTH-1:0]     W_DATA_IN,
  // Read Interface
  input  wire                        R_CLKEN_IN,
  input  wire                        R_EN_IN,
  output reg                         R_VALID_OUT,
  output reg [P_DATA_WIDTH-1:0]      R_DATA_OUT,
  // Flags
  output wire                        FULL_OUT,
  output wire                        EMPTY_OUT,
  output wire                        UNDERFLOW_OUT, // Read on empty
  output wire                        OVERFLOW_OUT   // Write on full
);

  // Infer RAM
  reg [P_DATA_WIDTH-1:0] mem [2**P_ADDR_WIDTH-1:0];
  
  // Internal signals
  wire [P_DATA_WIDTH -1:0] r_data_i;
  reg  [P_ADDR_WIDTH:0]    w_ptr; 
  reg  [P_ADDR_WIDTH:0]    w_ptr_dly;
  reg  [P_ADDR_WIDTH:0]    r_ptr;
  
  // Assignments
  assign r_data_i = mem[r_ptr[P_ADDR_WIDTH-1:0]];

  // Delays
  always @(posedge CLK_IN) begin
    if (RST_IN) 
      w_ptr_dly <= {P_ADDR_WIDTH{1'b0}};
    else if (W_CLKEN_IN)
      w_ptr_dly <= w_ptr;
  end

  // Write Logic
  always @(posedge CLK_IN) begin
    if (RST_IN) begin
      w_ptr <= {P_ADDR_WIDTH{1'b0}};
    end
    else if (W_CLKEN_IN) begin
      if (!FULL_OUT && W_EN_IN) begin
        mem[w_ptr[P_ADDR_WIDTH-1:0]] <= W_DATA_IN;
        w_ptr <= w_ptr + 1'b1;
      end 
    end
  end

  // Read Logic
  always @(posedge CLK_IN) begin
    if (RST_IN) begin
      r_ptr <= {P_ADDR_WIDTH{1'b0}};
      R_DATA_OUT <= {P_DATA_WIDTH{1'b0}};
      R_VALID_OUT <= 1'b0;
    end
    else if (R_CLKEN_IN) begin
      if (!EMPTY_OUT && R_EN_IN) begin
        r_ptr <= r_ptr + 1'b1;
        R_DATA_OUT <= r_data_i;
        R_VALID_OUT <= 1'b1;
      end 
      else begin
        R_VALID_OUT <= 1'b0;
        R_DATA_OUT <= R_DATA_OUT;
      end
    end
  end

  // Output assignments
  assign EMPTY_OUT     = (w_ptr[P_ADDR_WIDTH:0] == r_ptr[P_ADDR_WIDTH:0]);
  assign FULL_OUT      = (w_ptr[P_ADDR_WIDTH] != r_ptr[P_ADDR_WIDTH]) && (w_ptr[P_ADDR_WIDTH-1:0] == r_ptr[P_ADDR_WIDTH-1:0]);
  assign UNDERFLOW_OUT = EMPTY_OUT && R_EN_IN && ~R_VALID_OUT; 
  assign OVERFLOW_OUT  = (w_ptr == w_ptr_dly) && (W_EN_IN & FULL_OUT);

endmodule

`default_nettype wire

