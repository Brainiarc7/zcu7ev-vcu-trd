//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Command: generate_target bd_22f3_wrapper.bd
//Design : bd_22f3_wrapper
//Purpose: IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module bd_22f3_wrapper
   (M_AXIS_CTRL_SB_RX_tdata,
    M_AXIS_CTRL_SB_RX_tready,
    M_AXIS_CTRL_SB_RX_tvalid,
    SDI_TS_DET_OUT_rx_t_family,
    SDI_TS_DET_OUT_rx_t_locked,
    SDI_TS_DET_OUT_rx_t_rate,
    SDI_TS_DET_OUT_rx_t_scan,
    S_AXIS_RX_tdata,
    S_AXIS_RX_tready,
    S_AXIS_RX_tuser,
    S_AXIS_RX_tvalid,
    S_AXIS_STS_SB_RX_tdata,
    S_AXIS_STS_SB_RX_tready,
    S_AXIS_STS_SB_RX_tvalid,
    S_AXI_CTRL_araddr,
    S_AXI_CTRL_arprot,
    S_AXI_CTRL_arready,
    S_AXI_CTRL_arvalid,
    S_AXI_CTRL_awaddr,
    S_AXI_CTRL_awprot,
    S_AXI_CTRL_awready,
    S_AXI_CTRL_awvalid,
    S_AXI_CTRL_bready,
    S_AXI_CTRL_bresp,
    S_AXI_CTRL_bvalid,
    S_AXI_CTRL_rdata,
    S_AXI_CTRL_rready,
    S_AXI_CTRL_rresp,
    S_AXI_CTRL_rvalid,
    S_AXI_CTRL_wdata,
    S_AXI_CTRL_wready,
    S_AXI_CTRL_wstrb,
    S_AXI_CTRL_wvalid,
    VIDEO_OUT_tdata,
    VIDEO_OUT_tlast,
    VIDEO_OUT_tready,
    VIDEO_OUT_tuser,
    VIDEO_OUT_tvalid,
    fid,
    s_axi_aclk,
    s_axi_arstn,
    sdi_rx_clk,
    sdi_rx_irq,
    sdi_rx_rst,
    video_out_arstn,
    video_out_clk);
  output [31:0]M_AXIS_CTRL_SB_RX_tdata;
  input M_AXIS_CTRL_SB_RX_tready;
  output M_AXIS_CTRL_SB_RX_tvalid;
  output [3:0]SDI_TS_DET_OUT_rx_t_family;
  output SDI_TS_DET_OUT_rx_t_locked;
  output [3:0]SDI_TS_DET_OUT_rx_t_rate;
  output SDI_TS_DET_OUT_rx_t_scan;
  input [39:0]S_AXIS_RX_tdata;
  output S_AXIS_RX_tready;
  input [31:0]S_AXIS_RX_tuser;
  input S_AXIS_RX_tvalid;
  input [31:0]S_AXIS_STS_SB_RX_tdata;
  output S_AXIS_STS_SB_RX_tready;
  input S_AXIS_STS_SB_RX_tvalid;
  input [8:0]S_AXI_CTRL_araddr;
  input [2:0]S_AXI_CTRL_arprot;
  output S_AXI_CTRL_arready;
  input S_AXI_CTRL_arvalid;
  input [8:0]S_AXI_CTRL_awaddr;
  input [2:0]S_AXI_CTRL_awprot;
  output S_AXI_CTRL_awready;
  input S_AXI_CTRL_awvalid;
  input S_AXI_CTRL_bready;
  output [1:0]S_AXI_CTRL_bresp;
  output S_AXI_CTRL_bvalid;
  output [31:0]S_AXI_CTRL_rdata;
  input S_AXI_CTRL_rready;
  output [1:0]S_AXI_CTRL_rresp;
  output S_AXI_CTRL_rvalid;
  input [31:0]S_AXI_CTRL_wdata;
  output S_AXI_CTRL_wready;
  input [3:0]S_AXI_CTRL_wstrb;
  input S_AXI_CTRL_wvalid;
  output [63:0]VIDEO_OUT_tdata;
  output VIDEO_OUT_tlast;
  input VIDEO_OUT_tready;
  output VIDEO_OUT_tuser;
  output VIDEO_OUT_tvalid;
  output fid;
  input s_axi_aclk;
  input s_axi_arstn;
  input sdi_rx_clk;
  output sdi_rx_irq;
  input sdi_rx_rst;
  input video_out_arstn;
  input video_out_clk;

  wire [31:0]M_AXIS_CTRL_SB_RX_tdata;
  wire M_AXIS_CTRL_SB_RX_tready;
  wire M_AXIS_CTRL_SB_RX_tvalid;
  wire [3:0]SDI_TS_DET_OUT_rx_t_family;
  wire SDI_TS_DET_OUT_rx_t_locked;
  wire [3:0]SDI_TS_DET_OUT_rx_t_rate;
  wire SDI_TS_DET_OUT_rx_t_scan;
  wire [39:0]S_AXIS_RX_tdata;
  wire S_AXIS_RX_tready;
  wire [31:0]S_AXIS_RX_tuser;
  wire S_AXIS_RX_tvalid;
  wire [31:0]S_AXIS_STS_SB_RX_tdata;
  wire S_AXIS_STS_SB_RX_tready;
  wire S_AXIS_STS_SB_RX_tvalid;
  wire [8:0]S_AXI_CTRL_araddr;
  wire [2:0]S_AXI_CTRL_arprot;
  wire S_AXI_CTRL_arready;
  wire S_AXI_CTRL_arvalid;
  wire [8:0]S_AXI_CTRL_awaddr;
  wire [2:0]S_AXI_CTRL_awprot;
  wire S_AXI_CTRL_awready;
  wire S_AXI_CTRL_awvalid;
  wire S_AXI_CTRL_bready;
  wire [1:0]S_AXI_CTRL_bresp;
  wire S_AXI_CTRL_bvalid;
  wire [31:0]S_AXI_CTRL_rdata;
  wire S_AXI_CTRL_rready;
  wire [1:0]S_AXI_CTRL_rresp;
  wire S_AXI_CTRL_rvalid;
  wire [31:0]S_AXI_CTRL_wdata;
  wire S_AXI_CTRL_wready;
  wire [3:0]S_AXI_CTRL_wstrb;
  wire S_AXI_CTRL_wvalid;
  wire [63:0]VIDEO_OUT_tdata;
  wire VIDEO_OUT_tlast;
  wire VIDEO_OUT_tready;
  wire VIDEO_OUT_tuser;
  wire VIDEO_OUT_tvalid;
  wire fid;
  wire s_axi_aclk;
  wire s_axi_arstn;
  wire sdi_rx_clk;
  wire sdi_rx_irq;
  wire sdi_rx_rst;
  wire video_out_arstn;
  wire video_out_clk;

  bd_22f3 bd_22f3_i
       (.M_AXIS_CTRL_SB_RX_tdata(M_AXIS_CTRL_SB_RX_tdata),
        .M_AXIS_CTRL_SB_RX_tready(M_AXIS_CTRL_SB_RX_tready),
        .M_AXIS_CTRL_SB_RX_tvalid(M_AXIS_CTRL_SB_RX_tvalid),
        .SDI_TS_DET_OUT_rx_t_family(SDI_TS_DET_OUT_rx_t_family),
        .SDI_TS_DET_OUT_rx_t_locked(SDI_TS_DET_OUT_rx_t_locked),
        .SDI_TS_DET_OUT_rx_t_rate(SDI_TS_DET_OUT_rx_t_rate),
        .SDI_TS_DET_OUT_rx_t_scan(SDI_TS_DET_OUT_rx_t_scan),
        .S_AXIS_RX_tdata(S_AXIS_RX_tdata),
        .S_AXIS_RX_tready(S_AXIS_RX_tready),
        .S_AXIS_RX_tuser(S_AXIS_RX_tuser),
        .S_AXIS_RX_tvalid(S_AXIS_RX_tvalid),
        .S_AXIS_STS_SB_RX_tdata(S_AXIS_STS_SB_RX_tdata),
        .S_AXIS_STS_SB_RX_tready(S_AXIS_STS_SB_RX_tready),
        .S_AXIS_STS_SB_RX_tvalid(S_AXIS_STS_SB_RX_tvalid),
        .S_AXI_CTRL_araddr(S_AXI_CTRL_araddr),
        .S_AXI_CTRL_arprot(S_AXI_CTRL_arprot),
        .S_AXI_CTRL_arready(S_AXI_CTRL_arready),
        .S_AXI_CTRL_arvalid(S_AXI_CTRL_arvalid),
        .S_AXI_CTRL_awaddr(S_AXI_CTRL_awaddr),
        .S_AXI_CTRL_awprot(S_AXI_CTRL_awprot),
        .S_AXI_CTRL_awready(S_AXI_CTRL_awready),
        .S_AXI_CTRL_awvalid(S_AXI_CTRL_awvalid),
        .S_AXI_CTRL_bready(S_AXI_CTRL_bready),
        .S_AXI_CTRL_bresp(S_AXI_CTRL_bresp),
        .S_AXI_CTRL_bvalid(S_AXI_CTRL_bvalid),
        .S_AXI_CTRL_rdata(S_AXI_CTRL_rdata),
        .S_AXI_CTRL_rready(S_AXI_CTRL_rready),
        .S_AXI_CTRL_rresp(S_AXI_CTRL_rresp),
        .S_AXI_CTRL_rvalid(S_AXI_CTRL_rvalid),
        .S_AXI_CTRL_wdata(S_AXI_CTRL_wdata),
        .S_AXI_CTRL_wready(S_AXI_CTRL_wready),
        .S_AXI_CTRL_wstrb(S_AXI_CTRL_wstrb),
        .S_AXI_CTRL_wvalid(S_AXI_CTRL_wvalid),
        .VIDEO_OUT_tdata(VIDEO_OUT_tdata),
        .VIDEO_OUT_tlast(VIDEO_OUT_tlast),
        .VIDEO_OUT_tready(VIDEO_OUT_tready),
        .VIDEO_OUT_tuser(VIDEO_OUT_tuser),
        .VIDEO_OUT_tvalid(VIDEO_OUT_tvalid),
        .fid(fid),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_arstn(s_axi_arstn),
        .sdi_rx_clk(sdi_rx_clk),
        .sdi_rx_irq(sdi_rx_irq),
        .sdi_rx_rst(sdi_rx_rst),
        .video_out_arstn(video_out_arstn),
        .video_out_clk(video_out_clk));
endmodule
