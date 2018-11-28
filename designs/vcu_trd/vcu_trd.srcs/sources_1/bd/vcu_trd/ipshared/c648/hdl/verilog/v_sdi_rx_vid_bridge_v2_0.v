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
------------------------------------------------------------------------------
*/

`timescale 1ps/1ps
(* DowngradeIPIdentifiedWarnings="yes" *)

module v_sdi_rx_vid_bridge_v2_0_0 #(
  parameter C_PIXELS_PER_CLOCK = 2,
  parameter C_INCLUDE_3G_SDI_BRIDGE = 1,
  parameter C_INCLUDE_12G_SDI_BRIDGE = 1
) (
  input  wire              clk,
  input  wire              rst,
  //control interface
  input  wire [31:0]       sdi_rx_bridge_ctrl,
  output reg  [31:0]       sdi_rx_bridge_sts,
  // SDI Interface
  input  wire [9:0]        rx_ds1,
  input  wire [9:0]        rx_ds2,
  input  wire [9:0]        rx_ds3,
  input  wire [9:0]        rx_ds4,
  input  wire [9:0]        rx_ds5,
  input  wire [9:0]        rx_ds6,
  input  wire [9:0]        rx_ds7,
  input  wire [9:0]        rx_ds8,
  input  wire              rx_ce,
  input  wire              rx_level_b,
  input  wire [2:0]        rx_mode,
  input  wire              rx_mode_locked,
  // Native Interface
  output wire [3*10*C_PIXELS_PER_CLOCK-1:0]
                           vid_data,		     
  output wire              vid_active_video,    
  output wire              vid_vblank,		    
  output wire              vid_hblank,		    
  output wire              vid_field_id,
  output wire              vid_ce
);

wire        rx_dout_rdy_to_3g;
wire        rx_ce_sd_to_3g;

reg         sdi_bridge_select;

wire [20*C_PIXELS_PER_CLOCK-1:0]
            vid_data_from_3g;
wire        vid_active_from_3g;
wire        vid_vblank_from_3g;
wire        vid_hblank_from_3g;
wire        vid_field_from_3g;
wire        vid_ce_from_3g;

wire [20*C_PIXELS_PER_CLOCK-1:0]
            vid_data_from_12g;
wire        vid_active_from_12g;
wire        vid_vblank_from_12g;
wire        vid_hblank_from_12g;
wire        vid_field_from_12g;
wire        vid_ce_from_12g;

reg ctrl_run;

always @(posedge clk) begin
  //sdi_rx_bridge_ctrl decoding
  ctrl_run  <= sdi_rx_bridge_ctrl[0];

  //sdi_rx_bridge_sts assign 
  sdi_rx_bridge_sts[0] <= sdi_bridge_select;
  sdi_rx_bridge_sts[1] <= rx_mode_locked;
  sdi_rx_bridge_sts[3:2] <= 0;
  sdi_rx_bridge_sts[6:4] <= rx_mode;
  sdi_rx_bridge_sts[7] <= rx_level_b;
  sdi_rx_bridge_sts[31:8] <= 0;
end



// 1/2 duty cycle in 3GB-SDI, otherwise held high
assign rx_dout_rdy_to_3g = (rx_mode == 3'b010 && rx_level_b == 1'b1) ? rx_ce : 1'b1; 
// Cadence 5/6/5/6 in SD-SDI, otherwise held high
assign rx_ce_sd_to_3g    = (rx_mode == 3'b001) ? rx_ce : 1'b1; 

// Mode selection
always @(*) begin
  sdi_bridge_select    = 0;

  case (rx_mode) 
  // HD
  0: begin
    sdi_bridge_select  = 0;
  end
  // SD
  1: begin
    sdi_bridge_select  = 0;
  end
  // 3G Level A/B
  2: begin
    sdi_bridge_select  = 0;
  end
  // 6G/12G 
  default: begin
    sdi_bridge_select  = 1;
  end
  endcase
end

generate if (C_INCLUDE_3G_SDI_BRIDGE) begin : generate_3g_sdi_bridge
// Instantiate SD/HD/3G SDI RX Bridge
v_sdi_rx_vid_bridge_v2_0_0_3g #(
  .C_PPC(C_PIXELS_PER_CLOCK)
) SDI_3G_RX_BRIDGE_INST (
  .rx_usrclk(clk),
  .rst(rst | ~ctrl_run | ~rx_mode_locked),

  .rx_mode(rx_mode[1:0]),          
  .rx_mode_locked(rx_mode_locked),   
  .rx_level_b(rx_level_b),       
  .rx_dout_rdy(rx_dout_rdy_to_3g),      
  .rx_ce_sd(rx_ce_sd_to_3g),         
  .rx_ds1a(rx_ds1),          
  .rx_ds2a(rx_ds2),         
  .rx_ds1b(rx_ds3),         
  .rx_ds2b(rx_ds4),         

  .vid_data(vid_data_from_3g),        
  .vid_active_video(vid_active_from_3g),
  .vid_hblank(vid_hblank_from_3g),      
  .vid_vblank(vid_vblank_from_3g),      
  .vid_field_id(vid_field_from_3g),     
  .vid_ce(vid_ce_from_3g)          
);
end
else
begin
assign   vid_data_from_3g    = 40'd0  ;
assign   vid_active_from_3g  = 1'd0   ;
assign   vid_vblank_from_3g  = 1'd0   ;
assign   vid_hblank_from_3g  = 1'd0   ;
assign   vid_field_from_3g   = 1'd0   ;
assign   vid_ce_from_3g      = 1'd0   ;
end
endgenerate

generate if (C_INCLUDE_12G_SDI_BRIDGE) begin : generate_12g_sdi_bridge
// Instantiate 6G/12G SDI RX Bridge
v_sdi_rx_vid_bridge_v2_0_0_12g #(
  .C_PPC(C_PIXELS_PER_CLOCK),
  .C_VID_DUTY_CYCLE(C_PIXELS_PER_CLOCK/2 - 1),
  .C_SDI_DUTY_CYCLE(1) 
) SDI_12G_RX_BRIDGE_INST (
  .CLK_IN(clk),
  .RST_IN(rst | ~ctrl_run | ~rx_mode_locked),

  .SDI_DS1_IN(rx_ds1),
  .SDI_DS2_IN(rx_ds2),
  .SDI_DS3_IN(rx_ds3),
  .SDI_DS4_IN(rx_ds4),
  .SDI_DS5_IN(rx_ds5),
  .SDI_DS6_IN(rx_ds6),
  .SDI_DS7_IN(rx_ds7),
  .SDI_DS8_IN(rx_ds8),
  .SDI_CE_IN(rx_ce),

  .VID_DATA_OUT(vid_data_from_12g),
  .VID_VALID_OUT(vid_active_from_12g),
  .VID_HBLANK_OUT(vid_hblank_from_12g),
  .VID_VBLANK_OUT(vid_vblank_from_12g),
  .VID_FIELD_ID(vid_field_from_12g),
  .VID_CE_OUT(vid_ce_from_12g),

  .ERROR_OUT()
);
end
else
begin
assign      vid_data_from_12g   = 40'd0;
assign      vid_active_from_12g = 1'd0 ;
assign      vid_vblank_from_12g = 1'd0 ;
assign      vid_hblank_from_12g = 1'd0 ;
assign      vid_field_from_12g  = 1'd0 ;
assign      vid_ce_from_12g     = 1'd0 ;
end
endgenerate

// Output assignments
assign vid_data[2*10*C_PIXELS_PER_CLOCK-1:0]   = (sdi_bridge_select) ? vid_data_from_12g   : vid_data_from_3g; 
assign vid_data[3*10*C_PIXELS_PER_CLOCK-1:2*10*C_PIXELS_PER_CLOCK] = 0; 
assign vid_active_video = (sdi_bridge_select) ? vid_active_from_12g : vid_active_from_3g;
assign vid_vblank       = (sdi_bridge_select) ? vid_vblank_from_12g : vid_vblank_from_3g;
assign vid_hblank       = (sdi_bridge_select) ? vid_hblank_from_12g : vid_hblank_from_3g;
assign vid_field_id     = (sdi_bridge_select) ? vid_field_from_12g  : vid_field_from_3g; 
assign vid_ce           = (sdi_bridge_select) ? vid_ce_from_12g     : vid_ce_from_3g; 

endmodule
