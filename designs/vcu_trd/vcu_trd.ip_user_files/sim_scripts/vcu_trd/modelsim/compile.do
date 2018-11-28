vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xilinx_vip
vlib modelsim_lib/msim/xil_defaultlib
vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/lib_cdc_v1_0_2
vlib modelsim_lib/msim/proc_sys_reset_v5_0_12
vlib modelsim_lib/msim/axi_infrastructure_v1_1_0
vlib modelsim_lib/msim/axi_register_slice_v2_1_17
vlib modelsim_lib/msim/smartconnect_v1_0
vlib modelsim_lib/msim/axi_protocol_checker_v2_0_3
vlib modelsim_lib/msim/axi_vip_v1_1_3
vlib modelsim_lib/msim/zynq_ultra_ps_e_vip_v1_0_3
vlib modelsim_lib/msim/xlconcat_v2_1_1
vlib modelsim_lib/msim/gtwizard_ultrascale_v1_7_4
vlib modelsim_lib/msim/gig_ethernet_pcs_pma_v16_1_4
vlib modelsim_lib/msim/v_smpte_uhdsdi_rx_v1_0_0
vlib modelsim_lib/msim/v_sdi_rx_vid_bridge_v2_0_0
vlib modelsim_lib/msim/v_vid_in_axi4s_v4_0_8
vlib modelsim_lib/msim/generic_baseblocks_v2_1_0
vlib modelsim_lib/msim/fifo_generator_v13_2_2
vlib modelsim_lib/msim/axi_data_fifo_v2_1_16
vlib modelsim_lib/msim/axi_crossbar_v2_1_18
vlib modelsim_lib/msim/v_smpte_uhdsdi_tx_v1_0_0
vlib modelsim_lib/msim/v_vid_sdi_tx_bridge_v2_0_0
vlib modelsim_lib/msim/axi_lite_ipif_v3_0_4
vlib modelsim_lib/msim/v_tc_v6_1_12
vlib modelsim_lib/msim/v_axi4s_vid_out_v4_0_9
vlib modelsim_lib/msim/xlconstant_v1_1_5
vlib modelsim_lib/msim/axi_protocol_converter_v2_1_17

vmap xilinx_vip modelsim_lib/msim/xilinx_vip
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib
vmap xpm modelsim_lib/msim/xpm
vmap lib_cdc_v1_0_2 modelsim_lib/msim/lib_cdc_v1_0_2
vmap proc_sys_reset_v5_0_12 modelsim_lib/msim/proc_sys_reset_v5_0_12
vmap axi_infrastructure_v1_1_0 modelsim_lib/msim/axi_infrastructure_v1_1_0
vmap axi_register_slice_v2_1_17 modelsim_lib/msim/axi_register_slice_v2_1_17
vmap smartconnect_v1_0 modelsim_lib/msim/smartconnect_v1_0
vmap axi_protocol_checker_v2_0_3 modelsim_lib/msim/axi_protocol_checker_v2_0_3
vmap axi_vip_v1_1_3 modelsim_lib/msim/axi_vip_v1_1_3
vmap zynq_ultra_ps_e_vip_v1_0_3 modelsim_lib/msim/zynq_ultra_ps_e_vip_v1_0_3
vmap xlconcat_v2_1_1 modelsim_lib/msim/xlconcat_v2_1_1
vmap gtwizard_ultrascale_v1_7_4 modelsim_lib/msim/gtwizard_ultrascale_v1_7_4
vmap gig_ethernet_pcs_pma_v16_1_4 modelsim_lib/msim/gig_ethernet_pcs_pma_v16_1_4
vmap v_smpte_uhdsdi_rx_v1_0_0 modelsim_lib/msim/v_smpte_uhdsdi_rx_v1_0_0
vmap v_sdi_rx_vid_bridge_v2_0_0 modelsim_lib/msim/v_sdi_rx_vid_bridge_v2_0_0
vmap v_vid_in_axi4s_v4_0_8 modelsim_lib/msim/v_vid_in_axi4s_v4_0_8
vmap generic_baseblocks_v2_1_0 modelsim_lib/msim/generic_baseblocks_v2_1_0
vmap fifo_generator_v13_2_2 modelsim_lib/msim/fifo_generator_v13_2_2
vmap axi_data_fifo_v2_1_16 modelsim_lib/msim/axi_data_fifo_v2_1_16
vmap axi_crossbar_v2_1_18 modelsim_lib/msim/axi_crossbar_v2_1_18
vmap v_smpte_uhdsdi_tx_v1_0_0 modelsim_lib/msim/v_smpte_uhdsdi_tx_v1_0_0
vmap v_vid_sdi_tx_bridge_v2_0_0 modelsim_lib/msim/v_vid_sdi_tx_bridge_v2_0_0
vmap axi_lite_ipif_v3_0_4 modelsim_lib/msim/axi_lite_ipif_v3_0_4
vmap v_tc_v6_1_12 modelsim_lib/msim/v_tc_v6_1_12
vmap v_axi4s_vid_out_v4_0_9 modelsim_lib/msim/v_axi4s_vid_out_v4_0_9
vmap xlconstant_v1_1_5 modelsim_lib/msim/xlconstant_v1_1_5
vmap axi_protocol_converter_v2_1_17 modelsim_lib/msim/axi_protocol_converter_v2_1_17

