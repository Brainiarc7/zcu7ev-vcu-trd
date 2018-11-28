
`timescale 1 ns / 1 ps

	module v_smpte_uhdsdi_tx_v1_0_0 #
	(
		// Users to add parameters here
		parameter C_AXI4LITE_ENABLE              = 1, 
		parameter C_ADV_FEATURE                  = 0,
                parameter C_INCLUDE_VID_OVER_AXI          = 1,
                parameter C_INCLUDE_SDI_BRIDGE            = 1,
		parameter C_INCLUDE_TX_EDH_PROCESSOR     = 1,
		parameter C_TX_TDATA_WIDTH               = 40,				
		parameter C_TX_TUSER_WIDTH               = 32,			
		parameter C_NUM_SYNC_REGS                = 3,			
		parameter C_LINE_RATE                    = "12G_SDI_8DS",			
		parameter integer C_AXI_DATA_WIDTH = 32,
		parameter integer C_AXI_ADDR_WIDTH = 9
	)
	(
		// Users to add ports here
		input  wire                     tx_clk,                 // txusrclk
		input  wire                     tx_rst,                 // sync reset input
		input  wire                     axis_clk,               // axi4s_vid_out axis clk 
		input  wire                     axis_rstn,               // axi4s_vid_out axis resetn 
		//control input ports
		input  wire [31:0]              sdi_tx_ctrl,            // sdi_tx control signals
		//Native SDI Interface 2.0 (subset): slave
		input  wire                     tx_ce,                  // clock enable
		input  wire                     tx_sd_ce,               // SD-SDI clock enable, must be High in all other modes
		//input  wire                     tx_edh_ce,              // EDH clock enable, recommended Low in all modes except SD-SDI
		input  wire [10:0]              tx_line_ch0,            // current line number for ds1 & ds2
		input  wire [10:0]              tx_line_ch1,            // current line number for ds3 & ds4
		input  wire [10:0]              tx_line_ch2,            // current line number for ds5 & ds6 
		input  wire [10:0]              tx_line_ch3,            // current line number for ds7 & ds8
		input  wire [10:0]              tx_line_ch4,            // current line number for ds9 & ds10
		input  wire [10:0]              tx_line_ch5,            // current line number for ds11 & ds12
		input  wire [10:0]              tx_line_ch6,            // current line number for ds13 & ds14
		input  wire [10:0]              tx_line_ch7,            // current line number for ds15 & ds16
		input  wire [10:0]              tx_st352_line_f1,       // line number in field 1 to insert ST 352
		input  wire [10:0]              tx_st352_line_f2,       // line number in field 2 to insert ST 352
		input  wire [31:0]              tx_st352_data_ch0,      // ST352 data bytes for ds1 {byte4, byte3, byte2, byte1} 
		input  wire [31:0]              tx_st352_data_ch1,      // ST352 data bytes for ds3 (and ds2 in 3GA mode) {byte4, byte3, byte2, byte1} 
		input  wire [31:0]              tx_st352_data_ch2,      // ST352 data bytes for ds5 {byte4, byte3, byte2, byte1} 
		input  wire [31:0]              tx_st352_data_ch3,      // ST352 data bytes for ds7 {byte4, byte3, byte2, byte1} 
		input  wire [31:0]              tx_st352_data_ch4,      // ST352 data bytes for ds9 {byte4, byte3, byte2, byte1} 
		input  wire [31:0]              tx_st352_data_ch5,      // ST352 data bytes for ds11 {byte4, byte3, byte2, byte1} 
		input  wire [31:0]              tx_st352_data_ch6,      // ST352 data bytes for ds13 {byte4, byte3, byte2, byte1} 
		input  wire [31:0]              tx_st352_data_ch7,      // ST352 data bytes for ds15 {byte4, byte3, byte2, byte1} 
		input  wire [9:0]               tx_ds1_in,              // data stream 1 (Y) in -- only active ds in SD, Y for HD & 3GA, AY for 3GB
		input  wire [9:0]               tx_ds2_in,              // data stream 2 (C) in -- C for HD & 3GA, AC for 3GB
		input  wire [9:0]               tx_ds3_in,              // data stream 3 (Y) in -- BY for 3GB
		input  wire [9:0]               tx_ds4_in,              // data stream 4 (C) in -- BC for 3GB
		input  wire [9:0]               tx_ds5_in,              // data stream 5 (Y) in
		input  wire [9:0]               tx_ds6_in,              // data stream 6 (C) in
		input  wire [9:0]               tx_ds7_in,              // data stream 7 (Y) in
		input  wire [9:0]               tx_ds8_in,              // data stream 8 (C) in
		input  wire [9:0]               tx_ds9_in,              // data stream 9 (Y) in
		input  wire [9:0]               tx_ds10_in,             // data stream 10 (C) in
		input  wire [9:0]               tx_ds11_in,             // data stream 11 (Y) in
		input  wire [9:0]               tx_ds12_in,             // data stream 12 (C) in
		input  wire [9:0]               tx_ds13_in,             // data stream 13 (Y) in
		input  wire [9:0]               tx_ds14_in,             // data stream 14 (C) in
		input  wire [9:0]               tx_ds15_in,             // data stream 15 (Y) in
		input  wire [9:0]               tx_ds16_in,             // data stream 16 (C) in
		output wire [9:0]               tx_ds1_st352_out,       // data stream 1 after ST352 insertion
		output wire [9:0]               tx_ds2_st352_out,       // data stream 2 after ST352 insertion
		output wire [9:0]               tx_ds3_st352_out,       // data stream 3 after ST352 insertion
		output wire [9:0]               tx_ds4_st352_out,       // data stream 4 after ST352 insertion
		output wire [9:0]               tx_ds5_st352_out,       // data stream 5 after ST352 insertion
		output wire [9:0]               tx_ds6_st352_out,       // data stream 6 after ST352 insertion
		output wire [9:0]               tx_ds7_st352_out,       // data stream 7 after ST352 insertion
		output wire [9:0]               tx_ds8_st352_out,       // data stream 8 after ST352 insertion
		output wire [9:0]               tx_ds9_st352_out,       // data stream 9 after ST352 insertion
		output wire [9:0]               tx_ds10_st352_out,      // data stream 10 after ST352 insertion
		output wire [9:0]               tx_ds11_st352_out,      // data stream 11 after ST352 insertion
		output wire [9:0]               tx_ds12_st352_out,      // data stream 12 after ST352 insertion
		output wire [9:0]               tx_ds13_st352_out,      // data stream 13 after ST352 insertion
		output wire [9:0]               tx_ds14_st352_out,      // data stream 14 after ST352 insertion
		output wire [9:0]               tx_ds15_st352_out,      // data stream 15 after ST352 insertion
		output wire [9:0]               tx_ds16_st352_out,      // data stream 16 after ST352 insertion
		input  wire [9:0]               tx_ds1_anc_in,          // data stream 1 after ANC insertion input
		input  wire [9:0]               tx_ds2_anc_in,          // data stream 2 after ANC insertion input
		input  wire [9:0]               tx_ds3_anc_in,          // data stream 3 after ANC section input
		input  wire [9:0]               tx_ds4_anc_in,          // data stream 4 after ANC section input
		input  wire [9:0]               tx_ds5_anc_in,          // data stream 5 after ANC section input
		input  wire [9:0]               tx_ds6_anc_in,          // data stream 6 after ANC section input
		input  wire [9:0]               tx_ds7_anc_in,          // data stream 7 after ANC section input
		input  wire [9:0]               tx_ds8_anc_in,          // data stream 8 after ANC section input
		input  wire [9:0]               tx_ds9_anc_in,          // data stream 9 after ANC section input
		input  wire [9:0]               tx_ds10_anc_in,         // data stream 10 after ANC section input
		input  wire [9:0]               tx_ds11_anc_in,         // data stream 11 after ANC section input
		input  wire [9:0]               tx_ds12_anc_in,         // data stream 12 after ANC section input
		input  wire [9:0]               tx_ds13_anc_in,         // data stream 13 after ANC section input
		input  wire [9:0]               tx_ds14_anc_in,         // data stream 14 after ANC section input
		input  wire [9:0]               tx_ds15_anc_in,         // data stream 15 after ANC section input
		input  wire [9:0]               tx_ds16_anc_in,         // data stream 16 after ANC section input
		output wire [31:0]              sdi_tx_anc_ctrl_out,    // ANC section control output
		//output ports
		output wire [31:0]                sdi_tx_err,              
		//m_axis interface to GT
		input  wire                       m_axis_tx_tready,  //Currently dont support push back: make sure tready never go down once started data stream in system
		output wire                       m_axis_tx_tvalid, 
		output wire [C_TX_TDATA_WIDTH-1:0]  m_axis_tx_tdata,    
		output wire [C_TX_TUSER_WIDTH-1:0]  m_axis_tx_tuser,   
		//control siadband to GT
		input  wire                       m_axis_ctrl_sb_tx_tready,
		output wire                       m_axis_ctrl_sb_tx_tvalid, 
		output wire [31:0]                m_axis_ctrl_sb_tx_tdata,    
		//status siadband from GT
		output wire                       s_axis_sts_sb_tx_tready,
		input wire                        s_axis_sts_sb_tx_tvalid, 
		input wire [31:0]                 s_axis_sts_sb_tx_tdata,    
		//control signal to axi4s_vid_out bridge
		output reg axi4s_vid_out_vid_rst,  //reset in tx_clk domain: ((!module_enable) OR tx_rst)
		output reg axi4s_vid_out_vid_rstn,  //inverted axi4s_vid_out_vid_rst
		output reg axi4s_vid_out_axis_rstn,  //reset in axis clock domain: module_enable AND axis_rstn
		//status signal from axi4s_vid_out
		input wire axi4s_vid_out_locked,
		input wire axi4s_vid_out_overflow,
		input wire axi4s_vid_out_underflow,
		input wire [31:0] axi4s_vid_out_status,
		//control signal to sdi_tx_bridge
		output wire [31:0] sdi_tx_bridge_ctrl,
		//status signal from sdi_tx_bridge
		input wire [31:0] sdi_tx_bridge_sts,
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
	
localparam MODE_HD        = 3'b000;
localparam MODE_SD        = 3'b001;
localparam MODE_3G        = 3'b010;
localparam MODE_6G        = 3'b100;
localparam MODE_12G       = 3'b101;

    //sdi_tx_ctrl	
	wire      		module_enable;                   
	wire      		output_enable;                   
	wire      		tx_m;                   // 0 = tx_rate: integer frame rate; 1 = fractional frame rate; 
	wire [2:0]		tx_mode;                // SDI mode
	wire      		tx_insert_crc;          // 1 = insert CRC for HD and 3G
	wire      		tx_insert_ln;           // 1 = insert LN for HD and 3G
	wire      		tx_insert_st352;        // 1 = insert st352 PID packets
	wire      		tx_st352_f2_en; 
	wire      		tx_overwrite_st352;     // 1 = overwrite existing ST 352 packets
	wire      		tx_insert_edh;          // 1 = generate & insert EDH packets in SD-SDI mode
	wire [2:0]		tx_mux_pattern;         // specifies the multiplex interleave pattern of data streams
	wire      		tx_insert_sync_bit;     // 1 enables sync bit insertion
	wire      		tx_sd_bitrep_bypass;    // 1 bypasses the SD-SDI 11X bit replicator
	wire      		tx_use_anc_in;    
	//others
	wire [10:0]              tx_st352_line_f1_int;
	wire [10:0]              tx_st352_line_f2_int;
	wire [31:0]              tx_st352_data_ch0_int;
	wire [31:0]              tx_st352_data_ch1_int;
	wire [31:0]              tx_st352_data_ch2_int;
	wire [31:0]              tx_st352_data_ch3_int;
	wire [31:0]              tx_st352_data_ch4_int;
	wire [31:0]              tx_st352_data_ch5_int;
	wire [31:0]              tx_st352_data_ch6_int;
	wire [31:0]              tx_st352_data_ch7_int;
	
	wire [39:0]     txdata;

    //axi_aclk domain signals
	wire axi4s_vid_out_locked_axi;
	wire axi4s_vid_out_overflow_axi;
	wire axi4s_vid_out_underflow_axi;
	wire [31:0] axi4s_vid_out_sts1_axi;
	wire [31:0] axi4s_vid_out_sts2_axi;
	wire [31:0] module_ctrl_axi;
	wire [31:0] gt_ctrl_axi;
	wire [31:0] sdi_tx_bridge_ctrl_axi;
	wire [31:0] axi4s_vid_out_ctrl_axi;
	wire  axi4s_vid_out_module_enable_axis;
	wire  axi4s_vid_out_module_enable_sys;
	wire [31:0] stat_reset_axi;
	wire [10:0] tx_st352_line_f1_axi;
	wire [10:0] tx_st352_line_f2_axi;
	wire [31:0] tx_st352_data_ch0_axi;
	wire [31:0] tx_st352_data_ch1_axi;
	wire [31:0] tx_st352_data_ch2_axi;
	wire [31:0] tx_st352_data_ch3_axi;
	wire [31:0] tx_st352_data_ch4_axi;
	wire [31:0] tx_st352_data_ch5_axi;
	wire [31:0] tx_st352_data_ch6_axi;
	wire [31:0] tx_st352_data_ch7_axi;
    wire tx_ce_align_err_axi;	
	//synced to tx_clk domain
	wire [31:0] module_ctrl_sys;
	wire  tx_err_reset_sys; //todo: use this to reset tx_ce_align_err signal in design 
	wire [10:0] tx_st352_line_f1_sys;
	wire [10:0] tx_st352_line_f2_sys;
	wire [31:0] tx_st352_data_ch0_sys;
	wire [31:0] tx_st352_data_ch1_sys;
	wire [31:0] tx_st352_data_ch2_sys;
	wire [31:0] tx_st352_data_ch3_sys;
	wire [31:0] tx_st352_data_ch4_sys;
	wire [31:0] tx_st352_data_ch5_sys;
	wire [31:0] tx_st352_data_ch6_sys;
	wire [31:0] tx_st352_data_ch7_sys;

    wire tx_ce_align_err;	
    wire [31:0] sts_sb_axi;
    wire [31:0] sts_sb_sys;
    wire [31:0] sdi_tx_bridge_sts_axi;
	wire tx_fabric_rst;
	wire tx_fabric_rst_axis;
	reg tx_rst_int;
	wire tx_rst_int_sys;
    wire gt_tx_rst_pll_and_datapath;
    wire gt_tx_rst_datapath;
    wire gt_rst_all;
	reg tx_edh_ce;
	reg axi4s_vid_out_axis_rstn_d1;
	reg axi4s_vid_out_axis_rstn_d2;
	reg axi4s_vid_out_vid_rst_d1;
	reg axi4s_vid_out_vid_rst_d2;
	reg axi4s_vid_out_vid_rstn_d1;
	reg axi4s_vid_out_vid_rstn_d2;
	wire gttx_resetdone;
	wire gttx_resetdone_axi;
	reg gttx_resetdone_axi_d1;
	reg gttx_resetdone_axi_d2;
	reg gttx_resetdone_int;
	reg axi4s_vid_out_locked_axi_r1;
	reg axi4s_vid_out_locked_axi_r2;
        reg axi4s_vid_out_locked_int;
	reg axi4s_vid_out_overflow_axi_r1;
	reg axi4s_vid_out_overflow_axi_r2;
        reg axi4s_vid_out_overflow_int;
	reg axi4s_vid_out_underflow_axi_r1;
	reg axi4s_vid_out_underflow_axi_r2;
        reg axi4s_vid_out_underflow_int;
	reg tx_ce_align_err_axi_r1;
	reg tx_ce_align_err_axi_r2;
        reg tx_ce_align_err_int;
        reg axi4s_vid_out_module_en_axi;
        reg axi4s_vid_out_module_en_t_axi;
(* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg     tx_fabric_rst_sync1_cdc_to_reg       = 1'b0;
(* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg     tx_fabric_rst_sync2_reg              = 1'b0;
(* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg     tx_fabric_rst_last_reg               = 1'b0;
(* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg     axi4s_vid_out_module_en_sync1_cdc_to_reg       = 1'b0;
(* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg     axi4s_vid_out_module_en_sync2_reg              = 1'b0;
(* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg     axi4s_vid_out_module_en_last_reg               = 1'b0;
(* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg     axi4s_vid_out_module_en_t_sync1_cdc_to_reg       = 1'b0;
(* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg     axi4s_vid_out_module_en_t_sync2_reg              = 1'b0;
(* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg     axi4s_vid_out_module_en_t_last_reg               = 1'b0;

//assign input/output
//master axis
assign m_axis_tx_tvalid= 1'b1;
//ctrl sideband 
assign m_axis_ctrl_sb_tx_tvalid = 1'b1;
assign m_axis_ctrl_sb_tx_tdata[2:0] = tx_mode;
assign m_axis_ctrl_sb_tx_tdata[3]   = tx_m;
assign m_axis_ctrl_sb_tx_tdata[31:4] = 0;
//status sideband 
assign s_axis_sts_sb_tx_tready = 1'b1; //no push back
assign gttx_resetdone = s_axis_sts_sb_tx_tdata[2];//sts_sb_sys[2];
assign tx_fabric_rst  = s_axis_sts_sb_tx_tdata[8];//sts_sb_sys[8];

//others
assign sdi_tx_err[31:1] = 31'b0;

generate if (C_ADV_FEATURE == 1) begin : gen_tx_anc_ctrl
  assign sdi_tx_anc_ctrl_out[0]      =  tx_sd_ce;  
  assign sdi_tx_anc_ctrl_out[1]      =  tx_ce;  
  assign sdi_tx_anc_ctrl_out[12:2]   =  tx_line_ch0;  
  assign sdi_tx_anc_ctrl_out[13]     =  tx_rst_int_sys;  
  assign sdi_tx_anc_ctrl_out[31:14]  =  0;  
end
else begin
  assign sdi_tx_anc_ctrl_out         =  0; 
end
endgenerate

//combine fabric_rst from uhdsdi_ctrl(compact_gt) and module_disable with tx_rst to reset tx core (xapp1248);
always @( posedge tx_clk) begin
   tx_rst_int <= tx_rst | tx_fabric_rst | (~module_enable); 
end

/////////////////////bridge reset generate/////////begin
always @( posedge tx_clk) begin
	axi4s_vid_out_vid_rst_d1 <= (! axi4s_vid_out_module_enable_sys) | tx_rst | tx_fabric_rst;
    axi4s_vid_out_vid_rst_d2 <= axi4s_vid_out_vid_rst_d1; 
    axi4s_vid_out_vid_rst <= axi4s_vid_out_vid_rst_d2; 

	axi4s_vid_out_vid_rstn_d1 <= ! axi4s_vid_out_vid_rst;
	axi4s_vid_out_vid_rstn_d2 <= axi4s_vid_out_vid_rstn_d1;  
	axi4s_vid_out_vid_rstn <= axi4s_vid_out_vid_rstn_d2;  
end

generate
if(C_INCLUDE_VID_OVER_AXI == 1)
begin
always @( posedge axis_clk) begin
	axi4s_vid_out_axis_rstn_d1 <= axi4s_vid_out_module_enable_axis & axis_rstn & (~tx_fabric_rst_axis);
	axi4s_vid_out_axis_rstn_d2 <= axi4s_vid_out_axis_rstn_d1;  
	axi4s_vid_out_axis_rstn <= axi4s_vid_out_axis_rstn_d2;  
end
end
endgenerate
/////////////////////bridge reset generate///////////end
//interrupt generation 

always @( posedge s_axi_aclk) begin
	if (s_axi_aresetn == 1'b0) begin
        gttx_resetdone_axi_d1 <= 1'b0;
        gttx_resetdone_axi_d2 <= 1'b0;
        gttx_resetdone_int    <= 1'b0;
        axi4s_vid_out_locked_axi_r1  <=  1'b0;
        axi4s_vid_out_locked_axi_r2  <=  1'b0;
        axi4s_vid_out_locked_int     <=  1'b0;
        axi4s_vid_out_overflow_axi_r1  <=  1'b0;
        axi4s_vid_out_overflow_axi_r2  <=  1'b0;
        axi4s_vid_out_overflow_int     <=  1'b0;
        axi4s_vid_out_underflow_axi_r1  <=  1'b0;
        axi4s_vid_out_underflow_axi_r2  <=  1'b0;
        axi4s_vid_out_underflow_int     <=  1'b0;
        tx_ce_align_err_axi_r1  <=  1'b0;
        tx_ce_align_err_axi_r2  <=  1'b0;
        tx_ce_align_err_int     <=  1'b0;
        axi4s_vid_out_module_en_axi   <= 1'b0;
        axi4s_vid_out_module_en_t_axi <= 1'b0;
    end else begin
	gttx_resetdone_axi_d1 <= gttx_resetdone_axi;
	gttx_resetdone_axi_d2 <= gttx_resetdone_axi_d1;
        gttx_resetdone_int <= (~gttx_resetdone_axi_d2) & gttx_resetdone_axi_d1;
        axi4s_vid_out_locked_axi_r1  <=  axi4s_vid_out_locked_axi;
        axi4s_vid_out_locked_axi_r2  <=  axi4s_vid_out_locked_axi_r1;
        axi4s_vid_out_locked_int     <=  (~axi4s_vid_out_locked_axi_r2) & axi4s_vid_out_locked_axi_r1;
        axi4s_vid_out_overflow_axi_r1  <=  axi4s_vid_out_overflow_axi;
        axi4s_vid_out_overflow_axi_r2  <=  axi4s_vid_out_overflow_axi_r1;
        axi4s_vid_out_overflow_int     <=  (~axi4s_vid_out_overflow_axi_r2) & axi4s_vid_out_overflow_axi_r1;
        axi4s_vid_out_underflow_axi_r1  <=  axi4s_vid_out_underflow_axi;
        axi4s_vid_out_underflow_axi_r2  <=  axi4s_vid_out_underflow_axi_r1;
        axi4s_vid_out_underflow_int     <=  (~axi4s_vid_out_underflow_axi_r2) & axi4s_vid_out_underflow_axi_r1;
        tx_ce_align_err_axi_r1  <=  tx_ce_align_err_axi;
        tx_ce_align_err_axi_r2  <=  tx_ce_align_err_axi_r1;
        tx_ce_align_err_int     <=  (~tx_ce_align_err_axi_r2) & tx_ce_align_err_axi_r1;
        axi4s_vid_out_module_en_axi   <= axi4s_vid_out_ctrl_axi[0];
        axi4s_vid_out_module_en_t_axi <= axi4s_vid_out_ctrl_axi[0];
    end
end

assign axi4s_vid_out_sts1_axi[0] = axi4s_vid_out_locked_int;
assign axi4s_vid_out_sts1_axi[1] = axi4s_vid_out_overflow_int;
assign axi4s_vid_out_sts1_axi[2] = axi4s_vid_out_underflow_int;
assign axi4s_vid_out_sts1_axi[31:3] = 0; 


//clock enable for edh processor, make it low in all other mode except SD mode
always @ (posedge tx_clk) begin
   if (tx_mode == MODE_SD) begin
      tx_edh_ce <= tx_sd_ce;
   end else begin 
      tx_edh_ce <= 1'b0;
   end
end

generate
	if (C_TX_TDATA_WIDTH == 40)
	begin : TX40
		assign m_axis_tx_tdata[39:0] = txdata;
	end else begin : TX20
		assign m_axis_tx_tdata[19:0] = txdata[19:0];
	end
endgenerate

generate
    if (C_AXI4LITE_ENABLE == 1)
    begin : GEN_AXI4LITE_TX
          // Instantiation of Axi Bus Interface s00_axi
      	v_smpte_uhdsdi_tx_v1_0_0_s00_axi # (
	        .C_AXI4LITE_ENABLE(C_AXI4LITE_ENABLE),
		    .C_ADV_FEATURE(C_ADV_FEATURE),
		    .C_INCLUDE_VID_OVER_AXI(C_INCLUDE_VID_OVER_AXI),  
		    .C_INCLUDE_SDI_BRIDGE(C_INCLUDE_SDI_BRIDGE),  
		    .C_INCLUDE_TX_EDH_PROCESSOR(C_INCLUDE_TX_EDH_PROCESSOR),  
      		.C_S_AXI_DATA_WIDTH(C_AXI_DATA_WIDTH),
      		.C_S_AXI_ADDR_WIDTH(C_AXI_ADDR_WIDTH)
      	) v_smpte_uhdsdi_tx_v1_0_0_s00_axi_inst (
		    .module_ctrl(module_ctrl_axi),
		    //.gt_ctrl(gt_ctrl_axi),
		    .sdi_tx_bridge_ctrl(sdi_tx_bridge_ctrl_axi),
		    .axi4s_vid_out_ctrl(axi4s_vid_out_ctrl_axi),
		    .stat_reset(stat_reset_axi),
		    .tx_st352_line_f1(tx_st352_line_f1_axi),
		    .tx_st352_line_f2(tx_st352_line_f2_axi),
		    .tx_st352_data_ch0(tx_st352_data_ch0_axi),
		    .tx_st352_data_ch1(tx_st352_data_ch1_axi),
		    .tx_st352_data_ch2(tx_st352_data_ch2_axi),
		    .tx_st352_data_ch3(tx_st352_data_ch3_axi),
		    .tx_st352_data_ch4(tx_st352_data_ch4_axi),
		    .tx_st352_data_ch5(tx_st352_data_ch5_axi),
		    .tx_st352_data_ch6(tx_st352_data_ch6_axi),
		    .tx_st352_data_ch7(tx_st352_data_ch7_axi),
            .tx_ce_align_err(tx_ce_align_err_int),	
            .sts_sb(sts_sb_axi),	
            .sdi_tx_bridge_sts(sdi_tx_bridge_sts_axi),	
            .axi4s_vid_out_sts1(axi4s_vid_out_sts1_axi),	
            .axi4s_vid_out_sts2(axi4s_vid_out_sts2_axi),	
		    .gttx_resetdone_int(gttx_resetdone_int),  
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
		//sdi_tx_ctrl
        assign module_enable       = module_ctrl_sys[0];
        assign output_enable       = module_ctrl_sys[1];
        assign tx_mode             = module_ctrl_sys[6:4];
        assign tx_m                = module_ctrl_sys[7];
        assign tx_mux_pattern      = module_ctrl_sys[10:8];
        assign tx_insert_crc       = module_ctrl_sys[12];
        assign tx_insert_st352     = module_ctrl_sys[13];
        assign tx_overwrite_st352  = module_ctrl_sys[14];
        assign tx_st352_f2_en      = module_ctrl_sys[15];
        assign tx_insert_sync_bit  = module_ctrl_sys[16];
        assign tx_sd_bitrep_bypass = module_ctrl_sys[17];
        assign tx_use_anc_in       = module_ctrl_sys[18];
        assign tx_insert_ln        = module_ctrl_sys[19];
        assign tx_insert_edh       = module_ctrl_sys[20];
        //others
        assign tx_st352_line_f1_int  = tx_st352_line_f1_sys;
        assign tx_st352_line_f2_int  = tx_st352_line_f2_sys;
        assign tx_st352_data_ch0_int = tx_st352_data_ch0_sys;
        assign tx_st352_data_ch1_int = tx_st352_data_ch1_sys;
        assign tx_st352_data_ch2_int = tx_st352_data_ch2_sys;
        assign tx_st352_data_ch3_int = tx_st352_data_ch3_sys;
        assign tx_st352_data_ch4_int = tx_st352_data_ch4_sys;
        assign tx_st352_data_ch5_int = tx_st352_data_ch5_sys;
        assign tx_st352_data_ch6_int = tx_st352_data_ch6_sys;
        assign tx_st352_data_ch7_int = tx_st352_data_ch7_sys;
		//gt control signals: use axi_clk domain
		//assign gt_rst_all = gt_ctrl_axi[0];
		//assign gt_tx_rst_pll_and_datapath = gt_ctrl_axi[1];
		//assign gt_tx_rst_datapath = gt_ctrl_axi[2];

 end
    else
    begin : AXI4LITE_DISABLED 
		//sdi_tx_ctrl
        assign module_enable       = sdi_tx_ctrl[0];
        assign output_enable       = sdi_tx_ctrl[1];
        assign tx_mode             = sdi_tx_ctrl[6:4];
        assign tx_m                = sdi_tx_ctrl[7];
        assign tx_mux_pattern      = sdi_tx_ctrl[10:8];
        assign tx_insert_crc       = sdi_tx_ctrl[12];
        assign tx_insert_st352     = sdi_tx_ctrl[13];
        assign tx_overwrite_st352  = sdi_tx_ctrl[14];
        assign tx_st352_f2_en      = sdi_tx_ctrl[15];
        assign tx_insert_sync_bit  = sdi_tx_ctrl[16];
        assign tx_sd_bitrep_bypass = sdi_tx_ctrl[17];
        assign tx_use_anc_in       = sdi_tx_ctrl[18];
        assign tx_insert_ln        = sdi_tx_ctrl[19];
        assign tx_insert_edh       = sdi_tx_ctrl[20];
		//gt control signals
		//assign gt_tx_rst_pll_and_datapath = sdi_tx_ctrl[24];
		//assign gt_tx_rst_datapath = sdi_tx_ctrl[25];
		//assign gt_rst_all = sdi_tx_ctrl[26];
		//sdi_tx_bridge control signals
       assign  sdi_tx_bridge_ctrl[0]       =  sdi_tx_ctrl[0];//sditx_bridge_en_axi;
       assign  sdi_tx_bridge_ctrl[3:1]     =  3'd0;
       assign  sdi_tx_bridge_ctrl[6:4]     =  sdi_tx_ctrl[6:4];
       assign  sdi_tx_bridge_ctrl[8:7]     =  sdi_tx_ctrl[29:28];
       assign  sdi_tx_bridge_ctrl[31:9]    =  23'd0;

		assign axi4s_vid_out_ctrl = 0;
		//others
        assign tx_st352_line_f1_int  = tx_st352_line_f1;
        assign tx_st352_line_f2_int  = tx_st352_line_f2;
        assign tx_st352_data_ch0_int = tx_st352_data_ch0;
        assign tx_st352_data_ch1_int = tx_st352_data_ch1;
        assign tx_st352_data_ch2_int = tx_st352_data_ch2;
        assign tx_st352_data_ch3_int = tx_st352_data_ch3;
        assign tx_st352_data_ch4_int = tx_st352_data_ch4;
        assign tx_st352_data_ch5_int = tx_st352_data_ch5;
        assign tx_st352_data_ch6_int = tx_st352_data_ch6;
        assign tx_st352_data_ch7_int = tx_st352_data_ch7;
		
		assign sdi_tx_err[0] = tx_ce_align_err;
    end
endgenerate


generate
if(C_LINE_RATE == "3G_SDI")
begin
v_smpte_uhdsdi_tx_v1_0_0_tx #(
    .INCLUDE_TX_EDH_PROCESSOR (C_INCLUDE_TX_EDH_PROCESSOR),
    .C_LINE_RATE              (2)
	)
TX (
	.clk                        (tx_clk),
	.ce                         (tx_ce),
	.sd_ce                      (tx_sd_ce),
	.edh_ce                     (tx_edh_ce),
	.rst                        (tx_rst_int_sys),
	.mode                       (tx_mode),
	.insert_crc                 (tx_insert_crc),
	.insert_ln                  (tx_insert_ln),
	.insert_st352               (tx_insert_st352),
	.overwrite_st352            (tx_overwrite_st352),
	.insert_edh                 (tx_insert_edh),
	.mux_pattern                (tx_mux_pattern),
	.insert_sync_bit            (tx_insert_sync_bit),
	.sd_bitrep_bypass           (tx_sd_bitrep_bypass),
	.line_ch0                   (tx_line_ch0),
	.line_ch1                   (tx_line_ch1),
	.line_ch2                   (tx_line_ch2),
	.line_ch3                   (tx_line_ch3),
	.line_ch4                   (tx_line_ch4),
	.line_ch5                   (tx_line_ch5),
	.line_ch6                   (tx_line_ch6),
	.line_ch7                   (tx_line_ch7),
	.st352_line_f1              (tx_st352_line_f1_int),
	.st352_line_f2              (tx_st352_line_f2_int),
	.st352_f2_en                (tx_st352_f2_en),
	.st352_data_ch0             (tx_st352_data_ch0_int),
	.st352_data_ch1             (tx_st352_data_ch1_int),
	.st352_data_ch2             (tx_st352_data_ch2_int),
	.st352_data_ch3             (tx_st352_data_ch3_int),
	.st352_data_ch4             (tx_st352_data_ch4_int),
	.st352_data_ch5             (tx_st352_data_ch5_int),
	.st352_data_ch6             (tx_st352_data_ch6_int),
	.st352_data_ch7             (tx_st352_data_ch7_int),
	.ds1_in                     (tx_ds1_in),
	.ds2_in                     (tx_ds2_in),
	.ds3_in                     (tx_ds3_in),
	.ds4_in                     (tx_ds4_in),
	.ds5_in                     (tx_ds5_in),
	.ds6_in                     (tx_ds6_in),
	.ds7_in                     (tx_ds7_in),
	.ds8_in                     (tx_ds8_in),
	.ds9_in                     (tx_ds9_in),
	.ds10_in                    (tx_ds10_in),
	.ds11_in                    (tx_ds11_in),
	.ds12_in                    (tx_ds12_in),
	.ds13_in                    (tx_ds13_in),
	.ds14_in                    (tx_ds14_in),
	.ds15_in                    (tx_ds15_in),
	.ds16_in                    (tx_ds16_in),
	.ds1_st352_out              (tx_ds1_st352_out),
	.ds2_st352_out              (tx_ds2_st352_out),
	.ds3_st352_out              (tx_ds3_st352_out),
	.ds4_st352_out              (tx_ds4_st352_out),
	.ds5_st352_out              (tx_ds5_st352_out),
	.ds6_st352_out              (tx_ds6_st352_out),
	.ds7_st352_out              (tx_ds7_st352_out),
	.ds8_st352_out              (tx_ds8_st352_out),
	.ds9_st352_out              (tx_ds9_st352_out),
	.ds10_st352_out             (tx_ds10_st352_out),
	.ds11_st352_out             (tx_ds11_st352_out),
	.ds12_st352_out             (tx_ds12_st352_out),
	.ds13_st352_out             (tx_ds13_st352_out),
	.ds14_st352_out             (tx_ds14_st352_out),
	.ds15_st352_out             (tx_ds15_st352_out),
	.ds16_st352_out             (tx_ds16_st352_out),
	.ds1_anc_in                 (tx_ds1_anc_in),
	.ds2_anc_in                 (tx_ds2_anc_in),
	.ds3_anc_in                 (tx_ds3_anc_in),
	.ds4_anc_in                 (tx_ds4_anc_in),
	.ds5_anc_in                 (tx_ds5_anc_in),
	.ds6_anc_in                 (tx_ds6_anc_in),
	.ds7_anc_in                 (tx_ds7_anc_in),
	.ds8_anc_in                 (tx_ds8_anc_in),
	.ds9_anc_in                 (tx_ds9_anc_in),
	.ds10_anc_in                (tx_ds10_anc_in),
	.ds11_anc_in                (tx_ds11_anc_in),
	.ds12_anc_in                (tx_ds12_anc_in),
	.ds13_anc_in                (tx_ds13_anc_in),
	.ds14_anc_in                (tx_ds14_anc_in),
	.ds15_anc_in                (tx_ds15_anc_in),
	.ds16_anc_in                (tx_ds16_anc_in),
	.use_anc_in                 (tx_use_anc_in),
	.txdata                     (txdata),
	.ce_align_err               (tx_ce_align_err)
	);
end
else
begin
v_smpte_uhdsdi_tx_v1_0_0_tx #(
    .INCLUDE_TX_EDH_PROCESSOR (C_INCLUDE_TX_EDH_PROCESSOR),
    .C_LINE_RATE              (0)
	)
TX (
	.clk                        (tx_clk),
	.ce                         (tx_ce),
	.sd_ce                      (tx_sd_ce),
	.edh_ce                     (tx_edh_ce),
	.rst                        (tx_rst_int_sys),
	.mode                       (tx_mode),
	.insert_crc                 (tx_insert_crc),
	.insert_ln                  (tx_insert_ln),
	.insert_st352               (tx_insert_st352),
	.overwrite_st352            (tx_overwrite_st352),
	.insert_edh                 (tx_insert_edh),
	.mux_pattern                (tx_mux_pattern),
	.insert_sync_bit            (tx_insert_sync_bit),
	.sd_bitrep_bypass           (tx_sd_bitrep_bypass),
	.line_ch0                   (tx_line_ch0),
	.line_ch1                   (tx_line_ch1),
	.line_ch2                   (tx_line_ch2),
	.line_ch3                   (tx_line_ch3),
	.line_ch4                   (tx_line_ch4),
	.line_ch5                   (tx_line_ch5),
	.line_ch6                   (tx_line_ch6),
	.line_ch7                   (tx_line_ch7),
	.st352_line_f1              (tx_st352_line_f1_int),
	.st352_line_f2              (tx_st352_line_f2_int),
	.st352_f2_en                (tx_st352_f2_en),
	.st352_data_ch0             (tx_st352_data_ch0_int),
	.st352_data_ch1             (tx_st352_data_ch1_int),
	.st352_data_ch2             (tx_st352_data_ch2_int),
	.st352_data_ch3             (tx_st352_data_ch3_int),
	.st352_data_ch4             (tx_st352_data_ch4_int),
	.st352_data_ch5             (tx_st352_data_ch5_int),
	.st352_data_ch6             (tx_st352_data_ch6_int),
	.st352_data_ch7             (tx_st352_data_ch7_int),
	.ds1_in                     (tx_ds1_in),
	.ds2_in                     (tx_ds2_in),
	.ds3_in                     (tx_ds3_in),
	.ds4_in                     (tx_ds4_in),
	.ds5_in                     (tx_ds5_in),
	.ds6_in                     (tx_ds6_in),
	.ds7_in                     (tx_ds7_in),
	.ds8_in                     (tx_ds8_in),
	.ds9_in                     (tx_ds9_in),
	.ds10_in                    (tx_ds10_in),
	.ds11_in                    (tx_ds11_in),
	.ds12_in                    (tx_ds12_in),
	.ds13_in                    (tx_ds13_in),
	.ds14_in                    (tx_ds14_in),
	.ds15_in                    (tx_ds15_in),
	.ds16_in                    (tx_ds16_in),
	.ds1_st352_out              (tx_ds1_st352_out),
	.ds2_st352_out              (tx_ds2_st352_out),
	.ds3_st352_out              (tx_ds3_st352_out),
	.ds4_st352_out              (tx_ds4_st352_out),
	.ds5_st352_out              (tx_ds5_st352_out),
	.ds6_st352_out              (tx_ds6_st352_out),
	.ds7_st352_out              (tx_ds7_st352_out),
	.ds8_st352_out              (tx_ds8_st352_out),
	.ds9_st352_out              (tx_ds9_st352_out),
	.ds10_st352_out             (tx_ds10_st352_out),
	.ds11_st352_out             (tx_ds11_st352_out),
	.ds12_st352_out             (tx_ds12_st352_out),
	.ds13_st352_out             (tx_ds13_st352_out),
	.ds14_st352_out             (tx_ds14_st352_out),
	.ds15_st352_out             (tx_ds15_st352_out),
	.ds16_st352_out             (tx_ds16_st352_out),
	.ds1_anc_in                 (tx_ds1_anc_in),
	.ds2_anc_in                 (tx_ds2_anc_in),
	.ds3_anc_in                 (tx_ds3_anc_in),
	.ds4_anc_in                 (tx_ds4_anc_in),
	.ds5_anc_in                 (tx_ds5_anc_in),
	.ds6_anc_in                 (tx_ds6_anc_in),
	.ds7_anc_in                 (tx_ds7_anc_in),
	.ds8_anc_in                 (tx_ds8_anc_in),
	.ds9_anc_in                 (tx_ds9_anc_in),
	.ds10_anc_in                (tx_ds10_anc_in),
	.ds11_anc_in                (tx_ds11_anc_in),
	.ds12_anc_in                (tx_ds12_anc_in),
	.ds13_anc_in                (tx_ds13_anc_in),
	.ds14_anc_in                (tx_ds14_anc_in),
	.ds15_anc_in                (tx_ds15_anc_in),
	.ds16_anc_in                (tx_ds16_anc_in),
	.use_anc_in                 (tx_use_anc_in),
	.txdata                     (txdata),
	.ce_align_err               (tx_ce_align_err)
	);
end
endgenerate
	//synchronization

	//sync to axis_clk domain: level signals
/*        
cross_clk_reg #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(1),
    .C_REGISTER_INPUT(0)
) tx_fabric_rst_sync2axis_clk(
	.in_clk   (1'b0), 
	.out_clk  (axis_clk),
	.data_in  (tx_fabric_rst),
	.data_out (tx_fabric_rst_axis));
*/
generate
if(C_INCLUDE_VID_OVER_AXI == 1)
begin
always @ (posedge axis_clk)
begin
    tx_fabric_rst_sync1_cdc_to_reg <= tx_fabric_rst;
    tx_fabric_rst_sync2_reg        <= tx_fabric_rst_sync1_cdc_to_reg;
    tx_fabric_rst_last_reg         <= tx_fabric_rst_sync2_reg;
end

assign  tx_fabric_rst_axis  =  tx_fabric_rst_last_reg;
end
endgenerate

/*        
cross_clk_reg #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(1),
    .C_REGISTER_INPUT(0)
) axi4s_vid_out_axis_rstn_sync2axis_clk(
	.in_clk   (1'b0), 
	.out_clk  (axis_clk),
	.data_in  (axi4s_vid_out_module_en_axi),
	.data_out (axi4s_vid_out_module_enable_axis));
*/

generate
if(C_INCLUDE_VID_OVER_AXI == 1)
begin
always @ (posedge axis_clk)
begin
    axi4s_vid_out_module_en_sync1_cdc_to_reg <= axi4s_vid_out_module_en_axi;
    axi4s_vid_out_module_en_sync2_reg        <= axi4s_vid_out_module_en_sync1_cdc_to_reg;
    axi4s_vid_out_module_en_last_reg         <= axi4s_vid_out_module_en_sync2_reg;
end

assign axi4s_vid_out_module_enable_axis  =  axi4s_vid_out_module_en_last_reg;
end
endgenerate
        
	//sync to tx_clk domain: level signals
/*        
cross_clk_reg #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(1),
    .C_REGISTER_INPUT(0)
) axi4s_vid_out_module_enable_sync2sys (
	.in_clk   (1'b0), //dont know clk source
	.out_clk  (tx_clk),
	.data_in  (axi4s_vid_out_module_en_t_axi),
	.data_out (axi4s_vid_out_module_enable_sys));
*/

always @ (posedge tx_clk)
begin
    axi4s_vid_out_module_en_t_sync1_cdc_to_reg <= axi4s_vid_out_module_en_t_axi;
    axi4s_vid_out_module_en_t_sync2_reg        <= axi4s_vid_out_module_en_t_sync1_cdc_to_reg;
    axi4s_vid_out_module_en_t_last_reg         <= axi4s_vid_out_module_en_t_sync2_reg;
end

assign axi4s_vid_out_module_enable_sys  =  axi4s_vid_out_module_en_t_last_reg;

cross_clk_reg #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(1),
    .C_REGISTER_INPUT(0)
) tx_rst_int_sync2sys (
	.in_clk   (1'b0), //dont know clk source
	.out_clk  (tx_clk),
	.data_in  (tx_rst_int),
	.data_out (tx_rst_int_sys));

/*
cross_clk_reg #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(32),
    .C_REGISTER_INPUT(0)
) sts_sb_sync2sys (
	.in_clk   (1'b0), //dont know clk source
	.out_clk  (tx_clk),
	.data_in  (s_axis_sts_sb_tx_tdata),
	.data_out (sts_sb_sys));
*/
generate
    if (C_AXI4LITE_ENABLE == 1)
    begin : GEN_AXI4LITE_SYNC
	//sync to axi_aclk domain: level signals
cross_clk_reg #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(1),
    .C_REGISTER_INPUT(1)
) gttx_resetdone_sync2axi (
	.in_clk   (tx_clk),
	.out_clk  (s_axi_aclk),
	.data_in  (gttx_resetdone),
	.data_out (gttx_resetdone_axi));

cross_clk_reg #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(1),
    .C_REGISTER_INPUT(1)
) axi4s_vid_out_locked_sync2axi (
	.in_clk   (tx_clk),
	.out_clk  (s_axi_aclk),
	.data_in  (axi4s_vid_out_locked),
	.data_out (axi4s_vid_out_locked_axi));
    end
endgenerate

generate
if((C_AXI4LITE_ENABLE == 1)&&(C_INCLUDE_VID_OVER_AXI == 1))
begin
cross_clk_reg #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(1),
    .C_REGISTER_INPUT(1)
) axi4s_vid_out_overflow_sync2axi (
	.in_clk   (axis_clk),
	.out_clk  (s_axi_aclk),
	.data_in  (axi4s_vid_out_overflow),
	.data_out (axi4s_vid_out_overflow_axi));
end
else
begin
    assign axi4s_vid_out_overflow_axi = 1'b0;
end
endgenerate

generate
    if (C_AXI4LITE_ENABLE == 1)
    begin : GEN_AXI4LITE_SYNC_1
cross_clk_reg #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(1),
    .C_REGISTER_INPUT(1)
) axi4s_vid_out_underflow_sync2axi (
	.in_clk   (tx_clk),
	.out_clk  (s_axi_aclk),
	.data_in  (axi4s_vid_out_underflow),
	.data_out (axi4s_vid_out_underflow_axi));

cross_clk_reg #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(32),
    .C_REGISTER_INPUT(0)
) axi4s_vid_out_status_sync2axi (
	.in_clk   (1'b0),
	.out_clk  (s_axi_aclk),
	.data_in  (axi4s_vid_out_status),
	.data_out (axi4s_vid_out_sts2_axi));

cross_clk_reg #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(1),
    .C_REGISTER_INPUT(1)
) tx_ce_align_err_sync2axi (
	.in_clk   (tx_clk),
	.out_clk  (s_axi_aclk),
	.data_in  (tx_ce_align_err),
	.data_out (tx_ce_align_err_axi));

cross_clk_reg #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(32),
    .C_REGISTER_INPUT(1)
) sts_sb_sync2axi (
	.in_clk   (tx_clk),
	.out_clk  (s_axi_aclk),
	.data_in  (s_axis_sts_sb_tx_tdata),
	.data_out (sts_sb_axi));

cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(32)
) sdi_tx_bridge_sts_sync2axi (
	.in_clk   (tx_clk), 
	.out_clk  (s_axi_aclk),
	.data_in  (sdi_tx_bridge_sts),
	.data_out (sdi_tx_bridge_sts_axi));

	//sync from axi_aclk to tx_clk domain: pulse signals
map_pulse #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS)
) tx_err_reset_axi2sys (
	.clk_i    (s_axi_aclk),
	.clk_o    (tx_clk),
	.pls_i  (stat_reset_axi[0]),
	.pls_o (tx_err_reset_sys));
	
	//sync from axi_aclk to tx_clk domain: level signals
cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(32)
) module_ctrl_sync2sys (
	.in_clk   (s_axi_aclk),
	.out_clk  (tx_clk),
	.data_in  (module_ctrl_axi),
	.data_out (module_ctrl_sys));

cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(32)
) sdi_tx_bridge_ctrl_sync2sys (
	.in_clk   (s_axi_aclk),
	.out_clk  (tx_clk),
	.data_in  (sdi_tx_bridge_ctrl_axi),
	.data_out (sdi_tx_bridge_ctrl));

cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(11)
) tx_st352_line_f1_sync2sys (
	.in_clk   (s_axi_aclk),
	.out_clk  (tx_clk),
	.data_in  (tx_st352_line_f1_axi),
	.data_out (tx_st352_line_f1_sys));

cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(11)
) tx_st352_line_f2_sync2sys (
	.in_clk   (s_axi_aclk),
	.out_clk  (tx_clk),
	.data_in  (tx_st352_line_f2_axi),
	.data_out (tx_st352_line_f2_sys));

cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(32)
) tx_st352_data_ch0_sync2sys (
	.in_clk   (s_axi_aclk),
	.out_clk  (tx_clk),
	.data_in  (tx_st352_data_ch0_axi),
	.data_out (tx_st352_data_ch0_sys));

cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(32)
) tx_st352_data_ch1_sync2sys (
	.in_clk   (s_axi_aclk),
	.out_clk  (tx_clk),
	.data_in  (tx_st352_data_ch1_axi),
	.data_out (tx_st352_data_ch1_sys));

cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(32)
) tx_st352_data_ch2_sync2sys (
	.in_clk   (s_axi_aclk),
	.out_clk  (tx_clk),
	.data_in  (tx_st352_data_ch2_axi),
	.data_out (tx_st352_data_ch2_sys));

cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(32)
) tx_st352_data_ch3_sync2sys (
	.in_clk   (s_axi_aclk),
	.out_clk  (tx_clk),
	.data_in  (tx_st352_data_ch3_axi),
	.data_out (tx_st352_data_ch3_sys));

cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(32)
) tx_st352_data_ch4_sync2sys (
	.in_clk   (s_axi_aclk),
	.out_clk  (tx_clk),
	.data_in  (tx_st352_data_ch4_axi),
	.data_out (tx_st352_data_ch4_sys));

cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(32)
) tx_st352_data_ch5_sync2sys (
	.in_clk   (s_axi_aclk),
	.out_clk  (tx_clk),
	.data_in  (tx_st352_data_ch5_axi),
	.data_out (tx_st352_data_ch5_sys));

cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(32)
) tx_st352_data_ch6_sync2sys (
	.in_clk   (s_axi_aclk),
	.out_clk  (tx_clk),
	.data_in  (tx_st352_data_ch6_axi),
	.data_out (tx_st352_data_ch6_sys));

cross_clk_bus #( 
    .C_NUM_SYNC_REGS(C_NUM_SYNC_REGS),
    .C_DATA_WIDTH(32)
) tx_st352_data_ch7_sync2sys (
	.in_clk   (s_axi_aclk),
	.out_clk  (tx_clk),
	.data_in  (tx_st352_data_ch7_axi),
	.data_out (tx_st352_data_ch7_sys));
   end
endgenerate

endmodule
