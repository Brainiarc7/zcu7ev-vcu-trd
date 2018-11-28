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
Module description:

This module implement the finite state machine for the video flywheel. The FSM
synchronizes to the received video stream in two steps. 

First, the FSM syncs horizontally by waiting for a received SAV symbol. This
causes the FSM to reset the horizontal counter in the fly_hcnt module. After
receiving a SAV, the FSM checks the results by comparing the position of the
next received SAV with the expected location. If they match, then the FSM
assumes it is synchronized horizontally.

Next, the FSM syncs vertically. This is done by waiting for the received video
to change fields, as indicated by the F bit in the received TRS symbols. When
a field transition occurs, the vertical line counter in the fly_vcnt module
is updated to the correct count and the FSM asserts the lock signal to indicate
that it is synchronized with the video.

Once locked, the error detection logic continually compares the position and
contents of the received TRS symbols with the flywheel generated TRS symbols.
When the number of lines containing mismatched TRS symbols exceeds the MAX_ERRS
value over the observation window (defaults to 8 lines), the resync signal is
asserted. This causes the state machine to negate the lock signal and go
through the synchronization process again.

The FSM is designed to accomodate synchronous switching as defined by SMPTE
RP 168. This recommended practice defines one line per field in the vertical
blanking interval when it is allowed to switch the video stream between two
synchronous video sources. The video sources must be synchronized but minor
displacements of the EAV symbol on these switching lines is tolerated since the
switch sometimes induces minor errors on the line. During the switching
interval lines, errors in the position of the EAV symbol cause the FSM to
update the horizontal counter value immediately without going through the
normal synchronization process.

The FSM normally verifies that the received TRS symbol matches the flywheel 
generated TRS symbol by comparing the F, V, and H bits. However, previous
versions of the NTSC digital component video standards allowed the V bit to
fall early, anywhere between line 10 and line 20 for field 1 and lines
273 to 283 for the second field. These standards now specify that the V bit
must fall one lines 20 and 283, but also recommend that new equipment be
tolerant of the signal falling early. The FSM ignores the V bit transitioning
early.

The inputs to this module are:

clk: clock input

ce: clock enable

rst: synchronous reset

vid_f: Input video bit that carries the F signal during XYZ words.

vid_v: Input video bit that carries the V signal during XYZ words.

vid_h: Input video bit that carries the H signal during XYZ words.

rx_xyz: Asserted when the XYZ word is being processed by the flywheel.

fly_eav: Asserted when the XYZ word of an EAV is being generated by the flywheel.

fly_sav: Asserted when the XYZ word of an SAV is being generated by the flywheel.

fly_eav_next: Asserted the clock cycle before it is time for the flywheel to
generated an EAV symbol.

rx_eav: Asserted when the flywheel is receiving the XYZ word of an EAV.

rx_sav: Asserted when the flywheel is receiving the XYZ word of an SAV.

rx_eav_first: Asserted when the flywheel is receiving the first word of an EAV.

new_rx_field: From the new field detector in fly_field module. Asserted for the
duration of the first line of a new field.

xyz_err: Asserted when an error is detected in the received XYZ word.

std_locked: Asserted when autodetect module is locked to input video stream's
standard.

switch_interval: Asserted when the current video line is a synchronous
switching line.

xyz_f: F bit from flywheel generated XYZ word.

xyz_v: V bit from flywheel generated XYZ word.

xyz_h: H bit from flywheel generated XYZ word.

sloppy_v: Asserted one those lines when the status of the V bit is ambiguous.

The outputs of this module are:

lock: Asserted when the flywheel is locked to the input video stream.

ld_vcnt: Asserted during resync cycle to cause the vertical counter to load
with a new value at the start of a new field.

inc_vcnt: Asserted to cause the vertical counter to increment.

clr_hcnt: Asserted to cause the horizontal counter to reset.

resync_hcnt: Asserted during synchronous switching to cause the the horizontal
counter to update to the position of the new input video stream.

ld_std: Loads the flywheel's int_std register with the current video standard
code.

