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
This module implements the vertical functions of the video flywheel.

This module contains the vertical counter. This counter keeps track of the
current video scan line. The module also generates the V signal. This signal
is asserted during the vertical blanking interval of each field.

This module has the following inputs:

clk: clock input

rst: synchronous reset input

ce: clock enable

ntsc: Asserted when the input video stream is NTSC.

ld_vcnt: This input causes the vertical counter to load the value of the first
line of the current field.

fsm_inc_vcnt: This input is asserted by the FSM to force the vertical counter
to increment during a failed synchronous switch.

eav_next: Asserted the clock cycle before the first word of a flywheel generated
EAV symbol.

clr_switch: Causes the switch_interval output to be negated.

rx_f: This signal carries the F bit from the input video stream during XYZ 
words.

f: This is the flywheel generated F bit.

fly_sav: Asserted during the XYZ word of a flywheel generated SAV.

fly_eav: Asserted during the XYZ word of a flywheel generated EAV.

rx_eav_first: Asserted during the first word of an EAV in the input video 
stream.

lock: Asserted when the flywheel is locked.

This module generates the following outputs:

vcnt: This is the value of the vertical counter indicating the current video
line number.

v: This is the vertical blanking bit asserted during the vertical blanking
interval.

sloppy_v: This signal is asserted on those lines where the V bit may fall early.

inc_f: Toggles the F bit when asserted.

switch_interval: Asserted when the current line contains the synchronous
switching interval.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_tx_v1_0_0_edh_fly_vert #(
    parameter VCNT_WIDTH = 10)
(
    input  wire                     clk,                    // clock input
    input  wire                     rst,                    // sync reset input
    input  wire                     ce,                     // clock enable input
    input  wire                     ntsc,                   // 1 = NTSC, 0 = PAL
    input  wire                     ld_vcnt,                // causes vert counter to load
    input  wire                     fsm_inc_vcnt,           // forces vert counter to increment during failed sync switch
    input  wire                     eav_next,               // asserted when next word is first word of a flywheel EAV
    input  wire                     clr_switch,             // clears the switch_interval signal
    input  wire                     rx_f,                   // received F bit
    input  wire                     f,                      // flywheel generated field bit
    input  wire                     fly_sav,                // asserted during first word of flywheel generated SAV
    input  wire                     fly_eav,                // asserted during first word of flywheel generated EAV
    input  wire                     rx_eav_first,           // asserted during first word of received EAV
    input  wire                     lock,                   // asserted when flywheel is locked
    output wire [VCNT_WIDTH-1:0]    vcnt,                   // vertical counter
    output reg                      v = 1'b0,               // vertical blanking bit indicator
    output reg                      sloppy_v = 1'b0,        // asserted when FSM should ignore V bit in XYZ comparison
    output wire                     inc_f,                  // toggles the F bit when asserted
    output reg                      switch_interval = 1'b0  // asserted when current line is a sync switching line
);

//-----------------------------------------------------------------------------
// Parameter definitions
//
localparam VCNT_MSB      = VCNT_WIDTH - 1;       // MS bit # of vcnt

//
// This group of parameters defines the synchronous switching interval lines.
//
localparam NTSC_FLD1_SWITCH          = 10;
localparam NTSC_FLD2_SWITCH          = 273;
localparam PAL_FLD1_SWITCH           = 6;
localparam PAL_FLD2_SWITCH           = 319;
    
//
// This group of parameters defines the ending positions of the fields for
// NTSC and PAL.
//
localparam NTSC_FLD1_END             = 265;
localparam NTSC_FLD2_END             = 3;
localparam PAL_FLD1_END              = 312;
localparam PAL_FLD2_END              = 625;
localparam NTSC_V_TOTAL              = 525;
localparam PAL_V_TOTAL               = 625;
    
//
// This group of parameters defines the starting and ending active portions of
// of the fields.
//
localparam NTSC_FLD1_ACT_START       = 20;
localparam NTSC_FLD1_ACT_END         = 263;
localparam NTSC_FLD2_ACT_START       = 283;
localparam NTSC_FLD2_ACT_END         = 525;
localparam PAL_FLD1_ACT_START        = 23;
localparam PAL_FLD1_ACT_END          = 310;
localparam PAL_FLD2_ACT_START        = 336;
localparam PAL_FLD2_ACT_END          = 623;
         
//
// This group of parameters defines the starting lines on which it is possible
// for the V bit to change early. This is due to previous versions of the
// specifications that allowed for an early transition from 1 to 0 on the V
// bit. This only occurs in the NTSC specifications. The period of ambiguity
// on the V bit ends with the first active video line of each field as
// defined above.
//
localparam SLOPPY_V_START_FLD1       = 10;
localparam SLOPPY_V_START_FLD2       = 273;


//-----------------------------------------------------------------------------
// Signal definitions
//
reg     [VCNT_MSB:0]    vcount = 1;     // vertical counter
wire                    clr_vcnt;       // clears the vertical counter
reg     [VCNT_MSB:0]    new_vcnt;       // new value to load into vcount                
reg     [VCNT_MSB:0]    fld1_switch;    // synchronous switching line for field 1
reg     [VCNT_MSB:0]    fld2_switch;    // synchronous switching line for field 2
wire    [VCNT_MSB:0]    fld_switch;     // synchronous switching line for current field
wire                    switch_line;    // asserted when vcnt == fld_switch
wire    [VCNT_MSB:0]    v_total;        // total vertical lines for this video standard
reg     [VCNT_MSB:0]    fld1_act_start; // starting line of active video in field 1
reg     [VCNT_MSB:0]    fld1_act_end;   // ending line of active video in field 1
reg     [VCNT_MSB:0]    fld2_act_start; // starting line of active video in field 2
reg     [VCNT_MSB:0]    fld2_act_end;   // ending line of active video in field 2
wire    [VCNT_MSB:0]    fld_act_start;  // starting line of active video in current field
wire    [VCNT_MSB:0]    fld_act_end;    // ending line of active video in current field
wire                    act_start;      // result of comparing vcnt and fld_act_start
reg     [VCNT_MSB:0]    fld1_end;       // line count for end of field 1
reg     [VCNT_MSB:0]    fld2_end;       // line count for end of field 2
wire    [VCNT_MSB:0]    fld_end;        // line count for end of current field
wire    [VCNT_MSB:0]    sloppy_start;   // starting position of V bit ambiguity period

