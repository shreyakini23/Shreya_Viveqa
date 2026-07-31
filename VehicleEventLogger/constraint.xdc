## Clock
create_clock -period 41.667 -name sys_clk [get_ports clk_24mhz]
set_property -dict {PACKAGE_PIN D13 IOSTANDARD LVCMOS33} [get_ports clk_24mhz]

set_property PACKAGE_PIN D5  [get_ports {led[0]}]
set_property PACKAGE_PIN A3  [get_ports {led[1]}]
set_property PACKAGE_PIN B4  [get_ports {led[2]}]
set_property PACKAGE_PIN A4  [get_ports {led[3]}]
set_property PACKAGE_PIN E6  [get_ports {led[4]}]
set_property PACKAGE_PIN C13 [get_ports {led[5]}]
set_property PACKAGE_PIN C14 [get_ports {led[6]}]
set_property PACKAGE_PIN D14 [get_ports {led[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]
set_property PACKAGE_PIN C9  [get_ports {sw[0]}]
set_property PACKAGE_PIN B9  [get_ports {sw[1]}]
set_property PACKAGE_PIN G5  [get_ports {sw[2]}]
set_property PACKAGE_PIN A7  [get_ports {sw[3]}]
set_property PACKAGE_PIN C7  [get_ports {sw[4]}]
set_property PACKAGE_PIN A10 [get_ports {sw[5]}]
set_property PACKAGE_PIN B7  [get_ports {sw[6]}]
set_property PACKAGE_PIN A8  [get_ports {sw[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {sw[*]}]
## Push button for log dump trigger
## 4x4 Keypad
set_property PACKAGE_PIN A13 [get_ports {keypad[0]}]
set_property PACKAGE_PIN F5  [get_ports {keypad[1]}]
set_property PACKAGE_PIN E3  [get_ports {keypad[2]}]
set_property PACKAGE_PIN F2  [get_ports {keypad[3]}]
set_property PACKAGE_PIN A12 [get_ports {keypad[4]}]
set_property PACKAGE_PIN D6  [get_ports {keypad[5]}]
set_property PACKAGE_PIN D3  [get_ports {keypad[6]}]
set_property PACKAGE_PIN F3  [get_ports {keypad[7]}]
set_property PACKAGE_PIN A5  [get_ports {keypad[8]}]
set_property PACKAGE_PIN C6  [get_ports {keypad[9]}]
set_property PACKAGE_PIN D4  [get_ports {keypad[10]}]
set_property PACKAGE_PIN F4  [get_ports {keypad[11]}]
set_property PACKAGE_PIN B6  [get_ports {keypad[12]}]
set_property PACKAGE_PIN B5  [get_ports {keypad[13]}]
set_property PACKAGE_PIN C4  [get_ports {keypad[14]}]
set_property PACKAGE_PIN E5  [get_ports {keypad[15]}]

set_property IOSTANDARD LVCMOS33 [get_ports {keypad[*]}]

## UART TX output
set_property PACKAGE_PIN T3 [get_ports uart_tx]
set_property IOSTANDARD LVCMOS33 [get_ports uart_tx]