vlog -work xilinx_vip -64 -incr -sv -L smartconnect_v1_0 -L axi_protocol_checker_v2_0_3 -L axi_vip_v1_1_3 -L zynq_ultra_ps_e_vip_v1_0_3 -L xilinx_vip "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xil_defaultlib -64 -incr -sv -L smartconnect_v1_0 -L axi_protocol_checker_v2_0_3 -L axi_vip_v1_1_3 -L zynq_ultra_ps_e_vip_v1_0_3 -L xilinx_vip "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"/opt/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"/opt/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"/opt/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"/opt/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/sim/vcu_trd.v" \

vcom -work lib_cdc_v1_0_2 -64 -93 \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work proc_sys_reset_v5_0_12 -64 -93 \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/f86a/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_proc_sys_reset_vcu_0_1/sim/vcu_trd_proc_sys_reset_vcu_0_1.vhd" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_proc_sys_reset_vcu_1_1/sim/vcu_trd_proc_sys_reset_vcu_1_1.vhd" \

vlog -work axi_infrastructure_v1_1_0 -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_register_slice_v2_1_17 -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/6020/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_vcu_enc0_reg_slice_1/sim/vcu_trd_vcu_enc0_reg_slice_1.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_vcu_enc1_reg_slice_1/sim/vcu_trd_vcu_enc1_reg_slice_1.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_vcu_dec0_reg_slice_1/sim/vcu_trd_vcu_dec0_reg_slice_1.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_vcu_dec1_reg_slice_1/sim/vcu_trd_vcu_dec1_reg_slice_1.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_vcu_mcu_reg_slice_1/sim/vcu_trd_vcu_mcu_reg_slice_1.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_vcu_clk_wiz0_1/vcu_trd_vcu_clk_wiz0_1_clk_wiz.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_vcu_clk_wiz0_1/vcu_trd_vcu_clk_wiz0_1.v" \

vlog -work smartconnect_v1_0 -64 -incr -sv -L smartconnect_v1_0 -L axi_protocol_checker_v2_0_3 -L axi_vip_v1_1_3 -L zynq_ultra_ps_e_vip_v1_0_3 -L xilinx_vip "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/sc_util_v1_0_vl_rfs.sv" \

vlog -work axi_protocol_checker_v2_0_3 -64 -incr -sv -L smartconnect_v1_0 -L axi_protocol_checker_v2_0_3 -L axi_vip_v1_1_3 -L zynq_ultra_ps_e_vip_v1_0_3 -L xilinx_vip "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/03a9/hdl/axi_protocol_checker_v2_0_vl_rfs.sv" \

vlog -work axi_vip_v1_1_3 -64 -incr -sv -L smartconnect_v1_0 -L axi_protocol_checker_v2_0_3 -L axi_vip_v1_1_3 -L zynq_ultra_ps_e_vip_v1_0_3 -L xilinx_vip "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b9a8/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work zynq_ultra_ps_e_vip_v1_0_3 -64 -incr -sv -L smartconnect_v1_0 -L axi_protocol_checker_v2_0_3 -L axi_vip_v1_1_3 -L zynq_ultra_ps_e_vip_v1_0_3 -L xilinx_vip "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl/zynq_ultra_ps_e_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_zynq_ultra_ps_e_0_1/sim/vcu_trd_zynq_ultra_ps_e_0_1_vip_wrapper.v" \

