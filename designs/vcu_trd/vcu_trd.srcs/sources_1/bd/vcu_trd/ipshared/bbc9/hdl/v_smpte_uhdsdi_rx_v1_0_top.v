
`timescale 1 ns / 1 ps

	module v_smpte_uhdsdi_rx_v1_0_0 #
	(
		parameter C_AXI4LITE_ENABLE               = 1,				
		parameter C_ADV_FEATURE                   = 0,
                parameter C_INCLUDE_VID_OVER_AXI          = 1,
                parameter C_INCLUDE_SDI_BRIDGE            = 1,
                parameter C_INCLUDE_RX_EDH_PROCESSOR      = 1,
		parameter C_NUM_RX_CE                     = 1,				// number of clock enable outputs
		parameter C_RX_TDATA_WIDTH                = 40,			// width of rxdata port, must be 40 if 6G/12G are used, otherwise 20
		parameter C_RX_TUSER_WIDTH                = 32,			
		parameter integer C_AXI_DATA_WIDTH	= 32,
		parameter integer C_AXI_ADDR_WIDTH	= 9,
        parameter C_NUM_SYNC_REGS                = 3,	
		//hidden parameters
		parameter C_EDH_ERR_WIDTH         = 16,				// bit width of the EDH error counter
        parameter C_ERRCNT_WIDTH          = 4,                // width of counter tracking lines with errors
        parameter C_MAX_ERRS_LOCKED       = 15,               // max number of consecutive lines with errors
        parameter C_MAX_ERRS_UNLOCKED     = 15                // max number of lines with errors during search
	)
	(
		// Users to add ports here
		input  wire                     rx_clk,                 // rxusrclk input
		input  wire                     rx_rst,                 // sync reset input
	    //input  wire                     rx_mode_detect_rst,
        input  wire                     axis_clk,               // vid_in_axi4s axis clk 
	    input  wire                     axis_rstn,               // vid_in_axi4s axis resetn 
        //control input ports
		input  wire [63:0]              sdi_rx_ctrl,            // sdi_rx control signals: refer to UHDSDI_CORE_SPECIFICATION
        //Native SDI Interface 2.0 (subset): master 
		output wire                     rx_mode_locked,         // auto mode detection locked
		output wire [2:0]               rx_mode,                // 000=HD, 001=SD, 010=3G, 100=6G, 101=12G
		output wire                     rx_mode_hd,             // 1 = HD mode      
		output wire                     rx_mode_sd,             // 1 = SD mode
		output wire                     rx_mode_3g,             // 1 = 3G mode
		output wire                     rx_mode_6g,             // 1 = 6G mode
		output wire                     rx_mode_12g,            // 1 = 12G mode
		output wire                     rx_level_b_3g,          // 0 = level A, 1 = level B
		output wire [C_NUM_RX_CE-1:0]     rx_ce_out,              // clock enable
		output wire [2:0]               rx_active_streams,      // 2^active_streams = number of active streams
		output wire                     rx_eav,                 // EAV
		output wire                     rx_sav,                 // SAV
		output wire                     rx_trs,                 // TRS
		output wire                     rx_t_locked,            // transport format detection locked
		output wire [3:0]               rx_t_family,            // transport format family
		output wire [3:0]               rx_t_rate,              // transport frame rate
		output wire                     rx_t_scan,              // transport scan: 0=interlaced, 1=progressive
		output wire [10:0]              rx_ln_ds1,              // line number for ds1
		output wire [10:0]              rx_ln_ds2,              // line number for ds2
		output wire [10:0]              rx_ln_ds3,              // line number for ds3
		output wire [10:0]              rx_ln_ds4,              // line number for ds4
		output wire [10:0]              rx_ln_ds5,              // line number for ds5
		output wire [10:0]              rx_ln_ds6,              // line number for ds6
		output wire [10:0]              rx_ln_ds7,              // line number for ds7
		output wire [10:0]              rx_ln_ds8,              // line number for ds8
		output wire [10:0]              rx_ln_ds9,              // line number for ds9
		output wire [10:0]              rx_ln_ds10,             // line number for ds10
		output wire [10:0]              rx_ln_ds11,             // line number for ds11
		output wire [10:0]              rx_ln_ds12,             // line number for ds12
		output wire [10:0]              rx_ln_ds13,             // line number for ds13
		output wire [10:0]              rx_ln_ds14,             // line number for ds14
		output wire [10:0]              rx_ln_ds15,             // line number for ds15
		output wire [10:0]              rx_ln_ds16,             // line number for ds16
		output wire [31:0]              rx_st352_0,             // video payload ID packet ds1 (for 3G-SDI level A, Y VPID)
		output wire                     rx_st352_0_valid,       // 1 = st352_0 is valid
		output wire [31:0]              rx_st352_1,             // video payload ID packet ds3 (ds2 for 3G-SDI level A, C VPID) 
		output wire                     rx_st352_1_valid,       // 1 = st352_1 is valid
		output wire [31:0]              rx_st352_2,             // video payload ID packet ds5
		output wire                     rx_st352_2_valid,       // 1 = st352_2 is valid
		output wire [31:0]              rx_st352_3,             // video payload ID packet ds7
		output wire                     rx_st352_3_valid,       // 1 = st352_3 is valid
		output wire [31:0]              rx_st352_4,             // video payload ID packet ds9
		output wire                     rx_st352_4_valid,       // 1 = st352_4 is valid
		output wire [31:0]              rx_st352_5,             // video payload ID packet ds11
		output wire                     rx_st352_5_valid,       // 1 = st352_5 is valid
		output wire [31:0]              rx_st352_6,             // video payload ID packet ds13
		output wire                     rx_st352_6_valid,       // 1 = st352_6 is valid
		output wire [31:0]              rx_st352_7,             // video payload ID packet ds15
		output wire                     rx_st352_7_valid,       // 1 = st352_7 is valid
		output wire [9:0]               rx_ds1,                 // SD=Y/C, HD=Y, 3GA=ds1, 3GB=Y link A, 6G/12G=ds1
		output wire [9:0]               rx_ds2,                 // HD=C, 3GA=ds2, 3GB=C link A, 6G/12G=ds2
		output wire [9:0]               rx_ds3,                 // 3GB=Y link B, 6G/12G=ds3
		output wire [9:0]               rx_ds4,                 // 3GB=C link B, 6G/12G=ds4
		output wire [9:0]               rx_ds5,                 // 6G/12G=ds5
		output wire [9:0]               rx_ds6,                 // 6G/12G=ds6
		output wire [9:0]               rx_ds7,                 // 6G/12G=ds7
		output wire [9:0]               rx_ds8,                 // 6G/12G=ds8
		output wire [9:0]               rx_ds9,                 // 12G=ds9
		output wire [9:0]               rx_ds10,                // 12G=ds10
		output wire [9:0]               rx_ds11,                // 12G=ds11
		output wire [9:0]               rx_ds12,                // 12G=ds12
		output wire [9:0]               rx_ds13,                // 12G=ds13
		output wire [9:0]               rx_ds14,                // 12G=ds14
		output wire [9:0]               rx_ds15,                // 12G=ds15
		output wire [9:0]               rx_ds16,                // 12G=ds16

                //Exposing for ANC data extraction
                output wire [31:0]              sdi_rx_anc_ctrl_out,
                //output wire [2:0]               rx_mode_anc,
                //output wire                     rx_ce_anc,
		output wire [9:0]               rx_ds1_anc,             // SD=Y/C, HD=Y, 3GA=ds1, 3GB=Y link A, 6G/12G=ds1
		output wire [9:0]               rx_ds2_anc,             // HD=C, 3GA=ds2, 3GB=C link A, 6G/12G=ds2
		output wire [9:0]               rx_ds3_anc,             // 3GB=Y link B, 6G/12G=ds3
		output wire [9:0]               rx_ds4_anc,             // 3GB=C link B, 6G/12G=ds4
		output wire [9:0]               rx_ds5_anc,             // 6G/12G=ds5
		output wire [9:0]               rx_ds6_anc,             // 6G/12G=ds6
		output wire [9:0]               rx_ds7_anc,             // 6G/12G=ds7
		output wire [9:0]               rx_ds8_anc,             // 6G/12G=ds8
		output wire [9:0]               rx_ds9_anc,             // 12G=ds9
		output wire [9:0]               rx_ds10_anc,            // 12G=ds10
		output wire [9:0]               rx_ds11_anc,            // 12G=ds11
		output wire [9:0]               rx_ds12_anc,            // 12G=ds12
		output wire [9:0]               rx_ds13_anc,            // 12G=ds13
		output wire [9:0]               rx_ds14_anc,            // 12G=ds14
		output wire [9:0]               rx_ds15_anc,            // 12G=ds15
		output wire [9:0]               rx_ds16_anc,            // 12G=ds16

                // Exposing status signals when AXI-4 Lite is not present 
		output wire                     rx_mode_locked_sts,         // auto mode detection locked
		output wire [2:0]               rx_mode_sts,                // 000=HD, 001=SD, 010=3G, 100=6G, 101=12G
		output wire                     rx_mode_hd_sts,             // 1 = HD mode      
		output wire                     rx_mode_sd_sts,             // 1 = SD mode
		output wire                     rx_mode_3g_sts,             // 1 = 3G mode
		output wire                     rx_mode_6g_sts,             // 1 = 6G mode
		output wire                     rx_mode_12g_sts,            // 1 = 12G mode
		output wire                     rx_level_b_3g_sts,          // 0 = level A, 1 = level B
		output wire [C_NUM_RX_CE-1:0]     rx_ce_out_sts,              // clock enable
		output wire [2:0]               rx_active_streams_sts,      // 2^active_streams = number of active streams
		output wire                     rx_eav_sts,                 // EAV
		output wire                     rx_sav_sts,                 // SAV
		output wire                     rx_trs_sts,                 // TRS
                
		//output ports
		output wire [31:0]              sdi_rx_err,             // error detected by core 
		output wire [63:0]              sdi_rx_edh_out,         // edh check result by core 

        //s_axis interface to GT
		output  wire                     s_axis_rx_tready,  //Currently dont support push back: make sure tready never go down once started data stream in system
		input wire                       s_axis_rx_tvalid, 
		input wire [C_RX_TDATA_WIDTH-1:0]  s_axis_rx_tdata,    
		input wire [C_RX_TUSER_WIDTH-1:0]  s_axis_rx_tuser,   
        //control siadband to GT
		input  wire                      m_axis_ctrl_sb_rx_tready,
		output wire                      m_axis_ctrl_sb_rx_tvalid, 
		output wire [31:0]                m_axis_ctrl_sb_rx_tdata,    
		//status siadband from GT
		output wire                      s_axis_sts_sb_rx_tready,
		input wire                       s_axis_sts_sb_rx_tvalid, 
		input wire [31:0]                 s_axis_sts_sb_rx_tdata,    
	    //control signal to vid_in_axi4s bridge
	    output reg vid_in_axi4s_vid_rst,  //reset in tx_clk domain: ((!module_enable) OR rx_rst)
		output reg vid_in_axi4s_vid_rstn,  //inverted vid_in_axi4s_rst 
(* dont_touch = "true" *)		output reg vid_in_axi4s_axis_rstn,  //reset in axis clock domain: module_enable AND axis_rstn
		output wire vid_in_axi4s_axis_enable,  
        //status signal from vid_in_axi4s 
		input wire vid_in_axi4s_overflow,
		input wire vid_in_axi4s_underflow,
        //control signal to sdi_rx_bridge
		output wire [31:0] sdi_rx_bridge_ctrl,
		//status signal from sdi_rx_bridge
		input wire [31:0] sdi_rx_bridge_sts,

		// AXI4LITE interface
		input  wire  s_axi_aclk,
		input  wire  s_axi_aresetn,
		input  wire [C_AXI_ADDR_WIDTH-1 : 0] s_axi_awaddr,
		input  wire [2 : 0] s_axi_awprot,
		input  wire  s_axi_awvalid,
		output wire  s_axi_awready,
		input  wire [C_AXI_DATA_WIDTH-1 : 0] s_axi_wdata,
		input  wire [(C_AXI_DATA_WIDTH/8)-1 : 0] s_axi_wstrb,
		input  wire  s_axi_wvalid,
		output wire  s_axi_wready,
		output wire [1 : 0] s_axi_bresp,
		output wire  s_axi_bvalid,
		input  wire  s_axi_bready,
		input  wire [C_AXI_ADDR_WIDTH-1 : 0] s_axi_araddr,
		input  wire [2 : 0] s_axi_arprot,
		input  wire  s_axi_arvalid,
		output wire  s_axi_arready,
		output wire [C_AXI_DATA_WIDTH-1 : 0] s_axi_rdata,
		output wire [1 : 0] s_axi_rresp,
		output wire  s_axi_rvalid,
		input  wire  s_axi_rready,

		//Interrupts
		output wire  interrupt	
	);

    //sdi_rx_ctrl
    wire      		module_enable;                   
	wire      		output_enable;   	
	wire            rx_frame_en;
	wire            rx_mode_detect_en;
	wire [5:0]      rx_mode_enable;
	wire [2:0]      rx_forced_mode;
	wire [15:0]     rx_edh_errcnt_en;      	// enables various error to increment rx_edh_errcnt
	wire            rx_edh_clr_errcnt;         // clears rx_edh_errcnt
    
    //axi_aclk domain signals
	wire [31:0] module_ctrl_axi;
	wire [31:0] sdi_rx_bridge_ctrl_axi;
	wire [31:0] vid_in_axi4s_ctrl_axi;
	wire  vid_in_axi4s_module_enable_axis;
	wire  vid_in_axi4s_module_enable_sys;
    wire vid_in_axi4s_overflow_axi;
	wire vid_in_axi4s_underflow_axi;
	wire [31:0] vid_in_axi4s_sts_axi; 
	wire [31:0] stat_reset_axi;
	wire [15:0] rx_edh_errcnt_en_axi;
	wire video_lock_int_axi;
	wire video_unlock_int_axi;
	wire vid_lock_st352_vld_int_axi;
	wire rcv_st352_always_axi;
	wire rcv_st352_always;
    wire [7:0] rx_st352_valid_axi;
	wire [31:0] rx_st352_0_axi;
	wire [31:0] rx_st352_1_axi;
	wire [31:0] rx_st352_2_axi;
	wire [31:0] rx_st352_3_axi;
	wire [31:0] rx_st352_4_axi;
	wire [31:0] rx_st352_5_axi;
	wire [31:0] rx_st352_6_axi;
	wire [31:0] rx_st352_7_axi;
	wire [15:0] rx_crc_err_axi;
	reg [15:0] rx_crc_err_axi_d1;
	reg [31:0] rx_crc_errcnt_reg_axi;
	reg [15:0] rx_crc_errcnt_axi;
	wire [15:0] rx_edh_errcnt_axi;
	wire [22:0] rx_edh_sts_axi;
	wire [11:0] ts_det_sts_axi;
	wire [7:0] mode_det_sts_axi;
	//sys_clk domain signals
	wire [31:0] module_ctrl_sys;
    wire rx_edh_clr_errcnt_sys;
	wire [15:0] rx_edh_errcnt_en_sys;
	reg video_lock_int;
	reg video_unlock_int;
	reg vid_lock_st352_vld_int;
	wire [11:0] ts_det_sts;
	wire [7:0] mode_det_sts;

	//uhdsdi_rx signals
	wire            rx_ready;
    wire            rx_mode_locked_int;         // auto mode detection locked
    wire [2:0]      rx_mode_int;                // 000=HD_int; 001=SD_int; 010=3G_int; 100=6G_int; 101=12G
    wire            rx_mode_hd_int;             // 1 = HD mode      
    wire            rx_mode_sd_int;             // 1 = SD mode
    wire            rx_mode_3g_int;             // 1 = 3G mode
    wire            rx_mode_6g_int;             // 1 = 6G mode
    wire            rx_mode_12g_int;            // 1 = 12G mode
    wire            rx_level_b_3g_int;          // 0 = level A_int; 1 = level B
    wire [C_NUM_RX_CE-1:0]   rx_ce_out_int;              // clock enable
    wire [2:0]      rx_active_streams_int;      // 2^active_streams = number of active streams
    wire [2:0]      rx_active_streams_axi;      // 2^active_streams = number of active streams
    wire            rx_eav_int;                 // EAV
    wire            rx_sav_int;                 // SAV
    wire            rx_trs_int;                 // TRS
    wire            rx_t_locked_int;            // transport format detection locked
    wire [3:0]      rx_t_family_int;            // transport format family
    wire [3:0]      rx_t_rate_int;              // transport frame rate
    wire            rx_t_scan_int;              // transport scan: 0=interlaced_int; 1=progressive
    wire [7:0]      rx_st352_valid_int;
    wire [31:0]     rx_st352_0_int;             // video payload ID packet ds1 (for 3G-SDI level A_int; Y VPID)
    wire [31:0]     rx_st352_1_int;             // video payload ID packet ds3 (ds2 for 3G-SDI level A_int; C VPID) 
    wire [31:0]     rx_st352_2_int;             // video payload ID packet ds5
    wire [31:0]     rx_st352_3_int;             // video payload ID packet ds7
    wire [31:0]     rx_st352_4_int;             // video payload ID packet ds9
    wire [31:0]     rx_st352_5_int;             // video payload ID packet ds11
    wire [31:0]     rx_st352_6_int;             // video payload ID packet ds13
    wire [31:0]     rx_st352_7_int;             // video payload ID packet ds15
	wire [15:0]     rx_crc_err_int;
    wire [22:0]     rx_edh_sts_int;
    wire [15:0]     rx_edh_errcnt_int;
    wire [31:0] sts_sb_axi;
    wire [31:0] sts_sb_sys;
    wire [31:0] sdi_rx_bridge_sts_axi;
    wire [9:0]     rx_ds1_t;
    wire [9:0]     rx_ds2_t;
    wire [9:0]     rx_ds3_t;
    wire [9:0]     rx_ds4_t;
    wire [9:0]     rx_ds5_t;
    wire [9:0]     rx_ds6_t;
    wire [9:0]     rx_ds7_t;
    wire [9:0]     rx_ds8_t;
    wire [9:0]     rx_ds9_t;
    wire [9:0]     rx_ds10_t;
    wire [9:0]     rx_ds11_t;
    wire [9:0]     rx_ds12_t;
    wire [9:0]     rx_ds13_t;
    wire [9:0]     rx_ds14_t;
    wire [9:0]     rx_ds15_t;
    wire [9:0]     rx_ds16_t;
	wire rx_fabric_rst;
	wire rx_fabric_rst_axis;
	wire rx_resetdone;
	wire rx_change_done;
	wire rx_bit_rate;
	reg rx_rst_int;
	wire rx_rst_int_sys;
	reg video_locked;
	reg video_locked_d1;
	reg video_locked_d2;
	reg video_locked_d3;
	reg vid_lock_st352_vld;
	reg vid_lock_st352_vld_r1;
	reg vid_lock_st352_vld_r2;
	//wire gt_rx_rst_pll_and_datapath;
	//wire gt_rx_rst_datapath;
	//wire gt_rst_all;
	reg vid_in_axi4s_vid_rst_d1;
	reg vid_in_axi4s_vid_rst_d2;
	reg vid_in_axi4s_vid_rstn_d1;
	reg vid_in_axi4s_vid_rstn_d2;
(* dont_touch = "true" *)	reg vid_in_axi4s_axis_rstn_d1;
(* dont_touch = "true" *)	reg vid_in_axi4s_axis_rstn_d2;
        reg [31:0] video_lock_cnt;
        reg video_lock_gen_cnt;
    wire [31:0] video_lock_window_axi;
    wire [31:0] video_lock_window_sys;
 (* dont_touch = "true" *)   reg         vid_in_axi4s_mod_en_axi_r;
 (* dont_touch = "true" *)   reg         vid_in_axi4s_mod_en_axi_nxt;
        reg [7:0]      rx_st352_valid_int_r;
        reg            rx_st352_vld_always_r;
(* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg [15:0] rx_crc_err_int_sync1_cdc_to = 16'd0;
(* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg [15:0] rx_crc_err_int_sync2_reg    = 16'd0;
(* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg [15:0] rx_crc_err_int_last_reg     = 16'd0;


//assign input/output
//slave axis
assign s_axis_rx_tready = 1'b1; //no push back
//ctrl sideband
assign m_axis_ctrl_sb_rx_tvalid     = 1'b1; 
assign m_axis_ctrl_sb_rx_tdata[2:0] = rx_mode_int; 
assign m_axis_ctrl_sb_rx_tdata[3] = rx_mode_locked_int; //
assign m_axis_ctrl_sb_rx_tdata[4] = rx_level_b_3g_int; 
assign m_axis_ctrl_sb_rx_tdata[5] = rx_ce_out_int; 
assign m_axis_ctrl_sb_rx_tdata[31:6] = 0; //reserved
//sts sideband 
assign s_axis_sts_sb_rx_tready = 1'b1; //no push back
assign rx_change_done = sts_sb_sys[0];
assign rx_resetdone = sts_sb_sys[2];
assign rx_bit_rate = sts_sb_sys[3];
assign rx_fabric_rst = sts_sb_sys[8];

assign rx_ds1   =  rx_ds1_t;
assign rx_ds2   =  rx_ds2_t;
assign rx_ds3   =  rx_ds3_t;
assign rx_ds4   =  rx_ds4_t;
assign rx_ds5   =  rx_ds5_t;
assign rx_ds6   =  rx_ds6_t;
assign rx_ds7   =  rx_ds7_t;
assign rx_ds8   =  rx_ds8_t;
assign rx_ds9   =  rx_ds9_t;
assign rx_ds10  =  rx_ds10_t;
assign rx_ds11  =  rx_ds11_t;
assign rx_ds12  =  rx_ds12_t;
assign rx_ds13  =  rx_ds13_t;
assign rx_ds14  =  rx_ds14_t;
assign rx_ds15  =  rx_ds15_t;
assign rx_ds16  =  rx_ds16_t;

generate if (C_ADV_FEATURE == 1) begin : gen_rx_ds_anc
  assign sdi_rx_anc_ctrl_out[0]     =  rx_ce_out_int;  
  assign sdi_rx_anc_ctrl_out[3:1]   =  rx_mode_int;  
  assign sdi_rx_anc_ctrl_out[7:4]   =  rx_t_family_int;  
  assign sdi_rx_anc_ctrl_out[8]     =  rx_mode_locked_int;  
  assign sdi_rx_anc_ctrl_out[9]     =  rx_t_locked_int;  
  assign sdi_rx_anc_ctrl_out[13:10] =  rx_t_rate_int;  
  assign sdi_rx_anc_ctrl_out[14]    =  rx_t_scan_int;  
  assign sdi_rx_anc_ctrl_out[15]    =  rx_rst_int_sys;  
  assign sdi_rx_anc_ctrl_out[31:16] =  0;  
  //assign rx_mode_anc  =  rx_mode_int;  
  //assign rx_ce_anc    =  rx_ce_out_int;  
  assign rx_ds1_anc   =  rx_ds1_t;
  assign rx_ds2_anc   =  rx_ds2_t;
  assign rx_ds3_anc   =  rx_ds3_t;
  assign rx_ds4_anc   =  rx_ds4_t;
  assign rx_ds5_anc   =  rx_ds5_t;
  assign rx_ds6_anc   =  rx_ds6_t;
  assign rx_ds7_anc   =  rx_ds7_t;
  assign rx_ds8_anc   =  rx_ds8_t;
  assign rx_ds9_anc   =  rx_ds9_t;
  assign rx_ds10_anc  =  rx_ds10_t;
  assign rx_ds11_anc  =  rx_ds11_t;
  assign rx_ds12_anc  =  rx_ds12_t;
  assign rx_ds13_anc  =  rx_ds13_t;
  assign rx_ds14_anc  =  rx_ds14_t;
  assign rx_ds15_anc  =  rx_ds15_t;
  assign rx_ds16_anc  =  rx_ds16_t;
end
else begin
  assign sdi_rx_anc_ctrl_out  =  0;  
  //assign rx_mode_anc  =  0;  
  //assign rx_ce_anc    =  0;  
  assign rx_ds1_anc   =  0;
  assign rx_ds2_anc   =  0;
  assign rx_ds3_anc   =  0;
  assign rx_ds4_anc   =  0;
  assign rx_ds5_anc   =  0;
  assign rx_ds6_anc   =  0;
  assign rx_ds7_anc   =  0;
  assign rx_ds8_anc   =  0;
  assign rx_ds9_anc   =  0;
  assign rx_ds10_anc  =  0;
  assign rx_ds11_anc  =  0;
  assign rx_ds12_anc  =  0;
  assign rx_ds13_anc  =  0;
  assign rx_ds14_anc  =  0;
  assign rx_ds15_anc  =  0;
  assign rx_ds16_anc  =  0;
end
endgenerate

//SDI_STS_OUT I/F
  assign  rx_mode_sts              =  rx_mode_int;  
  assign  rx_ce_out_sts            =  rx_ce_out_int;  
  assign  rx_active_streams_sts    =  rx_active_streams_int;  
  assign  rx_mode_locked_sts       =  rx_mode_locked_int;  
  assign  rx_mode_hd_sts           =  rx_mode_hd_int; 
  assign  rx_mode_sd_sts           =  rx_mode_sd_int;   
  assign  rx_mode_3g_sts           =  rx_mode_3g_int;   
  assign  rx_mode_6g_sts           =  rx_mode_6g_int;   
  assign  rx_mode_12g_sts          =  rx_mode_12g_int;   
  assign  rx_level_b_3g_sts        =  rx_level_b_3g_int;  
  assign  rx_eav_sts               =  rx_eav_int; 
  assign  rx_sav_sts               =  rx_sav_int; 
  assign  rx_trs_sts               =  rx_trs_int; 

//combine fabric_rst from uhdsdi_ctrl(compact_gt) and module_disable with rx_rst to reset rx core (xapp1248);
always @( posedge rx_clk) begin
   rx_rst_int <= rx_rst | rx_fabric_rst | (~module_enable); 
end

always @ (posedge s_axi_aclk) begin
  vid_in_axi4s_mod_en_axi_r    <=  vid_in_axi4s_ctrl_axi[0];  
  vid_in_axi4s_mod_en_axi_nxt  <=  vid_in_axi4s_ctrl_axi[0];  
end

//vid_in_axi4s control signals
assign vid_in_axi4s_axis_enable = vid_in_axi4s_module_enable_sys;

/////////////////////bridge reset generatation////////////begin
always @( posedge rx_clk) begin
	vid_in_axi4s_vid_rst_d1 <= (! vid_in_axi4s_module_enable_sys) | rx_rst | rx_fabric_rst;
	vid_in_axi4s_vid_rst_d2 <= vid_in_axi4s_vid_rst_d1;  
	vid_in_axi4s_vid_rst <= vid_in_axi4s_vid_rst_d2;  

	vid_in_axi4s_vid_rstn_d1 <= ! vid_in_axi4s_vid_rst;
	vid_in_axi4s_vid_rstn_d2 <= vid_in_axi4s_vid_rstn_d1;  
	vid_in_axi4s_vid_rstn <= vid_in_axi4s_vid_rstn_d2;  
end

always @( posedge axis_clk) begin
	vid_in_axi4s_axis_rstn_d1 <= vid_in_axi4s_module_enable_axis & axis_rstn & (~rx_fabric_rst_axis);
	vid_in_axi4s_axis_rstn_d2  <=  vid_in_axi4s_axis_rstn_d1; 
	vid_in_axi4s_axis_rstn  <=  vid_in_axi4s_axis_rstn_d2; 
end
/////////////////////bridge reset generation////////////end
assign vid_in_axi4s_sts_axi[0] = vid_in_axi4s_overflow_axi;
assign vid_in_axi4s_sts_axi[1] = vid_in_axi4s_underflow_axi;
assign vid_in_axi4s_sts_axi[31:2] = 0; 


//others
assign rx_ready = rx_change_done; //follow xapp1248

//others
assign  rx_mode_locked  =  rx_mode_locked_int;  
assign  rx_mode  =        rx_mode_int;   
assign  rx_mode_hd  =     rx_mode_hd_int; 
assign  rx_mode_sd  =     rx_mode_sd_int;   
assign  rx_mode_3g  =     rx_mode_3g_int;   
assign  rx_mode_6g  =     rx_mode_6g_int;   
assign  rx_mode_12g  =    rx_mode_12g_int;   
assign  rx_level_b_3g  =   rx_level_b_3g_int;  
assign  rx_ce_out  =       rx_ce_out_int;  
assign  rx_active_streams = rx_active_streams_int;
assign  rx_eav  =           rx_eav_int; 
assign  rx_sav  =           rx_sav_int; 
assign  rx_trs  =           rx_trs_int; 
assign  rx_t_locked  =      rx_t_locked_int; 
assign  rx_t_family  =      rx_t_family_int; 
assign  rx_t_rate  =        rx_t_rate_int; 
assign  rx_t_scan  =        rx_t_scan_int; 
assign  rx_st352_0  =        rx_st352_0_int; 
assign  rx_st352_0_valid  =  rx_st352_valid_int[0]; 
assign  rx_st352_1  =        rx_st352_1_int; 
assign  rx_st352_1_valid  =  rx_st352_valid_int[1]; 
assign  rx_st352_2  =        rx_st352_2_int; 
assign  rx_st352_2_valid  =  rx_st352_valid_int[2]; 
assign  rx_st352_3  =        rx_st352_3_int; 
assign  rx_st352_3_valid  =  rx_st352_valid_int[3]; 
assign  rx_st352_4  =        rx_st352_4_int; 
assign  rx_st352_4_valid  =  rx_st352_valid_int[4]; 
assign  rx_st352_5  =        rx_st352_5_int; 
assign  rx_st352_5_valid  =  rx_st352_valid_int[5]; 
assign  rx_st352_6  =        rx_st352_6_int; 
assign  rx_st352_6_valid  =   rx_st352_valid_int[6]; 
assign  rx_st352_7  =        rx_st352_7_int; 
assign  rx_st352_7_valid  = rx_st352_valid_int[7]; 
assign  sdi_rx_err[15:0]  =     rx_crc_err_int[15:0];
assign  sdi_rx_edh_out[22:0]  = rx_edh_sts_int;   
assign  sdi_rx_edh_out[47:32]  = rx_edh_errcnt_int;   


//internal assignment
assign ts_det_sts[0] = rx_t_locked_int;
assign ts_det_sts[1] = rx_t_scan_int;
assign ts_det_sts[3:2] = 2'd0;
assign ts_det_sts[7:4] = rx_t_family_int;
assign ts_det_sts[11:8] = rx_t_rate_int;
assign mode_det_sts[2:0] = rx_mode_int;
assign mode_det_sts[3] = rx_mode_locked_int;
assign mode_det_sts[6:4] = rx_active_streams_int;
assign mode_det_sts[7] = rx_level_b_3g_int;


//interrupt detection

always @( posedge rx_clk) begin
	if (rx_rst_int_sys == 1'b1) begin
	    video_locked <= 1'b0;
	    video_locked_d1 <= 1'b0;
	    video_locked_d2 <= 1'b0;
	    video_locked_d3 <= 1'b0;
	    video_lock_int <= 1'b0;
	    video_unlock_int <= 1'b0;
		video_lock_gen_cnt <= 1'b0;
		video_lock_cnt <= 0;
    end else begin
		video_locked_d1 <= video_locked;
		video_locked_d2 <= video_locked_d1;
		video_locked_d3 <= video_locked_d2;

	    video_lock_int <= (~ video_locked_d2) & video_locked_d1;
	    video_unlock_int <= video_locked_d2 & (~ video_locked_d1);
       
		if(rx_ready == 1'b1 && rx_mode_locked_int == 1'b1 && rx_t_locked_int == 1'b1 && rx_eav == 1'b1 && rx_trs == 1'b1 && rx_ce_out_int == 1'b1) begin
			video_lock_gen_cnt <= 1'b1;
	    end else if(rx_ready == 1'b0 || rx_mode_locked_int == 1'b0 || rx_t_locked_int == 1'b0) begin
			video_lock_gen_cnt <= 1'b0;
		end
		if(video_lock_gen_cnt == 1'b1) begin
			if((rx_ce_out_int == 1'b1) && (video_lock_cnt < video_lock_window_sys)) begin
				    video_lock_cnt <= video_lock_cnt + 1;
			end
			if(video_lock_cnt == video_lock_window_sys) begin
				video_locked <= 1'b1;
			end
	    end else begin
		    video_lock_cnt <= 0;
			video_locked <= 1'b0;
		end
	end
end

always @( posedge rx_clk) begin
    if (rx_rst_int_sys == 1'b1) begin
       rx_st352_vld_always_r  <=  1'b0;
    end else if(rcv_st352_always || rx_mode_3g_int || rx_mode_6g_int || rx_mode_12g_int || rx_level_b_3g_int) begin
       rx_st352_vld_always_r  <=  rx_st352_valid_int_r[0];
    end else begin
       rx_st352_vld_always_r  <=  1'b1;
    end
end

always @( posedge rx_clk) begin
    if (rx_rst_int_sys == 1'b1) begin
       rx_st352_valid_int_r   <=  8'd0;
       vid_lock_st352_vld     <=  1'b0;
       vid_lock_st352_vld_r1  <=  1'b0;
       vid_lock_st352_vld_r2  <=  1'b0;
       vid_lock_st352_vld_int <=  1'b0;
       //video_unlock_int       <=  1'b0;
    end else begin
       rx_st352_valid_int_r   <=  rx_st352_valid_int;
       vid_lock_st352_vld     <=  video_locked_d3 && rx_st352_vld_always_r; 
       vid_lock_st352_vld_r1  <=  vid_lock_st352_vld;
       vid_lock_st352_vld_r2  <=  vid_lock_st352_vld_r1;
       vid_lock_st352_vld_int <=  vid_lock_st352_vld_r1 && !vid_lock_st352_vld_r2;
       //video_unlock_int       <=  vid_lock_st352_vld_r2 && !vid_lock_st352_vld_r1;
    end
end

generate
    if (C_AXI4LITE_ENABLE == 1)
    begin : gen_axi4lite_rx 
        // Instantiation of Axi Bus Interface s00_axi
       	v_smpte_uhdsdi_rx_v1_0_0_s00_axi #(
            .C_AXI4LITE_ENABLE(C_AXI4LITE_ENABLE),
		    .C_ADV_FEATURE(C_ADV_FEATURE),  
		    .C_INCLUDE_VID_OVER_AXI(C_INCLUDE_VID_OVER_AXI),  
		    .C_INCLUDE_SDI_BRIDGE(C_INCLUDE_SDI_BRIDGE),  
		    .C_INCLUDE_RX_EDH_PROCESSOR(C_INCLUDE_RX_EDH_PROCESSOR),  
      		.C_S_AXI_DATA_WIDTH(C_AXI_DATA_WIDTH),
      		.C_S_AXI_ADDR_WIDTH(C_AXI_ADDR_WIDTH) )
	    v_smpte_uhdsdi_rx_v1_0_0_s00_axi_inst (
		    .module_ctrl(module_ctrl_axi),
            .sdi_rx_bridge_ctrl(sdi_rx_bridge_ctrl_axi),
            .vid_in_axi4s_ctrl(vid_in_axi4s_ctrl_axi),
			.video_lock_window(video_lock_window_axi),
		    .stat_reset(stat_reset_axi),
		    .rx_edh_errcnt_en(rx_edh_errcnt_en_axi),
		    .rx_st352_valid(rx_st352_valid_axi),
		    .rx_st352_0(rx_st352_0_axi),
		    .rx_st352_1(rx_st352_1_axi),
		    .rx_st352_2(rx_st352_2_axi),
		    .rx_st352_3(rx_st352_3_axi),
		    .rx_st352_4(rx_st352_4_axi),
		    .rx_st352_5(rx_st352_5_axi),
		    .rx_st352_6(rx_st352_6_axi),
		    .rx_st352_7(rx_st352_7_axi),
		    .rx_crc_errcnt({rx_crc_errcnt_reg_axi[15:0],rx_crc_err_axi}),
		    .rx_edh_errcnt(rx_edh_errcnt_axi),
		    .rx_edh_sts(rx_edh_sts_axi),
		    .ts_det_sts(ts_det_sts_axi),
		    .mode_det_sts(mode_det_sts_axi),
			.sts_sb(sts_sb_axi),
            .sdi_rx_bridge_sts(sdi_rx_bridge_sts_axi),
            .vid_in_axi4s_sts(vid_in_axi4s_sts_axi),
                    .rcv_st352_always_axi(rcv_st352_always_axi),
		    .vid_lock_st352_vld_int(vid_lock_st352_vld_int_axi),
		    .video_lock_int(video_lock_int_axi),
		    .video_unlock_int(video_unlock_int_axi),
		    .module_interrupt(interrupt),

       		.axi_aclk(s_axi_aclk),
       		.axi_aresetn(s_axi_aresetn),
       		.axi_awaddr(s_axi_awaddr),
       		.axi_awvalid(s_axi_awvalid),
       		.axi_awready(s_axi_awready),
       		.axi_wdata(s_axi_wdata),
       		.axi_wstrb(s_axi_wstrb),
       		.axi_wvalid(s_axi_wvalid),
       		.axi_wready(s_axi_wready),
       		.axi_bresp(s_axi_bresp),
       		.axi_bvalid(s_axi_bvalid),
       		.axi_bready(s_axi_bready),
       		.axi_araddr(s_axi_araddr),
       		.axi_arvalid(s_axi_arvalid),
       		.axi_arready(s_axi_arready),
       		.axi_rdata(s_axi_rdata),
       		.axi_rresp(s_axi_rresp),
       		.axi_rvalid(s_axi_rvalid),
       		.axi_rready(s_axi_rready)
       	);
        assign  module_enable = module_ctrl_sys[0];    
        assign  output_enable = module_ctrl_sys[1];    
        assign  rx_frame_en = module_ctrl_sys[4];
        assign  rx_mode_detect_en = module_ctrl_sys[5];
        assign  rx_mode_enable = module_ctrl_sys[13:8];
        assign  rx_forced_mode = module_ctrl_sys[18:16];
        assign  rx_edh_errcnt_en = rx_edh_errcnt_en_sys; 
        assign  rx_edh_clr_errcnt = rx_edh_clr_errcnt_sys;
	
    end
    else
    begin : AXI4LITE_DISABLED 
        assign  module_enable = sdi_rx_ctrl[0];    
        assign  output_enable = sdi_rx_ctrl[1];    
        assign  rx_frame_en = sdi_rx_ctrl[4];
        assign  rx_mode_detect_en = sdi_rx_ctrl[5];
        assign  rx_mode_enable = sdi_rx_ctrl[13:8];
        assign  rx_forced_mode = sdi_rx_ctrl[18:16];
        assign  rx_edh_errcnt_en = sdi_rx_ctrl[47:32]; 
        assign  rx_edh_clr_errcnt = sdi_rx_ctrl[6];
	    //sdi_rx_bridge control signals
	assign sdi_rx_bridge_ctrl[0]    = sdi_rx_ctrl[0];
	assign sdi_rx_bridge_ctrl[31:1] = 0;
        assign vid_in_axi4s_ctrl = 0;
        assign video_lock_window_axi = 32'h3000;
		//gt ctrl signals: use axi_clk domain
		//assign gt_rx_rst_pll_and_datapath = sdi_rx_ctrl[24];
		//assign gt_rx_rst_datapath = sdi_rx_ctrl[25];
		//assign gt_rst_all = sdi_rx_ctrl[26];

    end
endgenerate

	//
	// UHD-SDI RX
	//	
	
v_smpte_uhdsdi_rx_v1_0_0_rx #(
    .RXDATA_WIDTH               (C_RX_TDATA_WIDTH),
    .INCLUDE_RX_EDH_PROCESSOR   (C_INCLUDE_RX_EDH_PROCESSOR),
    .NUM_CE                     (C_NUM_RX_CE),
    .ERRCNT_WIDTH               (C_ERRCNT_WIDTH),
    .MAX_ERRS_LOCKED            (C_MAX_ERRS_LOCKED),
    .MAX_ERRS_UNLOCKED          (C_MAX_ERRS_UNLOCKED),
    .EDH_ERR_WIDTH              (C_EDH_ERR_WIDTH))
RX (
    .clk                        (rx_clk),
    .rst                        (rx_rst_int_sys),
    .data_in                    (s_axis_rx_tdata),
    .sd_data_strobe             (s_axis_rx_tvalid),
    .frame_en                   (rx_frame_en),
    .bit_rate                   (rx_bit_rate),
    .mode_enable                (rx_mode_enable),
    .mode_detect_en             (rx_mode_detect_en),
    .forced_mode                (rx_forced_mode),
    .rx_ready                   (rx_ready),
    //.mode_detect_rst            (rx_mode_detect_rst),
    .mode_detect_rst            (rx_rst),
    .mode                       (rx_mode_int),
    .mode_HD                    (rx_mode_hd_int),
    .mode_SD                    (rx_mode_sd_int),
    .mode_3G                    (rx_mode_3g_int),
    .mode_6G                    (rx_mode_6g_int),
    .mode_12G                   (rx_mode_12g_int),
    .mode_locked                (rx_mode_locked_int),
    .t_locked                   (rx_t_locked_int),
    .t_family                   (rx_t_family_int),
    .t_rate                     (rx_t_rate_int),
    .t_scan                     (rx_t_scan_int),
    .level_b_3G                 (rx_level_b_3g_int),
    .ce_out                     (rx_ce_out_int),
    .nsp                        (),
    .active_streams             (rx_active_streams_int),
    .ln_ds1                     (rx_ln_ds1),
    .ln_ds2                     (rx_ln_ds2),
    .ln_ds3                     (rx_ln_ds3),
    .ln_ds4                     (rx_ln_ds4),
    .ln_ds5                     (rx_ln_ds5),
    .ln_ds6                     (rx_ln_ds6),
    .ln_ds7                     (rx_ln_ds7),
    .ln_ds8                     (rx_ln_ds8),
    .ln_ds9                     (rx_ln_ds9),
    .ln_ds10                    (rx_ln_ds10),
    .ln_ds11                    (rx_ln_ds11),
    .ln_ds12                    (rx_ln_ds12),
    .ln_ds13                    (rx_ln_ds13),
    .ln_ds14                    (rx_ln_ds14),
    .ln_ds15                    (rx_ln_ds15),
    .ln_ds16                    (rx_ln_ds16),
    .vpid_0                     (rx_st352_0_int),
    .vpid_0_valid               (rx_st352_valid_int[0]),
    .vpid_1                     (rx_st352_1_int),
    .vpid_1_valid               (rx_st352_valid_int[1]),
    .vpid_2                     (rx_st352_2_int),
    .vpid_2_valid               (rx_st352_valid_int[2]),
    .vpid_3                     (rx_st352_3_int),
    .vpid_3_valid               (rx_st352_valid_int[3]),
    .vpid_4                     (rx_st352_4_int),
    .vpid_4_valid               (rx_st352_valid_int[4]),
    .vpid_5                     (rx_st352_5_int),
    .vpid_5_valid               (rx_st352_valid_int[5]),
    .vpid_6                     (rx_st352_6_int),
    .vpid_6_valid               (rx_st352_valid_int[6]),
    .vpid_7                     (rx_st352_7_int),
    .vpid_7_valid               (rx_st352_valid_int[7]),
    .crc_err_ds1                (rx_crc_err_int[0]),
    .crc_err_ds2                (rx_crc_err_int[1]),
    .crc_err_ds3                (rx_crc_err_int[2]),
    .crc_err_ds4                (rx_crc_err_int[3]),
    .crc_err_ds5                (rx_crc_err_int[4]),
    .crc_err_ds6                (rx_crc_err_int[5]),
    .crc_err_ds7                (rx_crc_err_int[6]),
    .crc_err_ds8                (rx_crc_err_int[7]),
    .crc_err_ds9                (rx_crc_err_int[8]),
    .crc_err_ds10               (rx_crc_err_int[9]),
    .crc_err_ds11               (rx_crc_err_int[10]),
    .crc_err_ds12               (rx_crc_err_int[11]),
    .crc_err_ds13               (rx_crc_err_int[12]),
    .crc_err_ds14               (rx_crc_err_int[13]),
    .crc_err_ds15               (rx_crc_err_int[14]),
    .crc_err_ds16               (rx_crc_err_int[15]),
    .ds1                        (rx_ds1_t),
    .ds2                        (rx_ds2_t),
    .ds3                        (rx_ds3_t),
    .ds4                        (rx_ds4_t),
    .ds5                        (rx_ds5_t),
    .ds6                        (rx_ds6_t),
    .ds7                        (rx_ds7_t),
    .ds8                        (rx_ds8_t),
    .ds9                        (rx_ds9_t),
    .ds10                       (rx_ds10_t),
    .ds11                       (rx_ds11_t),
    .ds12                       (rx_ds12_t),
    .ds13                       (rx_ds13_t),
    .ds14                       (rx_ds14_t),
    .ds15                       (rx_ds15_t),
    .ds16                       (rx_ds16_t),
    .eav                        (rx_eav_int),
    .sav                        (rx_sav_int),
    .trs                        (rx_trs_int),
    .edh_errcnt_en              (rx_edh_errcnt_en),
    .edh_clr_errcnt             (rx_edh_clr_errcnt),
    .edh_ap                     (rx_edh_sts_int[0]),
    .edh_ff                     (rx_edh_sts_int[1]),
    .edh_anc                    (rx_edh_sts_int[2]),
    .edh_ap_flags               (rx_edh_sts_int[8:4]),
    .edh_ff_flags               (rx_edh_sts_int[13:9]),
    .edh_anc_flags              (rx_edh_sts_int[18:14]),
    .edh_packet_flags           (rx_edh_sts_int[22:19]),
    .edh_errcnt                 (rx_edh_errcnt_int[15:0]));
	// User logic ends
	
	//synchronization
	//
assign rx_edh_sts_int[3] = 1'd0;
//sync to axis_clk domain: level signals
cross_clk_reg #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(1),
    .C_REGISTER_INPUT(0)
) rx_fabric_rst_sync2axis_clk(
	.in_clk   (1'b0), 
	.out_clk  (axis_clk),
	.data_in  (rx_fabric_rst),
	.data_out (rx_fabric_rst_axis));
cross_clk_reg #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(1),
    .C_REGISTER_INPUT(0)
) vid_in_axi4s_module_enable_sync2axis_clk(
	.in_clk   (1'b0), 
	.out_clk  (axis_clk),
	.data_in  (vid_in_axi4s_mod_en_axi_r),
	.data_out (vid_in_axi4s_module_enable_axis));

/*        
cross_clk_reg #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(1),
    .C_REGISTER_INPUT(0)
) vid_in_axi4s_axis_enable_sync2axis_clk(
	.in_clk   (1'b0), 
	.out_clk  (rx_clk),
	.data_in  (vid_in_axi4s_axis_enable_axi),
	.data_out (vid_in_axi4s_axis_enable));
	
	//sync to rx_clk domain: level signals
*/

cross_clk_reg #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(1),
    .C_REGISTER_INPUT(0)
) vid_in_axi4s_module_enable_sync2sys (
	.in_clk   (1'b0), //dont know clk source
	.out_clk  (rx_clk),
	.data_in  (vid_in_axi4s_mod_en_axi_nxt),
	.data_out (vid_in_axi4s_module_enable_sys));
	
cross_clk_reg #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(1),
    .C_REGISTER_INPUT(0)
) rx_rst_int_sync2sys (
	.in_clk   (1'b0), //dont know clk source
	.out_clk  (rx_clk),
	.data_in  (rx_rst_int),
	.data_out (rx_rst_int_sys));


cross_clk_reg #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(32),
    .C_REGISTER_INPUT(0)
) sts_sb_sync2sys (
	.in_clk   (1'b0), //dont know clk source
	.out_clk  (rx_clk),
	.data_in  (s_axis_sts_sb_rx_tdata),
	.data_out (sts_sb_sys));
	
generate
    if (C_AXI4LITE_ENABLE == 1)
    begin : gen_axi4lite_sync
	//sync to axi_aclk domain: level signals
cross_clk_reg #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(1),
    .C_REGISTER_INPUT(0)
) vid_in_axi4s_overflow_sync2axi (
	.in_clk   (1'b0), //dont know clk source
	.out_clk  (s_axi_aclk),
	.data_in  (vid_in_axi4s_overflow),
	.data_out (vid_in_axi4s_overflow_axi));


cross_clk_reg #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(1),
    .C_REGISTER_INPUT(0)
) vid_in_axi4s_underflow_sync2axi (
	.in_clk   (1'b0), //dont know clk source
	.out_clk  (s_axi_aclk),
	.data_in  (vid_in_axi4s_underflow),
	.data_out (vid_in_axi4s_underflow_axi));

cross_clk_reg #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(32),
    .C_REGISTER_INPUT(0)
) sts_sb_sync2axi (
	.in_clk   (1'b0), //dont know clk source
	.out_clk  (s_axi_aclk),
	.data_in  (s_axis_sts_sb_rx_tdata),
	.data_out (sts_sb_axi));

cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(32)
) sdi_rx_bridge_sts_sync2axi (
	.in_clk   (rx_clk), 
	.out_clk  (s_axi_aclk),
	.data_in  (sdi_rx_bridge_sts),
	.data_out (sdi_rx_bridge_sts_axi));
	
cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(8)
) rx_st352_valid_sys2axi (
	.in_clk  (rx_clk),
	.out_clk   (s_axi_aclk),
	.data_in  (rx_st352_valid_int_r/*rx_st352_valid_int*/),
	.data_out (rx_st352_valid_axi));

cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(32)
) rx_st352_0_sys2axi (
	.in_clk  (rx_clk),
	.out_clk   (s_axi_aclk),
	.data_in  (rx_st352_0_int),
	.data_out (rx_st352_0_axi));

cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(32)
) rx_st352_1_sys2axi (
	.in_clk  (rx_clk),
	.out_clk   (s_axi_aclk),
	.data_in  (rx_st352_1_int),
	.data_out (rx_st352_1_axi));
	
cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(32)
) rx_st352_2_sys2axi (
	.in_clk  (rx_clk),
	.out_clk   (s_axi_aclk),
	.data_in  (rx_st352_2_int),
	.data_out (rx_st352_2_axi));

cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(32)
) rx_st352_3_sys2axi (
	.in_clk  (rx_clk),
	.out_clk   (s_axi_aclk),
	.data_in  (rx_st352_3_int),
	.data_out (rx_st352_3_axi));

cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(32)
) rx_st352_4_sys2axi (
	.in_clk  (rx_clk),
	.out_clk   (s_axi_aclk),
	.data_in  (rx_st352_4_int),
	.data_out (rx_st352_4_axi));

cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(32)
) rx_st352_5_sys2axi (
	.in_clk  (rx_clk),
	.out_clk   (s_axi_aclk),
	.data_in  (rx_st352_5_int),
	.data_out (rx_st352_5_axi));

cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(32)
) rx_st352_6_sys2axi (
	.in_clk  (rx_clk),
	.out_clk   (s_axi_aclk),
	.data_in  (rx_st352_6_int),
	.data_out (rx_st352_6_axi));

cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(32)
) rx_st352_7_sys2axi (
	.in_clk  (rx_clk),
	.out_clk   (s_axi_aclk),
	.data_in  (rx_st352_7_int),
	.data_out (rx_st352_7_axi));

//cross_clk_bus #( 
//    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
//    .C_DATA_WIDTH(16)
//) rx_crc_err_sys2axi (
//	.in_clk  (rx_clk),
//	.out_clk   (s_axi_aclk),
//	.data_in  (rx_crc_err_int),
//	.data_out (rx_crc_err_axi));

// Synchronize the CRC_ERR signal to the AXI clock
always @ (posedge s_axi_aclk)
begin
    rx_crc_err_int_sync1_cdc_to <= rx_crc_err_int;
    rx_crc_err_int_sync2_reg    <= rx_crc_err_int_sync1_cdc_to;
    rx_crc_err_int_last_reg     <= rx_crc_err_int_sync2_reg;
end

assign rx_crc_err_axi  = rx_crc_err_int_last_reg;

cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(16)
) rx_edh_errcnt_sys2axi (
	.in_clk  (rx_clk),
	.out_clk   (s_axi_aclk),
	.data_in  (rx_edh_errcnt_int),
	.data_out (rx_edh_errcnt_axi));

cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(23)
) rx_edh_sts_sys2axi (
	.in_clk  (rx_clk),
	.out_clk   (s_axi_aclk),
	.data_in  (rx_edh_sts_int),
	.data_out (rx_edh_sts_axi));

cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(12)
) ts_det_sts_sys2axi (
	.in_clk  (rx_clk),
	.out_clk   (s_axi_aclk),
	.data_in  (ts_det_sts),
	.data_out (ts_det_sts_axi));

cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(8)
) mode_det_sts_sys2axi (
	.in_clk  (rx_clk),
	.out_clk   (s_axi_aclk),
	.data_in  (mode_det_sts),
	.data_out (mode_det_sts_axi));


	//sync to axi_clk domain: pulse signals
map_pulse #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS)
) video_lock_int_sys2axi (
	.clk_i    (rx_clk),
	.clk_o    (s_axi_aclk),
	.pls_i  (video_lock_int),
	.pls_o (video_lock_int_axi));

map_pulse #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS)
) video_unlock_int_sys2axi (
	.clk_i    (rx_clk),
	.clk_o    (s_axi_aclk),
	.pls_i  (video_unlock_int),
	.pls_o (video_unlock_int_axi));

map_pulse #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS)
) vid_lock_st352_vld_int_sys2axi (
	.clk_i    (rx_clk),
	.clk_o    (s_axi_aclk),
	.pls_i  (vid_lock_st352_vld_int),
	.pls_o (vid_lock_st352_vld_int_axi));

cross_clk_reg #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(1),
    .C_REGISTER_INPUT(0)
) rcv_st352_always_axi2rxclk (
	.in_clk   (s_axi_aclk),
	.out_clk  (rx_clk),
	.data_in  (rcv_st352_always_axi),
	.data_out (rcv_st352_always));

	//sync from axi_aclk to sys_clk domain: level signals
cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(32)
) module_ctrl_axi2sys (
	.in_clk   (s_axi_aclk),
	.out_clk  (rx_clk),
	.data_in  (module_ctrl_axi),
	.data_out (module_ctrl_sys));

cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(32)
) sdi_rx_bridge_ctrl_sync2sys (
	.in_clk   (s_axi_aclk),
	.out_clk  (rx_clk),
	.data_in  (sdi_rx_bridge_ctrl_axi),
	.data_out (sdi_rx_bridge_ctrl));

cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(32)
) video_lock_window_sync2sys (
	.in_clk   (s_axi_aclk),
	.out_clk  (rx_clk),
	.data_in  (video_lock_window_axi),
	.data_out (video_lock_window_sys));

cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(16)
) rx_edh_errcnt_en_axi2sys (
	.in_clk   (s_axi_aclk),
	.out_clk  (rx_clk),
	.data_in  (rx_edh_errcnt_en_axi),
	.data_out (rx_edh_errcnt_en_sys));
	//sync to sys_clk domain: pulse signals

map_pulse #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS)
) rx_edh_clr_errcnt_axi2sys (
	.clk_o    (rx_clk),
	.clk_i    (s_axi_aclk),
	.pls_i  (stat_reset_axi[1]),
	.pls_o (rx_edh_clr_errcnt_sys));
   end

//rx_crc_errcnt register update
assign rx_active_streams_axi = mode_det_sts_axi[6:4];

always @( posedge s_axi_aclk) begin
	if (s_axi_aresetn == 1'b0 || stat_reset_axi[0] == 1'b1) begin
	   rx_crc_errcnt_axi <= 0;
	   rx_crc_errcnt_reg_axi <= 0;
	   rx_crc_err_axi_d1 <= 0;
	end else begin
	   rx_crc_err_axi_d1 <= rx_crc_err_axi;
	   //update error status to ds0 and ds1
	   if(rx_crc_err_axi_d1[0] == 1'b0 && rx_crc_err_axi[0] == 1'b1) begin 
		      rx_crc_errcnt_reg_axi[16+0] <= 1'b1;
	   end
	   if(rx_crc_err_axi_d1[1] == 1'b0 && rx_crc_err_axi[1] == 1'b1) begin 
		      rx_crc_errcnt_reg_axi[16+1] <= 1'b1;
	   end
	   //update increase rx_crc_errcnt whenever any ds got crc  err 
	   rx_crc_errcnt_reg_axi[15:0] <= rx_crc_errcnt_axi;

	   if (rx_active_streams_axi == 3'b001) begin //2 active streams
		   if((|rx_crc_err_axi_d1[1:0]) == 1'b0 && (|rx_crc_err_axi[1:0]) == 1'b1) begin 
			  rx_crc_errcnt_axi <= rx_crc_errcnt_axi + 1;
		   end
	   end else if (rx_active_streams_axi == 3'b010) begin //4 active streams
		   if((|rx_crc_err_axi_d1[3:0]) == 1'b0 && (|rx_crc_err_axi[3:0]) == 1'b1) begin 
			  rx_crc_errcnt_axi <= rx_crc_errcnt_axi + 1;
		   end
	       //update error status to ds2 and ds3
	       if(rx_crc_err_axi_d1[2] == 1'b0 && rx_crc_err_axi[2] == 1'b1) begin 
		      rx_crc_errcnt_reg_axi[16+2] <= 1'b1;
	       end
	       if(rx_crc_err_axi_d1[3] == 1'b0 && rx_crc_err_axi[3] == 1'b1) begin 
		      rx_crc_errcnt_reg_axi[16+3] <= 1'b1;
	       end
	   end else if (rx_active_streams_axi == 3'b011) begin //8 active streams
		   if((|rx_crc_err_axi_d1[7:0]) == 1'b0 && (|rx_crc_err_axi[7:0]) == 1'b1) begin 
			  rx_crc_errcnt_axi <= rx_crc_errcnt_axi + 1;
		   end
	       //update error status to ds2 ~ ds5
	       if(rx_crc_err_axi_d1[2] == 1'b0 && rx_crc_err_axi[2] == 1'b1) begin 
		      rx_crc_errcnt_reg_axi[16+2] <= 1'b1;
	       end
	       if(rx_crc_err_axi_d1[3] == 1'b0 && rx_crc_err_axi[3] == 1'b1) begin 
		      rx_crc_errcnt_reg_axi[16+3] <= 1'b1;
	       end
	       if(rx_crc_err_axi_d1[4] == 1'b0 && rx_crc_err_axi[4] == 1'b1) begin 
		      rx_crc_errcnt_reg_axi[16+4] <= 1'b1;
	       end
	       if(rx_crc_err_axi_d1[5] == 1'b0 && rx_crc_err_axi[5] == 1'b1) begin 
		      rx_crc_errcnt_reg_axi[16+5] <= 1'b1;
	       end
       end else begin //16 active streams
		   if((|rx_crc_err_axi_d1[7:0]) == 1'b0 && (|rx_crc_err_axi[7:0]) == 1'b1) begin 
			  rx_crc_errcnt_axi <= rx_crc_errcnt_axi + 1;
		   end
	       //update error status to ds2 ~ ds7
	       if(rx_crc_err_axi_d1[2] == 1'b0 && rx_crc_err_axi[2] == 1'b1) begin 
		      rx_crc_errcnt_reg_axi[16+2] <= 1'b1;
	       end
	       if(rx_crc_err_axi_d1[3] == 1'b0 && rx_crc_err_axi[3] == 1'b1) begin 
		      rx_crc_errcnt_reg_axi[16+3] <= 1'b1;
	       end
	       if(rx_crc_err_axi_d1[4] == 1'b0 && rx_crc_err_axi[4] == 1'b1) begin 
		      rx_crc_errcnt_reg_axi[16+4] <= 1'b1;
	       end
	       if(rx_crc_err_axi_d1[5] == 1'b0 && rx_crc_err_axi[5] == 1'b1) begin 
		      rx_crc_errcnt_reg_axi[16+5] <= 1'b1;
	       end
	       if(rx_crc_err_axi_d1[6] == 1'b0 && rx_crc_err_axi[6] == 1'b1) begin 
		      rx_crc_errcnt_reg_axi[16+6] <= 1'b1;
	       end
	       if(rx_crc_err_axi_d1[7] == 1'b0 && rx_crc_err_axi[7] == 1'b1) begin 
		      rx_crc_errcnt_reg_axi[16+7] <= 1'b1;
	       end
       end

	end
end


endgenerate


	endmodule       

