#ifndef IP_VCU_TRD_ZYNQ_ULTRA_PS_E_0_1_H_
#define IP_VCU_TRD_ZYNQ_ULTRA_PS_E_0_1_H_

// (c) Copyright 1995-2018 Xilinx, Inc. All rights reserved.
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
// DO NOT MODIFY THIS FILE.

#ifndef XTLM
#include "xtlm.h"
#endif

#ifndef SYSTEMC_H
#include "systemc.h"
#endif

class zynq_ultra_ps_e_tlm;

class vcu_trd_zynq_ultra_ps_e_0_1 : public sc_module
{
public:

  vcu_trd_zynq_ultra_ps_e_0_1(const sc_module_name& nm);
  virtual ~vcu_trd_zynq_ultra_ps_e_0_1();

public: // module pin-to-pin RTL interface

  sc_in< bool > maxihpm0_lpd_aclk;
  sc_out< sc_bv<16> > maxigp2_awid;
  sc_out< sc_bv<40> > maxigp2_awaddr;
  sc_out< sc_bv<8> > maxigp2_awlen;
  sc_out< sc_bv<3> > maxigp2_awsize;
  sc_out< sc_bv<2> > maxigp2_awburst;
  sc_out< bool > maxigp2_awlock;
  sc_out< sc_bv<4> > maxigp2_awcache;
  sc_out< sc_bv<3> > maxigp2_awprot;
  sc_out< bool > maxigp2_awvalid;
  sc_out< sc_bv<16> > maxigp2_awuser;
  sc_in< bool > maxigp2_awready;
  sc_out< sc_bv<32> > maxigp2_wdata;
  sc_out< sc_bv<4> > maxigp2_wstrb;
  sc_out< bool > maxigp2_wlast;
  sc_out< bool > maxigp2_wvalid;
  sc_in< bool > maxigp2_wready;
  sc_in< sc_bv<16> > maxigp2_bid;
  sc_in< sc_bv<2> > maxigp2_bresp;
  sc_in< bool > maxigp2_bvalid;
  sc_out< bool > maxigp2_bready;
  sc_out< sc_bv<16> > maxigp2_arid;
  sc_out< sc_bv<40> > maxigp2_araddr;
  sc_out< sc_bv<8> > maxigp2_arlen;
  sc_out< sc_bv<3> > maxigp2_arsize;
  sc_out< sc_bv<2> > maxigp2_arburst;
  sc_out< bool > maxigp2_arlock;
  sc_out< sc_bv<4> > maxigp2_arcache;
  sc_out< sc_bv<3> > maxigp2_arprot;
  sc_out< bool > maxigp2_arvalid;
  sc_out< sc_bv<16> > maxigp2_aruser;
  sc_in< bool > maxigp2_arready;
  sc_in< sc_bv<16> > maxigp2_rid;
  sc_in< sc_bv<32> > maxigp2_rdata;
  sc_in< sc_bv<2> > maxigp2_rresp;
  sc_in< bool > maxigp2_rlast;
  sc_in< bool > maxigp2_rvalid;
  sc_out< bool > maxigp2_rready;
  sc_out< sc_bv<4> > maxigp2_awqos;
  sc_out< sc_bv<4> > maxigp2_arqos;
  sc_in< bool > saxihpc0_fpd_aclk;
  sc_in< bool > saxigp0_aruser;
  sc_in< bool > saxigp0_awuser;
  sc_in< sc_bv<6> > saxigp0_awid;
  sc_in< sc_bv<49> > saxigp0_awaddr;
  sc_in< sc_bv<8> > saxigp0_awlen;
  sc_in< sc_bv<3> > saxigp0_awsize;
  sc_in< sc_bv<2> > saxigp0_awburst;
  sc_in< bool > saxigp0_awlock;
  sc_in< sc_bv<4> > saxigp0_awcache;
  sc_in< sc_bv<3> > saxigp0_awprot;
  sc_in< bool > saxigp0_awvalid;
  sc_out< bool > saxigp0_awready;
  sc_in< sc_bv<32> > saxigp0_wdata;
  sc_in< sc_bv<4> > saxigp0_wstrb;
  sc_in< bool > saxigp0_wlast;
  sc_in< bool > saxigp0_wvalid;
  sc_out< bool > saxigp0_wready;
  sc_out< sc_bv<6> > saxigp0_bid;
  sc_out< sc_bv<2> > saxigp0_bresp;
  sc_out< bool > saxigp0_bvalid;
  sc_in< bool > saxigp0_bready;
  sc_in< sc_bv<6> > saxigp0_arid;
  sc_in< sc_bv<49> > saxigp0_araddr;
  sc_in< sc_bv<8> > saxigp0_arlen;
  sc_in< sc_bv<3> > saxigp0_arsize;
  sc_in< sc_bv<2> > saxigp0_arburst;
  sc_in< bool > saxigp0_arlock;
  sc_in< sc_bv<4> > saxigp0_arcache;
  sc_in< sc_bv<3> > saxigp0_arprot;
  sc_in< bool > saxigp0_arvalid;
  sc_out< bool > saxigp0_arready;
  sc_out< sc_bv<6> > saxigp0_rid;
  sc_out< sc_bv<32> > saxigp0_rdata;
  sc_out< sc_bv<2> > saxigp0_rresp;
  sc_out< bool > saxigp0_rlast;
  sc_out< bool > saxigp0_rvalid;
  sc_in< bool > saxigp0_rready;
  sc_in< sc_bv<4> > saxigp0_awqos;
  sc_in< sc_bv<4> > saxigp0_arqos;
  sc_in< bool > saxihp0_fpd_aclk;
  sc_in< bool > saxigp2_aruser;
  sc_in< bool > saxigp2_awuser;
  sc_in< sc_bv<6> > saxigp2_awid;
  sc_in< sc_bv<49> > saxigp2_awaddr;
  sc_in< sc_bv<8> > saxigp2_awlen;
  sc_in< sc_bv<3> > saxigp2_awsize;
  sc_in< sc_bv<2> > saxigp2_awburst;
  sc_in< bool > saxigp2_awlock;
  sc_in< sc_bv<4> > saxigp2_awcache;
  sc_in< sc_bv<3> > saxigp2_awprot;
  sc_in< bool > saxigp2_awvalid;
  sc_out< bool > saxigp2_awready;
  sc_in< sc_bv<128> > saxigp2_wdata;
  sc_in< sc_bv<16> > saxigp2_wstrb;
  sc_in< bool > saxigp2_wlast;
  sc_in< bool > saxigp2_wvalid;
  sc_out< bool > saxigp2_wready;
  sc_out< sc_bv<6> > saxigp2_bid;
  sc_out< sc_bv<2> > saxigp2_bresp;
  sc_out< bool > saxigp2_bvalid;
  sc_in< bool > saxigp2_bready;
  sc_in< sc_bv<6> > saxigp2_arid;
  sc_in< sc_bv<49> > saxigp2_araddr;
  sc_in< sc_bv<8> > saxigp2_arlen;
  sc_in< sc_bv<3> > saxigp2_arsize;
  sc_in< sc_bv<2> > saxigp2_arburst;
  sc_in< bool > saxigp2_arlock;
  sc_in< sc_bv<4> > saxigp2_arcache;
  sc_in< sc_bv<3> > saxigp2_arprot;
  sc_in< bool > saxigp2_arvalid;
  sc_out< bool > saxigp2_arready;
  sc_out< sc_bv<6> > saxigp2_rid;
  sc_out< sc_bv<128> > saxigp2_rdata;
  sc_out< sc_bv<2> > saxigp2_rresp;
  sc_out< bool > saxigp2_rlast;
  sc_out< bool > saxigp2_rvalid;
  sc_in< bool > saxigp2_rready;
  sc_in< sc_bv<4> > saxigp2_awqos;
  sc_in< sc_bv<4> > saxigp2_arqos;
  sc_in< bool > saxihp1_fpd_aclk;
  sc_in< bool > saxigp3_aruser;
  sc_in< bool > saxigp3_awuser;
  sc_in< sc_bv<6> > saxigp3_awid;
  sc_in< sc_bv<49> > saxigp3_awaddr;
  sc_in< sc_bv<8> > saxigp3_awlen;
  sc_in< sc_bv<3> > saxigp3_awsize;
  sc_in< sc_bv<2> > saxigp3_awburst;
  sc_in< bool > saxigp3_awlock;
  sc_in< sc_bv<4> > saxigp3_awcache;
  sc_in< sc_bv<3> > saxigp3_awprot;
  sc_in< bool > saxigp3_awvalid;
  sc_out< bool > saxigp3_awready;
  sc_in< sc_bv<128> > saxigp3_wdata;
  sc_in< sc_bv<16> > saxigp3_wstrb;
  sc_in< bool > saxigp3_wlast;
  sc_in< bool > saxigp3_wvalid;
  sc_out< bool > saxigp3_wready;
  sc_out< sc_bv<6> > saxigp3_bid;
  sc_out< sc_bv<2> > saxigp3_bresp;
  sc_out< bool > saxigp3_bvalid;
  sc_in< bool > saxigp3_bready;
  sc_in< sc_bv<6> > saxigp3_arid;
  sc_in< sc_bv<49> > saxigp3_araddr;
  sc_in< sc_bv<8> > saxigp3_arlen;
  sc_in< sc_bv<3> > saxigp3_arsize;
  sc_in< sc_bv<2> > saxigp3_arburst;
  sc_in< bool > saxigp3_arlock;
  sc_in< sc_bv<4> > saxigp3_arcache;
  sc_in< sc_bv<3> > saxigp3_arprot;
  sc_in< bool > saxigp3_arvalid;
  sc_out< bool > saxigp3_arready;
  sc_out< sc_bv<6> > saxigp3_rid;
  sc_out< sc_bv<128> > saxigp3_rdata;
  sc_out< sc_bv<2> > saxigp3_rresp;
  sc_out< bool > saxigp3_rlast;
  sc_out< bool > saxigp3_rvalid;
  sc_in< bool > saxigp3_rready;
  sc_in< sc_bv<4> > saxigp3_awqos;
  sc_in< sc_bv<4> > saxigp3_arqos;
  sc_in< bool > saxihp2_fpd_aclk;
  sc_in< bool > saxigp4_aruser;
  sc_in< bool > saxigp4_awuser;
  sc_in< sc_bv<6> > saxigp4_awid;
  sc_in< sc_bv<49> > saxigp4_awaddr;
  sc_in< sc_bv<8> > saxigp4_awlen;
  sc_in< sc_bv<3> > saxigp4_awsize;
  sc_in< sc_bv<2> > saxigp4_awburst;
  sc_in< bool > saxigp4_awlock;
  sc_in< sc_bv<4> > saxigp4_awcache;
  sc_in< sc_bv<3> > saxigp4_awprot;
  sc_in< bool > saxigp4_awvalid;
  sc_out< bool > saxigp4_awready;
  sc_in< sc_bv<128> > saxigp4_wdata;
  sc_in< sc_bv<16> > saxigp4_wstrb;
  sc_in< bool > saxigp4_wlast;
  sc_in< bool > saxigp4_wvalid;
  sc_out< bool > saxigp4_wready;
  sc_out< sc_bv<6> > saxigp4_bid;
  sc_out< sc_bv<2> > saxigp4_bresp;
  sc_out< bool > saxigp4_bvalid;
  sc_in< bool > saxigp4_bready;
  sc_in< sc_bv<6> > saxigp4_arid;
  sc_in< sc_bv<49> > saxigp4_araddr;
  sc_in< sc_bv<8> > saxigp4_arlen;
  sc_in< sc_bv<3> > saxigp4_arsize;
  sc_in< sc_bv<2> > saxigp4_arburst;
  sc_in< bool > saxigp4_arlock;
  sc_in< sc_bv<4> > saxigp4_arcache;
  sc_in< sc_bv<3> > saxigp4_arprot;
  sc_in< bool > saxigp4_arvalid;
  sc_out< bool > saxigp4_arready;
  sc_out< sc_bv<6> > saxigp4_rid;
  sc_out< sc_bv<128> > saxigp4_rdata;
  sc_out< sc_bv<2> > saxigp4_rresp;
  sc_out< bool > saxigp4_rlast;
  sc_out< bool > saxigp4_rvalid;
  sc_in< bool > saxigp4_rready;
  sc_in< sc_bv<4> > saxigp4_awqos;
  sc_in< sc_bv<4> > saxigp4_arqos;
  sc_in< bool > saxihp3_fpd_aclk;
  sc_in< bool > saxigp5_aruser;
  sc_in< bool > saxigp5_awuser;
  sc_in< sc_bv<6> > saxigp5_awid;
  sc_in< sc_bv<49> > saxigp5_awaddr;
  sc_in< sc_bv<8> > saxigp5_awlen;
  sc_in< sc_bv<3> > saxigp5_awsize;
  sc_in< sc_bv<2> > saxigp5_awburst;
  sc_in< bool > saxigp5_awlock;
  sc_in< sc_bv<4> > saxigp5_awcache;
  sc_in< sc_bv<3> > saxigp5_awprot;
  sc_in< bool > saxigp5_awvalid;
  sc_out< bool > saxigp5_awready;
  sc_in< sc_bv<128> > saxigp5_wdata;
  sc_in< sc_bv<16> > saxigp5_wstrb;
  sc_in< bool > saxigp5_wlast;
  sc_in< bool > saxigp5_wvalid;
  sc_out< bool > saxigp5_wready;
  sc_out< sc_bv<6> > saxigp5_bid;
  sc_out< sc_bv<2> > saxigp5_bresp;
  sc_out< bool > saxigp5_bvalid;
  sc_in< bool > saxigp5_bready;
  sc_in< sc_bv<6> > saxigp5_arid;
  sc_in< sc_bv<49> > saxigp5_araddr;
  sc_in< sc_bv<8> > saxigp5_arlen;
  sc_in< sc_bv<3> > saxigp5_arsize;
  sc_in< sc_bv<2> > saxigp5_arburst;
  sc_in< bool > saxigp5_arlock;
  sc_in< sc_bv<4> > saxigp5_arcache;
  sc_in< sc_bv<3> > saxigp5_arprot;
  sc_in< bool > saxigp5_arvalid;
  sc_out< bool > saxigp5_arready;
  sc_out< sc_bv<6> > saxigp5_rid;
  sc_out< sc_bv<128> > saxigp5_rdata;
  sc_out< sc_bv<2> > saxigp5_rresp;
  sc_out< bool > saxigp5_rlast;
  sc_out< bool > saxigp5_rvalid;
  sc_in< bool > saxigp5_rready;
  sc_in< sc_bv<4> > saxigp5_awqos;
  sc_in< sc_bv<4> > saxigp5_arqos;
  sc_in< sc_bv<1> > pl_ps_irq0;
  sc_out< bool > pl_resetn0;
  sc_out< bool > pl_clk0;

public: // module socket-to-socket TLM interface