vlog -work xlconcat_v2_1_1 -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/2f66/hdl/xlconcat_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_vcu_interrupt_1/sim/vcu_trd_vcu_interrupt_1.v" \

vlog -work gtwizard_ultrascale_v1_7_4 -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/2223/hdl/gtwizard_ultrascale_v1_7_bit_sync.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/2223/hdl/gtwizard_ultrascale_v1_7_gte4_drp_arb.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/2223/hdl/gtwizard_ultrascale_v1_7_gthe4_delay_powergood.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/2223/hdl/gtwizard_ultrascale_v1_7_gtye4_delay_powergood.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/2223/hdl/gtwizard_ultrascale_v1_7_gthe3_cpll_cal.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/2223/hdl/gtwizard_ultrascale_v1_7_gthe3_cal_freqcnt.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/2223/hdl/gtwizard_ultrascale_v1_7_gthe4_cpll_cal.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/2223/hdl/gtwizard_ultrascale_v1_7_gthe4_cpll_cal_rx.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/2223/hdl/gtwizard_ultrascale_v1_7_gthe4_cpll_cal_tx.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/2223/hdl/gtwizard_ultrascale_v1_7_gthe4_cal_freqcnt.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/2223/hdl/gtwizard_ultrascale_v1_7_gtye4_cpll_cal.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/2223/hdl/gtwizard_ultrascale_v1_7_gtye4_cpll_cal_rx.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/2223/hdl/gtwizard_ultrascale_v1_7_gtye4_cpll_cal_tx.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/2223/hdl/gtwizard_ultrascale_v1_7_gtye4_cal_freqcnt.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/2223/hdl/gtwizard_ultrascale_v1_7_gtwiz_buffbypass_rx.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/2223/hdl/gtwizard_ultrascale_v1_7_gtwiz_buffbypass_tx.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/2223/hdl/gtwizard_ultrascale_v1_7_gtwiz_reset.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/2223/hdl/gtwizard_ultrascale_v1_7_gtwiz_userclk_rx.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/2223/hdl/gtwizard_ultrascale_v1_7_gtwiz_userclk_tx.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/2223/hdl/gtwizard_ultrascale_v1_7_gtwiz_userdata_rx.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/2223/hdl/gtwizard_ultrascale_v1_7_gtwiz_userdata_tx.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/2223/hdl/gtwizard_ultrascale_v1_7_reset_sync.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/2223/hdl/gtwizard_ultrascale_v1_7_reset_inv_sync.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_gig_ethernet_pcs_pma_0_1/ip_0/sim/gtwizard_ultrascale_v1_7_gthe4_channel.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_gig_ethernet_pcs_pma_0_1/ip_0/sim/vcu_trd_gig_ethernet_pcs_pma_0_1_gt_gthe4_channel_wrapper.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_gig_ethernet_pcs_pma_0_1/ip_0/sim/vcu_trd_gig_ethernet_pcs_pma_0_1_gt_gtwizard_gthe4.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_gig_ethernet_pcs_pma_0_1/ip_0/sim/vcu_trd_gig_ethernet_pcs_pma_0_1_gt_gtwizard_top.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_gig_ethernet_pcs_pma_0_1/ip_0/sim/vcu_trd_gig_ethernet_pcs_pma_0_1_gt.v" \

vcom -work gig_ethernet_pcs_pma_v16_1_4 -64 -93 \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/494d/hdl/gig_ethernet_pcs_pma_v16_1_rfs.vhd" \

