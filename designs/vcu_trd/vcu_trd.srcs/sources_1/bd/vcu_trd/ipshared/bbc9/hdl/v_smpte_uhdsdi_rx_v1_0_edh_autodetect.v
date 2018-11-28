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
This module examines a digital video stream and determines which of six
supported video standards matches the video stream. The supported video 
standards are:

Video Format                            Corresponding Standards
------------------------------------------------------------------------------
NTSC 4:2:2 component video              SMPTE 125M, ITU-R BT.601, ITU-R BT.656
NTSC 4:2:2 16x9 component video         SMPTE 267M
NTSC 4:4:4 component 13.5MHz sample     SMPTE RP 174
PAL 4:2:2 component video               ITU-R BT.656
PAL 4:2:2 16x9 component video          ITU-R BT.601
PAL 4:4:4 component 13.5MHz sample      ITU-R BT.799    

The autodetect module is a finite state machine (FSM) that looks for TRS
symbols and measures the number of samples per line of video based on the
positions of the TRS symbols.

The FSM executes two main loops, the ACQUIRE loop and the LOCKED loop. In the 
ACQUIRE loop, the FSM attempts to find eight consecutive lines with the same
number of samples. Once it does this, the FSM then compares the number of
samples per video line to that of each of the six known standards. If a
a matching standard is found, the FSM sets the locked output and also outputs
a 3-bit code representing the video standard on the std output port then
it advances to the LOCKED loop.

In the LOCKED loop, the FSM continuously compares the number of samples of each
received video line to the correct number for the current video standard. If
the number of consecutive lines with the incorrect number of samples exceeds
the MAX_ERR_CNT value, then the locked output is negated and the FSM returns
to the ACQUIRE loop.

The autodetect module has the following inputs:

clk: Input clock running at the video word rate.

ce: Clock enable input.

rst: Synchronous reset input.

reacquire: Forces the autodetect unit to redetect the video format when
asserted high. This is essentially a synchronous reset to the FSM. The FSM
will not start the reacquire loop until the reacquire input goes low.

vid_in: This is the video data input port. If eight bit video is being used, the
LS 2-bits of the vid_in input port should be grounded.

rx_trs: This input must be asserted on the first word of every TRS symbol
present in the input video stream.

rx_xyz: This input must be asserted during the XYZ word of every TRS symbol
present in the input video stream.

rx_xyz_err: This input must be asserted during when the XYZ word contains an
error according to the 4:2:2 format.

rx_xyz_err_4444: This input identifies errors in XYZ words for the 4:4:4:4 
formats.

The autodetect module has the following outputs.

std: A 3-bit output port that indicates which standard has been detected. This
code is not valid unless the locked output is asserted. The std code values
are:

000:    NTSC 4:2:2 component video
001:    invalid
010:    NTSC 4:2:2 16x9 component video
011:    NTSC 4:4:4 13.5MHz component video
100:    PAL 4:2:2 component video
101:    invalid
110:    PAL 4:2:2 16x9 component video
111:    PAL 4:4:4 13.5MHz component video

locked: Asserted high when the autodetect unit is locked to the incoming video
standard.

xyz_err: This signal indicates the detection of an XYZ word error. This output
is generated by multiplexing the rx_xyz_err and rx_xyz_err_4444 inputs
together and using the detected video standard as the control for the MUX.

s4444: For the 4444 component video standards, this signal reflects the S bits
in the TRS word. The S bit is 1 for YCbCr and 0 for RGB.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_rx_v1_0_0_edh_autodetect #(
    parameter HCNT_WIDTH        = 12,   // # of bits in horizontal counter
    parameter ERRCNT_WIDTH      = 4,    // # of bits in error counter -- must be enough to count to MAX_ERR_CNT
    parameter MAX_ERR_CNT       = 8)    // Max consectuive error allowed before FSM begins to reaquire format
(
    input  wire         clk,            // clock input
    input  wire         ce,             // clock enable
    input  wire         rst,            // sync reset input
    input  wire         reacquire,      // forces state machine to reacquire when asserted
    input  wire [9:0]   vid_in,         // video data input
    input  wire         rx_trs,         // must be high on first word of TRS (0x3ff)
    input  wire         rx_xyz,         // must be high during the TRS XYZ word
    input  wire         rx_xyz_err,     // XYZ word error input, for all standards except 4444
    input  wire         rx_xyz_err_4444,// XYZ word error input, for 4444 standards
    output reg  [2:0]   vid_std = 3'b0, // video standard code
    output reg          locked = 1'b0,  // output asserted when synced to input data
    output wire         xyz_err,        // asserted when the XYZ word contains an error
    output reg          s4444 = 1'b0    // reflects the status of the S bit in 4444 format
);