ld_f: Asserted during resynchronization to load the F bit.

clr_switch: This output clears the flywheel's switching_interval signal.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_tx_v1_0_0_edh_fly_fsm (
    input  wire         clk,            // clock input
    input  wire         ce,             // clock enable
    input  wire         rst,            // sync reset input
    input  wire         vid_f,          // video data F bit
    input  wire         vid_v,          // video data V bit
    input  wire         vid_h,          // video data H bit
    input  wire         rx_xyz,         // asserted during the XYZ word of a TRS symbol
    input  wire         fly_eav,        // asserted on XYZ word of flywheel generated EAV
    input  wire         fly_sav,        // asserted on XYZ word of flywheel generated SAV
    input  wire         fly_eav_next,   // asserted when flywheel will generate EAV starting with next word
    input  wire         fly_sav_next,   // asserted when flywheel will generate SAV starting with next word
    input  wire         rx_eav,         // asserted on XYZ word of received EAV
    input  wire         rx_sav,         // asserted on XYZ word of received SAV
    input  wire         rx_eav_first,   // asserted during the first word of a received EAV
    input  wire         new_rx_field,   // asserted when received field changes
    input  wire         xyz_err,        // asserted on parity error in XYZ word
    input  wire         std_locked,     // asserted by the autodetect unit when locked to video std
    input  wire         switch_interval,// asserted when in the synchronous switching interval
    input  wire         xyz_f,          // flywheel generated XYZ word F bit
    input  wire         xyz_v,          // flywheel generated XYZ word V bit
    input  wire         xyz_h,          // flywheel generated XYZ word H bit
    input  wire         sloppy_v,       // ignore V bit on XYZ comparison when asserted
    output reg          lock = 1'b0,    // asserted when flywheel is synchronized to video
    output reg          ld_vcnt,        // causes vcnt to load
    output reg          inc_vcnt,       // forces vcnt to increment during failed sync switch
    output reg          clr_hcnt,       // causes hcnt to clear
    output reg          resync_hcnt,    // reloads hcnt to SAV position during sync switch
    output reg          ld_std,         // loads the int_std register
    output reg          ld_f,           // loads the F bit
    output reg          clr_switch      // clears the switching_interval signal
);

//-----------------------------------------------------------------------------
// Parameter definitions
//

//
// This group of parameters defines the bit widths of various fields in the
// module.
//
// The ERRCNT_WIDTH must be big enough to generate a counter wide enough
// to accomodate error counts up to the MAX_ERRS value. It is recommended that
// one or two additional counts be available in the error counter above the
// MAX_ERRS value to prevent wrap around errors.
//
// The LSHIFT_WIDTH value dictates the number of lines in the error window. The
// default value of 32 provides a window of 32 lines over which the resync logic
// examines lines containing TRS errors. If the number of lines with errors
// exceeds MAX_ERRS over the error window, the FSM will be forced to
// resynchronize. It is recommended that the error window be larger than the
// vertical blanking interval and that the MAX_ERRS value never be set larger
// than 2, otherwise the flywheel will fail to resynchronize to a video stream
// that is offset by just a few lines from the current flywheel position.
//
//
parameter ERRCNT_WIDTH  = 3;                   // Width of errcnt
parameter LSHIFT_WIDTH  = 32;                  // Errored line shifter
 
localparam ERRCNT_MSB   = ERRCNT_WIDTH - 1;    // MS bit # of errcnt
localparam LSHIFT_MSB   = LSHIFT_WIDTH - 1;    // MS bit # of errored line shifter

parameter MAX_ERRS      = 2;                   // Max number of TRS errors allowed in window


//
// This group of parameters defines the states of the FSM.
//                                              
localparam STATE_WIDTH   = 4;
localparam STATE_MSB     = STATE_WIDTH - 1;

