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
//  This module embeds syncs and line numbers on the SDI data stream.  
//  It creates line numbers, and embeds them with the EAV .
//
//-----------------------------------------------------------------------------

`timescale 1 ps	/ 1ps

(* DowngradeIPIdentifiedWarnings="yes" *)
module v_vid_sdi_tx_bridge_v2_0_0_3g_embeddder #(
  parameter C_SIM_MODE = 0
) (
  input		        clk,
  input             rst,
  input             output_ce,	      // clock enable for output section
  input     [1:0]   tx_mode,             // sdi mode
  input             tx_level_b,       // SDI mode indicator for 3G-SDI level B
  input             vblank,			  // vertical blank
  input             hblank,			  // horizontal blank
  input             field_id,         // field_id bit
  input      [9:0]  tx_ds1a,          // SDI Data stream 1a (c)
  input	     [9:0]  tx_ds2a,          // SDI Data stream 2a (y)
  input	     [9:0]  tx_ds1b,          // SDI Data stream 1b for 3G level B only
  input	     [9:0]  tx_ds2b,          // SDI Data stream 2b for 3G level B only
  input      [3:0]  lev_b_tim,        // timing signals for level B only, F,V,H,A

  output reg [9:0]  tx_video_a_y,     // SDI data atream c with TRS and line #s
  output reg [9:0]  tx_video_a_c,     // SDI data stream y with TRS and line #s
  output reg [9:0]  tx_video_b_y,     // SDI data atream Bc with TRS and line #s
  output reg [9:0]  tx_video_b_c,     // SDI data stream By with TRS and line #s
  output wire [10:0] tx_line,
  output reg        eav,
  output reg        sav,
  output reg        trs
);
				   
  reg        [9:0]  trs_data;
  reg        [12:0] line_count;
  reg        [3:0]  offset;
  reg        [1:0]  mux_sel;		  // output mux select 0= pass thru,1 = TRS
									  // 2 = line num. LSBs, 3= line num. MSBs
  reg               hblank_1;		  // delay register for hblank
  reg               vblank_1;         // delay register for vblank
  wire              hblank_rising;
  reg              hblank_rising_d1;
  wire              hblank_falling;
  wire              vblank_rising;
  reg               vblank_rising_d1;
  wire              vblank_falling;
  reg               trs_type;		  // TRS type flag 0 = SAV, 1= EAV
  reg       [3:0]   trs_state;		  // TRS state counter
  reg               sav_active;		  // flag: SAV active 
  reg               eav_active;		  // flag: EAV active
  reg               sav_xyz;	      // flag; XYZ of SAV
  reg               eav_xyz;          // flag: XYZ of EAV
  reg       [9:0]   xyz;			  // xyz value
  reg      [12:0]   line_number;      // line number for embedding
  reg      [12:0]   total_lines;	  // emperical total lines for line # calc.
  reg       [9:0]   tx_ds1a_1;
  reg		[9:0]   tx_ds2a_1;
  reg		[9:0]   tx_ds1b_1;
  reg		[9:0]   tx_ds2b_1;
  reg       [9:0]   tx_ds1a_2;
  reg		[9:0]   tx_ds2a_2;
  reg		[9:0]   tx_ds1b_2;
  reg		[9:0]   tx_ds2b_2;
  reg               field_id_mux;
  reg               field_id_mux2; //this is field_id to set line 1.
reg               field_id_mux2_d1; //this is field_id delayed by 1 line. 
reg               field_id_mux2_d2; //this is field_id delayed by 2 lines. 
reg               field_id_mux2_d3; //this is field_id delayed by 3 lines. 
wire              field_id_mux2_final; //cunhua: to fix VTC sending out active data before vblank issue for same field_id value by play around field_id.
  reg               vblank_mux;
  reg               hblank_mux;
  reg               field_id_del;
  reg               hblank_del;
  reg               vblank_del;
  reg               interlace;

  assign tx_line = line_number[10:0]; 
  
  assign hblank_rising  = hblank_mux & !hblank_1;
  assign hblank_falling = !hblank_mux& hblank_1;
  assign vblank_rising  = vblank_mux  & !vblank_1;

  always @ (tx_mode or tx_level_b or lev_b_tim or field_id or vblank or hblank or field_id_del
            or hblank_del or vblank_del) begin
    if (tx_mode == 2 && tx_level_b) begin	 // 3G Level B
	  field_id_mux  = lev_b_tim[3];
	  vblank_mux    = lev_b_tim[2];
	  hblank_mux    = lev_b_tim[1];
	end
	else if (tx_mode == 1) begin			 // SD (delay to match video delay at V0,V1)
	  field_id_mux  = field_id_del;
	  vblank_mux    = vblank_del;
	  hblank_mux    = hblank_del;
	end
	else begin								 // HD and 3G Level A
	  field_id_mux  = field_id;
	  vblank_mux    = vblank;
	  hblank_mux    = hblank;
	end
  end	

///////////////////////////////////////
//  TRS Generator
///////////////////////////////////////
//cunhua: in HD interlace mode, field_id delay by 2 in field 1 and by 3 in field 2;
//cunhua: in SD mode, field_id delay by 2 for both fields.
assign field_id_mux2_final =  (tx_mode == 2'b00 && field_id_mux2 == 1'b1) ?   field_id_mux2_d3 : field_id_mux2_d2;

always @ (posedge clk) begin
  if (rst) begin
    hblank_1   <= 0;
	vblank_1   <= 0;
	trs_type   <= 0;
	trs_state  <= 0;
	sav_active <= 0;
	eav_active <= 0;
	sav_xyz    <= 0;	
	eav_xyz    <= 0;
	trs_data   <= 0;
	xyz        <= 0;
	field_id_mux2 <= 0;
	field_id_mux2_d1 <= 0;
	field_id_mux2_d2 <= 0;
	field_id_mux2_d3 <= 0;
	vblank_rising_d1 <= 0;
	hblank_rising_d1 <= 0;
	interlace <= 0;
  end
  else if (output_ce) begin
    field_id_del <= field_id;
	hblank_del 	 <=  hblank;
	vblank_del 	 <=  vblank;

    hblank_1 <= hblank_mux;
    vblank_1 <= vblank_mux;
    vblank_rising_d1 <= vblank_rising;
    hblank_rising_d1 <= hblank_rising;
	if(field_id) begin
		interlace <= 1'b1;
	end
	//cunhua: VTC output active data first then vblank when field_id value is same.
	//cunhua: bridge have inverse understanding on this.
	//cunhua: here to invert field when vblank is high.
	if((interlace == 1'b1) || field_id) begin
	     if (vblank_rising == 1'b1) begin
		field_id_mux2 <= ~field_id_mux;
	     end
	end else begin
	        field_id_mux2 <= field_id_mux;
	end
	//delay field_id_mux2 by two lines
	if(hblank_rising) begin
	  field_id_mux2_d1 <= field_id_mux2;
	  field_id_mux2_d2 <= field_id_mux2_d1;
	  field_id_mux2_d3 <= field_id_mux2_d2;
	end

    // XYZ logic
	//case ({field_id_mux, vblank_mux, trs_type})
	//cunhua: here use delayed version field_id_mux2_final to insert
	//cunhua: xyz with correct field_id info.
	case ({field_id_mux2_final, vblank_mux, trs_type})
 	  3'b000: xyz <= 10'h200;   // F0 SAV
 	  3'b001: xyz <= 10'h274;   // F0 EAV
 	  3'b010: xyz <= 10'h2AC;   // F0 vblank SAV
 	  3'b011: xyz <= 10'h2D8;   // F0 vblank EAV
 	  3'b100: xyz <= 10'h31C;   // F1 SAV
 	  3'b101: xyz <= 10'h368;   // F1 EAV
 	  3'b110: xyz <= 10'h3B0;   // F1 vblank SAV
 	  3'b111: xyz <= 10'h3C4;   // F1 vblank EAV
	  default: xyz <= 10'h000;
	endcase

    // TRS counter
	if (hblank_falling || hblank_rising)
	  trs_state <= 1;
	else  if (trs_state >= 10)
	    trs_state <= 0;
	else if (trs_state != 0)
	    trs_state <= trs_state + 1;

	sav_active <= 0;             //defaults
	eav_active <= 0;
    // SAV initial state
	if (hblank_falling)	begin    // initial SAV state
	  trs_type  <= 0;
	  sav_active <= 1;
	  sav_xyz   <= 0;
	  trs_data  <= 10'h3FF;
    end
	// EAV initial state	
	else if (hblank_rising)	begin    // initial EAV state
	  trs_type  <= 1;
	  eav_active <= 0;
	  eav_xyz   <= 0;
	  trs_data  <= 10'h000;
    end
	else if (trs_type == 0) begin // subsequent SAV States
	  case (trs_state)
		1: begin
		  sav_active <=1;
	      sav_xyz   <= 0;
		  trs_data	 <=10'h000;
		end
		2: begin
		  sav_active <=1;
	      sav_xyz   <= 0;
		  trs_data	 <=10'h000;
		end
		3: begin
		  sav_active <=1;
	      sav_xyz   <= 1;
		  trs_data	 <=xyz;
		end
	    default: begin
		  sav_active <= 0;
	      sav_xyz   <= 0;
	      trs_data <= 10'h000;
	    end
	  endcase
	end 

	else if (trs_type == 1) begin // subsequent EAV States
	  case (trs_state)
		4: begin
		  eav_active <=1;
	      eav_xyz   <= 0;
		  trs_data	 <=10'h3FF;
		end
		5: begin
		  eav_active <=1;
	      eav_xyz   <= 0;
		  trs_data	 <=10'h000;
		end
		6: begin
		  eav_active <=1;
	      eav_xyz   <= 0;
		  trs_data	 <=10'h000;
		end
		7: begin
		  eav_active <=1;
	      eav_xyz   <= 1;
		  trs_data	 <= xyz;
		end
		8: begin
		  eav_active <=1;
	      eav_xyz   <= 0;
		  trs_data	 <= {!line_number[6], line_number[6:0],2'b00};
		end
		9: begin
		  eav_active <=1;
	      eav_xyz   <= 0;
		  trs_data	 <= {4'b1000, line_number[10:7],2'b00};
		end
	    default: begin
		  eav_active <= 0;
	      eav_xyz   <= 0;
	      trs_data <= 10'h000;
	    end
	  endcase
	end 


  end 	//
end
///////////////////////////////////////


///////////////////////////////////////
//  Line Counter 
///////////////////////////////////////
  always @(posedge clk) begin
    if (rst) begin
	  line_count <= 0;
	  total_lines <= 0;
	end
    else if (output_ce) begin
      //if (vblank_rising && !field_id_mux)	begin
	  //cunhua: here use non-delayed version of field_id_mux2 to dertermin line 1.
      if (vblank_rising_d1 && !field_id_mux2)	begin
  	    total_lines <= line_count;
        line_count <= 1;
  	  end
  	  else if (hblank_rising_d1) begin
  	    line_count <= line_count + 1;
  	  end
  	end
  end
///////////////////////////////////////
/// Line Number Look Up	 
///////////////////////////////////////
generate
if (C_SIM_MODE == 0) begin: line_lockup_sim_0
always @ (posedge clk) begin
  if (output_ce) begin
    case (total_lines) 	// line number, relative to vsync depends on line standard
      625:  offset <= 3;
	  // 1125: offset <= 4;
      //cunhua: for HD, interlace offset is 2; progressive it's 4. 
	  1125: 
	        if(interlace) begin
	           offset <= 2;
			end else begin
	           offset <= 4;
			end
      750:  offset <= 5;
      default: offset <= 0;
    endcase
  end 
end
end
endgenerate
	// for small frame simulation use only
generate
if (C_SIM_MODE == 1) begin: line_lockup_sim_1
always @ (posedge clk) begin
  if (output_ce) begin
    case (total_lines) 	// line number, relative to vsync depends on line standard
      95:  offset <= 3;
	  // for small frame simulation, full frame 625 replaced with 95
	  65:
	  // for small frame simulation, full frame 1125 replaced with 65 - dv file need to set correctly
	  // active = 20, vblank = 45
	        if(interlace) begin
	           offset <= 2;
			end else begin
	           offset <= 4;
			end
      50:  offset <= 5;
	  // for small frame simulation, full frame 750 replaced with 50 - dv file need to set correctly
	  // active = 20, vblank = 30
      default: offset <= 0;
    endcase
  end 
end
end
endgenerate

always @ (posedge clk) begin
  if (output_ce) begin
    if (line_count <= offset)
	  line_number <= line_count + total_lines - offset;
	else
	  line_number <= line_count - offset;
  end
end
////////////////////////////////////////
// Delay Registers
////////////////////////////////////////
  always @ (posedge clk) begin
	if (rst) begin
	  tx_ds1a_1	 <= 10'h200;
	  tx_ds2a_1	 <= 10'h200;
	  tx_ds1b_1	 <= 10'h200;
	  tx_ds2b_1	 <= 10'h200;
	  tx_ds1a_2	 <= 10'h200;
	  tx_ds2a_2	 <= 10'h200;
	  tx_ds1b_2	 <= 10'h200;
	  tx_ds2b_2	 <= 10'h200;
	end
	else if (output_ce) begin
	  tx_ds1a_1	<=  tx_ds1a;
	  tx_ds2a_1	<=  tx_ds2a;
	  tx_ds1b_1	<=  tx_ds1b;
	  tx_ds2b_1	<=  tx_ds2b;

	  tx_ds1a_2	<=  tx_ds1a_1;
	  tx_ds2a_2	<=  tx_ds2a_1;
	  tx_ds1b_2	<=  tx_ds1b_1;
	  tx_ds2b_2	<=  tx_ds2b_1;

	end 
  end
////////////////////////////////////////
// Output Registers
////////////////////////////////////////
  always @ (posedge clk) begin
	if (rst) begin
	  tx_video_a_y	 <= 10'h200;
	  tx_video_a_c	 <= 10'h200;
	  tx_video_b_y	 <= 10'h200;
	  tx_video_b_c	 <= 10'h200;
	  eav		     <= 0;
	  sav			 <= 0;
	  trs			 <= 0;
	end
	else if (output_ce) begin	//not reset
	  if (sav_active || eav_active) begin
	    tx_video_a_y <=	trs_data;
		tx_video_a_c <=	trs_data;
		tx_video_b_y <=	trs_data;
		tx_video_b_c <=	trs_data;
		trs          <= 1;
		sav          <= sav_xyz;
		eav          <= eav_xyz;
	  end
	  else  begin
	    tx_video_a_y <=	tx_ds1a_2;
		tx_video_a_c <=	tx_ds2a_2;
		tx_video_b_y <=	tx_ds1b_2;
		tx_video_b_c <=	tx_ds2b_2;
		trs          <= 0;
		sav          <= 0;
		eav          <= 0;
	  end 
	end	  // not reset
  end	//always

endmodule
