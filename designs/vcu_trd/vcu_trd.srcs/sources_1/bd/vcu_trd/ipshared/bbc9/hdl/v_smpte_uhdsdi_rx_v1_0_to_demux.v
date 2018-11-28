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
//------------------------------------------------------------------------------
/*
Module Description:

This is the first part of the SDI RX data path, up to and including the stream
demux unit. It contains the descrambler, the framer, and the demux. For SD-SDI,
it also contains the NI-DRU.

*/
`timescale 1ns / 1ns
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_rx_v1_0_0_to_demux #(
    parameter           MAX_RXDATA_WIDTH = 40)
(
    input   wire                        clk,                // connect to GT RXUSRCLK
    input   wire                        sd_data_strobe,     // SD-SDI data strobe from NI-DRU
    input   wire                        rst,                // synchronous reset
    input   wire [MAX_RXDATA_WIDTH-1:0] rxdata,             // connect to GT RXDATA
    input   wire [2:0]                  mode,               // SDI mode
    input   wire                        frame_en,           // 1 to enable framer
    output  wire                        nsp,                // 1 when a new bit alignment is detected by framer
    output  wire                        ce_out,             // clock enable output
    output  reg                         trs = 1'b0,
    output  reg                         eav = 1'b0,
    output  reg                         sav = 1'b0,
    output  reg                         level_b = 1'b0,
    output  wire                        raw_sav,
    output  wire                        muxed_ds_ce,
    output  reg  [2:0]                  active_streams = 3'b001,    
    output  reg  [9:0]                  ds1 = 10'h000,
    output  reg  [9:0]                  ds2 = 10'h000,
    output  reg  [9:0]                  ds3 = 10'h000,
    output  reg  [9:0]                  ds4 = 10'h000,
    output  reg  [9:0]                  ds5 = 10'h000,
    output  reg  [9:0]                  ds6 = 10'h000,
    output  reg  [9:0]                  ds7 = 10'h000,
    output  reg  [9:0]                  ds8 = 10'h000,
    output  reg  [9:0]                  ds9 = 10'h000,
    output  reg  [9:0]                  ds10 = 10'h000,
    output  reg  [9:0]                  ds11 = 10'h000,
    output  reg  [9:0]                  ds12 = 10'h000,
    output  reg  [9:0]                  ds13 = 10'h000,
    output  reg  [9:0]                  ds14 = 10'h000,
    output  reg  [9:0]                  ds15 = 10'h000,
    output  reg  [9:0]                  ds16 = 10'h000
);

reg                         int_ce = 1'b0;
wire [MAX_RXDATA_WIDTH-1:0] desc_out;
wire [39:0] framer_in;
wire [39:0] framer_out;
wire [39:0] restore_out;
wire                        framer_trs;
wire                        restore_trs;
wire [3:0]                  demux1_active_streams;
wire [9:0]                  demux1_ds1;
wire [9:0]                  demux1_ds2;
wire [9:0]                  demux1_ds3;
wire [9:0]                  demux1_ds4;
wire                        demux1_ce;
wire                        demux1_trs;
wire                        demux1_eav;
wire                        demux1_sav;
wire [9:0]                  demux2_ds1;
wire [9:0]                  demux2_ds2;
wire [9:0]                  demux2_ds3;
wire [9:0]                  demux2_ds4;
wire [9:0]                  demux3_ds1;
wire [9:0]                  demux3_ds2;
wire [9:0]                  demux3_ds3;
wire [9:0]                  demux3_ds4;
wire [9:0]                  demux4_ds1;
wire [9:0]                  demux4_ds2;
wire [9:0]                  demux4_ds3;
wire [9:0]                  demux4_ds4;
reg                         trs_dly = 1'b0;
reg                         sav_dly = 1'b0;
reg                         eav_dly = 1'b0;

wire levelb_3g;
reg [9:0] din_reg = 10'b0;
reg [9:0] pipe0 = 10'b0;
reg [9:0] pipe1 = 10'b0;
reg [9:0] demux2_ds2_reg = 10'b0;
reg [9:0] demux2_ds1_reg = 10'b0;
//
// This is the internal clock enable signal for this module. It is High always
// in all SDI modes except SD-SDI where it follows the sd_data_strobe signal.
//
always @ (posedge clk)
    if (mode == 3'b001)
        int_ce <= sd_data_strobe;
    else
        int_ce <= 1'b1;

//
// The decoder descrambles the SDI signal.
//
v_smpte_uhdsdi_rx_v1_0_0_decoder #(
    .WIDTH      (MAX_RXDATA_WIDTH))
DEC (
    .clk        (clk),
    .ce         (int_ce),
    .mode       (mode),
    .din        (rxdata),
    .dout       (desc_out));

generate
if(MAX_RXDATA_WIDTH == 40)
begin
assign framer_in = desc_out;
end
else
begin
assign framer_in = {20'd0,desc_out};
end
endgenerate

//
// The framer looks for SAV and EAV sequences and aligns the data to the proper
// word alignment.
//
v_smpte_uhdsdi_rx_v1_0_0_framer #(
    .RXDATA_WIDTH      (MAX_RXDATA_WIDTH))
FRM (
    .clk        (clk),
    .ce         (int_ce),
    .rst        (rst),
    .mode       (mode),
    .din        (framer_in),
    .dout       (framer_out),
    .trs        (framer_trs),
    .frame_en   (frame_en),
    .nsp        (nsp));

assign raw_sav = framer_trs & ~framer_out[6];
assign muxed_ds_ce = int_ce;

//
// The trs_restore module undoes the run length mitigation of 6G-SDI and 12G-SDI,
// converting words where the upper 8 bits are all ones to a value of 0x3FF and
// converting words where the upper 8 bits are all zeros to a value of 0x000.
//
generate
    if(MAX_RXDATA_WIDTH == 40)
    begin
        v_smpte_uhdsdi_rx_v1_0_0_trs_restore RSTR (
            .clk        (clk),
            .ce         (int_ce),
            .trs_in     (framer_trs),
            .trs_out    (restore_trs),
            .din        (framer_out),
            .dout       (restore_out));
    end
    else
    begin
        assign restore_out = framer_out;
        assign restore_trs = framer_trs;
    end
endgenerate

//
// These are the stream demux modules.
//
generate
    if(MAX_RXDATA_WIDTH == 40)
    begin
v_smpte_uhdsdi_rx_v1_0_0_demux_4 #(
    .TRS_OUTPUTS    (1),
    .RXDATA_WIDTH   (MAX_RXDATA_WIDTH))
    DMUX1 (
    .clk                (clk),
    .rst                (rst),
    .ce_in              (int_ce),
    .sd_data_strobe     (sd_data_strobe),
    .mode               (mode),
    .trs_in             (restore_trs),
    .din                (restore_out[19:10]),
    .active_streams_out (demux1_active_streams),
    .ds1                (demux1_ds1),
    .ds2                (demux1_ds2),
    .ds3                (demux1_ds3),
    .ds4                (demux1_ds4),
    .ce_out             (demux1_ce),
    .trs_out            (demux1_trs),
    .eav_out            (demux1_eav),
    .sav_out            (demux1_sav));

v_smpte_uhdsdi_rx_v1_0_0_demux_4 #(
    .TRS_OUTPUTS    (0),
    .RXDATA_WIDTH   (MAX_RXDATA_WIDTH))
    DMUX2 (
    .clk                (clk),
    .rst                (rst),
    .ce_in              (int_ce),
    .sd_data_strobe     (sd_data_strobe),
    .mode               (mode),
    .trs_in             (restore_trs),
    .din                (restore_out[9:0]),
    .active_streams_out (),
    .ds1                (demux2_ds1),
    .ds2                (demux2_ds2),
    .ds3                (demux2_ds3),
    .ds4                (demux2_ds4),
    .ce_out             (),
    .trs_out            (),
    .eav_out            (),
    .sav_out            ());
    end
    else
    begin
    v_smpte_uhdsdi_rx_v1_0_0_demux_4 #(
    .TRS_OUTPUTS    (1),
    .RXDATA_WIDTH   (MAX_RXDATA_WIDTH))
    DMUX1 (
        .clk                (clk),
        .rst                (rst),
        .ce_in              (int_ce),
        .sd_data_strobe     (sd_data_strobe),
        .mode               (mode),
        .trs_in             (restore_trs),
        .din                (restore_out[19:10]),
        .active_streams_out (demux1_active_streams),
        .ds1                (demux1_ds1),
        .ds2                (demux1_ds2),
        .ds3                (),
        .ds4                (),
        .ce_out             (demux1_ce),
        .trs_out            (demux1_trs),
        .eav_out            (demux1_eav),
        .sav_out            (demux1_sav));



    always @ (posedge clk)
    begin
        if (int_ce) 
        begin
            din_reg <= restore_out[9:0];
        end
    end
    
    always @ (posedge clk)
    begin
        if (int_ce)
        begin
            pipe0 <= din_reg;
            pipe1 <= pipe0;
        end
    end

    always @ (posedge clk)
    begin
        if (demux1_ce)
        begin
            demux2_ds2_reg <= pipe0;
            demux2_ds1_reg <= pipe1;
        end 
    end
    
    assign demux2_ds2   = demux2_ds2_reg;
    assign demux2_ds1   = demux2_ds1_reg;
    //v_smpte_uhdsdi_rx_v1_0_0_demux_4 #(
    //.TRS_OUTPUTS    (0),
    //.RXDATA_WIDTH   (MAX_RXDATA_WIDTH))
    //DMUX2 (
    //    .clk                (clk),
    //    .rst                (rst),
    //    .ce_in              (int_ce),
    //    .sd_data_strobe     (sd_data_strobe),
    //    .mode               (mode),
    //    .trs_in             (restore_trs),
    //    .din                (restore_out[9:0]),
    //    .active_streams_out (),
    //    .ds1                (demux2_ds1),
    //    .ds2                (demux2_ds2),
    //    .ds3                (),
    //    .ds4                (),
    //    .ce_out             (),
    //    .trs_out            (),
    //    .eav_out            (),
    //    .sav_out            ());
    end
endgenerate


generate
    if (MAX_RXDATA_WIDTH == 40)
    begin : WIDTH40
        v_smpte_uhdsdi_rx_v1_0_0_demux_4 #(
        .TRS_OUTPUTS    (0),
        .RXDATA_WIDTH(MAX_RXDATA_WIDTH))
        DMUX3 (
            .clk                (clk),
            .rst                (rst),
            .ce_in              (int_ce),
            .sd_data_strobe     (sd_data_strobe),
            .mode               (mode),
            .trs_in             (restore_trs),
            .din                (restore_out[39:30]),
            .active_streams_out (),
            .ds1                (demux3_ds1),
            .ds2                (demux3_ds2),
            .ds3                (demux3_ds3),
            .ds4                (demux3_ds4),
            .ce_out             (),
            .trs_out            (),
            .eav_out            (),
            .sav_out            ());

        v_smpte_uhdsdi_rx_v1_0_0_demux_4 #(
        .TRS_OUTPUTS    (0),
        .RXDATA_WIDTH(MAX_RXDATA_WIDTH))
        DMUX4 (
            .clk                (clk),
            .rst                (rst),
            .ce_in              (int_ce),
            .sd_data_strobe     (sd_data_strobe),
            .mode               (mode),
            .trs_in             (restore_trs),
            .din                (restore_out[29:20]),
            .active_streams_out (),
            .ds1                (demux4_ds1),
            .ds2                (demux4_ds2),
            .ds3                (demux4_ds3),
            .ds4                (demux4_ds4),
            .ce_out             (),
            .trs_out            (),
            .eav_out            (),
            .sav_out            ());
    end
    else 
    begin : WIDTH20
        assign demux3_ds1 = 10'b0;
        assign demux3_ds2 = 10'b0;
        assign demux3_ds3 = 10'b0;
        assign demux3_ds4 = 10'b0;
        assign demux4_ds1 = 10'b0;
        assign demux4_ds2 = 10'b0;
        assign demux4_ds3 = 10'b0;
        assign demux4_ds4 = 10'b0;
    end
endgenerate

//
// In SD, HD, and 3GA modes, the TRS, EAV, and SAV signals from the demux have
// to be delayed by one clock cycle to get them properly aligned with the data
// streams.
//
always @ (posedge clk)
    if (int_ce)
    begin
        trs_dly <= demux1_trs;
        eav_dly <= demux1_eav;
        sav_dly <= demux1_sav;
    end

assign ce_out  = demux1_ce;

//
// Depending on the SDI mode, the output data streams are assigned to the various
// streams from the demux modules.
//
generate
    if(MAX_RXDATA_WIDTH == 40)
    begin
    always @ (posedge clk)
        if (int_ce)
        begin
            if (mode == 3'b001)
            begin                                                           // SD-SDI mode
                ds1 <= demux1_ds1;
                ds2 <= 10'b0;
                ds3 <= 10'b0;
                ds4 <= 10'b0;
                ds5 <= 10'b0;
                ds6 <= 10'b0;
                ds7 <= 10'b0;
                ds8 <= 10'b0;
                ds9 <= 10'b0;
                ds10 <= 10'b0;
                ds11 <= 10'b0;
                ds12 <= 10'b0;
                ds13 <= 10'b0;
                ds14 <= 10'b0;
                ds15 <= 10'b0;
                ds16 <= 10'b0;
                trs  <= trs_dly;
                eav  <= eav_dly;
                sav  <= sav_dly;
                level_b <= 1'b0;
                active_streams <= 3'b000;
            end
            else if (mode == 3'b000)                                        // HD-SDI mode
            begin
                ds1 <= demux1_ds1;
                ds2 <= demux2_ds1;
                ds3 <= 10'b0;
                ds4 <= 10'b0;
                ds5 <= 10'b0;
                ds6 <= 10'b0;
                ds7 <= 10'b0;
                ds8 <= 10'b0;
                ds9 <= 10'b0;
                ds10 <= 10'b0;
                ds11 <= 10'b0;
                ds12 <= 10'b0;
                ds13 <= 10'b0;
                ds14 <= 10'b0;
                ds15 <= 10'b0;
                ds16 <= 10'b0;
                trs  <= trs_dly;
                eav  <= eav_dly;
                sav  <= sav_dly;
                level_b <= 1'b0;
                active_streams <= 3'b001;
            end
            else if (mode == 3'b010 && demux1_active_streams == 4'b0001)    // 3G-SDI level A
            begin
                ds1 <= demux1_ds1;
                ds2 <= demux2_ds1;
                ds3 <= 10'b0;
                ds4 <= 10'b0;
                ds5 <= 10'b0;
                ds6 <= 10'b0;
                ds7 <= 10'b0;
                ds8 <= 10'b0;
                ds9 <= 10'b0;
                ds10 <= 10'b0;
                ds11 <= 10'b0;
                ds12 <= 10'b0;
                ds13 <= 10'b0;
                ds14 <= 10'b0;
                ds15 <= 10'b0;
                ds16 <= 10'b0;
                trs  <= trs_dly;
                eav  <= eav_dly;
                sav  <= sav_dly;
                level_b <= 1'b0;
                active_streams <= 3'b001;
            end
            else if (mode == 3'b010 && demux1_active_streams == 4'b0011)    // 3G-SDI level B
            begin
                ds1 <= demux1_ds2;
                ds2 <= demux1_ds1;
                ds3 <= demux2_ds2;
                ds4 <= demux2_ds1;
                ds5 <= 10'b0;
                ds6 <= 10'b0;
                ds7 <= 10'b0;
                ds8 <= 10'b0;
                ds9 <= 10'b0;
                ds10 <= 10'b0;
                ds11 <= 10'b0;
                ds12 <= 10'b0;
                ds13 <= 10'b0;
                ds14 <= 10'b0;
                ds15 <= 10'b0;
                ds16 <= 10'b0;
                trs  <= demux1_trs;
                eav  <= demux1_eav;
                sav  <= demux1_sav;
                level_b <= 1'b1;
                active_streams <= 3'b010;
            end
            else if (mode == 3'b100 && demux1_active_streams == 4'b0001)    // SL 6G-SDI mode 2 & 3 or DL 6G-SDI mode 1 & 2
            begin
                ds1 <= demux3_ds1;
                ds2 <= demux1_ds1;
                ds3 <= demux4_ds1;
                ds4 <= demux2_ds1;
                ds5 <= 10'b0;
                ds6 <= 10'b0;
                ds7 <= 10'b0;
                ds8 <= 10'b0;
                ds9 <= 10'b0;
                ds10 <= 10'b0;
                ds11 <= 10'b0;
                ds12 <= 10'b0;
                ds13 <= 10'b0;
                ds14 <= 10'b0;
                ds15 <= 10'b0;
                ds16 <= 10'b0;
                trs  <= trs_dly;
                eav  <= eav_dly;
                sav  <= sav_dly;
                level_b <= 1'b0;
                active_streams <= 3'b010;
            end
            else if (demux1_active_streams == 4'b0011)
            begin
                ds1 <= demux3_ds2;
                ds2 <= demux3_ds1;
                ds3 <= demux1_ds2;
                ds4 <= demux1_ds1;
                ds5 <= demux4_ds2;
                ds6 <= demux4_ds1;
                ds7 <= demux2_ds2;
                ds8 <= demux2_ds1;
                ds9 <= 10'b0;
                ds10 <= 10'b0;
                ds11 <= 10'b0;
                ds12 <= 10'b0;
                ds13 <= 10'b0;
                ds14 <= 10'b0;
                ds15 <= 10'b0;
                ds16 <= 10'b0;
                trs  <= demux1_trs;
                eav  <= demux1_eav;
                sav  <= demux1_sav;
                level_b <= 1'b0;
                active_streams <= 3'b011;
            end
            else
            begin
                ds1 <= demux3_ds2;
                ds2 <= demux3_ds4;
                ds3 <= demux3_ds1;
                ds4 <= demux3_ds3;
                ds5 <= demux1_ds2;
                ds6 <= demux1_ds4;
                ds7 <= demux1_ds1;
                ds8 <= demux1_ds3;
                ds9 <= demux4_ds2;
                ds10 <= demux4_ds4;
                ds11 <= demux4_ds1;
                ds12 <= demux4_ds3;
                ds13 <= demux2_ds2;
                ds14 <= demux2_ds4;
                ds15 <= demux2_ds1;
                ds16 <= demux2_ds3;
                trs  <= demux1_trs;
                eav  <= demux1_eav;
                sav  <= demux1_sav;
                level_b <= 1'b0;
                active_streams <= 3'b100;
            end
        end
     end
    else
    begin

    assign levelb_3g  = (mode == 3'b010 && demux1_active_streams == 4'b0011);
    always @ (posedge clk)
        if (int_ce)
        begin
            ds1 <=  (levelb_3g) ? demux1_ds2 : demux1_ds1;
            ds2 <=  (levelb_3g) ? demux1_ds1 : demux2_ds1; 
            ds3 <=  (levelb_3g) ? demux2_ds2 : 10'd0; 
            ds4 <=  (levelb_3g) ? demux2_ds1 : 10'd0; 
            ds5 <= 10'b0;
            ds6 <= 10'b0;
            ds7 <= 10'b0;
            ds8 <= 10'b0;
            ds9 <= 10'b0;
            ds10 <= 10'b0;
            ds11 <= 10'b0;
            ds12 <= 10'b0;
            ds13 <= 10'b0;
            ds14 <= 10'b0;
            ds15 <= 10'b0;
            ds16 <= 10'b0;
            trs  <= (levelb_3g) ? demux1_trs : trs_dly;
            eav  <= (levelb_3g) ? demux1_eav : eav_dly;
            sav  <= (levelb_3g) ? demux1_sav : sav_dly;
            level_b <= levelb_3g;
            active_streams <= levelb_3g ? 3'b010 : ((mode == 3'b001) ? 3'b000 : 3'b001);
        end
     end
endgenerate
endmodule

    
