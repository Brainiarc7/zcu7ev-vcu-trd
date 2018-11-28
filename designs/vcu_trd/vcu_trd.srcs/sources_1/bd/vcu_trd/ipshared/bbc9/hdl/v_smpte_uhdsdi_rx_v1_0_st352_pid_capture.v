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

This module captures the SMPTE ST 352 payload ID packet. The payload output port
is only updated when the packet does not have a checksum error. The valid 
output is asserted as long at least one valid packet has been detected in the 
last VPID_TIMEOUT_VBLANKS vertical blanking intervals.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_rx_v1_0_0_st352_pid_capture #(  
    parameter VPID_TIMEOUT_VBLANKS = 4)
( 
    // inputs
    input  wire         clk,            // clock input
    input  wire         ce,             // clock enable
    input  wire         rst,            // sync reset input
    input  wire         sav,            // asserted on XYZ word of SAV
    input  wire [9:0]   vid_in,         // video data input
        
    // outputs
    output reg  [31:0]  payload = 0,    // {byte 4, byte 3, byte 2, byte 1}
    output reg          valid = 1'b0    // 1 when payload is valid
);

//-----------------------------------------------------------------------------
// Parameter definitions
//      

//
// This group of parameters defines the states of the finite state machine.
//
localparam STATE_WIDTH   = 4;
localparam STATE_MSB     = STATE_WIDTH - 1;

localparam [STATE_WIDTH-1:0]
    STATE_START     = 0,
    STATE_ADF2      = 1,
    STATE_ADF3      = 2,
    STATE_DID       = 3,
    STATE_SDID      = 4,
    STATE_DC        = 5,
    STATE_UDW0      = 6,
    STATE_UDW1      = 7,
    STATE_UDW2      = 8,
    STATE_UDW3      = 9,
    STATE_CS        = 10;

localparam MUXSEL_MSB = 2;

localparam [MUXSEL_MSB:0]
    MUX_SEL_000     = 0,
    MUX_SEL_3FF     = 1,
    MUX_SEL_DID     = 2,
    MUX_SEL_SDID    = 3,
    MUX_SEL_DC      = 4,
    MUX_SEL_CS      = 5;

localparam SR_MSB = VPID_TIMEOUT_VBLANKS - 1;

reg  [STATE_MSB:0]  current_state = STATE_START;
reg  [STATE_MSB:0]  next_state;
reg  [8:0]          checksum = 0;
reg                 old_v = 0;
reg                 v = 0;
wire                v_fall;
wire                v_rise;
reg                 packet_rx = 0;
reg [SR_MSB:0]      packet_det = 0;
reg [7:0]           byte1 = 0;
reg [7:0]           byte2 = 0;
reg [7:0]           byte3 = 0;
reg [7:0]           byte4 = 0;
reg                 ld_byte1;
reg                 ld_byte2;
reg                 ld_byte3;
reg                 ld_byte4;
reg                 ld_cs_err;
reg                 clr_cs;
reg [MUXSEL_MSB:0]  cmp_mux_sel;
reg [9:0]           cmp_mux;
wire                cmp_equal;
reg                 packet_ok = 1'b0;
reg                 v_fall_nxt = 1'b0;