vlog -work gig_ethernet_pcs_pma_v16_1_4 -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/494d/hdl/gig_ethernet_pcs_pma_v16_1_rfs.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_gig_ethernet_pcs_pma_0_1/synth/vcu_trd_gig_ethernet_pcs_pma_0_1_resets.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_gig_ethernet_pcs_pma_0_1/synth/vcu_trd_gig_ethernet_pcs_pma_0_1_clocking.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_gig_ethernet_pcs_pma_0_1/synth/vcu_trd_gig_ethernet_pcs_pma_0_1_support.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_gig_ethernet_pcs_pma_0_1/synth/sgmii_adapt/vcu_trd_gig_ethernet_pcs_pma_0_1_clk_gen.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_gig_ethernet_pcs_pma_0_1/synth/sgmii_adapt/vcu_trd_gig_ethernet_pcs_pma_0_1_johnson_cntr.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_gig_ethernet_pcs_pma_0_1/synth/vcu_trd_gig_ethernet_pcs_pma_0_1_reset_sync.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_gig_ethernet_pcs_pma_0_1/synth/transceiver/vcu_trd_gig_ethernet_pcs_pma_0_1_rx_elastic_buffer.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_gig_ethernet_pcs_pma_0_1/synth/sgmii_adapt/vcu_trd_gig_ethernet_pcs_pma_0_1_rx_rate_adapt.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_gig_ethernet_pcs_pma_0_1/synth/sgmii_adapt/vcu_trd_gig_ethernet_pcs_pma_0_1_sgmii_adapt.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_gig_ethernet_pcs_pma_0_1/synth/vcu_trd_gig_ethernet_pcs_pma_0_1_sync_block.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_gig_ethernet_pcs_pma_0_1/synth/transceiver/vcu_trd_gig_ethernet_pcs_pma_0_1_transceiver.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_gig_ethernet_pcs_pma_0_1/synth/sgmii_adapt/vcu_trd_gig_ethernet_pcs_pma_0_1_tx_rate_adapt.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_gig_ethernet_pcs_pma_0_1/synth/vcu_trd_gig_ethernet_pcs_pma_0_1_block.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_gig_ethernet_pcs_pma_0_1/synth/vcu_trd_gig_ethernet_pcs_pma_0_1.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_clk_wiz_1/vcu_trd_clk_wiz_1_clk_wiz.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_clk_wiz_1/vcu_trd_clk_wiz_1.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_clk_wiz_1_1/vcu_trd_clk_wiz_1_1_clk_wiz.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_clk_wiz_1_1/vcu_trd_clk_wiz_1_1.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_clk_wiz_2_1/vcu_trd_clk_wiz_2_1_clk_wiz.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_clk_wiz_2_1/vcu_trd_clk_wiz_2_1.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_clk_wiz_3_1/vcu_trd_clk_wiz_3_1_clk_wiz.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_clk_wiz_3_1/vcu_trd_clk_wiz_3_1.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_clk_wiz_4_1/vcu_trd_clk_wiz_4_1_clk_wiz.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_clk_wiz_4_1/vcu_trd_clk_wiz_4_1.v" \

vlog -work v_smpte_uhdsdi_rx_v1_0_0 -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/v_smpte_uhdsdi_rx_v1_0_edh_fly_horz.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/v_smpte_uhdsdi_rx_v1_0_decoder.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/v_smpte_uhdsdi_rx_v1_0_framer.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/v_smpte_uhdsdi_rx_v1_0_edh_errcnt.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/v_smpte_uhdsdi_rx_v1_0_st352_pid_capture.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/v_smpte_uhdsdi_rx_v1_0_edh_crc.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/v_smpte_uhdsdi_rx_v1_0_edh_autodetect.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/v_smpte_uhdsdi_rx_v1_0_demux_4.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/v_smpte_uhdsdi_rx_v1_0_edh_flags.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/v_smpte_uhdsdi_rx_v1_0_trs_restore.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/v_smpte_uhdsdi_rx_v1_0_edh_video_decode.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/v_smpte_uhdsdi_rx_v1_0_edh_processor.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/v_smpte_uhdsdi_rx_v1_0_edh_rx.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/v_smpte_uhdsdi_rx_v1_0_edh_tx.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/v_smpte_uhdsdi_rx_v1_0_autorate.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/v_smpte_uhdsdi_rx_v1_0_edh_loc.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/v_smpte_uhdsdi_rx_v1_0_edh_fly_fsm.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/v_smpte_uhdsdi_rx_v1_0_edh_fly_field.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/v_smpte_uhdsdi_rx_v1_0_edh_crc16.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/v_smpte_uhdsdi_rx_v1_0_transport_detect.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/v_smpte_uhdsdi_rx_v1_0_edh_anc_rx.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/v_smpte_uhdsdi_rx_v1_0_edh_flywheel.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/v_smpte_uhdsdi_rx_v1_0_edh_fly_vert.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/v_smpte_uhdsdi_rx_v1_0_to_demux.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/v_smpte_uhdsdi_rx_v1_0_crc.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/v_smpte_uhdsdi_rx_v1_0_crc2.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/v_smpte_uhdsdi_rx_v1_0_edh_trs_detect.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/v_smpte_uhdsdi_rx_v1_0_s00_axi.v" \