//-----------------------------------------------------------------------------
// Parameter definitions
//

localparam HCNT_MSB      = HCNT_WIDTH - 1;       // MS bit # of hcnt
localparam ERRCNT_MSB    = ERRCNT_WIDTH - 1;     // MS bit # of errcnt

//
// This group of parameters defines the total number of clocks per line 
// for the various supported video standards.
//
localparam CNT_NTSC_422          = 1716;
localparam CNT_NTSC_422_WIDE     = 2288;
localparam CNT_NTSC_4444         = 3432;
localparam CNT_PAL_422           = 1728;
localparam CNT_PAL_422_WIDE      = 2304;
localparam CNT_PAL_4444          = 3456;

//
// This group of parameters defines the encoding for the video standards output
// code.
//
localparam [2:0]
    NTSC_422        = 3'b000,
    NTSC_INVALID    = 3'b001,
    NTSC_422_WIDE   = 3'b010,
    NTSC_4444       = 3'b011,
    PAL_422         = 3'b100,
    PAL_INVALID     = 3'b101,
    PAL_422_WIDE    = 3'b110,
    PAL_4444        = 3'b111;

//
// This group of parameters defines the states of the FSM.
//                                              
localparam STATE_WIDTH   = 4;
localparam STATE_MSB     = STATE_WIDTH - 1;

localparam [STATE_WIDTH-1:0]
    ACQ0 = 0,
    ACQ1 = 1,
    ACQ2 = 2,
    ACQ3 = 3,
    ACQ4 = 4,
    ACQ5 = 5,
    ACQ6 = 6,
    ACQ7 = 7,
    LCK0 = 8,
    LCK1 = 9,
    LCK2 = 10,
    LCK3 = 11,
    ERR0 = 12,
    ERR1 = 13,
    ERR2 = 14;
     
//-----------------------------------------------------------------------------
// Signal definitions
//

// counters and registers
reg     [HCNT_MSB:0]    hcnt = 1;               // horizontal counter
reg     [HCNT_MSB:0]    saved_hcnt = 0;         // saves the hcnt value of a line
reg     [STATE_MSB:0]   current_state = ACQ0;   // FSM current state
reg     [STATE_MSB:0]   next_state;             // FSM next state
reg     [2:0]           loops = 3'b0;           // iteration counter
reg     [ERRCNT_MSB:0]  errcnt = 0;             // error counter
reg     [2:0]           std = 3'b0;             // internal vid_std register
 
// FSM inputs
wire                    composite;              // 1=composite video
wire                    eav;                    // asserted when EAV received
wire                    sav;                    // asserted when SAV received
wire                    loops_eq_0;             // asserted when loops == 0
wire                    loops_eq_7;             // asserted when loops == 7
wire                    loops_eq_1;             // asserted when loops == 1
wire                    match;                  // comparator output
wire                    int_xyz_err;            // error in XYZ parity
wire                    max_errs;               // asserted when errcnt reaches max

// FSM outputs
reg                     clr_loops;              // clears loops counter
reg                     inc_loops;              // increments loops counter
reg                     clr_errcnt;             // clears the error counter
reg                     inc_errcnt;             // increments the error counter
reg                     clr_locked;             // clears the locked output
reg                     set_locked;             // sets the locked output
reg                     clr_hcnt;               // clears the hcnt counter
reg     [1:0]           match_code;             // comparator control bits
reg                     ld_std;                 // loads the video std output register
reg                     ld_saved_hcnt;          // loads the saved_hcnt register
reg                     ld_s4444;               // loads the s4444 flip-flop

// other signals
wire    [HCNT_MSB:0]    cmp_a;                  // A input to comparator
wire    [HCNT_MSB:0]    cmp_b;                  // B input to comparator
wire    [2:0]           samples_adr;            // address inputs for samples ROM
reg     [HCNT_MSB:0]    samples;                // ROM storing the sample counts for 
                                                //   various supported video standards


