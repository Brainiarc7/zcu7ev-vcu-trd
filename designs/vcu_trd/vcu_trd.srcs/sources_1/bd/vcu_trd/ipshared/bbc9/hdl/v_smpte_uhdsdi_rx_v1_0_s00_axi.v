
`timescale 1 ns / 1 ps

	module v_smpte_uhdsdi_rx_v1_0_0_s00_axi #
	(
      	        parameter C_AXI4LITE_ENABLE              = 1, 
		parameter C_ADV_FEATURE                  = 1,
		parameter C_INCLUDE_VID_OVER_AXI         = 1,
		parameter C_INCLUDE_SDI_BRIDGE           = 1,
		parameter C_INCLUDE_RX_EDH_PROCESSOR     = 1,
		// Width of S_AXI data bus
		parameter integer C_S_AXI_DATA_WIDTH	 = 32,
		// Width of S_AXI address bus
		parameter integer C_S_AXI_ADDR_WIDTH	 = 8
	)
	(
        //R/W regsiter
		output wire [31:0] module_ctrl,
		output reg [31:0] video_lock_window,
		output wire [31:0] sdi_rx_bridge_ctrl,
		output wire [31:0] vid_in_axi4s_ctrl,
		output wire [31:0] stat_reset,
		output reg [15:0] rx_edh_errcnt_en,
		//read-only regsiter
		input wire [7:0] rx_st352_valid,
		input wire [31:0] rx_st352_0,
		input wire [31:0] rx_st352_1,
		input wire [31:0] rx_st352_2,
		input wire [31:0] rx_st352_3,
		input wire [31:0] rx_st352_4,
		input wire [31:0] rx_st352_5,
		input wire [31:0] rx_st352_6,
		input wire [31:0] rx_st352_7,
		input wire [31:0] rx_crc_errcnt,
		input wire [15:0] rx_edh_errcnt,
		input wire [22:0] rx_edh_sts,
		input wire [11:0] ts_det_sts,
		input wire [7:0] mode_det_sts,
		input wire [31:0] sts_sb,
		input wire [31:0] sdi_rx_bridge_sts,
		input wire [31:0] vid_in_axi4s_sts,
                //Set this bit when incoming SDI stream has St352 payload in all SDO modes including SD-SDI & HD-SDI
                output reg rcv_st352_always_axi,
		//interrupts: 1 cycle pulse
		input wire vid_lock_st352_vld_int,
		input wire video_lock_int,
		input wire video_unlock_int,
		//module interrupt
		output wire module_interrupt,

        //axi4lite interface//// 
  input  wire                             axi_aclk,
  input  wire                             axi_aresetn,

  input  wire  [C_S_AXI_ADDR_WIDTH-1:0]           axi_awaddr,
  output wire                             axi_awready,
  input  wire                             axi_awvalid,

  input  wire  [C_S_AXI_ADDR_WIDTH-1:0]           axi_araddr,
  output wire                             axi_arready,
  input  wire                             axi_arvalid,

  input  wire  [C_S_AXI_DATA_WIDTH-1:0]           axi_wdata,
  input  wire  [(C_S_AXI_DATA_WIDTH/8)-1 : 0]            axi_wstrb,
  output wire                             axi_wready,
  input  wire                             axi_wvalid,

  output reg   [C_S_AXI_DATA_WIDTH-1:0]           axi_rdata,
  output wire  [1:0]           axi_rresp,
  input  wire                             axi_rready,
  output reg                              axi_rvalid,

  output wire  [1:0]           axi_bresp,
  input  wire                             axi_bready,
  output reg                              axi_bvalid
	);

  reg   [6:0]   wr_addr;
  reg   [6:0]   rd_addr;
  reg           wr_req;
  reg           rd_req;

  reg           reset_released;
  reg           reset_released_r;
  reg           sdi_en_axi;
  reg           sdi_srst_axi;
  reg           rst_crc_errcnt_axi;
  reg           rst_edh_errcnt_axi;
  reg           sdirx_bridge_en_axi;
  reg           axi4s_vid_out_en_axi;
  reg           vid_in_axi4s_mod_en_axi;
  //reg           vid_in_axi4s_en_axi; //connected to vid_in_axi4s_mod_en_axi
  //bit
  reg           vidlock_st352_vld_r;
  reg           sel_vidlock_st352_vld_axi; //1 : selects vid_lock_st352_vld_int; 0 : selects video_lock_int
  //reg           rcv_st352_always_axi; 
  reg  [31:0]   module_ctrl_reg_axi;
  reg           glbl_ier_axi;
  reg           video_lock_r_axi;
  reg           video_unlock_r_axi;
  reg           overflow_r_axi;
  reg           underflow_r_axi;
  reg           video_lock_clr_axi;
  reg           video_unlock_clr_axi;
  reg           overflow_clr_axi;
  reg           underflow_clr_axi;
  reg           video_lock_ie_axi;
  reg           video_unlock_ie_axi;
  reg           overflow_ie_axi;
  reg           underflow_ie_axi;
  reg   [15:0]  rx_crc_err_r_axi;
  reg   [15:0]  rx_crc_err_clr_axi;

  //reg  [10:0]   tx_st352_line_f1_r_axi;  //TODO for 8K
  //reg  [10:0]   tx_st352_line_f2_r_axi;  //TODO for 8K
  wire          inc_rx_edh_proc_i;
  wire [1:0]    video_if_i;
  wire          inc_adv_feature_i;
  assign  module_ctrl[0]              =  sdi_en_axi;
  assign  module_ctrl[31:1]           =  module_ctrl_reg_axi[31:1];
  generate if(C_INCLUDE_VID_OVER_AXI || C_INCLUDE_SDI_BRIDGE) begin: en_sdi_brdge_ctrl_proc
    assign  sdi_rx_bridge_ctrl[0]       =  sdirx_bridge_en_axi;
    assign  sdi_rx_bridge_ctrl[31:1]    =  31'd0;
  end else begin: disab_sdi_brdge_ctrl_proc
    assign  sdi_rx_bridge_ctrl[0]       =  1'b0;
    assign  sdi_rx_bridge_ctrl[31:1]    =  31'd0;
  end
  endgenerate
  generate if(C_INCLUDE_VID_OVER_AXI) begin: en_vid_out_ctrl_proc
    assign  vid_in_axi4s_ctrl[0]        =  vid_in_axi4s_mod_en_axi;
    assign  vid_in_axi4s_ctrl[1]        =  vid_in_axi4s_mod_en_axi;//vid_in_axi4s_en_axi;
    assign  vid_in_axi4s_ctrl[31:2]     =  30'd0;
  end else begin: disab_vid_out_ctrl_proc
    assign  vid_in_axi4s_ctrl[0]        =  1'b0;
    assign  vid_in_axi4s_ctrl[1]        =  1'b0;
    assign  vid_in_axi4s_ctrl[31:2]     =  30'd0;
  end
  endgenerate
  assign  stat_reset[0]               =  rst_crc_errcnt_axi;
  assign  stat_reset[1]               =  rst_edh_errcnt_axi;
  assign  stat_reset[31:2]            =  30'd0;

  generate if(C_INCLUDE_RX_EDH_PROCESSOR) begin: gen_inc_rx_edh_proc
    assign  inc_rx_edh_proc_i  =  1'b1;   
  end else begin
    assign  inc_rx_edh_proc_i  =  1'b0;   
  end
  endgenerate

  generate if(C_INCLUDE_VID_OVER_AXI && C_INCLUDE_SDI_BRIDGE) begin: gen_axi4s_if_proc
    assign  video_if_i  =  2'b00;   
  end else if(!C_INCLUDE_VID_OVER_AXI && C_INCLUDE_SDI_BRIDGE) begin: gen_native_vid_if_proc
    assign  video_if_i  =  2'b01;   
  end else begin: gen_native_sdi_if_proc
    assign  video_if_i  =  2'b10;   
  end
  endgenerate

  generate if(C_ADV_FEATURE) begin: gen_adv_feature_proc
    assign  inc_adv_feature_i  =  1'b1;   
  end else begin
    assign  inc_adv_feature_i  =  1'b0;   
  end
  endgenerate
  
  //******************************************************************************
  //A write address phase is accepted only when there is no pending read or
  //write transactions. when both read and write transactions occur on the
  //same clock read transaction will get the highest priority and processed
  //first. write transaction will not be accepted until the read transaction
  //is completed. 
  //******************************************************************************
  assign axi_awready = ((~wr_req) && (!(rd_req || axi_arvalid))) && reset_released_r;
  assign axi_bresp = 2'b00;
  assign axi_rresp = 2'b00;
  assign axi_wready = wr_req && ~axi_bvalid;
  assign axi_arready = ~rd_req && ~wr_req && reset_released_r;


  //******************************************************************************
  //According to xilinx guide lines after reset the AWREADY and ARREADY siganls
  //should be low atleast for one clock cycle. To achieve this a signal 
  //reset_released is taken and anded with axi_awready and axi_arready signals,
  //so that the output will show a logic '0' when in reset
  //******************************************************************************
  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
      if(~axi_aresetn) begin
          reset_released   <= 1'b0;
          reset_released_r <= 1'b0;
      end else begin
          reset_released   <= 1'b1;
          reset_released_r <= reset_released;
      end 
  end

  //******************************************************************************
  //AXI Lite trasaction decoding and address latching logic. 
  //when axi_a*valid signal is asserted by the master the address is latched 
  //and wr_req or rd_req signal is asserted until data phase is completed 
  //******************************************************************************


  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
      if(~axi_aresetn)begin
          wr_req <= 1'b0;
          rd_req <= 1'b0;
          wr_addr <= 7'h00;
          rd_addr <= 7'h00;
      end else begin
          if(axi_awvalid && axi_awready) begin
              wr_req <= 1'b1;
              wr_addr <= axi_awaddr;
          end else if (axi_bvalid && axi_bready) begin
              wr_req <= 1'b0;
              wr_addr <= 6'h00;
          end else begin
              wr_req <= wr_req;
              wr_addr <= wr_addr;
          end

          if(axi_arvalid && axi_arready) begin
              rd_req <= 1'b1;
              rd_addr <= axi_araddr;
          end else if (axi_rvalid && axi_rready) begin
              rd_req <= 1'b0;
              rd_addr <= rd_addr;
          end else begin
              rd_req <= rd_req;
              rd_addr <= rd_addr;
          end
      end
  end
  
 
generate if(C_INCLUDE_VID_OVER_AXI) begin: gen_axi4s_if
  //******************************************************************************
  //AXI Lite read trasaction processing logic. 
  //when a read transaction is received, depending on address bits [5:2] the
  //data is recovered and sent on to axi_rdata signal along with axi_rvalid.  
  //The address bits [1:0] are not considred and it is expected that the
  //address is word aligned and reads complete word information. 
  //******************************************************************************
  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
      if(~axi_aresetn)begin
          axi_rvalid <= 1'b0;
          axi_rdata <= 32'd0;
      end else begin
          if(rd_req) begin
              if(axi_rvalid && axi_rready) begin
                  axi_rvalid <= 1'b0;
              end else begin
                  axi_rvalid <= 1'b1;
              end
              if(~axi_rvalid) begin
                 case (rd_addr[6:2]) 
                     //5'h00: axi_rdata <= {21'd0,vid_in_axi4s_en_axi,vid_in_axi4s_mod_en_axi,sdirx_bridge_en_axi,4'd0,rst_edh_errcnt_axi,rst_crc_errcnt_axi,sdi_srst_axi,sdi_en_axi};
                     5'h00: axi_rdata <= {22'd0,vid_in_axi4s_mod_en_axi,sdirx_bridge_en_axi,4'd0,rst_edh_errcnt_axi,rst_crc_errcnt_axi,sdi_srst_axi,sdi_en_axi};
                     5'h01: axi_rdata <= {module_ctrl_reg_axi[31:8],rcv_st352_always_axi,sel_vidlock_st352_vld_axi,module_ctrl_reg_axi[5:0]};
                     5'h02: axi_rdata <= 32'd0;
                     5'h03: axi_rdata <= {31'd0,glbl_ier_axi};
                     5'h04: axi_rdata <= {21'd0,underflow_r_axi,overflow_r_axi,7'd0,video_unlock_r_axi,video_lock_r_axi};
                     5'h05: axi_rdata <= {21'd0,underflow_ie_axi,overflow_ie_axi,7'd0,video_unlock_ie_axi,video_lock_ie_axi};
                     5'h06: axi_rdata <= {24'd0,rx_st352_valid};
                     5'h07: axi_rdata <= rx_st352_0;
                     5'h08: axi_rdata <= rx_st352_1;
                     5'h09: axi_rdata <= rx_st352_2;
                     5'h0a: axi_rdata <= rx_st352_3;
                     5'h0b: axi_rdata <= rx_st352_4;
                     5'h0c: axi_rdata <= rx_st352_5;
                     5'h0d: axi_rdata <= rx_st352_6;
                     5'h0e: axi_rdata <= rx_st352_7;
                     5'h0f: axi_rdata <= 32'h02000000;
                     5'h10: axi_rdata <= {27'd0,inc_adv_feature_i,video_if_i[1:0],inc_rx_edh_proc_i,1'b0};
                     5'h11: axi_rdata <= {24'd0,mode_det_sts};
                     5'h12: axi_rdata <= {20'd0,ts_det_sts[11:4],2'd0,ts_det_sts[1:0]};
                     5'h13: axi_rdata <= {9'd0,rx_edh_sts[22:4],1'b0,rx_edh_sts[2:0]};
                     5'h14: axi_rdata <= {16'd0,rx_edh_errcnt_en[15:0]};
                     5'h15: axi_rdata <= {16'd0,rx_edh_errcnt[15:0]};
                     //5'h16: axi_rdata <= {rx_crc_errcnt, 16'd0}; //TODO
                     5'h16: axi_rdata <= {rx_crc_errcnt[31:16],rx_crc_err_r_axi[15:0]};
                     5'h17: axi_rdata <= video_lock_window[31:0];
                     5'h18: axi_rdata <= sts_sb;
                     5'h19: axi_rdata <= 32'd0;
                     //5'h1a: axi_rdata <= {24'd0,sdi_rx_bridge_sts[7:4],2'd0,sdi_rx_bridge_sts[1:0]};
                     5'h1b: axi_rdata <= 32'd0;
                     default: axi_rdata <= 32'd0;
                 endcase
              end
          end else begin
              axi_rvalid <= 1'b0;
              axi_rdata <= 32'd0;
          end
      end 
  end

  //******************************************************************************
  //AXI Lite write trasaction processing logic. 
  //when a write transaction is received, depending on address bits [5:2] the
  //data is written in to the corresponding register.  
  //The address bits [1:0] are not considred and it is expected that the
  //address is word aligned and writes into entire register.  
  //******************************************************************************
  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
      if(~axi_aresetn)begin
          sdi_en_axi              <= 1'b0;
          sdi_srst_axi            <= 1'b0;
          rst_crc_errcnt_axi      <= 1'b0;
          rst_edh_errcnt_axi      <= 1'b0;
          sdirx_bridge_en_axi     <= 1'b0;
          vid_in_axi4s_mod_en_axi <= 1'b0;
          //vid_in_axi4s_en_axi     <= 1'b0;
          sel_vidlock_st352_vld_axi<= 1; //1 Selects vid_lock_st352_vld_int;  
          rcv_st352_always_axi    <= 0;
          module_ctrl_reg_axi     <= 0;
          glbl_ier_axi            <= 0;
          video_lock_clr_axi      <= 0;
          video_unlock_clr_axi    <= 0;
          overflow_clr_axi        <= 0;
          underflow_clr_axi       <= 0;
          video_lock_ie_axi       <= 0;
          video_unlock_ie_axi     <= 0;
          overflow_ie_axi         <= 0;
          underflow_ie_axi        <= 0;
          rx_edh_errcnt_en        <= 0;
          video_lock_window       <= 0;
          rx_crc_err_clr_axi      <= 0;
      end else begin
          module_ctrl_reg_axi[3:0]   <= 4'd0;
          module_ctrl_reg_axi[7:6]   <= 2'd0;
          module_ctrl_reg_axi[15:14] <= 2'd0;
          module_ctrl_reg_axi[31:19] <= 13'd0;
          if(wr_req && axi_wvalid && ~axi_bvalid) begin
              case (wr_addr[6:2]) 
                  5'h00: begin
                           sdi_en_axi              <= axi_wdata[0];
                           sdi_srst_axi            <= axi_wdata[1];
                           rst_crc_errcnt_axi      <= axi_wdata[2];
                           rst_edh_errcnt_axi      <= axi_wdata[3];
                           sdirx_bridge_en_axi     <= axi_wdata[8];
                           vid_in_axi4s_mod_en_axi <= axi_wdata[9];
                           //vid_in_axi4s_en_axi     <= axi_wdata[10];
                         end
                  5'h01: begin 
                           module_ctrl_reg_axi[5:4]   <= axi_wdata[5:4];
                           sel_vidlock_st352_vld_axi  <= axi_wdata[6];
                           rcv_st352_always_axi       <= axi_wdata[7];
                           module_ctrl_reg_axi[13:8]  <= axi_wdata[13:8];
                           module_ctrl_reg_axi[18:16] <= axi_wdata[18:16];
                        end  
                  5'h03: glbl_ier_axi <= axi_wdata[0];
                  5'h04: begin
                           video_lock_clr_axi      <= axi_wdata[0];
                           video_unlock_clr_axi    <= axi_wdata[1];
                           overflow_clr_axi        <= axi_wdata[9];
                           underflow_clr_axi       <= axi_wdata[10];
                         end
                  5'h05: begin 
                           video_lock_ie_axi       <= axi_wdata[0];
                           video_unlock_ie_axi     <= axi_wdata[1];
                           overflow_ie_axi         <= axi_wdata[9];
                           underflow_ie_axi        <= axi_wdata[10];
                         end
                  5'h14: rx_edh_errcnt_en  <= axi_wdata[15:0];
                  5'h16: begin 
                           rx_crc_err_clr_axi[0]   <= axi_wdata[0];
                           rx_crc_err_clr_axi[1]   <= axi_wdata[1];
                           rx_crc_err_clr_axi[2]   <= axi_wdata[2];
                           rx_crc_err_clr_axi[3]   <= axi_wdata[3];
                           rx_crc_err_clr_axi[4]   <= axi_wdata[4];
                           rx_crc_err_clr_axi[5]   <= axi_wdata[5];
                           rx_crc_err_clr_axi[6]   <= axi_wdata[6];
                           rx_crc_err_clr_axi[7]   <= axi_wdata[7];
                           rx_crc_err_clr_axi[8]   <= axi_wdata[8];
                           rx_crc_err_clr_axi[9]   <= axi_wdata[9];
                           rx_crc_err_clr_axi[10]  <= axi_wdata[10];
                           rx_crc_err_clr_axi[11]  <= axi_wdata[11];
                           rx_crc_err_clr_axi[12]  <= axi_wdata[12];
                           rx_crc_err_clr_axi[13]  <= axi_wdata[13];
                           rx_crc_err_clr_axi[14]  <= axi_wdata[14];
                           rx_crc_err_clr_axi[15]  <= axi_wdata[15];
                         end
                  5'h17: video_lock_window <= axi_wdata[31:0];
              endcase
          end else begin
              video_lock_clr_axi      <= 0;
              video_unlock_clr_axi    <= 0;
              overflow_clr_axi        <= 0;
              underflow_clr_axi       <= 0;
              rx_crc_err_clr_axi      <= 0;
          end
      end 
  end

end else if(C_INCLUDE_SDI_BRIDGE) begin: gen_native_video_if
  //******************************************************************************
  //AXI Lite read trasaction processing logic. 
  //when a read transaction is received, depending on address bits [5:2] the
  //data is recovered and sent on to axi_rdata signal along with axi_rvalid.  
  //The address bits [1:0] are not considred and it is expected that the
  //address is word aligned and reads complete word information. 
  //******************************************************************************
  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
      if(~axi_aresetn)begin
          axi_rvalid <= 1'b0;
          axi_rdata <= 32'd0;
      end else begin
          if(rd_req) begin
              if(axi_rvalid && axi_rready) begin
                  axi_rvalid <= 1'b0;
              end else begin
                  axi_rvalid <= 1'b1;
              end
              if(~axi_rvalid) begin
                 case (rd_addr[6:2]) 
                     //5'h00: axi_rdata <= {21'd0,vid_in_axi4s_en_axi,vid_in_axi4s_mod_en_axi,sdirx_bridge_en_axi,4'd0,rst_edh_errcnt_axi,rst_crc_errcnt_axi,sdi_srst_axi,sdi_en_axi};
                     5'h00: axi_rdata <= {23'd0,sdirx_bridge_en_axi,4'd0,rst_edh_errcnt_axi,rst_crc_errcnt_axi,sdi_srst_axi,sdi_en_axi};
                     5'h01: axi_rdata <= {module_ctrl_reg_axi[31:8],rcv_st352_always_axi,sel_vidlock_st352_vld_axi,module_ctrl_reg_axi[5:0]};
                     5'h02: axi_rdata <= 32'd0;
                     5'h03: axi_rdata <= {31'd0,glbl_ier_axi};
                     5'h04: axi_rdata <= {30'd0,video_unlock_r_axi,video_lock_r_axi};
                     5'h05: axi_rdata <= {30'd0,video_unlock_ie_axi,video_lock_ie_axi};
                     5'h06: axi_rdata <= {24'd0,rx_st352_valid};
                     5'h07: axi_rdata <= rx_st352_0;
                     5'h08: axi_rdata <= rx_st352_1;
                     5'h09: axi_rdata <= rx_st352_2;
                     5'h0a: axi_rdata <= rx_st352_3;
                     5'h0b: axi_rdata <= rx_st352_4;
                     5'h0c: axi_rdata <= rx_st352_5;
                     5'h0d: axi_rdata <= rx_st352_6;
                     5'h0e: axi_rdata <= rx_st352_7;
                     5'h0f: axi_rdata <= 32'h02000000;
                     5'h10: axi_rdata <= {27'd0,inc_adv_feature_i,video_if_i[1:0],inc_rx_edh_proc_i,1'b0};
                     5'h11: axi_rdata <= {24'd0,mode_det_sts};
                     5'h12: axi_rdata <= {20'd0,ts_det_sts[11:4],2'd0,ts_det_sts[1:0]};
                     5'h13: axi_rdata <= {9'd0,rx_edh_sts[22:4],1'b0,rx_edh_sts[2:0]};
                     5'h14: axi_rdata <= {16'd0,rx_edh_errcnt_en[15:0]};
                     5'h15: axi_rdata <= {16'd0,rx_edh_errcnt[15:0]};
                     //5'h16: axi_rdata <= {rx_crc_errcnt, 16'd0}; //TODO
                     5'h16: axi_rdata <= {rx_crc_errcnt[31:16],rx_crc_err_r_axi[15:0]};
                     5'h17: axi_rdata <= video_lock_window[31:0];
                     5'h18: axi_rdata <= sts_sb;
                     5'h19: axi_rdata <= 32'd0;
                     //5'h1a: axi_rdata <= {24'd0,sdi_rx_bridge_sts[7:4],2'd0,sdi_rx_bridge_sts[1:0]};
                     5'h1b: axi_rdata <= 32'd0;
                     default: axi_rdata <= 32'd0;
                 endcase
              end
          end else begin
              axi_rvalid <= 1'b0;
              axi_rdata <= 32'd0;
          end
      end 
  end

  //******************************************************************************
  //AXI Lite write trasaction processing logic. 
  //when a write transaction is received, depending on address bits [5:2] the
  //data is written in to the corresponding register.  
  //The address bits [1:0] are not considred and it is expected that the
  //address is word aligned and writes into entire register.  
  //******************************************************************************
  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
      if(~axi_aresetn)begin
          sdi_en_axi              <= 1'b0;
          sdi_srst_axi            <= 1'b0;
          rst_crc_errcnt_axi      <= 1'b0;
          rst_edh_errcnt_axi      <= 1'b0;
          sdirx_bridge_en_axi     <= 1'b0;
          vid_in_axi4s_mod_en_axi <= 1'b0;
          //vid_in_axi4s_en_axi     <= 1'b0;
          sel_vidlock_st352_vld_axi<= 1; //1 Selects vid_lock_st352_vld_int;  
          rcv_st352_always_axi    <= 0;
          module_ctrl_reg_axi     <= 0;
          glbl_ier_axi            <= 0;
          video_lock_clr_axi      <= 0;
          video_unlock_clr_axi    <= 0;
          overflow_clr_axi        <= 0;
          underflow_clr_axi       <= 0;
          video_lock_ie_axi       <= 0;
          video_unlock_ie_axi     <= 0;
          overflow_ie_axi         <= 0;
          underflow_ie_axi        <= 0;
          rx_edh_errcnt_en        <= 0;
          video_lock_window       <= 0;
          rx_crc_err_clr_axi      <= 0;
      end else begin
          if(wr_req && axi_wvalid && ~axi_bvalid) begin
              case (wr_addr[6:2]) 
                  5'h00: begin
                           sdi_en_axi              <= axi_wdata[0];
                           sdi_srst_axi            <= axi_wdata[1];
                           rst_crc_errcnt_axi      <= axi_wdata[2];
                           rst_edh_errcnt_axi      <= axi_wdata[3];
                           sdirx_bridge_en_axi     <= axi_wdata[8];
                           //vid_in_axi4s_en_axi     <= axi_wdata[10];
                         end
                  5'h01: begin 
                           module_ctrl_reg_axi[5:4]   <= axi_wdata[5:4];
                           sel_vidlock_st352_vld_axi  <= axi_wdata[6];
                           rcv_st352_always_axi       <= axi_wdata[7];
                           module_ctrl_reg_axi[13:8]  <= axi_wdata[13:8];
                           module_ctrl_reg_axi[18:16] <= axi_wdata[18:16];
                        end  
                  5'h03: glbl_ier_axi <= axi_wdata[0];
                  5'h04: begin
                           video_lock_clr_axi      <= axi_wdata[0];
                           video_unlock_clr_axi    <= axi_wdata[1];
                         end
                  5'h05: begin 
                           video_lock_ie_axi       <= axi_wdata[0];
                           video_unlock_ie_axi     <= axi_wdata[1];
                         end
                  5'h14: rx_edh_errcnt_en  <= axi_wdata[15:0];
                  5'h16: begin 
                           rx_crc_err_clr_axi[0]   <= axi_wdata[0];
                           rx_crc_err_clr_axi[1]   <= axi_wdata[1];
                           rx_crc_err_clr_axi[2]   <= axi_wdata[2];
                           rx_crc_err_clr_axi[3]   <= axi_wdata[3];
                           rx_crc_err_clr_axi[4]   <= axi_wdata[4];
                           rx_crc_err_clr_axi[5]   <= axi_wdata[5];
                           rx_crc_err_clr_axi[6]   <= axi_wdata[6];
                           rx_crc_err_clr_axi[7]   <= axi_wdata[7];
                           rx_crc_err_clr_axi[8]   <= axi_wdata[8];
                           rx_crc_err_clr_axi[9]   <= axi_wdata[9];
                           rx_crc_err_clr_axi[10]  <= axi_wdata[10];
                           rx_crc_err_clr_axi[11]  <= axi_wdata[11];
                           rx_crc_err_clr_axi[12]  <= axi_wdata[12];
                           rx_crc_err_clr_axi[13]  <= axi_wdata[13];
                           rx_crc_err_clr_axi[14]  <= axi_wdata[14];
                           rx_crc_err_clr_axi[15]  <= axi_wdata[15];
                         end
                  5'h17: video_lock_window <= axi_wdata[31:0];
              endcase
          end else begin
              video_lock_clr_axi      <= 0;
              video_unlock_clr_axi    <= 0;
              overflow_clr_axi        <= 0;
              underflow_clr_axi       <= 0;
              rx_crc_err_clr_axi      <= 0;
          end
      end 
  end
   
end else begin: gen_native_sdi_if
  //******************************************************************************
  //AXI Lite read trasaction processing logic. 
  //when a read transaction is received, depending on address bits [5:2] the
  //data is recovered and sent on to axi_rdata signal along with axi_rvalid.  
  //The address bits [1:0] are not considred and it is expected that the
  //address is word aligned and reads complete word information. 
  //******************************************************************************
  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
      if(~axi_aresetn)begin
          axi_rvalid <= 1'b0;
          axi_rdata <= 32'd0;
      end else begin
          if(rd_req) begin
              if(axi_rvalid && axi_rready) begin
                  axi_rvalid <= 1'b0;
              end else begin
                  axi_rvalid <= 1'b1;
              end
              if(~axi_rvalid) begin
                 case (rd_addr[6:2]) 
                     //5'h00: axi_rdata <= {21'd0,vid_in_axi4s_en_axi,vid_in_axi4s_mod_en_axi,sdirx_bridge_en_axi,4'd0,rst_edh_errcnt_axi,rst_crc_errcnt_axi,sdi_srst_axi,sdi_en_axi};
                     5'h00: axi_rdata <= {28'd0,rst_edh_errcnt_axi,rst_crc_errcnt_axi,sdi_srst_axi,sdi_en_axi};
                     5'h01: axi_rdata <= {module_ctrl_reg_axi[31:8],rcv_st352_always_axi,sel_vidlock_st352_vld_axi,module_ctrl_reg_axi[5:0]};
                     5'h02: axi_rdata <= 32'd0;
                     5'h03: axi_rdata <= {31'd0,glbl_ier_axi};
                     5'h04: axi_rdata <= {30'd0,video_unlock_r_axi,video_lock_r_axi};
                     5'h05: axi_rdata <= {30'd0,video_unlock_ie_axi,video_lock_ie_axi};
                     5'h06: axi_rdata <= {24'd0,rx_st352_valid};
                     5'h07: axi_rdata <= rx_st352_0;
                     5'h08: axi_rdata <= rx_st352_1;
                     5'h09: axi_rdata <= rx_st352_2;
                     5'h0a: axi_rdata <= rx_st352_3;
                     5'h0b: axi_rdata <= rx_st352_4;
                     5'h0c: axi_rdata <= rx_st352_5;
                     5'h0d: axi_rdata <= rx_st352_6;
                     5'h0e: axi_rdata <= rx_st352_7;
                     5'h0f: axi_rdata <= 32'h02000000;
                     5'h10: axi_rdata <= {27'd0,inc_adv_feature_i,video_if_i[1:0],inc_rx_edh_proc_i,1'b0};
                     5'h11: axi_rdata <= {24'd0,mode_det_sts};
                     5'h12: axi_rdata <= {20'd0,ts_det_sts[11:4],2'd0,ts_det_sts[1:0]};
                     5'h13: axi_rdata <= {9'd0,rx_edh_sts[22:4],1'b0,rx_edh_sts[2:0]};
                     5'h14: axi_rdata <= {16'd0,rx_edh_errcnt_en[15:0]};
                     5'h15: axi_rdata <= {16'd0,rx_edh_errcnt[15:0]};
                     //5'h16: axi_rdata <= {rx_crc_errcnt, 16'd0}; //TODO
                     5'h16: axi_rdata <= {rx_crc_errcnt[31:16],rx_crc_err_r_axi[15:0]};
                     5'h17: axi_rdata <= video_lock_window[31:0];
                     5'h18: axi_rdata <= sts_sb;
                     5'h19: axi_rdata <= 32'd0;
                     //5'h1a: axi_rdata <= {24'd0,sdi_rx_bridge_sts[7:4],2'd0,sdi_rx_bridge_sts[1:0]};
                     5'h1b: axi_rdata <= 32'd0;
                     default: axi_rdata <= 32'd0;
                 endcase
              end
          end else begin
              axi_rvalid <= 1'b0;
              axi_rdata <= 32'd0;
          end
      end 
  end

  //******************************************************************************
  //AXI Lite write trasaction processing logic. 
  //when a write transaction is received, depending on address bits [5:2] the
  //data is written in to the corresponding register.  
  //The address bits [1:0] are not considred and it is expected that the
  //address is word aligned and writes into entire register.  
  //******************************************************************************
  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
      if(~axi_aresetn)begin
          sdi_en_axi              <= 1'b0;
          sdi_srst_axi            <= 1'b0;
          rst_crc_errcnt_axi      <= 1'b0;
          rst_edh_errcnt_axi      <= 1'b0;
          sdirx_bridge_en_axi     <= 1'b0;
          vid_in_axi4s_mod_en_axi <= 1'b0;
          //vid_in_axi4s_en_axi     <= 1'b0;
          sel_vidlock_st352_vld_axi<= 1; //1 Selects vid_lock_st352_vld_int;  
          rcv_st352_always_axi    <= 0;
          module_ctrl_reg_axi     <= 0;
          glbl_ier_axi            <= 0;
          video_lock_clr_axi      <= 0;
          video_unlock_clr_axi    <= 0;
          overflow_clr_axi        <= 0;
          underflow_clr_axi       <= 0;
          video_lock_ie_axi       <= 0;
          video_unlock_ie_axi     <= 0;
          overflow_ie_axi         <= 0;
          underflow_ie_axi        <= 0;
          rx_edh_errcnt_en        <= 0;
          video_lock_window       <= 0;
          rx_crc_err_clr_axi      <= 0;
      end else begin
          if(wr_req && axi_wvalid && ~axi_bvalid) begin
              case (wr_addr[6:2]) 
                  5'h00: begin
                           sdi_en_axi              <= axi_wdata[0];
                           sdi_srst_axi            <= axi_wdata[1];
                           rst_crc_errcnt_axi      <= axi_wdata[2];
                           rst_edh_errcnt_axi      <= axi_wdata[3];
                           //vid_in_axi4s_en_axi     <= axi_wdata[10];
                         end
                  5'h01: begin 
                           module_ctrl_reg_axi[5:4]   <= axi_wdata[5:4];
                           sel_vidlock_st352_vld_axi  <= axi_wdata[6];
                           rcv_st352_always_axi       <= axi_wdata[7];
                           module_ctrl_reg_axi[13:8]  <= axi_wdata[13:8];
                           module_ctrl_reg_axi[18:16] <= axi_wdata[18:16];
                        end  
                  5'h03: glbl_ier_axi <= axi_wdata[0];
                  5'h04: begin
                           video_lock_clr_axi      <= axi_wdata[0];
                           video_unlock_clr_axi    <= axi_wdata[1];
                         end
                  5'h05: begin 
                           video_lock_ie_axi       <= axi_wdata[0];
                           video_unlock_ie_axi     <= axi_wdata[1];
                         end
                  5'h14: rx_edh_errcnt_en  <= axi_wdata[15:0];
                  5'h16: begin 
                           rx_crc_err_clr_axi[0]   <= axi_wdata[0];
                           rx_crc_err_clr_axi[1]   <= axi_wdata[1];
                           rx_crc_err_clr_axi[2]   <= axi_wdata[2];
                           rx_crc_err_clr_axi[3]   <= axi_wdata[3];
                           rx_crc_err_clr_axi[4]   <= axi_wdata[4];
                           rx_crc_err_clr_axi[5]   <= axi_wdata[5];
                           rx_crc_err_clr_axi[6]   <= axi_wdata[6];
                           rx_crc_err_clr_axi[7]   <= axi_wdata[7];
                           rx_crc_err_clr_axi[8]   <= axi_wdata[8];
                           rx_crc_err_clr_axi[9]   <= axi_wdata[9];
                           rx_crc_err_clr_axi[10]  <= axi_wdata[10];
                           rx_crc_err_clr_axi[11]  <= axi_wdata[11];
                           rx_crc_err_clr_axi[12]  <= axi_wdata[12];
                           rx_crc_err_clr_axi[13]  <= axi_wdata[13];
                           rx_crc_err_clr_axi[14]  <= axi_wdata[14];
                           rx_crc_err_clr_axi[15]  <= axi_wdata[15];
                         end
                  5'h17: video_lock_window <= axi_wdata[31:0];
              endcase
          end else begin
              video_lock_clr_axi      <= 0;
              video_unlock_clr_axi    <= 0;
              overflow_clr_axi        <= 0;
              underflow_clr_axi       <= 0;
              rx_crc_err_clr_axi      <= 0;
          end
      end 
  end

end
endgenerate

  //********************************************************************************
  //write response channel logic. 
  //This logic will generate BVALID signal for the write transaction. 
  //********************************************************************************
  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
      if(~axi_aresetn) begin
          axi_bvalid <= 1'b0;
      end else begin
          if(wr_req && axi_wvalid && ~axi_bvalid) begin
              axi_bvalid <= 1'b1;
          end else if(axi_bready) begin
              axi_bvalid <= 1'b0;
          end else begin
              axi_bvalid <= axi_bvalid;
          end
      end
  end

  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
   if(~axi_aresetn)
     vidlock_st352_vld_r  <=  1'b0;
   else if(sel_vidlock_st352_vld_axi)
     vidlock_st352_vld_r  <=  vid_lock_st352_vld_int;
   else
     vidlock_st352_vld_r  <=  video_lock_int;
  end

  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
   if(~axi_aresetn)
     video_lock_r_axi  <=  1'b0;
   else if(sdi_srst_axi)
     video_lock_r_axi  <=  1'b0;
   else if(vidlock_st352_vld_r/*video_lock_int*/)
     video_lock_r_axi  <=  1'b1;
   else if(video_lock_clr_axi)
     video_lock_r_axi  <=  1'b0;
  end   

  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
   if(~axi_aresetn)
     video_unlock_r_axi  <=  1'b0;
   else if(sdi_srst_axi)
     video_unlock_r_axi  <=  1'b0;
   else if(video_unlock_int)
     video_unlock_r_axi  <=  1'b1;
   else if(video_unlock_clr_axi)
     video_unlock_r_axi  <=  1'b0;
  end   

  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
   if(~axi_aresetn)
     overflow_r_axi  <=  1'b0;
   else if(sdi_srst_axi)
     overflow_r_axi  <=  1'b0;
   else if(vid_in_axi4s_sts[0])
     overflow_r_axi  <=  1'b1;
   else if(overflow_clr_axi)
     overflow_r_axi  <=  1'b0;
  end   

  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
   if(~axi_aresetn)
     underflow_r_axi  <=  1'b0;
   else if(sdi_srst_axi)
     underflow_r_axi  <=  1'b0;
   else if(vid_in_axi4s_sts[1])
     underflow_r_axi  <=  1'b1;
   else if(underflow_clr_axi)
     underflow_r_axi  <=  1'b0;
  end   
 
  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
   if(~axi_aresetn)
     rx_crc_err_r_axi[0]  <=  1'b0;
   else if(sdi_srst_axi)
     rx_crc_err_r_axi[0]  <=  1'b0;
   else if(rx_crc_errcnt[0])
     rx_crc_err_r_axi[0]  <=  1'b1;
   else if(rx_crc_err_clr_axi[0])
     rx_crc_err_r_axi[0]  <=  1'b0;
  end   

  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
   if(~axi_aresetn)
     rx_crc_err_r_axi[1]  <=  1'b0;
   else if(sdi_srst_axi)
     rx_crc_err_r_axi[1]  <=  1'b0;
   else if(rx_crc_errcnt[1])
     rx_crc_err_r_axi[1]  <=  1'b1;
   else if(rx_crc_err_clr_axi[1])
     rx_crc_err_r_axi[1]  <=  1'b0;
  end 

  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
   if(~axi_aresetn)
     rx_crc_err_r_axi[2]  <=  1'b0;
   else if(sdi_srst_axi)
     rx_crc_err_r_axi[2]  <=  1'b0;
   else if(rx_crc_errcnt[2])
     rx_crc_err_r_axi[2]  <=  1'b1;
   else if(rx_crc_err_clr_axi[2])
     rx_crc_err_r_axi[2]  <=  1'b0;
  end

  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
   if(~axi_aresetn)
     rx_crc_err_r_axi[3]  <=  1'b0;
   else if(sdi_srst_axi)
     rx_crc_err_r_axi[3]  <=  1'b0;
   else if(rx_crc_errcnt[3])
     rx_crc_err_r_axi[3]  <=  1'b1;
   else if(rx_crc_err_clr_axi[3])
     rx_crc_err_r_axi[3]  <=  1'b0;
  end

  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
   if(~axi_aresetn)
     rx_crc_err_r_axi[4]  <=  1'b0;
   else if(sdi_srst_axi)
     rx_crc_err_r_axi[4]  <=  1'b0;
   else if(rx_crc_errcnt[4])
     rx_crc_err_r_axi[4]  <=  1'b1;
   else if(rx_crc_err_clr_axi[4])
     rx_crc_err_r_axi[4]  <=  1'b0;
  end 

  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
   if(~axi_aresetn)
     rx_crc_err_r_axi[5]  <=  1'b0;
   else if(sdi_srst_axi)
     rx_crc_err_r_axi[5]  <=  1'b0;
   else if(rx_crc_errcnt[5])
     rx_crc_err_r_axi[5]  <=  1'b1;
   else if(rx_crc_err_clr_axi[5])
     rx_crc_err_r_axi[5]  <=  1'b0;
  end 

  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
   if(~axi_aresetn)
     rx_crc_err_r_axi[6]  <=  1'b0;
   else if(sdi_srst_axi)
     rx_crc_err_r_axi[6]  <=  1'b0;
   else if(rx_crc_errcnt[6])
     rx_crc_err_r_axi[6]  <=  1'b1;
   else if(rx_crc_err_clr_axi[6])
     rx_crc_err_r_axi[6]  <=  1'b0;
  end 

  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
   if(~axi_aresetn)
     rx_crc_err_r_axi[7]  <=  1'b0;
   else if(sdi_srst_axi)
     rx_crc_err_r_axi[7]  <=  1'b0;
   else if(rx_crc_errcnt[7])
     rx_crc_err_r_axi[7]  <=  1'b1;
   else if(rx_crc_err_clr_axi[7])
     rx_crc_err_r_axi[7]  <=  1'b0;
  end 

  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
   if(~axi_aresetn)
     rx_crc_err_r_axi[8]  <=  1'b0;
   else if(sdi_srst_axi)
     rx_crc_err_r_axi[8]  <=  1'b0;
   else if(rx_crc_errcnt[8])
     rx_crc_err_r_axi[8]  <=  1'b1;
   else if(rx_crc_err_clr_axi[8])
     rx_crc_err_r_axi[8]  <=  1'b0;
  end 

  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
   if(~axi_aresetn)
     rx_crc_err_r_axi[9]  <=  1'b0;
   else if(sdi_srst_axi)
     rx_crc_err_r_axi[9]  <=  1'b0;
   else if(rx_crc_errcnt[9])
     rx_crc_err_r_axi[9]  <=  1'b1;
   else if(rx_crc_err_clr_axi[9])
     rx_crc_err_r_axi[9]  <=  1'b0;
  end 

  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
   if(~axi_aresetn)
     rx_crc_err_r_axi[10]  <=  1'b0;
   else if(sdi_srst_axi)
     rx_crc_err_r_axi[10]  <=  1'b0;
   else if(rx_crc_errcnt[10])
     rx_crc_err_r_axi[10]  <=  1'b1;
   else if(rx_crc_err_clr_axi[10])
     rx_crc_err_r_axi[10]  <=  1'b0;
  end 

  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
   if(~axi_aresetn)
     rx_crc_err_r_axi[11]  <=  1'b0;
   else if(sdi_srst_axi)
     rx_crc_err_r_axi[11]  <=  1'b0;
   else if(rx_crc_errcnt[11])
     rx_crc_err_r_axi[11]  <=  1'b1;
   else if(rx_crc_err_clr_axi[11])
     rx_crc_err_r_axi[11]  <=  1'b0;
  end 

  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
   if(~axi_aresetn)
     rx_crc_err_r_axi[12]  <=  1'b0;
   else if(sdi_srst_axi)
     rx_crc_err_r_axi[12]  <=  1'b0;
   else if(rx_crc_errcnt[12])
     rx_crc_err_r_axi[12]  <=  1'b1;
   else if(rx_crc_err_clr_axi[12])
     rx_crc_err_r_axi[12]  <=  1'b0;
  end 

  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
   if(~axi_aresetn)
     rx_crc_err_r_axi[13]  <=  1'b0;
   else if(sdi_srst_axi)
     rx_crc_err_r_axi[13]  <=  1'b0;
   else if(rx_crc_errcnt[13])
     rx_crc_err_r_axi[13]  <=  1'b1;
   else if(rx_crc_err_clr_axi[13])
     rx_crc_err_r_axi[13]  <=  1'b0;
  end 

  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
   if(~axi_aresetn)
     rx_crc_err_r_axi[14]  <=  1'b0;
   else if(sdi_srst_axi)
     rx_crc_err_r_axi[14]  <=  1'b0;
   else if(rx_crc_errcnt[14])
     rx_crc_err_r_axi[14]  <=  1'b1;
   else if(rx_crc_err_clr_axi[14])
     rx_crc_err_r_axi[14]  <=  1'b0;
  end 

  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
   if(~axi_aresetn)
     rx_crc_err_r_axi[15]  <=  1'b0;
   else if(sdi_srst_axi)
     rx_crc_err_r_axi[15]  <=  1'b0;
   else if(rx_crc_errcnt[15])
     rx_crc_err_r_axi[15]  <=  1'b1;
   else if(rx_crc_err_clr_axi[15])
     rx_crc_err_r_axi[15]  <=  1'b0;
  end 

generate if(C_INCLUDE_VID_OVER_AXI) begin: gen_axi4s_if_intr
    assign module_interrupt = glbl_ier_axi ?(|(({underflow_r_axi,overflow_r_axi,video_unlock_r_axi,video_lock_r_axi}) & ({underflow_ie_axi,overflow_ie_axi,video_unlock_ie_axi,video_lock_ie_axi}))):
                    1'b0;

end else if(C_INCLUDE_SDI_BRIDGE) begin: gen_native_video_if_intr
    assign module_interrupt = glbl_ier_axi ?(|(({video_unlock_r_axi,video_lock_r_axi}) & ({video_unlock_ie_axi,video_lock_ie_axi}))):
                    1'b0;

end else begin: gen_native_sdi_if_intr
    assign module_interrupt = glbl_ier_axi ?(|(({video_unlock_r_axi,video_lock_r_axi}) & ({video_unlock_ie_axi,video_lock_ie_axi}))):
                    1'b0;

end
endgenerate

endmodule
