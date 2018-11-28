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
/*
Module Description:
This module converts 1/2/4 pixel-per-clock video input
to 1 pixel-per-clock at the output. 
------------------------------------------------------------------------------
*/

`timescale 1ps/1ps

(* DowngradeIPIdentifiedWarnings="yes" *)
module v_vid_sdi_tx_bridge_v2_0_0_3g_converter #(
 parameter C_PPC = 1 // Pixel-per-clock: 1, 2, or 4
) (
  input                clk,
  input                rst,
  input                clken,

  // Video Inputs
  input [20*C_PPC-1:0] vid_data_in,            // Input parallel video data.  2 components, 10 bits, 1/2/4 PPC
  input                vid_active_video_in,    // Input active video control signal
  input                vid_vblank_in,          // Input vertical blank
  input                vid_hblank_in,          // Input horizontal blank
  input                vid_field_id_in,        // Input field_id bit

  // Video Outputs
  output [20-1:0]      vid_data_out,           // Output parallel video data.  2 components, 10 bits
  output               vid_active_video_out,   // Output active video control signal
  output               vid_vblank_out,         // Output vertical blank
  output               vid_hblank_out,         // Output horizontal blank
  output               vid_field_id_out,       // Output field_id bit
  output               vid_clken               // Output output clock enable
);

// Internal signals
wire clk_active_re;
reg [1:0] clk_pixel_cnt;
reg [1:0] clk_pixel_cnt_dly;
reg clk_vid_active;
reg [20*C_PPC-1:0] vid_data_in_reg; 
//wire[20*C_PPC-1:0] vid_data_in_int;
reg vid_clken_dly = 0;

assign clk_active_re = ~clk_vid_active & vid_active_video_in;

// Delay inputs
always @(posedge clk) begin
  if (rst) begin
    clk_vid_active <= 1'b0;
  end else if (clken) begin
    clk_vid_active <= vid_active_video_in;
  end
end

// Pixel counter
// Used to generate clock enable
always @(posedge clk) begin
  if (rst) begin
    clk_pixel_cnt <= 2'b00;
    clk_pixel_cnt_dly <= 2'b00;
  end 
  else if (clken) begin
    clk_pixel_cnt_dly <= clk_pixel_cnt;
    //if(clk_pixel_cnt == 2'd0)
    //    vid_data_in_reg   <= vid_data_in;

    case (C_PPC)
      2: clk_pixel_cnt <= clk_pixel_cnt ^ 1'b1; // sequence 0, 1, 0, 1
      4: clk_pixel_cnt <= clk_pixel_cnt + 1'b1; // sequence 0, 1, 2, 3
      default: clk_pixel_cnt <= 2'b00;          // sequence 0, 0, 0 , 0
    endcase
  end
end

always @(posedge clk)
begin
    if(rst)
    begin
        vid_data_in_reg <= {20*C_PPC{1'b0}} ;
        vid_clken_dly   <= 1'd0;       
    end
    else
    begin
        vid_clken_dly   <= vid_clken;
        if(vid_clken_dly)
            vid_data_in_reg   <= vid_data_in;
    end
end

//assign vid_data_in_int      = {vid_data_in_reg[20*C_PPC-1:20],vid_data_in[19:0]};

// Output assignments
// Theh below vid_data_out assinging logic is to satisfy the condition of
// input chaning on every clock cycle if this SDI bridge is used as standalone
// instead of getting used in TX subsystem.
// With this logic, in SD mode, the 20 bits of vid_data_out will be holded for 5 clock
// cycles till it is sampled by the fomatter, and it will be holded for one
// clock cycle in all other modes for the data to be sampled by the formatter. 
assign vid_data_out         = ((clk_pixel_cnt != 2'd0)||(~vid_clken_dly)) ? vid_data_in_reg[clk_pixel_cnt*20 +: 20] : vid_data_in[19:0];
//assign vid_data_out         = vid_data_in_int[clk_pixel_cnt*20 +: 20];
assign vid_active_video_out = vid_active_video_in;
assign vid_vblank_out       = vid_vblank_in;
assign vid_hblank_out       = vid_hblank_in;
assign vid_field_id_out     = vid_field_id_in;

generate
  if (C_PPC == 2) begin : generate_2ppc_clken
    assign vid_clken = clk_pixel_cnt[0] & ~(clk_pixel_cnt_dly[0]) & clken;
  end
  else if (C_PPC == 4) begin : generate_4ppc_clken
    assign vid_clken = (clk_pixel_cnt == 2'b11) & ~(clk_pixel_cnt_dly == 2'b11) & clken;
  end
  else begin : generate_1ppc_clken
    assign vid_clken = clken;
  end
endgenerate

endmodule

