// (c) Copyright 2014 - 2015 Xilinx, Inc. All rights reserved.
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

This is the SDI stream demux function. It takes in an interleaved stream and
separates it into one, two, or four elementary streams. It generates a clock
enable output with a duty cycle appropriate to the SDI mode and number of
interleaved data streams. It also generates trs, eav, and sav output timing
signals and an active_streams_out signal that indicates how many streams are
active. In a fully populated 12G-SDI RX, four of these demux modules operate in
parallel to demux up to 16 interleaved streams.
--------------------------------------------------------------------------------
*/
`timescale 1ns / 1ns
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_rx_v1_0_0_demux_4 #(
    parameter TRS_OUTPUTS  = 1,
    parameter RXDATA_WIDTH = 40)
    (
    input   wire        clk,                // input clock
    input   wire        rst,                // reset
    input   wire        ce_in,              // input clock enable
    input   wire        sd_data_strobe,     // SD-SDI data strobe
    input   wire [2:0]  mode,               // SDI mode input
    input   wire        trs_in,             // TRS input signal 
    input   wire [9:0]  din,                // input data
    output  wire [3:0]  active_streams_out, // indicates which streams should be active
    output  reg  [9:0]  ds1 = 10'h000,      // data stream 1 output
    output  reg  [9:0]  ds2 = 10'h000,      // data stream 2 output
    output  reg  [9:0]  ds3 = 10'h000,      // data stream 3 output
    output  reg  [9:0]  ds4 = 10'h000,      // data stream 4 output
    output  wire        ce_out,             // output clock enable
    output  wire        trs_out,            // asserted during all 4 words of each EAV and SAV
    output  reg         eav_out = 1'b0,     // asserted during XYZ word of each EAV
    output  reg         sav_out = 1'b0      // asserted during XYZ word of each SAV
);

//
// Internal signals
//
reg     [2:0]   pipe3ff = 3'b000;
reg     [9:0]   din_reg = 10'b0;
reg             trs_reg = 0;
reg     [2:0]   mode_reg = 3'b0;
reg     [9:0]   pipe0 = 10'b0;
reg     [9:0]   pipe1 = 10'b0;
reg     [9:0]   pipe2 = 10'b0;
reg     [9:0]   pipe3 = 10'b0;

reg     [3:0]   active_streams = 4'b0001;
reg     [3:0]   ce_gen = 4'b1111;
reg     [3:0]   ce_pattern = 4'b1111;
reg     [4:0]   trs_gen = 5'b00000;
//
// Input registers
//
generate
if(RXDATA_WIDTH == 40)
begin
always @ (posedge clk)
    if (ce_in) 
    begin
        din_reg <= din;
        trs_reg <= trs_in;
        mode_reg <= mode;
    end

//
// This is a 4 level deep input pipeline for the input data.
//
always @ (posedge clk)
    if (ce_in)
    begin
        pipe0 <= din_reg;
        pipe1 <= pipe0;
        pipe2 <= pipe1;
        pipe3 <= pipe2;
    end

//
// For each word in the input pipeline, record if that word is all in the
// pipe3ff shift register. The number of data words that are all ones is the
// factor used to determine how many data streams are interleaved.
//
always @ (posedge clk)
    if (ce_in)
        pipe3ff <= {pipe3ff[1:0], &din_reg};

//
// This code determines the number of streams that are interleaved together.
// It sets the active_streams signal to indicate the number of active streams
// and also sets the ce_pattern signal which is used to create the correct duty
// cycle for the clock enable.
//
always @ (posedge clk)
    if (rst)
    begin
        active_streams <= 4'b0001;
        ce_pattern <= 4'b1111;
    end
    else if (ce_in & trs_reg)
    begin
        if (mode_reg[2:1] == 2'b00)         // HD-SDI & SD-SDI Modes
        begin
            active_streams <= 4'b0001;
            ce_pattern <= 4'b1111;
        end
        else if (pipe3ff[2])                // 4 streams interleaved
        begin
            active_streams <= 4'b1111;
            ce_pattern <= 4'b1000;
        end
        else if (pipe3ff[0])                // 2 streams interleaved
        begin
            active_streams <= 4'b0011;
            ce_pattern <= 4'b1010;
        end
        else
        begin
            active_streams <= 4'b0001;      // 1 stream only
            ce_pattern <= 4'b1111;
        end
    end

assign active_streams_out = active_streams;     

//
// This is the clock enable generator. In SD-SDI mode, the clock enable is
// equal to the data strobe from the NI-DRU. In all other modes, the clock
// enable is created using the ce_pattern signal that is based on the SDI mode
// and number of interleaved streams. In all modes except SD-SDI, the ce_gen
// shift register is reloaded whenever the trs input signal is asserted and
// that pattern constantly circulates through the ce_gen shift register until
// the next TRS when it is reloaded.
//
always @ (posedge clk)
    if (rst)
        ce_gen <= 4'b1111;
    else if (mode == 3'b001)                        // SD-SDI mode
        ce_gen <= {sd_data_strobe, 3'b000};
    else
    begin
        if (trs_reg)                                // All other modes
            ce_gen <= ce_pattern;
        else
            ce_gen <= {ce_gen[2:0], ce_gen[3]};
    end
                         
assign ce_out = ce_gen[3];

//
// Set the data stream outputs from the input pipe line registers.
//
always @ (posedge clk)
    if (ce_out)
    begin
        ds2 <= pipe0;
        ds1 <= pipe1;
        ds4 <= pipe2;
        ds3 <= pipe3;
    end 
  
//
// Generate the trs, eav, and sav output signals.
//
if(TRS_OUTPUTS == 1)
begin

always @ (posedge clk)
    if (trs_reg)
        trs_gen <= 5'b01111;
    else if (ce_out)
        trs_gen <= {trs_gen[3:0], 1'b0};

assign trs_out = trs_gen[4];

always @ (posedge clk)
    if (ce_out)
    begin
        if (trs_gen == 5'b11000)
        begin
            eav_out <= pipe0[6];
            sav_out <= ~pipe0[6];
        end
        else
        begin
            eav_out <= 1'b0;
            sav_out <= 1'b0;
        end
    end
end

end
else
begin


//
// Input registers
//
always @ (posedge clk)
    if (ce_in) 
    begin
        din_reg <= din;
        trs_reg <= trs_in;
        mode_reg <= mode;
    end

//
// This is a 4 level deep input pipeline for the input data.
//
always @ (posedge clk)
    if (ce_in)
    begin
        pipe0 <= din_reg;
        pipe1 <= pipe0;
    end

//
// For each word in the input pipeline, record if that word is all in the
// pipe3ff shift register. The number of data words that are all ones is the
// factor used to determine how many data streams are interleaved.
//
always @ (posedge clk)
    if (ce_in)
        pipe3ff <= {pipe3ff[1:0], &din_reg};

//
// This code determines the number of streams that are interleaved together.
// It sets the active_streams signal to indicate the number of active streams
// and also sets the ce_pattern signal which is used to create the correct duty
// cycle for the clock enable.
//
always @ (posedge clk)
    if (rst)
    begin
        active_streams <= 4'b0001;
        ce_pattern <= 4'b1111;
    end
    else if (ce_in & trs_reg)
    begin
        if (mode_reg[2:1] == 2'b00)         // HD-SDI & SD-SDI Modes
        begin
            active_streams <= 4'b0001;
            ce_pattern <= 4'b1111;
        end
        else if(pipe3ff[0])                // 2 streams interleaved
        begin
            active_streams <= 4'b0011;
            ce_pattern <= 4'b1010;
        end
    end

assign active_streams_out = active_streams;     

//
// This is the clock enable generator. In SD-SDI mode, the clock enable is
// equal to the data strobe from the NI-DRU. In all other modes, the clock
// enable is created using the ce_pattern signal that is based on the SDI mode
// and number of interleaved streams. In all modes except SD-SDI, the ce_gen
// shift register is reloaded whenever the trs input signal is asserted and
// that pattern constantly circulates through the ce_gen shift register until
// the next TRS when it is reloaded.
//
always @ (posedge clk)
    if (rst)
        ce_gen <= 4'b1111;
    else if (mode == 3'b001)                        // SD-SDI mode
        ce_gen <= {sd_data_strobe, 3'b000};
    else
    begin
        if (trs_reg)                                // All other modes
            ce_gen <= ce_pattern ;
        else
            ce_gen <= {ce_gen[2:0], ce_gen[3]};
    end
                         
assign ce_out = ce_gen[3];

//
// Set the data stream outputs from the input pipe line registers.
//
always @ (posedge clk)
    if (ce_out)
    begin
        ds2 <= pipe0;
        ds1 <= pipe1;
    end 
  
//
// Generate the trs, eav, and sav output signals.
//
if(TRS_OUTPUTS == 1)
begin
reg     [4:0]   trs_gen = 5'b00000;

always @ (posedge clk)
    if (trs_reg)
        trs_gen <= 5'b01111;
    else if (ce_out)
        trs_gen <= {trs_gen[3:0], 1'b0};

assign trs_out = trs_gen[4];

always @ (posedge clk)
    if (ce_out)
    begin
        if (trs_gen == 5'b11000)
        begin
            eav_out <= pipe0[6];
            sav_out <= ~pipe0[6];
        end
        else
        begin
            eav_out <= 1'b0;
            sav_out <= 1'b0;
        end
    end
end

end
endgenerate
endmodule