vcom -work v_smpte_uhdsdi_rx_v1_0_0 -64 -93 \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/cross_clk_reg.vhd" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/cross_clk_bus.vhd" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/map_pulse.vhd" \

vlog -work v_smpte_uhdsdi_rx_v1_0_0 -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/v_smpte_uhdsdi_rx_v1_0_rx.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/bbc9/hdl/v_smpte_uhdsdi_rx_v1_0_top.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_v_smpte_uhdsdi_rx_ss_0_0/bd_0/ip/ip_0/sim/bd_22f3_v_smpte_uhdsdi_rx_0.v" \

vlog -work v_sdi_rx_vid_bridge_v2_0_0 -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/c648/hdl/verilog/v_sdi_rx_vid_bridge_v2_0_lib.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/c648/hdl/verilog/v_sdi_rx_vid_bridge_v2_0_12g_ce_gen.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/c648/hdl/verilog/v_sdi_rx_vid_bridge_v2_0_12g_converter.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/c648/hdl/verilog/v_sdi_rx_vid_bridge_v2_0_12g_fifo.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/c648/hdl/verilog/v_sdi_rx_vid_bridge_v2_0_12g_formatter.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/c648/hdl/verilog/v_sdi_rx_vid_bridge_v2_0_12g_trs_decode.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/c648/hdl/verilog/v_sdi_rx_vid_bridge_v2_0_12g.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/c648/hdl/verilog/v_sdi_rx_vid_bridge_v2_0_3g_ce_gen.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/c648/hdl/verilog/v_sdi_rx_vid_bridge_v2_0_3g_converter.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/c648/hdl/verilog/v_sdi_rx_vid_bridge_v2_0_3g_fifo.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/c648/hdl/verilog/v_sdi_rx_vid_bridge_v2_0_3g_formatter.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/c648/hdl/verilog/v_sdi_rx_vid_bridge_v2_0_3g_sync_extract.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/c648/hdl/verilog/v_sdi_rx_vid_bridge_v2_0_3g_trs_decode.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/c648/hdl/verilog/v_sdi_rx_vid_bridge_v2_0_3g.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/c648/hdl/verilog/v_sdi_rx_vid_bridge_v2_0.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_v_smpte_uhdsdi_rx_ss_0_0/bd_0/ip/ip_1/sim/bd_22f3_v_sdi_rx_vid_bridge_0.v" \

vlog -work v_vid_in_axi4s_v4_0_8 -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/d987/hdl/v_vid_in_axi4s_v4_0_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_v_smpte_uhdsdi_rx_ss_0_0/bd_0/ip/ip_2/sim/bd_22f3_v_vid_in_axi4s_0.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_v_smpte_uhdsdi_rx_ss_0_0/bd_0/sim/bd_22f3.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_v_smpte_uhdsdi_rx_ss_0_0/sim/vcu_trd_v_smpte_uhdsdi_rx_ss_0_0.v" \

vlog -work generic_baseblocks_v2_1_0 -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \

vlog -work fifo_generator_v13_2_2 -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/7aff/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_2 -64 -93 \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/7aff/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_2 -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/7aff/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work axi_data_fifo_v2_1_16 -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/247d/hdl/axi_data_fifo_v2_1_vl_rfs.v" \

vlog -work axi_crossbar_v2_1_18 -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/15a3/hdl/axi_crossbar_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_v_smpte_uhdsdi_tx_ss_0_0/bd_0/ip/ip_0/sim/bd_82d8_axi_crossbar_0.v" \

vlog -work v_smpte_uhdsdi_tx_v1_0_0 -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_edh_anc_rx.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_edh_flags.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_edh_loc.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_edh_processor.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_mux.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_bitrep_20b.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_edh_video_decode.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_edh_autodetect.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_edh_tx.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_edh_rx.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_channel.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_output.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_syncbit_insert.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_trsgen.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_crc2.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_insert_crc.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_scrambler.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_edh_crc16.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_st352_pid_insert.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_edh_trs_detect.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_edh_fly_horz.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_insert_ln.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_edh_fly_fsm.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_s00_axi.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_edh_errcnt.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_edh_crc.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_edh_flywheel.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_encoder.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_edh_fly_vert.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_edh_fly_field.v" \

