# Устанавливаем порядок компиляции
update_compile_order -fileset sources_1

# Создаем блочный дизайн
create_bd_design "design_1"

# Добавляем ваш модуль в блочный дизайн
create_bd_cell -type module -vlnv xilinx.com:user:tim_TOP:1.0 tim_TOP_0

# Создаем порты блочного дизайна
create_bd_port -dir I -from 31 -to 0 -type data AWADDR
create_bd_port -dir I AWVALID
create_bd_port -dir O AWREADY
create_bd_port -dir I -from 31 -to 0 -type data WDATA
create_bd_port -dir I WVALID
create_bd_port -dir O WREADY
create_bd_port -dir O -from 1 -to 0 BRESP
create_bd_port -dir O BVALID
create_bd_port -dir I BREADY
create_bd_port -dir I -from 31 -to 0 -type data ARADDR
create_bd_port -dir I ARVALID
create_bd_port -dir O ARREADY
create_bd_port -dir O -from 31 -to 0 -type data RDATA
create_bd_port -dir O RVALID
create_bd_port -dir I RREADY
create_bd_port -dir I -type clk clk
create_bd_port -dir I -type rst reset

# Подключаем порты к модулю tim_TOP
connect_bd_net [get_bd_ports clk] [get_bd_pins tim_TOP_0/clk]
connect_bd_net [get_bd_ports reset] [get_bd_pins tim_TOP_0/reset]
connect_bd_net [get_bd_ports AWADDR] [get_bd_pins tim_TOP_0/AWADDR]
connect_bd_net [get_bd_ports AWVALID] [get_bd_pins tim_TOP_0/AWVALID]
connect_bd_net [get_bd_ports AWREADY] [get_bd_pins tim_TOP_0/AWREADY]
connect_bd_net [get_bd_ports WDATA] [get_bd_pins tim_TOP_0/WDATA]
connect_bd_net [get_bd_ports WVALID] [get_bd_pins tim_TOP_0/WVALID]
connect_bd_net [get_bd_ports WREADY] [get_bd_pins tim_TOP_0/WREADY]
connect_bd_net [get_bd_ports BRESP] [get_bd_pins tim_TOP_0/BRESP]
connect_bd_net [get_bd_ports BVALID] [get_bd_pins tim_TOP_0/BVALID]
connect_bd_net [get_bd_ports BREADY] [get_bd_pins tim_TOP_0/BREADY]
connect_bd_net [get_bd_ports ARADDR] [get_bd_pins tim_TOP_0/ARADDR]
connect_bd_net [get_bd_ports ARVALID] [get_bd_pins tim_TOP_0/ARVALID]
connect_bd_net [get_bd_ports ARREADY] [get_bd_pins tim_TOP_0/ARREADY]
connect_bd_net [get_bd_ports RDATA] [get_bd_pins tim_TOP_0/RDATA]
connect_bd_net [get_bd_ports RVALID] [get_bd_pins tim_TOP_0/RVALID]
connect_bd_net [get_bd_ports RREADY] [get_bd_pins tim_TOP_0/RREADY]

# Генерируем обертку
make_wrapper -files [get_files $CURRENT_DIR/design_1/design_1.bd] -top

# Добавляем обертку в проект
add_files -norecurse $CURRENT_DIR/design_1/hdl/design_1_wrapper.vhd

# Обновляем порядок компиляции
update_compile_order -fileset sources_1
