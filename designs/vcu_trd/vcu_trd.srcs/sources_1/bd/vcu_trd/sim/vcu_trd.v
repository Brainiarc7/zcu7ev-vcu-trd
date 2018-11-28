//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.2 (lin64) Build 2258646 Thu Jun 14 20:02:38 MDT 2018
//Date        : Wed Nov 28 15:35:41 2018
//Host        : kenierkiller running 64-bit Ubuntu 18.04.1 LTS
//Command     : generate_target vcu_trd.bd
//Design      : vcu_trd
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module m00_couplers_imp_129FAK3
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arprot,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awprot,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arprot,
    S_AXI_arready,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awprot,
    S_AXI_awready,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [39:0]M_AXI_araddr;
  output [2:0]M_AXI_arprot;
  input [0:0]M_AXI_arready;
  output [0:0]M_AXI_arvalid;
  output [39:0]M_AXI_awaddr;
  output [2:0]M_AXI_awprot;
  input [0:0]M_AXI_awready;
  output [0:0]M_AXI_awvalid;
  output [0:0]M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input [0:0]M_AXI_bvalid;
  input [31:0]M_AXI_rdata;
  output [0:0]M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input [0:0]M_AXI_rvalid;
  output [31:0]M_AXI_wdata;
  input [0:0]M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output [0:0]M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [39:0]S_AXI_araddr;
  input [2:0]S_AXI_arprot;
  output [0:0]S_AXI_arready;
  input [0:0]S_AXI_arvalid;
  input [39:0]S_AXI_awaddr;
  input [2:0]S_AXI_awprot;
  output [0:0]S_AXI_awready;
  input [0:0]S_AXI_awvalid;
  input [0:0]S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output [0:0]S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  input [0:0]S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output [0:0]S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  output [0:0]S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input [0:0]S_AXI_wvalid;

  wire [39:0]m00_couplers_to_m00_couplers_ARADDR;
  wire [2:0]m00_couplers_to_m00_couplers_ARPROT;
  wire [0:0]m00_couplers_to_m00_couplers_ARREADY;
  wire [0:0]m00_couplers_to_m00_couplers_ARVALID;
  wire [39:0]m00_couplers_to_m00_couplers_AWADDR;
  wire [2:0]m00_couplers_to_m00_couplers_AWPROT;
  wire [0:0]m00_couplers_to_m00_couplers_AWREADY;
  wire [0:0]m00_couplers_to_m00_couplers_AWVALID;
  wire [0:0]m00_couplers_to_m00_couplers_BREADY;
  wire [1:0]m00_couplers_to_m00_couplers_BRESP;
  wire [0:0]m00_couplers_to_m00_couplers_BVALID;
  wire [31:0]m00_couplers_to_m00_couplers_RDATA;
  wire [0:0]m00_couplers_to_m00_couplers_RREADY;
  wire [1:0]m00_couplers_to_m00_couplers_RRESP;
  wire [0:0]m00_couplers_to_m00_couplers_RVALID;
  wire [31:0]m00_couplers_to_m00_couplers_WDATA;
  wire [0:0]m00_couplers_to_m00_couplers_WREADY;
  wire [3:0]m00_couplers_to_m00_couplers_WSTRB;
  wire [0:0]m00_couplers_to_m00_couplers_WVALID;

  assign M_AXI_araddr[39:0] = m00_couplers_to_m00_couplers_ARADDR;
  assign M_AXI_arprot[2:0] = m00_couplers_to_m00_couplers_ARPROT;
  assign M_AXI_arvalid[0] = m00_couplers_to_m00_couplers_ARVALID;
  assign M_AXI_awaddr[39:0] = m00_couplers_to_m00_couplers_AWADDR;
  assign M_AXI_awprot[2:0] = m00_couplers_to_m00_couplers_AWPROT;
  assign M_AXI_awvalid[0] = m00_couplers_to_m00_couplers_AWVALID;
  assign M_AXI_bready[0] = m00_couplers_to_m00_couplers_BREADY;
  assign M_AXI_rready[0] = m00_couplers_to_m00_couplers_RREADY;
  assign M_AXI_wdata[31:0] = m00_couplers_to_m00_couplers_WDATA;
  assign M_AXI_wstrb[3:0] = m00_couplers_to_m00_couplers_WSTRB;
  assign M_AXI_wvalid[0] = m00_couplers_to_m00_couplers_WVALID;
  assign S_AXI_arready[0] = m00_couplers_to_m00_couplers_ARREADY;
  assign S_AXI_awready[0] = m00_couplers_to_m00_couplers_AWREADY;
  assign S_AXI_bresp[1:0] = m00_couplers_to_m00_couplers_BRESP;
  assign S_AXI_bvalid[0] = m00_couplers_to_m00_couplers_BVALID;
  assign S_AXI_rdata[31:0] = m00_couplers_to_m00_couplers_RDATA;
  assign S_AXI_rresp[1:0] = m00_couplers_to_m00_couplers_RRESP;
  assign S_AXI_rvalid[0] = m00_couplers_to_m00_couplers_RVALID;
  assign S_AXI_wready[0] = m00_couplers_to_m00_couplers_WREADY;
  assign m00_couplers_to_m00_couplers_ARADDR = S_AXI_araddr[39:0];
  assign m00_couplers_to_m00_couplers_ARPROT = S_AXI_arprot[2:0];
  assign m00_couplers_to_m00_couplers_ARREADY = M_AXI_arready[0];
  assign m00_couplers_to_m00_couplers_ARVALID = S_AXI_arvalid[0];
  assign m00_couplers_to_m00_couplers_AWADDR = S_AXI_awaddr[39:0];
  assign m00_couplers_to_m00_couplers_AWPROT = S_AXI_awprot[2:0];
  assign m00_couplers_to_m00_couplers_AWREADY = M_AXI_awready[0];
  assign m00_couplers_to_m00_couplers_AWVALID = S_AXI_awvalid[0];
  assign m00_couplers_to_m00_couplers_BREADY = S_AXI_bready[0];
  assign m00_couplers_to_m00_couplers_BRESP = M_AXI_bresp[1:0];
  assign m00_couplers_to_m00_couplers_BVALID = M_AXI_bvalid[0];
  assign m00_couplers_to_m00_couplers_RDATA = M_AXI_rdata[31:0];
  assign m00_couplers_to_m00_couplers_RREADY = S_AXI_rready[0];
  assign m00_couplers_to_m00_couplers_RRESP = M_AXI_rresp[1:0];
  assign m00_couplers_to_m00_couplers_RVALID = M_AXI_rvalid[0];
  assign m00_couplers_to_m00_couplers_WDATA = S_AXI_wdata[31:0];
  assign m00_couplers_to_m00_couplers_WREADY = M_AXI_wready[0];
  assign m00_couplers_to_m00_couplers_WSTRB = S_AXI_wstrb[3:0];
  assign m00_couplers_to_m00_couplers_WVALID = S_AXI_wvalid[0];
endmodule

module m01_couplers_imp_3YGOS0
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arprot,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awprot,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arprot,
    S_AXI_arready,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awprot,
    S_AXI_awready,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [39:0]M_AXI_araddr;
  output [2:0]M_AXI_arprot;
  input M_AXI_arready;
  output M_AXI_arvalid;
  output [39:0]M_AXI_awaddr;
  output [2:0]M_AXI_awprot;
  input M_AXI_awready;
  output M_AXI_awvalid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input M_AXI_bvalid;
  input [31:0]M_AXI_rdata;
  output M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input M_AXI_rvalid;
  output [31:0]M_AXI_wdata;
  input M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [39:0]S_AXI_araddr;
  input [2:0]S_AXI_arprot;
  output S_AXI_arready;
  input S_AXI_arvalid;
  input [39:0]S_AXI_awaddr;
  input [2:0]S_AXI_awprot;
  output S_AXI_awready;
  input S_AXI_awvalid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input S_AXI_wvalid;

  wire [39:0]m01_couplers_to_m01_couplers_ARADDR;
  wire [2:0]m01_couplers_to_m01_couplers_ARPROT;
  wire m01_couplers_to_m01_couplers_ARREADY;
  wire m01_couplers_to_m01_couplers_ARVALID;
  wire [39:0]m01_couplers_to_m01_couplers_AWADDR;
  wire [2:0]m01_couplers_to_m01_couplers_AWPROT;
  wire m01_couplers_to_m01_couplers_AWREADY;
  wire m01_couplers_to_m01_couplers_AWVALID;
  wire m01_couplers_to_m01_couplers_BREADY;
  wire [1:0]m01_couplers_to_m01_couplers_BRESP;
  wire m01_couplers_to_m01_couplers_BVALID;
  wire [31:0]m01_couplers_to_m01_couplers_RDATA;
  wire m01_couplers_to_m01_couplers_RREADY;
  wire [1:0]m01_couplers_to_m01_couplers_RRESP;
  wire m01_couplers_to_m01_couplers_RVALID;
  wire [31:0]m01_couplers_to_m01_couplers_WDATA;
  wire m01_couplers_to_m01_couplers_WREADY;
  wire [3:0]m01_couplers_to_m01_couplers_WSTRB;
  wire m01_couplers_to_m01_couplers_WVALID;

  assign M_AXI_araddr[39:0] = m01_couplers_to_m01_couplers_ARADDR;
  assign M_AXI_arprot[2:0] = m01_couplers_to_m01_couplers_ARPROT;
  assign M_AXI_arvalid = m01_couplers_to_m01_couplers_ARVALID;
  assign M_AXI_awaddr[39:0] = m01_couplers_to_m01_couplers_AWADDR;
  assign M_AXI_awprot[2:0] = m01_couplers_to_m01_couplers_AWPROT;
  assign M_AXI_awvalid = m01_couplers_to_m01_couplers_AWVALID;
  assign M_AXI_bready = m01_couplers_to_m01_couplers_BREADY;
  assign M_AXI_rready = m01_couplers_to_m01_couplers_RREADY;
  assign M_AXI_wdata[31:0] = m01_couplers_to_m01_couplers_WDATA;
  assign M_AXI_wstrb[3:0] = m01_couplers_to_m01_couplers_WSTRB;
  assign M_AXI_wvalid = m01_couplers_to_m01_couplers_WVALID;
  assign S_AXI_arready = m01_couplers_to_m01_couplers_ARREADY;
  assign S_AXI_awready = m01_couplers_to_m01_couplers_AWREADY;
  assign S_AXI_bresp[1:0] = m01_couplers_to_m01_couplers_BRESP;
  assign S_AXI_bvalid = m01_couplers_to_m01_couplers_BVALID;
  assign S_AXI_rdata[31:0] = m01_couplers_to_m01_couplers_RDATA;
  assign S_AXI_rresp[1:0] = m01_couplers_to_m01_couplers_RRESP;
  assign S_AXI_rvalid = m01_couplers_to_m01_couplers_RVALID;
  assign S_AXI_wready = m01_couplers_to_m01_couplers_WREADY;
  assign m01_couplers_to_m01_couplers_ARADDR = S_AXI_araddr[39:0];
  assign m01_couplers_to_m01_couplers_ARPROT = S_AXI_arprot[2:0];
  assign m01_couplers_to_m01_couplers_ARREADY = M_AXI_arready;
  assign m01_couplers_to_m01_couplers_ARVALID = S_AXI_arvalid;
  assign m01_couplers_to_m01_couplers_AWADDR = S_AXI_awaddr[39:0];
  assign m01_couplers_to_m01_couplers_AWPROT = S_AXI_awprot[2:0];
  assign m01_couplers_to_m01_couplers_AWREADY = M_AXI_awready;
  assign m01_couplers_to_m01_couplers_AWVALID = S_AXI_awvalid;
  assign m01_couplers_to_m01_couplers_BREADY = S_AXI_bready;
  assign m01_couplers_to_m01_couplers_BRESP = M_AXI_bresp[1:0];
  assign m01_couplers_to_m01_couplers_BVALID = M_AXI_bvalid;
  assign m01_couplers_to_m01_couplers_RDATA = M_AXI_rdata[31:0];
  assign m01_couplers_to_m01_couplers_RREADY = S_AXI_rready;
  assign m01_couplers_to_m01_couplers_RRESP = M_AXI_rresp[1:0];
  assign m01_couplers_to_m01_couplers_RVALID = M_AXI_rvalid;
  assign m01_couplers_to_m01_couplers_WDATA = S_AXI_wdata[31:0];
  assign m01_couplers_to_m01_couplers_WREADY = M_AXI_wready;
  assign m01_couplers_to_m01_couplers_WSTRB = S_AXI_wstrb[3:0];
  assign m01_couplers_to_m01_couplers_WVALID = S_AXI_wvalid;
endmodule

module m02_couplers_imp_Q1FOXG
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arprot,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awprot,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arprot,
    S_AXI_arready,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awprot,
    S_AXI_awready,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [39:0]M_AXI_araddr;
  output [2:0]M_AXI_arprot;
  input [0:0]M_AXI_arready;
  output [0:0]M_AXI_arvalid;
  output [39:0]M_AXI_awaddr;
  output [2:0]M_AXI_awprot;
  input [0:0]M_AXI_awready;
  output [0:0]M_AXI_awvalid;
  output [0:0]M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input [0:0]M_AXI_bvalid;
  input [31:0]M_AXI_rdata;
  output [0:0]M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input [0:0]M_AXI_rvalid;
  output [31:0]M_AXI_wdata;
  input [0:0]M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output [0:0]M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [39:0]S_AXI_araddr;
  input [2:0]S_AXI_arprot;
  output [0:0]S_AXI_arready;
  input [0:0]S_AXI_arvalid;
  input [39:0]S_AXI_awaddr;
  input [2:0]S_AXI_awprot;
  output [0:0]S_AXI_awready;
  input [0:0]S_AXI_awvalid;
  input [0:0]S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output [0:0]S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  input [0:0]S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output [0:0]S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  output [0:0]S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input [0:0]S_AXI_wvalid;

  wire [39:0]m02_couplers_to_m02_couplers_ARADDR;
  wire [2:0]m02_couplers_to_m02_couplers_ARPROT;
  wire [0:0]m02_couplers_to_m02_couplers_ARREADY;
  wire [0:0]m02_couplers_to_m02_couplers_ARVALID;
  wire [39:0]m02_couplers_to_m02_couplers_AWADDR;
  wire [2:0]m02_couplers_to_m02_couplers_AWPROT;
  wire [0:0]m02_couplers_to_m02_couplers_AWREADY;
  wire [0:0]m02_couplers_to_m02_couplers_AWVALID;
  wire [0:0]m02_couplers_to_m02_couplers_BREADY;
  wire [1:0]m02_couplers_to_m02_couplers_BRESP;
  wire [0:0]m02_couplers_to_m02_couplers_BVALID;
  wire [31:0]m02_couplers_to_m02_couplers_RDATA;
  wire [0:0]m02_couplers_to_m02_couplers_RREADY;
  wire [1:0]m02_couplers_to_m02_couplers_RRESP;
  wire [0:0]m02_couplers_to_m02_couplers_RVALID;
  wire [31:0]m02_couplers_to_m02_couplers_WDATA;
  wire [0:0]m02_couplers_to_m02_couplers_WREADY;
  wire [3:0]m02_couplers_to_m02_couplers_WSTRB;
  wire [0:0]m02_couplers_to_m02_couplers_WVALID;

  assign M_AXI_araddr[39:0] = m02_couplers_to_m02_couplers_ARADDR;
  assign M_AXI_arprot[2:0] = m02_couplers_to_m02_couplers_ARPROT;
  assign M_AXI_arvalid[0] = m02_couplers_to_m02_couplers_ARVALID;
  assign M_AXI_awaddr[39:0] = m02_couplers_to_m02_couplers_AWADDR;
  assign M_AXI_awprot[2:0] = m02_couplers_to_m02_couplers_AWPROT;
  assign M_AXI_awvalid[0] = m02_couplers_to_m02_couplers_AWVALID;
  assign M_AXI_bready[0] = m02_couplers_to_m02_couplers_BREADY;
  assign M_AXI_rready[0] = m02_couplers_to_m02_couplers_RREADY;
  assign M_AXI_wdata[31:0] = m02_couplers_to_m02_couplers_WDATA;
  assign M_AXI_wstrb[3:0] = m02_couplers_to_m02_couplers_WSTRB;
  assign M_AXI_wvalid[0] = m02_couplers_to_m02_couplers_WVALID;
  assign S_AXI_arready[0] = m02_couplers_to_m02_couplers_ARREADY;
  assign S_AXI_awready[0] = m02_couplers_to_m02_couplers_AWREADY;
  assign S_AXI_bresp[1:0] = m02_couplers_to_m02_couplers_BRESP;
  assign S_AXI_bvalid[0] = m02_couplers_to_m02_couplers_BVALID;
  assign S_AXI_rdata[31:0] = m02_couplers_to_m02_couplers_RDATA;
  assign S_AXI_rresp[1:0] = m02_couplers_to_m02_couplers_RRESP;
  assign S_AXI_rvalid[0] = m02_couplers_to_m02_couplers_RVALID;
  assign S_AXI_wready[0] = m02_couplers_to_m02_couplers_WREADY;
  assign m02_couplers_to_m02_couplers_ARADDR = S_AXI_araddr[39:0];
  assign m02_couplers_to_m02_couplers_ARPROT = S_AXI_arprot[2:0];
  assign m02_couplers_to_m02_couplers_ARREADY = M_AXI_arready[0];
  assign m02_couplers_to_m02_couplers_ARVALID = S_AXI_arvalid[0];
  assign m02_couplers_to_m02_couplers_AWADDR = S_AXI_awaddr[39:0];
  assign m02_couplers_to_m02_couplers_AWPROT = S_AXI_awprot[2:0];
  assign m02_couplers_to_m02_couplers_AWREADY = M_AXI_awready[0];
  assign m02_couplers_to_m02_couplers_AWVALID = S_AXI_awvalid[0];
  assign m02_couplers_to_m02_couplers_BREADY = S_AXI_bready[0];
  assign m02_couplers_to_m02_couplers_BRESP = M_AXI_bresp[1:0];
  assign m02_couplers_to_m02_couplers_BVALID = M_AXI_bvalid[0];
  assign m02_couplers_to_m02_couplers_RDATA = M_AXI_rdata[31:0];
  assign m02_couplers_to_m02_couplers_RREADY = S_AXI_rready[0];
  assign m02_couplers_to_m02_couplers_RRESP = M_AXI_rresp[1:0];
  assign m02_couplers_to_m02_couplers_RVALID = M_AXI_rvalid[0];
  assign m02_couplers_to_m02_couplers_WDATA = S_AXI_wdata[31:0];
  assign m02_couplers_to_m02_couplers_WREADY = M_AXI_wready[0];
  assign m02_couplers_to_m02_couplers_WSTRB = S_AXI_wstrb[3:0];
  assign m02_couplers_to_m02_couplers_WVALID = S_AXI_wvalid[0];
endmodule

module m03_couplers_imp_1OMIXFB
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arready,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awready,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [39:0]M_AXI_araddr;
  input M_AXI_arready;
  output M_AXI_arvalid;
  output [39:0]M_AXI_awaddr;
  input M_AXI_awready;
  output M_AXI_awvalid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input M_AXI_bvalid;
  input [31:0]M_AXI_rdata;
  output M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input M_AXI_rvalid;
  output [31:0]M_AXI_wdata;
  input M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [39:0]S_AXI_araddr;
  output S_AXI_arready;
  input S_AXI_arvalid;
  input [39:0]S_AXI_awaddr;
  output S_AXI_awready;
  input S_AXI_awvalid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input S_AXI_wvalid;

  wire [39:0]m03_couplers_to_m03_couplers_ARADDR;
  wire m03_couplers_to_m03_couplers_ARREADY;
  wire m03_couplers_to_m03_couplers_ARVALID;
  wire [39:0]m03_couplers_to_m03_couplers_AWADDR;
  wire m03_couplers_to_m03_couplers_AWREADY;
  wire m03_couplers_to_m03_couplers_AWVALID;
  wire m03_couplers_to_m03_couplers_BREADY;
  wire [1:0]m03_couplers_to_m03_couplers_BRESP;
  wire m03_couplers_to_m03_couplers_BVALID;
  wire [31:0]m03_couplers_to_m03_couplers_RDATA;
  wire m03_couplers_to_m03_couplers_RREADY;
  wire [1:0]m03_couplers_to_m03_couplers_RRESP;
  wire m03_couplers_to_m03_couplers_RVALID;
  wire [31:0]m03_couplers_to_m03_couplers_WDATA;
  wire m03_couplers_to_m03_couplers_WREADY;
  wire [3:0]m03_couplers_to_m03_couplers_WSTRB;
  wire m03_couplers_to_m03_couplers_WVALID;

  assign M_AXI_araddr[39:0] = m03_couplers_to_m03_couplers_ARADDR;
  assign M_AXI_arvalid = m03_couplers_to_m03_couplers_ARVALID;
  assign M_AXI_awaddr[39:0] = m03_couplers_to_m03_couplers_AWADDR;
  assign M_AXI_awvalid = m03_couplers_to_m03_couplers_AWVALID;
  assign M_AXI_bready = m03_couplers_to_m03_couplers_BREADY;
  assign M_AXI_rready = m03_couplers_to_m03_couplers_RREADY;
  assign M_AXI_wdata[31:0] = m03_couplers_to_m03_couplers_WDATA;
  assign M_AXI_wstrb[3:0] = m03_couplers_to_m03_couplers_WSTRB;
  assign M_AXI_wvalid = m03_couplers_to_m03_couplers_WVALID;
  assign S_AXI_arready = m03_couplers_to_m03_couplers_ARREADY;
  assign S_AXI_awready = m03_couplers_to_m03_couplers_AWREADY;
  assign S_AXI_bresp[1:0] = m03_couplers_to_m03_couplers_BRESP;
  assign S_AXI_bvalid = m03_couplers_to_m03_couplers_BVALID;
  assign S_AXI_rdata[31:0] = m03_couplers_to_m03_couplers_RDATA;
  assign S_AXI_rresp[1:0] = m03_couplers_to_m03_couplers_RRESP;
  assign S_AXI_rvalid = m03_couplers_to_m03_couplers_RVALID;
  assign S_AXI_wready = m03_couplers_to_m03_couplers_WREADY;
  assign m03_couplers_to_m03_couplers_ARADDR = S_AXI_araddr[39:0];
  assign m03_couplers_to_m03_couplers_ARREADY = M_AXI_arready;
  assign m03_couplers_to_m03_couplers_ARVALID = S_AXI_arvalid;
  assign m03_couplers_to_m03_couplers_AWADDR = S_AXI_awaddr[39:0];
  assign m03_couplers_to_m03_couplers_AWREADY = M_AXI_awready;
  assign m03_couplers_to_m03_couplers_AWVALID = S_AXI_awvalid;
  assign m03_couplers_to_m03_couplers_BREADY = S_AXI_bready;
  assign m03_couplers_to_m03_couplers_BRESP = M_AXI_bresp[1:0];
  assign m03_couplers_to_m03_couplers_BVALID = M_AXI_bvalid;
  assign m03_couplers_to_m03_couplers_RDATA = M_AXI_rdata[31:0];
  assign m03_couplers_to_m03_couplers_RREADY = S_AXI_rready;
  assign m03_couplers_to_m03_couplers_RRESP = M_AXI_rresp[1:0];
  assign m03_couplers_to_m03_couplers_RVALID = M_AXI_rvalid;
  assign m03_couplers_to_m03_couplers_WDATA = S_AXI_wdata[31:0];
  assign m03_couplers_to_m03_couplers_WREADY = M_AXI_wready;
  assign m03_couplers_to_m03_couplers_WSTRB = S_AXI_wstrb[3:0];
  assign m03_couplers_to_m03_couplers_WVALID = S_AXI_wvalid;
endmodule

