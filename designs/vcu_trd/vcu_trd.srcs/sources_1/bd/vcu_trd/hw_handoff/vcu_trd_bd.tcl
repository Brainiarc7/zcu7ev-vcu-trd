
################################################################
# This is a generated script based on design: vcu_trd
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2018.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source vcu_trd_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xczu7ev-fbvb900-1-i
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name vcu_trd

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set diff_clock_rtl_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 diff_clock_rtl_0 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   ] $diff_clock_rtl_0
  set mdio_rtl_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 mdio_rtl_0 ]
  set sfp_rtl_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:sfp_rtl:1.0 sfp_rtl_0 ]

  # Create ports
  set reset_rtl_0 [ create_bd_port -dir I -type rst reset_rtl_0 ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset_rtl_0
  set reset_rtl_0_0 [ create_bd_port -dir I -type rst reset_rtl_0_0 ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset_rtl_0_0
  set reset_rtl_0_0_1 [ create_bd_port -dir I -type rst reset_rtl_0_0_1 ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset_rtl_0_0_1
  set reset_rtl_0_0_1_2 [ create_bd_port -dir I -type rst reset_rtl_0_0_1_2 ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset_rtl_0_0_1_2
  set reset_rtl_0_0_1_2_3 [ create_bd_port -dir I -type rst reset_rtl_0_0_1_2_3 ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset_rtl_0_0_1_2_3
  set reset_rtl_0_0_1_2_3_4 [ create_bd_port -dir I -type rst reset_rtl_0_0_1_2_3_4 ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset_rtl_0_0_1_2_3_4

  # Create instance: clk_wiz, and set properties
  set clk_wiz [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz ]

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]

  # Create instance: clk_wiz_1, and set properties
  set clk_wiz_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_1 ]

  # Create instance: clk_wiz_2, and set properties
  set clk_wiz_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_2 ]

  # Create instance: clk_wiz_3, and set properties
  set clk_wiz_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_3 ]

  # Create instance: clk_wiz_4, and set properties
  set clk_wiz_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_4 ]

  # Create instance: gig_ethernet_pcs_pma_0, and set properties
  set gig_ethernet_pcs_pma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:gig_ethernet_pcs_pma:16.1 gig_ethernet_pcs_pma_0 ]
  set_property -dict [ list \
   CONFIG.EMAC_IF_TEMAC {TEMAC} \
   CONFIG.Ext_Management_Interface {true} \
   CONFIG.MaxDataRate {1G} \
   CONFIG.Standard {BOTH} \
   CONFIG.SupportLevel {Include_Shared_Logic_in_Core} \
   CONFIG.TransceiverControl {false} \
 ] $gig_ethernet_pcs_pma_0

  # Create instance: proc_sys_reset_vcu_0, and set properties
  set proc_sys_reset_vcu_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_vcu_0 ]

  # Create instance: proc_sys_reset_vcu_1, and set properties
  set proc_sys_reset_vcu_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_vcu_1 ]

  # Create instance: v_smpte_uhdsdi_rx_ss_0, and set properties
  set v_smpte_uhdsdi_rx_ss_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_smpte_uhdsdi_rx_ss:2.0 v_smpte_uhdsdi_rx_ss_0 ]

  # Create instance: v_smpte_uhdsdi_tx_ss_0, and set properties
  set v_smpte_uhdsdi_tx_ss_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_smpte_uhdsdi_tx_ss:2.0 v_smpte_uhdsdi_tx_ss_0 ]

  # Create instance: vcu_0, and set properties
  set vcu_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:vcu:1.1 vcu_0 ]
  set_property -dict [ list \
   CONFIG.DEC_CODING_TYPE {1} \
   CONFIG.DEC_FPS {3} \
   CONFIG.DEC_FRAME_SIZE {3} \
   CONFIG.ENC_BUFFER_B_FRAME {2} \
   CONFIG.ENC_BUFFER_EN {true} \
   CONFIG.ENC_BUFFER_MOTION_VEC_RANGE {1} \
   CONFIG.ENC_BUFFER_SIZE {2800} \
   CONFIG.ENC_BUFFER_SIZE_ACTUAL {2975} \
   CONFIG.ENC_BUFFER_TYPE {2} \
   CONFIG.ENC_CODING_TYPE {1} \
   CONFIG.ENC_FPS {3} \
   CONFIG.ENC_FRAME_SIZE {1} \
   CONFIG.ENC_MEM_URAM_USED {0} \
   CONFIG.NO_OF_STREAMS {4} \
   CONFIG.TABLE_NO {3} \
 ] $vcu_0

  # Create instance: vcu_axi_lite_0, and set properties
  set vcu_axi_lite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 vcu_axi_lite_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
 ] $vcu_axi_lite_0

  # Create instance: vcu_clk_wiz0, and set properties
  set vcu_clk_wiz0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 vcu_clk_wiz0 ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_DRIVES {Buffer} \
   CONFIG.CLKOUT1_JITTER {173.386} \
   CONFIG.CLKOUT1_PHASE_ERROR {253.265} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {33} \
   CONFIG.CLKOUT2_DRIVES {Buffer} \
   CONFIG.CLKOUT2_JITTER {139.003} \
   CONFIG.CLKOUT2_PHASE_ERROR {253.265} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {167} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_DRIVES {Buffer} \
   CONFIG.CLKOUT4_DRIVES {Buffer} \
   CONFIG.CLKOUT5_DRIVES {Buffer} \
   CONFIG.CLKOUT6_DRIVES {Buffer} \
   CONFIG.CLKOUT7_DRIVES {Buffer} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {120.125} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {45.500} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {9} \
   CONFIG.MMCM_DIVCLK_DIVIDE {8} \
   CONFIG.NUM_OUT_CLKS {2} \
   CONFIG.PHASE_DUTY_CONFIG {false} \
   CONFIG.RESET_PORT {reset} \
   CONFIG.RESET_TYPE {ACTIVE_HIGH} \
   CONFIG.SECONDARY_SOURCE {Single_ended_clock_capable_pin} \
   CONFIG.USE_DYN_PHASE_SHIFT {false} \
   CONFIG.USE_DYN_RECONFIG {true} \
   CONFIG.USE_PHASE_ALIGNMENT {false} \
 ] $vcu_clk_wiz0

  # Create instance: vcu_dec0_reg_slice, and set properties
  set vcu_dec0_reg_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 vcu_dec0_reg_slice ]

  # Create instance: vcu_dec1_reg_slice, and set properties
  set vcu_dec1_reg_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 vcu_dec1_reg_slice ]

  # Create instance: vcu_enc0_reg_slice, and set properties
  set vcu_enc0_reg_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 vcu_enc0_reg_slice ]

  # Create instance: vcu_enc1_reg_slice, and set properties
  set vcu_enc1_reg_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 vcu_enc1_reg_slice ]

  # Create instance: vcu_interrupt, and set properties
  set vcu_interrupt [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 vcu_interrupt ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {1} \
 ] $vcu_interrupt

  # Create instance: vcu_mcu_reg_slice, and set properties
  set vcu_mcu_reg_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 vcu_mcu_reg_slice ]

  # Create instance: zynq_ultra_ps_e_0, and set properties
  set zynq_ultra_ps_e_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.2 zynq_ultra_ps_e_0 ]
  set_property -dict [ list \
   CONFIG.PSU_DDR_RAM_HIGHADDR_OFFSET {0x00000002} \
   CONFIG.PSU_DDR_RAM_LOWADDR_OFFSET {0x80000000} \
   CONFIG.PSU__AFI0_COHERENCY {0} \
   CONFIG.PSU__DDR_HIGH_ADDRESS_GUI_ENABLE {0} \
   CONFIG.PSU__PROTECTION__MASTERS {USB1:NonSecure;0|USB0:NonSecure;0|S_AXI_LPD:NA;0|S_AXI_HPC1_FPD:NA;0|S_AXI_HPC0_FPD:NA;1|S_AXI_HP3_FPD:NA;1|S_AXI_HP2_FPD:NA;1|S_AXI_HP1_FPD:NA;1|S_AXI_HP0_FPD:NA;1|S_AXI_ACP:NA;0|S_AXI_ACE:NA;0|SD1:NonSecure;0|SD0:NonSecure;0|SATA1:NonSecure;0|SATA0:NonSecure;0|RPU1:Secure;1|RPU0:Secure;1|QSPI:NonSecure;0|PMU:NA;1|PCIe:NonSecure;0|NAND:NonSecure;0|LDMA:NonSecure;1|GPU:NonSecure;1|GEM3:NonSecure;0|GEM2:NonSecure;0|GEM1:NonSecure;0|GEM0:NonSecure;0|FDMA:NonSecure;1|DP:NonSecure;0|DAP:NA;1|Coresight:NA;1|CSU:NA;1|APU:NA;1} \
   CONFIG.PSU__PROTECTION__SLAVES {LPD;USB3_1_XHCI;FE300000;FE3FFFFF;0|LPD;USB3_1;FF9E0000;FF9EFFFF;0|LPD;USB3_0_XHCI;FE200000;FE2FFFFF;0|LPD;USB3_0;FF9D0000;FF9DFFFF;0|LPD;UART1;FF010000;FF01FFFF;0|LPD;UART0;FF000000;FF00FFFF;0|LPD;TTC3;FF140000;FF14FFFF;0|LPD;TTC2;FF130000;FF13FFFF;0|LPD;TTC1;FF120000;FF12FFFF;0|LPD;TTC0;FF110000;FF11FFFF;0|FPD;SWDT1;FD4D0000;FD4DFFFF;0|LPD;SWDT0;FF150000;FF15FFFF;0|LPD;SPI1;FF050000;FF05FFFF;0|LPD;SPI0;FF040000;FF04FFFF;0|FPD;SMMU_REG;FD5F0000;FD5FFFFF;1|FPD;SMMU;FD800000;FDFFFFFF;1|FPD;SIOU;FD3D0000;FD3DFFFF;1|FPD;SERDES;FD400000;FD47FFFF;1|LPD;SD1;FF170000;FF17FFFF;0|LPD;SD0;FF160000;FF16FFFF;0|FPD;SATA;FD0C0000;FD0CFFFF;0|LPD;RTC;FFA60000;FFA6FFFF;1|LPD;RSA_CORE;FFCE0000;FFCEFFFF;1|LPD;RPU;FF9A0000;FF9AFFFF;1|FPD;RCPU_GIC;F9000000;F900FFFF;1|LPD;R5_TCM_RAM_GLOBAL;FFE00000;FFE3FFFF;1|LPD;R5_1_Instruction_Cache;FFEC0000;FFECFFFF;1|LPD;R5_1_Data_Cache;FFED0000;FFEDFFFF;1|LPD;R5_1_BTCM_GLOBAL;FFEB0000;FFEBFFFF;1|LPD;R5_1_ATCM_GLOBAL;FFE90000;FFE9FFFF;1|LPD;R5_0_Instruction_Cache;FFE40000;FFE4FFFF;1|LPD;R5_0_Data_Cache;FFE50000;FFE5FFFF;1|LPD;R5_0_BTCM_GLOBAL;FFE20000;FFE2FFFF;1|LPD;R5_0_ATCM_GLOBAL;FFE00000;FFE0FFFF;1|LPD;QSPI_Linear_Address;C0000000;DFFFFFFF;1|LPD;QSPI;FF0F0000;FF0FFFFF;0|LPD;PMU_RAM;FFDC0000;FFDDFFFF;1|LPD;PMU_GLOBAL;FFD80000;FFDBFFFF;1|FPD;PCIE_MAIN;FD0E0000;FD0EFFFF;0|FPD;PCIE_LOW;E0000000;EFFFFFFF;0|FPD;PCIE_HIGH2;8000000000;BFFFFFFFFF;0|FPD;PCIE_HIGH1;600000000;7FFFFFFFF;0|FPD;PCIE_DMA;FD0F0000;FD0FFFFF;0|FPD;PCIE_ATTRIB;FD480000;FD48FFFF;0|LPD;OCM_XMPU_CFG;FFA70000;FFA7FFFF;1|LPD;OCM_SLCR;FF960000;FF96FFFF;1|OCM;OCM;FFFC0000;FFFFFFFF;1|LPD;NAND;FF100000;FF10FFFF;0|LPD;MBISTJTAG;FFCF0000;FFCFFFFF;1|LPD;LPD_XPPU_SINK;FF9C0000;FF9CFFFF;1|LPD;LPD_XPPU;FF980000;FF98FFFF;1|LPD;LPD_SLCR_SECURE;FF4B0000;FF4DFFFF;1|LPD;LPD_SLCR;FF410000;FF4AFFFF;1|LPD;LPD_GPV;FE100000;FE1FFFFF;1|LPD;LPD_DMA_7;FFAF0000;FFAFFFFF;1|LPD;LPD_DMA_6;FFAE0000;FFAEFFFF;1|LPD;LPD_DMA_5;FFAD0000;FFADFFFF;1|LPD;LPD_DMA_4;FFAC0000;FFACFFFF;1|LPD;LPD_DMA_3;FFAB0000;FFABFFFF;1|LPD;LPD_DMA_2;FFAA0000;FFAAFFFF;1|LPD;LPD_DMA_1;FFA90000;FFA9FFFF;1|LPD;LPD_DMA_0;FFA80000;FFA8FFFF;1|LPD;IPI_CTRL;FF380000;FF3FFFFF;1|LPD;IOU_SLCR;FF180000;FF23FFFF;1|LPD;IOU_SECURE_SLCR;FF240000;FF24FFFF;1|LPD;IOU_SCNTRS;FF260000;FF26FFFF;1|LPD;IOU_SCNTR;FF250000;FF25FFFF;1|LPD;IOU_GPV;FE000000;FE0FFFFF;1|LPD;I2C1;FF030000;FF03FFFF;0|LPD;I2C0;FF020000;FF02FFFF;0|FPD;GPU;FD4B0000;FD4BFFFF;1|LPD;GPIO;FF0A0000;FF0AFFFF;1|LPD;GEM3;FF0E0000;FF0EFFFF;0|LPD;GEM2;FF0D0000;FF0DFFFF;0|LPD;GEM1;FF0C0000;FF0CFFFF;0|LPD;GEM0;FF0B0000;FF0BFFFF;0|FPD;FPD_XMPU_SINK;FD4F0000;FD4FFFFF;1|FPD;FPD_XMPU_CFG;FD5D0000;FD5DFFFF;1|FPD;FPD_SLCR_SECURE;FD690000;FD6CFFFF;1|FPD;FPD_SLCR;FD610000;FD68FFFF;1|FPD;FPD_GPV;FD700000;FD7FFFFF;1|FPD;FPD_DMA_CH7;FD570000;FD57FFFF;1|FPD;FPD_DMA_CH6;FD560000;FD56FFFF;1|FPD;FPD_DMA_CH5;FD550000;FD55FFFF;1|FPD;FPD_DMA_CH4;FD540000;FD54FFFF;1|FPD;FPD_DMA_CH3;FD530000;FD53FFFF;1|FPD;FPD_DMA_CH2;FD520000;FD52FFFF;1|FPD;FPD_DMA_CH1;FD510000;FD51FFFF;1|FPD;FPD_DMA_CH0;FD500000;FD50FFFF;1|LPD;EFUSE;FFCC0000;FFCCFFFF;1|FPD;Display Port;FD4A0000;FD4AFFFF;0|FPD;DPDMA;FD4C0000;FD4CFFFF;0|FPD;DDR_XMPU5_CFG;FD050000;FD05FFFF;1|FPD;DDR_XMPU4_CFG;FD040000;FD04FFFF;1|FPD;DDR_XMPU3_CFG;FD030000;FD03FFFF;1|FPD;DDR_XMPU2_CFG;FD020000;FD02FFFF;1|FPD;DDR_XMPU1_CFG;FD010000;FD01FFFF;1|FPD;DDR_XMPU0_CFG;FD000000;FD00FFFF;1|FPD;DDR_QOS_CTRL;FD090000;FD09FFFF;1|FPD;DDR_PHY;FD080000;FD08FFFF;1|DDR;DDR_LOW;0;7FFFFFFF;1|DDR;DDR_HIGH;800000000;800000000;0|FPD;DDDR_CTRL;FD070000;FD070FFF;1|LPD;Coresight;FE800000;FEFFFFFF;1|LPD;CSU_DMA;FFC80000;FFC9FFFF;1|LPD;CSU;FFCA0000;FFCAFFFF;0|LPD;CRL_APB;FF5E0000;FF85FFFF;1|FPD;CRF_APB;FD1A0000;FD2DFFFF;1|FPD;CCI_REG;FD5E0000;FD5EFFFF;1|FPD;CCI_GPV;FD6E0000;FD6EFFFF;1|LPD;CAN1;FF070000;FF07FFFF;0|LPD;CAN0;FF060000;FF06FFFF;0|FPD;APU;FD5C0000;FD5CFFFF;1|LPD;APM_INTC_IOU;FFA20000;FFA2FFFF;1|LPD;APM_FPD_LPD;FFA30000;FFA3FFFF;1|FPD;APM_5;FD490000;FD49FFFF;1|FPD;APM_0;FD0B0000;FD0BFFFF;1|LPD;APM2;FFA10000;FFA1FFFF;1|LPD;APM1;FFA00000;FFA0FFFF;1|LPD;AMS;FFA50000;FFA5FFFF;1|FPD;AFI_5;FD3B0000;FD3BFFFF;1|FPD;AFI_4;FD3A0000;FD3AFFFF;1|FPD;AFI_3;FD390000;FD39FFFF;1|FPD;AFI_2;FD380000;FD38FFFF;1|FPD;AFI_1;FD370000;FD37FFFF;1|FPD;AFI_0;FD360000;FD36FFFF;1|LPD;AFIFM6;FF9B0000;FF9BFFFF;1|FPD;ACPU_GIC;F9000000;F907FFFF;1} \
   CONFIG.PSU__SAXIGP0__DATA_WIDTH {32} \
   CONFIG.PSU__SAXIGP2__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP3__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP4__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP5__DATA_WIDTH {128} \
   CONFIG.PSU__USE__IRQ0 {1} \
   CONFIG.PSU__USE__S_AXI_GP0 {1} \
   CONFIG.PSU__USE__S_AXI_GP2 {1} \
   CONFIG.PSU__USE__S_AXI_GP3 {1} \
   CONFIG.PSU__USE__S_AXI_GP4 {1} \
   CONFIG.PSU__USE__S_AXI_GP5 {1} \
 ] $zynq_ultra_ps_e_0

  # Create interface connections
  connect_bd_intf_net -intf_net axi_lite_2_zynq [get_bd_intf_pins vcu_axi_lite_0/S00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_LPD]
  connect_bd_intf_net -intf_net diff_clock_rtl_0_1 [get_bd_intf_ports diff_clock_rtl_0] [get_bd_intf_pins gig_ethernet_pcs_pma_0/gtrefclk_in]
  connect_bd_intf_net -intf_net gig_ethernet_pcs_pma_0_ext_mdio_pcs_pma [get_bd_intf_ports mdio_rtl_0] [get_bd_intf_pins gig_ethernet_pcs_pma_0/ext_mdio_pcs_pma]
  connect_bd_intf_net -intf_net gig_ethernet_pcs_pma_0_sfp [get_bd_intf_ports sfp_rtl_0] [get_bd_intf_pins gig_ethernet_pcs_pma_0/sfp]
  connect_bd_intf_net -intf_net vcu_2_axi_lite [get_bd_intf_pins vcu_0/S_AXI_LITE] [get_bd_intf_pins vcu_axi_lite_0/M00_AXI]
  connect_bd_intf_net -intf_net vcu_axi_lite_0_M01_AXI [get_bd_intf_pins v_smpte_uhdsdi_rx_ss_0/S_AXI_CTRL] [get_bd_intf_pins vcu_axi_lite_0/M01_AXI]
  connect_bd_intf_net -intf_net vcu_axi_lite_0_M02_AXI [get_bd_intf_pins v_smpte_uhdsdi_tx_ss_0/S_AXI_CTRL] [get_bd_intf_pins vcu_axi_lite_0/M02_AXI]
  connect_bd_intf_net -intf_net vcu_axi_lite_0_M03_AXI [get_bd_intf_pins vcu_axi_lite_0/M03_AXI] [get_bd_intf_pins vcu_clk_wiz0/s_axi_lite]
  connect_bd_intf_net -intf_net vcu_dec_00_axi [get_bd_intf_pins vcu_0/M_AXI_DEC0] [get_bd_intf_pins vcu_dec0_reg_slice/S_AXI]
  connect_bd_intf_net -intf_net vcu_dec_01_axi [get_bd_intf_pins vcu_dec0_reg_slice/M_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP2_FPD]
  connect_bd_intf_net -intf_net vcu_dec_10_axi [get_bd_intf_pins vcu_0/M_AXI_DEC1] [get_bd_intf_pins vcu_dec1_reg_slice/S_AXI]
  connect_bd_intf_net -intf_net vcu_dec_11_axi [get_bd_intf_pins vcu_dec1_reg_slice/M_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP3_FPD]
  connect_bd_intf_net -intf_net vcu_enc_00_axi [get_bd_intf_pins vcu_0/M_AXI_ENC0] [get_bd_intf_pins vcu_enc0_reg_slice/S_AXI]
  connect_bd_intf_net -intf_net vcu_enc_01_axi [get_bd_intf_pins vcu_enc0_reg_slice/M_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP0_FPD]
  connect_bd_intf_net -intf_net vcu_enc_10_axi [get_bd_intf_pins vcu_0/M_AXI_ENC1] [get_bd_intf_pins vcu_enc1_reg_slice/S_AXI]
  connect_bd_intf_net -intf_net vcu_enc_11_axi [get_bd_intf_pins vcu_enc1_reg_slice/M_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP1_FPD]
  connect_bd_intf_net -intf_net vcu_mcu_axi [get_bd_intf_pins vcu_0/M_AXI_MCU] [get_bd_intf_pins vcu_mcu_reg_slice/S_AXI]
  connect_bd_intf_net -intf_net vcu_mcu_axi_1 [get_bd_intf_pins vcu_mcu_reg_slice/M_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HPC0_FPD]

  # Create port connections
  connect_bd_net -net axi_lite_reset_10 [get_bd_pins proc_sys_reset_vcu_0/interconnect_aresetn] [get_bd_pins v_smpte_uhdsdi_tx_ss_0/s_axi_arstn] [get_bd_pins vcu_0/vcu_resetn] [get_bd_pins vcu_axi_lite_0/ARESETN] [get_bd_pins vcu_axi_lite_0/M00_ARESETN] [get_bd_pins vcu_axi_lite_0/S00_ARESETN]
  connect_bd_net -net clk_wiz_clk_out1 [get_bd_pins clk_wiz/clk_out1] [get_bd_pins v_smpte_uhdsdi_rx_ss_0/sdi_rx_clk] [get_bd_pins v_smpte_uhdsdi_rx_ss_0/video_out_clk] [get_bd_pins v_smpte_uhdsdi_tx_ss_0/sdi_tx_clk] [get_bd_pins v_smpte_uhdsdi_tx_ss_0/video_in_clk]
  connect_bd_net -net pl_clk01 [get_bd_pins clk_wiz/clk_in1] [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins clk_wiz_1/clk_in1] [get_bd_pins clk_wiz_2/clk_in1] [get_bd_pins clk_wiz_3/clk_in1] [get_bd_pins clk_wiz_4/clk_in1] [get_bd_pins gig_ethernet_pcs_pma_0/independent_clock_bufg] [get_bd_pins proc_sys_reset_vcu_0/slowest_sync_clk] [get_bd_pins v_smpte_uhdsdi_rx_ss_0/s_axi_aclk] [get_bd_pins v_smpte_uhdsdi_tx_ss_0/s_axi_aclk] [get_bd_pins vcu_0/s_axi_lite_aclk] [get_bd_pins vcu_axi_lite_0/ACLK] [get_bd_pins vcu_axi_lite_0/M00_ACLK] [get_bd_pins vcu_axi_lite_0/M01_ACLK] [get_bd_pins vcu_axi_lite_0/M02_ACLK] [get_bd_pins vcu_axi_lite_0/M03_ACLK] [get_bd_pins vcu_axi_lite_0/S00_ACLK] [get_bd_pins vcu_clk_wiz0/clk_in1] [get_bd_pins vcu_clk_wiz0/s_axi_aclk] [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_lpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
  connect_bd_net -net pl_clk10 [get_bd_pins proc_sys_reset_vcu_1/slowest_sync_clk] [get_bd_pins vcu_0/m_axi_dec_aclk] [get_bd_pins vcu_0/m_axi_enc_aclk] [get_bd_pins vcu_0/m_axi_mcu_aclk] [get_bd_pins vcu_clk_wiz0/clk_out2] [get_bd_pins vcu_dec0_reg_slice/aclk] [get_bd_pins vcu_dec1_reg_slice/aclk] [get_bd_pins vcu_enc0_reg_slice/aclk] [get_bd_pins vcu_enc1_reg_slice/aclk] [get_bd_pins vcu_mcu_reg_slice/aclk] [get_bd_pins zynq_ultra_ps_e_0/saxihp0_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/saxihp1_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/saxihp2_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/saxihp3_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/saxihpc0_fpd_aclk]
  connect_bd_net -net pl_reset_axi [get_bd_pins proc_sys_reset_vcu_0/ext_reset_in] [get_bd_pins proc_sys_reset_vcu_1/ext_reset_in] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]
  connect_bd_net -net proc_sys_reset_vcu_0_peripheral_aresetn [get_bd_pins proc_sys_reset_vcu_0/peripheral_aresetn] [get_bd_pins v_smpte_uhdsdi_rx_ss_0/s_axi_arstn] [get_bd_pins vcu_axi_lite_0/M01_ARESETN] [get_bd_pins vcu_axi_lite_0/M02_ARESETN] [get_bd_pins vcu_axi_lite_0/M03_ARESETN] [get_bd_pins vcu_clk_wiz0/s_axi_aresetn]
  connect_bd_net -net reset_rtl_0_0_1 [get_bd_ports reset_rtl_0_0] [get_bd_pins clk_wiz_1/reset]
  connect_bd_net -net reset_rtl_0_0_1_1 [get_bd_ports reset_rtl_0_0_1] [get_bd_pins clk_wiz_2/reset]
  connect_bd_net -net reset_rtl_0_0_1_2_1 [get_bd_ports reset_rtl_0_0_1_2] [get_bd_pins clk_wiz_3/reset]
  connect_bd_net -net reset_rtl_0_0_1_2_3_1 [get_bd_ports reset_rtl_0_0_1_2_3] [get_bd_pins clk_wiz_4/reset]
  connect_bd_net -net reset_rtl_0_0_1_2_3_4_1 [get_bd_ports reset_rtl_0_0_1_2_3_4] [get_bd_pins clk_wiz_0/reset]
  connect_bd_net -net reset_rtl_0_1 [get_bd_ports reset_rtl_0] [get_bd_pins clk_wiz/reset]
  connect_bd_net -net vcu_clk_locked2 [get_bd_pins proc_sys_reset_vcu_0/dcm_locked] [get_bd_pins proc_sys_reset_vcu_1/dcm_locked] [get_bd_pins vcu_clk_wiz0/locked]
  connect_bd_net -net vcu_irq [get_bd_pins vcu_0/vcu_host_interrupt] [get_bd_pins vcu_interrupt/In0]
  connect_bd_net -net vcu_irq_to_ps [get_bd_pins vcu_interrupt/dout] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0]
  connect_bd_net -net vcu_ref_clk [get_bd_pins vcu_0/pll_ref_clk] [get_bd_pins vcu_clk_wiz0/clk_out1]
  connect_bd_net -net vcu_reset_slice4 [get_bd_pins proc_sys_reset_vcu_1/interconnect_aresetn] [get_bd_pins vcu_dec0_reg_slice/aresetn] [get_bd_pins vcu_dec1_reg_slice/aresetn] [get_bd_pins vcu_enc0_reg_slice/aresetn] [get_bd_pins vcu_enc1_reg_slice/aresetn] [get_bd_pins vcu_mcu_reg_slice/aresetn]

  # Create address segments
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces vcu_0/EncData0] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces vcu_0/EncData1] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces vcu_0/DecData0] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces vcu_0/DecData1] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces vcu_0/Code] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC0_DDR_LOW
  create_bd_addr_seg -range 0x00010000 -offset 0x80100000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs v_smpte_uhdsdi_rx_ss_0/S_AXI_CTRL/Reg] SEG_v_smpte_uhdsdi_rx_ss_0_Reg
  create_bd_addr_seg -range 0x00020000 -offset 0x80120000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs v_smpte_uhdsdi_tx_ss_0/S_AXI_CTRL/Reg] SEG_v_smpte_uhdsdi_tx_ss_0_Reg
  create_bd_addr_seg -range 0x00100000 -offset 0x80000000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs vcu_0/S_AXI_LITE/Reg] SEG_vcu_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x80110000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs vcu_clk_wiz0/s_axi_lite/Reg] SEG_vcu_clk_wiz0_Reg


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