  xtlm::xtlm_aximm_initiator_socket* M_AXI_HPM0_LPD_wr_socket;
  xtlm::xtlm_aximm_initiator_socket* M_AXI_HPM0_LPD_rd_socket;
  xtlm::xtlm_aximm_target_socket* S_AXI_HPC0_FPD_wr_socket;
  xtlm::xtlm_aximm_target_socket* S_AXI_HPC0_FPD_rd_socket;
  xtlm::xtlm_aximm_target_socket* S_AXI_HP0_FPD_wr_socket;
  xtlm::xtlm_aximm_target_socket* S_AXI_HP0_FPD_rd_socket;
  xtlm::xtlm_aximm_target_socket* S_AXI_HP1_FPD_wr_socket;
  xtlm::xtlm_aximm_target_socket* S_AXI_HP1_FPD_rd_socket;
  xtlm::xtlm_aximm_target_socket* S_AXI_HP2_FPD_wr_socket;
  xtlm::xtlm_aximm_target_socket* S_AXI_HP2_FPD_rd_socket;
  xtlm::xtlm_aximm_target_socket* S_AXI_HP3_FPD_wr_socket;
  xtlm::xtlm_aximm_target_socket* S_AXI_HP3_FPD_rd_socket;

protected:

  virtual void before_end_of_elaboration();

private:

  vcu_trd_zynq_ultra_ps_e_0_1(const vcu_trd_zynq_ultra_ps_e_0_1&);
  const vcu_trd_zynq_ultra_ps_e_0_1& operator=(const vcu_trd_zynq_ultra_ps_e_0_1&);

  zynq_ultra_ps_e_tlm* mp_impl;

  xtlm::xaximm_xtlm2pin_t<32,40,16,16,1,1,16,1>* mp_M_AXI_HPM0_LPD_transactor;
  sc_signal< bool > m_M_AXI_HPM0_LPD_transactor_rst_signal;

  xtlm::xaximm_pin2xtlm_t<32,49,6,1,1,1,1,1>* mp_S_AXI_HPC0_FPD_transactor;
  xsc::common::scalar2vector_converter* mp_saxigp0_aruser_converter;
  sc_signal< sc_bv<1> > m_saxigp0_aruser_converter_signal;
  xsc::common::scalar2vector_converter* mp_saxigp0_awuser_converter;
  sc_signal< sc_bv<1> > m_saxigp0_awuser_converter_signal;
  sc_signal< bool > m_S_AXI_HPC0_FPD_transactor_rst_signal;

  xtlm::xaximm_pin2xtlm_t<128,49,6,1,1,1,1,1>* mp_S_AXI_HP0_FPD_transactor;
  xsc::common::scalar2vector_converter* mp_saxigp2_aruser_converter;
  sc_signal< sc_bv<1> > m_saxigp2_aruser_converter_signal;
  xsc::common::scalar2vector_converter* mp_saxigp2_awuser_converter;
  sc_signal< sc_bv<1> > m_saxigp2_awuser_converter_signal;
  sc_signal< bool > m_S_AXI_HP0_FPD_transactor_rst_signal;