//
// hcnt: horizontal counter
//
// The horizontal counter increments every clock cycle to keep track of the
// current horizontal position. If clr_hcnt is asserted by the FSM, hcnt is
// reloaded with a value of 1. A value of 1 is used because of the latency
// involved in detected the TRS symbol and deciding whether to clear hcnt or
// not.
//
always @ (posedge clk)
    if (ce)
        begin
            if (rst | clr_hcnt)
                hcnt <= 1;
            else
                hcnt <= hcnt + 1;
        end

//
// saved_hcnt
//
// This register loads the current value of the hcnt counter when ld_saved_hcnt
// is asserted.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            saved_hcnt <= 0;
        else if (ld_saved_hcnt)
            saved_hcnt <= hcnt;
    end

//
// error counter
//
// This counter increments when inc_errcnt is asserted by the FSM. It clears
// when the FSM asserts clr_errcnt. When the error counter reaches the 
// MAX_ERR_CNT value, max_errs is asserted.
//
always @ (posedge clk)
    if (ce)
        begin
            if (rst | clr_errcnt)
                errcnt <= 0;
            else if (inc_errcnt)
                errcnt <= errcnt + 1;
        end

assign max_errs = (errcnt == MAX_ERR_CNT);

//
// loops
//
// This iteration counter is used by the FSM for two purposes. First, it is
// used to count the number of consecutive times that the SAV occurs at the 
// same hcnt value. Second, it is used to index through the samples ROM to 
// search for a matching video standard.
//
always @ (posedge clk)
    if (ce)
        begin
            if (rst | clr_loops)
                loops <= 0;
            else if (inc_loops)
                loops <= loops + 1;
        end

//
// std
//
// This register holds the code representing the video standard found by the
// FSM. If the FSM asserted ld_std, the register loads the current value of the
// loops iteration counter.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            std <= NTSC_422;
        else if (ld_std)
            std <= loops;
    end

//-----------------------------------------------------------------------------
// FSM
//
// The finite state machine is implemented in three processes, one for the
// current_state register, one to generate the next_state value, and the
// third to decode the current_state to generate the outputs.
 
//
// FSM: current_state register
//
// This code implements the current state register. It loads with the ACQ0
// state on reset and the next_state value with each rising clock edge.
//
always @ (posedge clk)
    if (ce)
        begin
            if (rst | reacquire)
                current_state <= ACQ0;
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
        ACQ0:   next_state = ACQ1;

        ACQ1:   if (rx_trs)
                    next_state = ACQ2;
                else
                    next_state = ACQ1;

        ACQ2:   if (eav | (sav & composite))
                    next_state = ACQ1;
                else if (~sav)
                    next_state = ACQ2;
                else
                    begin
                        if (loops_eq_0)
                            next_state = ACQ3;
                        else if (loops_eq_1)
                            next_state = ACQ4;
                        else if (loops_eq_7)
                            next_state = ACQ5;
                        else
                            next_state = ACQ7;
                    end                     
                        
        ACQ3:   next_state = ACQ1;

        ACQ4:   next_state = ACQ1;

        ACQ5:   if (match)
                    next_state = ACQ6;
                else
                    next_state = ACQ0;

        ACQ6:   if (match)
                    next_state = LCK0;
                else if (loops_eq_7)
                    next_state = ACQ0;
                else
                    next_state = ACQ6;

        ACQ7:   if (match)
                    next_state = ACQ1;
                else
                    next_state = ACQ0;

        LCK0:   if (rx_trs)
                    next_state = LCK1;
                else
                    next_state = LCK0;

        LCK1:   if (eav)
                    next_state = LCK0;
                else if (sav & int_xyz_err)
                    next_state = ERR0;
                else if (sav & ~int_xyz_err)
                    next_state = LCK2;
                else
                    next_state = LCK1;

        LCK2:   if (match)
                    next_state = LCK3;
                else
                    next_state = ERR1;

        LCK3:   next_state = LCK0;
                
        ERR0:   next_state = ERR1;

        ERR1:   next_state = ERR2;

        ERR2:   if (max_errs)
                    next_state = ACQ0;
                else
                    next_state = LCK0;

        default: next_state = ACQ0;
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
    clr_loops     = 1'b0;
    inc_loops     = 1'b0;
    clr_errcnt    = 1'b0;
    inc_errcnt    = 1'b0;
    clr_locked    = 1'b0;
    set_locked    = 1'b0;
    clr_hcnt      = 1'b0;
    ld_saved_hcnt = 1'b0;
    match_code    = 2'b00;
    ld_std        = 1'b0;
    ld_s4444      = 1'b0;
            
    case(current_state)     
        ACQ0:   begin
                    clr_locked = 1'b1;
                    clr_errcnt = 1'b1;
                    clr_loops = 1'b1;
                end

        ACQ2:   if (rx_xyz)
                    ld_s4444 = 1'b1;
                else
                    ld_s4444 = 1'b0;

        ACQ3:   begin
                    inc_loops = 1'b1;
                    clr_hcnt = 1'b1;
                end

        ACQ4:   begin
                    ld_saved_hcnt = 1'b1;
                    clr_hcnt = 1'b1;
                    inc_loops = 1'b1;
                end

        ACQ5:   begin
                    match_code = 2'b00;
                    inc_loops = 1'b1;
                    clr_hcnt = 1'b1;
                end

        ACQ6:   begin
                    inc_loops = 1'b1;
                    ld_std = 1'b1;
                    match_code = 2'b01;
                end

        ACQ7:   begin
                    match_code = 2'b00;
                    clr_hcnt = 1'b1;
                    inc_loops = 1'b1;
                end

        LCK0:   set_locked = 1'b1;

        LCK1:   if (rx_xyz & (std == PAL_4444 || std == NTSC_4444))
                    ld_s4444 = 1'b1;
                else
                    ld_s4444 = 1'b0;

        LCK2:   begin
                    match_code = 2'b10;
                    clr_hcnt = 1'b1;
                end

        LCK3:   clr_errcnt = 1'b1;

        ERR0:   clr_hcnt = 1'b1;

        ERR1:   inc_errcnt = 1'b1;
    endcase
