transcript file ""
transcript file simulation.log
transcript on

set RTL_PATH ../rtl
set TB_PATH ../tb
set include_path "+incdir+$RTL_PATH+incdir+$TB_PATH"

vlog -64 -incr -lint -sv  $include_path $RTL_PATH/arbitrated_dual_port_ram.sv
vlog -64 -incr -lint -sv  $include_path $RTL_PATH/axi_switch.sv
vlog -64 -incr -lint -sv  $include_path $RTL_PATH/channel_arbiter.sv
vlog -64 -incr -lint -sv  $include_path $RTL_PATH/master_switch.sv
vlog -64 -incr -lint -sv  $include_path $RTL_PATH/rr_arbiter.sv
vlog -64 -incr -lint -sv  $include_path $RTL_PATH/slave_switch.sv

vlog -64 -incr -lint -sv  $include_path $TB_PATH/tb_axi4_switch.sv

vopt tb_axi4_switch -o opttop +cover
#vsim -vopt -voptargs="+acc" -coverage opttop
vsim -coverage -voptargs="+acc" opttop

#toggle add -r sim:/dut/*

do wave.do

run -all

#toggle report -all
#coverage report -html -htmldir covhtmlreport -assert -directive -cvg -code bcefst -threshL 50 -threshH 90
