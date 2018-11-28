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

This module will examine a HD data stream and detect the transport format. It
detects all the video standards currently supported by ST 292-2010, including
the ST 2048-2 2K video formats. It also detects the transports supported by 
ST 425-2010, ST 372-2010, and the SD-SDI NTSC and PAL formats.

Note that this module detects transport timing and not necessarily  the actual 
video format. The module determines the transport format by examining the timing
of the video signals and does not rely on ST 352 video payload ID packets.
However, this means that it is not able to determine the exact video format,
only the nature of the transport timing.

The transport_family port indicates the video format family of the signal
being received. It is encoded as follows:

ST 274      1920x1080   0000
ST 296      1280x720    0001
ST 2048-2   2048x1080   0010        This also includes the ST 428-9 and ST 428-19 formats
ST 295                  0011        Obsolete format
NTSC        720x486     1000
PAL         720x576     1001
UNKNOWN                 1111

All other codes are reserved for future use. The format detector does detect
and lock to the obsolete ST 260 video format, but simply reports it as the
1920x1080 ST 274 format.

The transport_rate port indicates the frame rate of the transport, not 
necessarily the frame rate of the picture. This port is encoded in the same way 
that the picture rate field of the ST 352 video payload ID packet is encoded:

NONE        0000
23.98 Hz    0010
24 Hz       0011
47.95 Hz    0100
25 Hz       0101
29.97 Hz    0110
30 Hz       0111
48 Hz       1000
50 Hz       1001
59.94 Hz    1010
60 Hz       1011

The format detector uses the bit_rate input port to distinguish between the
otherwise identical timings of the 1/1.000 rates and the 1/1.001 rates. If the
bit rate port is hard wired to 1'b0, all rates will be reported as exact 
1/1.000 rates.

The transport_locked output is asserted as long as the transport_family and
transport_rate are known good values. It will be cleared to zero whenever
mode_locked is negated.
cunhua: deassertion only when mode_locked negated is not good, this make stream
detection relying on mode_locked and t_locked not possible in downstream modules.
I will add logic to deassert t_lock once locked t_* signal values changes.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_rx_v1_0_0_transport_detect
(
    input  wire        clk,                     // recovered SDI clock
    input  wire        rst,                     // synchronous reset
    input  wire        ce,                      // clock enable input
    input  wire        vid_7,                   // connect to bit 7 of C or Y data stream (V bit) 
    input  wire        eav,                     // must be asserted during XYZ word of EAV
    input  wire        sav,                     // must be asserted during XYZ word of SAV
    input  wire        bit_rate,                // 1 = rate/1.001
    input  wire [2:0]  mode,                    // SDI mode
    input  wire [2:0]  active_streams,          // number of active streams
    input  wire        mode_locked,             // indicates when mode is valid
    input  wire        level_b,                 // 3G-SDI level code
    input  wire [10:0] ln,                      // current line number
    output reg  [3:0]  transport_family=4'hF,   // transport format family code
    output reg  [3:0]  transport_rate=4'hF,     // frame rate code
    output reg         transport_scan=1'b0,     // 0 = interlaced, 1 = progressive
    output wire        transport_locked         // 1 = transport format has been detected
);

//-----------------------------------------------------------------------------
// Parameter definitions
//

localparam HCNT_MSB     = 5;                // MS bit # of modulo 63 HANC counter
localparam HANC_MOD     = 63;               // Modulo value to use for HANC counter
localparam HANC_TC      = HANC_MOD-1;
localparam VCNT_MSB     = 10;               // MS bit # of vertical counter
localparam FA_DLY_MSB   = 9;                // MS bit # of first active line delay shift reg

localparam [3:0]
    FAM_1920_1080       = 4'b0000,
    FAM_1280_720        = 4'b0001,
    FAM_2048_1080       = 4'b0010,
    FAM_ST295           = 4'b0011,
    FAM_NTSC            = 4'b1000,
    FAM_PAL             = 4'b1001,
    FAM_UNKNOWN         = 4'b1111;

localparam [2:0]
    RATE_24             = 3'b000,
    RATE_25             = 3'b001,
    RATE_30             = 3'b010,
    RATE_48             = 3'b011,
    RATE_50             = 3'b100,
    RATE_60             = 3'b101,
    RATE_UNKNOWN        = 3'b111;

localparam [3:0]
    SMPTE_RATE_NONE     = 4'h0,
    SMPTE_RATE_24M      = 4'h2,
    SMPTE_RATE_24       = 4'h3,
    SMPTE_RATE_48M      = 4'h4,
    SMPTE_RATE_25       = 4'h5,
    SMPTE_RATE_30M      = 4'h6,
    SMPTE_RATE_30       = 4'h7,
    SMPTE_RATE_48       = 4'h8,
    SMPTE_RATE_50       = 4'h9,
    SMPTE_RATE_60M      = 4'hA,
    SMPTE_RATE_60       = 4'hB;

