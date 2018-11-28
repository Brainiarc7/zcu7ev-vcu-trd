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

This module reformats video data to SDI format, with embedded syncs and blanks
For 3G-SDI Level B, it also stores up incoming lines so that two lines are output
in parallel.
------------------------------------------------------------------------------
*/

`timescale 1ps/1ps

(* DowngradeIPIdentifiedWarnings="yes" *)
module v_vid_sdi_tx_bridge_v2_0_0_3g_formatter (
  input             clk,
  input             rst,
  input             vid_ce,			  // video side clock enable
  input             tx_ce_sd,         // SDI side clock enable
  input             output_ce,      // clock enable for output section
  input     [1:0]   tx_mode,          // sdi mode
  input             tx_level_b,       // SDI mode indicator for 3G-SDI level B
  input             tx_din_rdy,       // clock enable for 3G level B  
  input  [19:0]     video_data,		  // parallel video data.  2 components, 10 bits
  input             active_video,	  // valid data control signal
  input             vblank,			  // vertical blank
  input             hblank,			  // horizontal blank
  input	            field_id,		  // field ID
  output reg [9:0]  tx_ds1a,          // SDI Data stream 1a (c)
  output reg [9:0]  tx_ds2a,          // SDI Data stream 2a (y)
  output reg [9:0]  tx_ds1b,          // SDI Data stream 1b for 3G level B only
  output reg [9:0]  tx_ds2b,          // SDI Data stream 2b for 3G level B only 
  // Video format 
  // 00 - 4:2:2
  // 01 - 4:2:0
  // 10 - Reserved
  // 11 - Reserved
  input  wire [1:0] vid_frmt,
  output     [3:0]  lev_b_tim 		  // timing signals for level B only. F,V,H,A
  );
  reg           link_sel = 0; // link select for 3G-SDI level B. 1 = Link A
  reg   [9:0]	v0;			  // Intermediate registers 
  reg   [9:0]   v1;
  reg   [9:0]   vid_a_c;
  reg   [9:0]   vid_a_y;
  wire  [19:0]  fifo_a_out;
  wire  [23:0]  fifo_b_out;
  reg   [19:0]  fifo_a_out_1 = 0;
  reg   [23:0]  fifo_b_out_1 = 0;
  reg   [19:0]  fifo_a_out_2 = 0;
  reg   [23:0]  fifo_b_out_2 = 0;
  wire  [19:0]  vid_a;        // contenation of vid_a_c and vid_a_y 
  wire          fifo_b_empty;
  reg           b_empty_1 = 0;
  reg           b_empty_2 = 0;
  reg           b_empty_3 = 0;
  reg           b_empty_4 = 0;
  reg           b_empty_5 = 0;
  wire  [10:0]  fifo_b_level_rd;
  wire  [10:0]  fifo_b_level_wr;
  wire          fifo_a_wr_en;
  wire          fifo_b_wr_en;
  reg           wr_a_sr_ff;
  reg           wr_b_sr_ff;
  reg           rd_a_sr_ff;
  reg           rd_b_sr_ff;
  reg           wait_v_fall;
  reg           wait_h_fall;
  wire          fifo_a_rd_en;
  wire          fifo_b_rd_en;
  reg           y_mux_sel = 0;
  reg           vblank_1 = 0;
  reg           vblank_2 = 0;
  reg           vblank_3 = 0;
  reg           vblank_4 = 0;
  reg           hblank_1 = 0;
  reg           hblank_2 = 0;
  reg           hblank_3 = 0;
  reg           hblank_4 = 0;
  reg           hblank_5 = 0;
  reg           hblank_6 = 0;
  reg           hblank_7 = 0;
  reg           hblank_8 = 0;
  reg           hblank_9 = 0;
  reg           hblank_10 = 0;
  reg           b_rd_1  = 0;
  reg           b_rd_2  = 0;
  reg           b_rd_3  = 0;
  reg           b_rd_4  = 0;
  reg           b_rd_5  = 0;
  reg           b_rd_6  = 0;
  reg           b_rd_7  = 0;
  reg           active_video_1 = 0;
  reg           active_video_2 = 0;
  reg           field_id_1 = 0;
  reg           field_id_2 = 0;
  wire          hblank_rising_early;
  wire          hblank_rising_late;
  wire          vblank_falling;
  wire  [23:0]  fifo_b_in;
  reg           lev_b_vblank_1 = 0;
  reg           lev_b_hblank_1 = 0;
  reg           lev_b_active_1 = 0;
  reg           lev_b_field_1  = 0;
  reg           first_sof     = 0;

  assign fifo_b_in = {field_id_1,vblank_1, hblank_1,active_video_1,vid_a};
  assign hblank_rising_early = hblank_3 && !hblank_4;
  assign vblank_falling       = !vblank_2 && vblank_3;
  assign hblank_rising_late  = hblank_9 & !hblank_10;

  // Link A Line FIFO
  v_vid_sdi_tx_bridge_v2_0_0_3g_fifo #(
    .RAM_WIDTH  (20),
    .RAM_ADDR_BITS  (11)
  )
  link_a_fifo
  (
    .wr_clk	   (clk   ),     
	.rd_clk    (clk   ),
	.rst       (rst      ),
	.wr_ce     (1'b1   ),
	.rd_ce     (1'b1   ),
	.wr_en     (fifo_a_wr_en    ),
	.rd_en     (fifo_a_rd_en    ),
	.din       (vid_a    ),

	.dout      (fifo_a_out     ),
	.empty     ( ),
	.rd_error  ( ),
	.full      ( ),
	.wr_error  ( ),
	.level_rd  ( ),
	.level_wr  ( ) 
   );

  // Link B Line FIFO
  v_vid_sdi_tx_bridge_v2_0_0_3g_fifo #(
    .RAM_WIDTH (24),
    .RAM_ADDR_BITS (11)
  )
  link_b_fifo
  (
    .wr_clk	   (clk   ),     
	.rd_clk    (clk   ),
	.rst       (rst      ),
	.wr_ce     (1'b1   ),
	.rd_ce     (1'b1   ),
	.wr_en     (fifo_b_wr_en    ),
	.rd_en     (fifo_b_rd_en    ),
	.din       (fifo_b_in    ),

	.dout      (fifo_b_out     ),
	.empty     (fifo_b_empty    ),
	.rd_error  ( ),
	.full      ( ),
	.wr_error  ( ),
	.level_rd  (fifo_b_level_rd ),
	.level_wr  (fifo_b_level_wr ) 
   );

  
  assign lev_b_tim = {lev_b_field_1, lev_b_vblank_1, lev_b_hblank_1, lev_b_active_1};
  assign vid_a = {vid_a_c,vid_a_y};
  assign fifo_a_wr_en = first_sof &(!wait_h_fall & wr_a_sr_ff & !link_sel);
  assign fifo_b_wr_en = first_sof &(!wait_h_fall & (wr_b_sr_ff & link_sel 
         || (link_sel &  hblank_3 & !hblank_6) //write 3 extra at end of link a
		 || (link_sel & !hblank_1 & hblank_2) // write 1 extra befor start of link b
         )
         ); 
  assign fifo_a_rd_en = !wait_h_fall & rd_a_sr_ff & tx_din_rdy;
  assign fifo_b_rd_en = !wait_h_fall & rd_b_sr_ff & tx_din_rdy;

  always @ (posedge clk) begin
	b_empty_1 <= fifo_b_empty;
	b_empty_2 <= b_empty_1;
	b_empty_3 <= b_empty_2;
	b_empty_4 <= b_empty_3;
	b_empty_5 <= b_empty_4;
  end

  always @ (posedge clk) begin		// startup logic
   if (rst || tx_mode != 2 || !tx_level_b ) begin
	  wait_v_fall <= 1;
	  wait_h_fall <= 1;
	  end
	else begin
	  if (!vblank_1 & vblank_2)
	    wait_v_fall <= 0;
	  if (!wait_v_fall & !hblank_1 & hblank_2)
	    wait_h_fall <= 0;
	end
  end

  always @ (posedge clk) begin          // read logic
	if (rst) begin	  
	  rd_a_sr_ff <= 0;
	  rd_b_sr_ff <= 0;
	end
	else if (tx_din_rdy) begin 

	  if(!fifo_b_wr_en && fifo_b_level_rd == 1)	//FIFO almost empty  
	    rd_a_sr_ff <= 0;
	  else if (b_rd_3 && !b_rd_4)			
	    rd_a_sr_ff <= 1; 
    
	  if (!fifo_b_wr_en && fifo_b_level_rd == 1)	  
	    rd_b_sr_ff <= 0;
      else if (fifo_b_wr_en && fifo_b_level_wr >= 10)	 // after startup, start reading b 6 states
        rd_b_sr_ff <= 1; 	     // to fill up the pipe with valid data
    end
  end

  always @ (posedge clk) begin			//write logic
    if (rst || hblank_1 & !hblank_2)
	  wr_a_sr_ff <= 0;
	else if (!hblank_1 && hblank_2)
	  wr_a_sr_ff <= 1;

    if (rst || hblank_1 & !hblank_2)	 
	  wr_b_sr_ff <= 0;				 
	else if ( !hblank_1 && hblank_2)
	  wr_b_sr_ff <= 1;
	  
  end

  always @ (posedge clk) begin
    if (rst)
	  y_mux_sel <= 0;
	else begin
	  if (tx_mode == 1) begin
	    if (tx_ce_sd) begin
		  if (vid_ce)
		    y_mux_sel <= 1;
		  else
		    y_mux_sel <= 0;
		         
		end
	  end  // tx_mode = 1
	  else 	// tx_mode /= 1
	    y_mux_sel <= 0;

	end	// not reset
  end

  always @ (posedge clk)  begin
    if (rst) begin
	  v1 <= 10'h200;
	  v0 <= 10'h200;
	  vblank_1 <= 0;
	  hblank_1 <= 0;
	  active_video_1 <= 0;
	  field_id_1 <= 0;
	end
	else if(vid_ce) begin
	  vblank_1       <= vblank;
	  hblank_1       <= hblank;
      active_video_1 <= active_video;
	  field_id_1     <= field_id;
   // Clamp v1 register
	  if (video_data[19:10] < 10'h004)	    // low clamp
	  	    v1 <= 10'h004;
	  else if (video_data[19:10] > 10'h3FB) // high clamp
		v1 <= 10'h3FB;
      else
	    v1 <= video_data[19:10];
   									  // Clamp v0 register
      if (video_data[9:0] < 10'h004)      // low clamp
	    v0 <= 10'h004;
	  else if (video_data[9:0] > 10'h3FB) // high clamp
	    v0 <= 10'h3FB;
	  else
	    v0 <= video_data[9:0]; 
	end	  // if !rst
  end     //always	

  always @ (posedge clk) begin
	if (rst) begin
	  vid_a_c        <= 10'h200;
	  vid_a_y        <= 10'h200;
	  vblank_2       <= 0;
	  vblank_3       <= 0;
	  vblank_4       <= 0;
	  hblank_2       <= 0;
	  hblank_3       <= 0;
	  hblank_4       <= 0;
	  hblank_5       <= 0;
	  hblank_6       <= 0;
	  hblank_7       <= 0;
	  hblank_8       <= 0;
	  hblank_9       <= 0;
	  hblank_10      <= 0;
	  active_video_2 <= 0;
    end
	else if (tx_ce_sd) begin  //!rst
	  vblank_2       <= vblank_1;
	  vblank_3       <= vblank_2;
	  vblank_4       <= vblank_3;
	  hblank_2       <= hblank_1;
	  hblank_3       <= hblank_2;
	  hblank_4		 <= hblank_3;
	  hblank_5		 <= hblank_4;
	  hblank_6		 <= hblank_5;
	  hblank_7		 <= hblank_6;
	  hblank_8		 <= hblank_7;
	  hblank_9		 <= hblank_8;
	  hblank_10		 <= hblank_9;

  	  if (hblank_1 || vblank_1) begin
	    vid_a_c <= 10'h200;
		vid_a_y <= 10'h200;
	  end
	  else begin
	    vid_a_c <= v1;
        if (y_mux_sel)
	      vid_a_y <= v1;
        else
	      vid_a_y <= v0; 
	  end     	   
	end  //if !rst
  end	 //always
 
  always @ (posedge clk) begin
    if (rst) begin
	  tx_ds2a <= 10'h200;
	  tx_ds1a <= 10'h200;
	  tx_ds2b <= 10'h200;
	  tx_ds1b <= 10'h200;
	end
	else if (output_ce)begin
      if (tx_mode == 2 && tx_level_b) begin
          //vid_frmt == 2'b01 implies 4:2:0 format. 4:2:0 is only valid in 2160 line resolution and 
          //it is possible only in 3G Dual link mode apart from 6G and 12G modes. 
          //This 3G Dual link mode will use 3G Level-B data streams for 2160 line resolution.
          //So we will have total 4 data streams per link and one of the link
          //will accomodate only odd lines of the actual frame. 
          //Since all the chroma values of odd lines of actual frame should be
          //10'h200 in 4:2:0,making Chroma values of all the lines in this mode to 10'h200.
          //If this link is chosen to accomodate odd lines in the dual link
          //mode,vid_frmt will be made 2'b01.
          if(vid_frmt == 2'b01)                  
          begin
    	    tx_ds2a <= 10'h200;
            tx_ds1a <= fifo_a_out_2[9:0];
    	    tx_ds2b <= 10'h200;
    	    tx_ds1b <= fifo_b_out_2[9:0];
          end
          else
          begin
    	    tx_ds2a <= fifo_a_out_2[19:10];
            tx_ds1a <= fifo_a_out_2[9:0];
    	    tx_ds2b <= fifo_b_out_2[19:10];
    	    tx_ds1b <= fifo_b_out_2[9:0];
          end

      end  
      else begin
    	 tx_ds2a <= vid_a_c;
    	 tx_ds1a <= vid_a_y;
    	 tx_ds2b <= 0;
    	 tx_ds1b <= 0;
      end  //else
	end
  end  //always

  // link_sel logic.  link sel only toggles in 3G level B 
  // at the start of active video lines.
  // first_sof ensures startup happens at the start of a full frame  
  // vblank must toggle coincident with rising edge of hsync.
  always @ (posedge clk) begin
    if (rst)  begin
	  link_sel <= 0;
	  first_sof <= 0;
	end
	else if (!vblank_2 && vblank_3)	begin   // vblsnk falling
	    link_sel <= 0;
		first_sof <= 1;
	end
	else if (hblank_2 && !hblank_3  && tx_mode == 2 && tx_level_b
	  && first_sof)	begin
	    link_sel <= !link_sel;
      end
  end  
  // timing logic
  // vblank and field_id are sampled at hblank rising and remain constant 
  // through the line.  This is so that they are always reflect the link b values.	
  always @ (posedge clk) begin
    if(rst) begin
	  lev_b_vblank_1 <= 0;
	  lev_b_hblank_1 <= 0;
	  lev_b_active_1 <= 0;
	  lev_b_field_1	 <= 0;
	end
    else if (tx_din_rdy) begin
      lev_b_active_1 <= fifo_b_out[20];
	  lev_b_hblank_1 <= fifo_b_out[21];
	  if (fifo_b_out[21] && !lev_b_hblank_1) begin  // hblank_rising
		lev_b_vblank_1 <= fifo_b_out[22];
		lev_b_field_1  <= fifo_b_out[23];
	  end
    end  
  end

  always @ (posedge clk) begin
    if (rst) begin
	  b_rd_1  <= 0;
	  b_rd_2  <= 0;
	  b_rd_3  <= 0;
	  b_rd_4  <= 0;
	  b_rd_5  <= 0;
	  b_rd_6  <= 0;
	  b_rd_7  <= 0;
	  fifo_a_out_1 <= 20'h80200;
	  fifo_b_out_1 <= 23'h80200;
	  fifo_a_out_2 <= 20'h80200;
	  fifo_b_out_2 <= 23'h80200;
	end
    else if (tx_din_rdy) begin
	  b_rd_1  <=  fifo_b_rd_en;
	  b_rd_2  <=  b_rd_1;
	  b_rd_3  <=  b_rd_2;
	  b_rd_4  <=  b_rd_3;
	  b_rd_5  <=  b_rd_4;
	  b_rd_6  <=  b_rd_5;
	  b_rd_7  <=  b_rd_6;
	  if (lev_b_hblank_1 || lev_b_vblank_1) begin
		fifo_a_out_1[19:0] <=  20'h80200;
		fifo_b_out_1[19:0] <=  20'h80200;
	  end
	  else begin
	    fifo_a_out_1 <= fifo_a_out;
	    fifo_b_out_1 <= fifo_b_out;
	  end 

	 fifo_a_out_2 <= fifo_a_out_1;
	 fifo_b_out_2 <= fifo_b_out_1;
	end 
  end


endmodule