module s00_couplers_imp_44DMZZ
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arprot,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awprot,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arburst,
    S_AXI_arcache,
    S_AXI_arid,
    S_AXI_arlen,
    S_AXI_arlock,
    S_AXI_arprot,
    S_AXI_arqos,
    S_AXI_arready,
    S_AXI_arsize,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awburst,
    S_AXI_awcache,
    S_AXI_awid,
    S_AXI_awlen,
    S_AXI_awlock,
    S_AXI_awprot,
    S_AXI_awqos,
    S_AXI_awready,
    S_AXI_awsize,
    S_AXI_awvalid,
    S_AXI_bid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rid,
    S_AXI_rlast,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wlast,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [39:0]M_AXI_araddr;
  output [2:0]M_AXI_arprot;
  input M_AXI_arready;
  output M_AXI_arvalid;
  output [39:0]M_AXI_awaddr;
  output [2:0]M_AXI_awprot;
  input M_AXI_awready;
  output M_AXI_awvalid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input M_AXI_bvalid;
  input [31:0]M_AXI_rdata;
  output M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input M_AXI_rvalid;
  output [31:0]M_AXI_wdata;
  input M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [39:0]S_AXI_araddr;
  input [1:0]S_AXI_arburst;
  input [3:0]S_AXI_arcache;
  input [15:0]S_AXI_arid;
  input [7:0]S_AXI_arlen;
  input S_AXI_arlock;
  input [2:0]S_AXI_arprot;
  input [3:0]S_AXI_arqos;
  output S_AXI_arready;
  input [2:0]S_AXI_arsize;
  input S_AXI_arvalid;
  input [39:0]S_AXI_awaddr;
  input [1:0]S_AXI_awburst;
  input [3:0]S_AXI_awcache;
  input [15:0]S_AXI_awid;
  input [7:0]S_AXI_awlen;
  input S_AXI_awlock;
  input [2:0]S_AXI_awprot;
  input [3:0]S_AXI_awqos;
  output S_AXI_awready;
  input [2:0]S_AXI_awsize;
  input S_AXI_awvalid;
  output [15:0]S_AXI_bid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  output [15:0]S_AXI_rid;
  output S_AXI_rlast;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  input S_AXI_wlast;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input S_AXI_wvalid;

  wire S_ACLK_1;
  wire S_ARESETN_1;
  wire [39:0]auto_pc_to_s00_couplers_ARADDR;
  wire [2:0]auto_pc_to_s00_couplers_ARPROT;
  wire auto_pc_to_s00_couplers_ARREADY;
  wire auto_pc_to_s00_couplers_ARVALID;
  wire [39:0]auto_pc_to_s00_couplers_AWADDR;
  wire [2:0]auto_pc_to_s00_couplers_AWPROT;
  wire auto_pc_to_s00_couplers_AWREADY;
  wire auto_pc_to_s00_couplers_AWVALID;
  wire auto_pc_to_s00_couplers_BREADY;
  wire [1:0]auto_pc_to_s00_couplers_BRESP;
  wire auto_pc_to_s00_couplers_BVALID;
  wire [31:0]auto_pc_to_s00_couplers_RDATA;
  wire auto_pc_to_s00_couplers_RREADY;
  wire [1:0]auto_pc_to_s00_couplers_RRESP;
  wire auto_pc_to_s00_couplers_RVALID;
  wire [31:0]auto_pc_to_s00_couplers_WDATA;
  wire auto_pc_to_s00_couplers_WREADY;
  wire [3:0]auto_pc_to_s00_couplers_WSTRB;
  wire auto_pc_to_s00_couplers_WVALID;
  wire [39:0]s00_couplers_to_auto_pc_ARADDR;
  wire [1:0]s00_couplers_to_auto_pc_ARBURST;
  wire [3:0]s00_couplers_to_auto_pc_ARCACHE;
  wire [15:0]s00_couplers_to_auto_pc_ARID;
  wire [7:0]s00_couplers_to_auto_pc_ARLEN;
  wire s00_couplers_to_auto_pc_ARLOCK;
  wire [2:0]s00_couplers_to_auto_pc_ARPROT;
  wire [3:0]s00_couplers_to_auto_pc_ARQOS;
  wire s00_couplers_to_auto_pc_ARREADY;
  wire [2:0]s00_couplers_to_auto_pc_ARSIZE;
  wire s00_couplers_to_auto_pc_ARVALID;
  wire [39:0]s00_couplers_to_auto_pc_AWADDR;
  wire [1:0]s00_couplers_to_auto_pc_AWBURST;
  wire [3:0]s00_couplers_to_auto_pc_AWCACHE;
  wire [15:0]s00_couplers_to_auto_pc_AWID;
  wire [7:0]s00_couplers_to_auto_pc_AWLEN;
  wire s00_couplers_to_auto_pc_AWLOCK;
  wire [2:0]s00_couplers_to_auto_pc_AWPROT;
  wire [3:0]s00_couplers_to_auto_pc_AWQOS;
  wire s00_couplers_to_auto_pc_AWREADY;
  wire [2:0]s00_couplers_to_auto_pc_AWSIZE;
  wire s00_couplers_to_auto_pc_AWVALID;
  wire [15:0]s00_couplers_to_auto_pc_BID;
  wire s00_couplers_to_auto_pc_BREADY;
  wire [1:0]s00_couplers_to_auto_pc_BRESP;
  wire s00_couplers_to_auto_pc_BVALID;
  wire [31:0]s00_couplers_to_auto_pc_RDATA;
  wire [15:0]s00_couplers_to_auto_pc_RID;
  wire s00_couplers_to_auto_pc_RLAST;
  wire s00_couplers_to_auto_pc_RREADY;
  wire [1:0]s00_couplers_to_auto_pc_RRESP;
  wire s00_couplers_to_auto_pc_RVALID;
  wire [31:0]s00_couplers_to_auto_pc_WDATA;
  wire s00_couplers_to_auto_pc_WLAST;
  wire s00_couplers_to_auto_pc_WREADY;
  wire [3:0]s00_couplers_to_auto_pc_WSTRB;
  wire s00_couplers_to_auto_pc_WVALID;

  assign M_AXI_araddr[39:0] = auto_pc_to_s00_couplers_ARADDR;
  assign M_AXI_arprot[2:0] = auto_pc_to_s00_couplers_ARPROT;
  assign M_AXI_arvalid = auto_pc_to_s00_couplers_ARVALID;
  assign M_AXI_awaddr[39:0] = auto_pc_to_s00_couplers_AWADDR;
  assign M_AXI_awprot[2:0] = auto_pc_to_s00_couplers_AWPROT;
  assign M_AXI_awvalid = auto_pc_to_s00_couplers_AWVALID;
  assign M_AXI_bready = auto_pc_to_s00_couplers_BREADY;
  assign M_AXI_rready = auto_pc_to_s00_couplers_RREADY;
  assign M_AXI_wdata[31:0] = auto_pc_to_s00_couplers_WDATA;
  assign M_AXI_wstrb[3:0] = auto_pc_to_s00_couplers_WSTRB;
  assign M_AXI_wvalid = auto_pc_to_s00_couplers_WVALID;
  assign S_ACLK_1 = S_ACLK;
  assign S_ARESETN_1 = S_ARESETN;
  assign S_AXI_arready = s00_couplers_to_auto_pc_ARREADY;
  assign S_AXI_awready = s00_couplers_to_auto_pc_AWREADY;
  assign S_AXI_bid[15:0] = s00_couplers_to_auto_pc_BID;
  assign S_AXI_bresp[1:0] = s00_couplers_to_auto_pc_BRESP;
  assign S_AXI_bvalid = s00_couplers_to_auto_pc_BVALID;
  assign S_AXI_rdata[31:0] = s00_couplers_to_auto_pc_RDATA;
  assign S_AXI_rid[15:0] = s00_couplers_to_auto_pc_RID;
  assign S_AXI_rlast = s00_couplers_to_auto_pc_RLAST;
  assign S_AXI_rresp[1:0] = s00_couplers_to_auto_pc_RRESP;
  assign S_AXI_rvalid = s00_couplers_to_auto_pc_RVALID;
  assign S_AXI_wready = s00_couplers_to_auto_pc_WREADY;
  assign auto_pc_to_s00_couplers_ARREADY = M_AXI_arready;
  assign auto_pc_to_s00_couplers_AWREADY = M_AXI_awready;
  assign auto_pc_to_s00_couplers_BRESP = M_AXI_bresp[1:0];
  assign auto_pc_to_s00_couplers_BVALID = M_AXI_bvalid;
  assign auto_pc_to_s00_couplers_RDATA = M_AXI_rdata[31:0];
  assign auto_pc_to_s00_couplers_RRESP = M_AXI_rresp[1:0];
  assign auto_pc_to_s00_couplers_RVALID = M_AXI_rvalid;
  assign auto_pc_to_s00_couplers_WREADY = M_AXI_wready;
  assign s00_couplers_to_auto_pc_ARADDR = S_AXI_araddr[39:0];
  assign s00_couplers_to_auto_pc_ARBURST = S_AXI_arburst[1:0];
  assign s00_couplers_to_auto_pc_ARCACHE = S_AXI_arcache[3:0];
  assign s00_couplers_to_auto_pc_ARID = S_AXI_arid[15:0];
  assign s00_couplers_to_auto_pc_ARLEN = S_AXI_arlen[7:0];
  assign s00_couplers_to_auto_pc_ARLOCK = S_AXI_arlock;
  assign s00_couplers_to_auto_pc_ARPROT = S_AXI_arprot[2:0];
  assign s00_couplers_to_auto_pc_ARQOS = S_AXI_arqos[3:0];
  assign s00_couplers_to_auto_pc_ARSIZE = S_AXI_arsize[2:0];
  assign s00_couplers_to_auto_pc_ARVALID = S_AXI_arvalid;
  assign s00_couplers_to_auto_pc_AWADDR = S_AXI_awaddr[39:0];
  assign s00_couplers_to_auto_pc_AWBURST = S_AXI_awburst[1:0];
  assign s00_couplers_to_auto_pc_AWCACHE = S_AXI_awcache[3:0];
  assign s00_couplers_to_auto_pc_AWID = S_AXI_awid[15:0];
  assign s00_couplers_to_auto_pc_AWLEN = S_AXI_awlen[7:0];
  assign s00_couplers_to_auto_pc_AWLOCK = S_AXI_awlock;
  assign s00_couplers_to_auto_pc_AWPROT = S_AXI_awprot[2:0];
  assign s00_couplers_to_auto_pc_AWQOS = S_AXI_awqos[3:0];
  assign s00_couplers_to_auto_pc_AWSIZE = S_AXI_awsize[2:0];
  assign s00_couplers_to_auto_pc_AWVALID = S_AXI_awvalid;
  assign s00_couplers_to_auto_pc_BREADY = S_AXI_bready;
  assign s00_couplers_to_auto_pc_RREADY = S_AXI_rready;
  assign s00_couplers_to_auto_pc_WDATA = S_AXI_wdata[31:0];
  assign s00_couplers_to_auto_pc_WLAST = S_AXI_wlast;
  assign s00_couplers_to_auto_pc_WSTRB = S_AXI_wstrb[3:0];
  assign s00_couplers_to_auto_pc_WVALID = S_AXI_wvalid;
  vcu_trd_auto_pc_0 auto_pc
       (.aclk(S_ACLK_1),
        .aresetn(S_ARESETN_1),
        .m_axi_araddr(auto_pc_to_s00_couplers_ARADDR),
        .m_axi_arprot(auto_pc_to_s00_couplers_ARPROT),
        .m_axi_arready(auto_pc_to_s00_couplers_ARREADY),
        .m_axi_arvalid(auto_pc_to_s00_couplers_ARVALID),
        .m_axi_awaddr(auto_pc_to_s00_couplers_AWADDR),
        .m_axi_awprot(auto_pc_to_s00_couplers_AWPROT),
        .m_axi_awready(auto_pc_to_s00_couplers_AWREADY),
        .m_axi_awvalid(auto_pc_to_s00_couplers_AWVALID),
        .m_axi_bready(auto_pc_to_s00_couplers_BREADY),
        .m_axi_bresp(auto_pc_to_s00_couplers_BRESP),
        .m_axi_bvalid(auto_pc_to_s00_couplers_BVALID),
        .m_axi_rdata(auto_pc_to_s00_couplers_RDATA),
        .m_axi_rready(auto_pc_to_s00_couplers_RREADY),
        .m_axi_rresp(auto_pc_to_s00_couplers_RRESP),
        .m_axi_rvalid(auto_pc_to_s00_couplers_RVALID),
        .m_axi_wdata(auto_pc_to_s00_couplers_WDATA),
        .m_axi_wready(auto_pc_to_s00_couplers_WREADY),
        .m_axi_wstrb(auto_pc_to_s00_couplers_WSTRB),
        .m_axi_wvalid(auto_pc_to_s00_couplers_WVALID),
        .s_axi_araddr(s00_couplers_to_auto_pc_ARADDR),
        .s_axi_arburst(s00_couplers_to_auto_pc_ARBURST),
        .s_axi_arcache(s00_couplers_to_auto_pc_ARCACHE),
        .s_axi_arid(s00_couplers_to_auto_pc_ARID),
        .s_axi_arlen(s00_couplers_to_auto_pc_ARLEN),
        .s_axi_arlock(s00_couplers_to_auto_pc_ARLOCK),
        .s_axi_arprot(s00_couplers_to_auto_pc_ARPROT),
        .s_axi_arqos(s00_couplers_to_auto_pc_ARQOS),
        .s_axi_arready(s00_couplers_to_auto_pc_ARREADY),
        .s_axi_arregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arsize(s00_couplers_to_auto_pc_ARSIZE),
        .s_axi_arvalid(s00_couplers_to_auto_pc_ARVALID),
        .s_axi_awaddr(s00_couplers_to_auto_pc_AWADDR),
        .s_axi_awburst(s00_couplers_to_auto_pc_AWBURST),
        .s_axi_awcache(s00_couplers_to_auto_pc_AWCACHE),
        .s_axi_awid(s00_couplers_to_auto_pc_AWID),
        .s_axi_awlen(s00_couplers_to_auto_pc_AWLEN),
        .s_axi_awlock(s00_couplers_to_auto_pc_AWLOCK),
        .s_axi_awprot(s00_couplers_to_auto_pc_AWPROT),
        .s_axi_awqos(s00_couplers_to_auto_pc_AWQOS),
        .s_axi_awready(s00_couplers_to_auto_pc_AWREADY),
        .s_axi_awregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awsize(s00_couplers_to_auto_pc_AWSIZE),
        .s_axi_awvalid(s00_couplers_to_auto_pc_AWVALID),
        .s_axi_bid(s00_couplers_to_auto_pc_BID),
        .s_axi_bready(s00_couplers_to_auto_pc_BREADY),
        .s_axi_bresp(s00_couplers_to_auto_pc_BRESP),
        .s_axi_bvalid(s00_couplers_to_auto_pc_BVALID),
        .s_axi_rdata(s00_couplers_to_auto_pc_RDATA),
        .s_axi_rid(s00_couplers_to_auto_pc_RID),
        .s_axi_rlast(s00_couplers_to_auto_pc_RLAST),
        .s_axi_rready(s00_couplers_to_auto_pc_RREADY),
        .s_axi_rresp(s00_couplers_to_auto_pc_RRESP),
        .s_axi_rvalid(s00_couplers_to_auto_pc_RVALID),
        .s_axi_wdata(s00_couplers_to_auto_pc_WDATA),
        .s_axi_wlast(s00_couplers_to_auto_pc_WLAST),
        .s_axi_wready(s00_couplers_to_auto_pc_WREADY),
        .s_axi_wstrb(s00_couplers_to_auto_pc_WSTRB),
        .s_axi_wvalid(s00_couplers_to_auto_pc_WVALID));
endmodule