localparam [2:0]
    MODE_HD             = 3'b000,
    MODE_SD             = 3'b001,
    MODE_3G             = 3'b010,
    MODE_6G             = 3'b100,
    MODE_12G            = 3'b101,
    MODE_12G_1          = 3'b110;
//
// Signal definitions
//
reg                     eav_reg = 1'b0;
reg                     sav_reg = 1'b0;
reg     [2:0]           mode_reg = 3'b000;           // SDI mode input register
reg     [2:0]           active_streams_reg = 3'b000; // active streams input register
reg                     level_b_reg = 1'b0;
reg                     v_reg = 1'b0;
reg                     v_last = 1'b0;          // previous V flag value
wire                    fa;                     // first active line indicator
reg     [FA_DLY_MSB:0]  fa_dly = 0;             // delays first active signal by 8 clocks
 wire                    fa_dly_out;
 reg     [HCNT_MSB:0]    hanc_counter = 0;       // counts samples in HANC, modulo 8
 reg     [HCNT_MSB:0]    hanc_counter_save = 0;  // saves the last HANC counter value
 reg     [VCNT_MSB:0]    first_active_line = 0;  // register holds line # of first active video line
 wire                    is_1080p;               // 1 when format is 1080p
 reg                     hanc_counter_en = 1'b0; // HANC interval counter enable
 reg                     mode_3GA;
 reg                     locked_int = 1'b0;
 reg                     locked_int2 = 1'b0;
reg     [HCNT_MSB+2:0]  rom_address = 0;
reg     [7:0]           rom_out = 0;
 wire    [3:0]           family;
 wire    [2:0]           rate;
 wire                    scan;
 reg    [3:0]           family_locked;
 reg    [2:0]           rate_locked;
 reg                    scan_locked;
 reg                     bit_rate_reg = 1'b0;

// -----------------------------------------------------------------------------
// Input registers
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            eav_reg <= 1'b0;
        else
            eav_reg <= eav;
    end

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            sav_reg <= 1'b0;
        else
            sav_reg <= sav;
    end

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            mode_reg <= 3'b000;
        else
            mode_reg <= mode;
    end

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            active_streams_reg <= 3'b000;
        else
            active_streams_reg <= active_streams;
    end

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            level_b_reg <= 1'b0;
        else
            level_b_reg <= level_b;
    end

//
// The mode_3GA signals is used to select the detected frame rate as either 
// being in the 25&30 Hz family (if mode_3GA is Low) or in the 50&60 Hz family
// if mode_3GA is High. In 6G-SDI mode, if there are 8 active data streams, the
// mode_3GA signal is Low to select the 25&30 Hz family and if there are 4 active
// streams, mode_3GA is High to select the 50&60 Hz family. It is not possible
// for the frame rate detector to distinguish between the 50&60 Hz frame rate
// family and the 100&120 Hz frame rate family carried in 6G-SDI mapping modes
// 2 & 3 because and the 100&120 Hz frame rates are always reported as 50&60 Hz.
// In 12G-SDI mode, the mode_3GA signal is asserted if there are 8 data streams
// and it is not asserted if there are 16 data streams.
//
always @ (*)
    case (mode_reg)
        MODE_SD:    mode_3GA = 1'b0;
        MODE_HD:    mode_3GA = 1'b0;
        MODE_3G:    mode_3GA = ~level_b_reg;
        MODE_6G:    mode_3GA = active_streams_reg == 3'b010;
        default:    mode_3GA = active_streams_reg == 3'b011;
    endcase
    
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            v_reg <= 1'b0;
        else
            v_reg <= vid_7;
    end

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            bit_rate_reg <= 1'b0;
        else
            bit_rate_reg <= bit_rate;
    end

//------------------------------------------------------------------------------
// HANC counter
//
// The HANC counter is a modulo 63 counter that counts the duration of the
// HANC interval. It begins counting when the eav input is asserted and stops
// when sav is asserted.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst | sav_reg)
            hanc_counter_en <= 1'b0;
        else if (eav_reg)
            hanc_counter_en <= 1'b1;
    end

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            hanc_counter <= 63; 
        else if (eav_reg)
            hanc_counter <= 0;
        else if (hanc_counter_en)
        begin
            if (hanc_counter == HANC_TC)
                hanc_counter <= 0;
            else
                hanc_counter <= hanc_counter + 1;
        end
    end

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            hanc_counter_save <= 63;
        else if (~hanc_counter_en)
            hanc_counter_save <= hanc_counter;
    end

