
# False path constraint for synchronizer
set_false_path -to [get_pins -hier *cdc_to*/D]

# Get all the instances of the entity "cross_clk_reg" wherever they are in the hierarchy
set sync_inst [get_cells -hier -filter {(ORIG_REF_NAME == cross_clk_reg) || (REF_NAME == cross_clk_reg)}]
# Set the ASYNC_REG property on all the cells named "data_sync" in the instances identified above
set_property ASYNC_REG TRUE [get_cells [join $sync_inst "/data_sync* "]]