//
// vcnt: vertical counter
//
// The vertical counter increments once per line to keep track of the current
// vertical position. If clr_vcnt is asserted, vcnt is loaded with a value of
// 1. If ld_vcnt is asserted, the new_vcnt value is loaded into vcnt. If the
// state machine asserts the fsm_inc_vcnt signal indicating a synchronous
// switch event, then the vcnt must be forced to increment since the received
// EAV came before the flywheel's generated EAV, causing the hcnt to be updated
// to a position after the EAV and thus skipping the normal inc_vcnt signal
// that comes with the flywheel's EAV.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            vcount <= 1;
        else if (ld_vcnt)
            vcount <= new_vcnt;
        else if (fsm_inc_vcnt | ((lock & switch_interval) ? rx_eav_first : eav_next))
        begin
            if (clr_vcnt)
                vcount <= 1;
            else
                vcount <= vcount + 1;
        end
    end

assign v_total = ntsc ? NTSC_V_TOTAL : PAL_V_TOTAL;
assign clr_vcnt = (vcount == v_total);
assign vcnt = vcount;

always @ (*)
    if (ntsc)
    begin
        if (rx_f)
            new_vcnt = NTSC_FLD1_END + 1;
        else
            new_vcnt = NTSC_FLD2_END + 1;
    end
    else
    begin
        if (rx_f)
            new_vcnt = PAL_FLD1_END + 1;
        else
            new_vcnt = 1;
    end


//
// synchronous switching line detector
//
// This code determines when the current line is a line during which
// it is permitted to switch between synchronous video sources. These sources
// may have a small amount of offset. The flywheel will immediately 
// resynchronize to the new signal on the synchronous switching lines without
// the usual flywheel induced delay.
//
always @ (*)
    if (ntsc)
    begin
        fld1_switch <= NTSC_FLD1_SWITCH;
        fld2_switch <= NTSC_FLD2_SWITCH;
    end
    else
    begin
        fld1_switch <= PAL_FLD1_SWITCH;
        fld2_switch <= PAL_FLD2_SWITCH;
    end

assign fld_switch = f ? fld2_switch : fld1_switch;

assign switch_line = (vcount == fld_switch);

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            switch_interval <= 1'b0;
        else if (switch_interval ? clr_switch : fly_eav)
            switch_interval <= 1'b0;
        else if (fly_sav)
            switch_interval <= switch_line;
    end

//
// v
//
// This logic generates the V bit for the TRS XYZ word. The V bit is asserted
// in the TRS symbols of all lines in the vertical blanking interval. It is
// generated by comparing the vcnt starting and ending positions of the
// current field at the beginning of the EAV symbol. Whenever the state 
// machine reloads the field counter by asserted ld_f, the v flag should be
// set because the field counter is only reloaded in the vertical blanking
// interval.
//
always @ (*)
    if (ntsc)
    begin
        fld1_act_start = NTSC_FLD1_ACT_START - 1;
        fld1_act_end   = NTSC_FLD1_ACT_END;
        fld2_act_start = NTSC_FLD2_ACT_START - 1;
        fld2_act_end   = NTSC_FLD2_ACT_END;
    end
    else
    begin
        fld1_act_start = PAL_FLD1_ACT_START - 1;
        fld1_act_end   = PAL_FLD1_ACT_END;
        fld2_act_start = PAL_FLD2_ACT_START - 1;
        fld2_act_end   = PAL_FLD2_ACT_END;
    end

assign fld_act_start = f ? fld2_act_start : fld1_act_start;
assign fld_act_end   = f ? fld2_act_end   : fld1_act_end;
assign act_start = vcnt == fld_act_start;

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            v <= 1'b0;
        else if (ld_vcnt)
            v <= 1'b1;
        else if (eav_next)
            begin
                if (vcnt == fld_act_start)
                    v <= 1'b0;
                else if (vcnt == fld_act_end)
                    v <= 1'b1;
            end
    end

//
// inc_f
//
// This logic determines when to toggle the F bit.
//
always @ (*)
    if (ntsc)
    begin
        fld1_end = NTSC_FLD1_END;
        fld2_end = NTSC_FLD2_END;
    end
    else
    begin
        fld1_end = PAL_FLD1_END;
        fld2_end = PAL_FLD2_END;
    end

assign fld_end = f ? fld2_end : fld1_end;
assign inc_f = (vcnt == fld_end);

//
// sloppy_v
//
// This signal is asserted during the interval when the V bit should be
// ignored in XYZ comparisons due to ambiguity in earlier versions of the
// NTSC digital video specifications.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst | ld_vcnt | ~ntsc)
            sloppy_v <= 1'b0;
        else
        begin
            if (vcnt == sloppy_start)
                sloppy_v <= 1'b1;
            else if (eav_next & act_start)
                sloppy_v <= 1'b0;
        end
    end

assign sloppy_start = f ? SLOPPY_V_START_FLD2 : SLOPPY_V_START_FLD1;

endmodule
