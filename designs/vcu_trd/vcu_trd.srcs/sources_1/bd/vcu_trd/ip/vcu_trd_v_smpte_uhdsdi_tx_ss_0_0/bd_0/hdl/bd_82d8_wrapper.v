//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Command: generate_target bd_82d8_wrapper.bd
//Design : bd_82d8_wrapper
//Purpose: IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module bd_82d8_wrapper
   (M_AXIS_CTRL_SB_TX_tdata,
    M_AXIS_CTRL_SB_TX_tready,
    M_AXIS_CTRL_SB_TX_tvalid,
    M_AXIS_TX_tdata,
    M_AXIS_TX_tready,
    M_AXIS_TX_tuser,
    M_AXIS_TX_tvalid,
    S_AXIS_STS_SB_TX_tdata,
    S_AXIS_STS_SB_TX_tready,
    S_AXIS_STS_SB_TX_tvalid,
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
    VIDEO_IN_tdata,
    VIDEO_IN_tlast,
    VIDEO_IN_tready,
    VIDEO_IN_tuser,
    VIDEO_IN_tvalid,
    fid,
    s_axi_aclk,
    s_axi_arstn,
    sdi_tx_clk,
    sdi_tx_irq,
    sdi_tx_rst,
    video_in_arstn,
    video_in_clk,
    vtc_irq);
  output [31:0]M_AXIS_CTRL_SB_TX_tdata;
  input M_AXIS_CTRL_SB_TX_tready;
  output M_AXIS_CTRL_SB_TX_tvalid;
  output [39:0]M_AXIS_TX_tdata;
  input M_AXIS_TX_tready;
  output [31:0]M_AXIS_TX_tuser;
  output M_AXIS_TX_tvalid;
  input [31:0]S_AXIS_STS_SB_TX_tdata;
  output S_AXIS_STS_SB_TX_tready;
  input S_AXIS_STS_SB_TX_tvalid;
  input [16:0]S_AXI_CTRL_araddr;
  input [2:0]S_AXI_CTRL_arprot;
  output [0:0]S_AXI_CTRL_arready;
  input [0:0]S_AXI_CTRL_arvalid;
  input [16:0]S_AXI_CTRL_awaddr;
  input [2:0]S_AXI_CTRL_awprot;
  output [0:0]S_AXI_CTRL_awready;
  input [0:0]S_AXI_CTRL_awvalid;
  input [0:0]S_AXI_CTRL_bready;
  output [1:0]S_AXI_CTRL_bresp;
  output [0:0]S_AXI_CTRL_bvalid;
  output [31:0]S_AXI_CTRL_rdata;
  input [0:0]S_AXI_CTRL_rready;
  output [1:0]S_AXI_CTRL_rresp;
  output [0:0]S_AXI_CTRL_rvalid;
  input [31:0]S_AXI_CTRL_wdata;
  output [0:0]S_AXI_CTRL_wready;
  input [3:0]S_AXI_CTRL_wstrb;
  input [0:0]S_AXI_CTRL_wvalid;
  input [63:0]VIDEO_IN_tdata;
  input VIDEO_IN_tlast;
  output VIDEO_IN_tready;
  input VIDEO_IN_tuser;
  input VIDEO_IN_tvalid;
  input fid;
  input s_axi_aclk;
  input s_axi_arstn;
  input sdi_tx_clk;
  output sdi_tx_irq;
  input sdi_tx_rst;
  input video_in_arstn;
  input video_in_clk;
  output vtc_irq;

  wire [31:0]M_AXIS_CTRL_SB_TX_tdata;
  wire M_AXIS_CTRL_SB_TX_tready;
  wire M_AXIS_CTRL_SB_TX_tvalid;
  wire [39:0]M_AXIS_TX_tdata;
  wire M_AXIS_TX_tready;
  wire [31:0]M_AXIS_TX_tuser;
  wire M_AXIS_TX_tvalid;
  wire [31:0]S_AXIS_STS_SB_TX_tdata;
  wire S_AXIS_STS_SB_TX_tready;
  wire S_AXIS_STS_SB_TX_tvalid;
  wire [16:0]S_AXI_CTRL_araddr;
  wire [2:0]S_AXI_CTRL_arprot;
  wire [0:0]S_AXI_CTRL_arready;
  wire [0:0]S_AXI_CTRL_arvalid;
  wire [16:0]S_AXI_CTRL_awaddr;
  wire [2:0]S_AXI_CTRL_awprot;
  wire [0:0]S_AXI_CTRL_awready;
  wire [0:0]S_AXI_CTRL_awvalid;
  wire [0:0]S_AXI_CTRL_bready;
  wire [1:0]S_AXI_CTRL_bresp;
  wire [0:0]S_AXI_CTRL_bvalid;
  wire [31:0]S_AXI_CTRL_rdata;
  wire [0:0]S_AXI_CTRL_rready;
  wire [1:0]S_AXI_CTRL_rresp;
  wire [0:0]S_AXI_CTRL_rvalid;
  wire [31:0]S_AXI_CTRL_wdata;
  wire [0:0]S_AXI_CTRL_wready;
  wire [3:0]S_AXI_CTRL_wstrb;
  wire [0:0]S_AXI_CTRL_wvalid;
  wire [63:0]VIDEO_IN_tdata;
  wire VIDEO_IN_tlast;
  wire VIDEO_IN_tready;
  wire VIDEO_IN_tuser;
  wire VIDEO_IN_tvalid;
  wire fid;
  wire s_axi_aclk;
  wire s_axi_arstn;
  wire sdi_tx_clk;
  wire sdi_tx_irq;
  wire sdi_tx_rst;
  wire video_in_arstn;
  wire video_in_clk;
  wire vtc_irq;

  bd_82d8 bd_82d8_i
       (.M_AXIS_CTRL_SB_TX_tdata(M_AXIS_CTRL_SB_TX_tdata),
        .M_AXIS_CTRL_SB_TX_tready(M_AXIS_CTRL_SB_TX_tready),
        .M_AXIS_CTRL_SB_TX_tvalid(M_AXIS_CTRL_SB_TX_tvalid),
        .M_AXIS_TX_tdata(M_AXIS_TX_tdata),
        .M_AXIS_TX_tready(M_AXIS_TX_tready),
        .M_AXIS_TX_tuser(M_AXIS_TX_tuser),
        .M_AXIS_TX_tvalid(M_AXIS_TX_tvalid),
        .S_AXIS_STS_SB_TX_tdata(S_AXIS_STS_SB_TX_tdata),
        .S_AXIS_STS_SB_TX_tready(S_AXIS_STS_SB_TX_tready),
        .S_AXIS_STS_SB_TX_tvalid(S_AXIS_STS_SB_TX_tvalid),
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
        .VIDEO_IN_tdata(VIDEO_IN_tdata),
        .VIDEO_IN_tlast(VIDEO_IN_tlast),
        .VIDEO_IN_tready(VIDEO_IN_tready),
        .VIDEO_IN_tuser(VIDEO_IN_tuser),
        .VIDEO_IN_tvalid(VIDEO_IN_tvalid),
        .fid(fid),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_arstn(s_axi_arstn),
        .sdi_tx_clk(sdi_tx_clk),
        .sdi_tx_irq(sdi_tx_irq),
        .sdi_tx_rst(sdi_tx_rst),
        .video_in_arstn(video_in_arstn),
        .video_in_clk(video_in_clk),
        .vtc_irq(vtc_irq));
endmodule
