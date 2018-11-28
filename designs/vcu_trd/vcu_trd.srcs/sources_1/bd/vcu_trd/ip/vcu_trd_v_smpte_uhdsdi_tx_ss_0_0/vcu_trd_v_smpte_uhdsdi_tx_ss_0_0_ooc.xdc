# This constraints file contains default clock frequencies to be used during out-of-context flows such as
# OOC Synthesis and Hierarchical Designs. For best results the frequencies should be modified
# to match the target frequencies.
# This constraints file is not used in normal top-down synthesis.


	create_clock -name s_axi_aclk -period 10 [get_ports s_axi_aclk]



	create_clock -name sdi_tx_clk -period 3.367 [get_ports sdi_tx_clk]
	

		create_clock -name video_in_clk -period 3.333 [get_ports video_in_clk]


