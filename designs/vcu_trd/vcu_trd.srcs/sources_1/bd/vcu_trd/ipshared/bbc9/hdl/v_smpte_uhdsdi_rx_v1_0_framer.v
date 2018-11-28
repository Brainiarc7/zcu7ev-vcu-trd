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

This is the RX framer module for the UHD-SDI receiver. It supports 10, 20, and
40-bit data paths and SD-SDI, HD-SDI, 3G-SDI, 6G-SDI, and 12G-SDI. 10-bit mode
is used for SD-SDI, 20-bit mode for HD-SDI and 3G-SDI, and 40-bit mode for 
6G-SDI and 12G-SDI.

In 10-bit mode, the data enters the framer on bits [19:10] of the din port
and exits the framer on bits [19:10] of the dout port. In 20-bit mode, the data 
must enter the framer on bits [19:0] of the din port and exits the framer on
bits [19:0] of the dout port with the C channel (data stream 1 ) on bits [9:0] 
and the Y channel (data stream 2) on the [19:10] bits. In 40-bit mode, the
assignment of data streams to the four 10-bit portions of the dout port are
dependent on the interleave structure of the data streams as shown below where
the / indicates difference in time (ie 8-way bits [9:0] carry DS8 on first
clock cycle and DS7 on second clock cycle):

            4-way     8-way                   16-way
[ 9: 0]     DS4     DS8 / DS7       DS15 / DS13 / DS16 / DS14
[19:10]     DS2     DS4 / DS3       DS7  / DS5  / DS8  / DS6
[29:20]     DS3     DS6 / DS5       DS11 / DS9  / DS12 / DS10
[39:30]     DS1     DS2 / DS1       DS3  / DS1  / DS4  / DS2

The framer searches for the 30-bit 3FF 000 000 pattern in all cases. In all 
modes except SD-SDI mode, the pattern match logic requires a leading 1 
immediately before the 3FF 000 000 pattern to prevent false detection that can
occur as a combination of the CRC words and the ADF in HD-SDI and 3G-SDI level A
modes. The framer will adjust its alignment when the TRS pattern is detected if
the frame_en input is High. If it is low, the alignment offset is not updated.
The nsp output will be asserted until the next TRS is detected when frame_en is
High. 

The trs output is asserted high for one clock cycle coincident with the 3FF of
the TRS pattern output on the dout register. For 3G-SDI level B and for 6G-SDI
and 12G-SDI with 8 or 16 interleaved streams, the TRS is coincident with the
last word of 3FF on each stream. The 3FF values prior to this clock cycle will
be properly aligned.

--------------------------------------------------------------------------------
*/

