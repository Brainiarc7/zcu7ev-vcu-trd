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

This module performs the bit replication of the incoming data. Each input bit is
replicated 11 times. The module generates 20 bits on every clock cycle. This 
module requires an alternating cadence of 5/6/5/6 on the clock enable (ce) 
input. The state machine automatically aligns itself regardless of whether the 
first step of the cadence is 5 or 6 when it starts up. If the 5/6/5/6 cadence 
gets out of step, the state machine will realign itself and will also assert the
align_err output for one clock cycle.

--------------------------------------------------------------------------------
*/

`timescale 1ns / 1ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_tx_v1_0_0_bitrep_20b (
    input  wire             clk,                // clock input
    input  wire             rst,                // sync reset 
    input  wire             ce,                 // clock enable 
    input  wire [9:0]       d,                  // input data
    output reg  [19:0]      q = 0,              // output data
    output reg              align_err = 1'b0);  // ce alignment error



//-------------------------------------------------------------------
// Parameter definitions
//

localparam STATE_WIDTH = 4;
localparam STATE_MSB   = STATE_WIDTH - 1;

localparam [STATE_MSB:0] 
    START = 4'b1111,
    S0    = 4'b0000,
    S1    = 4'b0001,
    S2    = 4'b0010,
    S3    = 4'b0011,
    S4    = 4'b0100,
    S5    = 4'b0101,
    S6    = 4'b0110,
    S7    = 4'b0111,
    S8    = 4'b1000,
    S9    = 4'b1001,
    S10   = 4'b1010,
    S5X   = 4'b1011;
  
//--------------------------------------------------------------------
// Signal definitions
//

reg  [STATE_MSB:0]  current_state = START;
reg  [STATE_MSB:0]  next_state;
reg  [9:0]          in_reg = 0;
reg  [9:0]          d_reg = 0;
reg                 b9_save = 1'b0;
reg                 ce_dly = 1'b0;
reg  [19:0]         q_int;

//
// Input registers
//
always @ (posedge clk)
    if (ce)
        in_reg <= d;
        
always @ (posedge clk)
    ce_dly <= ce;
    
always @ (posedge clk)
    if (ce_dly)
        d_reg <= in_reg;                

always @ (posedge clk)
    if (ce_dly)
        b9_save <= d_reg[9];

//
// FSM: current_state register
//
// This code implements the current state register. It loads with the S0
// state on reset and the next_state value with each rising clock edge.
//
always @ (posedge clk)
    if (rst)
        current_state <= START;
    else 
        current_state <= next_state;
        

// FSM: next_state logic
//
// This case statement generates the next_state value for the FSM based on
// the current_state and the various FSM inputs.
//        
always@ *
    case(current_state)
        START:  if (ce_dly)
                    next_state = S0;
                else
                    next_state = START;
        
        S0:     next_state = S1;
        
        S1:     next_state = S2;
        
        S2:     next_state = S3;
        
        S3:     next_state = S4;
        
        S4:     if (ce_dly) 
                    next_state = S5;
                else
                    next_state = S5X;
        
        S5:     next_state = S6;            // Two different state 5's depending
                                            // on when the occurred
        S5X:    next_state = S6;
        
        S6:     next_state = S7;
        
        S7:     next_state = S8;
        
        S8:     next_state = S9;
        
        S9:     next_state = S10;
        
        S10:    if (ce_dly) 
                    next_state = S0; 
                else 
                    next_state = START;
        
        default: next_state = START; 
    endcase 

//
// Output mux
//
// Use the current state encoding to select the output bits.
//
always @ *
    case(current_state)
        S1:         q_int = { {7{d_reg[3]}}, {11{d_reg[2]}}, {2{d_reg[1]}}};
        S2:         q_int = { {5{d_reg[5]}}, {11{d_reg[4]}}, {4{d_reg[3]}}};
        S3:         q_int = { {3{d_reg[7]}}, {11{d_reg[6]}}, {6{d_reg[5]}}};
        S4:         q_int = {    d_reg[9],   {11{d_reg[8]}}, {8{d_reg[7]}}};
        S5:         q_int = {{10{d_reg[0]}}, {10{b9_save}}};                
        S6:         q_int = { {8{d_reg[2]}}, {11{d_reg[1]}},    d_reg[0]};
        S7:         q_int = { {6{d_reg[4]}}, {11{d_reg[3]}}, {3{d_reg[2]}}};
        S8:         q_int = { {4{d_reg[6]}}, {11{d_reg[5]}}, {5{d_reg[4]}}};
        S9:         q_int = { {2{d_reg[8]}}, {11{d_reg[7]}}, {7{d_reg[6]}}};
        S10:        q_int = {{11{d_reg[9]}}, { 9{d_reg[8]}}};               
        S5X:        q_int = {{10{in_reg[0]}},{10{d_reg[9]}}};               
        default:    q_int = { {9{d_reg[1]}}, {11{d_reg[0]}}};               
    endcase

always @ (posedge clk)
    q <= q_int;
        
always @ (posedge clk)
    align_err <= ((current_state == S10) || (current_state == S5X)) & ~ce_dly;

endmodule
