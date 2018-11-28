//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.2 (lin64) Build 2258646 Thu Jun 14 20:02:38 MDT 2018
//Date        : Wed Nov 28 15:35:41 2018
//Host        : kenierkiller running 64-bit Ubuntu 18.04.1 LTS
//Command     : generate_target vcu_trd_wrapper.bd
//Design      : vcu_trd_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module vcu_trd_wrapper
   (diff_clock_rtl_0_clk_n,
    diff_clock_rtl_0_clk_p,
    mdio_rtl_0_mdc,
    mdio_rtl_0_mdio_io,
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
  input diff_clock_rtl_0_clk_n;
  input diff_clock_rtl_0_clk_p;
  output mdio_rtl_0_mdc;
  inout mdio_rtl_0_mdio_io;
  input reset_rtl_0;
  input reset_rtl_0_0;
  input reset_rtl_0_0_1;
  input reset_rtl_0_0_1_2;
  input reset_rtl_0_0_1_2_3;
  input reset_rtl_0_0_1_2_3_4;
  input sfp_rtl_0_rxn;
  input sfp_rtl_0_rxp;
  output sfp_rtl_0_txn;
  output sfp_rtl_0_txp;

  wire diff_clock_rtl_0_clk_n;
  wire diff_clock_rtl_0_clk_p;
  wire mdio_rtl_0_mdc;
  wire mdio_rtl_0_mdio_i;
  wire mdio_rtl_0_mdio_io;
  wire mdio_rtl_0_mdio_o;
  wire mdio_rtl_0_mdio_t;
  wire reset_rtl_0;
  wire reset_rtl_0_0;
  wire reset_rtl_0_0_1;
  wire reset_rtl_0_0_1_2;
  wire reset_rtl_0_0_1_2_3;
  wire reset_rtl_0_0_1_2_3_4;
  wire sfp_rtl_0_rxn;
  wire sfp_rtl_0_rxp;
  wire sfp_rtl_0_txn;
  wire sfp_rtl_0_txp;

  IOBUF mdio_rtl_0_mdio_iobuf
       (.I(mdio_rtl_0_mdio_o),
        .IO(mdio_rtl_0_mdio_io),
        .O(mdio_rtl_0_mdio_i),
        .T(mdio_rtl_0_mdio_t));
  vcu_trd vcu_trd_i
       (.diff_clock_rtl_0_clk_n(diff_clock_rtl_0_clk_n),
        .diff_clock_rtl_0_clk_p(diff_clock_rtl_0_clk_p),
        .mdio_rtl_0_mdc(mdio_rtl_0_mdc),
        .mdio_rtl_0_mdio_i(mdio_rtl_0_mdio_i),
        .mdio_rtl_0_mdio_o(mdio_rtl_0_mdio_o),
        .mdio_rtl_0_mdio_t(mdio_rtl_0_mdio_t),
        .reset_rtl_0(reset_rtl_0),
        .reset_rtl_0_0(reset_rtl_0_0),
        .reset_rtl_0_0_1(reset_rtl_0_0_1),
        .reset_rtl_0_0_1_2(reset_rtl_0_0_1_2),
        .reset_rtl_0_0_1_2_3(reset_rtl_0_0_1_2_3),
        .reset_rtl_0_0_1_2_3_4(reset_rtl_0_0_1_2_3_4),
        .sfp_rtl_0_rxn(sfp_rtl_0_rxn),
        .sfp_rtl_0_rxp(sfp_rtl_0_rxp),
        .sfp_rtl_0_txn(sfp_rtl_0_txn),
        .sfp_rtl_0_txp(sfp_rtl_0_txp));
endmodule