(* CORE_GENERATION_INFO = "vcu_trd,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=vcu_trd,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=28,numReposBlks=22,numNonXlnxBlks=0,numHierBlks=6,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,da_axi4_cnt=13,da_board_cnt=36,da_clkrst_cnt=14,da_vcu_cnt=2,synth_mode=Global}" *) (* HW_HANDOFF = "vcu_trd.hwdef" *) 
module vcu_trd
   (diff_clock_rtl_0_clk_n,
    diff_clock_rtl_0_clk_p,
    mdio_rtl_0_mdc,
    mdio_rtl_0_mdio_i,
    mdio_rtl_0_mdio_o,
    mdio_rtl_0_mdio_t,
    reset_rtl_0,
    reset_rtl_0_0,
    reset_rtl_0_0_1,
    reset_rtl_0_0_1_2,
    reset_rtl_0_0_1_2_3,
    reset_rtl_0_0_1_2_3_4,
    sfp_rtl_0_rxn,
    sfp_rtl_0_rxp,
    sfp_rtl_0_txn,
    sfp_rtl_0_txp);
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 diff_clock_rtl_0 CLK_N" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME diff_clock_rtl_0, CAN_DEBUG false, FREQ_HZ 100000000" *) input diff_clock_rtl_0_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 diff_clock_rtl_0 CLK_P" *) input diff_clock_rtl_0_clk_p;
  (* X_INTERFACE_INFO = "xilinx.com:interface:mdio:1.0 mdio_rtl_0 MDC" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME mdio_rtl_0, CAN_DEBUG false" *) output mdio_rtl_0_mdc;
  (* X_INTERFACE_INFO = "xilinx.com:interface:mdio:1.0 mdio_rtl_0 MDIO_I" *) input mdio_rtl_0_mdio_i;
  (* X_INTERFACE_INFO = "xilinx.com:interface:mdio:1.0 mdio_rtl_0 MDIO_O" *) output mdio_rtl_0_mdio_o;
  (* X_INTERFACE_INFO = "xilinx.com:interface:mdio:1.0 mdio_rtl_0 MDIO_T" *) output mdio_rtl_0_mdio_t;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESET_RTL_0 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESET_RTL_0, POLARITY ACTIVE_HIGH" *) input reset_rtl_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESET_RTL_0_0 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESET_RTL_0_0, POLARITY ACTIVE_HIGH" *) input reset_rtl_0_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESET_RTL_0_0_1 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESET_RTL_0_0_1, POLARITY ACTIVE_HIGH" *) input reset_rtl_0_0_1;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESET_RTL_0_0_1_2 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESET_RTL_0_0_1_2, POLARITY ACTIVE_HIGH" *) input reset_rtl_0_0_1_2;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESET_RTL_0_0_1_2_3 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESET_RTL_0_0_1_2_3, POLARITY ACTIVE_HIGH" *) input reset_rtl_0_0_1_2_3;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESET_RTL_0_0_1_2_3_4 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESET_RTL_0_0_1_2_3_4, POLARITY ACTIVE_HIGH" *) input reset_rtl_0_0_1_2_3_4;
  (* X_INTERFACE_INFO = "xilinx.com:interface:sfp:1.0 sfp_rtl_0 RXN" *) input sfp_rtl_0_rxn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:sfp:1.0 sfp_rtl_0 RXP" *) input sfp_rtl_0_rxp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:sfp:1.0 sfp_rtl_0 TXN" *) output sfp_rtl_0_txn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:sfp:1.0 sfp_rtl_0 TXP" *) output sfp_rtl_0_txp;

  wire [39:0]axi_lite_2_zynq_ARADDR;
  wire [1:0]axi_lite_2_zynq_ARBURST;
  wire [3:0]axi_lite_2_zynq_ARCACHE;
  wire [15:0]axi_lite_2_zynq_ARID;
  wire [7:0]axi_lite_2_zynq_ARLEN;
  wire axi_lite_2_zynq_ARLOCK;
  wire [2:0]axi_lite_2_zynq_ARPROT;
  wire [3:0]axi_lite_2_zynq_ARQOS;
  wire axi_lite_2_zynq_ARREADY;
  wire [2:0]axi_lite_2_zynq_ARSIZE;
  wire axi_lite_2_zynq_ARVALID;
  wire [39:0]axi_lite_2_zynq_AWADDR;
  wire [1:0]axi_lite_2_zynq_AWBURST;
  wire [3:0]axi_lite_2_zynq_AWCACHE;
  wire [15:0]axi_lite_2_zynq_AWID;
  wire [7:0]axi_lite_2_zynq_AWLEN;
  wire axi_lite_2_zynq_AWLOCK;
  wire [2:0]axi_lite_2_zynq_AWPROT;
  wire [3:0]axi_lite_2_zynq_AWQOS;
  wire axi_lite_2_zynq_AWREADY;
  wire [2:0]axi_lite_2_zynq_AWSIZE;
  wire axi_lite_2_zynq_AWVALID;
  wire [15:0]axi_lite_2_zynq_BID;
  wire axi_lite_2_zynq_BREADY;
  wire [1:0]axi_lite_2_zynq_BRESP;
  wire axi_lite_2_zynq_BVALID;
  wire [31:0]axi_lite_2_zynq_RDATA;
  wire [15:0]axi_lite_2_zynq_RID;
  wire axi_lite_2_zynq_RLAST;
  wire axi_lite_2_zynq_RREADY;
  wire [1:0]axi_lite_2_zynq_RRESP;
  wire axi_lite_2_zynq_RVALID;
  wire [31:0]axi_lite_2_zynq_WDATA;
  wire axi_lite_2_zynq_WLAST;
  wire axi_lite_2_zynq_WREADY;
  wire [3:0]axi_lite_2_zynq_WSTRB;
  wire axi_lite_2_zynq_WVALID;
  wire [0:0]axi_lite_reset_10;
  wire clk_wiz_clk_out1;
  wire diff_clock_rtl_0_1_CLK_N;
  wire diff_clock_rtl_0_1_CLK_P;
  wire gig_ethernet_pcs_pma_0_ext_mdio_pcs_pma_MDC;
  wire gig_ethernet_pcs_pma_0_ext_mdio_pcs_pma_MDIO_I;
  wire gig_ethernet_pcs_pma_0_ext_mdio_pcs_pma_MDIO_O;
  wire gig_ethernet_pcs_pma_0_ext_mdio_pcs_pma_MDIO_T;
  wire gig_ethernet_pcs_pma_0_sfp_RXN;
  wire gig_ethernet_pcs_pma_0_sfp_RXP;
  wire gig_ethernet_pcs_pma_0_sfp_TXN;
  wire gig_ethernet_pcs_pma_0_sfp_TXP;
  wire pl_clk01;
  wire pl_clk10;
  wire pl_reset_axi;
  wire [0:0]proc_sys_reset_vcu_0_peripheral_aresetn;
  wire \^reset_rtl_0_0_1 ;
  wire reset_rtl_0_0_1_1;
  wire reset_rtl_0_0_1_2_1;
  wire reset_rtl_0_0_1_2_3_1;
  wire reset_rtl_0_0_1_2_3_4_1;
  wire reset_rtl_0_1;
  wire [39:0]vcu_2_axi_lite_ARADDR;
  wire [2:0]vcu_2_axi_lite_ARPROT;
  wire [0:0]vcu_2_axi_lite_ARREADY;
  wire [0:0]vcu_2_axi_lite_ARVALID;
  wire [39:0]vcu_2_axi_lite_AWADDR;
  wire [2:0]vcu_2_axi_lite_AWPROT;
  wire [0:0]vcu_2_axi_lite_AWREADY;
  wire [0:0]vcu_2_axi_lite_AWVALID;
  wire [0:0]vcu_2_axi_lite_BREADY;
  wire [1:0]vcu_2_axi_lite_BRESP;
  wire [0:0]vcu_2_axi_lite_BVALID;
  wire [31:0]vcu_2_axi_lite_RDATA;
  wire [0:0]vcu_2_axi_lite_RREADY;
  wire [1:0]vcu_2_axi_lite_RRESP;
  wire [0:0]vcu_2_axi_lite_RVALID;
  wire [31:0]vcu_2_axi_lite_WDATA;
  wire [0:0]vcu_2_axi_lite_WREADY;
  wire [3:0]vcu_2_axi_lite_WSTRB;
  wire [0:0]vcu_2_axi_lite_WVALID;
  wire [39:0]vcu_axi_lite_0_M01_AXI_ARADDR;
  wire [2:0]vcu_axi_lite_0_M01_AXI_ARPROT;
  wire vcu_axi_lite_0_M01_AXI_ARREADY;
  wire vcu_axi_lite_0_M01_AXI_ARVALID;
  wire [39:0]vcu_axi_lite_0_M01_AXI_AWADDR;
  wire [2:0]vcu_axi_lite_0_M01_AXI_AWPROT;
  wire vcu_axi_lite_0_M01_AXI_AWREADY;
  wire vcu_axi_lite_0_M01_AXI_AWVALID;
  wire vcu_axi_lite_0_M01_AXI_BREADY;
  wire [1:0]vcu_axi_lite_0_M01_AXI_BRESP;
  wire vcu_axi_lite_0_M01_AXI_BVALID;
  wire [31:0]vcu_axi_lite_0_M01_AXI_RDATA;
  wire vcu_axi_lite_0_M01_AXI_RREADY;
  wire [1:0]vcu_axi_lite_0_M01_AXI_RRESP;
  wire vcu_axi_lite_0_M01_AXI_RVALID;
  wire [31:0]vcu_axi_lite_0_M01_AXI_WDATA;
  wire vcu_axi_lite_0_M01_AXI_WREADY;
  wire [3:0]vcu_axi_lite_0_M01_AXI_WSTRB;
  wire vcu_axi_lite_0_M01_AXI_WVALID;
  wire [39:0]vcu_axi_lite_0_M02_AXI_ARADDR;
  wire [2:0]vcu_axi_lite_0_M02_AXI_ARPROT;
  wire [0:0]vcu_axi_lite_0_M02_AXI_ARREADY;
  wire [0:0]vcu_axi_lite_0_M02_AXI_ARVALID;
  wire [39:0]vcu_axi_lite_0_M02_AXI_AWADDR;
  wire [2:0]vcu_axi_lite_0_M02_AXI_AWPROT;
  wire [0:0]vcu_axi_lite_0_M02_AXI_AWREADY;
  wire [0:0]vcu_axi_lite_0_M02_AXI_AWVALID;
  wire [0:0]vcu_axi_lite_0_M02_AXI_BREADY;
  wire [1:0]vcu_axi_lite_0_M02_AXI_BRESP;
  wire [0:0]vcu_axi_lite_0_M02_AXI_BVALID;
  wire [31:0]vcu_axi_lite_0_M02_AXI_RDATA;
  wire [0:0]vcu_axi_lite_0_M02_AXI_RREADY;
  wire [1:0]vcu_axi_lite_0_M02_AXI_RRESP;
  wire [0:0]vcu_axi_lite_0_M02_AXI_RVALID;
  wire [31:0]vcu_axi_lite_0_M02_AXI_WDATA;
  wire [0:0]vcu_axi_lite_0_M02_AXI_WREADY;
  wire [3:0]vcu_axi_lite_0_M02_AXI_WSTRB;
  wire [0:0]vcu_axi_lite_0_M02_AXI_WVALID;
  wire [39:0]vcu_axi_lite_0_M03_AXI_ARADDR;
  wire vcu_axi_lite_0_M03_AXI_ARREADY;
  wire vcu_axi_lite_0_M03_AXI_ARVALID;
  wire [39:0]vcu_axi_lite_0_M03_AXI_AWADDR;
  wire vcu_axi_lite_0_M03_AXI_AWREADY;
  wire vcu_axi_lite_0_M03_AXI_AWVALID;
  wire vcu_axi_lite_0_M03_AXI_BREADY;
  wire [1:0]vcu_axi_lite_0_M03_AXI_BRESP;
  wire vcu_axi_lite_0_M03_AXI_BVALID;
  wire [31:0]vcu_axi_lite_0_M03_AXI_RDATA;
  wire vcu_axi_lite_0_M03_AXI_RREADY;
  wire [1:0]vcu_axi_lite_0_M03_AXI_RRESP;
  wire vcu_axi_lite_0_M03_AXI_RVALID;
  wire [31:0]vcu_axi_lite_0_M03_AXI_WDATA;
  wire vcu_axi_lite_0_M03_AXI_WREADY;
  wire [3:0]vcu_axi_lite_0_M03_AXI_WSTRB;
  wire vcu_axi_lite_0_M03_AXI_WVALID;
  wire vcu_clk_locked2;
  wire [43:0]vcu_dec_00_axi_ARADDR;
  wire [1:0]vcu_dec_00_axi_ARBURST;
  wire [3:0]vcu_dec_00_axi_ARCACHE;
  wire [3:0]vcu_dec_00_axi_ARID;
  wire [7:0]vcu_dec_00_axi_ARLEN;
  wire vcu_dec_00_axi_ARLOCK;
  wire [2:0]vcu_dec_00_axi_ARPROT;
  wire [3:0]vcu_dec_00_axi_ARQOS;
  wire vcu_dec_00_axi_ARREADY;
  wire [3:0]vcu_dec_00_axi_ARREGION;
  wire [2:0]vcu_dec_00_axi_ARSIZE;
  wire vcu_dec_00_axi_ARVALID;
  wire [43:0]vcu_dec_00_axi_AWADDR;
  wire [1:0]vcu_dec_00_axi_AWBURST;
  wire [3:0]vcu_dec_00_axi_AWCACHE;
  wire [3:0]vcu_dec_00_axi_AWID;
  wire [7:0]vcu_dec_00_axi_AWLEN;
  wire vcu_dec_00_axi_AWLOCK;
  wire [2:0]vcu_dec_00_axi_AWPROT;
  wire [3:0]vcu_dec_00_axi_AWQOS;
  wire vcu_dec_00_axi_AWREADY;
  wire [3:0]vcu_dec_00_axi_AWREGION;
  wire [2:0]vcu_dec_00_axi_AWSIZE;
  wire vcu_dec_00_axi_AWVALID;
  wire [3:0]vcu_dec_00_axi_BID;
  wire vcu_dec_00_axi_BREADY;
  wire [1:0]vcu_dec_00_axi_BRESP;
  wire vcu_dec_00_axi_BVALID;
  wire [127:0]vcu_dec_00_axi_RDATA;
  wire [3:0]vcu_dec_00_axi_RID;
  wire vcu_dec_00_axi_RLAST;
  wire vcu_dec_00_axi_RREADY;
  wire [1:0]vcu_dec_00_axi_RRESP;
  wire vcu_dec_00_axi_RVALID;
  wire [127:0]vcu_dec_00_axi_WDATA;
  wire vcu_dec_00_axi_WLAST;
  wire vcu_dec_00_axi_WREADY;
  wire [15:0]vcu_dec_00_axi_WSTRB;
  wire vcu_dec_00_axi_WVALID;
  wire [43:0]vcu_dec_01_axi_ARADDR;
  wire [1:0]vcu_dec_01_axi_ARBURST;
  wire [3:0]vcu_dec_01_axi_ARCACHE;
  wire [3:0]vcu_dec_01_axi_ARID;
  wire [7:0]vcu_dec_01_axi_ARLEN;
  wire [0:0]vcu_dec_01_axi_ARLOCK;
  wire [2:0]vcu_dec_01_axi_ARPROT;
  wire [3:0]vcu_dec_01_axi_ARQOS;
  wire vcu_dec_01_axi_ARREADY;
  wire [2:0]vcu_dec_01_axi_ARSIZE;
  wire vcu_dec_01_axi_ARVALID;
  wire [43:0]vcu_dec_01_axi_AWADDR;
  wire [1:0]vcu_dec_01_axi_AWBURST;
  wire [3:0]vcu_dec_01_axi_AWCACHE;
  wire [3:0]vcu_dec_01_axi_AWID;
  wire [7:0]vcu_dec_01_axi_AWLEN;
  wire [0:0]vcu_dec_01_axi_AWLOCK;
  wire [2:0]vcu_dec_01_axi_AWPROT;
  wire [3:0]vcu_dec_01_axi_AWQOS;
  wire vcu_dec_01_axi_AWREADY;
  wire [2:0]vcu_dec_01_axi_AWSIZE;
  wire vcu_dec_01_axi_AWVALID;
  wire [5:0]vcu_dec_01_axi_BID;
  wire vcu_dec_01_axi_BREADY;
  wire [1:0]vcu_dec_01_axi_BRESP;
  wire vcu_dec_01_axi_BVALID;
  wire [127:0]vcu_dec_01_axi_RDATA;
  wire [5:0]vcu_dec_01_axi_RID;
  wire vcu_dec_01_axi_RLAST;
  wire vcu_dec_01_axi_RREADY;
  wire [1:0]vcu_dec_01_axi_RRESP;
  wire vcu_dec_01_axi_RVALID;
  wire [127:0]vcu_dec_01_axi_WDATA;
  wire vcu_dec_01_axi_WLAST;
  wire vcu_dec_01_axi_WREADY;
  wire [15:0]vcu_dec_01_axi_WSTRB;
  wire vcu_dec_01_axi_WVALID;
  wire [43:0]vcu_dec_10_axi_ARADDR;
  wire [1:0]vcu_dec_10_axi_ARBURST;
  wire [3:0]vcu_dec_10_axi_ARCACHE;
  wire [3:0]vcu_dec_10_axi_ARID;
  wire [7:0]vcu_dec_10_axi_ARLEN;
  wire vcu_dec_10_axi_ARLOCK;
  wire [2:0]vcu_dec_10_axi_ARPROT;
  wire [3:0]vcu_dec_10_axi_ARQOS;
  wire vcu_dec_10_axi_ARREADY;
  wire [3:0]vcu_dec_10_axi_ARREGION;
  wire [2:0]vcu_dec_10_axi_ARSIZE;
  wire vcu_dec_10_axi_ARVALID;
  wire [43:0]vcu_dec_10_axi_AWADDR;
  wire [1:0]vcu_dec_10_axi_AWBURST;
  wire [3:0]vcu_dec_10_axi_AWCACHE;
  wire [3:0]vcu_dec_10_axi_AWID;
  wire [7:0]vcu_dec_10_axi_AWLEN;
  wire vcu_dec_10_axi_AWLOCK;
  wire [2:0]vcu_dec_10_axi_AWPROT;
  wire [3:0]vcu_dec_10_axi_AWQOS;
  wire vcu_dec_10_axi_AWREADY;
  wire [3:0]vcu_dec_10_axi_AWREGION;
  wire [2:0]vcu_dec_10_axi_AWSIZE;
  wire vcu_dec_10_axi_AWVALID;
  wire [3:0]vcu_dec_10_axi_BID;
  wire vcu_dec_10_axi_BREADY;
  wire [1:0]vcu_dec_10_axi_BRESP;
  wire vcu_dec_10_axi_BVALID;
  wire [127:0]vcu_dec_10_axi_RDATA;
  wire [3:0]vcu_dec_10_axi_RID;
  wire vcu_dec_10_axi_RLAST;
  wire vcu_dec_10_axi_RREADY;
  wire [1:0]vcu_dec_10_axi_RRESP;
  wire vcu_dec_10_axi_RVALID;
  wire [127:0]vcu_dec_10_axi_WDATA;
  wire vcu_dec_10_axi_WLAST;
  wire vcu_dec_10_axi_WREADY;
  wire [15:0]vcu_dec_10_axi_WSTRB;
  wire vcu_dec_10_axi_WVALID;
  wire [43:0]vcu_dec_11_axi_ARADDR;
  wire [1:0]vcu_dec_11_axi_ARBURST;
  wire [3:0]vcu_dec_11_axi_ARCACHE;
  wire [3:0]vcu_dec_11_axi_ARID;
  wire [7:0]vcu_dec_11_axi_ARLEN;
  wire [0:0]vcu_dec_11_axi_ARLOCK;
  wire [2:0]vcu_dec_11_axi_ARPROT;
  wire [3:0]vcu_dec_11_axi_ARQOS;
  wire vcu_dec_11_axi_ARREADY;
  wire [2:0]vcu_dec_11_axi_ARSIZE;
  wire vcu_dec_11_axi_ARVALID;
  wire [43:0]vcu_dec_11_axi_AWADDR;
  wire [1:0]vcu_dec_11_axi_AWBURST;
  wire [3:0]vcu_dec_11_axi_AWCACHE;
  wire [3:0]vcu_dec_11_axi_AWID;
  wire [7:0]vcu_dec_11_axi_AWLEN;
  wire [0:0]vcu_dec_11_axi_AWLOCK;
  wire [2:0]vcu_dec_11_axi_AWPROT;
  wire [3:0]vcu_dec_11_axi_AWQOS;
  wire vcu_dec_11_axi_AWREADY;
  wire [2:0]vcu_dec_11_axi_AWSIZE;
  wire vcu_dec_11_axi_AWVALID;
  wire [5:0]vcu_dec_11_axi_BID;
  wire vcu_dec_11_axi_BREADY;
  wire [1:0]vcu_dec_11_axi_BRESP;
  wire vcu_dec_11_axi_BVALID;
  wire [127:0]vcu_dec_11_axi_RDATA;
  wire [5:0]vcu_dec_11_axi_RID;
  wire vcu_dec_11_axi_RLAST;
  wire vcu_dec_11_axi_RREADY;
  wire [1:0]vcu_dec_11_axi_RRESP;
  wire vcu_dec_11_axi_RVALID;
  wire [127:0]vcu_dec_11_axi_WDATA;
  wire vcu_dec_11_axi_WLAST;
  wire vcu_dec_11_axi_WREADY;
  wire [15:0]vcu_dec_11_axi_WSTRB;
  wire vcu_dec_11_axi_WVALID;
  wire [43:0]vcu_enc_00_axi_ARADDR;
  wire [1:0]vcu_enc_00_axi_ARBURST;
  wire [3:0]vcu_enc_00_axi_ARCACHE;
  wire [3:0]vcu_enc_00_axi_ARID;
  wire [7:0]vcu_enc_00_axi_ARLEN;
  wire vcu_enc_00_axi_ARLOCK;
  wire [2:0]vcu_enc_00_axi_ARPROT;
  wire [3:0]vcu_enc_00_axi_ARQOS;
  wire vcu_enc_00_axi_ARREADY;
  wire [3:0]vcu_enc_00_axi_ARREGION;
  wire [2:0]vcu_enc_00_axi_ARSIZE;
  wire vcu_enc_00_axi_ARVALID;
  wire [43:0]vcu_enc_00_axi_AWADDR;
  wire [1:0]vcu_enc_00_axi_AWBURST;
  wire [3:0]vcu_enc_00_axi_AWCACHE;
  wire [3:0]vcu_enc_00_axi_AWID;
  wire [7:0]vcu_enc_00_axi_AWLEN;
  wire vcu_enc_00_axi_AWLOCK;
  wire [2:0]vcu_enc_00_axi_AWPROT;
  wire [3:0]vcu_enc_00_axi_AWQOS;
  wire vcu_enc_00_axi_AWREADY;
  wire [3:0]vcu_enc_00_axi_AWREGION;
  wire [2:0]vcu_enc_00_axi_AWSIZE;
  wire vcu_enc_00_axi_AWVALID;
  wire [3:0]vcu_enc_00_axi_BID;
  wire vcu_enc_00_axi_BREADY;
  wire [1:0]vcu_enc_00_axi_BRESP;
  wire vcu_enc_00_axi_BVALID;
  wire [127:0]vcu_enc_00_axi_RDATA;
  wire [3:0]vcu_enc_00_axi_RID;
  wire vcu_enc_00_axi_RLAST;
  wire vcu_enc_00_axi_RREADY;
  wire [1:0]vcu_enc_00_axi_RRESP;
  wire vcu_enc_00_axi_RVALID;
  wire [127:0]vcu_enc_00_axi_WDATA;
  wire vcu_enc_00_axi_WLAST;
  wire vcu_enc_00_axi_WREADY;
  wire [15:0]vcu_enc_00_axi_WSTRB;
  wire vcu_enc_00_axi_WVALID;
  wire [43:0]vcu_enc_01_axi_ARADDR;
  wire [1:0]vcu_enc_01_axi_ARBURST;
  wire [3:0]vcu_enc_01_axi_ARCACHE;
  wire [3:0]vcu_enc_01_axi_ARID;
  wire [7:0]vcu_enc_01_axi_ARLEN;
  wire [0:0]vcu_enc_01_axi_ARLOCK;
  wire [2:0]vcu_enc_01_axi_ARPROT;
  wire [3:0]vcu_enc_01_axi_ARQOS;
  wire vcu_enc_01_axi_ARREADY;
  wire [2:0]vcu_enc_01_axi_ARSIZE;
  wire vcu_enc_01_axi_ARVALID;
  wire [43:0]vcu_enc_01_axi_AWADDR;
  wire [1:0]vcu_enc_01_axi_AWBURST;
  wire [3:0]vcu_enc_01_axi_AWCACHE;
  wire [3:0]vcu_enc_01_axi_AWID;
  wire [7:0]vcu_enc_01_axi_AWLEN;
  wire [0:0]vcu_enc_01_axi_AWLOCK;
  wire [2:0]vcu_enc_01_axi_AWPROT;
  wire [3:0]vcu_enc_01_axi_AWQOS;
  wire vcu_enc_01_axi_AWREADY;
  wire [2:0]vcu_enc_01_axi_AWSIZE;
  wire vcu_enc_01_axi_AWVALID;
  wire [5:0]vcu_enc_01_axi_BID;
  wire vcu_enc_01_axi_BREADY;
  wire [1:0]vcu_enc_01_axi_BRESP;
  wire vcu_enc_01_axi_BVALID;
  wire [127:0]vcu_enc_01_axi_RDATA;
  wire [5:0]vcu_enc_01_axi_RID;
  wire vcu_enc_01_axi_RLAST;
  wire vcu_enc_01_axi_RREADY;
  wire [1:0]vcu_enc_01_axi_RRESP;
  wire vcu_enc_01_axi_RVALID;
  wire [127:0]vcu_enc_01_axi_WDATA;
  wire vcu_enc_01_axi_WLAST;
  wire vcu_enc_01_axi_WREADY;
  wire [15:0]vcu_enc_01_axi_WSTRB;
  wire vcu_enc_01_axi_WVALID;
  wire [43:0]vcu_enc_10_axi_ARADDR;
  wire [1:0]vcu_enc_10_axi_ARBURST;
  wire [3:0]vcu_enc_10_axi_ARCACHE;
  wire [3:0]vcu_enc_10_axi_ARID;
  wire [7:0]vcu_enc_10_axi_ARLEN;
  wire vcu_enc_10_axi_ARLOCK;
  wire [2:0]vcu_enc_10_axi_ARPROT;
  wire [3:0]vcu_enc_10_axi_ARQOS;
  wire vcu_enc_10_axi_ARREADY;
  wire [3:0]vcu_enc_10_axi_ARREGION;
  wire [2:0]vcu_enc_10_axi_ARSIZE;
  wire vcu_enc_10_axi_ARVALID;
  wire [43:0]vcu_enc_10_axi_AWADDR;
  wire [1:0]vcu_enc_10_axi_AWBURST;
  wire [3:0]vcu_enc_10_axi_AWCACHE;
  wire [3:0]vcu_enc_10_axi_AWID;
  wire [7:0]vcu_enc_10_axi_AWLEN;
  wire vcu_enc_10_axi_AWLOCK;
  wire [2:0]vcu_enc_10_axi_AWPROT;
  wire [3:0]vcu_enc_10_axi_AWQOS;
  wire vcu_enc_10_axi_AWREADY;
  wire [3:0]vcu_enc_10_axi_AWREGION;
  wire [2:0]vcu_enc_10_axi_AWSIZE;
  wire vcu_enc_10_axi_AWVALID;
  wire [3:0]vcu_enc_10_axi_BID;
  wire vcu_enc_10_axi_BREADY;
  wire [1:0]vcu_enc_10_axi_BRESP;
  wire vcu_enc_10_axi_BVALID;
  wire [127:0]vcu_enc_10_axi_RDATA;
  wire [3:0]vcu_enc_10_axi_RID;
  wire vcu_enc_10_axi_RLAST;
  wire vcu_enc_10_axi_RREADY;
  wire [1:0]vcu_enc_10_axi_RRESP;
  wire vcu_enc_10_axi_RVALID;
  wire [127:0]vcu_enc_10_axi_WDATA;
  wire vcu_enc_10_axi_WLAST;
  wire vcu_enc_10_axi_WREADY;
  wire [15:0]vcu_enc_10_axi_WSTRB;
  wire vcu_enc_10_axi_WVALID;
  wire [43:0]vcu_enc_11_axi_ARADDR;
  wire [1:0]vcu_enc_11_axi_ARBURST;
  wire [3:0]vcu_enc_11_axi_ARCACHE;
  wire [3:0]vcu_enc_11_axi_ARID;
  wire [7:0]vcu_enc_11_axi_ARLEN;
  wire [0:0]vcu_enc_11_axi_ARLOCK;
  wire [2:0]vcu_enc_11_axi_ARPROT;
  wire [3:0]vcu_enc_11_axi_ARQOS;
  wire vcu_enc_11_axi_ARREADY;
  wire [2:0]vcu_enc_11_axi_ARSIZE;
  wire vcu_enc_11_axi_ARVALID;
  wire [43:0]vcu_enc_11_axi_AWADDR;
  wire [1:0]vcu_enc_11_axi_AWBURST;
  wire [3:0]vcu_enc_11_axi_AWCACHE;
  wire [3:0]vcu_enc_11_axi_AWID;
  wire [7:0]vcu_enc_11_axi_AWLEN;
  wire [0:0]vcu_enc_11_axi_AWLOCK;
  wire [2:0]vcu_enc_11_axi_AWPROT;
  wire [3:0]vcu_enc_11_axi_AWQOS;
  wire vcu_enc_11_axi_AWREADY;
  wire [2:0]vcu_enc_11_axi_AWSIZE;
  wire vcu_enc_11_axi_AWVALID;
  wire [5:0]vcu_enc_11_axi_BID;
  wire vcu_enc_11_axi_BREADY;
  wire [1:0]vcu_enc_11_axi_BRESP;
  wire vcu_enc_11_axi_BVALID;
  wire [127:0]vcu_enc_11_axi_RDATA;
  wire [5:0]vcu_enc_11_axi_RID;
  wire vcu_enc_11_axi_RLAST;
  wire vcu_enc_11_axi_RREADY;
  wire [1:0]vcu_enc_11_axi_RRESP;
  wire vcu_enc_11_axi_RVALID;
  wire [127:0]vcu_enc_11_axi_WDATA;
  wire vcu_enc_11_axi_WLAST;
  wire vcu_enc_11_axi_WREADY;
  wire [15:0]vcu_enc_11_axi_WSTRB;
  wire vcu_enc_11_axi_WVALID;
  wire vcu_irq;
  wire [0:0]vcu_irq_to_ps;
  wire [43:0]vcu_mcu_axi_1_ARADDR;
  wire [1:0]vcu_mcu_axi_1_ARBURST;
  wire [3:0]vcu_mcu_axi_1_ARCACHE;
  wire [2:0]vcu_mcu_axi_1_ARID;
  wire [7:0]vcu_mcu_axi_1_ARLEN;
  wire [0:0]vcu_mcu_axi_1_ARLOCK;
  wire [2:0]vcu_mcu_axi_1_ARPROT;
  wire [3:0]vcu_mcu_axi_1_ARQOS;
  wire vcu_mcu_axi_1_ARREADY;
  wire [2:0]vcu_mcu_axi_1_ARSIZE;
  wire vcu_mcu_axi_1_ARVALID;
  wire [43:0]vcu_mcu_axi_1_AWADDR;
  wire [1:0]vcu_mcu_axi_1_AWBURST;
  wire [3:0]vcu_mcu_axi_1_AWCACHE;
  wire [2:0]vcu_mcu_axi_1_AWID;
  wire [7:0]vcu_mcu_axi_1_AWLEN;
  wire [0:0]vcu_mcu_axi_1_AWLOCK;
  wire [2:0]vcu_mcu_axi_1_AWPROT;
  wire [3:0]vcu_mcu_axi_1_AWQOS;
  wire vcu_mcu_axi_1_AWREADY;
  wire [2:0]vcu_mcu_axi_1_AWSIZE;
  wire vcu_mcu_axi_1_AWVALID;
  wire [5:0]vcu_mcu_axi_1_BID;
  wire vcu_mcu_axi_1_BREADY;
  wire [1:0]vcu_mcu_axi_1_BRESP;
  wire vcu_mcu_axi_1_BVALID;
  wire [31:0]vcu_mcu_axi_1_RDATA;
  wire [5:0]vcu_mcu_axi_1_RID;
  wire vcu_mcu_axi_1_RLAST;
  wire vcu_mcu_axi_1_RREADY;
  wire [1:0]vcu_mcu_axi_1_RRESP;
  wire vcu_mcu_axi_1_RVALID;
  wire [31:0]vcu_mcu_axi_1_WDATA;
  wire vcu_mcu_axi_1_WLAST;
  wire vcu_mcu_axi_1_WREADY;
  wire [3:0]vcu_mcu_axi_1_WSTRB;
  wire vcu_mcu_axi_1_WVALID;
  wire [43:0]vcu_mcu_axi_ARADDR;
  wire [1:0]vcu_mcu_axi_ARBURST;
  wire [3:0]vcu_mcu_axi_ARCACHE;
  wire [2:0]vcu_mcu_axi_ARID;
  wire [7:0]vcu_mcu_axi_ARLEN;
  wire vcu_mcu_axi_ARLOCK;
  wire [2:0]vcu_mcu_axi_ARPROT;
  wire [3:0]vcu_mcu_axi_ARQOS;
  wire vcu_mcu_axi_ARREADY;
  wire [2:0]vcu_mcu_axi_ARSIZE;
  wire vcu_mcu_axi_ARVALID;
  wire [43:0]vcu_mcu_axi_AWADDR;
  wire [1:0]vcu_mcu_axi_AWBURST;
  wire [3:0]vcu_mcu_axi_AWCACHE;
  wire [2:0]vcu_mcu_axi_AWID;
  wire [7:0]vcu_mcu_axi_AWLEN;
  wire vcu_mcu_axi_AWLOCK;
  wire [2:0]vcu_mcu_axi_AWPROT;
  wire [3:0]vcu_mcu_axi_AWQOS;
  wire vcu_mcu_axi_AWREADY;
  wire [2:0]vcu_mcu_axi_AWSIZE;
  wire vcu_mcu_axi_AWVALID;
  wire [2:0]vcu_mcu_axi_BID;
  wire vcu_mcu_axi_BREADY;
  wire [1:0]vcu_mcu_axi_BRESP;
  wire vcu_mcu_axi_BVALID;
  wire [31:0]vcu_mcu_axi_RDATA;
  wire [2:0]vcu_mcu_axi_RID;
  wire vcu_mcu_axi_RLAST;
  wire vcu_mcu_axi_RREADY;
  wire [1:0]vcu_mcu_axi_RRESP;
  wire vcu_mcu_axi_RVALID;
  wire [31:0]vcu_mcu_axi_WDATA;
  wire vcu_mcu_axi_WLAST;
  wire vcu_mcu_axi_WREADY;
  wire [3:0]vcu_mcu_axi_WSTRB;
  wire vcu_mcu_axi_WVALID;
  wire vcu_ref_clk;
  wire [0:0]vcu_reset_slice4;

  assign \^reset_rtl_0_0_1  = reset_rtl_0_0;
  assign diff_clock_rtl_0_1_CLK_N = diff_clock_rtl_0_clk_n;
  assign diff_clock_rtl_0_1_CLK_P = diff_clock_rtl_0_clk_p;
  assign gig_ethernet_pcs_pma_0_ext_mdio_pcs_pma_MDIO_I = mdio_rtl_0_mdio_i;
  assign gig_ethernet_pcs_pma_0_sfp_RXN = sfp_rtl_0_rxn;
  assign gig_ethernet_pcs_pma_0_sfp_RXP = sfp_rtl_0_rxp;
  assign mdio_rtl_0_mdc = gig_ethernet_pcs_pma_0_ext_mdio_pcs_pma_MDC;
  assign mdio_rtl_0_mdio_o = gig_ethernet_pcs_pma_0_ext_mdio_pcs_pma_MDIO_O;
  assign mdio_rtl_0_mdio_t = gig_ethernet_pcs_pma_0_ext_mdio_pcs_pma_MDIO_T;
  assign reset_rtl_0_0_1_1 = reset_rtl_0_0_1;
  assign reset_rtl_0_0_1_2_1 = reset_rtl_0_0_1_2;
  assign reset_rtl_0_0_1_2_3_1 = reset_rtl_0_0_1_2_3;
  assign reset_rtl_0_0_1_2_3_4_1 = reset_rtl_0_0_1_2_3_4;
  assign reset_rtl_0_1 = reset_rtl_0;
  assign sfp_rtl_0_txn = gig_ethernet_pcs_pma_0_sfp_TXN;
  assign sfp_rtl_0_txp = gig_ethernet_pcs_pma_0_sfp_TXP;
  vcu_trd_clk_wiz_1 clk_wiz
       (.clk_in1(pl_clk01),
        .clk_out1(clk_wiz_clk_out1),
        .reset(reset_rtl_0_1));
  vcu_trd_clk_wiz_0_1 clk_wiz_0
       (.clk_in1(pl_clk01),
        .reset(reset_rtl_0_0_1_2_3_4_1));
  vcu_trd_clk_wiz_1_1 clk_wiz_1
       (.clk_in1(pl_clk01),
        .reset(\^reset_rtl_0_0_1 ));
  vcu_trd_clk_wiz_2_1 clk_wiz_2
       (.clk_in1(pl_clk01),
        .reset(reset_rtl_0_0_1_1));
  vcu_trd_clk_wiz_3_1 clk_wiz_3
       (.clk_in1(pl_clk01),
        .reset(reset_rtl_0_0_1_2_1));
  vcu_trd_clk_wiz_4_1 clk_wiz_4
       (.clk_in1(pl_clk01),
        .reset(reset_rtl_0_0_1_2_3_1));
  vcu_trd_gig_ethernet_pcs_pma_0_1 gig_ethernet_pcs_pma_0
       (.an_adv_config_val(1'b0),
        .an_adv_config_vector({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .an_restart_config(1'b0),
        .basex_or_sgmii(1'b0),
        .configuration_valid(1'b0),
        .configuration_vector({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ext_mdc(gig_ethernet_pcs_pma_0_ext_mdio_pcs_pma_MDC),
        .ext_mdio_i(gig_ethernet_pcs_pma_0_ext_mdio_pcs_pma_MDIO_I),
        .ext_mdio_o(gig_ethernet_pcs_pma_0_ext_mdio_pcs_pma_MDIO_O),
        .ext_mdio_t(gig_ethernet_pcs_pma_0_ext_mdio_pcs_pma_MDIO_T),
        .gmii_tx_en(1'b0),
        .gmii_tx_er(1'b0),
        .gmii_txd({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .gtrefclk_n(diff_clock_rtl_0_1_CLK_N),
        .gtrefclk_p(diff_clock_rtl_0_1_CLK_P),
        .independent_clock_bufg(pl_clk01),
        .mdc(1'b0),
        .mdio_i(1'b1),
        .mdio_t_in(1'b0),
        .phyaddr({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .reset(1'b0),
        .rxn(gig_ethernet_pcs_pma_0_sfp_RXN),
        .rxp(gig_ethernet_pcs_pma_0_sfp_RXP),
        .signal_detect(1'b1),
        .speed_is_100(1'b0),
        .speed_is_10_100(1'b0),
        .txn(gig_ethernet_pcs_pma_0_sfp_TXN),
        .txp(gig_ethernet_pcs_pma_0_sfp_TXP));
  vcu_trd_proc_sys_reset_vcu_0_1 proc_sys_reset_vcu_0
       (.aux_reset_in(1'b1),
        .dcm_locked(vcu_clk_locked2),
        .ext_reset_in(pl_reset_axi),
        .interconnect_aresetn(axi_lite_reset_10),
        .mb_debug_sys_rst(1'b0),
        .peripheral_aresetn(proc_sys_reset_vcu_0_peripheral_aresetn),
        .slowest_sync_clk(pl_clk01));
  vcu_trd_proc_sys_reset_vcu_1_1 proc_sys_reset_vcu_1
       (.aux_reset_in(1'b1),
        .dcm_locked(vcu_clk_locked2),
        .ext_reset_in(pl_reset_axi),
        .interconnect_aresetn(vcu_reset_slice4),
        .mb_debug_sys_rst(1'b0),
        .slowest_sync_clk(pl_clk10));
  vcu_trd_v_smpte_uhdsdi_rx_ss_0_0 v_smpte_uhdsdi_rx_ss_0
       (.M_AXIS_CTRL_SB_RX_tready(1'b1),
        .S_AXIS_RX_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .S_AXIS_RX_tuser({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .S_AXIS_RX_tvalid(1'b0),
        .S_AXIS_STS_SB_RX_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .S_AXIS_STS_SB_RX_tvalid(1'b0),
        .S_AXI_CTRL_araddr(vcu_axi_lite_0_M01_AXI_ARADDR[8:0]),
        .S_AXI_CTRL_arprot(vcu_axi_lite_0_M01_AXI_ARPROT),
        .S_AXI_CTRL_arready(vcu_axi_lite_0_M01_AXI_ARREADY),
        .S_AXI_CTRL_arvalid(vcu_axi_lite_0_M01_AXI_ARVALID),
        .S_AXI_CTRL_awaddr(vcu_axi_lite_0_M01_AXI_AWADDR[8:0]),
        .S_AXI_CTRL_awprot(vcu_axi_lite_0_M01_AXI_AWPROT),
        .S_AXI_CTRL_awready(vcu_axi_lite_0_M01_AXI_AWREADY),
        .S_AXI_CTRL_awvalid(vcu_axi_lite_0_M01_AXI_AWVALID),
        .S_AXI_CTRL_bready(vcu_axi_lite_0_M01_AXI_BREADY),
        .S_AXI_CTRL_bresp(vcu_axi_lite_0_M01_AXI_BRESP),
        .S_AXI_CTRL_bvalid(vcu_axi_lite_0_M01_AXI_BVALID),
        .S_AXI_CTRL_rdata(vcu_axi_lite_0_M01_AXI_RDATA),
        .S_AXI_CTRL_rready(vcu_axi_lite_0_M01_AXI_RREADY),
        .S_AXI_CTRL_rresp(vcu_axi_lite_0_M01_AXI_RRESP),
        .S_AXI_CTRL_rvalid(vcu_axi_lite_0_M01_AXI_RVALID),
        .S_AXI_CTRL_wdata(vcu_axi_lite_0_M01_AXI_WDATA),
        .S_AXI_CTRL_wready(vcu_axi_lite_0_M01_AXI_WREADY),
        .S_AXI_CTRL_wstrb(vcu_axi_lite_0_M01_AXI_WSTRB),
        .S_AXI_CTRL_wvalid(vcu_axi_lite_0_M01_AXI_WVALID),
        .VIDEO_OUT_tready(1'b1),
        .s_axi_aclk(pl_clk01),
        .s_axi_arstn(proc_sys_reset_vcu_0_peripheral_aresetn),
        .sdi_rx_clk(clk_wiz_clk_out1),
        .sdi_rx_rst(1'b0),
        .video_out_arstn(1'b0),
        .video_out_clk(clk_wiz_clk_out1));
  vcu_trd_v_smpte_uhdsdi_tx_ss_0_0 v_smpte_uhdsdi_tx_ss_0
       (.M_AXIS_CTRL_SB_TX_tready(1'b1),
        .M_AXIS_TX_tready(1'b1),
        .S_AXIS_STS_SB_TX_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .S_AXIS_STS_SB_TX_tvalid(1'b0),
        .S_AXI_CTRL_araddr(vcu_axi_lite_0_M02_AXI_ARADDR[16:0]),
        .S_AXI_CTRL_arprot(vcu_axi_lite_0_M02_AXI_ARPROT),
        .S_AXI_CTRL_arready(vcu_axi_lite_0_M02_AXI_ARREADY),
        .S_AXI_CTRL_arvalid(vcu_axi_lite_0_M02_AXI_ARVALID),
        .S_AXI_CTRL_awaddr(vcu_axi_lite_0_M02_AXI_AWADDR[16:0]),
        .S_AXI_CTRL_awprot(vcu_axi_lite_0_M02_AXI_AWPROT),
        .S_AXI_CTRL_awready(vcu_axi_lite_0_M02_AXI_AWREADY),
        .S_AXI_CTRL_awvalid(vcu_axi_lite_0_M02_AXI_AWVALID),
        .S_AXI_CTRL_bready(vcu_axi_lite_0_M02_AXI_BREADY),
        .S_AXI_CTRL_bresp(vcu_axi_lite_0_M02_AXI_BRESP),
        .S_AXI_CTRL_bvalid(vcu_axi_lite_0_M02_AXI_BVALID),
        .S_AXI_CTRL_rdata(vcu_axi_lite_0_M02_AXI_RDATA),
        .S_AXI_CTRL_rready(vcu_axi_lite_0_M02_AXI_RREADY),
        .S_AXI_CTRL_rresp(vcu_axi_lite_0_M02_AXI_RRESP),
        .S_AXI_CTRL_rvalid(vcu_axi_lite_0_M02_AXI_RVALID),
        .S_AXI_CTRL_wdata(vcu_axi_lite_0_M02_AXI_WDATA),
        .S_AXI_CTRL_wready(vcu_axi_lite_0_M02_AXI_WREADY),
        .S_AXI_CTRL_wstrb(vcu_axi_lite_0_M02_AXI_WSTRB),
        .S_AXI_CTRL_wvalid(vcu_axi_lite_0_M02_AXI_WVALID),
        .VIDEO_IN_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .VIDEO_IN_tlast(1'b0),
        .VIDEO_IN_tuser(1'b0),
        .VIDEO_IN_tvalid(1'b0),
        .fid(1'b0),
        .s_axi_aclk(pl_clk01),
        .s_axi_arstn(axi_lite_reset_10),
        .sdi_tx_clk(clk_wiz_clk_out1),
        .sdi_tx_rst(1'b0),
        .video_in_arstn(1'b0),
        .video_in_clk(clk_wiz_clk_out1));
  vcu_trd_vcu_0_1 vcu_0
       (.m_axi_dec_aclk(pl_clk10),
        .m_axi_enc_aclk(pl_clk10),
        .m_axi_mcu_aclk(pl_clk10),
        .pl_vcu_araddr_axi_lite_apb(vcu_2_axi_lite_ARADDR[19:0]),
        .pl_vcu_arprot_axi_lite_apb(vcu_2_axi_lite_ARPROT),
        .pl_vcu_arvalid_axi_lite_apb(vcu_2_axi_lite_ARVALID),
        .pl_vcu_awaddr_axi_lite_apb(vcu_2_axi_lite_AWADDR[19:0]),
        .pl_vcu_awprot_axi_lite_apb(vcu_2_axi_lite_AWPROT),
        .pl_vcu_awvalid_axi_lite_apb(vcu_2_axi_lite_AWVALID),
        .pl_vcu_bready_axi_lite_apb(vcu_2_axi_lite_BREADY),
        .pl_vcu_dec_arready0(vcu_dec_00_axi_ARREADY),
        .pl_vcu_dec_arready1(vcu_dec_10_axi_ARREADY),
        .pl_vcu_dec_awready0(vcu_dec_00_axi_AWREADY),
        .pl_vcu_dec_awready1(vcu_dec_10_axi_AWREADY),
        .pl_vcu_dec_bid0(vcu_dec_00_axi_BID),
        .pl_vcu_dec_bid1(vcu_dec_10_axi_BID),
        .pl_vcu_dec_bresp0(vcu_dec_00_axi_BRESP),
        .pl_vcu_dec_bresp1(vcu_dec_10_axi_BRESP),
        .pl_vcu_dec_bvalid0(vcu_dec_00_axi_BVALID),
        .pl_vcu_dec_bvalid1(vcu_dec_10_axi_BVALID),
        .pl_vcu_dec_rdata0(vcu_dec_00_axi_RDATA),
        .pl_vcu_dec_rdata1(vcu_dec_10_axi_RDATA),
        .pl_vcu_dec_rid0(vcu_dec_00_axi_RID),
        .pl_vcu_dec_rid1(vcu_dec_10_axi_RID),
        .pl_vcu_dec_rlast0(vcu_dec_00_axi_RLAST),
        .pl_vcu_dec_rlast1(vcu_dec_10_axi_RLAST),
        .pl_vcu_dec_rresp0(vcu_dec_00_axi_RRESP),
        .pl_vcu_dec_rresp1(vcu_dec_10_axi_RRESP),
        .pl_vcu_dec_rvalid0(vcu_dec_00_axi_RVALID),
        .pl_vcu_dec_rvalid1(vcu_dec_10_axi_RVALID),
        .pl_vcu_dec_wready0(vcu_dec_00_axi_WREADY),
        .pl_vcu_dec_wready1(vcu_dec_10_axi_WREADY),
        .pl_vcu_enc_arready0(vcu_enc_00_axi_ARREADY),
        .pl_vcu_enc_arready1(vcu_enc_10_axi_ARREADY),
        .pl_vcu_enc_awready0(vcu_enc_00_axi_AWREADY),
        .pl_vcu_enc_awready1(vcu_enc_10_axi_AWREADY),
        .pl_vcu_enc_bid0(vcu_enc_00_axi_BID),
        .pl_vcu_enc_bid1(vcu_enc_10_axi_BID),
        .pl_vcu_enc_bresp0(vcu_enc_00_axi_BRESP),
        .pl_vcu_enc_bresp1(vcu_enc_10_axi_BRESP),
        .pl_vcu_enc_bvalid0(vcu_enc_00_axi_BVALID),
        .pl_vcu_enc_bvalid1(vcu_enc_10_axi_BVALID),
        .pl_vcu_enc_rdata0(vcu_enc_00_axi_RDATA),
        .pl_vcu_enc_rdata1(vcu_enc_10_axi_RDATA),
        .pl_vcu_enc_rid0(vcu_enc_00_axi_RID),
        .pl_vcu_enc_rid1(vcu_enc_10_axi_RID),
        .pl_vcu_enc_rlast0(vcu_enc_00_axi_RLAST),
        .pl_vcu_enc_rlast1(vcu_enc_10_axi_RLAST),
        .pl_vcu_enc_rresp0(vcu_enc_00_axi_RRESP),
        .pl_vcu_enc_rresp1(vcu_enc_10_axi_RRESP),
        .pl_vcu_enc_rvalid0(vcu_enc_00_axi_RVALID),
        .pl_vcu_enc_rvalid1(vcu_enc_10_axi_RVALID),
        .pl_vcu_enc_wready0(vcu_enc_00_axi_WREADY),
        .pl_vcu_enc_wready1(vcu_enc_10_axi_WREADY),
        .pl_vcu_mcu_m_axi_ic_dc_arready(vcu_mcu_axi_ARREADY),
        .pl_vcu_mcu_m_axi_ic_dc_awready(vcu_mcu_axi_AWREADY),
        .pl_vcu_mcu_m_axi_ic_dc_bid(vcu_mcu_axi_BID),
        .pl_vcu_mcu_m_axi_ic_dc_bresp(vcu_mcu_axi_BRESP),
        .pl_vcu_mcu_m_axi_ic_dc_bvalid(vcu_mcu_axi_BVALID),
        .pl_vcu_mcu_m_axi_ic_dc_rdata(vcu_mcu_axi_RDATA),
        .pl_vcu_mcu_m_axi_ic_dc_rid(vcu_mcu_axi_RID),
        .pl_vcu_mcu_m_axi_ic_dc_rlast(vcu_mcu_axi_RLAST),
        .pl_vcu_mcu_m_axi_ic_dc_rresp(vcu_mcu_axi_RRESP),
        .pl_vcu_mcu_m_axi_ic_dc_rvalid(vcu_mcu_axi_RVALID),
        .pl_vcu_mcu_m_axi_ic_dc_wready(vcu_mcu_axi_WREADY),
        .pl_vcu_rready_axi_lite_apb(vcu_2_axi_lite_RREADY),
        .pl_vcu_wdata_axi_lite_apb(vcu_2_axi_lite_WDATA),
        .pl_vcu_wstrb_axi_lite_apb(vcu_2_axi_lite_WSTRB),
        .pl_vcu_wvalid_axi_lite_apb(vcu_2_axi_lite_WVALID),
        .pll_ref_clk(vcu_ref_clk),
        .s_axi_lite_aclk(pl_clk01),
        .vcu_host_interrupt(vcu_irq),
        .vcu_pl_arready_axi_lite_apb(vcu_2_axi_lite_ARREADY),
        .vcu_pl_awready_axi_lite_apb(vcu_2_axi_lite_AWREADY),
        .vcu_pl_bresp_axi_lite_apb(vcu_2_axi_lite_BRESP),
        .vcu_pl_bvalid_axi_lite_apb(vcu_2_axi_lite_BVALID),
        .vcu_pl_dec_araddr0(vcu_dec_00_axi_ARADDR),
        .vcu_pl_dec_araddr1(vcu_dec_10_axi_ARADDR),
        .vcu_pl_dec_arburst0(vcu_dec_00_axi_ARBURST),
        .vcu_pl_dec_arburst1(vcu_dec_10_axi_ARBURST),
        .vcu_pl_dec_arcache0(vcu_dec_00_axi_ARCACHE),
        .vcu_pl_dec_arcache1(vcu_dec_10_axi_ARCACHE),
        .vcu_pl_dec_arid0(vcu_dec_00_axi_ARID),
        .vcu_pl_dec_arid1(vcu_dec_10_axi_ARID),
        .vcu_pl_dec_arlen0(vcu_dec_00_axi_ARLEN),
        .vcu_pl_dec_arlen1(vcu_dec_10_axi_ARLEN),
        .vcu_pl_dec_arlock0(vcu_dec_00_axi_ARLOCK),
        .vcu_pl_dec_arlock1(vcu_dec_10_axi_ARLOCK),
        .vcu_pl_dec_arprot0(vcu_dec_00_axi_ARPROT),
        .vcu_pl_dec_arprot1(vcu_dec_10_axi_ARPROT),
        .vcu_pl_dec_arqos0(vcu_dec_00_axi_ARQOS),
        .vcu_pl_dec_arqos1(vcu_dec_10_axi_ARQOS),
        .vcu_pl_dec_arregion0(vcu_dec_00_axi_ARREGION),
        .vcu_pl_dec_arregion1(vcu_dec_10_axi_ARREGION),
        .vcu_pl_dec_arsize0(vcu_dec_00_axi_ARSIZE),
        .vcu_pl_dec_arsize1(vcu_dec_10_axi_ARSIZE),
        .vcu_pl_dec_arvalid0(vcu_dec_00_axi_ARVALID),
        .vcu_pl_dec_arvalid1(vcu_dec_10_axi_ARVALID),
        .vcu_pl_dec_awaddr0(vcu_dec_00_axi_AWADDR),
        .vcu_pl_dec_awaddr1(vcu_dec_10_axi_AWADDR),
        .vcu_pl_dec_awburst0(vcu_dec_00_axi_AWBURST),
        .vcu_pl_dec_awburst1(vcu_dec_10_axi_AWBURST),
        .vcu_pl_dec_awcache0(vcu_dec_00_axi_AWCACHE),
        .vcu_pl_dec_awcache1(vcu_dec_10_axi_AWCACHE),
        .vcu_pl_dec_awid0(vcu_dec_00_axi_AWID),
        .vcu_pl_dec_awid1(vcu_dec_10_axi_AWID),
        .vcu_pl_dec_awlen0(vcu_dec_00_axi_AWLEN),
        .vcu_pl_dec_awlen1(vcu_dec_10_axi_AWLEN),
        .vcu_pl_dec_awlock0(vcu_dec_00_axi_AWLOCK),
        .vcu_pl_dec_awlock1(vcu_dec_10_axi_AWLOCK),
        .vcu_pl_dec_awprot0(vcu_dec_00_axi_AWPROT),
        .vcu_pl_dec_awprot1(vcu_dec_10_axi_AWPROT),
        .vcu_pl_dec_awqos0(vcu_dec_00_axi_AWQOS),
        .vcu_pl_dec_awqos1(vcu_dec_10_axi_AWQOS),
        .vcu_pl_dec_awregion0(vcu_dec_00_axi_AWREGION),
        .vcu_pl_dec_awregion1(vcu_dec_10_axi_AWREGION),
        .vcu_pl_dec_awsize0(vcu_dec_00_axi_AWSIZE),
        .vcu_pl_dec_awsize1(vcu_dec_10_axi_AWSIZE),
        .vcu_pl_dec_awvalid0(vcu_dec_00_axi_AWVALID),
        .vcu_pl_dec_awvalid1(vcu_dec_10_axi_AWVALID),
        .vcu_pl_dec_bready0(vcu_dec_00_axi_BREADY),
        .vcu_pl_dec_bready1(vcu_dec_10_axi_BREADY),
        .vcu_pl_dec_rready0(vcu_dec_00_axi_RREADY),
        .vcu_pl_dec_rready1(vcu_dec_10_axi_RREADY),
        .vcu_pl_dec_wdata0(vcu_dec_00_axi_WDATA),
        .vcu_pl_dec_wdata1(vcu_dec_10_axi_WDATA),
        .vcu_pl_dec_wlast0(vcu_dec_00_axi_WLAST),
        .vcu_pl_dec_wlast1(vcu_dec_10_axi_WLAST),
        .vcu_pl_dec_wstrb0(vcu_dec_00_axi_WSTRB),
        .vcu_pl_dec_wstrb1(vcu_dec_10_axi_WSTRB),
        .vcu_pl_dec_wvalid0(vcu_dec_00_axi_WVALID),
        .vcu_pl_dec_wvalid1(vcu_dec_10_axi_WVALID),
        .vcu_pl_enc_araddr0(vcu_enc_00_axi_ARADDR),
        .vcu_pl_enc_araddr1(vcu_enc_10_axi_ARADDR),
        .vcu_pl_enc_arburst0(vcu_enc_00_axi_ARBURST),
        .vcu_pl_enc_arburst1(vcu_enc_10_axi_ARBURST),
        .vcu_pl_enc_arcache0(vcu_enc_00_axi_ARCACHE),
        .vcu_pl_enc_arcache1(vcu_enc_10_axi_ARCACHE),
        .vcu_pl_enc_arid0(vcu_enc_00_axi_ARID),
        .vcu_pl_enc_arid1(vcu_enc_10_axi_ARID),
        .vcu_pl_enc_arlen0(vcu_enc_00_axi_ARLEN),
        .vcu_pl_enc_arlen1(vcu_enc_10_axi_ARLEN),
        .vcu_pl_enc_arlock0(vcu_enc_00_axi_ARLOCK),
        .vcu_pl_enc_arlock1(vcu_enc_10_axi_ARLOCK),
        .vcu_pl_enc_arprot0(vcu_enc_00_axi_ARPROT),
        .vcu_pl_enc_arprot1(vcu_enc_10_axi_ARPROT),
        .vcu_pl_enc_arqos0(vcu_enc_00_axi_ARQOS),
        .vcu_pl_enc_arqos1(vcu_enc_10_axi_ARQOS),
        .vcu_pl_enc_arregion0(vcu_enc_00_axi_ARREGION),
        .vcu_pl_enc_arregion1(vcu_enc_10_axi_ARREGION),
        .vcu_pl_enc_arsize0(vcu_enc_00_axi_ARSIZE),
        .vcu_pl_enc_arsize1(vcu_enc_10_axi_ARSIZE),
        .vcu_pl_enc_arvalid0(vcu_enc_00_axi_ARVALID),
        .vcu_pl_enc_arvalid1(vcu_enc_10_axi_ARVALID),
        .vcu_pl_enc_awaddr0(vcu_enc_00_axi_AWADDR),
        .vcu_pl_enc_awaddr1(vcu_enc_10_axi_AWADDR),
        .vcu_pl_enc_awburst0(vcu_enc_00_axi_AWBURST),
        .vcu_pl_enc_awburst1(vcu_enc_10_axi_AWBURST),
        .vcu_pl_enc_awcache0(vcu_enc_00_axi_AWCACHE),
        .vcu_pl_enc_awcache1(vcu_enc_10_axi_AWCACHE),
        .vcu_pl_enc_awid0(vcu_enc_00_axi_AWID),
        .vcu_pl_enc_awid1(vcu_enc_10_axi_AWID),
        .vcu_pl_enc_awlen0(vcu_enc_00_axi_AWLEN),
        .vcu_pl_enc_awlen1(vcu_enc_10_axi_AWLEN),
        .vcu_pl_enc_awlock0(vcu_enc_00_axi_AWLOCK),
        .vcu_pl_enc_awlock1(vcu_enc_10_axi_AWLOCK),
        .vcu_pl_enc_awprot0(vcu_enc_00_axi_AWPROT),
        .vcu_pl_enc_awprot1(vcu_enc_10_axi_AWPROT),
        .vcu_pl_enc_awqos0(vcu_enc_00_axi_AWQOS),
        .vcu_pl_enc_awqos1(vcu_enc_10_axi_AWQOS),
        .vcu_pl_enc_awregion0(vcu_enc_00_axi_AWREGION),
        .vcu_pl_enc_awregion1(vcu_enc_10_axi_AWREGION),
        .vcu_pl_enc_awsize0(vcu_enc_00_axi_AWSIZE),
        .vcu_pl_enc_awsize1(vcu_enc_10_axi_AWSIZE),
        .vcu_pl_enc_awvalid0(vcu_enc_00_axi_AWVALID),
        .vcu_pl_enc_awvalid1(vcu_enc_10_axi_AWVALID),
        .vcu_pl_enc_bready0(vcu_enc_00_axi_BREADY),
        .vcu_pl_enc_bready1(vcu_enc_10_axi_BREADY),
        .vcu_pl_enc_rready0(vcu_enc_00_axi_RREADY),
        .vcu_pl_enc_rready1(vcu_enc_10_axi_RREADY),
        .vcu_pl_enc_wdata0(vcu_enc_00_axi_WDATA),
        .vcu_pl_enc_wdata1(vcu_enc_10_axi_WDATA),
        .vcu_pl_enc_wlast0(vcu_enc_00_axi_WLAST),
        .vcu_pl_enc_wlast1(vcu_enc_10_axi_WLAST),
        .vcu_pl_enc_wstrb0(vcu_enc_00_axi_WSTRB),
        .vcu_pl_enc_wstrb1(vcu_enc_10_axi_WSTRB),
        .vcu_pl_enc_wvalid0(vcu_enc_00_axi_WVALID),
        .vcu_pl_enc_wvalid1(vcu_enc_10_axi_WVALID),
        .vcu_pl_mcu_m_axi_ic_dc_araddr(vcu_mcu_axi_ARADDR),
        .vcu_pl_mcu_m_axi_ic_dc_arburst(vcu_mcu_axi_ARBURST),
        .vcu_pl_mcu_m_axi_ic_dc_arcache(vcu_mcu_axi_ARCACHE),
        .vcu_pl_mcu_m_axi_ic_dc_arid(vcu_mcu_axi_ARID),
        .vcu_pl_mcu_m_axi_ic_dc_arlen(vcu_mcu_axi_ARLEN),
        .vcu_pl_mcu_m_axi_ic_dc_arlock(vcu_mcu_axi_ARLOCK),
        .vcu_pl_mcu_m_axi_ic_dc_arprot(vcu_mcu_axi_ARPROT),
        .vcu_pl_mcu_m_axi_ic_dc_arqos(vcu_mcu_axi_ARQOS),
        .vcu_pl_mcu_m_axi_ic_dc_arsize(vcu_mcu_axi_ARSIZE),
        .vcu_pl_mcu_m_axi_ic_dc_arvalid(vcu_mcu_axi_ARVALID),
        .vcu_pl_mcu_m_axi_ic_dc_awaddr(vcu_mcu_axi_AWADDR),
        .vcu_pl_mcu_m_axi_ic_dc_awburst(vcu_mcu_axi_AWBURST),
        .vcu_pl_mcu_m_axi_ic_dc_awcache(vcu_mcu_axi_AWCACHE),
        .vcu_pl_mcu_m_axi_ic_dc_awid(vcu_mcu_axi_AWID),
        .vcu_pl_mcu_m_axi_ic_dc_awlen(vcu_mcu_axi_AWLEN),
        .vcu_pl_mcu_m_axi_ic_dc_awlock(vcu_mcu_axi_AWLOCK),
        .vcu_pl_mcu_m_axi_ic_dc_awprot(vcu_mcu_axi_AWPROT),
        .vcu_pl_mcu_m_axi_ic_dc_awqos(vcu_mcu_axi_AWQOS),
        .vcu_pl_mcu_m_axi_ic_dc_awsize(vcu_mcu_axi_AWSIZE),
        .vcu_pl_mcu_m_axi_ic_dc_awvalid(vcu_mcu_axi_AWVALID),
        .vcu_pl_mcu_m_axi_ic_dc_bready(vcu_mcu_axi_BREADY),
        .vcu_pl_mcu_m_axi_ic_dc_rready(vcu_mcu_axi_RREADY),
        .vcu_pl_mcu_m_axi_ic_dc_wdata(vcu_mcu_axi_WDATA),
        .vcu_pl_mcu_m_axi_ic_dc_wlast(vcu_mcu_axi_WLAST),
        .vcu_pl_mcu_m_axi_ic_dc_wstrb(vcu_mcu_axi_WSTRB),
        .vcu_pl_mcu_m_axi_ic_dc_wvalid(vcu_mcu_axi_WVALID),
        .vcu_pl_rdata_axi_lite_apb(vcu_2_axi_lite_RDATA),
        .vcu_pl_rresp_axi_lite_apb(vcu_2_axi_lite_RRESP),
        .vcu_pl_rvalid_axi_lite_apb(vcu_2_axi_lite_RVALID),
        .vcu_pl_wready_axi_lite_apb(vcu_2_axi_lite_WREADY),
        .vcu_resetn(axi_lite_reset_10));
  vcu_trd_vcu_axi_lite_0_1 vcu_axi_lite_0
       (.ACLK(pl_clk01),
        .ARESETN(axi_lite_reset_10),
        .M00_ACLK(pl_clk01),
        .M00_ARESETN(axi_lite_reset_10),
        .M00_AXI_araddr(vcu_2_axi_lite_ARADDR),
        .M00_AXI_arprot(vcu_2_axi_lite_ARPROT),
        .M00_AXI_arready(vcu_2_axi_lite_ARREADY),
        .M00_AXI_arvalid(vcu_2_axi_lite_ARVALID),
        .M00_AXI_awaddr(vcu_2_axi_lite_AWADDR),
        .M00_AXI_awprot(vcu_2_axi_lite_AWPROT),
        .M00_AXI_awready(vcu_2_axi_lite_AWREADY),
        .M00_AXI_awvalid(vcu_2_axi_lite_AWVALID),
        .M00_AXI_bready(vcu_2_axi_lite_BREADY),
        .M00_AXI_bresp(vcu_2_axi_lite_BRESP),
        .M00_AXI_bvalid(vcu_2_axi_lite_BVALID),
        .M00_AXI_rdata(vcu_2_axi_lite_RDATA),
        .M00_AXI_rready(vcu_2_axi_lite_RREADY),
        .M00_AXI_rresp(vcu_2_axi_lite_RRESP),
        .M00_AXI_rvalid(vcu_2_axi_lite_RVALID),
        .M00_AXI_wdata(vcu_2_axi_lite_WDATA),
        .M00_AXI_wready(vcu_2_axi_lite_WREADY),
        .M00_AXI_wstrb(vcu_2_axi_lite_WSTRB),
        .M00_AXI_wvalid(vcu_2_axi_lite_WVALID),
        .M01_ACLK(pl_clk01),
        .M01_ARESETN(proc_sys_reset_vcu_0_peripheral_aresetn),
        .M01_AXI_araddr(vcu_axi_lite_0_M01_AXI_ARADDR),
        .M01_AXI_arprot(vcu_axi_lite_0_M01_AXI_ARPROT),
        .M01_AXI_arready(vcu_axi_lite_0_M01_AXI_ARREADY),
        .M01_AXI_arvalid(vcu_axi_lite_0_M01_AXI_ARVALID),
        .M01_AXI_awaddr(vcu_axi_lite_0_M01_AXI_AWADDR),
        .M01_AXI_awprot(vcu_axi_lite_0_M01_AXI_AWPROT),
        .M01_AXI_awready(vcu_axi_lite_0_M01_AXI_AWREADY),
        .M01_AXI_awvalid(vcu_axi_lite_0_M01_AXI_AWVALID),
        .M01_AXI_bready(vcu_axi_lite_0_M01_AXI_BREADY),
        .M01_AXI_bresp(vcu_axi_lite_0_M01_AXI_BRESP),
        .M01_AXI_bvalid(vcu_axi_lite_0_M01_AXI_BVALID),
        .M01_AXI_rdata(vcu_axi_lite_0_M01_AXI_RDATA),
        .M01_AXI_rready(vcu_axi_lite_0_M01_AXI_RREADY),
        .M01_AXI_rresp(vcu_axi_lite_0_M01_AXI_RRESP),
        .M01_AXI_rvalid(vcu_axi_lite_0_M01_AXI_RVALID),
        .M01_AXI_wdata(vcu_axi_lite_0_M01_AXI_WDATA),
        .M01_AXI_wready(vcu_axi_lite_0_M01_AXI_WREADY),
        .M01_AXI_wstrb(vcu_axi_lite_0_M01_AXI_WSTRB),
        .M01_AXI_wvalid(vcu_axi_lite_0_M01_AXI_WVALID),
        .M02_ACLK(pl_clk01),
        .M02_ARESETN(proc_sys_reset_vcu_0_peripheral_aresetn),
        .M02_AXI_araddr(vcu_axi_lite_0_M02_AXI_ARADDR),
        .M02_AXI_arprot(vcu_axi_lite_0_M02_AXI_ARPROT),
        .M02_AXI_arready(vcu_axi_lite_0_M02_AXI_ARREADY),
        .M02_AXI_arvalid(vcu_axi_lite_0_M02_AXI_ARVALID),
        .M02_AXI_awaddr(vcu_axi_lite_0_M02_AXI_AWADDR),
        .M02_AXI_awprot(vcu_axi_lite_0_M02_AXI_AWPROT),
        .M02_AXI_awready(vcu_axi_lite_0_M02_AXI_AWREADY),
        .M02_AXI_awvalid(vcu_axi_lite_0_M02_AXI_AWVALID),
        .M02_AXI_bready(vcu_axi_lite_0_M02_AXI_BREADY),
        .M02_AXI_bresp(vcu_axi_lite_0_M02_AXI_BRESP),
        .M02_AXI_bvalid(vcu_axi_lite_0_M02_AXI_BVALID),
        .M02_AXI_rdata(vcu_axi_lite_0_M02_AXI_RDATA),
        .M02_AXI_rready(vcu_axi_lite_0_M02_AXI_RREADY),
        .M02_AXI_rresp(vcu_axi_lite_0_M02_AXI_RRESP),
        .M02_AXI_rvalid(vcu_axi_lite_0_M02_AXI_RVALID),
        .M02_AXI_wdata(vcu_axi_lite_0_M02_AXI_WDATA),
        .M02_AXI_wready(vcu_axi_lite_0_M02_AXI_WREADY),
        .M02_AXI_wstrb(vcu_axi_lite_0_M02_AXI_WSTRB),
        .M02_AXI_wvalid(vcu_axi_lite_0_M02_AXI_WVALID),
        .M03_ACLK(pl_clk01),
        .M03_ARESETN(proc_sys_reset_vcu_0_peripheral_aresetn),
        .M03_AXI_araddr(vcu_axi_lite_0_M03_AXI_ARADDR),
        .M03_AXI_arready(vcu_axi_lite_0_M03_AXI_ARREADY),
        .M03_AXI_arvalid(vcu_axi_lite_0_M03_AXI_ARVALID),
        .M03_AXI_awaddr(vcu_axi_lite_0_M03_AXI_AWADDR),
        .M03_AXI_awready(vcu_axi_lite_0_M03_AXI_AWREADY),
        .M03_AXI_awvalid(vcu_axi_lite_0_M03_AXI_AWVALID),
        .M03_AXI_bready(vcu_axi_lite_0_M03_AXI_BREADY),
        .M03_AXI_bresp(vcu_axi_lite_0_M03_AXI_BRESP),
        .M03_AXI_bvalid(vcu_axi_lite_0_M03_AXI_BVALID),
        .M03_AXI_rdata(vcu_axi_lite_0_M03_AXI_RDATA),
        .M03_AXI_rready(vcu_axi_lite_0_M03_AXI_RREADY),
        .M03_AXI_rresp(vcu_axi_lite_0_M03_AXI_RRESP),
        .M03_AXI_rvalid(vcu_axi_lite_0_M03_AXI_RVALID),
        .M03_AXI_wdata(vcu_axi_lite_0_M03_AXI_WDATA),
        .M03_AXI_wready(vcu_axi_lite_0_M03_AXI_WREADY),
        .M03_AXI_wstrb(vcu_axi_lite_0_M03_AXI_WSTRB),
        .M03_AXI_wvalid(vcu_axi_lite_0_M03_AXI_WVALID),
        .S00_ACLK(pl_clk01),
        .S00_ARESETN(axi_lite_reset_10),
        .S00_AXI_araddr(axi_lite_2_zynq_ARADDR),
        .S00_AXI_arburst(axi_lite_2_zynq_ARBURST),
        .S00_AXI_arcache(axi_lite_2_zynq_ARCACHE),
        .S00_AXI_arid(axi_lite_2_zynq_ARID),
        .S00_AXI_arlen(axi_lite_2_zynq_ARLEN),
        .S00_AXI_arlock(axi_lite_2_zynq_ARLOCK),
        .S00_AXI_arprot(axi_lite_2_zynq_ARPROT),
        .S00_AXI_arqos(axi_lite_2_zynq_ARQOS),
        .S00_AXI_arready(axi_lite_2_zynq_ARREADY),
        .S00_AXI_arsize(axi_lite_2_zynq_ARSIZE),
        .S00_AXI_arvalid(axi_lite_2_zynq_ARVALID),
        .S00_AXI_awaddr(axi_lite_2_zynq_AWADDR),
        .S00_AXI_awburst(axi_lite_2_zynq_AWBURST),
        .S00_AXI_awcache(axi_lite_2_zynq_AWCACHE),
        .S00_AXI_awid(axi_lite_2_zynq_AWID),
        .S00_AXI_awlen(axi_lite_2_zynq_AWLEN),
        .S00_AXI_awlock(axi_lite_2_zynq_AWLOCK),
        .S00_AXI_awprot(axi_lite_2_zynq_AWPROT),
        .S00_AXI_awqos(axi_lite_2_zynq_AWQOS),
        .S00_AXI_awready(axi_lite_2_zynq_AWREADY),
        .S00_AXI_awsize(axi_lite_2_zynq_AWSIZE),
        .S00_AXI_awvalid(axi_lite_2_zynq_AWVALID),
        .S00_AXI_bid(axi_lite_2_zynq_BID),
        .S00_AXI_bready(axi_lite_2_zynq_BREADY),
        .S00_AXI_bresp(axi_lite_2_zynq_BRESP),
        .S00_AXI_bvalid(axi_lite_2_zynq_BVALID),
        .S00_AXI_rdata(axi_lite_2_zynq_RDATA),
        .S00_AXI_rid(axi_lite_2_zynq_RID),
        .S00_AXI_rlast(axi_lite_2_zynq_RLAST),
        .S00_AXI_rready(axi_lite_2_zynq_RREADY),
        .S00_AXI_rresp(axi_lite_2_zynq_RRESP),
        .S00_AXI_rvalid(axi_lite_2_zynq_RVALID),
        .S00_AXI_wdata(axi_lite_2_zynq_WDATA),
        .S00_AXI_wlast(axi_lite_2_zynq_WLAST),
        .S00_AXI_wready(axi_lite_2_zynq_WREADY),
        .S00_AXI_wstrb(axi_lite_2_zynq_WSTRB),
        .S00_AXI_wvalid(axi_lite_2_zynq_WVALID));
  vcu_trd_vcu_clk_wiz0_1 vcu_clk_wiz0
       (.clk_in1(pl_clk01),
        .clk_out1(vcu_ref_clk),
        .clk_out2(pl_clk10),
        .locked(vcu_clk_locked2),
        .s_axi_aclk(pl_clk01),
        .s_axi_araddr(vcu_axi_lite_0_M03_AXI_ARADDR[10:0]),
        .s_axi_aresetn(proc_sys_reset_vcu_0_peripheral_aresetn),
        .s_axi_arready(vcu_axi_lite_0_M03_AXI_ARREADY),
        .s_axi_arvalid(vcu_axi_lite_0_M03_AXI_ARVALID),
        .s_axi_awaddr(vcu_axi_lite_0_M03_AXI_AWADDR[10:0]),
        .s_axi_awready(vcu_axi_lite_0_M03_AXI_AWREADY),
        .s_axi_awvalid(vcu_axi_lite_0_M03_AXI_AWVALID),
        .s_axi_bready(vcu_axi_lite_0_M03_AXI_BREADY),
        .s_axi_bresp(vcu_axi_lite_0_M03_AXI_BRESP),
        .s_axi_bvalid(vcu_axi_lite_0_M03_AXI_BVALID),
        .s_axi_rdata(vcu_axi_lite_0_M03_AXI_RDATA),
        .s_axi_rready(vcu_axi_lite_0_M03_AXI_RREADY),
        .s_axi_rresp(vcu_axi_lite_0_M03_AXI_RRESP),
        .s_axi_rvalid(vcu_axi_lite_0_M03_AXI_RVALID),
        .s_axi_wdata(vcu_axi_lite_0_M03_AXI_WDATA),
        .s_axi_wready(vcu_axi_lite_0_M03_AXI_WREADY),
        .s_axi_wstrb(vcu_axi_lite_0_M03_AXI_WSTRB),
        .s_axi_wvalid(vcu_axi_lite_0_M03_AXI_WVALID));
  vcu_trd_vcu_dec0_reg_slice_1 vcu_dec0_reg_slice
       (.aclk(pl_clk10),
        .aresetn(vcu_reset_slice4),
        .m_axi_araddr(vcu_dec_01_axi_ARADDR),
        .m_axi_arburst(vcu_dec_01_axi_ARBURST),
        .m_axi_arcache(vcu_dec_01_axi_ARCACHE),
        .m_axi_arid(vcu_dec_01_axi_ARID),
        .m_axi_arlen(vcu_dec_01_axi_ARLEN),
        .m_axi_arlock(vcu_dec_01_axi_ARLOCK),
        .m_axi_arprot(vcu_dec_01_axi_ARPROT),
        .m_axi_arqos(vcu_dec_01_axi_ARQOS),
        .m_axi_arready(vcu_dec_01_axi_ARREADY),
        .m_axi_arsize(vcu_dec_01_axi_ARSIZE),
        .m_axi_arvalid(vcu_dec_01_axi_ARVALID),
        .m_axi_awaddr(vcu_dec_01_axi_AWADDR),
        .m_axi_awburst(vcu_dec_01_axi_AWBURST),
        .m_axi_awcache(vcu_dec_01_axi_AWCACHE),
        .m_axi_awid(vcu_dec_01_axi_AWID),
        .m_axi_awlen(vcu_dec_01_axi_AWLEN),
        .m_axi_awlock(vcu_dec_01_axi_AWLOCK),
        .m_axi_awprot(vcu_dec_01_axi_AWPROT),
        .m_axi_awqos(vcu_dec_01_axi_AWQOS),
        .m_axi_awready(vcu_dec_01_axi_AWREADY),
        .m_axi_awsize(vcu_dec_01_axi_AWSIZE),
        .m_axi_awvalid(vcu_dec_01_axi_AWVALID),
        .m_axi_bid(vcu_dec_01_axi_BID[3:0]),
        .m_axi_bready(vcu_dec_01_axi_BREADY),
        .m_axi_bresp(vcu_dec_01_axi_BRESP),
        .m_axi_bvalid(vcu_dec_01_axi_BVALID),
        .m_axi_rdata(vcu_dec_01_axi_RDATA),
        .m_axi_rid(vcu_dec_01_axi_RID[3:0]),
        .m_axi_rlast(vcu_dec_01_axi_RLAST),
        .m_axi_rready(vcu_dec_01_axi_RREADY),
        .m_axi_rresp(vcu_dec_01_axi_RRESP),
        .m_axi_rvalid(vcu_dec_01_axi_RVALID),
        .m_axi_wdata(vcu_dec_01_axi_WDATA),
        .m_axi_wlast(vcu_dec_01_axi_WLAST),
        .m_axi_wready(vcu_dec_01_axi_WREADY),
        .m_axi_wstrb(vcu_dec_01_axi_WSTRB),
        .m_axi_wvalid(vcu_dec_01_axi_WVALID),
        .s_axi_araddr(vcu_dec_00_axi_ARADDR),
        .s_axi_arburst(vcu_dec_00_axi_ARBURST),
        .s_axi_arcache(vcu_dec_00_axi_ARCACHE),
        .s_axi_arid(vcu_dec_00_axi_ARID),
        .s_axi_arlen(vcu_dec_00_axi_ARLEN),
        .s_axi_arlock(vcu_dec_00_axi_ARLOCK),
        .s_axi_arprot(vcu_dec_00_axi_ARPROT),
        .s_axi_arqos(vcu_dec_00_axi_ARQOS),
        .s_axi_arready(vcu_dec_00_axi_ARREADY),
        .s_axi_arregion(vcu_dec_00_axi_ARREGION),
        .s_axi_arsize(vcu_dec_00_axi_ARSIZE),
        .s_axi_arvalid(vcu_dec_00_axi_ARVALID),
        .s_axi_awaddr(vcu_dec_00_axi_AWADDR),
        .s_axi_awburst(vcu_dec_00_axi_AWBURST),
        .s_axi_awcache(vcu_dec_00_axi_AWCACHE),
        .s_axi_awid(vcu_dec_00_axi_AWID),
        .s_axi_awlen(vcu_dec_00_axi_AWLEN),
        .s_axi_awlock(vcu_dec_00_axi_AWLOCK),
        .s_axi_awprot(vcu_dec_00_axi_AWPROT),
        .s_axi_awqos(vcu_dec_00_axi_AWQOS),
        .s_axi_awready(vcu_dec_00_axi_AWREADY),
        .s_axi_awregion(vcu_dec_00_axi_AWREGION),
        .s_axi_awsize(vcu_dec_00_axi_AWSIZE),
        .s_axi_awvalid(vcu_dec_00_axi_AWVALID),
        .s_axi_bid(vcu_dec_00_axi_BID),
        .s_axi_bready(vcu_dec_00_axi_BREADY),
        .s_axi_bresp(vcu_dec_00_axi_BRESP),
        .s_axi_bvalid(vcu_dec_00_axi_BVALID),
        .s_axi_rdata(vcu_dec_00_axi_RDATA),
        .s_axi_rid(vcu_dec_00_axi_RID),
        .s_axi_rlast(vcu_dec_00_axi_RLAST),
        .s_axi_rready(vcu_dec_00_axi_RREADY),
        .s_axi_rresp(vcu_dec_00_axi_RRESP),
        .s_axi_rvalid(vcu_dec_00_axi_RVALID),
        .s_axi_wdata(vcu_dec_00_axi_WDATA),
        .s_axi_wlast(vcu_dec_00_axi_WLAST),
        .s_axi_wready(vcu_dec_00_axi_WREADY),
        .s_axi_wstrb(vcu_dec_00_axi_WSTRB),
        .s_axi_wvalid(vcu_dec_00_axi_WVALID));
  vcu_trd_vcu_dec1_reg_slice_1 vcu_dec1_reg_slice
       (.aclk(pl_clk10),
        .aresetn(vcu_reset_slice4),
        .m_axi_araddr(vcu_dec_11_axi_ARADDR),
        .m_axi_arburst(vcu_dec_11_axi_ARBURST),
        .m_axi_arcache(vcu_dec_11_axi_ARCACHE),
        .m_axi_arid(vcu_dec_11_axi_ARID),
        .m_axi_arlen(vcu_dec_11_axi_ARLEN),
        .m_axi_arlock(vcu_dec_11_axi_ARLOCK),
        .m_axi_arprot(vcu_dec_11_axi_ARPROT),
        .m_axi_arqos(vcu_dec_11_axi_ARQOS),
        .m_axi_arready(vcu_dec_11_axi_ARREADY),
        .m_axi_arsize(vcu_dec_11_axi_ARSIZE),
        .m_axi_arvalid(vcu_dec_11_axi_ARVALID),
        .m_axi_awaddr(vcu_dec_11_axi_AWADDR),
        .m_axi_awburst(vcu_dec_11_axi_AWBURST),
        .m_axi_awcache(vcu_dec_11_axi_AWCACHE),
        .m_axi_awid(vcu_dec_11_axi_AWID),
        .m_axi_awlen(vcu_dec_11_axi_AWLEN),
        .m_axi_awlock(vcu_dec_11_axi_AWLOCK),
        .m_axi_awprot(vcu_dec_11_axi_AWPROT),
        .m_axi_awqos(vcu_dec_11_axi_AWQOS),
        .m_axi_awready(vcu_dec_11_axi_AWREADY),
        .m_axi_awsize(vcu_dec_11_axi_AWSIZE),
        .m_axi_awvalid(vcu_dec_11_axi_AWVALID),
        .m_axi_bid(vcu_dec_11_axi_BID[3:0]),
        .m_axi_bready(vcu_dec_11_axi_BREADY),
        .m_axi_bresp(vcu_dec_11_axi_BRESP),
        .m_axi_bvalid(vcu_dec_11_axi_BVALID),
        .m_axi_rdata(vcu_dec_11_axi_RDATA),
        .m_axi_rid(vcu_dec_11_axi_RID[3:0]),
        .m_axi_rlast(vcu_dec_11_axi_RLAST),
        .m_axi_rready(vcu_dec_11_axi_RREADY),
        .m_axi_rresp(vcu_dec_11_axi_RRESP),
        .m_axi_rvalid(vcu_dec_11_axi_RVALID),
        .m_axi_wdata(vcu_dec_11_axi_WDATA),
        .m_axi_wlast(vcu_dec_11_axi_WLAST),
        .m_axi_wready(vcu_dec_11_axi_WREADY),
        .m_axi_wstrb(vcu_dec_11_axi_WSTRB),
        .m_axi_wvalid(vcu_dec_11_axi_WVALID),
        .s_axi_araddr(vcu_dec_10_axi_ARADDR),
        .s_axi_arburst(vcu_dec_10_axi_ARBURST),
        .s_axi_arcache(vcu_dec_10_axi_ARCACHE),
        .s_axi_arid(vcu_dec_10_axi_ARID),
        .s_axi_arlen(vcu_dec_10_axi_ARLEN),
        .s_axi_arlock(vcu_dec_10_axi_ARLOCK),
        .s_axi_arprot(vcu_dec_10_axi_ARPROT),
        .s_axi_arqos(vcu_dec_10_axi_ARQOS),
        .s_axi_arready(vcu_dec_10_axi_ARREADY),
        .s_axi_arregion(vcu_dec_10_axi_ARREGION),
        .s_axi_arsize(vcu_dec_10_axi_ARSIZE),
        .s_axi_arvalid(vcu_dec_10_axi_ARVALID),
        .s_axi_awaddr(vcu_dec_10_axi_AWADDR),
        .s_axi_awburst(vcu_dec_10_axi_AWBURST),
        .s_axi_awcache(vcu_dec_10_axi_AWCACHE),
        .s_axi_awid(vcu_dec_10_axi_AWID),
        .s_axi_awlen(vcu_dec_10_axi_AWLEN),
        .s_axi_awlock(vcu_dec_10_axi_AWLOCK),
        .s_axi_awprot(vcu_dec_10_axi_AWPROT),
        .s_axi_awqos(vcu_dec_10_axi_AWQOS),
        .s_axi_awready(vcu_dec_10_axi_AWREADY),
        .s_axi_awregion(vcu_dec_10_axi_AWREGION),
        .s_axi_awsize(vcu_dec_10_axi_AWSIZE),
        .s_axi_awvalid(vcu_dec_10_axi_AWVALID),
        .s_axi_bid(vcu_dec_10_axi_BID),
        .s_axi_bready(vcu_dec_10_axi_BREADY),
        .s_axi_bresp(vcu_dec_10_axi_BRESP),
        .s_axi_bvalid(vcu_dec_10_axi_BVALID),
        .s_axi_rdata(vcu_dec_10_axi_RDATA),
        .s_axi_rid(vcu_dec_10_axi_RID),
        .s_axi_rlast(vcu_dec_10_axi_RLAST),
        .s_axi_rready(vcu_dec_10_axi_RREADY),
        .s_axi_rresp(vcu_dec_10_axi_RRESP),
        .s_axi_rvalid(vcu_dec_10_axi_RVALID),
        .s_axi_wdata(vcu_dec_10_axi_WDATA),
        .s_axi_wlast(vcu_dec_10_axi_WLAST),
        .s_axi_wready(vcu_dec_10_axi_WREADY),
        .s_axi_wstrb(vcu_dec_10_axi_WSTRB),
        .s_axi_wvalid(vcu_dec_10_axi_WVALID));
  vcu_trd_vcu_enc0_reg_slice_1 vcu_enc0_reg_slice
       (.aclk(pl_clk10),
        .aresetn(vcu_reset_slice4),
        .m_axi_araddr(vcu_enc_01_axi_ARADDR),
        .m_axi_arburst(vcu_enc_01_axi_ARBURST),
        .m_axi_arcache(vcu_enc_01_axi_ARCACHE),
        .m_axi_arid(vcu_enc_01_axi_ARID),
        .m_axi_arlen(vcu_enc_01_axi_ARLEN),
        .m_axi_arlock(vcu_enc_01_axi_ARLOCK),
        .m_axi_arprot(vcu_enc_01_axi_ARPROT),
        .m_axi_arqos(vcu_enc_01_axi_ARQOS),
        .m_axi_arready(vcu_enc_01_axi_ARREADY),
        .m_axi_arsize(vcu_enc_01_axi_ARSIZE),
        .m_axi_arvalid(vcu_enc_01_axi_ARVALID),
        .m_axi_awaddr(vcu_enc_01_axi_AWADDR),
        .m_axi_awburst(vcu_enc_01_axi_AWBURST),
        .m_axi_awcache(vcu_enc_01_axi_AWCACHE),
        .m_axi_awid(vcu_enc_01_axi_AWID),
        .m_axi_awlen(vcu_enc_01_axi_AWLEN),
        .m_axi_awlock(vcu_enc_01_axi_AWLOCK),
        .m_axi_awprot(vcu_enc_01_axi_AWPROT),
        .m_axi_awqos(vcu_enc_01_axi_AWQOS),
        .m_axi_awready(vcu_enc_01_axi_AWREADY),
        .m_axi_awsize(vcu_enc_01_axi_AWSIZE),
        .m_axi_awvalid(vcu_enc_01_axi_AWVALID),
        .m_axi_bid(vcu_enc_01_axi_BID[3:0]),
        .m_axi_bready(vcu_enc_01_axi_BREADY),
        .m_axi_bresp(vcu_enc_01_axi_BRESP),
        .m_axi_bvalid(vcu_enc_01_axi_BVALID),
        .m_axi_rdata(vcu_enc_01_axi_RDATA),
        .m_axi_rid(vcu_enc_01_axi_RID[3:0]),
        .m_axi_rlast(vcu_enc_01_axi_RLAST),
        .m_axi_rready(vcu_enc_01_axi_RREADY),
        .m_axi_rresp(vcu_enc_01_axi_RRESP),
        .m_axi_rvalid(vcu_enc_01_axi_RVALID),
        .m_axi_wdata(vcu_enc_01_axi_WDATA),
        .m_axi_wlast(vcu_enc_01_axi_WLAST),
        .m_axi_wready(vcu_enc_01_axi_WREADY),
        .m_axi_wstrb(vcu_enc_01_axi_WSTRB),
        .m_axi_wvalid(vcu_enc_01_axi_WVALID),
        .s_axi_araddr(vcu_enc_00_axi_ARADDR),
        .s_axi_arburst(vcu_enc_00_axi_ARBURST),
        .s_axi_arcache(vcu_enc_00_axi_ARCACHE),
        .s_axi_arid(vcu_enc_00_axi_ARID),
        .s_axi_arlen(vcu_enc_00_axi_ARLEN),
        .s_axi_arlock(vcu_enc_00_axi_ARLOCK),
        .s_axi_arprot(vcu_enc_00_axi_ARPROT),
        .s_axi_arqos(vcu_enc_00_axi_ARQOS),
        .s_axi_arready(vcu_enc_00_axi_ARREADY),
        .s_axi_arregion(vcu_enc_00_axi_ARREGION),
        .s_axi_arsize(vcu_enc_00_axi_ARSIZE),
        .s_axi_arvalid(vcu_enc_00_axi_ARVALID),
        .s_axi_awaddr(vcu_enc_00_axi_AWADDR),
        .s_axi_awburst(vcu_enc_00_axi_AWBURST),
        .s_axi_awcache(vcu_enc_00_axi_AWCACHE),
        .s_axi_awid(vcu_enc_00_axi_AWID),
        .s_axi_awlen(vcu_enc_00_axi_AWLEN),
        .s_axi_awlock(vcu_enc_00_axi_AWLOCK),
        .s_axi_awprot(vcu_enc_00_axi_AWPROT),
        .s_axi_awqos(vcu_enc_00_axi_AWQOS),
        .s_axi_awready(vcu_enc_00_axi_AWREADY),
        .s_axi_awregion(vcu_enc_00_axi_AWREGION),
        .s_axi_awsize(vcu_enc_00_axi_AWSIZE),
        .s_axi_awvalid(vcu_enc_00_axi_AWVALID),
        .s_axi_bid(vcu_enc_00_axi_BID),
        .s_axi_bready(vcu_enc_00_axi_BREADY),
        .s_axi_bresp(vcu_enc_00_axi_BRESP),
        .s_axi_bvalid(vcu_enc_00_axi_BVALID),
        .s_axi_rdata(vcu_enc_00_axi_RDATA),
        .s_axi_rid(vcu_enc_00_axi_RID),
        .s_axi_rlast(vcu_enc_00_axi_RLAST),
        .s_axi_rready(vcu_enc_00_axi_RREADY),
        .s_axi_rresp(vcu_enc_00_axi_RRESP),
        .s_axi_rvalid(vcu_enc_00_axi_RVALID),
        .s_axi_wdata(vcu_enc_00_axi_WDATA),
        .s_axi_wlast(vcu_enc_00_axi_WLAST),
        .s_axi_wready(vcu_enc_00_axi_WREADY),
        .s_axi_wstrb(vcu_enc_00_axi_WSTRB),
        .s_axi_wvalid(vcu_enc_00_axi_WVALID));
  vcu_trd_vcu_enc1_reg_slice_1 vcu_enc1_reg_slice
       (.aclk(pl_clk10),
        .aresetn(vcu_reset_slice4),
        .m_axi_araddr(vcu_enc_11_axi_ARADDR),
        .m_axi_arburst(vcu_enc_11_axi_ARBURST),
        .m_axi_arcache(vcu_enc_11_axi_ARCACHE),
        .m_axi_arid(vcu_enc_11_axi_ARID),
        .m_axi_arlen(vcu_enc_11_axi_ARLEN),
        .m_axi_arlock(vcu_enc_11_axi_ARLOCK),
        .m_axi_arprot(vcu_enc_11_axi_ARPROT),
        .m_axi_arqos(vcu_enc_11_axi_ARQOS),
        .m_axi_arready(vcu_enc_11_axi_ARREADY),
        .m_axi_arsize(vcu_enc_11_axi_ARSIZE),
        .m_axi_arvalid(vcu_enc_11_axi_ARVALID),
        .m_axi_awaddr(vcu_enc_11_axi_AWADDR),
        .m_axi_awburst(vcu_enc_11_axi_AWBURST),
        .m_axi_awcache(vcu_enc_11_axi_AWCACHE),
        .m_axi_awid(vcu_enc_11_axi_AWID),
        .m_axi_awlen(vcu_enc_11_axi_AWLEN),
        .m_axi_awlock(vcu_enc_11_axi_AWLOCK),
        .m_axi_awprot(vcu_enc_11_axi_AWPROT),
        .m_axi_awqos(vcu_enc_11_axi_AWQOS),
        .m_axi_awready(vcu_enc_11_axi_AWREADY),
        .m_axi_awsize(vcu_enc_11_axi_AWSIZE),
        .m_axi_awvalid(vcu_enc_11_axi_AWVALID),
        .m_axi_bid(vcu_enc_11_axi_BID[3:0]),
        .m_axi_bready(vcu_enc_11_axi_BREADY),
        .m_axi_bresp(vcu_enc_11_axi_BRESP),
        .m_axi_bvalid(vcu_enc_11_axi_BVALID),
        .m_axi_rdata(vcu_enc_11_axi_RDATA),
        .m_axi_rid(vcu_enc_11_axi_RID[3:0]),
        .m_axi_rlast(vcu_enc_11_axi_RLAST),
        .m_axi_rready(vcu_enc_11_axi_RREADY),
        .m_axi_rresp(vcu_enc_11_axi_RRESP),
        .m_axi_rvalid(vcu_enc_11_axi_RVALID),
        .m_axi_wdata(vcu_enc_11_axi_WDATA),
        .m_axi_wlast(vcu_enc_11_axi_WLAST),
        .m_axi_wready(vcu_enc_11_axi_WREADY),
        .m_axi_wstrb(vcu_enc_11_axi_WSTRB),
        .m_axi_wvalid(vcu_enc_11_axi_WVALID),
        .s_axi_araddr(vcu_enc_10_axi_ARADDR),
        .s_axi_arburst(vcu_enc_10_axi_ARBURST),
        .s_axi_arcache(vcu_enc_10_axi_ARCACHE),
        .s_axi_arid(vcu_enc_10_axi_ARID),
        .s_axi_arlen(vcu_enc_10_axi_ARLEN),
        .s_axi_arlock(vcu_enc_10_axi_ARLOCK),
        .s_axi_arprot(vcu_enc_10_axi_ARPROT),
        .s_axi_arqos(vcu_enc_10_axi_ARQOS),
        .s_axi_arready(vcu_enc_10_axi_ARREADY),
        .s_axi_arregion(vcu_enc_10_axi_ARREGION),
        .s_axi_arsize(vcu_enc_10_axi_ARSIZE),
        .s_axi_arvalid(vcu_enc_10_axi_ARVALID),
        .s_axi_awaddr(vcu_enc_10_axi_AWADDR),
        .s_axi_awburst(vcu_enc_10_axi_AWBURST),
        .s_axi_awcache(vcu_enc_10_axi_AWCACHE),
        .s_axi_awid(vcu_enc_10_axi_AWID),
        .s_axi_awlen(vcu_enc_10_axi_AWLEN),
        .s_axi_awlock(vcu_enc_10_axi_AWLOCK),
        .s_axi_awprot(vcu_enc_10_axi_AWPROT),
        .s_axi_awqos(vcu_enc_10_axi_AWQOS),
        .s_axi_awready(vcu_enc_10_axi_AWREADY),
        .s_axi_awregion(vcu_enc_10_axi_AWREGION),
        .s_axi_awsize(vcu_enc_10_axi_AWSIZE),
        .s_axi_awvalid(vcu_enc_10_axi_AWVALID),
        .s_axi_bid(vcu_enc_10_axi_BID),
        .s_axi_bready(vcu_enc_10_axi_BREADY),
        .s_axi_bresp(vcu_enc_10_axi_BRESP),
        .s_axi_bvalid(vcu_enc_10_axi_BVALID),
        .s_axi_rdata(vcu_enc_10_axi_RDATA),
        .s_axi_rid(vcu_enc_10_axi_RID),
        .s_axi_rlast(vcu_enc_10_axi_RLAST),
        .s_axi_rready(vcu_enc_10_axi_RREADY),
        .s_axi_rresp(vcu_enc_10_axi_RRESP),
        .s_axi_rvalid(vcu_enc_10_axi_RVALID),
        .s_axi_wdata(vcu_enc_10_axi_WDATA),
        .s_axi_wlast(vcu_enc_10_axi_WLAST),
        .s_axi_wready(vcu_enc_10_axi_WREADY),
        .s_axi_wstrb(vcu_enc_10_axi_WSTRB),
        .s_axi_wvalid(vcu_enc_10_axi_WVALID));
  vcu_trd_vcu_interrupt_1 vcu_interrupt
       (.In0(vcu_irq),
        .dout(vcu_irq_to_ps));
  vcu_trd_vcu_mcu_reg_slice_1 vcu_mcu_reg_slice
       (.aclk(pl_clk10),
        .aresetn(vcu_reset_slice4),
        .m_axi_araddr(vcu_mcu_axi_1_ARADDR),
        .m_axi_arburst(vcu_mcu_axi_1_ARBURST),
        .m_axi_arcache(vcu_mcu_axi_1_ARCACHE),
        .m_axi_arid(vcu_mcu_axi_1_ARID),
        .m_axi_arlen(vcu_mcu_axi_1_ARLEN),
        .m_axi_arlock(vcu_mcu_axi_1_ARLOCK),
        .m_axi_arprot(vcu_mcu_axi_1_ARPROT),
        .m_axi_arqos(vcu_mcu_axi_1_ARQOS),
        .m_axi_arready(vcu_mcu_axi_1_ARREADY),
        .m_axi_arsize(vcu_mcu_axi_1_ARSIZE),
        .m_axi_arvalid(vcu_mcu_axi_1_ARVALID),
        .m_axi_awaddr(vcu_mcu_axi_1_AWADDR),
        .m_axi_awburst(vcu_mcu_axi_1_AWBURST),
        .m_axi_awcache(vcu_mcu_axi_1_AWCACHE),
        .m_axi_awid(vcu_mcu_axi_1_AWID),
        .m_axi_awlen(vcu_mcu_axi_1_AWLEN),
        .m_axi_awlock(vcu_mcu_axi_1_AWLOCK),
        .m_axi_awprot(vcu_mcu_axi_1_AWPROT),
        .m_axi_awqos(vcu_mcu_axi_1_AWQOS),
        .m_axi_awready(vcu_mcu_axi_1_AWREADY),
        .m_axi_awsize(vcu_mcu_axi_1_AWSIZE),
        .m_axi_awvalid(vcu_mcu_axi_1_AWVALID),
        .m_axi_bid(vcu_mcu_axi_1_BID[2:0]),
        .m_axi_bready(vcu_mcu_axi_1_BREADY),
        .m_axi_bresp(vcu_mcu_axi_1_BRESP),
        .m_axi_bvalid(vcu_mcu_axi_1_BVALID),
        .m_axi_rdata(vcu_mcu_axi_1_RDATA),
        .m_axi_rid(vcu_mcu_axi_1_RID[2:0]),
        .m_axi_rlast(vcu_mcu_axi_1_RLAST),
        .m_axi_rready(vcu_mcu_axi_1_RREADY),
        .m_axi_rresp(vcu_mcu_axi_1_RRESP),
        .m_axi_rvalid(vcu_mcu_axi_1_RVALID),
        .m_axi_wdata(vcu_mcu_axi_1_WDATA),
        .m_axi_wlast(vcu_mcu_axi_1_WLAST),
        .m_axi_wready(vcu_mcu_axi_1_WREADY),
        .m_axi_wstrb(vcu_mcu_axi_1_WSTRB),
        .m_axi_wvalid(vcu_mcu_axi_1_WVALID),
        .s_axi_araddr(vcu_mcu_axi_ARADDR),
        .s_axi_arburst(vcu_mcu_axi_ARBURST),
        .s_axi_arcache(vcu_mcu_axi_ARCACHE),
        .s_axi_arid(vcu_mcu_axi_ARID),
        .s_axi_arlen(vcu_mcu_axi_ARLEN),
        .s_axi_arlock(vcu_mcu_axi_ARLOCK),
        .s_axi_arprot(vcu_mcu_axi_ARPROT),
        .s_axi_arqos(vcu_mcu_axi_ARQOS),
        .s_axi_arready(vcu_mcu_axi_ARREADY),
        .s_axi_arregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arsize(vcu_mcu_axi_ARSIZE),
        .s_axi_arvalid(vcu_mcu_axi_ARVALID),
        .s_axi_awaddr(vcu_mcu_axi_AWADDR),
        .s_axi_awburst(vcu_mcu_axi_AWBURST),
        .s_axi_awcache(vcu_mcu_axi_AWCACHE),
        .s_axi_awid(vcu_mcu_axi_AWID),
        .s_axi_awlen(vcu_mcu_axi_AWLEN),
        .s_axi_awlock(vcu_mcu_axi_AWLOCK),
        .s_axi_awprot(vcu_mcu_axi_AWPROT),
        .s_axi_awqos(vcu_mcu_axi_AWQOS),
        .s_axi_awready(vcu_mcu_axi_AWREADY),
        .s_axi_awregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awsize(vcu_mcu_axi_AWSIZE),
        .s_axi_awvalid(vcu_mcu_axi_AWVALID),
        .s_axi_bid(vcu_mcu_axi_BID),
        .s_axi_bready(vcu_mcu_axi_BREADY),
        .s_axi_bresp(vcu_mcu_axi_BRESP),
        .s_axi_bvalid(vcu_mcu_axi_BVALID),
        .s_axi_rdata(vcu_mcu_axi_RDATA),
        .s_axi_rid(vcu_mcu_axi_RID),
        .s_axi_rlast(vcu_mcu_axi_RLAST),
        .s_axi_rready(vcu_mcu_axi_RREADY),
        .s_axi_rresp(vcu_mcu_axi_RRESP),
        .s_axi_rvalid(vcu_mcu_axi_RVALID),
        .s_axi_wdata(vcu_mcu_axi_WDATA),
        .s_axi_wlast(vcu_mcu_axi_WLAST),
        .s_axi_wready(vcu_mcu_axi_WREADY),
        .s_axi_wstrb(vcu_mcu_axi_WSTRB),
        .s_axi_wvalid(vcu_mcu_axi_WVALID));
  vcu_trd_zynq_ultra_ps_e_0_1 zynq_ultra_ps_e_0
       (.maxigp2_araddr(axi_lite_2_zynq_ARADDR),
        .maxigp2_arburst(axi_lite_2_zynq_ARBURST),
        .maxigp2_arcache(axi_lite_2_zynq_ARCACHE),
        .maxigp2_arid(axi_lite_2_zynq_ARID),
        .maxigp2_arlen(axi_lite_2_zynq_ARLEN),
        .maxigp2_arlock(axi_lite_2_zynq_ARLOCK),
        .maxigp2_arprot(axi_lite_2_zynq_ARPROT),
        .maxigp2_arqos(axi_lite_2_zynq_ARQOS),
        .maxigp2_arready(axi_lite_2_zynq_ARREADY),
        .maxigp2_arsize(axi_lite_2_zynq_ARSIZE),
        .maxigp2_arvalid(axi_lite_2_zynq_ARVALID),
        .maxigp2_awaddr(axi_lite_2_zynq_AWADDR),
        .maxigp2_awburst(axi_lite_2_zynq_AWBURST),
        .maxigp2_awcache(axi_lite_2_zynq_AWCACHE),
        .maxigp2_awid(axi_lite_2_zynq_AWID),
        .maxigp2_awlen(axi_lite_2_zynq_AWLEN),
        .maxigp2_awlock(axi_lite_2_zynq_AWLOCK),
        .maxigp2_awprot(axi_lite_2_zynq_AWPROT),
        .maxigp2_awqos(axi_lite_2_zynq_AWQOS),
        .maxigp2_awready(axi_lite_2_zynq_AWREADY),
        .maxigp2_awsize(axi_lite_2_zynq_AWSIZE),
        .maxigp2_awvalid(axi_lite_2_zynq_AWVALID),
        .maxigp2_bid(axi_lite_2_zynq_BID),
        .maxigp2_bready(axi_lite_2_zynq_BREADY),
        .maxigp2_bresp(axi_lite_2_zynq_BRESP),
        .maxigp2_bvalid(axi_lite_2_zynq_BVALID),
        .maxigp2_rdata(axi_lite_2_zynq_RDATA),
        .maxigp2_rid(axi_lite_2_zynq_RID),
        .maxigp2_rlast(axi_lite_2_zynq_RLAST),
        .maxigp2_rready(axi_lite_2_zynq_RREADY),
        .maxigp2_rresp(axi_lite_2_zynq_RRESP),
        .maxigp2_rvalid(axi_lite_2_zynq_RVALID),
        .maxigp2_wdata(axi_lite_2_zynq_WDATA),
        .maxigp2_wlast(axi_lite_2_zynq_WLAST),
        .maxigp2_wready(axi_lite_2_zynq_WREADY),
        .maxigp2_wstrb(axi_lite_2_zynq_WSTRB),
        .maxigp2_wvalid(axi_lite_2_zynq_WVALID),
        .maxihpm0_lpd_aclk(pl_clk01),
        .pl_clk0(pl_clk01),
        .pl_ps_irq0(vcu_irq_to_ps),
        .pl_resetn0(pl_reset_axi),
        .saxigp0_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,vcu_mcu_axi_1_ARADDR}),
        .saxigp0_arburst(vcu_mcu_axi_1_ARBURST),
        .saxigp0_arcache(vcu_mcu_axi_1_ARCACHE),
        .saxigp0_arid({1'b0,1'b0,1'b0,vcu_mcu_axi_1_ARID}),
        .saxigp0_arlen(vcu_mcu_axi_1_ARLEN),
        .saxigp0_arlock(vcu_mcu_axi_1_ARLOCK),
        .saxigp0_arprot(vcu_mcu_axi_1_ARPROT),
        .saxigp0_arqos(vcu_mcu_axi_1_ARQOS),
        .saxigp0_arready(vcu_mcu_axi_1_ARREADY),
        .saxigp0_arsize(vcu_mcu_axi_1_ARSIZE),
        .saxigp0_aruser(1'b0),
        .saxigp0_arvalid(vcu_mcu_axi_1_ARVALID),
        .saxigp0_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,vcu_mcu_axi_1_AWADDR}),
        .saxigp0_awburst(vcu_mcu_axi_1_AWBURST),
        .saxigp0_awcache(vcu_mcu_axi_1_AWCACHE),
        .saxigp0_awid({1'b0,1'b0,1'b0,vcu_mcu_axi_1_AWID}),
        .saxigp0_awlen(vcu_mcu_axi_1_AWLEN),
        .saxigp0_awlock(vcu_mcu_axi_1_AWLOCK),
        .saxigp0_awprot(vcu_mcu_axi_1_AWPROT),
        .saxigp0_awqos(vcu_mcu_axi_1_AWQOS),
        .saxigp0_awready(vcu_mcu_axi_1_AWREADY),
        .saxigp0_awsize(vcu_mcu_axi_1_AWSIZE),
        .saxigp0_awuser(1'b0),
        .saxigp0_awvalid(vcu_mcu_axi_1_AWVALID),
        .saxigp0_bid(vcu_mcu_axi_1_BID),
        .saxigp0_bready(vcu_mcu_axi_1_BREADY),
        .saxigp0_bresp(vcu_mcu_axi_1_BRESP),
        .saxigp0_bvalid(vcu_mcu_axi_1_BVALID),
        .saxigp0_rdata(vcu_mcu_axi_1_RDATA),
        .saxigp0_rid(vcu_mcu_axi_1_RID),
        .saxigp0_rlast(vcu_mcu_axi_1_RLAST),
        .saxigp0_rready(vcu_mcu_axi_1_RREADY),
        .saxigp0_rresp(vcu_mcu_axi_1_RRESP),
        .saxigp0_rvalid(vcu_mcu_axi_1_RVALID),
        .saxigp0_wdata(vcu_mcu_axi_1_WDATA),
        .saxigp0_wlast(vcu_mcu_axi_1_WLAST),
        .saxigp0_wready(vcu_mcu_axi_1_WREADY),
        .saxigp0_wstrb(vcu_mcu_axi_1_WSTRB),
        .saxigp0_wvalid(vcu_mcu_axi_1_WVALID),
        .saxigp2_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,vcu_enc_01_axi_ARADDR}),
        .saxigp2_arburst(vcu_enc_01_axi_ARBURST),
        .saxigp2_arcache(vcu_enc_01_axi_ARCACHE),
        .saxigp2_arid({1'b0,1'b0,vcu_enc_01_axi_ARID}),
        .saxigp2_arlen(vcu_enc_01_axi_ARLEN),
        .saxigp2_arlock(vcu_enc_01_axi_ARLOCK),
        .saxigp2_arprot(vcu_enc_01_axi_ARPROT),
        .saxigp2_arqos(vcu_enc_01_axi_ARQOS),
        .saxigp2_arready(vcu_enc_01_axi_ARREADY),
        .saxigp2_arsize(vcu_enc_01_axi_ARSIZE),
        .saxigp2_aruser(1'b0),
        .saxigp2_arvalid(vcu_enc_01_axi_ARVALID),
        .saxigp2_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,vcu_enc_01_axi_AWADDR}),
        .saxigp2_awburst(vcu_enc_01_axi_AWBURST),
        .saxigp2_awcache(vcu_enc_01_axi_AWCACHE),
        .saxigp2_awid({1'b0,1'b0,vcu_enc_01_axi_AWID}),
        .saxigp2_awlen(vcu_enc_01_axi_AWLEN),
        .saxigp2_awlock(vcu_enc_01_axi_AWLOCK),
        .saxigp2_awprot(vcu_enc_01_axi_AWPROT),
        .saxigp2_awqos(vcu_enc_01_axi_AWQOS),
        .saxigp2_awready(vcu_enc_01_axi_AWREADY),
        .saxigp2_awsize(vcu_enc_01_axi_AWSIZE),
        .saxigp2_awuser(1'b0),
        .saxigp2_awvalid(vcu_enc_01_axi_AWVALID),
        .saxigp2_bid(vcu_enc_01_axi_BID),
        .saxigp2_bready(vcu_enc_01_axi_BREADY),
        .saxigp2_bresp(vcu_enc_01_axi_BRESP),
        .saxigp2_bvalid(vcu_enc_01_axi_BVALID),
        .saxigp2_rdata(vcu_enc_01_axi_RDATA),
        .saxigp2_rid(vcu_enc_01_axi_RID),
        .saxigp2_rlast(vcu_enc_01_axi_RLAST),
        .saxigp2_rready(vcu_enc_01_axi_RREADY),
        .saxigp2_rresp(vcu_enc_01_axi_RRESP),
        .saxigp2_rvalid(vcu_enc_01_axi_RVALID),
        .saxigp2_wdata(vcu_enc_01_axi_WDATA),
        .saxigp2_wlast(vcu_enc_01_axi_WLAST),
        .saxigp2_wready(vcu_enc_01_axi_WREADY),
        .saxigp2_wstrb(vcu_enc_01_axi_WSTRB),
        .saxigp2_wvalid(vcu_enc_01_axi_WVALID),
        .saxigp3_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,vcu_enc_11_axi_ARADDR}),
        .saxigp3_arburst(vcu_enc_11_axi_ARBURST),
        .saxigp3_arcache(vcu_enc_11_axi_ARCACHE),
        .saxigp3_arid({1'b0,1'b0,vcu_enc_11_axi_ARID}),
        .saxigp3_arlen(vcu_enc_11_axi_ARLEN),
        .saxigp3_arlock(vcu_enc_11_axi_ARLOCK),
        .saxigp3_arprot(vcu_enc_11_axi_ARPROT),
        .saxigp3_arqos(vcu_enc_11_axi_ARQOS),
        .saxigp3_arready(vcu_enc_11_axi_ARREADY),
        .saxigp3_arsize(vcu_enc_11_axi_ARSIZE),
        .saxigp3_aruser(1'b0),
        .saxigp3_arvalid(vcu_enc_11_axi_ARVALID),
        .saxigp3_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,vcu_enc_11_axi_AWADDR}),
        .saxigp3_awburst(vcu_enc_11_axi_AWBURST),
        .saxigp3_awcache(vcu_enc_11_axi_AWCACHE),
        .saxigp3_awid({1'b0,1'b0,vcu_enc_11_axi_AWID}),
        .saxigp3_awlen(vcu_enc_11_axi_AWLEN),
        .saxigp3_awlock(vcu_enc_11_axi_AWLOCK),
        .saxigp3_awprot(vcu_enc_11_axi_AWPROT),
        .saxigp3_awqos(vcu_enc_11_axi_AWQOS),
        .saxigp3_awready(vcu_enc_11_axi_AWREADY),
        .saxigp3_awsize(vcu_enc_11_axi_AWSIZE),
        .saxigp3_awuser(1'b0),
        .saxigp3_awvalid(vcu_enc_11_axi_AWVALID),
        .saxigp3_bid(vcu_enc_11_axi_BID),
        .saxigp3_bready(vcu_enc_11_axi_BREADY),
        .saxigp3_bresp(vcu_enc_11_axi_BRESP),
        .saxigp3_bvalid(vcu_enc_11_axi_BVALID),
        .saxigp3_rdata(vcu_enc_11_axi_RDATA),
        .saxigp3_rid(vcu_enc_11_axi_RID),
        .saxigp3_rlast(vcu_enc_11_axi_RLAST),
        .saxigp3_rready(vcu_enc_11_axi_RREADY),
        .saxigp3_rresp(vcu_enc_11_axi_RRESP),
        .saxigp3_rvalid(vcu_enc_11_axi_RVALID),
        .saxigp3_wdata(vcu_enc_11_axi_WDATA),
        .saxigp3_wlast(vcu_enc_11_axi_WLAST),
        .saxigp3_wready(vcu_enc_11_axi_WREADY),
        .saxigp3_wstrb(vcu_enc_11_axi_WSTRB),
        .saxigp3_wvalid(vcu_enc_11_axi_WVALID),
        .saxigp4_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,vcu_dec_01_axi_ARADDR}),
        .saxigp4_arburst(vcu_dec_01_axi_ARBURST),
        .saxigp4_arcache(vcu_dec_01_axi_ARCACHE),
        .saxigp4_arid({1'b0,1'b0,vcu_dec_01_axi_ARID}),
        .saxigp4_arlen(vcu_dec_01_axi_ARLEN),
        .saxigp4_arlock(vcu_dec_01_axi_ARLOCK),
        .saxigp4_arprot(vcu_dec_01_axi_ARPROT),
        .saxigp4_arqos(vcu_dec_01_axi_ARQOS),
        .saxigp4_arready(vcu_dec_01_axi_ARREADY),
        .saxigp4_arsize(vcu_dec_01_axi_ARSIZE),
        .saxigp4_aruser(1'b0),
        .saxigp4_arvalid(vcu_dec_01_axi_ARVALID),
        .saxigp4_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,vcu_dec_01_axi_AWADDR}),
        .saxigp4_awburst(vcu_dec_01_axi_AWBURST),
        .saxigp4_awcache(vcu_dec_01_axi_AWCACHE),
        .saxigp4_awid({1'b0,1'b0,vcu_dec_01_axi_AWID}),
        .saxigp4_awlen(vcu_dec_01_axi_AWLEN),
        .saxigp4_awlock(vcu_dec_01_axi_AWLOCK),
        .saxigp4_awprot(vcu_dec_01_axi_AWPROT),
        .saxigp4_awqos(vcu_dec_01_axi_AWQOS),
        .saxigp4_awready(vcu_dec_01_axi_AWREADY),
        .saxigp4_awsize(vcu_dec_01_axi_AWSIZE),
        .saxigp4_awuser(1'b0),
        .saxigp4_awvalid(vcu_dec_01_axi_AWVALID),
        .saxigp4_bid(vcu_dec_01_axi_BID),
        .saxigp4_bready(vcu_dec_01_axi_BREADY),
        .saxigp4_bresp(vcu_dec_01_axi_BRESP),
        .saxigp4_bvalid(vcu_dec_01_axi_BVALID),
        .saxigp4_rdata(vcu_dec_01_axi_RDATA),
        .saxigp4_rid(vcu_dec_01_axi_RID),
        .saxigp4_rlast(vcu_dec_01_axi_RLAST),
        .saxigp4_rready(vcu_dec_01_axi_RREADY),
        .saxigp4_rresp(vcu_dec_01_axi_RRESP),
        .saxigp4_rvalid(vcu_dec_01_axi_RVALID),
        .saxigp4_wdata(vcu_dec_01_axi_WDATA),
        .saxigp4_wlast(vcu_dec_01_axi_WLAST),
        .saxigp4_wready(vcu_dec_01_axi_WREADY),
        .saxigp4_wstrb(vcu_dec_01_axi_WSTRB),
        .saxigp4_wvalid(vcu_dec_01_axi_WVALID),
        .saxigp5_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,vcu_dec_11_axi_ARADDR}),
        .saxigp5_arburst(vcu_dec_11_axi_ARBURST),
        .saxigp5_arcache(vcu_dec_11_axi_ARCACHE),
        .saxigp5_arid({1'b0,1'b0,vcu_dec_11_axi_ARID}),
        .saxigp5_arlen(vcu_dec_11_axi_ARLEN),
        .saxigp5_arlock(vcu_dec_11_axi_ARLOCK),
        .saxigp5_arprot(vcu_dec_11_axi_ARPROT),
        .saxigp5_arqos(vcu_dec_11_axi_ARQOS),
        .saxigp5_arready(vcu_dec_11_axi_ARREADY),
        .saxigp5_arsize(vcu_dec_11_axi_ARSIZE),
        .saxigp5_aruser(1'b0),
        .saxigp5_arvalid(vcu_dec_11_axi_ARVALID),
        .saxigp5_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,vcu_dec_11_axi_AWADDR}),
        .saxigp5_awburst(vcu_dec_11_axi_AWBURST),
        .saxigp5_awcache(vcu_dec_11_axi_AWCACHE),
        .saxigp5_awid({1'b0,1'b0,vcu_dec_11_axi_AWID}),
        .saxigp5_awlen(vcu_dec_11_axi_AWLEN),
        .saxigp5_awlock(vcu_dec_11_axi_AWLOCK),
        .saxigp5_awprot(vcu_dec_11_axi_AWPROT),
        .saxigp5_awqos(vcu_dec_11_axi_AWQOS),
        .saxigp5_awready(vcu_dec_11_axi_AWREADY),
        .saxigp5_awsize(vcu_dec_11_axi_AWSIZE),
        .saxigp5_awuser(1'b0),
        .saxigp5_awvalid(vcu_dec_11_axi_AWVALID),
        .saxigp5_bid(vcu_dec_11_axi_BID),
        .saxigp5_bready(vcu_dec_11_axi_BREADY),
        .saxigp5_bresp(vcu_dec_11_axi_BRESP),
        .saxigp5_bvalid(vcu_dec_11_axi_BVALID),
        .saxigp5_rdata(vcu_dec_11_axi_RDATA),
        .saxigp5_rid(vcu_dec_11_axi_RID),
        .saxigp5_rlast(vcu_dec_11_axi_RLAST),
        .saxigp5_rready(vcu_dec_11_axi_RREADY),
        .saxigp5_rresp(vcu_dec_11_axi_RRESP),
        .saxigp5_rvalid(vcu_dec_11_axi_RVALID),
        .saxigp5_wdata(vcu_dec_11_axi_WDATA),
        .saxigp5_wlast(vcu_dec_11_axi_WLAST),
        .saxigp5_wready(vcu_dec_11_axi_WREADY),
        .saxigp5_wstrb(vcu_dec_11_axi_WSTRB),
        .saxigp5_wvalid(vcu_dec_11_axi_WVALID),
        .saxihp0_fpd_aclk(pl_clk10),
        .saxihp1_fpd_aclk(pl_clk10),
        .saxihp2_fpd_aclk(pl_clk10),
        .saxihp3_fpd_aclk(pl_clk10),
        .saxihpc0_fpd_aclk(pl_clk10));
endmodule

module vcu_trd_vcu_axi_lite_0_1
   (ACLK,
    ARESETN,
    M00_ACLK,
    M00_ARESETN,
    M00_AXI_araddr,
    M00_AXI_arprot,
    M00_AXI_arready,
    M00_AXI_arvalid,
    M00_AXI_awaddr,
    M00_AXI_awprot,
    M00_AXI_awready,
    M00_AXI_awvalid,
    M00_AXI_bready,
    M00_AXI_bresp,
    M00_AXI_bvalid,
    M00_AXI_rdata,
    M00_AXI_rready,
    M00_AXI_rresp,
    M00_AXI_rvalid,
    M00_AXI_wdata,
    M00_AXI_wready,
    M00_AXI_wstrb,
    M00_AXI_wvalid,
    M01_ACLK,
    M01_ARESETN,
    M01_AXI_araddr,
    M01_AXI_arprot,
    M01_AXI_arready,
    M01_AXI_arvalid,
    M01_AXI_awaddr,
    M01_AXI_awprot,
    M01_AXI_awready,
    M01_AXI_awvalid,
    M01_AXI_bready,
    M01_AXI_bresp,
    M01_AXI_bvalid,
    M01_AXI_rdata,
    M01_AXI_rready,
    M01_AXI_rresp,
    M01_AXI_rvalid,
    M01_AXI_wdata,
    M01_AXI_wready,
    M01_AXI_wstrb,
    M01_AXI_wvalid,
    M02_ACLK,
    M02_ARESETN,
    M02_AXI_araddr,
    M02_AXI_arprot,
    M02_AXI_arready,
    M02_AXI_arvalid,
    M02_AXI_awaddr,
    M02_AXI_awprot,
    M02_AXI_awready,
    M02_AXI_awvalid,
    M02_AXI_bready,
    M02_AXI_bresp,
    M02_AXI_bvalid,
    M02_AXI_rdata,
    M02_AXI_rready,
    M02_AXI_rresp,
    M02_AXI_rvalid,
    M02_AXI_wdata,
    M02_AXI_wready,
    M02_AXI_wstrb,
    M02_AXI_wvalid,
    M03_ACLK,
    M03_ARESETN,
    M03_AXI_araddr,
    M03_AXI_arready,
    M03_AXI_arvalid,
    M03_AXI_awaddr,
    M03_AXI_awready,
    M03_AXI_awvalid,
    M03_AXI_bready,
    M03_AXI_bresp,
    M03_AXI_bvalid,
    M03_AXI_rdata,
    M03_AXI_rready,
    M03_AXI_rresp,
    M03_AXI_rvalid,
    M03_AXI_wdata,
    M03_AXI_wready,
    M03_AXI_wstrb,
    M03_AXI_wvalid,
    S00_ACLK,
    S00_ARESETN,
    S00_AXI_araddr,
    S00_AXI_arburst,
    S00_AXI_arcache,
    S00_AXI_arid,
    S00_AXI_arlen,
    S00_AXI_arlock,
    S00_AXI_arprot,
    S00_AXI_arqos,
    S00_AXI_arready,
    S00_AXI_arsize,
    S00_AXI_arvalid,
    S00_AXI_awaddr,
    S00_AXI_awburst,
    S00_AXI_awcache,
    S00_AXI_awid,
    S00_AXI_awlen,
    S00_AXI_awlock,
    S00_AXI_awprot,
    S00_AXI_awqos,
    S00_AXI_awready,
    S00_AXI_awsize,
    S00_AXI_awvalid,
    S00_AXI_bid,
    S00_AXI_bready,
    S00_AXI_bresp,
    S00_AXI_bvalid,
    S00_AXI_rdata,
    S00_AXI_rid,
    S00_AXI_rlast,
    S00_AXI_rready,
    S00_AXI_rresp,
    S00_AXI_rvalid,
    S00_AXI_wdata,
    S00_AXI_wlast,
    S00_AXI_wready,
    S00_AXI_wstrb,
    S00_AXI_wvalid);
  input ACLK;
  input ARESETN;
  input M00_ACLK;
  input M00_ARESETN;
  output [39:0]M00_AXI_araddr;
  output [2:0]M00_AXI_arprot;
  input [0:0]M00_AXI_arready;
  output [0:0]M00_AXI_arvalid;
  output [39:0]M00_AXI_awaddr;
  output [2:0]M00_AXI_awprot;
  input [0:0]M00_AXI_awready;
  output [0:0]M00_AXI_awvalid;
  output [0:0]M00_AXI_bready;
  input [1:0]M00_AXI_bresp;
  input [0:0]M00_AXI_bvalid;
  input [31:0]M00_AXI_rdata;
  output [0:0]M00_AXI_rready;
  input [1:0]M00_AXI_rresp;
  input [0:0]M00_AXI_rvalid;
  output [31:0]M00_AXI_wdata;
  input [0:0]M00_AXI_wready;
  output [3:0]M00_AXI_wstrb;
  output [0:0]M00_AXI_wvalid;
  input M01_ACLK;
  input M01_ARESETN;
  output [39:0]M01_AXI_araddr;
  output [2:0]M01_AXI_arprot;
  input M01_AXI_arready;
  output M01_AXI_arvalid;
  output [39:0]M01_AXI_awaddr;
  output [2:0]M01_AXI_awprot;
  input M01_AXI_awready;
  output M01_AXI_awvalid;
  output M01_AXI_bready;
  input [1:0]M01_AXI_bresp;
  input M01_AXI_bvalid;
  input [31:0]M01_AXI_rdata;
  output M01_AXI_rready;
  input [1:0]M01_AXI_rresp;
  input M01_AXI_rvalid;
  output [31:0]M01_AXI_wdata;
  input M01_AXI_wready;
  output [3:0]M01_AXI_wstrb;
  output M01_AXI_wvalid;
  input M02_ACLK;
  input M02_ARESETN;
  output [39:0]M02_AXI_araddr;
  output [2:0]M02_AXI_arprot;
  input [0:0]M02_AXI_arready;
  output [0:0]M02_AXI_arvalid;
  output [39:0]M02_AXI_awaddr;
  output [2:0]M02_AXI_awprot;
  input [0:0]M02_AXI_awready;
  output [0:0]M02_AXI_awvalid;
  output [0:0]M02_AXI_bready;
  input [1:0]M02_AXI_bresp;
  input [0:0]M02_AXI_bvalid;
  input [31:0]M02_AXI_rdata;
  output [0:0]M02_AXI_rready;
  input [1:0]M02_AXI_rresp;
  input [0:0]M02_AXI_rvalid;
  output [31:0]M02_AXI_wdata;
  input [0:0]M02_AXI_wready;
  output [3:0]M02_AXI_wstrb;
  output [0:0]M02_AXI_wvalid;
  input M03_ACLK;
  input M03_ARESETN;
  output [39:0]M03_AXI_araddr;
  input M03_AXI_arready;
  output M03_AXI_arvalid;
  output [39:0]M03_AXI_awaddr;
  input M03_AXI_awready;
  output M03_AXI_awvalid;
  output M03_AXI_bready;
  input [1:0]M03_AXI_bresp;
  input M03_AXI_bvalid;
  input [31:0]M03_AXI_rdata;
  output M03_AXI_rready;
  input [1:0]M03_AXI_rresp;
  input M03_AXI_rvalid;
  output [31:0]M03_AXI_wdata;
  input M03_AXI_wready;
  output [3:0]M03_AXI_wstrb;
  output M03_AXI_wvalid;
  input S00_ACLK;
  input S00_ARESETN;
  input [39:0]S00_AXI_araddr;
  input [1:0]S00_AXI_arburst;
  input [3:0]S00_AXI_arcache;
  input [15:0]S00_AXI_arid;
  input [7:0]S00_AXI_arlen;
  input S00_AXI_arlock;
  input [2:0]S00_AXI_arprot;
  input [3:0]S00_AXI_arqos;
  output S00_AXI_arready;
  input [2:0]S00_AXI_arsize;
  input S00_AXI_arvalid;
  input [39:0]S00_AXI_awaddr;
  input [1:0]S00_AXI_awburst;
  input [3:0]S00_AXI_awcache;
  input [15:0]S00_AXI_awid;
  input [7:0]S00_AXI_awlen;
  input S00_AXI_awlock;
  input [2:0]S00_AXI_awprot;
  input [3:0]S00_AXI_awqos;
  output S00_AXI_awready;
  input [2:0]S00_AXI_awsize;
  input S00_AXI_awvalid;
  output [15:0]S00_AXI_bid;
  input S00_AXI_bready;
  output [1:0]S00_AXI_bresp;
  output S00_AXI_bvalid;
  output [31:0]S00_AXI_rdata;
  output [15:0]S00_AXI_rid;
  output S00_AXI_rlast;
  input S00_AXI_rready;
  output [1:0]S00_AXI_rresp;
  output S00_AXI_rvalid;
  input [31:0]S00_AXI_wdata;
  input S00_AXI_wlast;
  output S00_AXI_wready;
  input [3:0]S00_AXI_wstrb;
  input S00_AXI_wvalid;

  wire M00_ACLK_1;
  wire M00_ARESETN_1;
  wire M01_ACLK_1;
  wire M01_ARESETN_1;
  wire M02_ACLK_1;
  wire M02_ARESETN_1;
  wire M03_ACLK_1;
  wire M03_ARESETN_1;
  wire S00_ACLK_1;
  wire S00_ARESETN_1;
  wire [39:0]m00_couplers_to_vcu_axi_lite_0_ARADDR;
  wire [2:0]m00_couplers_to_vcu_axi_lite_0_ARPROT;
  wire [0:0]m00_couplers_to_vcu_axi_lite_0_ARREADY;
  wire [0:0]m00_couplers_to_vcu_axi_lite_0_ARVALID;
  wire [39:0]m00_couplers_to_vcu_axi_lite_0_AWADDR;
  wire [2:0]m00_couplers_to_vcu_axi_lite_0_AWPROT;
  wire [0:0]m00_couplers_to_vcu_axi_lite_0_AWREADY;
  wire [0:0]m00_couplers_to_vcu_axi_lite_0_AWVALID;
  wire [0:0]m00_couplers_to_vcu_axi_lite_0_BREADY;
  wire [1:0]m00_couplers_to_vcu_axi_lite_0_BRESP;
  wire [0:0]m00_couplers_to_vcu_axi_lite_0_BVALID;
  wire [31:0]m00_couplers_to_vcu_axi_lite_0_RDATA;
  wire [0:0]m00_couplers_to_vcu_axi_lite_0_RREADY;
  wire [1:0]m00_couplers_to_vcu_axi_lite_0_RRESP;
  wire [0:0]m00_couplers_to_vcu_axi_lite_0_RVALID;
  wire [31:0]m00_couplers_to_vcu_axi_lite_0_WDATA;
  wire [0:0]m00_couplers_to_vcu_axi_lite_0_WREADY;
  wire [3:0]m00_couplers_to_vcu_axi_lite_0_WSTRB;
  wire [0:0]m00_couplers_to_vcu_axi_lite_0_WVALID;
  wire [39:0]m01_couplers_to_vcu_axi_lite_0_ARADDR;
  wire [2:0]m01_couplers_to_vcu_axi_lite_0_ARPROT;
  wire m01_couplers_to_vcu_axi_lite_0_ARREADY;
  wire m01_couplers_to_vcu_axi_lite_0_ARVALID;
  wire [39:0]m01_couplers_to_vcu_axi_lite_0_AWADDR;
  wire [2:0]m01_couplers_to_vcu_axi_lite_0_AWPROT;
  wire m01_couplers_to_vcu_axi_lite_0_AWREADY;
  wire m01_couplers_to_vcu_axi_lite_0_AWVALID;
  wire m01_couplers_to_vcu_axi_lite_0_BREADY;
  wire [1:0]m01_couplers_to_vcu_axi_lite_0_BRESP;
  wire m01_couplers_to_vcu_axi_lite_0_BVALID;
  wire [31:0]m01_couplers_to_vcu_axi_lite_0_RDATA;
  wire m01_couplers_to_vcu_axi_lite_0_RREADY;
  wire [1:0]m01_couplers_to_vcu_axi_lite_0_RRESP;
  wire m01_couplers_to_vcu_axi_lite_0_RVALID;
  wire [31:0]m01_couplers_to_vcu_axi_lite_0_WDATA;
  wire m01_couplers_to_vcu_axi_lite_0_WREADY;
  wire [3:0]m01_couplers_to_vcu_axi_lite_0_WSTRB;
  wire m01_couplers_to_vcu_axi_lite_0_WVALID;
  wire [39:0]m02_couplers_to_vcu_axi_lite_0_ARADDR;
  wire [2:0]m02_couplers_to_vcu_axi_lite_0_ARPROT;
  wire [0:0]m02_couplers_to_vcu_axi_lite_0_ARREADY;
  wire [0:0]m02_couplers_to_vcu_axi_lite_0_ARVALID;
  wire [39:0]m02_couplers_to_vcu_axi_lite_0_AWADDR;
  wire [2:0]m02_couplers_to_vcu_axi_lite_0_AWPROT;
  wire [0:0]m02_couplers_to_vcu_axi_lite_0_AWREADY;
  wire [0:0]m02_couplers_to_vcu_axi_lite_0_AWVALID;
  wire [0:0]m02_couplers_to_vcu_axi_lite_0_BREADY;
  wire [1:0]m02_couplers_to_vcu_axi_lite_0_BRESP;
  wire [0:0]m02_couplers_to_vcu_axi_lite_0_BVALID;
  wire [31:0]m02_couplers_to_vcu_axi_lite_0_RDATA;
  wire [0:0]m02_couplers_to_vcu_axi_lite_0_RREADY;
  wire [1:0]m02_couplers_to_vcu_axi_lite_0_RRESP;
  wire [0:0]m02_couplers_to_vcu_axi_lite_0_RVALID;
  wire [31:0]m02_couplers_to_vcu_axi_lite_0_WDATA;
  wire [0:0]m02_couplers_to_vcu_axi_lite_0_WREADY;
  wire [3:0]m02_couplers_to_vcu_axi_lite_0_WSTRB;
  wire [0:0]m02_couplers_to_vcu_axi_lite_0_WVALID;
  wire [39:0]m03_couplers_to_vcu_axi_lite_0_ARADDR;
  wire m03_couplers_to_vcu_axi_lite_0_ARREADY;
  wire m03_couplers_to_vcu_axi_lite_0_ARVALID;
  wire [39:0]m03_couplers_to_vcu_axi_lite_0_AWADDR;
  wire m03_couplers_to_vcu_axi_lite_0_AWREADY;
  wire m03_couplers_to_vcu_axi_lite_0_AWVALID;
  wire m03_couplers_to_vcu_axi_lite_0_BREADY;
  wire [1:0]m03_couplers_to_vcu_axi_lite_0_BRESP;
  wire m03_couplers_to_vcu_axi_lite_0_BVALID;
  wire [31:0]m03_couplers_to_vcu_axi_lite_0_RDATA;
  wire m03_couplers_to_vcu_axi_lite_0_RREADY;
  wire [1:0]m03_couplers_to_vcu_axi_lite_0_RRESP;
  wire m03_couplers_to_vcu_axi_lite_0_RVALID;
  wire [31:0]m03_couplers_to_vcu_axi_lite_0_WDATA;
  wire m03_couplers_to_vcu_axi_lite_0_WREADY;
  wire [3:0]m03_couplers_to_vcu_axi_lite_0_WSTRB;
  wire m03_couplers_to_vcu_axi_lite_0_WVALID;
  wire [39:0]s00_couplers_to_xbar_ARADDR;
  wire [2:0]s00_couplers_to_xbar_ARPROT;
  wire [0:0]s00_couplers_to_xbar_ARREADY;
  wire s00_couplers_to_xbar_ARVALID;
  wire [39:0]s00_couplers_to_xbar_AWADDR;
  wire [2:0]s00_couplers_to_xbar_AWPROT;
  wire [0:0]s00_couplers_to_xbar_AWREADY;
  wire s00_couplers_to_xbar_AWVALID;
  wire s00_couplers_to_xbar_BREADY;
  wire [1:0]s00_couplers_to_xbar_BRESP;
  wire [0:0]s00_couplers_to_xbar_BVALID;
  wire [31:0]s00_couplers_to_xbar_RDATA;
  wire s00_couplers_to_xbar_RREADY;
  wire [1:0]s00_couplers_to_xbar_RRESP;
  wire [0:0]s00_couplers_to_xbar_RVALID;
  wire [31:0]s00_couplers_to_xbar_WDATA;
  wire [0:0]s00_couplers_to_xbar_WREADY;
  wire [3:0]s00_couplers_to_xbar_WSTRB;
  wire s00_couplers_to_xbar_WVALID;
  wire vcu_axi_lite_0_ACLK_net;
  wire vcu_axi_lite_0_ARESETN_net;
  wire [39:0]vcu_axi_lite_0_to_s00_couplers_ARADDR;
  wire [1:0]vcu_axi_lite_0_to_s00_couplers_ARBURST;
  wire [3:0]vcu_axi_lite_0_to_s00_couplers_ARCACHE;
  wire [15:0]vcu_axi_lite_0_to_s00_couplers_ARID;
  wire [7:0]vcu_axi_lite_0_to_s00_couplers_ARLEN;
  wire vcu_axi_lite_0_to_s00_couplers_ARLOCK;
  wire [2:0]vcu_axi_lite_0_to_s00_couplers_ARPROT;
  wire [3:0]vcu_axi_lite_0_to_s00_couplers_ARQOS;
  wire vcu_axi_lite_0_to_s00_couplers_ARREADY;
  wire [2:0]vcu_axi_lite_0_to_s00_couplers_ARSIZE;
  wire vcu_axi_lite_0_to_s00_couplers_ARVALID;
  wire [39:0]vcu_axi_lite_0_to_s00_couplers_AWADDR;
  wire [1:0]vcu_axi_lite_0_to_s00_couplers_AWBURST;
  wire [3:0]vcu_axi_lite_0_to_s00_couplers_AWCACHE;
  wire [15:0]vcu_axi_lite_0_to_s00_couplers_AWID;
  wire [7:0]vcu_axi_lite_0_to_s00_couplers_AWLEN;
  wire vcu_axi_lite_0_to_s00_couplers_AWLOCK;
  wire [2:0]vcu_axi_lite_0_to_s00_couplers_AWPROT;
  wire [3:0]vcu_axi_lite_0_to_s00_couplers_AWQOS;
  wire vcu_axi_lite_0_to_s00_couplers_AWREADY;
  wire [2:0]vcu_axi_lite_0_to_s00_couplers_AWSIZE;
  wire vcu_axi_lite_0_to_s00_couplers_AWVALID;
  wire [15:0]vcu_axi_lite_0_to_s00_couplers_BID;
  wire vcu_axi_lite_0_to_s00_couplers_BREADY;
  wire [1:0]vcu_axi_lite_0_to_s00_couplers_BRESP;
  wire vcu_axi_lite_0_to_s00_couplers_BVALID;
  wire [31:0]vcu_axi_lite_0_to_s00_couplers_RDATA;
  wire [15:0]vcu_axi_lite_0_to_s00_couplers_RID;
  wire vcu_axi_lite_0_to_s00_couplers_RLAST;
  wire vcu_axi_lite_0_to_s00_couplers_RREADY;
  wire [1:0]vcu_axi_lite_0_to_s00_couplers_RRESP;
  wire vcu_axi_lite_0_to_s00_couplers_RVALID;
  wire [31:0]vcu_axi_lite_0_to_s00_couplers_WDATA;
  wire vcu_axi_lite_0_to_s00_couplers_WLAST;
  wire vcu_axi_lite_0_to_s00_couplers_WREADY;
  wire [3:0]vcu_axi_lite_0_to_s00_couplers_WSTRB;
  wire vcu_axi_lite_0_to_s00_couplers_WVALID;
  wire [39:0]xbar_to_m00_couplers_ARADDR;
  wire [2:0]xbar_to_m00_couplers_ARPROT;
  wire [0:0]xbar_to_m00_couplers_ARREADY;
  wire [0:0]xbar_to_m00_couplers_ARVALID;
  wire [39:0]xbar_to_m00_couplers_AWADDR;
  wire [2:0]xbar_to_m00_couplers_AWPROT;
  wire [0:0]xbar_to_m00_couplers_AWREADY;
  wire [0:0]xbar_to_m00_couplers_AWVALID;
  wire [0:0]xbar_to_m00_couplers_BREADY;
  wire [1:0]xbar_to_m00_couplers_BRESP;
  wire [0:0]xbar_to_m00_couplers_BVALID;
  wire [31:0]xbar_to_m00_couplers_RDATA;
  wire [0:0]xbar_to_m00_couplers_RREADY;
  wire [1:0]xbar_to_m00_couplers_RRESP;
  wire [0:0]xbar_to_m00_couplers_RVALID;
  wire [31:0]xbar_to_m00_couplers_WDATA;
  wire [0:0]xbar_to_m00_couplers_WREADY;
  wire [3:0]xbar_to_m00_couplers_WSTRB;
  wire [0:0]xbar_to_m00_couplers_WVALID;
  wire [79:40]xbar_to_m01_couplers_ARADDR;
  wire [5:3]xbar_to_m01_couplers_ARPROT;
  wire xbar_to_m01_couplers_ARREADY;
  wire [1:1]xbar_to_m01_couplers_ARVALID;
  wire [79:40]xbar_to_m01_couplers_AWADDR;
  wire [5:3]xbar_to_m01_couplers_AWPROT;
  wire xbar_to_m01_couplers_AWREADY;
  wire [1:1]xbar_to_m01_couplers_AWVALID;
  wire [1:1]xbar_to_m01_couplers_BREADY;
  wire [1:0]xbar_to_m01_couplers_BRESP;
  wire xbar_to_m01_couplers_BVALID;
  wire [31:0]xbar_to_m01_couplers_RDATA;
  wire [1:1]xbar_to_m01_couplers_RREADY;
  wire [1:0]xbar_to_m01_couplers_RRESP;
  wire xbar_to_m01_couplers_RVALID;
  wire [63:32]xbar_to_m01_couplers_WDATA;
  wire xbar_to_m01_couplers_WREADY;
  wire [7:4]xbar_to_m01_couplers_WSTRB;
  wire [1:1]xbar_to_m01_couplers_WVALID;
  wire [119:80]xbar_to_m02_couplers_ARADDR;
  wire [8:6]xbar_to_m02_couplers_ARPROT;
  wire [0:0]xbar_to_m02_couplers_ARREADY;
  wire [2:2]xbar_to_m02_couplers_ARVALID;
  wire [119:80]xbar_to_m02_couplers_AWADDR;
  wire [8:6]xbar_to_m02_couplers_AWPROT;
  wire [0:0]xbar_to_m02_couplers_AWREADY;
  wire [2:2]xbar_to_m02_couplers_AWVALID;
  wire [2:2]xbar_to_m02_couplers_BREADY;
  wire [1:0]xbar_to_m02_couplers_BRESP;
  wire [0:0]xbar_to_m02_couplers_BVALID;
  wire [31:0]xbar_to_m02_couplers_RDATA;
  wire [2:2]xbar_to_m02_couplers_RREADY;
  wire [1:0]xbar_to_m02_couplers_RRESP;
  wire [0:0]xbar_to_m02_couplers_RVALID;
  wire [95:64]xbar_to_m02_couplers_WDATA;
  wire [0:0]xbar_to_m02_couplers_WREADY;
  wire [11:8]xbar_to_m02_couplers_WSTRB;
  wire [2:2]xbar_to_m02_couplers_WVALID;
  wire [159:120]xbar_to_m03_couplers_ARADDR;
  wire xbar_to_m03_couplers_ARREADY;
  wire [3:3]xbar_to_m03_couplers_ARVALID;
  wire [159:120]xbar_to_m03_couplers_AWADDR;
  wire xbar_to_m03_couplers_AWREADY;
  wire [3:3]xbar_to_m03_couplers_AWVALID;
  wire [3:3]xbar_to_m03_couplers_BREADY;
  wire [1:0]xbar_to_m03_couplers_BRESP;
  wire xbar_to_m03_couplers_BVALID;
  wire [31:0]xbar_to_m03_couplers_RDATA;
  wire [3:3]xbar_to_m03_couplers_RREADY;
  wire [1:0]xbar_to_m03_couplers_RRESP;
  wire xbar_to_m03_couplers_RVALID;
  wire [127:96]xbar_to_m03_couplers_WDATA;
  wire xbar_to_m03_couplers_WREADY;
  wire [15:12]xbar_to_m03_couplers_WSTRB;
  wire [3:3]xbar_to_m03_couplers_WVALID;

  assign M00_ACLK_1 = M00_ACLK;
  assign M00_ARESETN_1 = M00_ARESETN;
  assign M00_AXI_araddr[39:0] = m00_couplers_to_vcu_axi_lite_0_ARADDR;
  assign M00_AXI_arprot[2:0] = m00_couplers_to_vcu_axi_lite_0_ARPROT;
  assign M00_AXI_arvalid[0] = m00_couplers_to_vcu_axi_lite_0_ARVALID;
  assign M00_AXI_awaddr[39:0] = m00_couplers_to_vcu_axi_lite_0_AWADDR;
  assign M00_AXI_awprot[2:0] = m00_couplers_to_vcu_axi_lite_0_AWPROT;
  assign M00_AXI_awvalid[0] = m00_couplers_to_vcu_axi_lite_0_AWVALID;
  assign M00_AXI_bready[0] = m00_couplers_to_vcu_axi_lite_0_BREADY;
  assign M00_AXI_rready[0] = m00_couplers_to_vcu_axi_lite_0_RREADY;
  assign M00_AXI_wdata[31:0] = m00_couplers_to_vcu_axi_lite_0_WDATA;
  assign M00_AXI_wstrb[3:0] = m00_couplers_to_vcu_axi_lite_0_WSTRB;
  assign M00_AXI_wvalid[0] = m00_couplers_to_vcu_axi_lite_0_WVALID;
  assign M01_ACLK_1 = M01_ACLK;
  assign M01_ARESETN_1 = M01_ARESETN;
  assign M01_AXI_araddr[39:0] = m01_couplers_to_vcu_axi_lite_0_ARADDR;
  assign M01_AXI_arprot[2:0] = m01_couplers_to_vcu_axi_lite_0_ARPROT;
  assign M01_AXI_arvalid = m01_couplers_to_vcu_axi_lite_0_ARVALID;
  assign M01_AXI_awaddr[39:0] = m01_couplers_to_vcu_axi_lite_0_AWADDR;
  assign M01_AXI_awprot[2:0] = m01_couplers_to_vcu_axi_lite_0_AWPROT;
  assign M01_AXI_awvalid = m01_couplers_to_vcu_axi_lite_0_AWVALID;
  assign M01_AXI_bready = m01_couplers_to_vcu_axi_lite_0_BREADY;
  assign M01_AXI_rready = m01_couplers_to_vcu_axi_lite_0_RREADY;
  assign M01_AXI_wdata[31:0] = m01_couplers_to_vcu_axi_lite_0_WDATA;
  assign M01_AXI_wstrb[3:0] = m01_couplers_to_vcu_axi_lite_0_WSTRB;
  assign M01_AXI_wvalid = m01_couplers_to_vcu_axi_lite_0_WVALID;
  assign M02_ACLK_1 = M02_ACLK;
  assign M02_ARESETN_1 = M02_ARESETN;
  assign M02_AXI_araddr[39:0] = m02_couplers_to_vcu_axi_lite_0_ARADDR;
  assign M02_AXI_arprot[2:0] = m02_couplers_to_vcu_axi_lite_0_ARPROT;
  assign M02_AXI_arvalid[0] = m02_couplers_to_vcu_axi_lite_0_ARVALID;
  assign M02_AXI_awaddr[39:0] = m02_couplers_to_vcu_axi_lite_0_AWADDR;
  assign M02_AXI_awprot[2:0] = m02_couplers_to_vcu_axi_lite_0_AWPROT;
  assign M02_AXI_awvalid[0] = m02_couplers_to_vcu_axi_lite_0_AWVALID;
  assign M02_AXI_bready[0] = m02_couplers_to_vcu_axi_lite_0_BREADY;
  assign M02_AXI_rready[0] = m02_couplers_to_vcu_axi_lite_0_RREADY;
  assign M02_AXI_wdata[31:0] = m02_couplers_to_vcu_axi_lite_0_WDATA;
  assign M02_AXI_wstrb[3:0] = m02_couplers_to_vcu_axi_lite_0_WSTRB;
  assign M02_AXI_wvalid[0] = m02_couplers_to_vcu_axi_lite_0_WVALID;
  assign M03_ACLK_1 = M03_ACLK;
  assign M03_ARESETN_1 = M03_ARESETN;
  assign M03_AXI_araddr[39:0] = m03_couplers_to_vcu_axi_lite_0_ARADDR;
  assign M03_AXI_arvalid = m03_couplers_to_vcu_axi_lite_0_ARVALID;
  assign M03_AXI_awaddr[39:0] = m03_couplers_to_vcu_axi_lite_0_AWADDR;
  assign M03_AXI_awvalid = m03_couplers_to_vcu_axi_lite_0_AWVALID;
  assign M03_AXI_bready = m03_couplers_to_vcu_axi_lite_0_BREADY;
  assign M03_AXI_rready = m03_couplers_to_vcu_axi_lite_0_RREADY;
  assign M03_AXI_wdata[31:0] = m03_couplers_to_vcu_axi_lite_0_WDATA;
  assign M03_AXI_wstrb[3:0] = m03_couplers_to_vcu_axi_lite_0_WSTRB;
  assign M03_AXI_wvalid = m03_couplers_to_vcu_axi_lite_0_WVALID;
  assign S00_ACLK_1 = S00_ACLK;
  assign S00_ARESETN_1 = S00_ARESETN;
  assign S00_AXI_arready = vcu_axi_lite_0_to_s00_couplers_ARREADY;
  assign S00_AXI_awready = vcu_axi_lite_0_to_s00_couplers_AWREADY;
  assign S00_AXI_bid[15:0] = vcu_axi_lite_0_to_s00_couplers_BID;
  assign S00_AXI_bresp[1:0] = vcu_axi_lite_0_to_s00_couplers_BRESP;
  assign S00_AXI_bvalid = vcu_axi_lite_0_to_s00_couplers_BVALID;
  assign S00_AXI_rdata[31:0] = vcu_axi_lite_0_to_s00_couplers_RDATA;
  assign S00_AXI_rid[15:0] = vcu_axi_lite_0_to_s00_couplers_RID;
  assign S00_AXI_rlast = vcu_axi_lite_0_to_s00_couplers_RLAST;
  assign S00_AXI_rresp[1:0] = vcu_axi_lite_0_to_s00_couplers_RRESP;
  assign S00_AXI_rvalid = vcu_axi_lite_0_to_s00_couplers_RVALID;
  assign S00_AXI_wready = vcu_axi_lite_0_to_s00_couplers_WREADY;
  assign m00_couplers_to_vcu_axi_lite_0_ARREADY = M00_AXI_arready[0];
  assign m00_couplers_to_vcu_axi_lite_0_AWREADY = M00_AXI_awready[0];
  assign m00_couplers_to_vcu_axi_lite_0_BRESP = M00_AXI_bresp[1:0];
  assign m00_couplers_to_vcu_axi_lite_0_BVALID = M00_AXI_bvalid[0];
  assign m00_couplers_to_vcu_axi_lite_0_RDATA = M00_AXI_rdata[31:0];
  assign m00_couplers_to_vcu_axi_lite_0_RRESP = M00_AXI_rresp[1:0];
  assign m00_couplers_to_vcu_axi_lite_0_RVALID = M00_AXI_rvalid[0];
  assign m00_couplers_to_vcu_axi_lite_0_WREADY = M00_AXI_wready[0];
  assign m01_couplers_to_vcu_axi_lite_0_ARREADY = M01_AXI_arready;
  assign m01_couplers_to_vcu_axi_lite_0_AWREADY = M01_AXI_awready;
  assign m01_couplers_to_vcu_axi_lite_0_BRESP = M01_AXI_bresp[1:0];
  assign m01_couplers_to_vcu_axi_lite_0_BVALID = M01_AXI_bvalid;
  assign m01_couplers_to_vcu_axi_lite_0_RDATA = M01_AXI_rdata[31:0];
  assign m01_couplers_to_vcu_axi_lite_0_RRESP = M01_AXI_rresp[1:0];
  assign m01_couplers_to_vcu_axi_lite_0_RVALID = M01_AXI_rvalid;
  assign m01_couplers_to_vcu_axi_lite_0_WREADY = M01_AXI_wready;
  assign m02_couplers_to_vcu_axi_lite_0_ARREADY = M02_AXI_arready[0];
  assign m02_couplers_to_vcu_axi_lite_0_AWREADY = M02_AXI_awready[0];
  assign m02_couplers_to_vcu_axi_lite_0_BRESP = M02_AXI_bresp[1:0];
  assign m02_couplers_to_vcu_axi_lite_0_BVALID = M02_AXI_bvalid[0];
  assign m02_couplers_to_vcu_axi_lite_0_RDATA = M02_AXI_rdata[31:0];
  assign m02_couplers_to_vcu_axi_lite_0_RRESP = M02_AXI_rresp[1:0];
  assign m02_couplers_to_vcu_axi_lite_0_RVALID = M02_AXI_rvalid[0];
  assign m02_couplers_to_vcu_axi_lite_0_WREADY = M02_AXI_wready[0];
  assign m03_couplers_to_vcu_axi_lite_0_ARREADY = M03_AXI_arready;
  assign m03_couplers_to_vcu_axi_lite_0_AWREADY = M03_AXI_awready;
  assign m03_couplers_to_vcu_axi_lite_0_BRESP = M03_AXI_bresp[1:0];
  assign m03_couplers_to_vcu_axi_lite_0_BVALID = M03_AXI_bvalid;
  assign m03_couplers_to_vcu_axi_lite_0_RDATA = M03_AXI_rdata[31:0];
  assign m03_couplers_to_vcu_axi_lite_0_RRESP = M03_AXI_rresp[1:0];
  assign m03_couplers_to_vcu_axi_lite_0_RVALID = M03_AXI_rvalid;
  assign m03_couplers_to_vcu_axi_lite_0_WREADY = M03_AXI_wready;
  assign vcu_axi_lite_0_ACLK_net = ACLK;
  assign vcu_axi_lite_0_ARESETN_net = ARESETN;
  assign vcu_axi_lite_0_to_s00_couplers_ARADDR = S00_AXI_araddr[39:0];
  assign vcu_axi_lite_0_to_s00_couplers_ARBURST = S00_AXI_arburst[1:0];
  assign vcu_axi_lite_0_to_s00_couplers_ARCACHE = S00_AXI_arcache[3:0];
  assign vcu_axi_lite_0_to_s00_couplers_ARID = S00_AXI_arid[15:0];
  assign vcu_axi_lite_0_to_s00_couplers_ARLEN = S00_AXI_arlen[7:0];
  assign vcu_axi_lite_0_to_s00_couplers_ARLOCK = S00_AXI_arlock;
  assign vcu_axi_lite_0_to_s00_couplers_ARPROT = S00_AXI_arprot[2:0];
  assign vcu_axi_lite_0_to_s00_couplers_ARQOS = S00_AXI_arqos[3:0];
  assign vcu_axi_lite_0_to_s00_couplers_ARSIZE = S00_AXI_arsize[2:0];
  assign vcu_axi_lite_0_to_s00_couplers_ARVALID = S00_AXI_arvalid;
  assign vcu_axi_lite_0_to_s00_couplers_AWADDR = S00_AXI_awaddr[39:0];
  assign vcu_axi_lite_0_to_s00_couplers_AWBURST = S00_AXI_awburst[1:0];
  assign vcu_axi_lite_0_to_s00_couplers_AWCACHE = S00_AXI_awcache[3:0];
  assign vcu_axi_lite_0_to_s00_couplers_AWID = S00_AXI_awid[15:0];
  assign vcu_axi_lite_0_to_s00_couplers_AWLEN = S00_AXI_awlen[7:0];
  assign vcu_axi_lite_0_to_s00_couplers_AWLOCK = S00_AXI_awlock;
  assign vcu_axi_lite_0_to_s00_couplers_AWPROT = S00_AXI_awprot[2:0];
  assign vcu_axi_lite_0_to_s00_couplers_AWQOS = S00_AXI_awqos[3:0];
  assign vcu_axi_lite_0_to_s00_couplers_AWSIZE = S00_AXI_awsize[2:0];
  assign vcu_axi_lite_0_to_s00_couplers_AWVALID = S00_AXI_awvalid;
  assign vcu_axi_lite_0_to_s00_couplers_BREADY = S00_AXI_bready;
  assign vcu_axi_lite_0_to_s00_couplers_RREADY = S00_AXI_rready;
  assign vcu_axi_lite_0_to_s00_couplers_WDATA = S00_AXI_wdata[31:0];
  assign vcu_axi_lite_0_to_s00_couplers_WLAST = S00_AXI_wlast;
  assign vcu_axi_lite_0_to_s00_couplers_WSTRB = S00_AXI_wstrb[3:0];
  assign vcu_axi_lite_0_to_s00_couplers_WVALID = S00_AXI_wvalid;
  m00_couplers_imp_129FAK3 m00_couplers
       (.M_ACLK(M00_ACLK_1),
        .M_ARESETN(M00_ARESETN_1),
        .M_AXI_araddr(m00_couplers_to_vcu_axi_lite_0_ARADDR),
        .M_AXI_arprot(m00_couplers_to_vcu_axi_lite_0_ARPROT),
        .M_AXI_arready(m00_couplers_to_vcu_axi_lite_0_ARREADY),
        .M_AXI_arvalid(m00_couplers_to_vcu_axi_lite_0_ARVALID),
        .M_AXI_awaddr(m00_couplers_to_vcu_axi_lite_0_AWADDR),
        .M_AXI_awprot(m00_couplers_to_vcu_axi_lite_0_AWPROT),
        .M_AXI_awready(m00_couplers_to_vcu_axi_lite_0_AWREADY),
        .M_AXI_awvalid(m00_couplers_to_vcu_axi_lite_0_AWVALID),
        .M_AXI_bready(m00_couplers_to_vcu_axi_lite_0_BREADY),
        .M_AXI_bresp(m00_couplers_to_vcu_axi_lite_0_BRESP),
        .M_AXI_bvalid(m00_couplers_to_vcu_axi_lite_0_BVALID),
        .M_AXI_rdata(m00_couplers_to_vcu_axi_lite_0_RDATA),
        .M_AXI_rready(m00_couplers_to_vcu_axi_lite_0_RREADY),
        .M_AXI_rresp(m00_couplers_to_vcu_axi_lite_0_RRESP),
        .M_AXI_rvalid(m00_couplers_to_vcu_axi_lite_0_RVALID),
        .M_AXI_wdata(m00_couplers_to_vcu_axi_lite_0_WDATA),
        .M_AXI_wready(m00_couplers_to_vcu_axi_lite_0_WREADY),
        .M_AXI_wstrb(m00_couplers_to_vcu_axi_lite_0_WSTRB),
        .M_AXI_wvalid(m00_couplers_to_vcu_axi_lite_0_WVALID),
        .S_ACLK(vcu_axi_lite_0_ACLK_net),
        .S_ARESETN(vcu_axi_lite_0_ARESETN_net),
        .S_AXI_araddr(xbar_to_m00_couplers_ARADDR),
        .S_AXI_arprot(xbar_to_m00_couplers_ARPROT),
        .S_AXI_arready(xbar_to_m00_couplers_ARREADY),
        .S_AXI_arvalid(xbar_to_m00_couplers_ARVALID),
        .S_AXI_awaddr(xbar_to_m00_couplers_AWADDR),
        .S_AXI_awprot(xbar_to_m00_couplers_AWPROT),
        .S_AXI_awready(xbar_to_m00_couplers_AWREADY),
        .S_AXI_awvalid(xbar_to_m00_couplers_AWVALID),
        .S_AXI_bready(xbar_to_m00_couplers_BREADY),
        .S_AXI_bresp(xbar_to_m00_couplers_BRESP),
        .S_AXI_bvalid(xbar_to_m00_couplers_BVALID),
        .S_AXI_rdata(xbar_to_m00_couplers_RDATA),
        .S_AXI_rready(xbar_to_m00_couplers_RREADY),
        .S_AXI_rresp(xbar_to_m00_couplers_RRESP),
        .S_AXI_rvalid(xbar_to_m00_couplers_RVALID),
        .S_AXI_wdata(xbar_to_m00_couplers_WDATA),
        .S_AXI_wready(xbar_to_m00_couplers_WREADY),
        .S_AXI_wstrb(xbar_to_m00_couplers_WSTRB),
        .S_AXI_wvalid(xbar_to_m00_couplers_WVALID));
  m01_couplers_imp_3YGOS0 m01_couplers
       (.M_ACLK(M01_ACLK_1),
        .M_ARESETN(M01_ARESETN_1),
        .M_AXI_araddr(m01_couplers_to_vcu_axi_lite_0_ARADDR),
        .M_AXI_arprot(m01_couplers_to_vcu_axi_lite_0_ARPROT),
        .M_AXI_arready(m01_couplers_to_vcu_axi_lite_0_ARREADY),
        .M_AXI_arvalid(m01_couplers_to_vcu_axi_lite_0_ARVALID),
        .M_AXI_awaddr(m01_couplers_to_vcu_axi_lite_0_AWADDR),
        .M_AXI_awprot(m01_couplers_to_vcu_axi_lite_0_AWPROT),
        .M_AXI_awready(m01_couplers_to_vcu_axi_lite_0_AWREADY),
        .M_AXI_awvalid(m01_couplers_to_vcu_axi_lite_0_AWVALID),
        .M_AXI_bready(m01_couplers_to_vcu_axi_lite_0_BREADY),
        .M_AXI_bresp(m01_couplers_to_vcu_axi_lite_0_BRESP),
        .M_AXI_bvalid(m01_couplers_to_vcu_axi_lite_0_BVALID),
        .M_AXI_rdata(m01_couplers_to_vcu_axi_lite_0_RDATA),
        .M_AXI_rready(m01_couplers_to_vcu_axi_lite_0_RREADY),
        .M_AXI_rresp(m01_couplers_to_vcu_axi_lite_0_RRESP),
        .M_AXI_rvalid(m01_couplers_to_vcu_axi_lite_0_RVALID),
        .M_AXI_wdata(m01_couplers_to_vcu_axi_lite_0_WDATA),
        .M_AXI_wready(m01_couplers_to_vcu_axi_lite_0_WREADY),
        .M_AXI_wstrb(m01_couplers_to_vcu_axi_lite_0_WSTRB),
        .M_AXI_wvalid(m01_couplers_to_vcu_axi_lite_0_WVALID),
        .S_ACLK(vcu_axi_lite_0_ACLK_net),
        .S_ARESETN(vcu_axi_lite_0_ARESETN_net),
        .S_AXI_araddr(xbar_to_m01_couplers_ARADDR),
        .S_AXI_arprot(xbar_to_m01_couplers_ARPROT),
        .S_AXI_arready(xbar_to_m01_couplers_ARREADY),
        .S_AXI_arvalid(xbar_to_m01_couplers_ARVALID),
        .S_AXI_awaddr(xbar_to_m01_couplers_AWADDR),
        .S_AXI_awprot(xbar_to_m01_couplers_AWPROT),
        .S_AXI_awready(xbar_to_m01_couplers_AWREADY),
        .S_AXI_awvalid(xbar_to_m01_couplers_AWVALID),
        .S_AXI_bready(xbar_to_m01_couplers_BREADY),
        .S_AXI_bresp(xbar_to_m01_couplers_BRESP),
        .S_AXI_bvalid(xbar_to_m01_couplers_BVALID),
        .S_AXI_rdata(xbar_to_m01_couplers_RDATA),
        .S_AXI_rready(xbar_to_m01_couplers_RREADY),
        .S_AXI_rresp(xbar_to_m01_couplers_RRESP),
        .S_AXI_rvalid(xbar_to_m01_couplers_RVALID),
        .S_AXI_wdata(xbar_to_m01_couplers_WDATA),
        .S_AXI_wready(xbar_to_m01_couplers_WREADY),
        .S_AXI_wstrb(xbar_to_m01_couplers_WSTRB),
        .S_AXI_wvalid(xbar_to_m01_couplers_WVALID));
  m02_couplers_imp_Q1FOXG m02_couplers
       (.M_ACLK(M02_ACLK_1),
        .M_ARESETN(M02_ARESETN_1),
        .M_AXI_araddr(m02_couplers_to_vcu_axi_lite_0_ARADDR),
        .M_AXI_arprot(m02_couplers_to_vcu_axi_lite_0_ARPROT),
        .M_AXI_arready(m02_couplers_to_vcu_axi_lite_0_ARREADY),
        .M_AXI_arvalid(m02_couplers_to_vcu_axi_lite_0_ARVALID),
        .M_AXI_awaddr(m02_couplers_to_vcu_axi_lite_0_AWADDR),
        .M_AXI_awprot(m02_couplers_to_vcu_axi_lite_0_AWPROT),
        .M_AXI_awready(m02_couplers_to_vcu_axi_lite_0_AWREADY),
        .M_AXI_awvalid(m02_couplers_to_vcu_axi_lite_0_AWVALID),
        .M_AXI_bready(m02_couplers_to_vcu_axi_lite_0_BREADY),
        .M_AXI_bresp(m02_couplers_to_vcu_axi_lite_0_BRESP),
        .M_AXI_bvalid(m02_couplers_to_vcu_axi_lite_0_BVALID),
        .M_AXI_rdata(m02_couplers_to_vcu_axi_lite_0_RDATA),
        .M_AXI_rready(m02_couplers_to_vcu_axi_lite_0_RREADY),
        .M_AXI_rresp(m02_couplers_to_vcu_axi_lite_0_RRESP),
        .M_AXI_rvalid(m02_couplers_to_vcu_axi_lite_0_RVALID),
        .M_AXI_wdata(m02_couplers_to_vcu_axi_lite_0_WDATA),
        .M_AXI_wready(m02_couplers_to_vcu_axi_lite_0_WREADY),
        .M_AXI_wstrb(m02_couplers_to_vcu_axi_lite_0_WSTRB),
        .M_AXI_wvalid(m02_couplers_to_vcu_axi_lite_0_WVALID),
        .S_ACLK(vcu_axi_lite_0_ACLK_net),
        .S_ARESETN(vcu_axi_lite_0_ARESETN_net),
        .S_AXI_araddr(xbar_to_m02_couplers_ARADDR),
        .S_AXI_arprot(xbar_to_m02_couplers_ARPROT),
        .S_AXI_arready(xbar_to_m02_couplers_ARREADY),
        .S_AXI_arvalid(xbar_to_m02_couplers_ARVALID),
        .S_AXI_awaddr(xbar_to_m02_couplers_AWADDR),
        .S_AXI_awprot(xbar_to_m02_couplers_AWPROT),
        .S_AXI_awready(xbar_to_m02_couplers_AWREADY),
        .S_AXI_awvalid(xbar_to_m02_couplers_AWVALID),
        .S_AXI_bready(xbar_to_m02_couplers_BREADY),
        .S_AXI_bresp(xbar_to_m02_couplers_BRESP),
        .S_AXI_bvalid(xbar_to_m02_couplers_BVALID),
        .S_AXI_rdata(xbar_to_m02_couplers_RDATA),
        .S_AXI_rready(xbar_to_m02_couplers_RREADY),
        .S_AXI_rresp(xbar_to_m02_couplers_RRESP),
        .S_AXI_rvalid(xbar_to_m02_couplers_RVALID),
        .S_AXI_wdata(xbar_to_m02_couplers_WDATA),
        .S_AXI_wready(xbar_to_m02_couplers_WREADY),
        .S_AXI_wstrb(xbar_to_m02_couplers_WSTRB),
        .S_AXI_wvalid(xbar_to_m02_couplers_WVALID));
  m03_couplers_imp_1OMIXFB m03_couplers
       (.M_ACLK(M03_ACLK_1),
        .M_ARESETN(M03_ARESETN_1),
        .M_AXI_araddr(m03_couplers_to_vcu_axi_lite_0_ARADDR),
        .M_AXI_arready(m03_couplers_to_vcu_axi_lite_0_ARREADY),
        .M_AXI_arvalid(m03_couplers_to_vcu_axi_lite_0_ARVALID),
        .M_AXI_awaddr(m03_couplers_to_vcu_axi_lite_0_AWADDR),
        .M_AXI_awready(m03_couplers_to_vcu_axi_lite_0_AWREADY),
        .M_AXI_awvalid(m03_couplers_to_vcu_axi_lite_0_AWVALID),
        .M_AXI_bready(m03_couplers_to_vcu_axi_lite_0_BREADY),
        .M_AXI_bresp(m03_couplers_to_vcu_axi_lite_0_BRESP),
        .M_AXI_bvalid(m03_couplers_to_vcu_axi_lite_0_BVALID),
        .M_AXI_rdata(m03_couplers_to_vcu_axi_lite_0_RDATA),
        .M_AXI_rready(m03_couplers_to_vcu_axi_lite_0_RREADY),
        .M_AXI_rresp(m03_couplers_to_vcu_axi_lite_0_RRESP),
        .M_AXI_rvalid(m03_couplers_to_vcu_axi_lite_0_RVALID),
        .M_AXI_wdata(m03_couplers_to_vcu_axi_lite_0_WDATA),
        .M_AXI_wready(m03_couplers_to_vcu_axi_lite_0_WREADY),
        .M_AXI_wstrb(m03_couplers_to_vcu_axi_lite_0_WSTRB),
        .M_AXI_wvalid(m03_couplers_to_vcu_axi_lite_0_WVALID),
        .S_ACLK(vcu_axi_lite_0_ACLK_net),
        .S_ARESETN(vcu_axi_lite_0_ARESETN_net),
        .S_AXI_araddr(xbar_to_m03_couplers_ARADDR),
        .S_AXI_arready(xbar_to_m03_couplers_ARREADY),
        .S_AXI_arvalid(xbar_to_m03_couplers_ARVALID),
        .S_AXI_awaddr(xbar_to_m03_couplers_AWADDR),
        .S_AXI_awready(xbar_to_m03_couplers_AWREADY),
        .S_AXI_awvalid(xbar_to_m03_couplers_AWVALID),
        .S_AXI_bready(xbar_to_m03_couplers_BREADY),
        .S_AXI_bresp(xbar_to_m03_couplers_BRESP),
        .S_AXI_bvalid(xbar_to_m03_couplers_BVALID),
        .S_AXI_rdata(xbar_to_m03_couplers_RDATA),
        .S_AXI_rready(xbar_to_m03_couplers_RREADY),
        .S_AXI_rresp(xbar_to_m03_couplers_RRESP),
        .S_AXI_rvalid(xbar_to_m03_couplers_RVALID),
        .S_AXI_wdata(xbar_to_m03_couplers_WDATA),
        .S_AXI_wready(xbar_to_m03_couplers_WREADY),
        .S_AXI_wstrb(xbar_to_m03_couplers_WSTRB),
        .S_AXI_wvalid(xbar_to_m03_couplers_WVALID));
  s00_couplers_imp_44DMZZ s00_couplers
       (.M_ACLK(vcu_axi_lite_0_ACLK_net),
        .M_ARESETN(vcu_axi_lite_0_ARESETN_net),
        .M_AXI_araddr(s00_couplers_to_xbar_ARADDR),
        .M_AXI_arprot(s00_couplers_to_xbar_ARPROT),
        .M_AXI_arready(s00_couplers_to_xbar_ARREADY),
        .M_AXI_arvalid(s00_couplers_to_xbar_ARVALID),
        .M_AXI_awaddr(s00_couplers_to_xbar_AWADDR),
        .M_AXI_awprot(s00_couplers_to_xbar_AWPROT),
        .M_AXI_awready(s00_couplers_to_xbar_AWREADY),
        .M_AXI_awvalid(s00_couplers_to_xbar_AWVALID),
        .M_AXI_bready(s00_couplers_to_xbar_BREADY),
        .M_AXI_bresp(s00_couplers_to_xbar_BRESP),
        .M_AXI_bvalid(s00_couplers_to_xbar_BVALID),
        .M_AXI_rdata(s00_couplers_to_xbar_RDATA),
        .M_AXI_rready(s00_couplers_to_xbar_RREADY),
        .M_AXI_rresp(s00_couplers_to_xbar_RRESP),
        .M_AXI_rvalid(s00_couplers_to_xbar_RVALID),
        .M_AXI_wdata(s00_couplers_to_xbar_WDATA),
        .M_AXI_wready(s00_couplers_to_xbar_WREADY),
        .M_AXI_wstrb(s00_couplers_to_xbar_WSTRB),
        .M_AXI_wvalid(s00_couplers_to_xbar_WVALID),
        .S_ACLK(S00_ACLK_1),
        .S_ARESETN(S00_ARESETN_1),
        .S_AXI_araddr(vcu_axi_lite_0_to_s00_couplers_ARADDR),
        .S_AXI_arburst(vcu_axi_lite_0_to_s00_couplers_ARBURST),
        .S_AXI_arcache(vcu_axi_lite_0_to_s00_couplers_ARCACHE),
        .S_AXI_arid(vcu_axi_lite_0_to_s00_couplers_ARID),
        .S_AXI_arlen(vcu_axi_lite_0_to_s00_couplers_ARLEN),
        .S_AXI_arlock(vcu_axi_lite_0_to_s00_couplers_ARLOCK),
        .S_AXI_arprot(vcu_axi_lite_0_to_s00_couplers_ARPROT),
        .S_AXI_arqos(vcu_axi_lite_0_to_s00_couplers_ARQOS),
        .S_AXI_arready(vcu_axi_lite_0_to_s00_couplers_ARREADY),
        .S_AXI_arsize(vcu_axi_lite_0_to_s00_couplers_ARSIZE),
        .S_AXI_arvalid(vcu_axi_lite_0_to_s00_couplers_ARVALID),
        .S_AXI_awaddr(vcu_axi_lite_0_to_s00_couplers_AWADDR),
        .S_AXI_awburst(vcu_axi_lite_0_to_s00_couplers_AWBURST),
        .S_AXI_awcache(vcu_axi_lite_0_to_s00_couplers_AWCACHE),
        .S_AXI_awid(vcu_axi_lite_0_to_s00_couplers_AWID),
        .S_AXI_awlen(vcu_axi_lite_0_to_s00_couplers_AWLEN),
        .S_AXI_awlock(vcu_axi_lite_0_to_s00_couplers_AWLOCK),
        .S_AXI_awprot(vcu_axi_lite_0_to_s00_couplers_AWPROT),
        .S_AXI_awqos(vcu_axi_lite_0_to_s00_couplers_AWQOS),
        .S_AXI_awready(vcu_axi_lite_0_to_s00_couplers_AWREADY),
        .S_AXI_awsize(vcu_axi_lite_0_to_s00_couplers_AWSIZE),
        .S_AXI_awvalid(vcu_axi_lite_0_to_s00_couplers_AWVALID),
        .S_AXI_bid(vcu_axi_lite_0_to_s00_couplers_BID),
        .S_AXI_bready(vcu_axi_lite_0_to_s00_couplers_BREADY),
        .S_AXI_bresp(vcu_axi_lite_0_to_s00_couplers_BRESP),
        .S_AXI_bvalid(vcu_axi_lite_0_to_s00_couplers_BVALID),
        .S_AXI_rdata(vcu_axi_lite_0_to_s00_couplers_RDATA),
        .S_AXI_rid(vcu_axi_lite_0_to_s00_couplers_RID),
        .S_AXI_rlast(vcu_axi_lite_0_to_s00_couplers_RLAST),
        .S_AXI_rready(vcu_axi_lite_0_to_s00_couplers_RREADY),
        .S_AXI_rresp(vcu_axi_lite_0_to_s00_couplers_RRESP),
        .S_AXI_rvalid(vcu_axi_lite_0_to_s00_couplers_RVALID),
        .S_AXI_wdata(vcu_axi_lite_0_to_s00_couplers_WDATA),
        .S_AXI_wlast(vcu_axi_lite_0_to_s00_couplers_WLAST),
        .S_AXI_wready(vcu_axi_lite_0_to_s00_couplers_WREADY),
        .S_AXI_wstrb(vcu_axi_lite_0_to_s00_couplers_WSTRB),
        .S_AXI_wvalid(vcu_axi_lite_0_to_s00_couplers_WVALID));
  vcu_trd_xbar_1 xbar
       (.aclk(vcu_axi_lite_0_ACLK_net),
        .aresetn(vcu_axi_lite_0_ARESETN_net),
        .m_axi_araddr({xbar_to_m03_couplers_ARADDR,xbar_to_m02_couplers_ARADDR,xbar_to_m01_couplers_ARADDR,xbar_to_m00_couplers_ARADDR}),
        .m_axi_arprot({xbar_to_m02_couplers_ARPROT,xbar_to_m01_couplers_ARPROT,xbar_to_m00_couplers_ARPROT}),
        .m_axi_arready({xbar_to_m03_couplers_ARREADY,xbar_to_m02_couplers_ARREADY,xbar_to_m01_couplers_ARREADY,xbar_to_m00_couplers_ARREADY}),
        .m_axi_arvalid({xbar_to_m03_couplers_ARVALID,xbar_to_m02_couplers_ARVALID,xbar_to_m01_couplers_ARVALID,xbar_to_m00_couplers_ARVALID}),
        .m_axi_awaddr({xbar_to_m03_couplers_AWADDR,xbar_to_m02_couplers_AWADDR,xbar_to_m01_couplers_AWADDR,xbar_to_m00_couplers_AWADDR}),
        .m_axi_awprot({xbar_to_m02_couplers_AWPROT,xbar_to_m01_couplers_AWPROT,xbar_to_m00_couplers_AWPROT}),
        .m_axi_awready({xbar_to_m03_couplers_AWREADY,xbar_to_m02_couplers_AWREADY,xbar_to_m01_couplers_AWREADY,xbar_to_m00_couplers_AWREADY}),
        .m_axi_awvalid({xbar_to_m03_couplers_AWVALID,xbar_to_m02_couplers_AWVALID,xbar_to_m01_couplers_AWVALID,xbar_to_m00_couplers_AWVALID}),
        .m_axi_bready({xbar_to_m03_couplers_BREADY,xbar_to_m02_couplers_BREADY,xbar_to_m01_couplers_BREADY,xbar_to_m00_couplers_BREADY}),
        .m_axi_bresp({xbar_to_m03_couplers_BRESP,xbar_to_m02_couplers_BRESP,xbar_to_m01_couplers_BRESP,xbar_to_m00_couplers_BRESP}),
        .m_axi_bvalid({xbar_to_m03_couplers_BVALID,xbar_to_m02_couplers_BVALID,xbar_to_m01_couplers_BVALID,xbar_to_m00_couplers_BVALID}),
        .m_axi_rdata({xbar_to_m03_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m00_couplers_RDATA}),
        .m_axi_rready({xbar_to_m03_couplers_RREADY,xbar_to_m02_couplers_RREADY,xbar_to_m01_couplers_RREADY,xbar_to_m00_couplers_RREADY}),
        .m_axi_rresp({xbar_to_m03_couplers_RRESP,xbar_to_m02_couplers_RRESP,xbar_to_m01_couplers_RRESP,xbar_to_m00_couplers_RRESP}),
        .m_axi_rvalid({xbar_to_m03_couplers_RVALID,xbar_to_m02_couplers_RVALID,xbar_to_m01_couplers_RVALID,xbar_to_m00_couplers_RVALID}),
        .m_axi_wdata({xbar_to_m03_couplers_WDATA,xbar_to_m02_couplers_WDATA,xbar_to_m01_couplers_WDATA,xbar_to_m00_couplers_WDATA}),
        .m_axi_wready({xbar_to_m03_couplers_WREADY,xbar_to_m02_couplers_WREADY,xbar_to_m01_couplers_WREADY,xbar_to_m00_couplers_WREADY}),
        .m_axi_wstrb({xbar_to_m03_couplers_WSTRB,xbar_to_m02_couplers_WSTRB,xbar_to_m01_couplers_WSTRB,xbar_to_m00_couplers_WSTRB}),
        .m_axi_wvalid({xbar_to_m03_couplers_WVALID,xbar_to_m02_couplers_WVALID,xbar_to_m01_couplers_WVALID,xbar_to_m00_couplers_WVALID}),
        .s_axi_araddr(s00_couplers_to_xbar_ARADDR),
        .s_axi_arprot(s00_couplers_to_xbar_ARPROT),
        .s_axi_arready(s00_couplers_to_xbar_ARREADY),
        .s_axi_arvalid(s00_couplers_to_xbar_ARVALID),
        .s_axi_awaddr(s00_couplers_to_xbar_AWADDR),
        .s_axi_awprot(s00_couplers_to_xbar_AWPROT),
        .s_axi_awready(s00_couplers_to_xbar_AWREADY),
        .s_axi_awvalid(s00_couplers_to_xbar_AWVALID),
        .s_axi_bready(s00_couplers_to_xbar_BREADY),
        .s_axi_bresp(s00_couplers_to_xbar_BRESP),
        .s_axi_bvalid(s00_couplers_to_xbar_BVALID),
        .s_axi_rdata(s00_couplers_to_xbar_RDATA),
        .s_axi_rready(s00_couplers_to_xbar_RREADY),
        .s_axi_rresp(s00_couplers_to_xbar_RRESP),
        .s_axi_rvalid(s00_couplers_to_xbar_RVALID),
        .s_axi_wdata(s00_couplers_to_xbar_WDATA),
        .s_axi_wready(s00_couplers_to_xbar_WREADY),
        .s_axi_wstrb(s00_couplers_to_xbar_WSTRB),
        .s_axi_wvalid(s00_couplers_to_xbar_WVALID));
endmodule