  xtlm::xaximm_pin2xtlm_t<128,49,6,1,1,1,1,1>* mp_S_AXI_HP1_FPD_transactor;
  xsc::common::scalar2vector_converter* mp_saxigp3_aruser_converter;
  sc_signal< sc_bv<1> > m_saxigp3_aruser_converter_signal;
  xsc::common::scalar2vector_converter* mp_saxigp3_awuser_converter;
  sc_signal< sc_bv<1> > m_saxigp3_awuser_converter_signal;
  sc_signal< bool > m_S_AXI_HP1_FPD_transactor_rst_signal;

  xtlm::xaximm_pin2xtlm_t<128,49,6,1,1,1,1,1>* mp_S_AXI_HP2_FPD_transactor;
  xsc::common::scalar2vector_converter* mp_saxigp4_aruser_converter;
  sc_signal< sc_bv<1> > m_saxigp4_aruser_converter_signal;
  xsc::common::scalar2vector_converter* mp_saxigp4_awuser_converter;
  sc_signal< sc_bv<1> > m_saxigp4_awuser_converter_signal;
  sc_signal< bool > m_S_AXI_HP2_FPD_transactor_rst_signal;

  xtlm::xaximm_pin2xtlm_t<128,49,6,1,1,1,1,1>* mp_S_AXI_HP3_FPD_transactor;
  xsc::common::scalar2vector_converter* mp_saxigp5_aruser_converter;
  sc_signal< sc_bv<1> > m_saxigp5_aruser_converter_signal;
  xsc::common::scalar2vector_converter* mp_saxigp5_awuser_converter;
  sc_signal< sc_bv<1> > m_saxigp5_awuser_converter_signal;
  sc_signal< bool > m_S_AXI_HP3_FPD_transactor_rst_signal;

};

#endif // IP_VCU_TRD_ZYNQ_ULTRA_PS_E_0_1_H_