end

//
// locked flip-flop
//
// The locked signal is generated by the FSM to indicate when it is properly
// synchronized with the incoming video stream. This flip-flop is set when the
// set_locked signal is asserted by the FSM and cleared when the clr_locked
// signal is asserted by the FSM.
//
always @ (posedge clk)
    if (ce)
        begin
            if (rst | clr_locked)
                locked <= 1'b0;
            else if (set_locked)
                locked <= 1'b1;
        end

//
// These statements generate the composite, eav, sav, and int_xyz_err sigals.
//
assign composite = ~vid_in[9];
assign eav = vid_in[6] & rx_xyz;
assign sav = ~vid_in[6] & rx_xyz;
assign int_xyz_err = (std == NTSC_4444 || std == PAL_4444) ? 
                      rx_xyz_err_4444 : rx_xyz_err;

//
// These statements decode the loops interation counter.
//
assign loops_eq_0 = (loops == 3'b000);
assign loops_eq_1 = (loops == 3'b001);
assign loops_eq_7 = (loops == 3'b111);

//
// This is the samples ROM. It contains the total number of samples on a video
// line for each of the eight supported video standards.
//
always @ (*)
    case(samples_adr)
        NTSC_422:       samples = CNT_NTSC_422;
        NTSC_422_WIDE:  samples = CNT_NTSC_422_WIDE;
        NTSC_4444:      samples = CNT_NTSC_4444;
        PAL_422:        samples = CNT_PAL_422;
        PAL_422_WIDE:   samples = CNT_PAL_422_WIDE;
        PAL_4444:       samples = CNT_PAL_4444;
    default:            samples = 0;
endcase

//
// This code implements a MUX to generate the address into the samples counter.
// This address can come from either the loops counter or the std register
// depending on the MSB of the match_code from the FSM.
//
assign samples_adr = match_code[1] ? std : loops;

//
// This code implements the comparator that generates the match input to the
// FSM. It can compare hcnt to saved_hcnt, hcnt to the output of the samples
// ROM, or saved_hcnt to the output of the samples ROM depending the match_code
// value.
//
assign cmp_a = match_code[0] ? samples : hcnt;
assign cmp_b = match_code[1] ? samples : saved_hcnt;
assign match = cmp_a == cmp_b;

 
//
// Output register for s4444 signal
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            s4444 <= 1'b1;
        else if (ld_s4444 & ~int_xyz_err)
            s4444 <= vid_in[5];
    end

//
// vid_std output register
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            vid_std <= 3'b000;
        else if (set_locked)
            vid_std <= std;
    end

assign xyz_err = int_xyz_err;

endmodule