vcom -work v_smpte_uhdsdi_tx_v1_0_0 -64 -93 \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/cross_clk_reg.vhd" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/cross_clk_bus.vhd" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/map_pulse.vhd" \

vlog -work v_smpte_uhdsdi_tx_v1_0_0 -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_tx.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/8b05/hdl/v_smpte_uhdsdi_tx_v1_0_top.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_v_smpte_uhdsdi_tx_ss_0_0/bd_0/ip/ip_1/sim/bd_82d8_v_smpte_uhdsdi_tx_0.v" \

vlog -work v_vid_sdi_tx_bridge_v2_0_0 -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/108c/hdl/verilog/v_vid_sdi_tx_bridge_v2_0_lib.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/108c/hdl/verilog/v_vid_sdi_tx_bridge_v2_0_12g_ce_gen.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/108c/hdl/verilog/v_vid_sdi_tx_bridge_v2_0_12g_clamp.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/108c/hdl/verilog/v_vid_sdi_tx_bridge_v2_0_12g_converter.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/108c/hdl/verilog/v_vid_sdi_tx_bridge_v2_0_12g_embedder.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/108c/hdl/verilog/v_vid_sdi_tx_bridge_v2_0_12g_fifo.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/108c/hdl/verilog/v_vid_sdi_tx_bridge_v2_0_12g_formatter.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/108c/hdl/verilog/v_vid_sdi_tx_bridge_v2_0_12g.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/108c/hdl/verilog/v_vid_sdi_tx_bridge_v2_0_3g_ce_gen.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/108c/hdl/verilog/v_vid_sdi_tx_bridge_v2_0_3g_converter.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/108c/hdl/verilog/v_vid_sdi_tx_bridge_v2_0_3g_embedder.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/108c/hdl/verilog/v_vid_sdi_tx_bridge_v2_0_3g_fifo.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/108c/hdl/verilog/v_vid_sdi_tx_bridge_v2_0_3g_formatter.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/108c/hdl/verilog/v_vid_sdi_tx_bridge_v2_0_3g.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/108c/hdl/verilog/v_vid_sdi_tx_bridge_v2_0.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_v_smpte_uhdsdi_tx_ss_0_0/bd_0/ip/ip_2/sim/bd_82d8_v_vid_sdi_tx_bridge_0.v" \

vcom -work axi_lite_ipif_v3_0_4 -64 -93 \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/cced/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \

vcom -work v_tc_v6_1_12 -64 -93 \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/6694/hdl/v_tc_v6_1_vh_rfs.vhd" \

vlog -work v_axi4s_vid_out_v4_0_9 -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/9a07/hdl/v_axi4s_vid_out_v4_0_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_v_smpte_uhdsdi_tx_ss_0_0/bd_0/ip/ip_3/sim/bd_82d8_v_axi4s_vid_out_0.v" \

vcom -work xil_defaultlib -64 -93 \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_v_smpte_uhdsdi_tx_ss_0_0/bd_0/ip/ip_4/sim/bd_82d8_v_tc_0.vhd" \

vlog -work xlconstant_v1_1_5 -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/f1c3/hdl/xlconstant_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_v_smpte_uhdsdi_tx_ss_0_0/bd_0/ip/ip_5/sim/bd_82d8_const_1_0.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_v_smpte_uhdsdi_tx_ss_0_0/bd_0/sim/bd_82d8.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_v_smpte_uhdsdi_tx_ss_0_0/sim/vcu_trd_v_smpte_uhdsdi_tx_ss_0_0.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_clk_wiz_0_1/vcu_trd_clk_wiz_0_1_clk_wiz.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_clk_wiz_0_1/vcu_trd_clk_wiz_0_1.v" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_xbar_1/sim/vcu_trd_xbar_1.v" \

vlog -work axi_protocol_converter_v2_1_17 -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ccfb/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/ec67/hdl" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/b65a" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/5bb9/hdl/verilog" "+incdir+../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ipshared/e4d1/hdl" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../vcu_trd.srcs/sources_1/bd/vcu_trd/ip/vcu_trd_auto_pc_6/sim/vcu_trd_auto_pc_6.v" \

vlog -work xil_defaultlib \
"glbl.v"

