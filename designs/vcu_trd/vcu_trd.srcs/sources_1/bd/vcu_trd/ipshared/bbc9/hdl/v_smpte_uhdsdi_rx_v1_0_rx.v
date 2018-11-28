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

This is the top level of the UHD-SDI RX supporting all rates from SD to 12G.
*/

`timescale 1ns / 1ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_rx_v1_0_0_rx #(
    parameter INCLUDE_RX_EDH_PROCESSOR = 1,
    parameter NUM_CE                = 1,                // number of clock enable outputs
    parameter ERRCNT_WIDTH          = 4,                // width of counter tracking lines with errors
    parameter MAX_ERRS_LOCKED       = 15,               // max number of consecutive lines with errors
    parameter MAX_ERRS_UNLOCKED     = 2,                // max number of lines with errors during search
    parameter RXDATA_WIDTH          = 40,               // width of rxdata port, must be 40 if 6G/12G are used, otherwise 20
    parameter EDH_ERR_WIDTH         = 16)               // width of EDH error counter
(
    // inputs
    input  wire                     clk,                // rxusrclk input
    input  wire                     rst,                // sync reset input
    input  wire                     mode_detect_rst,    // sync reset for SDI mode detection function
    input  wire [RXDATA_WIDTH-1:0]  data_in,            // raw data from GTX RXDATA port, in SD mode, the 10 LSBs must be driven by the DRU output
    input  wire                     sd_data_strobe,     // asserted high when SD data is available on data_in
    input  wire                     frame_en,           // 1 = enable framer position update
    input  wire                     bit_rate,           // 1 = 1000/1001 bit rate, 0 = 1000/1000 bit rate
    input  wire [5:0]               mode_enable,        // unary enable bits for SDI mode search {12G/1.001,12G/1, 6G, 3G, SD, HD} 1=enable, 0=disable
    input  wire                     mode_detect_en,     // 1 enables SDI mode detection
    input  wire [2:0]               forced_mode,        // if mode_detect_en=0, this port specifies the SDI mode of the RX
    input  wire                     rx_ready,           // when 0, prevents the SDI mode search from running

    // outputs
    output wire [2:0]               mode,               // 000=HD, 001=SD, 010=3G, 100=6G, 101=12G/1, 110=12G/1.001
    output reg                      mode_HD = 1'b0,     // 1 = HD mode      
    output reg                      mode_SD = 1'b0,     // 1 = SD mode
    output reg                      mode_3G = 1'b0,     // 1 = 3G mode
    output reg                      mode_6G = 1'b0,     // 1 = 6G mode
    output reg                      mode_12G = 1'b0,    // 1 = 12G mode
    output wire                     mode_locked,        // auto mode detection locked
    output wire                     t_locked,           // transport format detection locked
    output wire [3:0]               t_family,           // transport format family
    output wire [3:0]               t_rate,             // transport frame rate
    output wire                     t_scan,             // transport scan: 0=interlaced, 1=progressive
    output reg                      level_b_3G = 1'b0,  // 0 = level A, 1 = level B
    output wire [NUM_CE-1:0]        ce_out,             // clock enable
    output wire                     nsp,                // framer new start position
    output wire [2:0]               active_streams,     // 2^active_streams = number of active streams
    output wire [10:0]              ln_ds1,             // line number for ds1
    output wire [10:0]              ln_ds2,             // line number for ds2
    output wire [10:0]              ln_ds3,             // line number for ds3
    output wire [10:0]              ln_ds4,             // line number for ds4
    output wire [10:0]              ln_ds5,             // line number for ds5
    output wire [10:0]              ln_ds6,             // line number for ds6
    output wire [10:0]              ln_ds7,             // line number for ds7
    output wire [10:0]              ln_ds8,             // line number for ds8
    output wire [10:0]              ln_ds9,             // line number for ds9
    output wire [10:0]              ln_ds10,            // line number for ds10
    output wire [10:0]              ln_ds11,            // line number for ds11
    output wire [10:0]              ln_ds12,            // line number for ds12
    output wire [10:0]              ln_ds13,            // line number for ds13
    output wire [10:0]              ln_ds14,            // line number for ds14
    output wire [10:0]              ln_ds15,            // line number for ds15
    output wire [10:0]              ln_ds16,            // line number for ds16
    output wire [31:0]              vpid_0,             // video payload ID packet channel 0 (for 3G-SDI level A, Y VPID)
    output wire                     vpid_0_valid,       // 1 = vpid_0 is valid
    output wire [31:0]              vpid_1,             // video payload ID packet channel 1 (for 3G-SDI level A, C VPID) 
    output wire                     vpid_1_valid,       // 1 = vpid_1 is valid
    output wire [31:0]              vpid_2,             // video payload ID packet channel 2
    output wire                     vpid_2_valid,       // 1 = vpid_2 is valid
    output wire [31:0]              vpid_3,             // video payload ID packet channel 3
    output wire                     vpid_3_valid,       // 1 = vpid_3 is valid
    output wire [31:0]              vpid_4,             // video payload ID packet channel 4
    output wire                     vpid_4_valid,       // 1 = vpid_4 is valid
    output wire [31:0]              vpid_5,             // video payload ID packet channel 5
    output wire                     vpid_5_valid,       // 1 = vpid_5 is valid
    output wire [31:0]              vpid_6,             // video payload ID packet channel 6
    output wire                     vpid_6_valid,       // 1 = vpid_6 is valid
    output wire [31:0]              vpid_7,             // video payload ID packet channel 7
    output wire                     vpid_7_valid,       // 1 = vpid_7 is valid
    output reg                      crc_err_ds1 = 1'b0, // CRC error for ds1
    output reg                      crc_err_ds2 = 1'b0, // CRC error for ds2
    output reg                      crc_err_ds3 = 1'b0, // CRC error for ds3
    output reg                      crc_err_ds4 = 1'b0, // CRC error for ds4
    output reg                      crc_err_ds5 = 1'b0, // CRC error for ds5
    output reg                      crc_err_ds6 = 1'b0, // CRC error for ds6
    output reg                      crc_err_ds7 = 1'b0, // CRC error for ds7
    output reg                      crc_err_ds8 = 1'b0, // CRC error for ds8
    output reg                      crc_err_ds9 = 1'b0, // CRC error for ds9
    output reg                      crc_err_ds10 = 1'b0,// CRC error for ds10
    output reg                      crc_err_ds11 = 1'b0,// CRC error for ds11
    output reg                      crc_err_ds12 = 1'b0,// CRC error for ds12
    output reg                      crc_err_ds13 = 1'b0,// CRC error for ds13
    output reg                      crc_err_ds14 = 1'b0,// CRC error for ds14
    output reg                      crc_err_ds15 = 1'b0,// CRC error for ds15
    output reg                      crc_err_ds16 = 1'b0,// CRC error for ds16
    output wire [9:0]               ds1,                // SD=Y/C, HD=Y, 3GA=ds1, 3GB=Y link A, 6G/12G=ds1
    output wire [9:0]               ds2,                // HD=C, 3GA=ds2, 3GB=C link A, 6G/12G=ds2
    output wire [9:0]               ds3,                // 3GB=Y link B, 6G/12G=ds3
    output wire [9:0]               ds4,                // 3GB=C link B, 6G/12G=ds4
    output wire [9:0]               ds5,                // 6G/12G=ds5
    output wire [9:0]               ds6,                // 6G/12G=ds6
    output wire [9:0]               ds7,                // 6G/12G=ds7
    output wire [9:0]               ds8,                // 6G/12G=ds8
    output wire [9:0]               ds9,                // 12G=ds9
    output wire [9:0]               ds10,               // 12G=ds10
    output wire [9:0]               ds11,               // 12G=ds11
    output wire [9:0]               ds12,               // 12G=ds12
    output wire [9:0]               ds13,               // 12G=ds13
    output wire [9:0]               ds14,               // 12G=ds14
    output wire [9:0]               ds15,               // 12G=ds15
    output wire [9:0]               ds16,               // 12G=ds16
    output wire                     eav,                // EAV
    output wire                     sav,                // SAV
    output wire                     trs,                // TRS
    input  wire [15:0]              edh_errcnt_en,      // enables various error to increment rx_edh_errcnt
    input  wire                     edh_clr_errcnt,     // clears rx_edh_errcnt
    output wire                     edh_ap,             // 1 = AP CRC error detected previous field
    output wire                     edh_ff,             // 1 = FF CRC error detected previous field
    output wire                     edh_anc,            // 1 = ANC checksum error detected
    output wire [4:0]               edh_ap_flags,       // EDH AP flags received in last EDH packet
    output wire [4:0]               edh_ff_flags,       // EDH FF flags received in last EDH packet
    output wire [4:0]               edh_anc_flags,      // EDH ANC flags received in last EDH packet
    output wire [3:0]               edh_packet_flags,   // EDH packet error condition flags
    output wire [15:0]              edh_errcnt          // EDH error counter

);

//
// Internal signal declarations
//

// Clock enables
localparam NUM_INT_CE = 2;                  // Number of internal clock enables used

(* equivalent_register_removal = "no" *)
(* KEEP = "TRUE" *)
reg [NUM_INT_CE-1:0]    ce_int = 0;         // internal SD clock enable FFs

(* equivalent_register_removal = "no" *)
(* KEEP = "TRUE" *)
reg [NUM_CE-1:0]        ce_ff = 0;          // external SD clock enable FFs

(* equivalent_register_removal = "no" *)
(* KEEP = "TRUE" *)
reg                     ce_edh = 0;         // EDH clock enable FF

reg  [RXDATA_WIDTH-1:0] rxdata = 0;
reg  [9:0]              sd_rxdata = 0;
wire [2:0]              mode_int;
wire [2:0]              mode_x;
wire                    mode_locked_int;
wire                    mode_locked_x;
reg                     mode_HD_int;
reg                     mode_SD_int;
reg                     mode_3G_int;
reg                     mode_6G_int;
reg                     mode_12G_int;
wire [19:0]             descrambler_in_ls;
wire [RXDATA_WIDTH-1:0] descrambler_in;
wire [9:0]              framer_ds1;
wire [9:0]              framer_ds2;
wire [9:0]              framer_ds3;
wire [9:0]              framer_ds4;
wire [9:0]              framer_ds5;
wire [9:0]              framer_ds6;
wire [9:0]              framer_ds7;
wire [9:0]              framer_ds8;
wire [9:0]              framer_ds9;
wire [9:0]              framer_ds10;
wire [9:0]              framer_ds11;
wire [9:0]              framer_ds12;
wire [9:0]              framer_ds13;
wire [9:0]              framer_ds14;
wire [9:0]              framer_ds15;
wire [9:0]              framer_ds16;
wire                    framer_eav;
wire                    framer_sav;
wire                    framer_trs;
wire                    framer_trs_err;
reg                     eav_int = 1'b0;
reg                     sav_int = 1'b0;
reg                     trs_int = 1'b0;
wire                    ds1_crc_err;
wire                    ds2_crc_err;
wire                    ds3_crc_err;
wire                    ds4_crc_err;
wire                    ds5_crc_err;
wire                    ds6_crc_err;
wire                    ds7_crc_err;
wire                    ds8_crc_err;
wire                    ds9_crc_err;
wire                    ds10_crc_err;
wire                    ds11_crc_err;
wire                    ds12_crc_err;
wire                    ds13_crc_err;
wire                    ds14_crc_err;
wire                    ds15_crc_err;
wire                    ds16_crc_err;
wire [10:0]             ln_ds1_int;
wire [10:0]             ln_ds2_int;
wire [10:0]             ln_ds3_int;
wire [10:0]             ln_ds4_int;
wire [10:0]             ln_ds5_int;
wire [10:0]             ln_ds6_int;
wire [10:0]             ln_ds7_int;
wire [10:0]             ln_ds8_int;
wire [10:0]             ln_ds9_int;
wire [10:0]             ln_ds10_int;
wire [10:0]             ln_ds11_int;
wire [10:0]             ln_ds12_int;
wire [10:0]             ln_ds13_int;
wire [10:0]             ln_ds14_int;
wire [10:0]             ln_ds15_int;
wire [10:0]             ln_ds16_int;
wire                    framer_ce;
wire [5:0]              mode_enable_int;
wire [9:0]              vpid_1_mux;
wire                    mode_3ga;
wire                    level_b;
wire                    sd_strobe = sd_data_strobe;
wire                    autorate_ce;
wire                    autorate_sav;
wire                    bit_rate_int;
wire [2:0]              active_streams_int;
reg                     trs_err = 1'b0;
wire [15:0]             crc_err_vector;
wire                    framer_nsp;

assign active_streams = active_streams_int;

//------------------------------------------------------------------------------
// Clock enable generation
//

//
// Generate multiple copies of the clock enable signal. In SD-SDI mode, the CE
// comes from the DRU data strobe (the sd_data_strobe) input. In all other modes,
// the ce comes from the framer.
//
always @ (posedge clk)
    if (mode_int == 3'b001)
        ce_int <= {NUM_INT_CE {sd_data_strobe}};
    else
        ce_int <= {NUM_INT_CE {framer_ce}};

always @ (posedge clk)
    if (mode_int == 3'b001)
        ce_ff <= {NUM_CE {sd_data_strobe}};
    else
        ce_ff <= {NUM_CE {framer_ce}};
        
assign ce_out = ce_ff;

generate
    if (INCLUDE_RX_EDH_PROCESSOR == 1)
    begin : INCLUDE_EDH_CE
        
        always @ (posedge clk)
            if (mode_int == 3'b001)
                ce_edh <= sd_data_strobe;
            else
                ce_edh <= 1'b0;
    end
    else
    begin : NO_EDH_CE
        always @ (posedge clk)
            ce_edh <= 1'b0;
    end
endgenerate

//------------------------------------------------------------------------------
// Data input registers
//
always @ (posedge clk)
    rxdata <= data_in;

always @ (posedge clk)
    if (sd_data_strobe)
        sd_rxdata <= data_in[9:0];

//------------------------------------------------------------------------------
// SDI descrambler, framer, and data stream mux.
//
assign descrambler_in_ls = (mode_int == 3'b001) ? {sd_rxdata, 10'b0} : rxdata[19:0];

generate
    if (RXDATA_WIDTH == 20) begin: rx20b
        assign mode_enable_int = {3'b000, mode_enable[2:0]};
        assign descrambler_in = descrambler_in_ls;
    end else begin: rx40b
        assign mode_enable_int = mode_enable;
        assign descrambler_in = {rxdata[39:20], descrambler_in_ls};
    end
endgenerate

generate 
if(RXDATA_WIDTH == 40)
begin

v_smpte_uhdsdi_rx_v1_0_0_to_demux #(
    .MAX_RXDATA_WIDTH   (RXDATA_WIDTH))
RXDPCOMMON (
    .clk            (clk),
    .sd_data_strobe (sd_data_strobe),
    .rst            (rst | ~rx_ready),
    .rxdata         (descrambler_in),
    .mode           (mode_int),
    .frame_en       (frame_en),
    .nsp            (framer_nsp),
    .ce_out         (framer_ce),
    .trs            (framer_trs),
    .eav            (framer_eav),
    .sav            (framer_sav),
    .level_b        (level_b),
    .raw_sav        (autorate_sav),
    .muxed_ds_ce    (autorate_ce),
    .active_streams (active_streams_int),
    .ds1            (framer_ds1),
    .ds2            (framer_ds2),
    .ds3            (framer_ds3),
    .ds4            (framer_ds4),
    .ds5            (framer_ds5),
    .ds6            (framer_ds6),
    .ds7            (framer_ds7),
    .ds8            (framer_ds8),
    .ds9            (framer_ds9),
    .ds10           (framer_ds10),
    .ds11           (framer_ds11),
    .ds12           (framer_ds12),
    .ds13           (framer_ds13),
    .ds14           (framer_ds14),
    .ds15           (framer_ds15),
    .ds16           (framer_ds16));
end
else
begin
    v_smpte_uhdsdi_rx_v1_0_0_to_demux #(
        .MAX_RXDATA_WIDTH   (RXDATA_WIDTH))
    RXDPCOMMON (
        .clk            (clk),
        .sd_data_strobe (sd_data_strobe),
        .rst            (rst | ~rx_ready),
        .rxdata         (descrambler_in),
        .mode           (mode_int),
        .frame_en       (frame_en),
        .nsp            (framer_nsp),
        .ce_out         (framer_ce),
        .trs            (framer_trs),
        .eav            (framer_eav),
        .sav            (framer_sav),
        .level_b        (level_b),
        .raw_sav        (autorate_sav),
        .muxed_ds_ce    (autorate_ce),
        .active_streams (active_streams_int),
        .ds1            (framer_ds1),
        .ds2            (framer_ds2),
        .ds3            (framer_ds3),
        .ds4            (framer_ds4),
        .ds5            (),
        .ds6            (),
        .ds7            (),
        .ds8            (),
        .ds9            (),
        .ds10           (),
        .ds11           (),
        .ds12           (),
        .ds13           (),
        .ds14           (),
        .ds15           (),
        .ds16           ());
end
endgenerate
assign framer_trs_err = framer_sav & (
                        (framer_ds1[5] ^ framer_ds1[6] ^ framer_ds1[7]) |
                        (framer_ds1[4] ^ framer_ds1[8] ^ framer_ds1[6]) |
                        (framer_ds1[3] ^ framer_ds1[8] ^ framer_ds1[7]) |
                        (framer_ds1[2] ^ framer_ds1[8] ^ framer_ds1[7] ^ framer_ds1[6]) |
                        ~framer_ds1[9] | framer_ds1[1] | framer_ds1[0]);
 
assign nsp = framer_nsp;

//------------------------------------------------------------------------------
// SDI mode detection
//

//
// Validate every SAV for the autorate module. If the CRC error signal of
// all active data streams is asserted, then the SAV isn't valid.
//
assign crc_err_vector = {ds16_crc_err, ds15_crc_err, ds14_crc_err, ds13_crc_err, ds12_crc_err, ds11_crc_err, ds10_crc_err, ds9_crc_err,
                         ds8_crc_err, ds7_crc_err, ds6_crc_err, ds5_crc_err, ds4_crc_err, ds3_crc_err, ds2_crc_err, ds1_crc_err};

always @ (posedge clk)
    case(active_streams_int)
        3'b000:     trs_err <= 1'b0;                    // CRC errors aren't valid in SD-SDI mode, so trs_err is always Low
        3'b001:     trs_err <= &crc_err_vector[1:0];    // 2 active streams
        3'b010:     trs_err <= &crc_err_vector[3:0];    // 4 active streams
        3'b011:     trs_err <= &crc_err_vector[7:0];    // 8 active streams
        default:    trs_err <= &crc_err_vector[15:0];   // 16 active streams
    endcase

v_smpte_uhdsdi_rx_v1_0_0_autorate #(
    .ERRCNT_WIDTH       (ERRCNT_WIDTH),
    .MAX_ERRS_LOCKED    (MAX_ERRS_LOCKED),
    .MAX_ERRS_UNLOCKED  (MAX_ERRS_UNLOCKED))
AUTORATE (
    .clk                (clk),
    .ce                 (autorate_ce),
    .rst                (mode_detect_rst),
	.ds1                (framer_ds1),
	.eav                (framer_eav),
    .sav                (framer_sav),
    .trs_err            (trs_err | framer_trs_err),
    .rx_ready           (rx_ready),
    .mode_enable        (mode_enable_int),
    .mode               (mode_x),
    .locked             (mode_locked_x));

//
// Decode the RX mode into unary mode signals.
//
generate
if(RXDATA_WIDTH == 40)
begin
    always @ (*)
    begin
        mode_HD_int = 1'b0;
        mode_SD_int = 1'b0;
        mode_3G_int = 1'b0;
        mode_6G_int = 1'b0;
        mode_12G_int= 1'b0;
    
        case(mode_int)
            3'b001:   mode_SD_int = 1'b1;
            3'b010:   mode_3G_int = 1'b1;
            3'b100:   mode_6G_int = 1'b1;
            3'b101:   mode_12G_int = 1'b1;
            3'b110:   mode_12G_int = 1'b1;
            default:  mode_HD_int = 1'b1;
        endcase
    end
end
else
begin
    always @ (*)
    begin
        mode_HD_int = 1'b0;
        mode_SD_int = 1'b0;
        mode_3G_int = 1'b0;
        mode_6G_int = 1'b0;
        mode_12G_int= 1'b0;
    
        case(mode_int)
            3'b001:   mode_SD_int = 1'b1;
            3'b010:   mode_3G_int = 1'b1;
            default:  mode_HD_int = 1'b1;
        endcase
    end
end
endgenerate

//
// If the mode_detect_en input is 1, then use the mode detected by the 
// v_smpte_uhdsdi_rx_v1_0_0_autorate module and the associated mode_locked signal.
// Otherwise, use the forced_mode input and always assert mode_locked.
//
generate
    if(RXDATA_WIDTH == 40)
    begin
        assign mode_int = mode_detect_en ? mode_x : forced_mode;
    end
    else
    begin
        assign mode_int = mode_detect_en ? {1'd0,mode_x[1:0]} : {1'd0,forced_mode[1:0]};
    end
endgenerate

assign mode_locked_int = mode_detect_en ? mode_locked_x : 1'b1;

assign mode = mode_int;
assign mode_locked = mode_locked_int;

generate
if(RXDATA_WIDTH == 40)
begin
assign ds1 = framer_ds1;
assign ds2 = framer_ds2;
assign ds3 = framer_ds3;
assign ds4 = framer_ds4;
assign ds5 = framer_ds5;
assign ds6 = framer_ds6;
assign ds7 = framer_ds7;
assign ds8 = framer_ds8;
assign ds9 = framer_ds9;
assign ds10 = framer_ds10;
assign ds11 = framer_ds11;
assign ds12 = framer_ds12;
assign ds13 = framer_ds13;
assign ds14 = framer_ds14;
assign ds15 = framer_ds15;
assign ds16 = framer_ds16;
end
else
begin
assign ds1 = framer_ds1;
assign ds2 = framer_ds2;
assign ds3 = framer_ds3;
assign ds4 = framer_ds4;
assign ds5 = 10'd0;
assign ds6 = 10'd0;
assign ds7 = 10'd0;
assign ds8 = 10'd0;
assign ds9 = 10'd0;
assign ds10 = 10'd0;
assign ds11 = 10'd0;
assign ds12 = 10'd0;
assign ds13 = 10'd0;
assign ds14 = 10'd0;
assign ds15 = 10'd0;
assign ds16 = 10'd0;
end
endgenerate

assign eav  = framer_eav;
assign sav  = framer_sav;
assign trs  = framer_trs;

//------------------------------------------------------------------------------
// Transport timing detection module
//
//assign bit_rate_int = mode_12G_int ? ~mode_int[0] : bit_rate; 
assign bit_rate_int = bit_rate; 

v_smpte_uhdsdi_rx_v1_0_0_transport_detect TD (
    .clk                (clk),
    .rst                (rst),
    .ce                 (ce_int[0]),
    .vid_7              (framer_ds1[7]),
    .eav                (framer_eav),
    .sav                (framer_sav),
    .bit_rate           (bit_rate_int),
    .mode               (mode_int),
    .active_streams     (active_streams_int),
    .mode_locked        (mode_locked_int),
    .level_b            (level_b),
    .ln                 (ln_ds1_int),
    .transport_family   (t_family),
    .transport_rate     (t_rate),
    .transport_scan     (t_scan),
    .transport_locked   (t_locked));

//------------------------------------------------------------------------------
// CRC error detection and line number capture
//
v_smpte_uhdsdi_rx_v1_0_0_crc RXCRC1 (
    .clk        (clk),
    .rst        (rst),
    .ce         (ce_int[0]), 
    .c_video    (framer_ds2),
    .y_video    (framer_ds1),
    .trs        (framer_trs),
    .c_crc_err  (ds2_crc_err),
    .y_crc_err  (ds1_crc_err),
    .c_line_num (ln_ds2_int),
    .y_line_num (ln_ds1_int));

assign ln_ds1 = ln_ds1_int;
assign ln_ds2 = ln_ds2_int;

v_smpte_uhdsdi_rx_v1_0_0_crc RXCRC2 (
    .clk        (clk),
    .rst        (rst),
    .ce         (ce_int[0]), 
    .c_video    (framer_ds4),
    .y_video    (framer_ds3),
    .trs        (framer_trs),
    .c_crc_err  (ds4_crc_err),
    .y_crc_err  (ds3_crc_err),
    .c_line_num (ln_ds4_int),
    .y_line_num (ln_ds3_int));

assign ln_ds3 = ln_ds3_int;
assign ln_ds4 = ln_ds4_int;


generate 
    if(RXDATA_WIDTH == 40)
    begin
v_smpte_uhdsdi_rx_v1_0_0_crc RXCRC3 (
    .clk        (clk),
    .rst        (rst),
    .ce         (ce_int[0]), 
    .c_video    (framer_ds6),
    .y_video    (framer_ds5),
    .trs        (framer_trs),
    .c_crc_err  (ds6_crc_err),
    .y_crc_err  (ds5_crc_err),
    .c_line_num (ln_ds6_int),
    .y_line_num (ln_ds5_int));

assign ln_ds5 = ln_ds5_int;
assign ln_ds6 = ln_ds6_int;

v_smpte_uhdsdi_rx_v1_0_0_crc RXCRC4 (
    .clk        (clk),
    .rst        (rst),
    .ce         (ce_int[0]), 
    .c_video    (framer_ds8),
    .y_video    (framer_ds7),
    .trs        (framer_trs),
    .c_crc_err  (ds8_crc_err),
    .y_crc_err  (ds7_crc_err),
    .c_line_num (ln_ds8_int),
    .y_line_num (ln_ds7_int));

assign ln_ds7 = ln_ds7_int;
assign ln_ds8 = ln_ds8_int;

v_smpte_uhdsdi_rx_v1_0_0_crc RXCRC5 (
    .clk        (clk),
    .rst        (rst),
    .ce         (ce_int[1]), 
    .c_video    (framer_ds10),
    .y_video    (framer_ds9),
    .trs        (framer_trs),
    .c_crc_err  (ds10_crc_err),
    .y_crc_err  (ds9_crc_err),
    .c_line_num (ln_ds10_int),
    .y_line_num (ln_ds9_int));

assign ln_ds9 = ln_ds9_int;
assign ln_ds10 = ln_ds10_int;

v_smpte_uhdsdi_rx_v1_0_0_crc RXCRC6 (
    .clk        (clk),
    .rst        (rst),
    .ce         (ce_int[1]), 
    .c_video    (framer_ds12),
    .y_video    (framer_ds11),
    .trs        (framer_trs),
    .c_crc_err  (ds12_crc_err),
    .y_crc_err  (ds11_crc_err),
    .c_line_num (ln_ds12_int),
    .y_line_num (ln_ds11_int));

assign ln_ds11 = ln_ds11_int;
assign ln_ds12 = ln_ds12_int;

v_smpte_uhdsdi_rx_v1_0_0_crc RXCRC7 (
    .clk        (clk),
    .rst        (rst),
    .ce         (ce_int[1]), 
    .c_video    (framer_ds14),
    .y_video    (framer_ds13),
    .trs        (framer_trs),
    .c_crc_err  (ds14_crc_err),
    .y_crc_err  (ds13_crc_err),
    .c_line_num (ln_ds14_int),
    .y_line_num (ln_ds13_int));

assign ln_ds13 = ln_ds13_int;
assign ln_ds14 = ln_ds14_int;

v_smpte_uhdsdi_rx_v1_0_0_crc RXCRC8 (
    .clk        (clk),
    .rst        (rst),
    .ce         (ce_int[1]), 
    .c_video    (framer_ds16),
    .y_video    (framer_ds15),
    .trs        (framer_trs),
    .c_crc_err  (ds16_crc_err),
    .y_crc_err  (ds15_crc_err),
    .c_line_num (ln_ds16_int),
    .y_line_num (ln_ds15_int));

assign ln_ds15 = ln_ds15_int;
assign ln_ds16 = ln_ds16_int;

end
else
begin
assign ds5_crc_err  = 1'b0; 
assign ds6_crc_err  = 1'b0; 
assign ds7_crc_err  = 1'b0; 
assign ds8_crc_err  = 1'b0; 
assign ds9_crc_err  = 1'b0; 
assign ds10_crc_err = 1'b0; 
assign ds11_crc_err = 1'b0; 
assign ds12_crc_err = 1'b0; 
assign ds13_crc_err = 1'b0; 
assign ds14_crc_err = 1'b0; 
assign ds15_crc_err = 1'b0; 
assign ds16_crc_err = 1'b0; 

assign ln_ds5  = 11'd0;
assign ln_ds6  = 11'd0;
assign ln_ds7  = 11'd0;
assign ln_ds8  = 11'd0;
assign ln_ds9  = 11'd0;
assign ln_ds10 = 11'd0;
assign ln_ds11 = 11'd0;
assign ln_ds12 = 11'd0;
assign ln_ds13 = 11'd0;
assign ln_ds14 = 11'd0;
assign ln_ds15 = 11'd0;
assign ln_ds16 = 11'd0;
end
endgenerate

//------------------------------------------------------------------------------
// SMPTE 352 payload ID capture
//

//
// In 3G-SDI level A mode, a ST 352 packet is present in the C data stream (data
// stream 2). This is the only mode in which ST 352 packets are present in the C
// data stream. The following mux routes data stream 2 through the ST 352 packet
// data stream 3 capture module in 3G-SDI level A mode. Otherwise, ST 352 packets
// are only detected on the Y data stream of each data stream pair.
//
assign mode_3ga = (mode_int == 3'b010) && ~level_b;
assign vpid_1_mux = mode_3ga ? framer_ds2 : framer_ds3;

v_smpte_uhdsdi_rx_v1_0_0_st352_pid_capture PLOD0 (
    .clk            (clk),
    .ce             (ce_int[0]),
    .rst            (rst),
    .sav            (framer_sav),
    .vid_in         (framer_ds1),
    .payload        (vpid_0),
    .valid          (vpid_0_valid));

v_smpte_uhdsdi_rx_v1_0_0_st352_pid_capture PLOD1 (
    .clk            (clk),
    .ce             (ce_int[0]),
    .rst            (rst),
    .sav            (framer_sav),
    .vid_in         (vpid_1_mux),
    .payload        (vpid_1),
    .valid          (vpid_1_valid));


generate
    if(RXDATA_WIDTH == 40)
    begin

v_smpte_uhdsdi_rx_v1_0_0_st352_pid_capture PLOD2 (
    .clk            (clk),
    .ce             (ce_int[0]),
    .rst            (rst),
    .sav            (framer_sav),
    .vid_in         (framer_ds5),
    .payload        (vpid_2),
    .valid          (vpid_2_valid));

v_smpte_uhdsdi_rx_v1_0_0_st352_pid_capture PLOD3 (
    .clk            (clk),
    .ce             (ce_int[0]),
    .rst            (rst),
    .sav            (framer_sav),
    .vid_in         (framer_ds7),
    .payload        (vpid_3),
    .valid          (vpid_3_valid));

v_smpte_uhdsdi_rx_v1_0_0_st352_pid_capture PLOD4 (
    .clk            (clk),
    .ce             (ce_int[1]),
    .rst            (rst),
    .sav            (framer_sav),
    .vid_in         (framer_ds9),
    .payload        (vpid_4),
    .valid          (vpid_4_valid));

v_smpte_uhdsdi_rx_v1_0_0_st352_pid_capture PLOD5 (
    .clk            (clk),
    .ce             (ce_int[1]),
    .rst            (rst),
    .sav            (framer_sav),
    .vid_in         (framer_ds11),
    .payload        (vpid_5),
    .valid          (vpid_5_valid));

v_smpte_uhdsdi_rx_v1_0_0_st352_pid_capture PLOD6 (
    .clk            (clk),
    .ce             (ce_int[1]),
    .rst            (rst),
    .sav            (framer_sav),
    .vid_in         (framer_ds13),
    .payload        (vpid_6),
    .valid          (vpid_6_valid));

v_smpte_uhdsdi_rx_v1_0_0_st352_pid_capture PLOD7 (
    .clk            (clk),
    .ce             (ce_int[1]),
    .rst            (rst),
    .sav            (framer_sav),
    .vid_in         (framer_ds15),
    .payload        (vpid_7),
    .valid          (vpid_7_valid));

    end
else
begin
    assign vpid_2          =   32'd0;
    assign vpid_2_valid    =   1'b0;
    assign vpid_3          =   32'd0;
    assign vpid_3_valid    =   1'b0;
    assign vpid_4          =   32'd0;
    assign vpid_4_valid    =   1'b0;
    assign vpid_5          =   32'd0;
    assign vpid_5_valid    =   1'b0;
    assign vpid_6          =   32'd0;
    assign vpid_6_valid    =   1'b0;
    assign vpid_7          =   32'd0;
    assign vpid_7_valid    =   1'b0;

end
endgenerate
//------------------------------------------------------------------------------
// Output registers for the unary mode signals, the level_b_3G signal, and the
// CRC error signals.
//
generate
if (RXDATA_WIDTH == 40)
begin
always @ (posedge clk)
    if (ce_int[0])
    begin
        if (rst)
        begin
            mode_HD <= 1'b0;
            mode_SD <= 1'b0;
            mode_3G <= 1'b0;
            mode_6G <= 1'b0;
            mode_12G <= 1'b0;
            level_b_3G <= 1'b0;
            crc_err_ds1 <= 1'b0;
            crc_err_ds2 <= 1'b0;
            crc_err_ds3 <= 1'b0;
            crc_err_ds4 <= 1'b0;
            crc_err_ds5 <= 1'b0;
            crc_err_ds6 <= 1'b0;
            crc_err_ds7 <= 1'b0;
            crc_err_ds8 <= 1'b0;
            crc_err_ds9 <= 1'b0;
            crc_err_ds10 <= 1'b0;
            crc_err_ds11 <= 1'b0;
            crc_err_ds12 <= 1'b0;
            crc_err_ds13 <= 1'b0;
            crc_err_ds14 <= 1'b0;
            crc_err_ds15 <= 1'b0;
            crc_err_ds16 <= 1'b0;
        end
        else
        begin
            mode_HD <= mode_HD_int & mode_locked_int;
            mode_SD <= mode_SD_int & mode_locked_int;
            mode_3G <= mode_3G_int & mode_locked_int;
            mode_6G <= mode_6G_int & mode_locked_int;
            mode_12G <= mode_12G_int & mode_locked_int;
            level_b_3G <= mode_3G_int & level_b;
            crc_err_ds1 <= ds1_crc_err;
            crc_err_ds2 <= ds2_crc_err;
            crc_err_ds3 <= ds3_crc_err;
            crc_err_ds4 <= ds4_crc_err;
            crc_err_ds5 <= ds5_crc_err;
            crc_err_ds6 <= ds6_crc_err;
            crc_err_ds7 <= ds7_crc_err;
            crc_err_ds8 <= ds8_crc_err;
            crc_err_ds9 <= ds9_crc_err;
            crc_err_ds10 <= ds10_crc_err;
            crc_err_ds11 <= ds11_crc_err;
            crc_err_ds12 <= ds12_crc_err;
            crc_err_ds13 <= ds13_crc_err;
            crc_err_ds14 <= ds14_crc_err;
            crc_err_ds15 <= ds15_crc_err;
            crc_err_ds16 <= ds16_crc_err;
        end
    end
end

else
begin
always @ (posedge clk)
begin
    mode_6G <= 1'b0;
    mode_12G <= 1'b0;
    crc_err_ds5 <= 1'b0;
    crc_err_ds6 <= 1'b0;
    crc_err_ds7 <= 1'b0;
    crc_err_ds8 <= 1'b0;
    crc_err_ds9 <= 1'b0;
    crc_err_ds10 <= 1'b0;
    crc_err_ds11 <= 1'b0;
    crc_err_ds12 <= 1'b0;
    crc_err_ds13 <= 1'b0;
    crc_err_ds14 <= 1'b0;
    crc_err_ds15 <= 1'b0;
    crc_err_ds16 <= 1'b0;
    if (ce_int[0])
    begin
        if (rst)
        begin
            mode_HD <= 1'b0;
            mode_SD <= 1'b0;
            mode_3G <= 1'b0;
            level_b_3G <= 1'b0;
            crc_err_ds1 <= 1'b0;
            crc_err_ds2 <= 1'b0;
            crc_err_ds3 <= 1'b0;
            crc_err_ds4 <= 1'b0;
        end
        else
        begin
            mode_HD <= mode_HD_int & mode_locked_int;
            mode_SD <= mode_SD_int & mode_locked_int;
            mode_3G <= mode_3G_int & mode_locked_int;
            level_b_3G <= mode_3G_int & level_b;
            crc_err_ds1 <= ds1_crc_err;
            crc_err_ds2 <= ds2_crc_err;
            crc_err_ds3 <= ds3_crc_err;
            crc_err_ds4 <= ds4_crc_err;
        end
    end
end
end
endgenerate
//------------------------------------------------------------------------------
// SD-SDI EDH Processor
//
generate
    if (INCLUDE_RX_EDH_PROCESSOR == 1)
    begin : INCLUDE_EDH

        wire [4:0]              ap_flags;
        wire [4:0]              ff_flags;
        wire [4:0]              anc_flags;

        v_smpte_uhdsdi_rx_v1_0_0_edh_processor #(
            .ERROR_COUNT_WIDTH  (EDH_ERR_WIDTH))
        EDH (
            .clk                (clk),
            .ce                 (ce_edh),
            .rst                (rst),
            .vid_in             (framer_ds1),
            .reacquire          (1'b0),
            .en_sync_switch     (1'b1),
            .en_trs_blank       (1'b0),
            .anc_idh_local      (1'b0),
            .anc_ues_local      (1'b0),
            .ap_idh_local       (1'b0),
            .ff_idh_local       (1'b0),
            .errcnt_flg_en      (edh_errcnt_en),
            .clr_errcnt         (edh_clr_errcnt),
            .receive_mode       (1'b1),                   
            .vid_out            (),
            .std                (),
            .std_locked         (),
            .trs                (),
            .field              (),
            .v_blank            (),
            .h_blank            (),
            .horz_count         (),
            .vert_count         (),
            .sync_switch        (),
            .locked             (),
            .eav_next           (),
            .sav_next           (),
            .xyz_word           (),
            .anc_next           (),
            .edh_next           (),
            .rx_ap_flags        (edh_ap_flags),
            .rx_ff_flags        (edh_ff_flags),
            .rx_anc_flags       (edh_anc_flags),
            .ap_flags           (ap_flags),
            .ff_flags           (ff_flags),
            .anc_flags          (anc_flags),
            .packet_flags       (edh_packet_flags),
            .errcnt             (edh_errcnt),
            .edh_packet         ());

        assign edh_ap = ap_flags[0];
        assign edh_ff = ff_flags[0];
        assign edh_anc = anc_flags[0];
    end
    else
    begin : NO_EDH
        assign edh_ap_flags = 0;
        assign edh_ff_flags = 0;
        assign edh_anc_flags = 0;
        assign edh_packet_flags = 0;
        assign edh_ap = 1'b0;
        assign edh_ff = 1'b0;
        assign edh_anc = 1'b0;
        assign edh_errcnt = 0;
    end
endgenerate

endmodule