`timescale 1ns / 1ns
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_rx_v1_0_0_framer #(
    parameter RXDATA_WIDTH = 40)
(
    input  wire         clk,            // input clock
    input  wire         ce,             // clock enable
    input  wire         rst,            // reset signal
    input  wire [2:0]   mode,           // 000=HD, 001=SD, 010=3G, 100=6G, 101 and 110=12G
    input  wire [39:0]  din,            // input data
    output wire [39:0]  dout,           // output data
    output wire         trs,            // asserted for one clock cycle when a TRS is detected
    input  wire         frame_en,       // enables resynchronization when High
    output reg          nsp = 1'b1      // new start position detected
);

//------------------------------------------------------------------------------
// Internal signals
//
reg     [2:0]       mode_reg = 3'b000;
wire                b10;
wire                b20;
wire                b40;
reg     [39:0]      in_reg = 0;
reg     [39:0]      pipe_reg = 0;
reg     [69:0]      detect_in = 0;

wire    [29:0]      pattern = 30'b0000000000_0000000000_1111111111;
reg     [39:0]      match = 40'd0;

reg     [5:0]       loc;
reg     [5:0]       loc_reg = 6'b0;
reg     [5:0]       offset_reg = 6'b0;
wire                match_found;
reg                 load_offset = 1'b0;
integer             i,j;

reg     [79:0]      barrel_in = 80'b0;
reg     [79:0]      barrel_pipe0 = 80'b0;
reg     [79:0]      barrel_pipe1 = 80'b0;
reg     [79:0]      barrel_pipe2 = 80'b0;
reg     [79:0]      barrel_pipe3 = 80'b0;
reg     [79:0]      barrel_pipe4 = 80'b0;
reg     [8:0]       trs_dly = 9'b000000000;
reg     [3:0]       trs_dly_value = 4'h4;
reg                 trs_int = 1'b0;



reg     [39:0]      mask = 40'b0000000000_0000000000_1111111111_1111111111;
wire    [39:0]      barrel_out;
reg     [39:0]      out_pipe0 = 40'b0;
reg     [39:0]      out_pipe1 = 40'b0;
reg     [39:0]      out_pipe2 = 40'b0;
reg     [39:0]      out_reg = 40'b0;
     
//------------------------------------------------------------------------------
// Input and data pipeline registers. These provide a wide enough input data
// vector for the match unit to look at. In 40-bit mode, the input vector is
// 70 bits, in 20-bit mode it is 60 bits, and in 10-bit mode it is 40 bits.
//
always @ (posedge clk)
    if (ce)
        mode_reg <= mode;
generate 
if(RXDATA_WIDTH == 40)
begin
    assign b40 = mode_reg == 3'b100 || mode_reg == 3'b101 || mode_reg == 3'b110;
end
else
begin
    assign b40 = 1'd0;
end
endgenerate

assign b20 = mode_reg == 3'b000 || mode_reg == 3'b010;
assign b10 = mode_reg == 3'b001;


always @ (posedge clk)
    if (ce)
        in_reg <= din;

always @ (posedge clk)
    if (ce)
    begin
        pipe_reg[9:0]   <= b10 ? in_reg[19:10]   : in_reg[9:0];     // In 10-bit mode, the valid 10 bits are on din[19:10]
        pipe_reg[19:10] <= b10 ? pipe_reg[9:0]   : in_reg[19:10];
        pipe_reg[29:20] <= b10 ? pipe_reg[19:10] : b20 ? pipe_reg[9:0]   : in_reg[29:20];
        pipe_reg[39:30] <= b10 ? pipe_reg[29:20] : b20 ? pipe_reg[19:10] : in_reg[39:30];
    end
//------------------------------------------------------------------------------
// TRS Detection Logic
//
// Create a detect_in vector to the pattern matching logic that has the order of
// the bits arranged so that the most recently received bit is the LSB and the
// first bit received is the MSB. The valid bits in the detect_in vector is 
// dependent upon the width of the input data vector.
//

generate
    if(RXDATA_WIDTH == 40)
    begin
        always @ (posedge clk)
            if (ce)
            begin
                if (b10)
                    detect_in <= {30'b0, pipe_reg[9:0], pipe_reg[19:10], pipe_reg[29:20], pipe_reg[39:30]};
                else if (b20)
                    detect_in <= {20'b0, in_reg[9:0], pipe_reg[19:0], pipe_reg[39:20]};
                else
                    detect_in <= {in_reg[29:0], pipe_reg};
            end
     end
     else
     begin
        always @ (posedge clk)
            if (ce)
            begin
                if (b10)
                    detect_in <= {30'b0, pipe_reg[9:0], pipe_reg[19:10], pipe_reg[29:20], pipe_reg[39:30]};
                else if (b20)
                    detect_in <= {20'b0, in_reg[9:0], pipe_reg[19:0], pipe_reg[39:20]};
            end
     end
endgenerate

//
// The mask vector determines which starting locations are valid based on the
// input data width.
//
//generate 
//if(RXDATA_WIDTH == 40)
//begin
//reg     [39:0]      mask = 40'b0000000000_0000000000_1111111111_1111111111;
//always @ (posedge clk)
//    if (ce)
//        mask <= b10 ? 40'b0000000000_0000000000_0000000000_1111111111 : 
//                b20 ? 40'b0000000000_0000000000_1111111111_1111111111 : 
//                      40'b1111111111_1111111111_1111111111_1111111111;
//end
//endgenerate


generate 
    if(RXDATA_WIDTH == 40)
    begin
        //
        // The mask vector determines which starting locations are valid based on the
        // input data width.
        //

        always @ (posedge clk)
            if (ce)
                mask <= b10 ? 40'b0000000000_0000000000_0000000000_1111111111 : 
                        b20 ? 40'b0000000000_0000000000_1111111111_1111111111 : 
                              40'b1111111111_1111111111_1111111111_1111111111;
        //
        // This is the pattern matching logic. It compares the 30 or 31 bit TRS preamble 
        // pattern to detect_in vector at each of the possible bit offset.
        //


        always @ (posedge clk)
            if (ce)
                for (i=0; i<40; i=i+1)
                    if (b10)
                        match[i] <= (detect_in[i +: 30] == pattern) && mask[i];
                    else
                        match[i] <= (detect_in[i+1 +: 30] == pattern) && detect_in[i] && mask[i];
    end
    else
    begin
        always @ (posedge clk)
        begin
            if (ce)
            begin
                    if (b10)
                    begin
                        match[0] <= (detect_in[0 +: 30] == pattern);
                        match[1] <= (detect_in[1 +: 30] == pattern);
                        match[2] <= (detect_in[2 +: 30] == pattern);
                        match[3] <= (detect_in[3 +: 30] == pattern);
                        match[4] <= (detect_in[4 +: 30] == pattern);
                        match[5] <= (detect_in[5 +: 30] == pattern);
                        match[6] <= (detect_in[6 +: 30] == pattern);
                        match[7] <= (detect_in[7 +: 30] == pattern);
                        match[8] <= (detect_in[8 +: 30] == pattern);
                        match[9] <= (detect_in[9 +: 30] == pattern);
                        match[39:10] <= 30'd0;
                    end
                    else
                    begin
                        match[39:20] <= 20'd0;
                        for (i=0; i<20; i=i+1)
                            match[i] <= (detect_in[i+1 +: 30] == pattern) && detect_in[i];
                    end
            end
        end
    end
endgenerate

//
// This logic scans the match vector produced above to determine the bit offset
// of the match. The resulting loc variable is the offset location of the pattern
// in the detect_in vector. The match_found signal will be High if a pattern
// match was found, Low otherwise.
//
generate
    if(RXDATA_WIDTH == 40)
    begin
        always @ (*)
        begin
            loc = 6'b0;
            for (j=0; j<40; j=j+1)
                if (match[j])
                    loc = j;
        end
    end
    else
    begin
        always @ (*)
        begin
            loc = 6'b0;
            for (j=0; j<20; j=j+1)
                if (match[j])
                    loc = j;
        end
    end
endgenerate

always @ (posedge clk)
    if (ce)
        loc_reg <= loc + (b10 ? 6'b000000 : 6'b000001);

assign match_found = |match;

always @ (posedge clk)
    if (ce)
        load_offset <= match_found & frame_en;

//
// In 20-bit and 40-bit mode, because of the extra leading 1 requirement, the
// number of bits to shift needs to be increased by one lane value (10 bits).
// This needs to be wrapped around so as not to exceed 40 bits of offset.
//
always @ (posedge clk)
    if (ce)
        if (load_offset)
        begin
            if (b40 | b20)
                offset_reg <= loc_reg + (loc_reg > 30 ? -30 : 10);
            else
                offset_reg <= loc_reg;
        end

always @ (posedge clk)
    if (ce)
        if (match_found)
        begin
            if (loc_reg == offset_reg)
                nsp <= 1'b0;
            else
                nsp <= 1'b1;
        end

//------------------------------------------------------------------------------
// Barrel shifter
//
// The input vector is shifted by the offset stored in the offset_reg. Some
// pipeline registers are required in order to make sure leading 3FF values
// are also shifted by the new offset value when multiple streams are 
// interleaved. The delay from the barrel shifters implemented here support up
// to 16 interleaved data streams.
//
generate
    if(RXDATA_WIDTH == 40)
    begin
        always @ (posedge clk)
            if (ce)
            begin
                barrel_pipe0 <= b40 ? {pipe_reg, barrel_pipe0[79:40]} : {10'b0, detect_in};
                barrel_pipe1 <= barrel_pipe0;
                barrel_pipe2 <= barrel_pipe1;
                barrel_pipe3 <= barrel_pipe2;
                barrel_pipe4 <= barrel_pipe3;
                barrel_in    <= barrel_pipe4;
            end
        assign barrel_out = barrel_in[offset_reg +: 40];
        always @ (posedge clk)
            if (ce)
            begin
                out_pipe0 <= barrel_out;
                out_pipe1 <= out_pipe0;
                out_pipe2 <= out_pipe1;
                out_reg   <= b40 ? out_pipe2 : out_pipe0;
            end
        assign dout = out_reg;
     end
     else
     begin
        always @ (posedge clk)
            if (ce)
            begin
                barrel_pipe0 <= {10'b0, detect_in};
                barrel_pipe1 <= barrel_pipe0;
                barrel_pipe2 <= barrel_pipe1;
                barrel_pipe3 <= barrel_pipe2;
                barrel_pipe4 <= barrel_pipe3;
                barrel_in    <= barrel_pipe4;
            end
        assign barrel_out = {20'd0,barrel_in[offset_reg +: 20]};
        always @ (posedge clk)
            if (ce)
            begin
                out_pipe0 <= barrel_out;
                out_reg   <= out_pipe0;
            end
        assign dout = out_reg;

     end
endgenerate






                  
//------------------------------------------------------------------------------
// TRS signal generation logic
//
generate
    if(RXDATA_WIDTH == 40)
    begin
        always @ (posedge clk)
            if (b40 && (offset_reg < 11))
                trs_dly_value <= 7;
            else if (b40)
                trs_dly_value <= 6;
            else
                trs_dly_value <= 4;

        always @ (posedge clk)
            if (ce)
            begin
                if (rst)
                begin
                    trs_dly <= 9'b000000000;
                    trs_int <= 1'b0;
                end
                else
                begin
                    trs_dly <= {trs_dly[7:0], match_found};
                    trs_int <= trs_dly[trs_dly_value];
                end
            end
    end
    else
    begin
        always @ (posedge clk)
            if (ce)
            begin
                if (rst)
                begin
                    trs_dly <= 9'b000000000;
                    trs_int <= 1'b0;
                end
                else
                begin
                    trs_dly <= {trs_dly[7:0], match_found};
                    trs_int <= trs_dly[4];
                end
            end
    end
endgenerate



assign trs = trs_int;

endmodule