localparam [STATE_WIDTH-1:0]
    LOCK    = 0,
    HSYNC1  = 1,
    HSYNC2  = 2,
    FSYNC1  = 3,
    FSYNC2  = 4,
    FSYNC3  = 5,
    UNLOCK  = 6,
    SWITCH1 = 7,
    SWITCH2 = 8,
    SWITCH3 = 9,
    SWITCH4 = 10,
    SWITCH5 = 11,
    SWITCH6 = 12;

         
//-----------------------------------------------------------------------------
// Signal definitions
//

reg     [STATE_MSB:0]   current_state = UNLOCK;     // FSM current state
reg     [STATE_MSB:0]   next_state;                 // FSM next state
wire                    resync;                     // asserted to cause flywheel to resync
reg                     clr_resync;                 // reset resync logic
reg     [ERRCNT_MSB:0]  errcnt = 0;                 // resync error counter
reg     [LSHIFT_MSB:0]  lerr_shifter = 0;           // errored line shift register
reg                     line_err = 1'b0;            // SR flip-flop indicating error in this line
wire                    trs_err;                    // sets the line_err flip-flop
wire                    xyz_match;                  // asserted if flywheel XYZ word matches received data
reg                     set_lock;                   // sets the lock flip-flop
reg                     clr_lock;                   // clears the lock flip-flop
wire                    fly_xyz;                    // asserted when flywheel generates XYZ

//
// fly_xyz
//
// fly_xyz is asserted on the flywheel generated XYZ word
//
assign fly_xyz = fly_sav | fly_eav;

//
// lock
//
// This is the lock flip-flop. It is set and cleared by the state machine to
// indicate whether the flywheel is synchronized to the incoming video or not.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            lock <= 1'b0;
        else if (set_lock)
            lock <= 1'b1;
        else if (clr_lock)
            lock <= 1'b0;
    end

//
// resync logic
//
// The resync logic determines when it is time to resynchronize the flywheel.
// An SR flip-flop is set if a TRS error is detected on the current line. At
// the end of the line, when fly_eav_next is asserted, the contents of the SR
// flip-flop are shifted into the lerr_shifter and the flip-flop is cleared.
// 
// The lerr_shifter contains one bit for each line in the "window" over which
// the resync mechanism operates. The shifter shifts one bit position at the 
// end of each line. The output bit of the shifter will cause the errcnt to 
// decrement if it is asserted because a line with an error has moved out of
// the error window.
//
// The errcnt is a counter that increments at the end of every line in which
// a TRS error is detected (when the line_err SR flip-flop is asserted). It
// decrements if the output bit of the shifter is asserted. In this way,
// it keeps track of the number of lines in the current window that had TRS
// errors. If the errcnt value exceeds the maximum number of allowed errors in
// the window, the resync signal is asserted.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst | fly_eav_next | clr_resync)
            line_err <= 1'b0;
        else if (trs_err)
            line_err <= 1'b1;
    end
        
always @ (posedge clk)
    if (ce)
    begin
        if (rst | clr_resync)
            lerr_shifter <= 0;
        else if (fly_eav_next)
            lerr_shifter <= {lerr_shifter[LSHIFT_MSB - 1:0], line_err};
    end
        
always @ (posedge clk)
    if (ce)
    begin
        if (rst | clr_resync)
            errcnt <= 0;
        else if (fly_eav_next)
            begin
                if (line_err & !lerr_shifter[LSHIFT_MSB])
                    errcnt <= errcnt + 1;
                else if (!line_err & lerr_shifter[LSHIFT_MSB])
                    errcnt <= errcnt - 1;
            end
    end
        
assign resync = (errcnt >= MAX_ERRS);

//
// trs_err
//
// This signal is asserted when the received word is misplaced relative to the
// flywheel's TRS location or if the received TRS XYZ word doesn't match
// the flywheel's generated values. This signal tells resync logic than an
// error occurred.
//
assign trs_err = (~fly_xyz & rx_xyz) | 
                 (fly_xyz & rx_xyz & (~xyz_match | xyz_err));

//
// xyz_match logic
// 
// This logic compares the received XYZ word with the flywheel generated XYZ
// word to determine if they match. Only the F, V, and H bits of these words
// are compared. If the sloppy_v signal is asserted, then the V bit is ignored.
//

