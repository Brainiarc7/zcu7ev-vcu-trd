//-----------------------------------------------------------------------------
//  (c) Copyright 2013 Xilinx, Inc. All rights reserved.
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

This module reformats SDI data with embedded syncs, to Video format,  and blanks
For 3G-SDI Level B, it also stores up incoming lines so that the two lines are output
sequentially.
------------------------------------------------------------------------------
*/

`timescale 1ps/1ps

(* DowngradeIPIdentifiedWarnings="yes" *)
module v_sdi_rx_vid_bridge_v2_0_0_3g_formatter  (
  input             clk,
  input             rst,
  input             rx_ce_sd,        // clock enable for SD-SDI
  input             vid_ce_comb,     // combinatorial video clock enable
  input             vid_ce,          // clock enable for output video
  input             rx_dout_rdy,     // clock enable for 3G level B
  input      [1:0]  rx_mode,         // SDI mode 
  input             rx_mode_locked,  // Flag indicating mode is locked
  input             rx_level_b,      // 3G level B flag
  input             rx_eav,          // End Active Video flag
  input             rx_sav,          // Start Active Video flag
  input             rx_trs,          // Timing Reference Symbol flag
  input      [9:0]  rx_ds1a,         // SDI data stream 1a (c) 
  input      [9:0]  rx_ds2a,         // SDI data stream 2a (y)
  input      [9:0]  rx_ds1b,         // SDI data stream 1b for 3G level B only 
  input      [9:0]  rx_ds2b,         // SDI data stream 2b for 3G level B only 
  input             pre_act_vid,     // unblank signal to from sync_extract

  output reg [9:0]  d1a,             // SDI data after reformatting for mode.
  output reg  [2:0] tim,             // SDI timing data matching d1a
  output reg [19:0] video_data,      // Data formatted for video output.
  output reg        vreg_sel         // input sel. for V1 Register. 1/2 input rate
);
reg           lvl_b_rst;           // reset for level B logic
reg           link_sel;            // link select for 3G-SDI level B. 1 = Link A
reg           rd_ok = 0;           // OK to read from fifo in level B
reg           rd_en_a;             // FIFO A rean enable for level B
reg           rd_en_b;             // FIFO B read enable for level B
reg   [9:0]   v0_1;                // Intermediate registers 
reg   [9:0]   v1_1;       
reg   [19:0]  video_2;        
reg   [19:0]  video_3;         
reg   [19:0]  video_4;        
reg   [19:0]  video_5;        
reg   [9:0]   d2a;
wire  [22:0]  fifo_a_din;
wire  [22:0]  fifo_b_din;
wire  [22:0]  fifo_a_dout;
wire  [22:0]  fifo_b_dout;
wire          fifo_a_empty;
wire          fifo_b_empty;
wire  [10:0]  fifo_a_level;
reg   [11:0]  h_counter;
reg   [11:0]  h_count_1;
reg   [11:0]  h_count_2; 
reg   [10:0]  fifo_a_init_fill = 100;
wire          eol_in;       // FIFO input side end of line flag for level B
wire          eol_out;      // FIFO output side end of line flag for level B 
reg           h_active;     // indicates the period between SAV and EAV
reg   [2:0] tim_1;
reg           link_sel_1; 

assign fifo_a_din = {rx_eav, rx_sav, rx_trs, rx_ds2a, rx_ds1a};
assign fifo_b_din = {rx_eav, rx_sav, rx_trs, rx_ds2b, rx_ds1b};
assign eol_in     = rx_eav;
assign eol_out    = link_sel? fifo_b_dout[22]: fifo_a_dout[22];

// Link A Line FIFO
v_sdi_rx_vid_bridge_v2_0_0_3g_fifo #(
  .RAM_WIDTH (23),
  .RAM_ADDR_BITS (11)
) link_a_fifo (
  .wr_clk    (clk   ),     
  .rd_clk    (clk   ),
  .rst       (lvl_b_rst      ),
  .wr_ce     (rx_dout_rdy),
  .rd_ce     (1'b1),
  .wr_en     (1'b1    ),
  .rd_en     (rd_en_a    ),
  .din       (fifo_a_din    ),

  .dout      (fifo_a_dout     ),
  .empty     (fifo_a_empty),
  .rd_error  ( ),
  .full      ( ),
  .wr_error  ( ),
  .level_rd  (fifo_a_level ),
  .level_wr  ( ) 
);
  
// Link B Line FIFO
v_sdi_rx_vid_bridge_v2_0_0_3g_fifo #(
  .RAM_WIDTH (23),
  .RAM_ADDR_BITS (12)
) link_b_fifo (
  .wr_clk    (clk   ),     
  .rd_clk    (clk   ),
  .rst       (lvl_b_rst      ),
  .wr_ce     (rx_dout_rdy),
  .rd_ce     (1'b1),
  .wr_en     (1'b1    ),
  .rd_en     (rd_en_b    ),
  .din       (fifo_b_din    ),

  .dout      (fifo_b_dout     ),
  .empty     (fifo_b_empty),
  .rd_error  ( ),
  .full      ( ),
  .wr_error  ( ),
  .level_rd  ( ),
  .level_wr  ( ) 
);

/////////////////////////////////////////
// Create vreg_sel
///////////////////////////////////////// 
always @(posedge clk) begin
  if (rst)
    vreg_sel <= 0;
  else begin
    if (rx_mode == 1) begin
      if (rx_ce_sd)
        if (rx_sav)
          vreg_sel <= 0;
    else 
      vreg_sel <= !vreg_sel;
    end 
    else
      vreg_sel <= 0;      // for non-SD, pass data straight through.
  end  
end   

//////////////////////////////////////////////
// Horiz. Counter, and lvl_b_rst  for level_b
//////////////////////////////////////////////
always @(posedge clk) begin
  if (rst) begin      
    lvl_b_rst <= 1;
    h_counter  <= 1;
    h_count_1 <=0;
    h_count_2 <=0;
    fifo_a_init_fill <= 100;
  end  
  else if (rx_dout_rdy) begin
    if (rx_sav)   begin
      h_counter <= 1;
      h_count_1 <= h_counter;
      h_count_2 <= h_count_1;
    end
    else begin
      h_counter <= h_counter + 1;
    end
        
    if ( !rx_mode_locked || (!lvl_b_rst & h_count_2 != h_count_1)) begin
      lvl_b_rst <= 1;
      fifo_a_init_fill <= (h_count_1 >> 1) + 16;
    end
    else
      lvl_b_rst <= 0;
  end     
end

/////////////////////////////////////////
// B select logic
/////////////////////////////////////////
always @(posedge clk) begin
  if (rst)  begin
    tim_1    <= 0;
    h_active <= 0;
    link_sel <= 0;
    link_sel_1 <= 0;
    rd_en_a  <= 0;
    rd_en_b  <= 0;
  end
  else begin
    tim_1 <= tim;
    link_sel_1 <= link_sel;

    if (tim == 3)         // SAV
      h_active <= 1;
    else if ((h_active && tim[0] && !tim_1[0]) || lvl_b_rst)       //EAV or mode change
      h_active <= 0;

    if (rx_mode == 2 && rx_level_b) begin   // link_sel
      if (h_active && tim[0] && !tim_1[0] ) // toggle  at the next TRS after active (EAV)
        link_sel <= !link_sel;
    end
    else
      link_sel <= 0;

    if (lvl_b_rst)          //rd_ok
      rd_ok <= 0;
    else if (fifo_a_level >= fifo_a_init_fill)
      rd_ok <= 1;
  
    if (rd_ok) begin          // read enables
      if (link_sel) begin
        rd_en_a <= 0;
        rd_en_b <= 1;
      end
      else begin
        rd_en_a <= 1;
        rd_en_b <= 0;
      end
    end
    else begin
      rd_en_a <= 0;
      rd_en_b <= 0;
    end

  end // if not reset
end    

/////////////////////////////////////////
// Registers
///////////////////////////////////////// 
always @(posedge clk) begin
  if (rst) begin
    tim <= 0;
    d1a <= 0;
    d2a <= 0;
    v0_1  <= 0;
    v1_1  <= 0;
    video_2  <= 0;
    video_3  <= 0;
    video_4  <= 0;
    video_5  <= 0;
    video_data <= 0;
  end
  else if (rx_ce_sd) begin
    //  d1a, d2a
    if (rx_mode ==2 && rx_level_b) begin   // level b
        if (link_sel_1)  begin
          tim <= fifo_b_dout[22:20];
          d2a <= fifo_b_dout[19:10];
          d1a <= fifo_b_dout[9:0];
        end
        else begin
          tim <= fifo_a_dout[22:20];
          d2a <= fifo_a_dout[19:10];
          d1a <= fifo_a_dout[9:0];
        end
    end
    else begin
      tim <= {rx_eav, rx_sav, rx_trs};       // otherwise
      d2a <= rx_ds2a;
      d1a <= rx_ds1a;
    end

    //  v0_1, v1_1
    if (rx_mode == 1) begin           // SD mode
      if (rx_ce_sd) begin
        if (vreg_sel) begin
          v1_1 <= d1a;
        end
        else begin
          v0_1 <= d1a;
        end
      end
    end // SD mode
    else begin   // non SD mode
      v1_1 <= d2a;
      v0_1 <= d1a;
    end   // non SD mode
  end

  // other video delay and output registers
  if (vid_ce_comb) begin
    video_2 <= {v1_1, v0_1};
  end
  if (vid_ce) begin
    video_3 <= video_2;
    video_4 <= video_3;

    if (rx_mode == 1 || (rx_mode == 2 && rx_level_b))  // SD or level B
      video_5 <= video_4;
    else 
      video_5 <= video_3;

    if (pre_act_vid) begin  
      if (rx_mode == 1)
        video_data <= video_3;
      else 
        video_data <= video_5;
    end 
    else
      video_data <= 0;     // blank video when not active.
    end
  end 

endmodule