//------------------------------------------------------------------------------
// Detect first active video line
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            v_last <= 1'b0;
        else if (eav_reg)
            v_last <= v_reg;
    end

assign fa = ~v_reg & v_last & eav_reg;

always @ (posedge clk)
    if (ce)
        fa_dly <= {fa_dly[FA_DLY_MSB-1:0], fa};

assign fa_dly_out = fa_dly[FA_DLY_MSB-2];

always @ (posedge clk)
    if (ce)
    begin
        if (fa_dly_out)
            first_active_line <= ln;
    end
    
assign is_1080p = first_active_line == 11'd42;

//------------------------------------------------------------------------------
// Transport family code ROM
//
always @ (posedge clk)
    if (ce)
        rom_address <= {mode_3GA, is_1080p, hanc_counter_save};

always @ (*)
    case(rom_address)
        8'd20   :   rom_out = {1'b0, RATE_30, FAM_NTSC};           // SD:      NTSC
        8'd32   :   rom_out = {1'b0, RATE_25, FAM_PAL};            // SD:      PAL
        8'd24   :   rom_out = {1'b0, RATE_30, FAM_1920_1080};      // HD/3GB:  1080i60 
        8'd23   :   rom_out = {1'b0, RATE_25, FAM_1920_1080};      // HD/3GB:  1080i50
        8'd88   :   rom_out = {1'b1, RATE_30, FAM_1920_1080};      // HD/3GB:  1080p30
        8'd87   :   rom_out = {1'b1, RATE_25, FAM_1920_1080};      // HD/3GB:  1080p25
        8'd71   :   rom_out = {1'b1, RATE_24, FAM_1920_1080};      // HD-3GB:  1080p24
        8'd7    :   rom_out = {1'b0, RATE_24, FAM_1920_1080};      // HD-3GB:  1080psF24
        8'd51   :   rom_out = {1'b1, RATE_60, FAM_1280_720};       // HD:      720p60
        8'd3    :   rom_out = {1'b1, RATE_50, FAM_1280_720};       // HD:      720p50
        8'd0    :   rom_out = {1'b1, RATE_30, FAM_1280_720};       // HD:      720p30
        8'd30   :   rom_out = {1'b1, RATE_25, FAM_1280_720};       // HD:      720p25
        8'd6    :   rom_out = {1'b1, RATE_24, FAM_1280_720};       // HD:      720p24
        8'd86   :   rom_out = {1'b1, RATE_30, FAM_2048_1080};      // HD/3GB:  2Kx1080p30
        8'd85   :   rom_out = {1'b1, RATE_25, FAM_2048_1080};      // HD/3GB:  2Kx1080p25
        8'd69   :   rom_out = {1'b1, RATE_24, FAM_2048_1080};      // HD/3GB:  2Kx1080p24
        8'd22   :   rom_out = {1'b0, RATE_30, FAM_2048_1080};      // HD/3GB:  2Kx1080psF30
        8'd21   :   rom_out = {1'b0, RATE_25, FAM_2048_1080};      // HD/3GB:  2Kx1080psF25
        8'd5    :   rom_out = {1'b0, RATE_24, FAM_2048_1080};      // HD/3GB:  2Kx1080psF24
        8'd216  :   rom_out = {1'b1, RATE_60, FAM_1920_1080};      // 3GA:     1080p60
        8'd215  :   rom_out = {1'b1, RATE_50, FAM_1920_1080};      // 3GA:     1080p50
        8'd214  :   rom_out = {1'b1, RATE_60, FAM_2048_1080};      // 3GA:     2Kx1080p60
        8'd213  :   rom_out = {1'b1, RATE_50, FAM_2048_1080};      // 3GA:     2Kx1080p50
        8'd197  :   rom_out = {1'b1, RATE_48, FAM_2048_1080};      // 3GA:     2Kx1080p48
        8'd199  :   rom_out = {1'b1, RATE_48, FAM_1920_1080};      // 3GA:     1080p48
        8'd180  :   rom_out = {1'b0, RATE_30, FAM_1920_1080};      // 3GA:     1080i60
        8'd178  :   rom_out = {1'b0, RATE_25, FAM_1920_1080};      // 3GA:     1080i50
        8'd244  :   rom_out = {1'b1, RATE_30, FAM_1920_1080};      // 3GA:     1080p30
        8'd242  :   rom_out = {1'b1, RATE_25, FAM_1920_1080};      // 3GA:     1080p25
        8'd210  :   rom_out = {1'b1, RATE_24, FAM_1920_1080};      // 3GA:     1080p24
        8'd146  :   rom_out = {1'b0, RATE_24, FAM_1920_1080};      // 3GA:     1080psF24
        8'd240  :   rom_out = {1'b1, RATE_30, FAM_2048_1080};      // 3GA:     2Kx1080p30
        8'd238  :   rom_out = {1'b1, RATE_25, FAM_2048_1080};      // 3GA:     2Kx1080p25
        8'd206  :   rom_out = {1'b1, RATE_24, FAM_2048_1080};      // 3GA:     2Kx1080p24
        8'd176  :   rom_out = {1'b0, RATE_30, FAM_2048_1080};      // 3GA:     2Kx1080psF30
        8'd174  :   rom_out = {1'b0, RATE_25, FAM_2048_1080};      // 3GA:     2Kx1080psF25
        8'd142  :   rom_out = {1'b0, RATE_24, FAM_2048_1080};      // 3GA:     2Kx1080psF24
        8'd171  :   rom_out = {1'b1, RATE_60, FAM_1280_720};       // 3GA:     720p60
        8'd138  :   rom_out = {1'b1, RATE_50, FAM_1280_720};       // 3GA:     720p50
        8'd132  :   rom_out = {1'b1, RATE_30, FAM_1280_720};       // 3GA:     720p30
        8'd129  :   rom_out = {1'b1, RATE_25, FAM_1280_720};       // 3GA:     720p25
        8'd144  :   rom_out = {1'b1, RATE_24, FAM_1280_720};       // 3GA:     720p24
        8'd11   :   rom_out = {1'b0, RATE_25, FAM_ST295};          // HD:      ST295
        default :   rom_out = {1'b0, RATE_UNKNOWN, FAM_UNKNOWN};
    endcase

assign family = rom_out[3:0];
assign rate   = rom_out[6:4];
assign scan   = rom_out[7];

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            transport_family <= FAM_UNKNOWN;
        else if (((family == FAM_PAL) || (family == FAM_NTSC)) && (mode_reg != 3'b001))
            transport_family <= FAM_UNKNOWN;
        else
            transport_family <= family;
    end

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            transport_rate <= SMPTE_RATE_NONE;
        else if (family == FAM_NTSC)
            transport_rate <= SMPTE_RATE_30M;
        else
            casex({rate, bit_rate_reg})
                4'b000_0 :  transport_rate <= SMPTE_RATE_24;
                4'b000_1 :  transport_rate <= SMPTE_RATE_24M;
                4'b001_x :  transport_rate <= SMPTE_RATE_25;
                4'b010_0 :  transport_rate <= SMPTE_RATE_30;
                4'b010_1 :  transport_rate <= SMPTE_RATE_30M;
                4'b011_0 :  transport_rate <= SMPTE_RATE_48;
                4'b011_1 :  transport_rate <= SMPTE_RATE_48M;
                4'b100_x :  transport_rate <= SMPTE_RATE_50;
                4'b101_0 :  transport_rate <= SMPTE_RATE_60;
                4'b101_1 :  transport_rate <= SMPTE_RATE_60M;   
                default  :  transport_rate <= SMPTE_RATE_NONE;
            endcase
    end

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            transport_scan <= 1'b0;
        else
            transport_scan <= scan;
    end


//------------------------------------------------------------------------------
// Transport locked detection
//
always @ (posedge clk) begin
    if (ce)
    begin
	    if (rst | ~mode_locked) begin
            locked_int <= 1'b0;
            locked_int2 <= 1'b0;
			rate_locked <= 0;
			family_locked <= 0;
			scan_locked <= 0;
		end else if (mode_locked & (mode == 3'b001))
 begin
            locked_int <= (rate != RATE_UNKNOWN) && (family != FAM_UNKNOWN);
	    end else if (fa_dly[FA_DLY_MSB]) begin
            locked_int <= (rate != RATE_UNKNOWN) && (family != FAM_UNKNOWN);
		end
		//cunhua: latch locked version of rate/family/scan when final locked go high. 
		if(locked_int2 == 1'b1) begin
			rate_locked <= rate;
			family_locked <= family;
			scan_locked <= scan;
	    end
		//deassert locked_int2 if already in locked state but rate/family/scan changed.
		if(locked_int2 & locked_int) begin
			if ((rate_locked != rate) || (family_locked != family) || (scan_locked != scan)) begin
			    locked_int2 <= 1'b0;
			end
		end else begin
			    locked_int2 <= locked_int;
		end

    end
end

assign transport_locked = locked_int2;

endmodule