assign xyz_match = ~( vid_f ^ xyz_f |                   // F bit compare
                    ((vid_v ^ xyz_v) & ~sloppy_v) |     // V bit compare
                      vid_h ^ xyz_h);                   // H bit compare  

// FSM
//
// The finite state machine is implemented in three processes, one for the
// current_state register, one to generate the next_state value, and the
// third to decode the current_state to generate the outputs.
 
//
// FSM: current_state register
//
// This code implements the current state register. It loads with the HSYNC1
// state on reset and the next_state value with each rising clock edge.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            current_state <= UNLOCK;
        else
            current_state <= next_state;
    end

//
// FSM: next_state logic
//
// This case statement generates the next_state value for the FSM based on
// the current_state and the various FSM inputs.
//
always @ (*)
    case(current_state)
        LOCK:   if (~std_locked)
                    next_state = UNLOCK;
                else if (resync)
                    next_state = HSYNC1;
                else if (switch_interval)
                    next_state = SWITCH1;
                else
                    next_state = LOCK;
                

        HSYNC1: if (~rx_sav)
                    next_state = HSYNC1;
                else if (fly_sav)
                    next_state = FSYNC1;
                else
                    next_state = HSYNC2;

        HSYNC2: next_state = HSYNC1;

        FSYNC1: if (~fly_eav)
                    next_state = FSYNC1;
                else if (~rx_eav)
                    next_state = HSYNC1;
                else if (xyz_err)
                    next_state = FSYNC1;
                else
                    next_state = FSYNC2;

        FSYNC2: if (new_rx_field)
                    next_state = FSYNC3;
                else
                    next_state = FSYNC1;

        FSYNC3: next_state = LOCK;

        UNLOCK: if (~std_locked)
                    next_state = UNLOCK;
                else
                    next_state = HSYNC1;

        SWITCH1: if (~std_locked)
                    next_state = UNLOCK;
                 else if (rx_eav_first)
                    next_state = SWITCH2;
                 else if (fly_eav_next)
                    next_state = SWITCH5;
                 else
                    next_state = SWITCH1;

        SWITCH2: next_state = SWITCH3;

        SWITCH3: next_state = SWITCH4;

        SWITCH4: next_state = LOCK;

        SWITCH5: if (rx_eav_first)
                    next_state = LOCK;
                 else
                    next_state = SWITCH6;

        SWITCH6: if (rx_eav_first)
                    next_state = SWITCH2;
                 else if (fly_sav_next)
                    next_state = UNLOCK;
                 else
                    next_state = SWITCH6;
                    
        default: next_state = HSYNC1;
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
    // are low.
    clr_resync      = 1'b0;
    ld_vcnt         = 1'b0;
    clr_hcnt        = 1'b0;
    resync_hcnt     = 1'b0;
    ld_vcnt         = 1'b0;
    set_lock        = 1'b0;
    clr_lock        = 1'b0;
    ld_std          = 1'b0;
    ld_f            = 1'b0;
    clr_switch      = 1'b0;
    inc_vcnt        = 1'b0;
                            
    case(current_state)     
        LOCK:   set_lock = 1'b1;

        HSYNC1: begin
                    clr_lock = 1'b1;
                    ld_std   = 1'b1;
                end

        HSYNC2: clr_hcnt  = 1'b1;

        FSYNC3: begin
                    ld_vcnt    = 1'b1;
                    ld_f       = 1'b1;
                    clr_resync = 1'b1;
                end

        UNLOCK: begin
                    clr_lock = 1'b1;
                    clr_switch = 1'b1;
                end

        SWITCH2: resync_hcnt = 1'b1;
                 
        SWITCH4: clr_switch = 1'b1;

        SWITCH6: if (fly_sav_next)
                    begin
                        clr_switch = 1'b1;
                        inc_vcnt   = 1'b1;
                    end
                else
                    begin
                        clr_switch = 1'b0;
                        inc_vcnt   = 1'b0;
                    end

    endcase
end

endmodule
