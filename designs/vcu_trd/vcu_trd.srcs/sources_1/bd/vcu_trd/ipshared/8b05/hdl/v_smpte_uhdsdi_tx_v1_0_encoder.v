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

This modules implements a SMPTE SDI scrambler. It operates in 10-bit mode for
SD-SDI, with the active bits on [19:10] of the input and output ports, 20-bit
mode for HD-SDI and 3G-SDI, and 40-bit mode for 6G-SDI and 12G-SDI. 
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_tx_v1_0_0_encoder #(
    parameter C_LINE_RATE = 0
    )
(
    input  wire         clk,        // input clock
    input  wire         ce,         // input register load signal
    input  wire [2:0]   mode,       // 000=HD, 001=SD, 010=3G, 100=6G, 101=12G
    input  wire         nrzi,       // enables NRZ-to-NRZI conversion when high
    input  wire         scram,      // enables SDI scrambler when high
    input  wire [39:0]  d,          // input data port
    output wire [39:0]  q           // output data port
);


//
// Signal definitions
//
reg     [39:0]      in_reg = 40'b0;     // C channel input register
reg     [2:0]       mode_reg = 3'b0;    // SDI mode input register
reg                 scram_reg = 1'b1;
reg                 nrzi_reg = 1'b1;
wire    [8:0]       u0_i_scram;         // intermediate scrambled data from scrambler 0
wire    [8:0]       u1_i_scram;         // intermediate scrambled data from scrambler 1
wire    [8:0]       u2_i_scram;         // intermediate scrambled data from scrambler 2
wire                u0_i_nrzi;          // intermediate nrzi data from scrambler 0
wire                u1_i_nrzi;          // intermediate nrzi data from scrambler 1
wire                u2_i_nrzi;          // intermediate nrzi data from scrambler 2
wire    [8:0]       u1_i_scram_q;       // registered intermediate scrambled data from scrambler 1
wire    [8:0]       u3_i_scram_q;       // registered intermediate scrambled data from scrambler 3
wire    [39:0]      scram_out;          // output of scrambler
wire    [8:0]       u0_p_scram_mux;     // p_scram input MUX for scrambler 0
wire                u0_p_nrzi_mux;      // p_nrzi input MUX for scrambler 0
wire    [8:0]       u1_p_scram_mux;     // p_scram input MUX for scrambler 1
wire                u1_p_nrzi_mux;      // p_nrzi input MUX for scrambler 1
wire                mode_40b;
wire                mode_SD;

//
// Input registers
//
always @ (posedge clk)
    if (ce)
    begin
        in_reg <= d;
        mode_reg <= mode;
        scram_reg <= scram;
        nrzi_reg <= nrzi;
    end

assign mode_SD = mode_reg == 3'b001;
assign mode_40b = mode_reg[2];

//
// Scrambler modules
//
assign u0_p_scram_mux = mode_40b ? u3_i_scram_q : u1_i_scram_q;
assign u0_p_nrzi_mux  = mode_40b ? scram_out[39] : scram_out[19];

v_smpte_uhdsdi_tx_v1_0_0_scrambler SCRAM0 (
    .clk        (clk),
    .ce         (ce),
    .nrzi       (nrzi_reg),
    .scram      (scram_reg),
    .d          (in_reg[9:0]),
    .p_scram    (u0_p_scram_mux),
    .p_nrzi     (u0_p_nrzi_mux),
    .q          (scram_out[9:0]),
    .i_scram    (u0_i_scram),
    .i_scram_q  (),
    .i_nrzi     (u0_i_nrzi)
);

assign u1_p_scram_mux = mode_SD ? u1_i_scram_q : u0_i_scram;
assign u1_p_nrzi_mux  = mode_SD ? scram_out[19] : u0_i_nrzi;

v_smpte_uhdsdi_tx_v1_0_0_scrambler SCRAM1 (
    .clk        (clk),
    .ce         (ce),
    .nrzi       (nrzi_reg),
    .scram      (scram_reg),
    .d          (in_reg[19:10]),
    .p_scram    (u1_p_scram_mux),
    .p_nrzi     (u1_p_nrzi_mux),
    .q          (scram_out[19:10]),
    .i_scram    (u1_i_scram),
    .i_scram_q  (u1_i_scram_q),
    .i_nrzi     (u1_i_nrzi)
);
generate
    if(C_LINE_RATE == 0)
    begin
v_smpte_uhdsdi_tx_v1_0_0_scrambler SCRAM2 (
    .clk        (clk),
    .ce         (ce & mode_40b),
    .nrzi       (nrzi_reg),
    .scram      (scram_reg),
    .d          (in_reg[29:20]),
    .p_scram    (u1_i_scram),
    .p_nrzi     (u1_i_nrzi),
    .q          (scram_out[29:20]),
    .i_scram    (u2_i_scram),
    .i_scram_q  (),
    .i_nrzi     (u2_i_nrzi)
);

v_smpte_uhdsdi_tx_v1_0_0_scrambler SCRAM3 (
    .clk        (clk),
    .ce         (ce & mode_40b),
    .nrzi       (nrzi_reg),
    .scram      (scram_reg),
    .d          (in_reg[39:30]),
    .p_scram    (u2_i_scram),
    .p_nrzi     (u2_i_nrzi),
    .q          (scram_out[39:30]),
    .i_scram    (),
    .i_scram_q  (u3_i_scram_q),
    .i_nrzi     ()
);
    end
    else
    begin
        assign scram_out[39:20] = 20'd0;
    end
endgenerate

assign q = scram_out;

endmodule
