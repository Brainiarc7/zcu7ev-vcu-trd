
################################################################
# This is a generated script based on design: bd_82d8
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
# source bd_82d8_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xczu7ev-fbvb900-1-i
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name bd_82d8

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

   create_bd_design -bdsource SBD $design_name

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
  set M_AXIS_CTRL_SB_TX [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_CTRL_SB_TX ]
  set M_AXIS_TX [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_TX ]
  set_property -dict [ list \
   CONFIG.TDATA_NUM_BYTES {5} \
   CONFIG.TUSER_WIDTH {32} \
   ] $M_AXIS_TX
  set S_AXIS_STS_SB_TX [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_STS_SB_TX ]
  set S_AXI_CTRL [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_CTRL ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {17} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $S_AXI_CTRL
  set VIDEO_IN [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 VIDEO_IN ]

  # Create ports
  set fid [ create_bd_port -dir I fid ]
  set s_axi_aclk [ create_bd_port -dir I -type clk s_axi_aclk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_RESET {s_axi_arstn} \
 ] $s_axi_aclk
  set s_axi_arstn [ create_bd_port -dir I -type rst s_axi_arstn ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $s_axi_arstn
  set sdi_tx_clk [ create_bd_port -dir I -type clk sdi_tx_clk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_RESET {sdi_tx_rst} \
 ] $sdi_tx_clk
  set sdi_tx_irq [ create_bd_port -dir O -type intr sdi_tx_irq ]
  set sdi_tx_rst [ create_bd_port -dir I -type rst sdi_tx_rst ]
  set video_in_arstn [ create_bd_port -dir I -type rst video_in_arstn ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $video_in_arstn
  set video_in_clk [ create_bd_port -dir I -type clk video_in_clk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_RESET {video_in_arstn} \
 ] $video_in_clk
  set vtc_irq [ create_bd_port -dir O -type intr vtc_irq ]

  # Create instance: axi_crossbar, and set properties
  set axi_crossbar [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_crossbar:2.1 axi_crossbar ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {17} \
   CONFIG.CONNECTIVITY_MODE {SASD} \
   CONFIG.M00_A00_ADDR_WIDTH {16} \
   CONFIG.M00_A00_BASE_ADDR {0x0000000000010000} \
   CONFIG.M01_A00_ADDR_WIDTH {16} \
   CONFIG.M01_A00_BASE_ADDR {0x0000000000000000} \
   CONFIG.PROTOCOL {AXI4LITE} \
   CONFIG.R_REGISTER {1} \
   CONFIG.S00_SINGLE_THREAD {1} \
 ] $axi_crossbar

  # Create instance: const_1, and set properties
  set const_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_1 ]

  # Create instance: v_axi4s_vid_out, and set properties
  set v_axi4s_vid_out [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_axi4s_vid_out:4.0 v_axi4s_vid_out ]
  set_property -dict [ list \
   CONFIG.C_HAS_ASYNC_CLK {1} \
   CONFIG.C_NATIVE_COMPONENT_WIDTH {10} \
   CONFIG.C_PIXELS_PER_CLOCK {2} \
   CONFIG.C_S_AXIS_VIDEO_DATA_WIDTH {10} \
 ] $v_axi4s_vid_out

  # Create instance: v_smpte_uhdsdi_tx, and set properties
  set v_smpte_uhdsdi_tx [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_smpte_uhdsdi_tx:1.0 v_smpte_uhdsdi_tx ]
  set_property -dict [ list \
   CONFIG.C_ADV_FEATURE {false} \
   CONFIG.C_AXI4LITE_ENABLE {true} \
   CONFIG.C_INCLUDE_SDI_BRIDGE {true} \
   CONFIG.C_INCLUDE_TX_EDH_PROCESSOR {true} \
   CONFIG.C_INCLUDE_VID_OVER_AXI {true} \
   CONFIG.C_LINE_RATE {12G_SDI_8DS} \
 ] $v_smpte_uhdsdi_tx

  # Create instance: v_tc, and set properties
  set v_tc [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_tc:6.1 v_tc ]
  set_property -dict [ list \
   CONFIG.GEN_FIELDID_EN {true} \
   CONFIG.GEN_INTERLACED {true} \
   CONFIG.INTERLACE_EN {true} \
   CONFIG.VIDEO_MODE {Custom} \
   CONFIG.enable_detection {false} \
 ] $v_tc

  # Create instance: v_vid_sdi_tx_bridge, and set properties
  set v_vid_sdi_tx_bridge [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_vid_sdi_tx_bridge:2.0 v_vid_sdi_tx_bridge ]
  set_property -dict [ list \
   CONFIG.C_ADV_FEATURE {false} \
   CONFIG.C_INCLUDE_12G_SDI_BRIDGE {true} \
   CONFIG.C_INCLUDE_3G_SDI_BRIDGE {true} \
   CONFIG.C_PIXELS_PER_CLOCK {2} \
 ] $v_vid_sdi_tx_bridge

  # Create interface connections
  connect_bd_intf_net -intf_net S_AXIS_STS_SB_TX_1 [get_bd_intf_ports S_AXIS_STS_SB_TX] [get_bd_intf_pins v_smpte_uhdsdi_tx/S_AXIS_STS_SB_TX]
  connect_bd_intf_net -intf_net S_AXI_CTRL_1 [get_bd_intf_ports S_AXI_CTRL] [get_bd_intf_pins axi_crossbar/S00_AXI]
  connect_bd_intf_net -intf_net VIDEO_IN_1 [get_bd_intf_ports VIDEO_IN] [get_bd_intf_pins v_axi4s_vid_out/video_in]
  connect_bd_intf_net -intf_net axi_crossbar_M00_AXI [get_bd_intf_pins axi_crossbar/M00_AXI] [get_bd_intf_pins v_tc/ctrl]
  connect_bd_intf_net -intf_net axi_crossbar_M01_AXI [get_bd_intf_pins axi_crossbar/M01_AXI] [get_bd_intf_pins v_smpte_uhdsdi_tx/S_AXI_CTRL]
  connect_bd_intf_net -intf_net v_axi4s_vid_out_vid_io_out [get_bd_intf_pins v_axi4s_vid_out/vid_io_out] [get_bd_intf_pins v_vid_sdi_tx_bridge/VID_IO_IN]
  connect_bd_intf_net -intf_net v_smpte_uhdsdi_tx_M_AXIS_CTRL_SB_TX [get_bd_intf_ports M_AXIS_CTRL_SB_TX] [get_bd_intf_pins v_smpte_uhdsdi_tx/M_AXIS_CTRL_SB_TX]
  connect_bd_intf_net -intf_net v_smpte_uhdsdi_tx_M_AXIS_TX [get_bd_intf_ports M_AXIS_TX] [get_bd_intf_pins v_smpte_uhdsdi_tx/M_AXIS_TX]
  connect_bd_intf_net -intf_net v_tc_vtiming_out [get_bd_intf_pins v_axi4s_vid_out/vtiming_in] [get_bd_intf_pins v_tc/vtiming_out]
  connect_bd_intf_net -intf_net v_vid_sdi_tx_bridge_SDI_DS_OUT [get_bd_intf_pins v_smpte_uhdsdi_tx/SDI_DS_IN] [get_bd_intf_pins v_vid_sdi_tx_bridge/SDI_DS_OUT]

  # Create port connections
  connect_bd_net -net const_1_dout [get_bd_pins const_1/dout] [get_bd_pins v_tc/resetn]
  connect_bd_net -net fid_1 [get_bd_ports fid] [get_bd_pins v_axi4s_vid_out/fid]
  connect_bd_net -net s_axi_aclk_1 [get_bd_ports s_axi_aclk] [get_bd_pins axi_crossbar/aclk] [get_bd_pins v_smpte_uhdsdi_tx/s_axi_aclk] [get_bd_pins v_tc/s_axi_aclk]
  connect_bd_net -net s_axi_arstn_1 [get_bd_ports s_axi_arstn] [get_bd_pins axi_crossbar/aresetn] [get_bd_pins v_smpte_uhdsdi_tx/s_axi_aresetn] [get_bd_pins v_tc/s_axi_aresetn]
  connect_bd_net -net sdi_tx_clk_1 [get_bd_ports sdi_tx_clk] [get_bd_pins v_axi4s_vid_out/vid_io_out_clk] [get_bd_pins v_smpte_uhdsdi_tx/tx_clk] [get_bd_pins v_tc/clk] [get_bd_pins v_vid_sdi_tx_bridge/clk]
  connect_bd_net -net sdi_tx_rst_1 [get_bd_ports sdi_tx_rst] [get_bd_pins v_smpte_uhdsdi_tx/tx_rst] [get_bd_pins v_vid_sdi_tx_bridge/rst]
  connect_bd_net -net v_axi4s_vid_out_locked [get_bd_pins v_axi4s_vid_out/locked] [get_bd_pins v_smpte_uhdsdi_tx/axi4s_vid_out_locked]
  connect_bd_net -net v_axi4s_vid_out_overflow [get_bd_pins v_axi4s_vid_out/overflow] [get_bd_pins v_smpte_uhdsdi_tx/axi4s_vid_out_overflow]
  connect_bd_net -net v_axi4s_vid_out_status [get_bd_pins v_axi4s_vid_out/status] [get_bd_pins v_smpte_uhdsdi_tx/axi4s_vid_out_status]
  connect_bd_net -net v_axi4s_vid_out_underflow [get_bd_pins v_axi4s_vid_out/underflow] [get_bd_pins v_smpte_uhdsdi_tx/axi4s_vid_out_underflow]
  connect_bd_net -net v_axi4s_vid_out_vtg_ce [get_bd_pins v_axi4s_vid_out/vtg_ce] [get_bd_pins v_tc/gen_clken]
  connect_bd_net -net v_smpte_uhdsdi_tx_axi4s_vid_out_axis_rstn [get_bd_pins v_axi4s_vid_out/aresetn] [get_bd_pins v_smpte_uhdsdi_tx/axi4s_vid_out_axis_rstn]
  connect_bd_net -net v_smpte_uhdsdi_tx_axi4s_vid_out_vid_rst [get_bd_pins v_axi4s_vid_out/vid_io_out_reset] [get_bd_pins v_smpte_uhdsdi_tx/axi4s_vid_out_vid_rst]
  connect_bd_net -net v_smpte_uhdsdi_tx_interrupt [get_bd_ports sdi_tx_irq] [get_bd_pins v_smpte_uhdsdi_tx/interrupt]
  connect_bd_net -net v_smpte_uhdsdi_tx_sdi_tx_bridge_ctrl [get_bd_pins v_smpte_uhdsdi_tx/sdi_tx_bridge_ctrl] [get_bd_pins v_vid_sdi_tx_bridge/sdi_tx_bridge_ctrl]
  connect_bd_net -net v_tc_irq [get_bd_ports vtc_irq] [get_bd_pins v_tc/irq]
  connect_bd_net -net v_vid_sdi_tx_bridge_sdi_tx_bridge_sts [get_bd_pins v_smpte_uhdsdi_tx/sdi_tx_bridge_sts] [get_bd_pins v_vid_sdi_tx_bridge/sdi_tx_bridge_sts]
  connect_bd_net -net v_vid_sdi_tx_bridge_vid_ce [get_bd_pins v_axi4s_vid_out/vid_io_out_ce] [get_bd_pins v_vid_sdi_tx_bridge/vid_ce]
  connect_bd_net -net video_in_arstn_1 [get_bd_ports video_in_arstn] [get_bd_pins v_smpte_uhdsdi_tx/axis_rstn]
  connect_bd_net -net video_in_clk_1 [get_bd_ports video_in_clk] [get_bd_pins v_axi4s_vid_out/aclk] [get_bd_pins v_smpte_uhdsdi_tx/axis_clk]

  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x00000000 [get_bd_addr_spaces S_AXI_CTRL] [get_bd_addr_segs v_smpte_uhdsdi_tx/S_AXI_CTRL/Reg] v_smpte_uhdsdi_tx
  create_bd_addr_seg -range 0x00010000 -offset 0x00010000 [get_bd_addr_spaces S_AXI_CTRL] [get_bd_addr_segs v_tc/ctrl/Reg] v_tc


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