//
// FSM: current_state register
//
// This code implements the current state register. 
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            current_state <= STATE_START;
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
        STATE_START:
            if (cmp_equal)
                next_state = STATE_ADF2;
            else
                next_state = STATE_START;
                
        STATE_ADF2:
            if (cmp_equal)
                next_state = STATE_ADF3;
            else
                next_state = STATE_START;

        STATE_ADF3:
            if (cmp_equal)
                next_state = STATE_DID;
            else
                next_state = STATE_START;

        STATE_DID:
            if (cmp_equal)
                next_state = STATE_SDID;
            else
                next_state = STATE_START;

        STATE_SDID:
            if (cmp_equal)
                next_state = STATE_DC;
            else
                next_state = STATE_START;

        STATE_DC:
            if (cmp_equal)
                next_state = STATE_UDW0;
            else
                next_state = STATE_START;

        STATE_UDW0:
            next_state = STATE_UDW1;

        STATE_UDW1:
            next_state = STATE_UDW2;

        STATE_UDW2:
            next_state = STATE_UDW3;

        STATE_UDW3:
            next_state = STATE_CS;

        STATE_CS:
            next_state = STATE_START;

        default:    next_state = STATE_START;
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
        ld_byte1    = 1'b0;
        ld_byte2    = 1'b0;
        ld_byte3    = 1'b0;
        ld_byte4    = 1'b0;
        ld_cs_err   = 1'b0;
        clr_cs      = 1'b0;
        cmp_mux_sel = MUX_SEL_000;
                                
        case(current_state) 

            STATE_START:    clr_cs = 1'b1;

            STATE_ADF2:     begin
                                cmp_mux_sel = MUX_SEL_3FF;
                                clr_cs = 1'b1;
                            end

            STATE_ADF3:     begin
                                cmp_mux_sel = MUX_SEL_3FF;
                                clr_cs = 1'b1;
                            end

            STATE_DID:      cmp_mux_sel = MUX_SEL_DID;

            STATE_SDID:     cmp_mux_sel = MUX_SEL_SDID;

            STATE_DC:       cmp_mux_sel = MUX_SEL_DC;

            STATE_UDW0:     ld_byte1 = 1'b1;

            STATE_UDW1:     ld_byte2 = 1'b1;

            STATE_UDW2:     ld_byte3 = 1'b1;

            STATE_UDW3:     ld_byte4 = 1'b1;

            STATE_CS:       begin
                                cmp_mux_sel = MUX_SEL_CS;
                                ld_cs_err = 1'b1;
                            end
        endcase
    end

//
// Comparator
//
// Compares the expected value of each word, except the user data words, to the
// received value.
//
always @ (*)
    case(cmp_mux_sel)
        MUX_SEL_000:    cmp_mux = 10'h000;
        MUX_SEL_3FF:    cmp_mux = 10'h3ff;
        MUX_SEL_DID:    cmp_mux = 10'h241;
        MUX_SEL_SDID:   cmp_mux = 10'h101;
        MUX_SEL_DC:     cmp_mux = 10'h104;
        MUX_SEL_CS:     cmp_mux = {~checksum[8], checksum};
        default:        cmp_mux = 10'h000;
    endcase

assign cmp_equal = cmp_mux == vid_in;

//
// User data word registers
//
always @ (posedge clk)
    if (ce & ld_byte1)
        byte1 <= vid_in[7:0];

always @ (posedge clk)
    if (ce & ld_byte2)
        byte2 <= vid_in[7:0];

always @ (posedge clk)
    if (ce & ld_byte3)
        byte3 <= vid_in[7:0];

always @ (posedge clk)
    if (ce & ld_byte4)
        byte4 <= vid_in[7:0];

//
// Checksum generation and error flag
//
always @ (posedge clk)
    if (ce) begin
        if (clr_cs)
            checksum <= 0;
        else
            checksum <= checksum + vid_in[8:0];
    end
    
always @ (posedge clk)
    if (ce) 
        packet_ok <= ld_cs_err & cmp_equal;

//
// Packet valid signal generation
//
// The valid output is updated immediatly if a packet is received. Once a
// packet has been detected in any of the last VPID_TIMEOUT_VBLANKS blanking 
// intervals, the valid output will be asserted.
//
always @ (posedge clk)
    if (ce & sav) begin
        v <= vid_in[7];
        old_v <= v;
    end
    
assign v_fall = old_v & ~v;
assign v_rise = ~old_v & v;

always @ (posedge clk)
    if (ce) begin
        if (rst)
            v_fall_nxt <= 1'b0;
        else
            v_fall_nxt <= v_fall;
    end
    
always @ (posedge clk)
    if (ce) begin
        if (rst)
            packet_rx <= 1'b0;
        else if (packet_ok)
            packet_rx <= 1'b1;
        else if (v_fall && !v_fall_nxt)
            packet_rx <= 1'b0;
    end

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            packet_det <= 0;
        else if (v_fall && !v_fall_nxt)
            packet_det <= {packet_det[SR_MSB - 1: 0], packet_rx};
    end

always @ (posedge clk) 
    if (ce)
    begin
        if (rst)
            valid <= 1'b0;
        else
            valid <= packet_rx | (|packet_det);
    end
         
//
// Output registers
//
// The payload register is loaded from the captured bytes at the same time that
// packet_rx is set -- when packet_ok is asserted.
//
always @ (posedge clk)
    if (ce & packet_ok)
        payload <= {byte4, byte3, byte2, byte1};

endmodule
