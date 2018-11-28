// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// 
//------------------------------------------------------------------------------
/*
Module Description:

This module inserts SMPTE 352M video payload ID packets into a video stream.
The stream may be either HD or SD, as indicated by the hd_sd input signal.
The module will overwrite an existing VPID packet if the overwrite input
is asserted, otherwise if a VPID packet exists in the HANC space, it will
not be overwritten and a new packet will not be inserted.

The module does not create the user data words of the VPID packet. Those
are generated externally and enter the module on the byte1, byte2, byte3,
and byte4 ports.

The module requires an interface line number on its input. This line number
must be valid for the new line one clock cycle before the start of the
HANC space -- that is during the second CRC word following the EAV.

If the overwrite input is 1, this module will also deleted any VPID packets
that occur elsewhere in any HANC space. These packets will be marked as
deleted packets.

When the level_b input is 1, then the module works a little bit differently.
It will always overwrite the first data word of the VPID packet with the value
present on the byte1 input port, even if overwrite is 0. This is because
conversions from dual link to level B 3G-SDI require the first byte to be
modified. The checksum is recalculated and inserted.

This module is compliant with the 2007 revision of SMPTE 425M for inserting
SMPTE 352M VPID packets in level B streams.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_tx_v1_0_0_st352_pid_insert (
    input  wire             clk,            // clock input
    input  wire             ce,             // clock enable
    input  wire             rst,            // sync reset input
    input  wire             hd_sd,          // 0 = HD, 1 = SD
    input  wire             level_b,        // 1 = SMPTE 425M Level B
    input  wire             enable,         // 0 = disable insertion
    input  wire             overwrite,      // 1 = overwrite existing packets
    input  wire [10:0]      line,           // current video line
    input  wire [10:0]      line_a,         // field 1 line for packet insertion
    input  wire [10:0]      line_b,         // field 2 line for packet insertion
    input  wire             line_b_en,      // 1 = use line_b, 0 = ignore line_b
    input  wire [7:0]       byte1,          // first byte of VPID data
    input  wire [7:0]       byte2,          // second byte of VPID data
    input  wire [7:0]       byte3,          // third byte of VPID data
    input  wire [7:0]       byte4,          // fourth byte of VPID data
    input  wire [9:0]       y_in,           // Y data stream in
    input  wire [9:0]       c_in,           // C data stream in
    output reg  [9:0]       y_out = 0,      // Y data stream out
    output reg  [9:0]       c_out = 0,      // C data stream out
    output reg              eav_out = 0,    // asserted on XYZ word of EAV
    output reg              sav_out = 0     // asserted on XYZ word of SAV
);

localparam STATE_WIDTH   = 6;
localparam STATE_MSB     = STATE_WIDTH - 1;

localparam [STATE_WIDTH-1:0]
    STATE_WAIT      = 6'd0,
    STATE_ADF0      = 6'd1,
    STATE_ADF1      = 6'd2,
    STATE_ADF2      = 6'd3,
    STATE_DID       = 6'd4,
    STATE_SDID      = 6'd5,
    STATE_DC        = 6'd6,
    STATE_B0        = 6'd7,
    STATE_B1        = 6'd8,
    STATE_B2        = 6'd9,
    STATE_B3        = 6'd10,
    STATE_CS        = 6'd11,
    STATE_DID2      = 6'd12,
    STATE_SDID2     = 6'd13,
    STATE_DC2       = 6'd14,
    STATE_UDW       = 6'd15,
    STATE_CS2       = 6'd16,
    STATE_INS_ADF0  = 6'd17,
    STATE_INS_ADF1  = 6'd18,
    STATE_INS_ADF2  = 6'd19,
    STATE_INS_DID   = 6'd20,
    STATE_INS_SDID  = 6'd21,
    STATE_INS_DC    = 6'd22,
    STATE_INS_B0    = 6'd23,
    STATE_INS_B1    = 6'd24,
    STATE_INS_B2    = 6'd25,
    STATE_INS_B3    = 6'd26,
    STATE_ADF0_X    = 6'd27,
    STATE_ADF1_X    = 6'd28,
    STATE_ADF2_X    = 6'd29,
    STATE_DID_X     = 6'd30,
    STATE_SDID_X    = 6'd31,
    STATE_DC_X      = 6'd32,
    STATE_UDW_X     = 6'd33,
    STATE_CS_X      = 6'd34;
        
localparam [3:0]
    MUX_SEL_000     = 4'd0,
    MUX_SEL_3FF     = 4'd1,
    MUX_SEL_DID     = 4'd2,
    MUX_SEL_SDID    = 4'd3,
    MUX_SEL_DC      = 4'd4,
    MUX_SEL_UDW     = 4'd5,
    MUX_SEL_CS      = 4'd6,
    MUX_SEL_DEL     = 4'd7,
    MUX_SEL_VID     = 4'd8;

// internal signals
reg     [9:0]   vid_reg0 = 0;           // video pipeline register
reg     [9:0]   vid_reg1 = 0;           // video pipeline register
reg     [9:0]   vid_reg2 = 0;           // video pipeline register
reg     [9:0]   vid_dly = 0;            // last stage of video pipeline
wire            all_ones_in;            // asserted when in_reg is all ones
wire            all_zeros_in;           // asserted when in_reg is all zeros
reg     [2:0]   all_zeros_pipe = 0;     // delay pipe for all zeros
reg     [2:0]   all_ones_pipe = 0;      // delay pipe for all ones
wire            xyz;                    // current word is the XYZ word
wire            eav_next;               // 1 = next word is first word of EAV
wire            sav_next;               // 1 = next word is first word of SAV
wire            anc_next;               // 1 = next word is first word of ANC
wire            hanc_start_next;        // 1 = next word is first word of HANC
reg     [3:0]   hanc_dly;               // delay value from xyz to hanc_start_next
reg     [15:0]  hanc_dly_srl = 0;       // SRL reg used to generate hanc_start_next
reg     [9:0]   in_reg = 0;             // input register
reg     [9:0]   vid_out = 0;            // internal version of y_out
wire            line_match_a;           // output of line_a comparitor
wire            line_match_b;           // output of line_b comparitor
reg             vpid_line = 0;          // 1 = insert VPID packet on this line
wire            vpid_pkt;               // 1 = ANC packet is a VPID
wire            del_pkt_ok;             // 1 = ANC act is deleted packet with
reg     [7:0]   udw_cntr = 0;           // user data word counter
wire    [7:0]   udw_cntr_mux;           // mux on input of udw_cntr
reg             ld_udw_cntr;            // 1 = load udw_cntr
wire            udw_cntr_tc;            // 1 = udw_cntr == 0
reg     [8:0]   cs_reg = 0;             // checksum generation register
reg             clr_cs_reg;             // 1 = clear cs_reg to 0
reg     [7:0]   vpid_mux;               // selects the VPID byte to be output 
reg     [1:0]   vpid_mux_sel;           // controls vpid_mux
reg     [3:0]   out_mux_sel;            // controls the vid_out data mux
wire            parity;                 // parity calculation
reg     [3:0]   sav_timing = 0;         // shift register for generating sav_out
reg     [3:0]   eav_timing = 0;         // shift register for generating eav_out
reg     [9:0]   cdly0 = 0;
reg     [9:0]   cdly1 = 0;
reg     [9:0]   cdly2 = 0;
reg     [9:0]   cdly3 = 0;
reg     [9:0]   cdly4 = 0;

reg     [STATE_MSB:0]   current_state = STATE_WAIT;     // FSM current state
reg     [STATE_MSB:0]   next_state;                     // FSM next state

reg     [7:0]   byte1_reg = 0;
reg     [7:0]   byte2_reg = 0;
reg     [7:0]   byte3_reg = 0;
reg     [7:0]   byte4_reg = 0;

//
// Input registers and video pipeline registers
//
always @ (posedge clk)
    if (ce) begin
        in_reg    <= y_in;
        vid_reg0  <= in_reg;
        vid_reg1  <= vid_reg0;
        vid_reg2  <= vid_reg1;
        vid_dly   <= vid_reg2;
        byte1_reg <= byte1;
        byte2_reg <= byte2;
        byte3_reg <= byte3;
        byte4_reg <= byte4;
    end

//
// all ones and all zeros detectors
//
assign all_ones_in = &in_reg;
assign all_zeros_in = ~|in_reg;

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            all_zeros_pipe <= 0;
        else
            all_zeros_pipe <= {all_zeros_pipe[1:0], all_zeros_in};
    end

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            all_ones_pipe <= 0;
        else
            all_ones_pipe <= {all_ones_pipe[1:0], all_ones_in};
    end

//
// EAV, SAV, and ADF detection
//
assign xyz = all_ones_pipe[2] & all_zeros_pipe[1] & all_zeros_pipe[0];

assign eav_next = xyz & in_reg[6];
assign sav_next = xyz & ~in_reg[6];
assign anc_next = all_zeros_pipe[2] & all_ones_pipe[1] & all_ones_pipe[0];

//
// This SRL16 is used to generate the hanc_start_next signal. The input to the
// shift register is eav_next. The depth of the shift register depends on 
// whether the video is HD or SD.
//
always @ (*)
    if (hd_sd)
        hanc_dly = 4'd3;
    else
        hanc_dly = 4'd7;

always @ (posedge clk)
    if (ce)
        hanc_dly_srl <= {hanc_dly_srl[14:0], eav_next};
        
assign hanc_start_next = hanc_dly_srl[hanc_dly];         
         
//
// Line number comparison
//
// Two comparators are used to determine if the current line number matches
// either of the two lines where the VPID packets are located. The second
// line can be disabled for progressive video by setting line_b_en low.
//
assign line_match_a = line == line_a;
assign line_match_b = line == line_b;

always @ (posedge clk)
    if (ce)
        vpid_line <= line_match_a | (line_match_b & line_b_en);

//
// DID/SDID match
//
// The vpid_pkt signal is asserted when the next two words in the video delay
// pipeline indicate a video payload ID packet. The del_pkt_ok signal is
// asserted when the data in the video delay pipeline indicates that a deleted
// ANC packet is present with a data count of at least 4.
//
assign vpid_pkt = vid_reg2[7:0] == 8'h41 && vid_reg1[7:0] == 8'h01;
assign del_pkt_ok = vid_reg2[7:0] == 8'h80 && vid_reg0[7:0] >= 8'h04;

//
// UDW counter
//
// This counter is used to cycle through the user data words of non-VPID ANC 
// packets that may be encountered before empty HANC space is found.
//
assign udw_cntr_mux = ld_udw_cntr ? vid_dly[7:0] : udw_cntr;
assign udw_cntr_tc = udw_cntr_mux == 8'h00;

always @ (posedge clk)
    if (ce)
        udw_cntr <= udw_cntr_mux - 1;

//
// Checksum generation
//
always @ (posedge clk)
    if (ce) begin
        if (clr_cs_reg)
            cs_reg <= 0;
        else
            cs_reg <= cs_reg + vid_out[8:0];
    end

//
// Video data path
//
always @ (*)
    case(vpid_mux_sel)
        2'b00:   vpid_mux = byte1_reg;
        2'b01:   vpid_mux = byte2_reg;
        2'b10:   vpid_mux = byte3_reg;
        default: vpid_mux = byte4_reg;
    endcase

assign parity = ^vpid_mux;

always @ (*)
    case(out_mux_sel)
        MUX_SEL_000:  vid_out = 10'h000;
        MUX_SEL_3FF:  vid_out = 10'h3ff;
        MUX_SEL_DID:  vid_out = 10'h241;   // DID
        MUX_SEL_SDID: vid_out = 10'h101;   // SDID
        MUX_SEL_DC:   vid_out = 10'h104;   // DC
        MUX_SEL_UDW:  vid_out = {~parity, parity, vpid_mux};
        MUX_SEL_CS:   vid_out = {~cs_reg[8], cs_reg};
        MUX_SEL_DEL:  vid_out = 10'h180;   // deleted pkt DID
        default:      vid_out = vid_dly;
    endcase

always @ (posedge clk)
    if (ce)
        y_out <= vid_out;

//
// Delay the C data stream by 6 clock cycles to match the Y data stream delay.
//
always @ (posedge clk)
    if (ce)
    begin
        cdly0 <= c_in;
        cdly1 <= cdly0;
        cdly2 <= cdly1;
        cdly3 <= cdly2;
        cdly4 <= cdly3;
        c_out <= cdly4;
    end

//
// EAV & SAV output generation
//
always @ (posedge clk)
    if (ce)
        eav_timing <= {eav_timing[2:0], eav_next};
        
always @ (posedge clk)
    if (ce)
        eav_out <= eav_timing[3];

always @ (posedge clk)
    if (ce)
        sav_timing <= {sav_timing[2:0], sav_next};

always @ (posedge clk)
    if (ce)
        sav_out <= sav_timing[3];

//
// FSM: current_state register
//
// This code implements the current state register. 
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            current_state <= STATE_WAIT;
        else if (ce)
        begin
            if (sav_next)
                current_state <= STATE_WAIT;
            else
                current_state <= next_state;
        end
    end

//
// FSM: next_state logic
//
// This case statement generates the next_state value for the FSM based on
// the current_state and the various FSM inputs.
//
always @ (*)
    case(current_state)
        STATE_WAIT:
            if (enable & vpid_line & hanc_start_next) begin
                if (anc_next)
                    next_state = STATE_ADF0;
                else
                    next_state = STATE_INS_ADF0;
            end else if (enable & ~vpid_line & anc_next & overwrite)
                next_state = STATE_ADF0_X;
            else    
                next_state = STATE_WAIT;
                
        STATE_ADF0:
            next_state = STATE_ADF1;

        STATE_ADF1:
            next_state = STATE_ADF2;

        STATE_ADF2:
            if (vpid_pkt)
                next_state = STATE_DID;
            else if (del_pkt_ok)
                next_state = STATE_INS_DID;
            else
                next_state = STATE_DID2;

        STATE_DID:
            next_state = STATE_SDID;

        STATE_SDID:
            if (overwrite)
                next_state = STATE_INS_DC;
            else
                next_state = STATE_DC;

        STATE_DC:
            next_state = STATE_B0;

        STATE_B0:
            next_state = STATE_B1;

        STATE_B1:
            next_state = STATE_B2;

        STATE_B2:
            next_state = STATE_B3;

        STATE_B3:
            next_state = STATE_CS;

        STATE_CS:
            next_state = STATE_WAIT;

        STATE_DID2:
            next_state = STATE_SDID2;

        STATE_SDID2:
            next_state = STATE_DC2;

        STATE_DC2:
            if (udw_cntr_tc)
                next_state = STATE_CS2;
            else
                next_state = STATE_UDW;

        STATE_UDW:
            if (udw_cntr_tc)
                next_state = STATE_CS2;
            else
                next_state = STATE_UDW;

        STATE_CS2:
            if (anc_next)
                next_state = STATE_ADF0;
            else
                next_state = STATE_INS_ADF0;

        STATE_INS_ADF0:
            next_state = STATE_INS_ADF1;

        STATE_INS_ADF1:
            next_state = STATE_INS_ADF2;

        STATE_INS_ADF2:
            next_state = STATE_INS_DID;

        STATE_INS_DID:
            next_state = STATE_INS_SDID;

        STATE_INS_SDID:
            next_state = STATE_INS_DC;

        STATE_INS_DC:
            next_state = STATE_INS_B0;

        STATE_INS_B0:
            next_state = STATE_INS_B1;

        STATE_INS_B1:
            next_state = STATE_INS_B2;

        STATE_INS_B2:
            next_state = STATE_INS_B3;

        STATE_INS_B3:   
            next_state = STATE_CS;

        STATE_ADF0_X:
            next_state = STATE_ADF1_X;

        STATE_ADF1_X:
            next_state = STATE_ADF2_X;

        STATE_ADF2_X:
            if (vpid_pkt)
                next_state = STATE_DID_X;
            else
                next_state = STATE_WAIT;

        STATE_DID_X:
            next_state = STATE_SDID_X;

        STATE_SDID_X:
            next_state = STATE_DC_X;

        STATE_DC_X:
            if (udw_cntr_tc)
                next_state = STATE_CS_X;
            else
                next_state = STATE_UDW_X;

        STATE_UDW_X:
            if (udw_cntr_tc)
                next_state = STATE_CS_X;
            else
                next_state = STATE_UDW_X;

        STATE_CS_X:
            if (anc_next)
                next_state = STATE_ADF0_X;
            else
                next_state = STATE_WAIT;

        default:    next_state = STATE_WAIT;
    endcase
        
//
// FSM: outputs
//
// This block decodes the current state to generate the various outputs of the
// FSM.
//
always @ (*)
    begin
        // Unless specifically assigned in the case statement, all FSM outputs
        // are given the values assigned here.
        ld_udw_cntr     = 1'b0;
        clr_cs_reg      = 1'b0;
        vpid_mux_sel    = 2'b00;
        out_mux_sel     = MUX_SEL_VID;
                                
        case(current_state) 

            STATE_ADF2:     clr_cs_reg = 1'b1;

            STATE_B0:       begin
                                out_mux_sel = level_b ? MUX_SEL_UDW : MUX_SEL_VID;
                                vpid_mux_sel = 2'b00;
                            end
        
            STATE_CS:       out_mux_sel = MUX_SEL_CS;

            STATE_DC2:      ld_udw_cntr = 1'b1;

            STATE_INS_ADF0: out_mux_sel = MUX_SEL_000;

            STATE_INS_ADF1: out_mux_sel = MUX_SEL_3FF;

            STATE_INS_ADF2: begin
                                out_mux_sel = MUX_SEL_3FF;
                                clr_cs_reg = 1'b1;
                            end

            STATE_INS_DID:  out_mux_sel = MUX_SEL_DID;

            STATE_INS_SDID: out_mux_sel = MUX_SEL_SDID;

            STATE_INS_DC:   out_mux_sel = MUX_SEL_DC;

            STATE_INS_B0:   begin
                                out_mux_sel = MUX_SEL_UDW;
                                vpid_mux_sel = 2'b00;
                            end
        
            STATE_INS_B1:   begin
                                out_mux_sel = MUX_SEL_UDW;
                                vpid_mux_sel = 2'b01;
                            end
        
            STATE_INS_B2:   begin
                                out_mux_sel = MUX_SEL_UDW;
                                vpid_mux_sel = 2'b10;
                            end
        
            STATE_INS_B3:   begin
                                out_mux_sel = MUX_SEL_UDW;
                                vpid_mux_sel = 2'b11;
                            end

            STATE_ADF2_X:   clr_cs_reg = 1'b1;

            STATE_DID_X:    out_mux_sel = MUX_SEL_DEL;

            STATE_DC_X:     ld_udw_cntr = 1'b1;

            STATE_CS_X:     out_mux_sel = MUX_SEL_CS;

        endcase
    end

endmodule
