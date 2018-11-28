
################################################################
# This is a generated script based on design: bd_22f3
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
# source bd_22f3_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xczu7ev-fbvb900-1-i
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name bd_22f3

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
  set M_AXIS_CTRL_SB_RX [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_CTRL_SB_RX ]
  set SDI_TS_DET_OUT [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:sdi_native_rtl:2.0 SDI_TS_DET_OUT ]
  set S_AXIS_RX [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_RX ]
  set S_AXIS_STS_SB_RX [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_STS_SB_RX ]
  set S_AXI_CTRL [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_CTRL ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {16} \
   CONFIG.DATA_WIDTH {32} \
   ] $S_AXI_CTRL
  set VIDEO_OUT [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 VIDEO_OUT ]
  set_property -dict [ list \
   CONFIG.LAYERED_METADATA {xilinx.com:interface:datatypes:1.0 {TDATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value xilinx.com:video:G_B_R_444:1.0} bitwidth {attribs {resolve_type automatic dependency {} format long minimum {} maximum {}} value 30} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} array_type {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value rows} size {attribs {resolve_type generated dependency active_rows format long minimum {} maximum {}} value 1} stride {attribs {resolve_type generated dependency active_rows_stride format long minimum {} maximum {}} value 32} datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type automatic dependency {} format long minimum {} maximum {}} value 30} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} array_type {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value cols} size {attribs {resolve_type generated dependency active_cols format long minimum {} maximum {}} value 1} stride {attribs {resolve_type generated dependency active_cols_stride format long minimum {} maximum {}} value 32} datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type automatic dependency {} format long minimum {} maximum {}} value 30} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} struct {field_G {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value G} enabled {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value true} datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type generated dependency video_data_width format long minimum {} maximum {}} value 10} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} integer {signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value true}}}} field_B {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value B} enabled {attribs {resolve_type generated dependency video_comp1_enabled format bool minimum {} maximum {}} value true} datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type generated dependency video_data_width format long minimum {} maximum {}} value 10} bitoffset {attribs {resolve_type generated dependency video_comp1_offset format long minimum {} maximum {}} value 10} integer {signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value true}}}} field_R {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value R} enabled {attribs {resolve_type generated dependency video_comp2_enabled format bool minimum {} maximum {}} value true} datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type generated dependency video_data_width format long minimum {} maximum {}} value 10} bitoffset {attribs {resolve_type generated dependency video_comp2_offset format long minimum {} maximum {}} value 20} integer {signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value true}}}}}}}}}}} TDATA_WIDTH 32}} \
   CONFIG.TDATA_NUM_BYTES {8} \
   ] $VIDEO_OUT

  # Create ports
  set fid [ create_bd_port -dir O fid ]
  set s_axi_aclk [ create_bd_port -dir I -type clk s_axi_aclk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_RESET {s_axi_arstn} \
 ] $s_axi_aclk
  set s_axi_arstn [ create_bd_port -dir I -type rst s_axi_arstn ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $s_axi_arstn
  set sdi_rx_clk [ create_bd_port -dir I -type clk sdi_rx_clk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_RESET {sdi_rx_rst} \
 ] $sdi_rx_clk
  set sdi_rx_irq [ create_bd_port -dir O -type intr sdi_rx_irq ]
  set sdi_rx_rst [ create_bd_port -dir I -type rst sdi_rx_rst ]
  set video_out_arstn [ create_bd_port -dir I -type rst video_out_arstn ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $video_out_arstn
  set video_out_clk [ create_bd_port -dir I -type clk video_out_clk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_RESET {video_out_arstn} \
 ] $video_out_clk

  # Create instance: v_sdi_rx_vid_bridge, and set properties
  set v_sdi_rx_vid_bridge [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_sdi_rx_vid_bridge:2.0 v_sdi_rx_vid_bridge ]
  set_property -dict [ list \
   CONFIG.C_INCLUDE_12G_SDI_BRIDGE {true} \
   CONFIG.C_INCLUDE_3G_SDI_BRIDGE {true} \
   CONFIG.C_PIXELS_PER_CLOCK {2} \
 ] $v_sdi_rx_vid_bridge

  # Create instance: v_smpte_uhdsdi_rx, and set properties
  set v_smpte_uhdsdi_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_smpte_uhdsdi_rx:1.0 v_smpte_uhdsdi_rx ]
  set_property -dict [ list \
   CONFIG.C_ADV_FEATURE {false} \
   CONFIG.C_AXI4LITE_ENABLE {true} \
   CONFIG.C_INCLUDE_RX_EDH_PROCESSOR {true} \
   CONFIG.C_INCLUDE_SDI_BRIDGE {true} \
   CONFIG.C_INCLUDE_VID_OVER_AXI {true} \
   CONFIG.C_LINE_RATE {12G_SDI_8DS} \
 ] $v_smpte_uhdsdi_rx

  # Create instance: v_vid_in_axi4s, and set properties
  set v_vid_in_axi4s [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_vid_in_axi4s:4.0 v_vid_in_axi4s ]
  set_property -dict [ list \
   CONFIG.C_HAS_ASYNC_CLK {1} \
   CONFIG.C_M_AXIS_VIDEO_DATA_WIDTH {10} \
   CONFIG.C_NATIVE_COMPONENT_WIDTH {10} \
   CONFIG.C_PIXELS_PER_CLOCK {2} \
 ] $v_vid_in_axi4s

  # Create interface connections
  connect_bd_intf_net -intf_net S_AXIS_RX_1 [get_bd_intf_ports S_AXIS_RX] [get_bd_intf_pins v_smpte_uhdsdi_rx/S_AXIS_RX]
  connect_bd_intf_net -intf_net S_AXIS_STS_SB_RX_1 [get_bd_intf_ports S_AXIS_STS_SB_RX] [get_bd_intf_pins v_smpte_uhdsdi_rx/S_AXIS_STS_SB_RX]
  connect_bd_intf_net -intf_net S_AXI_CTRL_1 [get_bd_intf_ports S_AXI_CTRL] [get_bd_intf_pins v_smpte_uhdsdi_rx/S_AXI_CTRL]
  connect_bd_intf_net -intf_net v_sdi_rx_vid_bridge_VID_IO_OUT [get_bd_intf_pins v_sdi_rx_vid_bridge/VID_IO_OUT] [get_bd_intf_pins v_vid_in_axi4s/vid_io_in]
  connect_bd_intf_net -intf_net v_smpte_uhdsdi_rx_M_AXIS_CTRL_SB_RX [get_bd_intf_ports M_AXIS_CTRL_SB_RX] [get_bd_intf_pins v_smpte_uhdsdi_rx/M_AXIS_CTRL_SB_RX]
  connect_bd_intf_net -intf_net v_smpte_uhdsdi_rx_SDI_DS_OUT [get_bd_intf_pins v_sdi_rx_vid_bridge/SDI_DS_IN] [get_bd_intf_pins v_smpte_uhdsdi_rx/SDI_DS_OUT]
  connect_bd_intf_net -intf_net v_smpte_uhdsdi_rx_SDI_TS_DET_OUT [get_bd_intf_ports SDI_TS_DET_OUT] [get_bd_intf_pins v_smpte_uhdsdi_rx/SDI_TS_DET_OUT]
  connect_bd_intf_net -intf_net v_vid_in_axi4s_video_out [get_bd_intf_ports VIDEO_OUT] [get_bd_intf_pins v_vid_in_axi4s/video_out]

  # Create port connections
  connect_bd_net -net s_axi_aclk_1 [get_bd_ports s_axi_aclk] [get_bd_pins v_smpte_uhdsdi_rx/s_axi_aclk]
  connect_bd_net -net s_axi_arstn_1 [get_bd_ports s_axi_arstn] [get_bd_pins v_smpte_uhdsdi_rx/s_axi_aresetn]
  connect_bd_net -net sdi_rx_clk_1 [get_bd_ports sdi_rx_clk] [get_bd_pins v_sdi_rx_vid_bridge/clk] [get_bd_pins v_smpte_uhdsdi_rx/rx_clk] [get_bd_pins v_vid_in_axi4s/vid_io_in_clk]
  connect_bd_net -net sdi_rx_rst_1 [get_bd_ports sdi_rx_rst] [get_bd_pins v_sdi_rx_vid_bridge/rst] [get_bd_pins v_smpte_uhdsdi_rx/rx_rst]
  connect_bd_net -net v_sdi_rx_vid_bridge_sdi_rx_bridge_sts [get_bd_pins v_sdi_rx_vid_bridge/sdi_rx_bridge_sts] [get_bd_pins v_smpte_uhdsdi_rx/sdi_rx_bridge_sts]
  connect_bd_net -net v_sdi_rx_vid_bridge_vid_ce [get_bd_pins v_sdi_rx_vid_bridge/vid_ce] [get_bd_pins v_vid_in_axi4s/vid_io_in_ce]
  connect_bd_net -net v_smpte_uhdsdi_rx_interrupt [get_bd_ports sdi_rx_irq] [get_bd_pins v_smpte_uhdsdi_rx/interrupt]
  connect_bd_net -net v_smpte_uhdsdi_rx_sdi_rx_bridge_ctrl [get_bd_pins v_sdi_rx_vid_bridge/sdi_rx_bridge_ctrl] [get_bd_pins v_smpte_uhdsdi_rx/sdi_rx_bridge_ctrl]
  connect_bd_net -net v_smpte_uhdsdi_rx_vid_in_axi4s_axis_enable [get_bd_pins v_smpte_uhdsdi_rx/vid_in_axi4s_axis_enable] [get_bd_pins v_vid_in_axi4s/axis_enable]
  connect_bd_net -net v_smpte_uhdsdi_rx_vid_in_axi4s_axis_rstn [get_bd_pins v_smpte_uhdsdi_rx/vid_in_axi4s_axis_rstn] [get_bd_pins v_vid_in_axi4s/aresetn]
  connect_bd_net -net v_smpte_uhdsdi_rx_vid_in_axi4s_vid_rst [get_bd_pins v_smpte_uhdsdi_rx/vid_in_axi4s_vid_rst] [get_bd_pins v_vid_in_axi4s/vid_io_in_reset]
  connect_bd_net -net v_vid_in_axi4s_fid [get_bd_ports fid] [get_bd_pins v_vid_in_axi4s/fid]
  connect_bd_net -net v_vid_in_axi4s_overflow [get_bd_pins v_smpte_uhdsdi_rx/vid_in_axi4s_overflow] [get_bd_pins v_vid_in_axi4s/overflow]
  connect_bd_net -net v_vid_in_axi4s_underflow [get_bd_pins v_smpte_uhdsdi_rx/vid_in_axi4s_underflow] [get_bd_pins v_vid_in_axi4s/underflow]
  connect_bd_net -net video_out_arstn_1 [get_bd_ports video_out_arstn] [get_bd_pins v_smpte_uhdsdi_rx/axis_rstn]
  connect_bd_net -net video_out_clk_1 [get_bd_ports video_out_clk] [get_bd_pins v_smpte_uhdsdi_rx/axis_clk] [get_bd_pins v_vid_in_axi4s/aclk]

  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x00000000 [get_bd_addr_spaces S_AXI_CTRL] [get_bd_addr_segs v_smpte_uhdsdi_rx/S_AXI_CTRL/Reg] v_smpte_uhdsdi_rx


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


