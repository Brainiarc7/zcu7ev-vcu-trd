
`timescale 1 ns / 1 ps

	module v_smpte_uhdsdi_tx_v1_0_0_s00_axi #
	(
      	parameter C_AXI4LITE_ENABLE              = 1, 
		parameter C_ADV_FEATURE                  = 0,
		parameter C_INCLUDE_VID_OVER_AXI         = 1,
		parameter C_INCLUDE_SDI_BRIDGE           = 1,
		parameter C_INCLUDE_TX_EDH_PROCESSOR     = 1,
		// Width of S_AXI data bus
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		// Width of S_AXI address bus
		parameter integer C_S_AXI_ADDR_WIDTH	= 8
	)
	(
        //R/W regsiter
		output wire [31:0] module_ctrl,
		output wire [31:0] sdi_tx_bridge_ctrl,
		output wire [31:0] axi4s_vid_out_ctrl,
		output wire [31:0] stat_reset,
		output reg  [10:0] tx_st352_line_f1,
		output reg  [10:0] tx_st352_line_f2,
		output reg  [31:0] tx_st352_data_ch0,
		output reg  [31:0] tx_st352_data_ch1,
		output reg  [31:0] tx_st352_data_ch2,
		output reg  [31:0] tx_st352_data_ch3,
		output reg  [31:0] tx_st352_data_ch4,
		output reg  [31:0] tx_st352_data_ch5,
		output reg  [31:0] tx_st352_data_ch6,
		output reg  [31:0] tx_st352_data_ch7,

        //statistics
        input wire tx_ce_align_err,	
        input wire [31:0] sts_sb,	
		input wire [31:0] sdi_tx_bridge_sts,
		input wire [31:0] axi4s_vid_out_sts1,
		input wire [31:0] axi4s_vid_out_sts2,
        //interrupts: 1 cycle pulse
		input wire  gttx_resetdone_int,
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
  reg  [31:0]   module_ctrl_reg_axi;
  reg           sdi_en_axi;
  reg           sdi_srst_axi;
  reg           sditx_bridge_en_axi;
  reg           axi4s_vid_out_en_axi;
  reg           glbl_ier_axi;
  reg           gttx_resetdone_r_axi;
  reg           tx_ce_align_err_r_axi;
  reg           axi4s_vid_lock_r_axi;
  reg           overflow_r_axi;
  reg           underflow_r_axi;
  reg           gttx_resetdone_clr_axi;
  reg           tx_ce_align_err_clr_axi;
  reg           axi4s_vid_lock_clr_axi;
  reg           overflow_clr_axi;
  reg           underflow_clr_axi;
  reg           gttx_resetdone_ie_axi;
  reg           tx_ce_align_err_ie_axi;
  reg           axi4s_vid_lock_ie_axi;
  reg           overflow_ie_axi;
  reg           underflow_ie_axi;
  //reg  [10:0]   tx_st352_line_f1_r_axi;  //TODO for 8K
  //reg  [10:0]   tx_st352_line_f2_r_axi;  //TODO for 8K
  wire          inc_tx_edh_proc_i;
  wire [1:0]    video_if_i;
  wire          inc_adv_feature_i;
 
  assign  module_ctrl[0]              =  sdi_en_axi;
  assign  module_ctrl[31:1]           =  module_ctrl_reg_axi[31:1];
  generate if(C_INCLUDE_VID_OVER_AXI || C_INCLUDE_SDI_BRIDGE) begin: en_sdi_brdge_ctrl_proc
    assign  sdi_tx_bridge_ctrl[0]       =  sditx_bridge_en_axi;
    assign  sdi_tx_bridge_ctrl[3:1]     =  3'd0;
    assign  sdi_tx_bridge_ctrl[6:4]     =  module_ctrl_reg_axi[6:4];
    assign  sdi_tx_bridge_ctrl[8:7]     =  module_ctrl_reg_axi[22:21];
    assign  sdi_tx_bridge_ctrl[31:9]    =  23'd0;
  end else begin: disab_sdi_brdge_ctrl_proc
    assign  sdi_tx_bridge_ctrl[0]       =  1'b0;
    assign  sdi_tx_bridge_ctrl[3:1]     =  3'd0;
    assign  sdi_tx_bridge_ctrl[6:4]     =  3'd0;
    assign  sdi_tx_bridge_ctrl[8:7]     =  2'd0;
    assign  sdi_tx_bridge_ctrl[31:9]    =  23'd0;
  end
  endgenerate
  generate if(C_INCLUDE_VID_OVER_AXI) begin: en_vid_out_ctrl_proc
    assign  axi4s_vid_out_ctrl[0]       =  axi4s_vid_out_en_axi;
    assign  axi4s_vid_out_ctrl[31:1]    =  31'd0;
  end else begin: disab_vid_out_ctrl_proc
    assign  axi4s_vid_out_ctrl[0]       =  1'b0;
    assign  axi4s_vid_out_ctrl[31:1]    =  31'd0;
  end
  endgenerate
  assign  stat_reset[0]               =  tx_ce_align_err_r_axi;
  assign  stat_reset[31:1]            =  31'd0;

  generate if(C_INCLUDE_TX_EDH_PROCESSOR) begin: gen_inc_tx_edh_proc
    assign  inc_tx_edh_proc_i  =  1'b1;   
  end else begin
    assign  inc_tx_edh_proc_i  =  1'b0;   
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
                     5'h00: axi_rdata <= {22'd0,axi4s_vid_out_en_axi,sditx_bridge_en_axi,6'd0,sdi_srst_axi,sdi_en_axi};
                     5'h01: axi_rdata <= module_ctrl_reg_axi;
                     5'h02: axi_rdata <= 32'd0;
                     5'h03: axi_rdata <= {31'd0,glbl_ier_axi};
                     5'h04: axi_rdata <= {21'd0,underflow_r_axi,overflow_r_axi,axi4s_vid_lock_r_axi,6'd0,tx_ce_align_err_r_axi,gttx_resetdone_r_axi};
                     5'h05: axi_rdata <= {21'd0,underflow_ie_axi,overflow_ie_axi,axi4s_vid_lock_ie_axi,6'd0,tx_ce_align_err_ie_axi,gttx_resetdone_ie_axi};
                     5'h06: axi_rdata <= {5'd0,tx_st352_line_f2,5'd0,tx_st352_line_f1};
                     5'h07: axi_rdata <= tx_st352_data_ch0;
                     5'h08: axi_rdata <= tx_st352_data_ch1;
                     5'h09: axi_rdata <= tx_st352_data_ch2;
                     5'h0a: axi_rdata <= tx_st352_data_ch3;
                     5'h0b: axi_rdata <= tx_st352_data_ch4;
                     5'h0c: axi_rdata <= tx_st352_data_ch5;
                     5'h0d: axi_rdata <= tx_st352_data_ch6;
                     5'h0e: axi_rdata <= tx_st352_data_ch7;
                     5'h0f: axi_rdata <= 32'h02000000;
                     5'h10: axi_rdata <= {27'd0,inc_adv_feature_i,video_if_i[1:0],inc_tx_edh_proc_i,1'b0};
                     5'h11: axi_rdata <= 32'd0;
                     5'h12: axi_rdata <= 32'd0;
                     5'h13: axi_rdata <= 32'd0;
                     5'h14: axi_rdata <= 32'd0;
                     5'h15: axi_rdata <= 32'd0;
                     5'h16: axi_rdata <= 32'd0;
                     5'h17: axi_rdata <= 32'd0;
                     5'h18: axi_rdata <= sts_sb;
                     5'h19: axi_rdata <= 32'd0;
                     5'h1a: axi_rdata <= {25'd0,sdi_tx_bridge_sts[6:4],3'd0,sdi_tx_bridge_sts[0]};
                     5'h1b: axi_rdata <= axi4s_vid_out_sts2;
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
          sditx_bridge_en_axi     <= 1'b0;
          axi4s_vid_out_en_axi    <= 1'b0;
          module_ctrl_reg_axi     <= 0;
          glbl_ier_axi            <= 0;
          gttx_resetdone_clr_axi  <= 0;
          tx_ce_align_err_clr_axi <= 0;
          axi4s_vid_lock_clr_axi  <= 0;
          overflow_clr_axi        <= 0;
          underflow_clr_axi       <= 0;
          gttx_resetdone_ie_axi   <= 0;
          tx_ce_align_err_ie_axi  <= 0;
          axi4s_vid_lock_ie_axi   <= 0;
          overflow_ie_axi         <= 0;
          underflow_ie_axi        <= 0;
          tx_st352_line_f1        <= 0;
	  tx_st352_line_f2        <= 0;
	  tx_st352_data_ch0       <= 0;
	  tx_st352_data_ch1       <= 0;
	  tx_st352_data_ch2       <= 0;
	  tx_st352_data_ch3       <= 0;
	  tx_st352_data_ch4       <= 0;
	  tx_st352_data_ch5       <= 0;
	  tx_st352_data_ch6       <= 0;
	  tx_st352_data_ch7       <= 0;
      end else begin
          module_ctrl_reg_axi[3:0]  <= 4'd0;
          module_ctrl_reg_axi[11]   <= 1'd0;
          module_ctrl_reg_axi[31:23]<= 9'd0;
          if(wr_req && axi_wvalid && ~axi_bvalid) begin
              case (wr_addr[6:2]) 
                  5'h00: begin
                           sdi_en_axi           <= axi_wdata[0];
                           sdi_srst_axi         <= axi_wdata[1];
                           sditx_bridge_en_axi  <= axi_wdata[8];
                           axi4s_vid_out_en_axi <= axi_wdata[9];
                         end
                  5'h01: begin 
                           module_ctrl_reg_axi[10:4]  <= axi_wdata[10:4];
                           module_ctrl_reg_axi[20:12] <= axi_wdata[20:12];
                           module_ctrl_reg_axi[22:21] <= axi_wdata[22:21];
                        end  
                  5'h03: glbl_ier_axi <= axi_wdata[0];
                  5'h04: begin
                           gttx_resetdone_clr_axi  <= axi_wdata[0];
                           tx_ce_align_err_clr_axi <= axi_wdata[1];
                           axi4s_vid_lock_clr_axi  <= axi_wdata[8];
                           overflow_clr_axi        <= axi_wdata[9];
                           underflow_clr_axi       <= axi_wdata[10];
                         end
                  5'h05: begin 
                           gttx_resetdone_ie_axi   <= axi_wdata[0];
                           tx_ce_align_err_ie_axi  <= axi_wdata[1];
                           axi4s_vid_lock_ie_axi   <= axi_wdata[8];
                           overflow_ie_axi         <= axi_wdata[9];
                           underflow_ie_axi        <= axi_wdata[10];
                         end
		  5'h06: begin 
			   tx_st352_line_f1        <=  axi_wdata[10:0];
		           tx_st352_line_f2        <=  axi_wdata[26:16];
			 end  
		  5'h07: tx_st352_data_ch0      <=  axi_wdata;
		  5'h08: tx_st352_data_ch1      <=  axi_wdata;
		  5'h09: tx_st352_data_ch2      <=  axi_wdata;
		  5'h0a: tx_st352_data_ch3      <=  axi_wdata;
		  5'h0b: tx_st352_data_ch4      <=  axi_wdata;
		  5'h0c: tx_st352_data_ch5      <=  axi_wdata;
		  5'h0d: tx_st352_data_ch6      <=  axi_wdata;
		  5'h0e: tx_st352_data_ch7      <=  axi_wdata;
              endcase
          end else begin
              gttx_resetdone_clr_axi  <= 0;
              tx_ce_align_err_clr_axi <= 0;
              axi4s_vid_lock_clr_axi  <= 0;
              overflow_clr_axi        <= 0;
              underflow_clr_axi       <= 0;
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
                     5'h00: axi_rdata <= {23'd0,sditx_bridge_en_axi,6'd0,sdi_srst_axi,sdi_en_axi};
                     5'h01: axi_rdata <= module_ctrl_reg_axi;
                     5'h02: axi_rdata <= 32'd0;
                     5'h03: axi_rdata <= {31'd0,glbl_ier_axi};
                     5'h04: axi_rdata <= {30'd0,tx_ce_align_err_r_axi,gttx_resetdone_r_axi};
                     5'h05: axi_rdata <= {30'd0,tx_ce_align_err_ie_axi,gttx_resetdone_ie_axi};
                     5'h06: axi_rdata <= {5'd0,tx_st352_line_f2,5'd0,tx_st352_line_f1};
                     5'h07: axi_rdata <= tx_st352_data_ch0;
                     5'h08: axi_rdata <= tx_st352_data_ch1;
                     5'h09: axi_rdata <= tx_st352_data_ch2;
                     5'h0a: axi_rdata <= tx_st352_data_ch3;
                     5'h0b: axi_rdata <= tx_st352_data_ch4;
                     5'h0c: axi_rdata <= tx_st352_data_ch5;
                     5'h0d: axi_rdata <= tx_st352_data_ch6;
                     5'h0e: axi_rdata <= tx_st352_data_ch7;
                     5'h0f: axi_rdata <= 32'h02000000;
                     5'h10: axi_rdata <= {27'd0,inc_adv_feature_i,video_if_i[1:0],inc_tx_edh_proc_i,1'b0};
                     5'h11: axi_rdata <= 32'd0;
                     5'h12: axi_rdata <= 32'd0;
                     5'h13: axi_rdata <= 32'd0;
                     5'h14: axi_rdata <= 32'd0;
                     5'h15: axi_rdata <= 32'd0;
                     5'h16: axi_rdata <= 32'd0;
                     5'h17: axi_rdata <= 32'd0;
                     5'h18: axi_rdata <= sts_sb;
                     5'h19: axi_rdata <= 32'd0;
                     5'h1a: axi_rdata <= {25'd0,sdi_tx_bridge_sts[6:4],3'd0,sdi_tx_bridge_sts[0]};
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
          sditx_bridge_en_axi     <= 1'b0;
          axi4s_vid_out_en_axi    <= 1'b0;
          module_ctrl_reg_axi     <= 0;
          glbl_ier_axi            <= 0;
          gttx_resetdone_clr_axi  <= 0;
          tx_ce_align_err_clr_axi <= 0;
          axi4s_vid_lock_clr_axi  <= 0;
          overflow_clr_axi        <= 0;
          underflow_clr_axi       <= 0;
          gttx_resetdone_ie_axi   <= 0;
          tx_ce_align_err_ie_axi  <= 0;
          axi4s_vid_lock_ie_axi   <= 0;
          overflow_ie_axi         <= 0;
          underflow_ie_axi        <= 0;
          tx_st352_line_f1        <= 0;
	  tx_st352_line_f2        <= 0;
	  tx_st352_data_ch0       <= 0;
	  tx_st352_data_ch1       <= 0;
	  tx_st352_data_ch2       <= 0;
	  tx_st352_data_ch3       <= 0;
	  tx_st352_data_ch4       <= 0;
	  tx_st352_data_ch5       <= 0;
	  tx_st352_data_ch6       <= 0;
	  tx_st352_data_ch7       <= 0;
      end else begin
          module_ctrl_reg_axi[3:0]  <= 4'd0;
          module_ctrl_reg_axi[11]   <= 1'd0;
          module_ctrl_reg_axi[31:23]<= 9'd0;
          if(wr_req && axi_wvalid && ~axi_bvalid) begin
              case (wr_addr[6:2]) 
                  5'h00: begin
                           sdi_en_axi           <= axi_wdata[0];
                           sdi_srst_axi         <= axi_wdata[1];
                           sditx_bridge_en_axi  <= axi_wdata[8];
                         end
                  5'h01: begin 
                           module_ctrl_reg_axi[10:4]  <= axi_wdata[10:4];
                           module_ctrl_reg_axi[20:12] <= axi_wdata[20:12];
                           module_ctrl_reg_axi[22:21] <= axi_wdata[22:21];
                        end  
                  5'h03: glbl_ier_axi <= axi_wdata[0];
                  5'h04: begin
                           gttx_resetdone_clr_axi  <= axi_wdata[0];
                           tx_ce_align_err_clr_axi <= axi_wdata[1];
                         end
                  5'h05: begin 
                           gttx_resetdone_ie_axi   <= axi_wdata[0];
                           tx_ce_align_err_ie_axi  <= axi_wdata[1];
                         end
		  5'h06: begin 
			   tx_st352_line_f1        <=  axi_wdata[10:0];
		           tx_st352_line_f2        <=  axi_wdata[26:16];
			 end  
		  5'h07: tx_st352_data_ch0      <=  axi_wdata;
		  5'h08: tx_st352_data_ch1      <=  axi_wdata;
		  5'h09: tx_st352_data_ch2      <=  axi_wdata;
		  5'h0a: tx_st352_data_ch3      <=  axi_wdata;
		  5'h0b: tx_st352_data_ch4      <=  axi_wdata;
		  5'h0c: tx_st352_data_ch5      <=  axi_wdata;
		  5'h0d: tx_st352_data_ch6      <=  axi_wdata;
		  5'h0e: tx_st352_data_ch7      <=  axi_wdata;
              endcase
          end else begin
              gttx_resetdone_clr_axi  <= 0;
              tx_ce_align_err_clr_axi <= 0;
              axi4s_vid_lock_clr_axi  <= 0;
              overflow_clr_axi        <= 0;
              underflow_clr_axi       <= 0;
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
                     5'h00: axi_rdata <= {30'd0,sdi_srst_axi,sdi_en_axi};
                     5'h01: axi_rdata <= module_ctrl_reg_axi;
                     5'h02: axi_rdata <= 32'd0;
                     5'h03: axi_rdata <= {31'd0,glbl_ier_axi};
                     5'h04: axi_rdata <= {30'd0,tx_ce_align_err_r_axi,gttx_resetdone_r_axi};
                     5'h05: axi_rdata <= {30'd0,tx_ce_align_err_ie_axi,gttx_resetdone_ie_axi};
                     5'h06: axi_rdata <= {5'd0,tx_st352_line_f2,5'd0,tx_st352_line_f1};
                     5'h07: axi_rdata <= tx_st352_data_ch0;
                     5'h08: axi_rdata <= tx_st352_data_ch1;
                     5'h09: axi_rdata <= tx_st352_data_ch2;
                     5'h0a: axi_rdata <= tx_st352_data_ch3;
                     5'h0b: axi_rdata <= tx_st352_data_ch4;
                     5'h0c: axi_rdata <= tx_st352_data_ch5;
                     5'h0d: axi_rdata <= tx_st352_data_ch6;
                     5'h0e: axi_rdata <= tx_st352_data_ch7;
                     5'h0f: axi_rdata <= 32'h02000000;
                     5'h10: axi_rdata <= {27'd0,inc_adv_feature_i,video_if_i[1:0],inc_tx_edh_proc_i,1'b0};
                     5'h11: axi_rdata <= 32'd0;
                     5'h12: axi_rdata <= 32'd0;
                     5'h13: axi_rdata <= 32'd0;
                     5'h14: axi_rdata <= 32'd0;
                     5'h15: axi_rdata <= 32'd0;
                     5'h16: axi_rdata <= 32'd0;
                     5'h17: axi_rdata <= 32'd0;
                     5'h18: axi_rdata <= sts_sb;
                     5'h19: axi_rdata <= 32'd0;
                     5'h1a: axi_rdata <= 32'd0;
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
          sditx_bridge_en_axi     <= 1'b0;
          axi4s_vid_out_en_axi    <= 1'b0;
          module_ctrl_reg_axi     <= 0;
          glbl_ier_axi            <= 0;
          gttx_resetdone_clr_axi  <= 0;
          tx_ce_align_err_clr_axi <= 0;
          axi4s_vid_lock_clr_axi  <= 0;
          overflow_clr_axi        <= 0;
          underflow_clr_axi       <= 0;
          gttx_resetdone_ie_axi   <= 0;
          tx_ce_align_err_ie_axi  <= 0;
          axi4s_vid_lock_ie_axi   <= 0;
          overflow_ie_axi         <= 0;
          underflow_ie_axi        <= 0;
          tx_st352_line_f1        <= 0;
	  tx_st352_line_f2        <= 0;
	  tx_st352_data_ch0       <= 0;
	  tx_st352_data_ch1       <= 0;
	  tx_st352_data_ch2       <= 0;
	  tx_st352_data_ch3       <= 0;
	  tx_st352_data_ch4       <= 0;
	  tx_st352_data_ch5       <= 0;
	  tx_st352_data_ch6       <= 0;
	  tx_st352_data_ch7       <= 0;
      end else begin
          module_ctrl_reg_axi[3:0]  <= 4'd0;
          module_ctrl_reg_axi[11]   <= 1'd0;
          module_ctrl_reg_axi[31:21]<= 11'd0;
          if(wr_req && axi_wvalid && ~axi_bvalid) begin
              case (wr_addr[6:2]) 
                  5'h00: begin
                           sdi_en_axi           <= axi_wdata[0];
                           sdi_srst_axi         <= axi_wdata[1];
                         end
                  5'h01: begin 
                           module_ctrl_reg_axi[10:4]  <= axi_wdata[10:4];
                           module_ctrl_reg_axi[20:12] <= axi_wdata[20:12];
                         end  
                  5'h03: glbl_ier_axi <= axi_wdata[0];
                  5'h04: begin
                           gttx_resetdone_clr_axi  <= axi_wdata[0];
                           tx_ce_align_err_clr_axi <= axi_wdata[1];
                         end
                  5'h05: begin 
                           gttx_resetdone_ie_axi   <= axi_wdata[0];
                           tx_ce_align_err_ie_axi  <= axi_wdata[1];
                         end
		  5'h06: begin 
			   tx_st352_line_f1        <=  axi_wdata[10:0];
		           tx_st352_line_f2        <=  axi_wdata[26:16];
			 end  
		  5'h07: tx_st352_data_ch0      <=  axi_wdata;
		  5'h08: tx_st352_data_ch1      <=  axi_wdata;
		  5'h09: tx_st352_data_ch2      <=  axi_wdata;
		  5'h0a: tx_st352_data_ch3      <=  axi_wdata;
		  5'h0b: tx_st352_data_ch4      <=  axi_wdata;
		  5'h0c: tx_st352_data_ch5      <=  axi_wdata;
		  5'h0d: tx_st352_data_ch6      <=  axi_wdata;
		  5'h0e: tx_st352_data_ch7      <=  axi_wdata;
              endcase
          end else begin
              gttx_resetdone_clr_axi  <= 0;
              tx_ce_align_err_clr_axi <= 0;
              axi4s_vid_lock_clr_axi  <= 0;
              overflow_clr_axi        <= 0;
              underflow_clr_axi       <= 0;
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
     gttx_resetdone_r_axi  <=  1'b0;
   else if(sdi_srst_axi)
     gttx_resetdone_r_axi  <=  1'b0;
   else if(gttx_resetdone_int)
     gttx_resetdone_r_axi  <=  1'b1;
   else if(gttx_resetdone_clr_axi)
     gttx_resetdone_r_axi  <=  1'b0;
  end   

  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
   if(~axi_aresetn)
     tx_ce_align_err_r_axi  <=  1'b0;
   else if(sdi_srst_axi)
     tx_ce_align_err_r_axi  <=  1'b0;
   else if(tx_ce_align_err)
     tx_ce_align_err_r_axi  <=  1'b1;
   else if(tx_ce_align_err_clr_axi)
     tx_ce_align_err_r_axi  <=  1'b0;
  end   

  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
   if(~axi_aresetn)
     axi4s_vid_lock_r_axi  <=  1'b0;
   else if(sdi_srst_axi)
     axi4s_vid_lock_r_axi  <=  1'b0;
   else if(axi4s_vid_out_sts1[0])
     axi4s_vid_lock_r_axi  <=  1'b1;
   else if(axi4s_vid_lock_clr_axi)
     axi4s_vid_lock_r_axi  <=  1'b0;
  end   

  always @(posedge axi_aclk or negedge axi_aresetn)
  begin
   if(~axi_aresetn)
     overflow_r_axi  <=  1'b0;
   else if(sdi_srst_axi)
     overflow_r_axi  <=  1'b0;
   else if(axi4s_vid_out_sts1[1])
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
   else if(axi4s_vid_out_sts1[2])
     underflow_r_axi  <=  1'b1;
   else if(underflow_clr_axi)
     underflow_r_axi  <=  1'b0;
  end   
  
generate if(C_INCLUDE_VID_OVER_AXI) begin: gen_axi4s_if_intr
    assign module_interrupt = glbl_ier_axi ?(|(({underflow_r_axi,overflow_r_axi,axi4s_vid_lock_r_axi,tx_ce_align_err_r_axi,gttx_resetdone_r_axi}) & ({underflow_ie_axi,overflow_ie_axi,axi4s_vid_lock_ie_axi,tx_ce_align_err_ie_axi,gttx_resetdone_ie_axi}))): 1'b0;

end else if(C_INCLUDE_SDI_BRIDGE) begin: gen_native_video_if_intr
    assign module_interrupt = glbl_ier_axi ?(|(({tx_ce_align_err_r_axi,gttx_resetdone_r_axi}) & ({tx_ce_align_err_ie_axi,gttx_resetdone_ie_axi}))): 1'b0;

end else begin: gen_native_sdi_if_intr
    assign module_interrupt = glbl_ier_axi ?(|(({tx_ce_align_err_r_axi,gttx_resetdone_r_axi}) & ({tx_ce_align_err_ie_axi,gttx_resetdone_ie_axi}))): 1'b0;

end
endgenerate


endmodule
