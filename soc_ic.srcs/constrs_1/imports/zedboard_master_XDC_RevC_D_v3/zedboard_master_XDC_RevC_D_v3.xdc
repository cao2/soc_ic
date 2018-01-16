

set_property PACKAGE_PIN Y9 [get_ports Clock];  # "GCLK"
set_property IOSTANDARD LVCMOS15 [get_ports Clock]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports Clock]


set_property PACKAGE_PIN Y11 [get_ports rx_in]; 
set_property IOSTANDARD LVCMOS15 [get_ports rx_in]


set_property PACKAGE_PIN AA11 [get_ports tx_out];
set_property IOSTANDARD LVCMOS15 [get_ports tx_out]


set_property PACKAGE_PIN P16 [get_ports reset];  # "BTNC"
set_property IOSTANDARD LVCMOS15 [get_ports reset]
