
##############################################
# Setting Max delay
##############################################


set max_delay_rx_clk [expr ([get_property PERIOD [get_clocks -of [get_ports rx_clk]]] -1.0)]
set max_delay_axi_aclk [expr ([get_property PERIOD [get_clocks -of [get_ports s_axi_aclk]]] -1.0)]


set max_delay_axis_clk [expr ([get_property PERIOD [get_clocks -of [get_ports axis_clk]]] -1.0)]

set_max_delay $max_delay_axis_clk -from [get_clocks -of [get_ports s_axi_aclk]] \
    -to [get_clocks -of [get_ports axis_clk]] -datapath_only
	
set_max_delay $max_delay_axis_clk -from [get_clocks -of [get_ports rx_clk]] \
    -to [get_clocks -of [get_ports axis_clk]] -datapath_only  

set_max_delay $max_delay_axi_aclk -from [get_clocks -of [get_ports axis_clk]] \
    -to [get_clocks -of [get_ports s_axi_aclk]] -datapath_only
	
set_max_delay $max_delay_rx_clk -from [get_clocks -of [get_ports axis_clk]] \
    -to [get_clocks -of [get_ports rx_clk]] -datapath_only


set_max_delay $max_delay_rx_clk -from [get_clocks -of [get_ports s_axi_aclk]] \
    -to [get_clocks -of [get_ports rx_clk]] -datapath_only        

set_max_delay $max_delay_axi_aclk -from [get_clocks -of [get_ports rx_clk]] \
    -to [get_clocks -of [get_ports s_axi_aclk]] -datapath_only

