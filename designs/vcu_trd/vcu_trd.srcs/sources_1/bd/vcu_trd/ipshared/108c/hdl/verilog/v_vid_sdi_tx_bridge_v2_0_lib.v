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

module v_vid_sdi_tx_bridge_v2_0_0_lib_sync_fifo #(
  parameter C_FIFO_WRITE_DEPTH      =    2048,             
  parameter C_WRITE_DATA_WIDTH      =    32,               
  parameter C_WR_DATA_COUNT_WIDTH   =    12,               
  parameter C_PROG_FULL_THRESH      =    10,               
  parameter C_FULL_RESET_VALUE      =    0,                
  parameter C_READ_MODE             =    "std",            
  parameter C_FIFO_READ_LATENCY     =    1,               
  parameter C_READ_DATA_WIDTH       =    32,             
  parameter C_RD_DATA_COUNT_WIDTH   =    12,             
  parameter C_PROG_EMPTY_THRESH     =    10,             
  parameter C_DOUT_RESET_VALUE      =    "0"              
) (
  input  wire CLK_IN,
  input  wire RST_IN,

  // Write 
  input  wire WR_EN_IN,
  input  wire [C_WRITE_DATA_WIDTH-1:0] D_IN,

  output wire FULL_OUT,
  output wire [C_WR_DATA_COUNT_WIDTH-1:0] WR_DATA_COUNT_OUT,
  output wire OVERFLOW_OUT,
  output wire WR_RST_BUSY_OUT,

  // Read
  input  wire RD_EN_IN,
  output wire [C_WRITE_DATA_WIDTH-1:0] D_OUT,

  output wire EMPTY_OUT,
  output wire [C_RD_DATA_COUNT_WIDTH-1:0] RD_DATA_COUNT_OUT,
  output wire UNDERFLOW_OUT,
  output wire RD_RST_BUSY_OUT
);

// XPM Synchronous FIFO
xpm_fifo_sync # (
  .FIFO_MEMORY_TYPE          ("distributed"),      
  .ECC_MODE                  ("no_ecc"),         
  .FIFO_WRITE_DEPTH          (C_FIFO_WRITE_DEPTH),  
  .WRITE_DATA_WIDTH          (C_WRITE_DATA_WIDTH),   
  .WR_DATA_COUNT_WIDTH       (C_WR_DATA_COUNT_WIDTH), 
  .PROG_FULL_THRESH          (10),               
  .FULL_RESET_VALUE          (C_FULL_RESET_VALUE),  
  .READ_MODE                 (C_READ_MODE),        
  .FIFO_READ_LATENCY         (C_FIFO_READ_LATENCY),   
  .READ_DATA_WIDTH           (C_READ_DATA_WIDTH),     
  .RD_DATA_COUNT_WIDTH       (C_RD_DATA_COUNT_WIDTH), 
  .PROG_EMPTY_THRESH         (C_PROG_EMPTY_THRESH),   
  .DOUT_RESET_VALUE          (C_DOUT_RESET_VALUE),    
  .WAKEUP_TIME               (0)                
) xpm_fifo_sync_inst (
  .sleep            (1'b0),
  .rst              (RST_IN),
  .wr_clk           (CLK_IN),
  .wr_en            (WR_EN_IN),
  .din              (D_IN),
  .full             (FULL_OUT),
  .prog_full        (),
  .wr_data_count    (WR_DATA_COUNT_OUT),
  .overflow         (OVERFLOW_OUT),
  .wr_rst_busy      (WR_RST_BUSY_OUT),
  .rd_en            (RD_EN_IN),
  .dout             (D_OUT),
  .empty            (EMPTY_OUT),
  .prog_empty       (),
  .rd_data_count    (RD_DATA_COUNT_OUT),
  .underflow        (UNDERFLOW_OUT),
  .rd_rst_busy      (RD_RST_BUSY_OUT),
  .injectsbiterr    (1'b0),
  .injectdbiterr    (1'b0),
  .sbiterr          (),
  .dbiterr          ()
);

endmodule

module v_vid_sdi_tx_bridge_v2_0_0_lib_sync_bus #(
  parameter C_DATA_WIDTH = 32
) (
  input  wire SRC_CLK_IN,
  input  wire [C_DATA_WIDTH-1:0] SRC_DATA_IN,
  input  wire DST_CLK_IN,
  output wire [C_DATA_WIDTH-1:0] DST_DATA_OUT
);

reg  src_send = 1'b1;
wire src_rcv;

// Send logic
always @(posedge SRC_CLK_IN) begin
   if (src_rcv) 
     src_send <= 1'b0;
   else 
     src_send <= 1'b1;
end

// XPM bus synchronizer with full handshake
xpm_cdc_handshake #(
  .DEST_EXT_HSK   (0), 
  .DEST_SYNC_FF   (4),
  .SIM_ASSERT_CHK (0),
  .SRC_SYNC_FF    (4),
  .WIDTH          (C_DATA_WIDTH) 
) xpm_cdc_handshake_inst (

  .src_clk  (SRC_CLK_IN),
  .src_in   (SRC_DATA_IN),
  .src_send (src_send),
  .src_rcv  (src_rcv),
  .dest_clk (DST_CLK_IN),
  .dest_req (),
  .dest_ack (1'b0), 
  .dest_out (DST_DATA_OUT)
);

endmodule

`default_nettype wire
